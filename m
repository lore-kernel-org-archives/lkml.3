Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab3DOEaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:30:04 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:8402
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751264Ab3DOEaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:30:02 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Vakul Garg <vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kim Phillips <kim.phillips@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCHv1] crypto: caam - fix job ring cleanup code
Date: Mon, 15 Apr 2013 09:55:51 +0530
Message-ID: <1365999951-20635-1-git-send-email-vakul@freescale.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The job ring init function creates a platform device for each job ring.
While the job ring is shutdown, e.g. while caam module removal, its
platform device was not being removed. This leads to failure while
reinsertion and then removal of caam module second time.

The following kernel crash dump appears when caam module is reinserted
and then removed again. This patch fixes it.

root@p4080ds:~# rmmod caam.ko 
Unable to handle kernel paging request for data at address 0x00000008
Faulting instruction address: 0xf94aca18
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=8 P4080 DS
Modules linked in: caam(-) qoriq_dbg(O) [last unloaded: caam]
NIP: f94aca18 LR: f94aca18 CTR: c029f950
REGS: eac47d60 TRAP: 0300   Tainted: G           O  (3.8.4-rt2)
MSR: 00029002 <CE,EE,ME>  CR: 22022484  XER: 20000000
DEAR: 00000008, ESR: 00000000
TASK = e49dfaf0[2110] 'rmmod' THREAD: eac46000 CPU: 1
GPR00: f94ad3f4 eac47e10 e49dfaf0 00000000 00000005 ea2ac210 ffffffff 00000000 
GPR08: c286de68 e4977ce0 c029b1c0 00000001 c029f950 10029738 00000000 100e0000 
GPR16: 00000000 10023d00 1000cbdc 1000cb8c 1000cbb8 00000000 c07dfecc 00000000 
GPR24: c07e0000 00000000 1000cbd8 f94e0000 ffffffff 00000000 ea53cd40 00000000 
NIP [f94aca18] caam_reset_hw_jr+0x18/0x1c0 [caam]
LR [f94aca18] caam_reset_hw_jr+0x18/0x1c0 [caam]
Call Trace:
[eac47e10] [eac47e30] 0xeac47e30 (unreliable)
[eac47e20] [f94ad3f4] caam_jr_shutdown+0x34/0x220 [caam]
[eac47e60] [f94ac0e4] caam_remove+0x54/0xb0 [caam]
[eac47e80] [c029fb38] __device_release_driver+0x68/0x120
[eac47e90] [c02a05c8] driver_detach+0xd8/0xe0
[eac47eb0] [c029f8e0] bus_remove_driver+0xa0/0x110
[eac47ed0] [c00768e4] sys_delete_module+0x144/0x270
[eac47f40] [c000e2f0] ret_from_syscall+0x0/0x3c


Signed-off-by: Vakul Garg <vakul@freescale.com>
Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
---
Changes in v1:
	Addressed Horia's comments regarding commit log.

 drivers/crypto/caam/intern.h |    1 +
 drivers/crypto/caam/jr.c     |    4 ++++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/crypto/caam/intern.h b/drivers/crypto/caam/intern.h
index 5cd4c1b..e4a16b7 100644
--- a/drivers/crypto/caam/intern.h
+++ b/drivers/crypto/caam/intern.h
@@ -41,6 +41,7 @@ struct caam_jrentry_info {
 /* Private sub-storage for a single JobR */
 struct caam_drv_private_jr {
 	struct device *parentdev;	/* points back to controller dev */
+	struct platform_device *jr_pdev;/* points to platform device for JR */
 	int ridx;
 	struct caam_job_ring __iomem *rregs;	/* JobR's register space */
 	struct tasklet_struct irqtask;
diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index 93d1407..b4aa773e 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -407,6 +407,7 @@ int caam_jr_shutdown(struct device *dev)
 	dma_free_coherent(dev, sizeof(struct jr_outentry) * JOBR_DEPTH,
 			  jrp->outring, outbusaddr);
 	kfree(jrp->entinfo);
+	of_device_unregister(jrp->jr_pdev);
 
 	return ret;
 }
@@ -454,6 +455,8 @@ int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
 		kfree(jrpriv);
 		return -EINVAL;
 	}
+
+	jrpriv->jr_pdev = jr_pdev;
 	jrdev = &jr_pdev->dev;
 	dev_set_drvdata(jrdev, jrpriv);
 	ctrlpriv->jrdev[ring] = jrdev;
@@ -472,6 +475,7 @@ int caam_jr_probe(struct platform_device *pdev, struct device_node *np,
 	/* Now do the platform independent part */
 	error = caam_jr_init(jrdev); /* now turn on hardware */
 	if (error) {
+		of_device_unregister(jr_pdev);
 		kfree(jrpriv);
 		return error;
 	}
-- 
1.7.7


