Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933973Ab3GRWx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 18:53:57 -0400
Received: from mail.skyhub.de ([78.46.96.112]:37992 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932956Ab3GRWx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 18:53:56 -0400
Date: Fri, 19 Jul 2013 00:53:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
Message-ID: <20130718225349.GD15992@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51E8194E.1030704@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey John,

On Thu, Jul 18, 2013 at 09:35:26AM -0700, John Stultz wrote:
> So first of all, thanks for digging in and generating a patch here!
> This issue has been on my list, but I've not been able to reproduce

So you know about it! This is one nasty deal, I tell ya :)

> it and have just not had the time to chase it down remotely, so I
> really appreciate your efforts here!

Thanks.

Btw I have a box here which has the issue so if you want to test
patches, send them on.

> >where, when wakeup alarm is enabled in the BIOS, the machine reboots
> >automatically right after shutdown, regardless of what wakeup time is
> >programmed.
> 
> So this doesn't quite make sense, since the wakeup alarm is being
> disabled on shutdown (and this patch is allowing the alarm interrupt
> to be left enabled).

This is exactly why it is nasty - it doesn't make any sense. And I even
dumped the RTC accesses to see what actually goes to the registers:

These are the last writes which happen when the machine boots up - I
have no accesses when it goes down (dump stack I added to see how we're
getting called):

[   14.810074] cmos_irq_disable: entry, rtc_control: 0x2, mask: 0x20
[   14.810077] Pid: 725, comm: hwclock Tainted: G           N  3.0.84-0.11-pae+ #5
[   14.810078] Call Trace:
[   14.810085]  [<c02052f9>] try_stack_unwind+0x199/0x1b0
[   14.810089]  [<c0204117>] dump_trace+0x47/0xf0
[   14.810092]  [<c020535b>] show_trace_log_lvl+0x4b/0x60
[   14.810094]  [<c0205388>] show_trace+0x18/0x20
[   14.810097]  [<c061f7c6>] dump_stack+0x6d/0x72
[   14.810102]  [<f7c23118>] cmos_irq_disable+0x58/0xd0 [rtc_cmos]
[   14.810106]  [<f7c232b1>] cmos_alarm_irq_enable+0x51/0x90 [rtc_cmos]
[   14.810110]  [<c054281f>] rtc_timer_remove+0xff/0x110
[   14.810114]  [<c0542935>] rtc_update_irq_enable+0x105/0x110
[   14.810118]  [<c0543d1f>] rtc_dev_ioctl+0x46f/0x480
[   14.810123]  [<c032ec9f>] do_vfs_ioctl+0x7f/0x590
[   14.810127]  [<c032f21a>] sys_ioctl+0x6a/0x80
[   14.810129]  [<c0630c18>] sysenter_do_call+0x12/0x28
[   14.810139]  [<ffffe424>] 0xffffe423
[   14.810140] cmos_irq_disable: will write rtc_control: 0x2, mask: 0x20
[   14.810141] rtc_cmos_write: addr: 0xb, val: 0x2
[   14.810148] rtc_cmos_read: addr: 0xc, val: 0x40
[   14.810152] rtc_cmos_read: addr: 0xb, val: 0x2
[   14.810153] cmos_irq_disable: end, rtc_control: 0x2, mask: 0x20
[   14.810162] rtc_cmos_read: addr: 0xa, val: 0x26
[   14.810166] rtc_cmos_read: addr: 0x0, val: 0x34
[   14.810170] rtc_cmos_read: addr: 0x2, val: 0x56
[   14.810174] rtc_cmos_read: addr: 0x4, val: 0x14
[   14.810178] rtc_cmos_read: addr: 0x7, val: 0x11
[   14.810182] rtc_cmos_read: addr: 0x8, val: 0x7
[   14.810186] rtc_cmos_read: addr: 0x9, val: 0x13
[   14.810190] rtc_cmos_read: addr: 0xb, val: 0x2
[   14.902374] rtc_cmos_read: addr: 0xa, val: 0x26
[   14.989200] rtc_cmos_read: addr: 0x0, val: 0x34
[   14.994258] rtc_cmos_read: addr: 0x2, val: 0x56
[   14.999316] rtc_cmos_read: addr: 0x4, val: 0x14
[   15.004378] rtc_cmos_read: addr: 0x7, val: 0x11
[   15.009442] rtc_cmos_read: addr: 0x8, val: 0x7
[   15.014417] rtc_cmos_read: addr: 0x9, val: 0x13
[   15.019480] rtc_cmos_read: addr: 0xb, val: 0x2
[   15.024474] rtc_cmos 00:06: entry, enabled: 0
[   15.029391] rtc_cmos_read: addr: 0xb, val: 0x2
[   15.034383] cmos_irq_disable: entry, rtc_control: 0x2, mask: 0x20
[   15.041039] Pid: 11, comm: kworker/0:1 Tainted: G           N  3.0.84-0.11-pae+ #5
[   15.049183] Call Trace:
[   15.052217]  [<c02052f9>] try_stack_unwind+0x199/0x1b0
[   15.057947]  [<c0204117>] dump_trace+0x47/0xf0
[   15.062982]  [<c020535b>] show_trace_log_lvl+0x4b/0x60
[   15.068713]  [<c0205388>] show_trace+0x18/0x20
[   15.073751]  [<c061f7c6>] dump_stack+0x6d/0x72
[   15.078779]  [<f7c23118>] cmos_irq_disable+0x58/0xd0 [rtc_cmos]
[   15.085280]  [<f7c232b1>] cmos_alarm_irq_enable+0x51/0x90 [rtc_cmos]
[   15.092206]  [<c05435a3>] rtc_timer_do_work+0x203/0x210
[   15.098011]  [<c0263c6f>] process_one_work+0xff/0x370
[   15.103645]  [<c02657c1>] worker_thread+0xf1/0x280
[   15.109020]  [<c02691da>] kthread+0x6a/0x80
[   15.113789]  [<c0631226>] kernel_thread_helper+0x6/0x10
[   15.119596] cmos_irq_disable: will write rtc_control: 0x2, mask: 0x20
[   15.126634] rtc_cmos_write: addr: 0xb, val: 0x2
[   15.131761] rtc_cmos_read: addr: 0xc, val: 0x40
[   15.136885] rtc_cmos_read: addr: 0xb, val: 0x2
[   15.141909] cmos_irq_disable: end, rtc_control: 0x2, mask: 0x20

