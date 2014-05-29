Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbaE2XJv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 19:09:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46202 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbaE2XJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 19:09:49 -0400
Date: Thu, 29 May 2014 16:09:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johan Hovold <johan@hovold.com>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Bryan Evenson <bevenson@melinkcorp.com>,
        Andrew Victor <linux@maxim.org.za>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: fix rtc irq mask for sam9x5 SoCs
Message-Id: <20140529160948.a63fa268a37d985189837a85@linux-foundation.org>
In-Reply-To: <20140509163652.GE6776@localhost>
References: <957b209589094df48ddedbc57c6ccdfd@BLUPR05MB037.namprd05.prod.outlook.com>
	<1399479649-3247-1-git-send-email-boris.brezillon@free-electrons.com>
	<20140508154912.GA6776@localhost>
	<536BBEA4.6080908@free-electrons.com>
	<20140509163652.GE6776@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014 18:36:52 +0200 Johan Hovold <johan@hovold.com> wrote:

> On Thu, May 08, 2014 at 07:28:04PM +0200, Boris BREZILLON wrote:
> 
> > > You should also keep the flush (read of IMR) regardless (to make sure
> > > the write has reached the peripheral), and remember to remove the now
> > > unused mask variable.
> > 
> > Does it has something to do with memory barriers ?
> > If so, why not using writel instead of writel_relaxed ?
> 
> You only need to use the non-relaxed version when synchronising with DMA
> operations.
> 
> The read-back of a register on the same device is a common technique to
> make sure that preceding write has actually reached the peripheral
> (write posting or flushing). In this case, it is used to make
> (reasonably) sure that interrupts have actually been masked before
> returning. (In the general case, you'd even need to verify the read-back
> value to be certain that the device has changed its state.)
> 

So I grabbed this patch as it's tied to "rtc: rtc-at91rm9200: fix
uninterruptible wait for ACKUPD" and is not in linux-next.  Someone
shout at me if that was a mistake.



From: Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: ARM: at91: fix rtc irq mask for sam9x5 SoCs

The RTC IMR register is not reliable on sam9x5 SoCs, hence why me have to
mask all interrupts no matter what IMR claims about already masked irqs.

Mark said:

: Atmel actually has this issue in the Errata of the SAM9G25 and SAM9G35
: datasheets which might be worth referencing in the description?

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Bryan Evenson <bevenson@melinkcorp.com>
Tested-by: Bryan Evenson <bevenson@melinkcorp.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Mark Roszko <mark.roszko@gmail.com>
Cc: Johan Hovold <johan@hovold.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/sysirq_mask.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff -puN arch/arm/mach-at91/sysirq_mask.c~arm-at91-fix-rtc-irq-mask-for-sam9x5-socs arch/arm/mach-at91/sysirq_mask.c
--- a/arch/arm/mach-at91/sysirq_mask.c~arm-at91-fix-rtc-irq-mask-for-sam9x5-socs
+++ a/arch/arm/mach-at91/sysirq_mask.c
@@ -37,12 +37,7 @@ void __init at91_sysirq_mask_rtc(u32 rtc
 	if (!base)
 		return;
 
-	mask = readl_relaxed(base + AT91_RTC_IMR);
-	if (mask) {
-		pr_info("AT91: Disabling rtc irq\n");
-		writel_relaxed(mask, base + AT91_RTC_IDR);
-		(void)readl_relaxed(base + AT91_RTC_IMR);	/* flush */
-	}
+	writel_relaxed(0x1f, base + AT91_RTC_IDR);
 
 	iounmap(base);
 }
_

