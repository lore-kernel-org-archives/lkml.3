Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab3JHIGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:06:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:39507 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727Ab3JHIGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1055,1371106800"; 
   d="scan'208";a="389442521"
Message-ID: <5253BCD1.6080606@intel.com>
Date: Tue, 08 Oct 2013 11:05:37 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH V4 8/9] perf buildid-cache: add ability to add kcore to
 the cache
References: <1381128618-22721-1-git-send-email-adrian.hunter@intel.com> <1381128618-22721-9-git-send-email-adrian.hunter@intel.com> <87k3hoky4x.fsf@sejong.aot.lge.com>
In-Reply-To: <87k3hoky4x.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/13 10:41, Namhyung Kim wrote:
> On Mon,  7 Oct 2013 09:50:17 +0300, Adrian Hunter wrote:
>> kcore can be used to view the running kernel object code.
>> However, kcore changes as modules are loaded and unloaded,
>> and when the kernel decides to modify its own code.
>> Consequently it is useful to create a copy of kcore at a
>> particular time.  Unlike vmlinux, kcore is not unique
>> for a given build-id.  And in addition, the kallsyms
>> and modules files are also needed.  The tool therefore
>> creates a directory:
>>
>> 	~/.debug/[kernel.kcore]/<build-id>/<YYYYmmddHHMMSShh>
>>
>> which contains: kcore, kallsyms and modules.
> 
> Hmm..  I think the problem is that the kallsyms and kcore also have
> module information and the build-id of kernel can identify the core
> kernel part only.  So why not splitting modules from kcore and kallsyms?
> 
> As the modules have their own build-id, we can extract module info from
> kcore and kallsyms and put them under ~/.debug/[module]/<build-id>.
> While at it, we can even synthesize symbol table and inject it into the
> module kcore and get rid of the module kallsyms file.
> 
> This way, we can identify all binaries using build-id only, no?

No.

kcore doesn't just give the module object code - it gives it
linked in to the kernel.  Unless you have the modules at the same
addresses the linking doesn't match what you traced.

> 
>>
>> Note that the copied kcore contains only code sections.
>> See the kcore_copy() function for how that is determined.
>>
>> The tool will not make additional copies of kcore if there
>> is already one with the same modules at the same addresses.
>>
>> Currently, perf tools will not look for kcore in the cache.
>> That is addressed in another patch.
>>
> [SNIP]
> 
>> +static int build_id_cache__kcore_buildid(const char *proc_dir, char *sbuildid)
>> +{
>> +	char root_dir[PATH_MAX];
>> +	char notes[PATH_MAX];
>> +	u8 build_id[BUILD_ID_SIZE];
>> +	char *p;
>> +
>> +	strlcpy(root_dir, proc_dir, sizeof(root_dir));
>> +
>> +	p = strrchr(root_dir, '/');
>> +	if (!p)
>> +		return -1;
>> +	*p = '\0';
>> +
>> +	snprintf(notes, sizeof(notes), "%s/sys/kernel/notes", root_dir);
> 
> Please use scnprintf() rather than snprintf().  I can see them in other
> places (and on other patches) too.

OK

> 
> Thanks,
> Namhyung
> 
>> +
>> +	if (sysfs__read_build_id(notes, build_id, sizeof(build_id)))
>> +		return -1;
>> +
>> +	build_id__sprintf(build_id, sizeof(build_id), sbuildid);
>> +
>> +	return 0;
>> +}
> 
> 

