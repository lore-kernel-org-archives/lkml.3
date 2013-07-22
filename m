Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932978Ab3GVSpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:45:45 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:39870 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab3GVSpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:45:43 -0400
Message-ID: <51ED7DD5.8010000@codeaurora.org>
Date: Mon, 22 Jul 2013 11:45:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 03/17] sched_clock: Use an hrtimer instead of timer
References: <1374189690-10810-1-git-send-email-sboyd@codeaurora.org> <1374189690-10810-4-git-send-email-sboyd@codeaurora.org> <51ED781F.6060300@linaro.org>
In-Reply-To: <51ED781F.6060300@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/13 11:21, John Stultz wrote:
> On 07/18/2013 04:21 PM, Stephen Boyd wrote:
>> In the next patch we're going to increase the number of bits that
>> the generic sched_clock can handle to be greater than 32. With
>> more than 32 bits the wraparound time can be larger than what can
>> fit into the units that msecs_to_jiffies takes (unsigned int).
>> Luckily, the wraparound is initially calculated in nanoseconds
>> which we can easily use with hrtimers, so switch to using an
>> hrtimer.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>
>
> Hrmm. So in my testing (under qemu), this patch causes bootup to hang.
>
> qemu-system-arm -kernel zImage-arm -M vexpress-a9 -cpu cortex-a9
> -nographic -m 1024  -append 'root=/dev/mmcblk0p2 rw mem=1024M
> raid=noautodetect console=ttyAMA0,38400n8 rootwait vmalloc=256MB
> devtmpfs.mount=0' -sd test-arm.img -redir tcp:4300::22
>
> Config file attached.
>
> I haven't gotten a chance to look very closely, but it seems the
> folowing patch resolves the issue. I'm not sure if we're seeing
> callers to setup_sched_clock happen after sched_clock_postinit or
> what, but it probably needs another look over.
>
> thanks
> -john
>
>
> diff --git a/kernel/time/sched_clock.c b/kernel/time/sched_clock.c
> index a269890b..c018ffc 100644
> --- a/kernel/time/sched_clock.c
> +++ b/kernel/time/sched_clock.c
> @@ -138,12 +138,6 @@ void __init setup_sched_clock(u32 (*read)(void),
> int bits, unsigned long rate)
>      pr_info("sched_clock: %u bits at %lu%cHz, resolution %lluns,
> wraps every %lluns\n",
>          bits, r, r_unit, res, wrap);
>  
> -    /*
> -     * Start the timer to keep sched_clock() properly updated and
> -     * sets the initial epoch.
> -     */
> -    hrtimer_init(&sched_clock_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> -    sched_clock_timer.function = sched_clock_poll;
>      update_sched_clock();
>  
>      /*
> @@ -175,6 +169,13 @@ void __init sched_clock_postinit(void)
>          setup_sched_clock(jiffy_sched_clock_read, 32, HZ);
>  
>      update_sched_clock();
> +
> +    /*
> +     * Start the timer to keep sched_clock() properly updated and
> +     * sets the initial epoch.
> +     */
> +    hrtimer_init(&sched_clock_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> +    sched_clock_timer.function = sched_clock_poll;
>      hrtimer_start(&sched_clock_timer, cd.wrap_kt, HRTIMER_MODE_REL);
>  }
>  
>

Hmm. Is it too early to use hrtimers? Moving the hrtimer_start() into
sched_clock_register() also causes the same crash.

[    0.000000] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
[    0.000000] pgd = c0004000
[    0.000000] [00000000] *pgd=00000000
[    0.000000] Internal error: Oops: 5 [#1] SMP ARM
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
3.11.0-rc1-00017-gecfb8ad-dirty #69
[    0.000000] task: c063b600 ti: c0630000 task.ti: c0630000
[    0.000000] PC is at _raw_spin_lock_irqsave+0xc/0x48
[    0.000000] LR is at lock_hrtimer_base+0x20/0x4c
[    0.000000] pc : [<c043b7f8>]    lr : [<c005edb8>]    psr: a00001d3
[    0.000000] sp : c0631f40  ip : 00000001  fp : 00000000
[    0.000000] r10: 00000000  r9 : 410fc090  r8 : c06e44c0
[    0.000000] r7 : c063c508  r6 : c0631f7c  r5 : c06e44c0  r4 : c062e538
[    0.000000] r3 : 00000024  r2 : 00000000  r1 : c0631f7c  r0 : a00001d3
[    0.000000] Flags: NzCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM 
Segment kernel
[    0.000000] Control: 10c5387d  Table: 6000406a  DAC: 00000015
[    0.000000] Process swapper/0 (pid: 0, stack limit = 0xc0630238)
[    0.000000] Stack: (0xc0631f40 to 0xc0632000)
[    0.000000] 1f40: c06be640 c06150a0 c0f05940 c005f344 00000000
00989680 755552dc 00000024
[    0.000000] 1f60: c063cd80 c0441354 755552dc 00000024 00000000
00000000 c063cd80 00000002
[    0.000000] 1f80: c0441354 c06be640 c06150a0 c0f05940 c063c508
6000406a 410fc090 00000000
[    0.000000] 1fa0: 00000000 c005f74c 00000000 00000001 00000001
00000000 00000000 c05e5984
[    0.000000] 1fc0: 00000001 c05c2e38 00000001 c05c06e0 ffffffff
ffffffff c05c02ec 00000000
[    0.000000] 1fe0: 00000000 c06150a0 10c5387d c0638418 c061509c
60008074 00000000 00000000
[    0.000000] [<c043b7f8>] (_raw_spin_lock_irqsave+0xc/0x48) from
[<c005edb8>] (lock_hrtimer_base+0x20/0x4c)
[    0.000000] [<c005edb8>] (lock_hrtimer_base+0x20/0x4c) from
[<c005f344>] (__hrtimer_start_range_ns+0x1c/0x3d8)
[    0.000000] [<c005f344>] (__hrtimer_start_range_ns+0x1c/0x3d8) from
[<c005f74c>] (hrtimer_start+0x20/0x28)
[    0.000000] [<c005f74c>] (hrtimer_start+0x20/0x28) from [<c05e5984>]
(sched_clock_postinit+0x44/0x5c)
[    0.000000] [<c05e5984>] (sched_clock_postinit+0x44/0x5c) from
[<c05c06e0>] (start_kernel+0x1d0/0x31c)
[    0.000000] [<c05c06e0>] (start_kernel+0x1d0/0x31c) from [<60008074>]
(0x60008074)
[    0.000000] Code: e12fff1e e1a02000 e10f0000 f10c0080 (e1923f9f)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

