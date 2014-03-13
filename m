Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbaCMWRF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 18:17:05 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:33462
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354AbaCMWQ6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 18:16:58 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(z569dhzc89bhe0eah4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Thu, 13 Mar 2014 15:16:51 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Anirudha Sarangi <anirudh@xilinx.com>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Zynq macb
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <c6344e9b-fa32-4313-8950-59030c4bffb8@AM1EHSMHS003.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

I did some testing on the current linux-next tree and ran iperf on Zynq.
It seems that network and even the whole system can collapse when doing
that.
I don't really know what's going on, but once I saw the message:
	"inconsistent Rx descriptor chain"
printed twice (system frozen afterwards).

I don't know what exactly is going wrong, but suspect something around
memory/DMA. I have no clue whether it makes any sense or not, but I
tried using the macb_* functions instead of the gem_* ones (see diff below).
That seems to result in a stable system and working Ethernet.

So, I guess my questions are:
Does any of this make sense?
Is it reasonable for the Zynq GEM to use the macb_* routines (are there
any implementation options to check whether one or the other are
appropriate for an macb implementation?)?
Any other hints?

	Thanks,
	Sören

-----------8<-------------8<---------------8<--------------8<----------------8<--------
diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index d0c38e01e99f..8c73cd43457e 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -1905,17 +1905,10 @@ static int __init macb_probe(struct platform_device *pdev)
        dev->base_addr = regs->start;
 
        /* setup appropriated routines according to adapter type */
-       if (macb_is_gem(bp)) {
-               bp->macbgem_ops.mog_alloc_rx_buffers = gem_alloc_rx_buffers;
-               bp->macbgem_ops.mog_free_rx_buffers = gem_free_rx_buffers;
-               bp->macbgem_ops.mog_init_rings = gem_init_rings;
-               bp->macbgem_ops.mog_rx = gem_rx;
-       } else {
-               bp->macbgem_ops.mog_alloc_rx_buffers = macb_alloc_rx_buffers;
-               bp->macbgem_ops.mog_free_rx_buffers = macb_free_rx_buffers;
-               bp->macbgem_ops.mog_init_rings = macb_init_rings;
-               bp->macbgem_ops.mog_rx = macb_rx;
-       }
+       bp->macbgem_ops.mog_alloc_rx_buffers = macb_alloc_rx_buffers;
+       bp->macbgem_ops.mog_free_rx_buffers = macb_free_rx_buffers;
+       bp->macbgem_ops.mog_init_rings = macb_init_rings;
+       bp->macbgem_ops.mog_rx = macb_rx;
 
        /* Set MII management clock divider */
        config = macb_mdc_clk_div(bp);


