Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaH1QrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 12:47:00 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:14550 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaH1Qq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 12:46:56 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+q+Bf0htXouCs9SdHwWohX
Date: Thu, 28 Aug 2014 09:46:46 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Message-ID: <20140828164645.GG16006@atomide.com>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-16-git-send-email-bigeasy@linutronix.de>
 <20140815210211.GD9239@atomide.com>
 <53F5AF0D.5060409@linutronix.de>
 <20140821184416.GF10066@atomide.com>
 <53FE3779.5090908@linutronix.de>
 <20140827202313.GF16006@atomide.com>
 <20140828082348.GA5413@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828082348.GA5413@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140828 01:24]:
> * Tony Lindgren | 2014-08-27 13:23:14 [-0700]:
> >
> >Do you mean just the OMAP_UART_SCR_DMAMODE_CTL related code, or
> >also the dmaengine calls?
> 
> dmaengine calls are unused because up.dma is not assigned. It is 
> basically like you wouldn't have the dma properties in the devicetree.
> And while in that non-DMA mode I just set and unset the DMAMODE_CTL + 
> DMAMODE_1 bits in the SCR register. Nothing else. Based on some testing
> I just did, DMAMODE_CTL does not make the difference. DMAMODE_CTL +
> DMAMODE_1 does.

OK
 
> >> However core-off with DMA won't work. I think we could document this in
> >> the binding document. What do you think?
> >
> >There should not be such a limitation though. Maybe dump out the values
> >of cm_idlest_per and cm_idlest1_core for working and failing off idle
> >cases and see what the difference is?
> 
> I can't follow here. This is the working case:
...
 
> so per_pwrdm and core_pwrdm remain on and I guess the former is where
> the UART sits.

That won't show the cm_idlest_per and cm_idlest1_core currently though.

Below is a test patch that allows you to dump those too. Then you
can see which bits show up as blockers. Sounds like it will be the
serial port with dma enabled based on your description.
 
> >It could be the either the dma or the uart hardware blocking. I guess
> >it could be also an issue with runtime pm use somewhere.
> 
> So I just toggle the two DMA bits in SCR and the UART seems to block
> since the DMA hw is not involved. Reading SCR back says that those bits
> are not set.

Oh that's interesting.

> To use DMA you don't have to enable it in SCR register you can also use
> the FCR register. The manual says that you can only write this DMA
> enable bit in the FCR register if the baud clock is not running. And
> guess what: same thing: I only *toggle* the DMA enable bit here (it
> remains 0 later) and the core won't hit idle.
> Same effect if I toggle this bit while the baud clock is running (the
> manual says that this bit can only be written if the baud clock is not
> running). Seems like the UART is following its own specification and it
> remains blocking once the DMA was enabled.
> It would be nice if someone from the UART-IP team could ACK this.

Sounds like there should be some way to clear that state.. I wonder
if omap-serial.c had something before it's DMA support was removed?

I'd assume when the UART is powered down by runtime PM it's state
is completetely reset and we could restore the non-DMA state?

Maybe post your current patches and a test patch to try to toggle
the DMA on and off?

> Bah. Does it make sense to use runtime-PM if we can't hit core-off? I'm
> thinking to add a printk once dma is enabled says that runtime-pm is
> switched off.

Well if we can't find a way to unset the DMA registers in the UART,
how about only enable it if a kernel cmdline option is specified?

We do have runtime PM working without it, and the serial console
super important for any kind of debugging no matter what idle
mode the SoC hits.. So let's not break that.

Regards,

Tony

8<-----------------
From: Tony Lindgren <tony@atomide.com>
Date: Tue, 26 Aug 2014 14:25:33 -0700
Subject: [PATCH] Test patch for dumping omap3 off idle blocking bits

Allows seeing the deeper idle state blockers in
/sys/kernel/debug/pm_debug/count. For example, when
off idle is working on beaglboard xm, this is what
i see:

# sleep 5; cat /sys/kernel/debug/pm_debug/count
...
0006ffff 48005020 (fa005020) cm_idlest_per blocking bits: 00010000
e7ffffbd 48004a20 (fa004a20) cm_idlest1_core blocking bits: 00000042
0000000d 48004a28 (fa004a28) cm_idlest3_core

--- a/arch/arm/mach-omap2/pm-debug.c
+++ b/arch/arm/mach-omap2/pm-debug.c
@@ -142,10 +142,76 @@ static int pwrdm_dbg_show_timer(struct powerdomain *pwrdm, void *user)
 	return 0;
 }
 
+#include "iomap.h"
+
+struct dregs {
+	const char	*desc;
+	u32		phys;
+	void __iomem	*virt;
+	u32		mask;
+};
+
+#define PER_CM_BASE	0x48005000
+#define PER_CM_REG(name, offset, mask)				\
+	{ name, PER_CM_BASE + offset,				\
+	OMAP2_L4_IO_ADDRESS(PER_CM_BASE + offset), mask, }
+
+static struct dregs cm_per[] = {
+	PER_CM_REG("cm_idlest_per", 0x20, 0xfff80000), /* p 513 */
+	{ NULL, },
+};
+
+#define CORE_CM_BASE	0x48004a00
+#define CORE_CM_REG(name, offset, mask)				\
+	{ name, CORE_CM_BASE + offset,				\
+	OMAP2_L4_IO_ADDRESS(CORE_CM_BASE + offset), mask, }
+
+static struct dregs cm_core[] = {
+	CORE_CM_REG("cm_idlest1_core", 0x20, 0x9c800109), /* p 467 */
+	CORE_CM_REG("cm_idlest3_core", 0x28, 0xfffffffb),
+	{ NULL, },
+};
+
+void __dregs_dump(struct dregs *dregs, struct seq_file *s)
+{
+	for (; dregs->desc; dregs++) {
+		u32 val, blockers;
+
+		val = __raw_readl(dregs->virt);
+
+		seq_printf(s, "%08x %08x (%p) %s",
+			   val, dregs->phys, dregs->virt,
+			   dregs->desc);
+
+		if (dregs->mask) {
+			blockers = ~val;
+			blockers &= ~dregs->mask;
+
+			if (blockers)
+				seq_printf(s, " blocking bits: %08x",
+					   blockers);
+		}
+
+		seq_printf(s, "\n");
+	}
+}
+
+void cm_per_dump(struct seq_file *s)
+{
+	__dregs_dump(cm_per, s);
+}
+
+void cm_core_dump(struct seq_file *s)
+{
+	__dregs_dump(cm_core, s);
+}
+
 static int pm_dbg_show_counters(struct seq_file *s, void *unused)
 {
 	pwrdm_for_each(pwrdm_dbg_show_counter, s);
 	clkdm_for_each(clkdm_dbg_show_counter, s);
+	cm_per_dump(s);
+	cm_core_dump(s);
 
 	return 0;
 }
