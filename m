Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170AbaIRQMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:12:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:55600 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756463AbaIRQM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:12:29 -0400
Date: Thu, 18 Sep 2014 18:12:25 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] ARM: edma: unconditionally ack the error interrupt
Message-ID: <20140918161225.GA10232@linutronix.de>
References: <1410377960-26921-1-git-send-email-bigeasy@linutronix.de>
 <541AA900.4080506@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <541AA900.4080506@ti.com>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Ujfalusi | 2014-09-18 12:42:24 [+0300]:

>My hunch on what could be causing this that we might have unhandled dma event
>and another comes. This will flag the EDMA_EMR register. Any change in this
>register will assert error interrupt which can only be cleared by writing to
>EDMA_EMRC register.
>The EDMA_EMRC register bits also cleared on edma_start(), edma_stop() and
>edma_clean_channel() apart from the error interrupt handler.
>So it is possible that we have missed event on one of the channels but a stop
>might clear the event so in the interrupt hander we do not see this.
>I think it would be good to understand what is going on the backround...
>Can you print out the EDMA_EMCR just before we clear it in the places I have
>mentioned? We might get better understanding on which stage we clear it and
>probably we can understand how to fix this properly so we are not going to
>have missed events on channels.

Okay. For the protocol I applied this patch:

diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
index 160460ae3a49..16598625a4d1 100644
--- a/arch/arm/common/edma.c
+++ b/arch/arm/common/edma.c
@@ -422,20 +422,24 @@ static irqreturn_t dma_ccerr_handler(int irq, void *data)
 	int i;
 	int ctlr;
 	unsigned int cnt = 0;
+	u32 emr0;
 
 	ctlr = irq2ctlr(irq);
 	if (ctlr < 0)
 		return IRQ_NONE;
 
 	dev_dbg(data, "dma_ccerr_handler\n");
+	emr0 = edma_read_array(ctlr, EDMA_EMR, 0);
 
-	if ((edma_read_array(ctlr, EDMA_EMR, 0) == 0) &&
+	if ((emr0 == 0) &&
 	    (edma_read_array(ctlr, EDMA_EMR, 1) == 0) &&
 	    (edma_read(ctlr, EDMA_QEMR) == 0) &&
 	    (edma_read(ctlr, EDMA_CCERR) == 0)) {
 		edma_write(ctlr, EDMA_EEVAL, 1);
+		trace_printk("Unhandled\n");
 		return IRQ_NONE;
 	}
+	trace_printk("emr0: %x\n", emr0);
 
 	while (1) {
 		int j = -1;
@@ -1310,6 +1314,9 @@ int edma_start(unsigned channel)
 		pr_debug("EDMA: ER%d %08x\n", j,
 			edma_shadow0_read_array(ctlr, SH_ER, j));
 		/* Clear any pending event or error */
+		trace_printk("j%d mask%x EDMA_EMCR: %x\n",
+			     j, mask,
+			     edma_read_array(ctlr, EDMA_EMCR, j));
 		edma_write_array(ctlr, EDMA_ECR, j, mask);
 		edma_write_array(ctlr, EDMA_EMCR, j, mask);
 		/* Clear any SER */
@@ -1347,6 +1354,9 @@ void edma_stop(unsigned channel)
 		edma_shadow0_write_array(ctlr, SH_EECR, j, mask);
 		edma_shadow0_write_array(ctlr, SH_ECR, j, mask);
 		edma_shadow0_write_array(ctlr, SH_SECR, j, mask);
+		trace_printk("j%d mask%x EDMA_EMCR: %x\n",
+			     j, mask,
+			     edma_read_array(ctlr, EDMA_EMCR, j));
 		edma_write_array(ctlr, EDMA_EMCR, j, mask);
 
 		pr_debug("EDMA: EER%d %08x\n", j,
@@ -1387,6 +1397,9 @@ void edma_clean_channel(unsigned channel)
 				edma_read_array(ctlr, EDMA_EMR, j));
 		edma_shadow0_write_array(ctlr, SH_ECR, j, mask);
 		/* Clear the corresponding EMR bits */
+		trace_printk("j%d mask%x EDMA_EMCR: %x\n",
+			     j, mask,
+			     edma_read_array(ctlr, EDMA_EMCR, j));
 		edma_write_array(ctlr, EDMA_EMCR, j, mask);
 		/* Clear any SER */
 		edma_shadow0_write_array(ctlr, SH_SECR, j, mask);

--

and the result is something like this:

           <idle>-0     [000] dnh.   303.356403: edma_start: j0 mask8000000 EDMA_EMCR: 0
           <idle>-0     [000] d.h.   303.396721: edma_stop: j0 mask8000000 EDMA_EMCR: 0
           <idle>-0     [000] dnh.   303.557103: edma_start: j0 mask8000000 EDMA_EMCR: 0
           <idle>-0     [000] dnh.   303.557129: edma_stop: j0 mask4000000 EDMA_EMCR: 0
           <idle>-0     [000] dnH.   303.557142: dma_ccerr_handler: Unhandled
             less-2612  [000] d...   303.557237: edma_start: j0 mask4000000 EDMA_EMCR: 0
             less-2612  [000] d.h.   303.562491: edma_stop: j0 mask4000000 EDMA_EMCR: 0
             less-2612  [000] d...   303.564475: edma_start: j0 mask4000000 EDMA_EMCR: 0

The full trace is at [0]. I haven't found a single entry where EDMA_EMCR
was != 0 at those spots. *If* there is a edma_stop() before the
interrupt then the interrupt remains unhandled. If there is a
edma_start() with mask 8000000 then we have dma_ccerr_handler() with a
mask of 4000000.

Fun fact: If I remove the write access to EDMA_EMCR register (the write
access after the read out) then I haven't seen [1] a single error interrupt
beeing "unhandled" out of 9. The former has three out of eight.

[0] https://breakpoint.cc/edma_trace.txt.xz
[1] https://breakpoint.cc/edma_trace_nowrite.txt.xz

Sebastian
