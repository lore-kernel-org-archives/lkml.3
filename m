Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3JGVpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:45:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:17210 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab3JGVpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:45:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1051,1371106800"; 
   d="scan'208";a="406852933"
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo\@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan\, Zheng" <zheng.z.yan@intel.com>
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
References: <1381162158-24329-1-git-send-email-eranian@google.com>
	<1381162158-24329-2-git-send-email-eranian@google.com>
	<20131007175542.GB3363@tassilo.jf.intel.com>
	<CABPqkBRYCGumFo1JO6VKXUiVpoDdUW61X7cHJeyw3WDu-wxM8Q@mail.gmail.com>
Date: Mon, 07 Oct 2013 14:45:44 -0700
In-Reply-To: <CABPqkBRYCGumFo1JO6VKXUiVpoDdUW61X7cHJeyw3WDu-wxM8Q@mail.gmail.com>
	(Stephane Eranian's message of "Mon, 7 Oct 2013 22:58:44 +0200")
Message-ID: <87pprgzref.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane Eranian <eranian@google.com> writes:
>
>>> +             goto again;
>>> +
>>> +     struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
>>> +
>>> +     if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
>>> +             return;
>>> +
>>> +     event->hw.state = 0;
>>> +
>>> +     local64_set(&event->hw.prev_count, rapl_read_counter(event));
>>> +
>>> +     pmu->n_active++;
>>
>> What lock protects this add?
>>
> None. I will add one. Bu then I am wondering about if it is really
> necessary given
> that RAPL event are system-wide and this pinned to a CPU. If the call came
> from another CPU, then it IPI there, and that means that CPU is executing that
> code. Any other CPU will need IPI too, and that interrupt will be kept pending.
> Am I missing a test case here? Are IPI reentrant?

they can be if interrupts are enabled (likely here)

>
>>> +}
>>> +
>>> +static ssize_t rapl_get_attr_cpumask(struct device *dev,
>>> +                             struct device_attribute *attr, char *buf)
>>> +{
>>> +     int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &rapl_cpu_mask);
>>
>> Check n here in case it overflowed
>>
> But isn't that what the -2 and the below \n\0 are for?

I know it's very unlikely and other stuff would break, but

Assuming you have a system with some many CPUs that they don't fit 
into a page. Then the scnprintf would fail, but you would corrupt
random data because you write before the buffer.

>> Doesn't this need a lock of some form? AFAIK we can do parallel
>> CPU startup now.
>>
> Did not know about this change? But then that means all the other
> perf_event *_starting() and maybe even _*prepare() routines must also
> use locks. I can add that to RAPL.

Yes may be broken everywhere.

>>> +     /* check supported CPU */
>>> +     switch (boot_cpu_data.x86_model) {
>>> +     case 42: /* Sandy Bridge */
>>> +     case 58: /* Ivy Bridge */
>>> +     case 60: /* Haswell */
>>
>> Need more model numbers for Haswell (see the main perf driver)
>>
> Don't have all the models to test...

It should be all the same.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
