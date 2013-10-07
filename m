Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab3JGWii (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 18:38:38 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:49615 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3JGWih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 18:38:37 -0400
MIME-Version: 1.0
In-Reply-To: <87pprgzref.fsf@tassilo.jf.intel.com>
References: <1381162158-24329-1-git-send-email-eranian@google.com>
	<1381162158-24329-2-git-send-email-eranian@google.com>
	<20131007175542.GB3363@tassilo.jf.intel.com>
	<CABPqkBRYCGumFo1JO6VKXUiVpoDdUW61X7cHJeyw3WDu-wxM8Q@mail.gmail.com>
	<87pprgzref.fsf@tassilo.jf.intel.com>
Date: Tue, 8 Oct 2013 00:38:36 +0200
Message-ID: <CABPqkBQpc4L5zEAsPnoTFQa4KogR2JWCSDJ1XVRwnvdRiWXtTA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] perf,x86: add Intel RAPL PMU support
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 7, 2013 at 11:45 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Stephane Eranian <eranian@google.com> writes:
>>
>>>> +             goto again;
>>>> +
>>>> +     struct rapl_pmu *pmu = __get_cpu_var(rapl_pmu);
>>>> +
>>>> +     if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
>>>> +             return;
>>>> +
>>>> +     event->hw.state = 0;
>>>> +
>>>> +     local64_set(&event->hw.prev_count, rapl_read_counter(event));
>>>> +
>>>> +     pmu->n_active++;
>>>
>>> What lock protects this add?
>>>
>> None. I will add one. Bu then I am wondering about if it is really
>> necessary given
>> that RAPL event are system-wide and this pinned to a CPU. If the call came
>> from another CPU, then it IPI there, and that means that CPU is executing that
>> code. Any other CPU will need IPI too, and that interrupt will be kept pending.
>> Am I missing a test case here? Are IPI reentrant?
>
> they can be if interrupts are enabled (likely here)
>
I will check on that.

>>
>>>> +}
>>>> +
>>>> +static ssize_t rapl_get_attr_cpumask(struct device *dev,
>>>> +                             struct device_attribute *attr, char *buf)
>>>> +{
>>>> +     int n = cpulist_scnprintf(buf, PAGE_SIZE - 2, &rapl_cpu_mask);
>>>
>>> Check n here in case it overflowed
>>>
>> But isn't that what the -2 and the below \n\0 are for?
>
> I know it's very unlikely and other stuff would break, but
>
> Assuming you have a system with some many CPUs that they don't fit
> into a page. Then the scnprintf would fail, but you would corrupt
> random data because you write before the buffer.
>
My understanding is that cpulist_scnprintf() behaves like snprintf(). It
generates up to PAGE_SIZE-2 characters in the buffer. So if you
have a very large number of CPUs, the generation of the output string in buf
will stop, i.e., truncated string. The return value is the length of the string.
That n cannot be negative. So how you could write buffer the buffer (buf)?

The part I don't like about the API of rapl_get_attr_cpumask() here is that
it assumes that the buf is PAGE_SIZE. Its size is not passed as an argument.
But maybe this is what you are pointing out to me.

>>> Doesn't this need a lock of some form? AFAIK we can do parallel
>>> CPU startup now.
>>>
>> Did not know about this change? But then that means all the other
>> perf_event *_starting() and maybe even _*prepare() routines must also
>> use locks. I can add that to RAPL.
>
> Yes may be broken everywhere.
>
>>>> +     /* check supported CPU */
>>>> +     switch (boot_cpu_data.x86_model) {
>>>> +     case 42: /* Sandy Bridge */
>>>> +     case 58: /* Ivy Bridge */
>>>> +     case 60: /* Haswell */
>>>
>>> Need more model numbers for Haswell (see the main perf driver)
>>>
>> Don't have all the models to test...
>
> It should be all the same.
>
Need to know which ones are client vs. servers. Not have the same
number of  RAPL events.

Thanks.
