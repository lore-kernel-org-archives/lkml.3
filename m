Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaLGXrN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 18:47:13 -0500
Received: from gloria.sntech.de ([95.129.55.99]:40416 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaLGXrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 18:47:11 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Kevin Hilman <khilman@kernel.org>, Chris Zhong <zyw@rock-chips.com>
Cc: Doug Anderson <dianders@chromium.org>,
        Mike Turquette <mturquette@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>, Tony Xie <xxx@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v10 0/4] This suspend patch is only support cut off the power of cpu and some external
Date: Mon, 08 Dec 2014 00:46:47 +0100
Message-ID: <2362255.5fGiDIoeyd@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <7hiohszgep.fsf@deeprootsystems.com>
References: <1417423940-1669-1-git-send-email-zyw@rock-chips.com> <547F1639.3030102@rock-chips.com> <7hiohszgep.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Mittwoch, 3. Dezember 2014, 11:23:26 schrieb Kevin Hilman:
> Chris Zhong <zyw@rock-chips.com> writes:
> 
> [...]
> 
> > I have test these patches on evb board base on next-20141128 with a
> > defconfig[0], and with u-boot[1].
> > As Doug said, we need below 3 patches for resume.
> > 
> > 1.https://patchwork.kernel.org/patch/5051881/  - clocksource:
> >    arch_timer: Allow the device tree to specify uninitialized timer
> >    registers
> > 
> > 2.https://patchwork.kernel.org/patch/5363671/  - clocksource:
> >    arch_timer: Fix code to use physical timers when requested
> > 
> > 3.https://patchwork.kernel.org/patch/5382141/  - ARM: dts: rk3288: add
> > 
> >    arm,cpu-registers-not-fw-configured
> > 
> > And it will auto wakeup, as Heiko said in v8.
> 
> OK, with your series plus those 3 patches on top of next-20141128, I'm
> now seeing it auto-wakeup, either with multi_v7_defconfig or Heiko's
> rk3288_defconfig.
> 
> > But I have never notice before, since the u-boot never enable edp, and
> > I use the coreboot with edp display.  Actually it is a bug in rk3288,
> > the rk3288 have not 27Mhz clock source, but the edp initially set to
> > this non-existent clock. At this time, edp is working on a unknown
> > state, and it always bring a interrupt, this interrupt avoid system
> > enter suspend.
> 
> I see, good find!

I think the "problem" might be a different one.

With Chris' short patch [0] enabling a bit of gic debug output on resume I was
able to track down where my wakeup comes from and it seems to be the
sdmmc_detect_n interrupt. When I have a sd card inserted it wakes up again
directly and when I remove it it stays asleep till I wake it with the power-
button.

Relevant output would be:
	gic_cpu_restore add = f0000000, 0, 0, 0, 0, 8

I have verified that at least for me the sclk_edp_24m has no influence on this,
by using an uboot that does not reparent the edp clock (it stays an orphan)
and an uboot that reparents it to xin24m.

In both cases the system wakes up directly when I have a sd card in the slot
and stays asleep (till pressing the power-key) when I remove the card.

So the auto-wakeup is not the fault of the new suspend-code, but we should
find a way to tame sdmmc_detect_n :-)


Now I only need to check why I get a
	rk3288_suspend_finish: Suspend finish failed
on every resume [1], but that is something for tomorrow.


Heiko


[0]
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index d617ee5..37d5ce0 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -538,6 +538,7 @@ static void gic_cpu_restore(unsigned int gic_nr)
 	u32 *ptr;
 	void __iomem *dist_base;
 	void __iomem *cpu_base;
+	u32 reg[5];
 
 	if (gic_nr >= MAX_GIC_NR)
 		BUG();
@@ -562,6 +563,10 @@ static void gic_cpu_restore(unsigned int gic_nr)
 
 	writel_relaxed(GICC_INT_PRI_THRESHOLD, cpu_base + GIC_CPU_PRIMASK);
 	gic_cpu_if_up();
+
+	for (i = 0; i < 5; i++)
+		reg[i] = readl_relaxed(dist_base + 0x200 + i * 4);
+	printk("%s add = %x, %x, %x, %x, %x, %x\n",__func__, dist_base, reg[0], reg[1], reg[2], reg[3], reg[4]);
 }
 
 static int gic_notifier(struct notifier_block *self, unsigned long cmd,	void *v)

[1]
Disabling non-boot CPUs ...
CPU1: shutdown
CPU2: shutdown
CPU3: shutdown
gic_cpu_restore add = f0000000, 0, 0, 0, 20000, 0
Enabling non-boot CPUs ...
CPU1 is up
CPU2 is up
CPU3 is up
PM: noirq resume of devices complete after 0.892 msecs
PM: early resume of devices complete after 0.991 msecs
rk3288_suspend_finish: Suspend finish failed
PM: resume of devices complete after 2.496 msecs

