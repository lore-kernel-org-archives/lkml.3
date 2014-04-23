Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaDWLM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 07:12:56 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44947 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbaDWLMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 07:12:50 -0400
Message-ID: <5357A02B.8030404@de.ibm.com>
Date: Wed, 23 Apr 2014 13:12:43 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: Re: [PATCH] perf/tool: Fix usage of trace events with '-' in trace
 system name.
References: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com> <20140417144019.GF7422@krava.brq.redhat.com>
In-Reply-To: <20140417144019.GF7422@krava.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042311-2966-0000-0000-00000B0611B2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/14 16:40, Jiri Olsa wrote:
> On Mon, Mar 24, 2014 at 09:49:00PM +0100, Christian Borntraeger wrote:
>> From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>>
>> Trace events potentially can have a '-' in their trace system name,
>> e.g. kvm on s390 defines kvm-s390:* tracepoints.
>> tools/perf could not parse them, because there was no rule for this:
>> $ sudo ./perf top -e "kvm-s390:*"
>> invalid or unsupported event: 'kvm-s390:*'
>>
>> This patch adds an extra rule to event_legacy_tracepoint which handles
>> those cases. Without the patch, perf will not accept such tracepoints in
>> the -e option.
>>
>> Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
>> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
>> ---
>>  tools/perf/util/parse-events.y | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
>> index 4eb67ec..dbbb01c 100644
>> --- a/tools/perf/util/parse-events.y
>> +++ b/tools/perf/util/parse-events.y
>> @@ -299,6 +299,18 @@ PE_PREFIX_MEM PE_VALUE sep_dc
>>  }
>>  
>>  event_legacy_tracepoint:
>> +PE_NAME '-' PE_NAME ':' PE_NAME
>> +{
>> +	struct parse_events_evlist *data = _data;
>> +	struct list_head *list;
>> +	char sys_name[strlen($1) + strlen($3) + 2];
> 
> hum, could you limit the size of sys_name array with some
> sane value? those strlens make me nervous :-\

Right. Something like
char sys_name[128];
[...]

snprintf(&sys_name, 128, "%s-%s", $1, $3);

should be enough for all trace event names. And if not, the event should simply fail.

Alexander,

can you send an updates patch?

