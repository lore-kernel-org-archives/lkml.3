Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933132Ab3GVV1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:27:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54436 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316Ab3GVV1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:27:49 -0400
Date: Mon, 22 Jul 2013 23:27:46 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
Message-ID: <20130722212746.GE4613@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
 <20130718225349.GD15992@pd.tnic>
 <20130719142628.GC19581@pd.tnic>
 <20130719151321.GD19581@pd.tnic>
 <51ED9D15.3010304@linaro.org>
 <20130722211223.GC4613@pd.tnic>
 <51EDA10D.6040207@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51EDA10D.6040207@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 02:15:57PM -0700, John Stultz wrote:
> On 07/22/2013 02:12 PM, Borislav Petkov wrote:
> >On Mon, Jul 22, 2013 at 01:59:01PM -0700, John Stultz wrote:
> >>So did this work some of the time, but not all? Or was the behavior
> >>totally unchanged with this?
> >Yep, some of the time. The first couple of runs it worked and I was
> >euphoric and then it rebooted and I almost threw the box out the window
> >:-)
> 
> I can understand your frustration. :)
> 
> But its interesting it sort of worked, no?  The bit you discovered
> earlier with the dump_stack debugging call, where we're actually
> disabling the irq twice was interesting.
> 
> If you use the debugging patch with this change, does it show any
> different in logic between the working cases and the instant-reboot
> case?

Ok, I'm kinda confused with so many experiments I did, what we actually
want to try:

Do we want to use the filter thingy:

---
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index be06d7150de5..bb265f1651e7 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -304,6 +304,9 @@ static void cmos_irq_enable(struct cmos_rtc *cmos, unsigned char mask)
        rtc_control = CMOS_READ(RTC_CONTROL);
        cmos_checkintr(cmos, rtc_control);

+       if (rtc_control == mask)
+               return;
+
        rtc_control |= mask;
        CMOS_WRITE(rtc_control, RTC_CONTROL);
        hpet_set_rtc_irq_bit(mask);
@@ -316,6 +319,10 @@ static void cmos_irq_disable(struct cmos_rtc *cmos, unsigned char mask)
        unsigned char   rtc_control;

        rtc_control = CMOS_READ(RTC_CONTROL);
+
+       if (!(rtc_control & mask))
+               return;
+
        rtc_control &= ~mask;
        CMOS_WRITE(rtc_control, RTC_CONTROL);
        hpet_mask_rtc_irq_bit(mask);
--

and also add dump_stack to see what calls cmos_irq_disable?

In the run I had, the first call came from rtc_dev_ioctl so I'm guessing
userspace and the following one was rtc workqueue rtc_timer_do_work.

Just let me know what exactly we want to try and I'll do it tomorrow, on
a clear head and not half asleep now :-)

Good night. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