So, at the end, register 0xb, bit 5, i.e. the alarm interrupt is
cleared.

> I assumed it was some sort of BIOS issue where any modification of the
> RTC_AIE bit caused the alarm irq line to be left high(or something
> like that) that triggered the immediate power-on on shutdown. But I've
> not been able to dig down on this.

Ha, this actually fits like an ass on a bucket (don't ask - German
proverb :-)).

If what you're saying is actually the case, then this explains why not
writing to 0xb doesn't cause the alarm irq to fire.

Btw, in the trace above we do the disabling twice. Once from
rtc_timer_remove() and then again from rtc_timer_do_work().

So, if we disable it once and we touch RTC_AIE again causing the second
time to rearm the alarm irq, this would explain the issue. Which reminds
me:

Maybe we should read out the alarm interrupt first and disable it only
if it is enabled - that would save us the modification of RTC_AIE. Cool,
I'll try that tomorrow.

> So while I do want to make sure we resolve this issue for the
> affected users, I would like to better understand exactly what is
> wrong in the BIOS that causes this.

Yep.

> >Bisecting the issue lead to this patch so disable its functionality with
> >a DMI quirk only for those boxes.
> So from the one bug above I could read, it looks like the RTC wakeup
> alarm functionality is also disabled with this patch, no? Might want
> to document that clearly, so we understand the known side-effects of
> applying this. It might also be interesting to see if much older
> kernels (pre 2.6.38 - before the RTC rework landed) have this
> functionality issue as well. I suspect there has to be some way to
> make the hardware work properly.

Well, this patch simply saves us the alarm irq disabling which
41c7f7424259f brought in. Apparently, not writing to 0xb doesn't cause
the reboot.

One other thing I was able to observe was that if I set the alarm with
rtcwake, say:

rtcwake -s 300

It doesn't reboot either but it remains off. But then it doesn't wake up
after 300 seconds either.

> >+static const struct dmi_system_id rtc_quirks[] __initconst = {
> >+	/* https://bugzilla.novell.com/show_bug.cgi?id=805740 */
> Any chance that bugzilla bug can be made public (it apparently
> requires a login to read, where as the other bug doesn't).

Let me ask around - some bugzillas are special. :) If I can't do it,
I'll add the opensuse one.

> 
> 
> >+	{
> >+		.callback = clear_disable_alarm,
> >+		.ident    = "IBM Truman",
> 
> "IBM Truman"?

It's an IBM box with Toshiba BIOS. Don't ask :)

> 
> >+		.matches  = {
> >+			DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
> >+			DMI_MATCH(DMI_PRODUCT_NAME, "4852570"),
> >+		},
> >+	},
> >+	{}
> >+};
> >+
> 
> Also, this seems to only address one of the systems you described.
> Do we need a second quirk entry as well?

Just got the DMI strings from the second user - I'll add them tomorrow.

> >  static void rtc_device_release(struct device *dev)
> >  {
> >  	struct rtc_device *rtc = to_rtc_device(dev);
> >@@ -340,6 +361,9 @@ static int __init rtc_init(void)
> >  	rtc_class->pm = RTC_CLASS_DEV_PM_OPS;
> >  	rtc_dev_init();
> >  	rtc_sysfs_init(rtc_class);
> >+
> >+	dmi_check_system(rtc_quirks);
> >+
> 
> Since this issue so far only affects x86 systems, would it be
> smarter to move the dmi quirk to the actual RTC driver in
> drivers/rtc/rtc-cmos.c rather then leaving it in the RTC core?

Sure, let me try that.

> >@@ -787,6 +792,9 @@ static void rtc_alarm_disable(struct rtc_device *rtc)
> >  	if (!rtc->ops || !rtc->ops->alarm_irq_enable)
> >  		return;
> >+	if (!rtc_disable_alarm)
> >+		return;
> >+
> >  	rtc->ops->alarm_irq_enable(rtc->dev.parent, false);
> 
> I suspect the same logic could be better applied in cmos_alarm_irq_enable().

I need to test that.

I also want to try to see whether needless modification of RTC_AIE fixes
the issue. I'll do that tomorrow on a clear head.

> thanks again!

I thank you for looking into this - I appreciate the guidance!

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
