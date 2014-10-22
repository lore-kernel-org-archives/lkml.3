Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753221AbaJVQmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:42:19 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:43381 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751902AbaJVQmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:42:17 -0400
MIME-Version: 1.0
In-Reply-To: <20141022145804.GC15126@krava.brq.redhat.com>
References: <1412872486-2930-1-git-send-email-eranian@google.com>
	<1412872486-2930-12-git-send-email-eranian@google.com>
	<20141022145804.GC15126@krava.brq.redhat.com>
Date: Wed, 22 Oct 2014 18:42:16 +0200
Message-ID: <CABPqkBSNMtBqSnTcos4jBYRZ+9+rQ533v8QdgqzNoztzYVdzLQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/12] perf/x86: make HT bug workaround conditioned on
 HT enabled
From: Stephane Eranian <eranian@google.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Liang, Kan" <kan.liang@intel.com>, Borislav Petkov <bp@alien8.de>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 4:58 PM, Jiri Olsa <jolsa@redhat.com> wrote:
> On Thu, Oct 09, 2014 at 06:34:45PM +0200, Stephane Eranian wrote:
>
> SNIP
>
>> --- a/arch/x86/kernel/cpu/perf_event_intel.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
>> @@ -12,6 +12,7 @@
>>  #include <linux/init.h>
>>  #include <linux/slab.h>
>>  #include <linux/export.h>
>> +#include <linux/watchdog.h>
>>
>>  #include <asm/cpufeature.h>
>>  #include <asm/hardirq.h>
>> @@ -1811,7 +1812,7 @@ intel_start_scheduling(struct cpu_hw_events *cpuc)
>>       /*
>>        * nothing needed if in group validation mode
>>        */
>> -     if (cpuc->is_fake)
>> +     if (cpuc->is_fake || !is_ht_workaround_enabled())
>>               return;
>>       /*
>>        * no exclusion needed
>> @@ -1849,8 +1850,9 @@ intel_stop_scheduling(struct cpu_hw_events *cpuc)
>>       /*
>>        * nothing needed if in group validation mode
>>        */
>> -     if (cpuc->is_fake)
>> +     if (cpuc->is_fake || !is_ht_workaround_enabled())
>>               return;
>
>
> Is it possible to change is_ht_workaround_enabled() result within
> intel_start_scheduling and intel_stop_scheduling time frame? like
> following would happen:
>
>
>   is_ht_workaround_enabled == 1
>
>   intel_start_scheduling -> spin_lock(&excl_cntrs->lock);
>
>   # echo 0 > /sys/devices/cpu/ht_bug_workaround
>
>   is_ht_workaround_enabled == 0
>
>   intel_stop_scheduling -> wont call spin_unlock(&excl_cntrs->lock)
>
>
> for some reason I can't get HT enabled on my HSW server, so I cannot try ;-)
>
Yes, that would be possible!
I can fix this by grabbing the lock in the sysctl handler.
Thanks.
