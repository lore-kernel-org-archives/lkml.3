Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaA3Jcx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 04:32:53 -0500
Received: from mga01.intel.com ([192.55.52.88]:33980 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbaA3Jcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 04:32:50 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,748,1384329600"; 
   d="scan'208";a="473142312"
Message-ID: <52EA1CAE.7060801@intel.com>
Date: Thu, 30 Jan 2014 11:34:38 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V2 9/9] perf buildid-cache: Check relocation when checking
 for existing kcore
References: <1391004884-10334-1-git-send-email-adrian.hunter@intel.com> <1391004884-10334-10-git-send-email-adrian.hunter@intel.com> <20140129191454.GG3998@ghostprotocols.net>
In-Reply-To: <20140129191454.GG3998@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/01/14 21:14, Arnaldo Carvalho de Melo wrote:
> Em Wed, Jan 29, 2014 at 04:14:44PM +0200, Adrian Hunter escreveu:
>> perf buildid-cache does not make another
>> copy of kcore if the buildid and modules
>> match an existing copy.  That does not
> 
> Humm, what is the problem? Having the ref reloc symbol we can fix things
> up, no? I.e. just using map->reloc the old kcore copy should be ok to
> use, no need to replace the kcore copy in the cache. Or am I missing
> something?

The current implementation works on the basis that kcore
matches the perf data recorded.  This is just a fix for that.

I am afraid it is that way because it meets my needs.
I did not think of allowing for relocation because I
need to be able to walk the code.  Relocation was one
of the things I was trying to avoid.

For me making a copy of kcore is far superior because
it can be made to have the jump labels mostly the
right way around too. e.g. run a dummy perf record
while making the copy.

> 
> - Arnaldo
> 
>> take into account the possibility that
>> the kernel has been relocated.  Extend
>> the check to check if the reference
>> relocation symbol matches too, otherwise
>> do make a copy.
>>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>>  tools/perf/builtin-buildid-cache.c | 33 +++++++++++++++++++++++++++++----
>>  1 file changed, 29 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
>> index cfede86..b22dbb1 100644
>> --- a/tools/perf/builtin-buildid-cache.c
>> +++ b/tools/perf/builtin-buildid-cache.c
>> @@ -63,11 +63,35 @@ static int build_id_cache__kcore_dir(char *dir, size_t sz)
>>  	return 0;
>>  }
>>  
>> +static bool same_kallsyms_reloc(const char *from_dir, char *to_dir)
>> +{
>> +	char from[PATH_MAX];
>> +	char to[PATH_MAX];
>> +	const char *name;
>> +	u64 addr1 = 0, addr2 = 0;
>> +	int i;
>> +
>> +	scnprintf(from, sizeof(from), "%s/kallsyms", from_dir);
>> +	scnprintf(to, sizeof(to), "%s/kallsyms", to_dir);
>> +
>> +	for (i = 0; (name = ref_reloc_sym_names[i]) != NULL; i++) {
>> +		addr1 = kallsyms__get_function_start(from, name);
>> +		if (addr1)
>> +			break;
>> +	}
>> +
>> +	if (name)
>> +		addr2 = kallsyms__get_function_start(to, name);
>> +
>> +	return addr1 == addr2;
>> +}
>> +
>>  static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
>>  					  size_t to_dir_sz)
>>  {
>>  	char from[PATH_MAX];
>>  	char to[PATH_MAX];
>> +	char to_subdir[PATH_MAX];
>>  	struct dirent *dent;
>>  	int ret = -1;
>>  	DIR *d;
>> @@ -86,10 +110,11 @@ static int build_id_cache__kcore_existing(const char *from_dir, char *to_dir,
>>  			continue;
>>  		scnprintf(to, sizeof(to), "%s/%s/modules", to_dir,
>>  			  dent->d_name);
>> -		if (!compare_proc_modules(from, to)) {
>> -			scnprintf(to, sizeof(to), "%s/%s", to_dir,
>> -				  dent->d_name);
>> -			strlcpy(to_dir, to, to_dir_sz);
>> +		scnprintf(to_subdir, sizeof(to_subdir), "%s/%s",
>> +			  to_dir, dent->d_name);
>> +		if (!compare_proc_modules(from, to) &&
>> +		    same_kallsyms_reloc(from_dir, to_subdir)) {
>> +			strlcpy(to_dir, to_subdir, to_dir_sz);
>>  			ret = 0;
>>  			break;
>>  		}
>> -- 
>> 1.7.11.7
> 
> 

