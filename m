Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaH1WzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 18:55:05 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:56732 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbaH1WzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 18:55:03 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/qkzQPAaQTPgQk1oLGpTyr
Date: Thu, 28 Aug 2014 15:54:54 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: balbi@ti.com, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Vinod Koul <vinod.koul@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Walmsley <paul@pwsan.com>
Subject: Re: [PATCH 15/15] tty: serial: 8250: omap: add dma support
Message-ID: <20140828225454.GM16006@atomide.com>
References: <1408124563-31541-1-git-send-email-bigeasy@linutronix.de>
 <1408124563-31541-16-git-send-email-bigeasy@linutronix.de>
 <20140815210211.GD9239@atomide.com>
 <53F5AF0D.5060409@linutronix.de>
 <20140821184416.GF10066@atomide.com>
 <53FE3779.5090908@linutronix.de>
 <20140827202313.GF16006@atomide.com>
 <20140828082348.GA5413@linutronix.de>
 <20140828164645.GG16006@atomide.com>
 <53FF84DF.7080406@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53FF84DF.7080406@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Sebastian Andrzej Siewior <bigeasy@linutronix.de> [140828 12:37]:
> On 08/28/2014 06:46 PM, Tony Lindgren wrote:
> > 
> > Sounds like there should be some way to clear that state.. I wonder
> > if omap-serial.c had something before it's DMA support was removed?
> 
> Its DMA was removed? Like there was DMA support?

Yeah see commit 494574304711a333386e7dd5fd3ebbc3b7024994...
 
> > I'd assume when the UART is powered down by runtime PM it's state
> > is completetely reset and we could restore the non-DMA state?
> 
> I tried that by canceling the RX-DMA request and removing the DMA-enable
> bits from UART but it didn't help. Then I noticed that once that DMA en
> bit is set, the UART won't do any idle.
> 
> > Maybe post your current patches and a test patch to try to toggle
> > the DMA on and off?
> 
> Oh. I pushed my dirty tree to
>  git://git.breakpoint.cc/bigeasy/linux.git uart_v8_wip
> 
> The top most commit does not setup dma at all and adds commented out
> code how to enable DMA via SCR or FCR register. With this I hit
> core-off. Once _one_ of the modes are enabled, it doesn't work anymore.
> 
> I will try to address review comments tomorrow and hopefully post a v8
> based on -rc2. The same goes for your patch (which I will try tomorrow).

OK thanks, I'm seeing the same issue as you. And the idlest registers
don't show any blockers. Looking at the errata docs, seems like
"Usage Note 2.7" in sprz318f.pdf says:

 Details When configured for DMA operations using smartidle mode (SYSC[4:3].IDLEMODE =
 0x2), the UART module will not acknowledge incoming idle requests. As a consequence,
 it can prevent L4 from going to idle.
 When there are additional expected transfers, the UART should be placed in force-idle
 mode.

So I've added also Paul to Cc, he may have better suggestions for the
hwmod flags to use. The experimental patch below seems to allow idling
for me, care to give it a try?

Regards,

Tony

8< --------------------
From: Tony Lindgren <tony@atomide.com>
Date: Thu, 28 Aug 2014 15:41:21 -0700
Subject: [PATCH] ARM: OMAP3: Use force-idle for UARTs because of DMA errata

In sprz318f.pdf Usage Note 2.7 says that UARTs cannot acknowledge
idle requests in smartidle mode when configure for DMA operations.
This prevents L4 from going idle. Sol et's use force-idle mode
instead.

--- a/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
+++ b/arch/arm/mach-omap2/omap_hwmod_3xxx_data.c
@@ -490,7 +490,9 @@ static struct omap_hwmod omap3xxx_uart1_hwmod = {
 	.mpu_irqs	= omap2_uart1_mpu_irqs,
 	.sdma_reqs	= omap2_uart1_sdma_reqs,
 	.main_clk	= "uart1_fck",
-	.flags		= DEBUG_TI81XXUART1_FLAGS | HWMOD_SWSUP_SIDLE_ACT,
+	.flags		= DEBUG_TI81XXUART1_FLAGS |
+				HWMOD_NO_OCP_AUTOIDLE | HWMOD_SWSUP_SIDLE |
+				HWMOD_FORCE_MSTANDBY,
 	.prcm		= {
 		.omap2 = {
 			.module_offs = CORE_MOD,
@@ -509,7 +511,9 @@ static struct omap_hwmod omap3xxx_uart2_hwmod = {
 	.mpu_irqs	= omap2_uart2_mpu_irqs,
 	.sdma_reqs	= omap2_uart2_sdma_reqs,
 	.main_clk	= "uart2_fck",
-	.flags		= DEBUG_TI81XXUART2_FLAGS | HWMOD_SWSUP_SIDLE_ACT,
+	.flags		= DEBUG_TI81XXUART2_FLAGS |
+				HWMOD_NO_OCP_AUTOIDLE | HWMOD_SWSUP_SIDLE |
+				HWMOD_FORCE_MSTANDBY,
 	.prcm		= {
 		.omap2 = {
 			.module_offs = CORE_MOD,
@@ -529,7 +533,8 @@ static struct omap_hwmod omap3xxx_uart3_hwmod = {
 	.sdma_reqs	= omap2_uart3_sdma_reqs,
 	.main_clk	= "uart3_fck",
 	.flags		= DEBUG_OMAP3UART3_FLAGS | DEBUG_TI81XXUART3_FLAGS |
-				HWMOD_SWSUP_SIDLE_ACT,
+				HWMOD_NO_OCP_AUTOIDLE | HWMOD_SWSUP_SIDLE |
+				HWMOD_FORCE_MSTANDBY,
 	.prcm		= {
 		.omap2 = {
 			.module_offs = OMAP3430_PER_MOD,
@@ -559,7 +564,9 @@ static struct omap_hwmod omap36xx_uart4_hwmod = {
 	.mpu_irqs	= uart4_mpu_irqs,
 	.sdma_reqs	= uart4_sdma_reqs,
 	.main_clk	= "uart4_fck",
-	.flags		= DEBUG_OMAP3UART4_FLAGS | HWMOD_SWSUP_SIDLE_ACT,
+	.flags		= DEBUG_OMAP3UART4_FLAGS |
+				HWMOD_NO_OCP_AUTOIDLE | HWMOD_SWSUP_SIDLE |
+				HWMOD_FORCE_MSTANDBY,
 	.prcm		= {
 		.omap2 = {
 			.module_offs = OMAP3430_PER_MOD,
