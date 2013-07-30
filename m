Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757204Ab3G3VM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:12:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:39600 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756301Ab3G3VM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:12:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,781,1367996400"; 
   d="scan'208";a="373655406"
Message-ID: <51F82C2F.6060504@intel.com>
Date: Wed, 31 Jul 2013 00:12:15 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 7/9] perf tools: add support for reading from /proc/kcore
References: <1374760890-30558-1-git-send-email-adrian.hunter@intel.com> <1374760890-30558-8-git-send-email-adrian.hunter@intel.com> <87zjt41x4r.fsf@sejong.aot.lge.com>
In-Reply-To: <87zjt41x4r.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/2013 7:37 a.m., Namhyung Kim wrote:
> Hi,
>
> On Thu, 25 Jul 2013 17:01:28 +0300, Adrian Hunter wrote:
>> In the absence of vmlinux, perf tools uses kallsyms
>> for symbols.  If the user has access, now also map to
>> /proc/kcore.
>>
>> The dso data_type is now set to either
>> DSO_BINARY_TYPE__KCORE or DSO_BINARY_TYPE__GUEST_KCORE
>> as approprite.
>
> [SNIP]
>> +
>> +static bool is_host_buildid_str(const char *str)
>> +{
>> +	u8 host_build_id[BUILD_ID_SIZE];
>> +	char host_build_id_str[BUILD_ID_SIZE * 2 + 1];
>> +
>> +	if (sysfs__read_build_id("/sys/kernel/notes", host_build_id,
>> +				 sizeof(host_build_id)))
>> +		return false;
>> +
>> +	build_id__sprintf(host_build_id, sizeof(host_build_id),
>> +			  host_build_id_str);
>> +
>> +	return !strcmp(str, host_build_id_str);
>> +}
>> +
>> +/*
>> + * If kallsyms is referenced by name then we look for kcore in the same
>> + * directory.  Otherwise we use /proc/kcore but only if the buildid matches the
>> + * host.
>> + */
>> +static bool kcore_filename_from_kallsyms_filename(char *kcore_filename,
>> +						  const char *kallsyms_filename)
>> +{
>> +	char *name;
>> +
>> +	strcpy(kcore_filename, kallsyms_filename);
>> +	name = strrchr(kcore_filename, '/');
>> +	if (!name)
>> +		return false;
>> +
>> +	if (!strcmp(name, "/kallsyms")) {
>> +		strcpy(name, "/kcore");
>> +		return true;
>> +	}
>> +
>> +	if (is_host_buildid_str(name)) {
>
> IIUC the name should start with '/' but build-id is not.  So doesn't it
> always fail?

In fact I realized the whole thing is not necessary. Fixed in V2.

>
> Thanks,
> Namhyung
>
>
>> +		strcpy(kcore_filename, "/proc/kcore");
>> +		return true;
>> +	}
>> +
>> +	return false;
>> +}

