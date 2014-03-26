Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbaCZUG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 16:06:27 -0400
Received: from siggy.segv.de ([78.46.139.7]:49887 "EHLO siggy.segv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbaCZUGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 16:06:25 -0400
Date: Wed, 26 Mar 2014 21:06:21 +0100
From: Alexander Elbs <alex@segv.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        bonbons@linux-vserver.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: mvsdio: unhandled interrupt, mmc writes queuing up
Message-ID: <20140326200621.GL29769@segv.de>
References: <20140325192759.GJ29769@segv.de>
 <53320055.9080307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53320055.9080307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 11:16:53PM +0100, Sebastian Hesselbarth wrote:
> > $ git bisect view --oneline
> > 2326f04 (refs/bisect/bad) ARM: kirkwood: convert to DT irqchip and clocksource
> 
> Can you please try the patches contained in [1]?
> 
> They have been Acked-by Jason Cooper, but I guess we simply lost
> track of them.
> 
> Sebastian
> 
> [1] https://lkml.org/lkml/2013/11/15/276
> 

Hello Sebastian,

I tested the patch series from [1] on top of 3.14-rc8. Works fine: no more
unhandled interrupt messages.

Tested-by: Alexander Elbs <alex@segv.de>

Regards,
Alexander

diff --git a/drivers/irqchip/irq-orion.c b/drivers/irqchip/irq-orion.c
index 8e41be6..a6ab87c 100644
--- a/drivers/irqchip/irq-orion.c
+++ b/drivers/irqchip/irq-orion.c
@@ -42,7 +42,7 @@ __exception_irq_entry orion_handle_irq(struct pt_regs *regs)
                u32 stat = readl_relaxed(gc->reg_base + ORION_IRQ_CAUSE) &
                        gc->mask_cache;
                while (stat) {
-                       u32 hwirq = ffs(stat) - 1;
+                       u32 hwirq = __fls(stat);
                        u32 irq = irq_find_mapping(orion_irq_domain,
                                                   gc->irq_base + hwirq);
                        handle_IRQ(irq, regs);
@@ -117,7 +117,7 @@ static void orion_bridge_irq_handler(unsigned int irq,
struct irq_desc *desc)
                   gc->mask_cache;
 
        while (stat) {
-               u32 hwirq = ffs(stat) - 1;
+               u32 hwirq = __fls(stat);
 
                generic_handle_irq(irq_find_mapping(d, gc->irq_base + hwirq));
                stat &= ~(1 << hwirq);
diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
index 45aa220..5eceec4 100644
--- a/drivers/mmc/host/mvsdio.c
+++ b/drivers/mmc/host/mvsdio.c
@@ -354,6 +354,21 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
                intr_status, mvsd_read(MVSD_NOR_INTR_EN),
                mvsd_read(MVSD_HW_STATE));
 
+       /*
+        * It looks like, SDIO IP can issue one late, spurious irq
+        * although all irqs should be disabled. To work around this,
+        * bail out early, if we didn't expect any irqs to occur.
+        */
+       if (!mvsd_read(MVSD_NOR_INTR_EN) && !mvsd_read(MVSD_ERR_INTR_EN)) {
+               dev_dbg(host->dev,
+                       "spurious irq detected intr 0x%04x intr_en 0x%04x erri
0x%04x erri_en 0x%04x\n",
+                       mvsd_read(MVSD_NOR_INTR_STATUS),
+                       mvsd_read(MVSD_NOR_INTR_EN),
+                       mvsd_read(MVSD_ERR_INTR_STATUS),
+                       mvsd_read(MVSD_ERR_INTR_EN));
+               return IRQ_HANDLED;
+       }
+
        spin_lock(&host->lock);
 
        /* PIO handling, if needed. Messy business... */
@@ -801,10 +816,9 @@ static int mvsd_probe(struct platform_device *pdev)
                goto out;
 
        if (!(mmc->caps & MMC_CAP_NEEDS_POLL))
-               dev_notice(&pdev->dev, "using GPIO for card detection\n");
+               dev_dbg(&pdev->dev, "using GPIO for card detection\n");
        else
-               dev_notice(&pdev->dev,
-                          "lacking card detect (fall back to polling)\n");
+               dev_dbg(&pdev->dev, "lacking card detect, fall back to
polling\n");
        return 0;
 
 out:

