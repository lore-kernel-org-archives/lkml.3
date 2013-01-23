Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3AWCjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:39:04 -0500
Received: from mail-vc0-f177.google.com ([209.85.220.177]:50990 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899Ab3AWCjA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:39:00 -0500
MIME-Version: 1.0
In-Reply-To: <CAMbhsRRM+60gUTRuYzT5sAgLPP7Fj=T78Z3E_hZVmajY-wqGeQ@mail.gmail.com>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<20130114154914.6d69eb27.akpm@linux-foundation.org>
	<CAMbhsRR29Zhje9mGtUwHfUsX+eFsggYkVMHPyQ+zgrGUp_rqTQ@mail.gmail.com>
	<20130114162504.e667a4be.akpm@linux-foundation.org>
	<CAMbhsRRM+60gUTRuYzT5sAgLPP7Fj=T78Z3E_hZVmajY-wqGeQ@mail.gmail.com>
Date: Tue, 22 Jan 2013 18:38:59 -0800
X-Google-Sender-Auth: 5Uuiq7KQKu621nOZ4A2lOQg1CgM
Message-ID: <CAMbhsRTDSJaQd4JKfo8KoaUsBaa5pQkpqh7JpH6jkOP4QFojhA@mail.gmail.com>
Subject: Re: [PATCH v2] hardlockup: detect hard lockups without NMIs using
 secondary cpus
From: Colin Cross <ccross@android.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        liu chuansheng <chuansheng.liu@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 4:30 PM, Colin Cross <ccross@android.com> wrote:
> On Mon, Jan 14, 2013 at 4:25 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Mon, 14 Jan 2013 16:19:23 -0800
>> Colin Cross <ccross@android.com> wrote:
>>
>>> >> +static void watchdog_check_hardlockup_other_cpu(void)
>>> >> +{
>>> >> +     unsigned int next_cpu;
>>> >> +
>>> >> +     /*
>>> >> +      * Test for hardlockups every 3 samples.  The sample period is
>>> >> +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
>>> >> +      *  watchdog_thresh (over by 20%).
>>> >> +      */
>>> >> +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
>>> >> +             return;
>>> >
>>> > The hardwired interval Seems Wrong.  watchdog_thresh is tunable at runtime.
>>> >
>>> > The comment could do with some fleshing out.  *why* do we want to test
>>> > at an interval "slightly over watchdog_thresh"?  What's going on here?
>>>
>>> I'll reword it.  We don't want to be slightly over watchdog_thresh,
>>> ideally we would be exactly at watchdog_thresh.  However, since this
>>> relies on the hrtimer interrupts that are scheduled at watchdog_thresh
>>> * 2 / 5, there is no multiple of hrtimer_interrupts that will result
>>> in watchdog_thresh.  watchdog_thresh * 2 / 5 * 3 (watchdog_thresh *
>>> 1.2) is the closest I can get to testing for a hardlockup once every
>>> watchdog_thresh seconds.
>>
>> It needs more than rewording, doesn't it?  What happens if watchdog_thresh is
>> altered at runtime?
>
> I'm not sure what you mean.  If watchdog_thresh changes, the next
> hrtimer interrupt on each cpu will move the following hrtimer
> interrupt forward by the new watchdog_thresh * 2 / 5.  There may be a
> single cycle of watchdog checks at an intermediate period, but nothing
> bad should happen.
>
> This code doesn't ever deal with watchdog_thresh directly, it is only
> counting hrtimer interrupts.  3 hrtimer interrupts is always a
> reasonable approximation of watchdog_thresh.

I think I see the race you were referring to.  When the hrtimer
interrupt fires on the first cpu after changing the watchdog thresh,
it will see the new value and starting firing the timer at the new
rate.  The other cpus may not see the new value for as long as the old
sample period.  If the new threshold is more than 3 times lower than
the old value, one cpu could easily get 3 hrtimer interrupts while
another cpu doesn't get any, triggering the lockup detector.

The exact same issue is already present in the existing NMI detector,
which is conceptually very similar to this one.  It has two
asynchronous timers, the NMI perf counter and the hrtimer.  If one
timer sees the new threshold before the other their relative rates
will be wrong and the lockup detector may fire.  Setting
watchdog_nmi_touch is not good enough, as one interrupt could fire
enough to trigger the hardlockup detector twice.  The only fix I can
think of is to set a timestamp far enough in the future to catch all
the ordering problems, and ignore lockups until sched_clock() is
higher than the timestamp.  I think it would need to be a delay of
twice the larger of the old and new watchdog_thresh values.

But its worse than that, the NMI perf counter is never updated when
watchdog_thresh changes, so raising watchdog_thresh more than 2.5x may
trigger the NMI detector.

I'll send a separate patch for the first problem, but I don't have
anything to test resetting the NMI counter on so I'll leave that issue
for someone else.
