Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756335AbaDPN2c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:28:32 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:43399 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202AbaDPN23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:28:29 -0400
Message-ID: <534E8576.3060907@de.ibm.com>
Date: Wed, 16 Apr 2014 15:28:22 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org, KVM <kvm@vger.kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PULL 1/2] perf/tool: Fix usage of trace events with '-' in trace
 system name.
References: <1397053319-2130-1-git-send-email-borntraeger@de.ibm.com> <1397053319-2130-2-git-send-email-borntraeger@de.ibm.com> <20140416130008.GA6087@krava.brq.redhat.com>
In-Reply-To: <20140416130008.GA6087@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14041613-1948-0000-0000-0000087CE722
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/04/14 15:00, Jiri Olsa wrote:
> On Wed, Apr 09, 2014 at 04:21:58PM +0200, Christian Borntraeger wrote:
>> From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>>
>> Trace events potentially can have a '-' in their trace system name,
>> e.g. kvm on s390 defines kvm-s390:* tracepoints.
>> tools/perf could not parse them, because there was no rule for this:
>> $ sudo ./perf top -e "kvm-s390:*"
>> invalid or unsupported event: 'kvm-s390:*'
>>
>> This patch allows '-' to be a part of PE_NAME token, so tracepoints
>> with '-' can be parsed by the event_legacy_tracepoint rule.
>> Without the patch, perf will not accept such tracepoints in the -e
>> option.
>>
>> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  tools/perf/util/parse-events.l |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
>> index 3432995..ca20da7 100644
>> --- a/tools/perf/util/parse-events.l
>> +++ b/tools/perf/util/parse-events.l
>> @@ -199,7 +199,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
>>  {num_hex}		{ return value(yyscanner, 16); }
>>  
>>  {modifier_event}	{ return str(yyscanner, PE_MODIFIER_EVENT); }
>> -{name}			{ return str(yyscanner, PE_NAME); }
>> +{name_minus}			{ return str(yyscanner, PE_NAME); }
>>  "/"			{ BEGIN(config); return '/'; }
>>  -			{ return '-'; }
>>  ,			{ BEGIN(event); return ','; }
> 
> this breaks parsing of cache events like:
> 
>   $ perf record -e 'L1-dcache-loads' ls
> 
> also test 10 (same issue):
>   $ ./perf test 10
>   10: roundtrip evsel->name check                            : FAILED!
> 
> 
> it might be little tricky to fix, let me know if you
> have any troubles with that, I could look on it

Hmm, so do you prefer tackling this problem directly at  event_legacy_tracepoint, e.g.
like in
https://lkml.org/lkml/2014/3/24/364

Christian


