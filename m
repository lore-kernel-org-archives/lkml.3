Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab3AOAan (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 19:30:43 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:37514 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3AOAak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 19:30:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130114162504.e667a4be.akpm@linux-foundation.org>
References: <1357941108-14138-1-git-send-email-ccross@android.com>
	<20130114154914.6d69eb27.akpm@linux-foundation.org>
	<CAMbhsRR29Zhje9mGtUwHfUsX+eFsggYkVMHPyQ+zgrGUp_rqTQ@mail.gmail.com>
	<20130114162504.e667a4be.akpm@linux-foundation.org>
Date: Mon, 14 Jan 2013 16:30:39 -0800
X-Google-Sender-Auth: Q0w0cipWDjr32Ta04I_-ykOF0Xk
Message-ID: <CAMbhsRRM+60gUTRuYzT5sAgLPP7Fj=T78Z3E_hZVmajY-wqGeQ@mail.gmail.com>
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

On Mon, Jan 14, 2013 at 4:25 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Mon, 14 Jan 2013 16:19:23 -0800
> Colin Cross <ccross@android.com> wrote:
>
>> >> +static void watchdog_check_hardlockup_other_cpu(void)
>> >> +{
>> >> +     unsigned int next_cpu;
>> >> +
>> >> +     /*
>> >> +      * Test for hardlockups every 3 samples.  The sample period is
>> >> +      *  watchdog_thresh * 2 / 5, so 3 samples gets us back to slightly over
>> >> +      *  watchdog_thresh (over by 20%).
>> >> +      */
>> >> +     if (__this_cpu_read(hrtimer_interrupts) % 3 != 0)
>> >> +             return;
>> >
>> > The hardwired interval Seems Wrong.  watchdog_thresh is tunable at runtime.
>> >
>> > The comment could do with some fleshing out.  *why* do we want to test
>> > at an interval "slightly over watchdog_thresh"?  What's going on here?
>>
>> I'll reword it.  We don't want to be slightly over watchdog_thresh,
>> ideally we would be exactly at watchdog_thresh.  However, since this
>> relies on the hrtimer interrupts that are scheduled at watchdog_thresh
>> * 2 / 5, there is no multiple of hrtimer_interrupts that will result
>> in watchdog_thresh.  watchdog_thresh * 2 / 5 * 3 (watchdog_thresh *
>> 1.2) is the closest I can get to testing for a hardlockup once every
>> watchdog_thresh seconds.
>
> It needs more than rewording, doesn't it?  What happens if watchdog_thresh is
> altered at runtime?

I'm not sure what you mean.  If watchdog_thresh changes, the next
hrtimer interrupt on each cpu will move the following hrtimer
interrupt forward by the new watchdog_thresh * 2 / 5.  There may be a
single cycle of watchdog checks at an intermediate period, but nothing
bad should happen.

This code doesn't ever deal with watchdog_thresh directly, it is only
counting hrtimer interrupts.  3 hrtimer interrupts is always a
reasonable approximation of watchdog_thresh.
