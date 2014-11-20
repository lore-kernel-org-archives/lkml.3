Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbaKTPWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 10:22:15 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:65221 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223AbaKTPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 10:22:13 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: netdev@vger.kernel.org
Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>, Roger Pao <rpao@paonet.org>,
        linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: [PATCH 2/2] pcmcia: remove pcmcia_request_exclusive_irq
Date: Thu, 20 Nov 2014 16:21:56 +0100
Message-ID: <2369529.fZhWQAcXLX@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4353896.15JnC91eLO@wuerfel>
References: <4353896.15JnC91eLO@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7/xEbZKo1qBc376cm9lnJa/4EqYpAqC1phOcD36n1ih
 u5kENxOZf35Jm10j+VCIcMiTy2PKmBDpMnA4wEp9lxXvB5TyZl
 OAFxLwRx4KlTj/i6NV5fPSIYcvmm7af3/3gBPQdaOs3J6uyv2d
 LY/fXocZWAK5gWjdGG+FPGWFlzLkkSh7zV7fJNF0aMWO/2gTLW
 IEEo9FjDZBSLg44wr2yhL7BoP2+xThi4LISOVeTWEF0Wooz76U
 iXI/kLCVSQyzglfumpd/zINrHum4lPgUPpVBVFatXsTwf3YRjm
 0/PUPzv4M4cTj5L5koFEbNhlduLo25zVtTuuSNr4Gj/cOV+QfJ
 JLS+jSnPAVgFQ8BgUlVw=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last user of the deprecated pcmcia_request_exclusive_irq function,
was removed in 5f5316fcd08e ("am2150: Update nmclan_cs.c to use update
PCMCIA API"), so we can clean up the core code and remove the interface
and its documentation.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 Documentation/pcmcia/driver-changes.txt |  3 ---
 drivers/pcmcia/pcmcia_resource.c        | 39 ---------------------------------------
 include/pcmcia/ds.h                     | 10 ----------
 3 files changed, 0 insertions(+), 52 deletions(-)

---
The patch that removed the last user was merged in 3.18-rc1, so this
should be safe to apply independently now.

diff --git a/Documentation/pcmcia/driver-changes.txt b/Documentation/pcmcia/driver-changes.txt
index dd04361dd361..78355c4c268a 100644
--- a/Documentation/pcmcia/driver-changes.txt
+++ b/Documentation/pcmcia/driver-changes.txt
@@ -46,9 +46,6 @@ This file details changes in 2.6 which affect PCMCIA card driver authors:
    - use pcmcia_request_irq(p_dev, handler_t); the PCMCIA core will
      clean up automatically on calls to pcmcia_disable_device() or
      device ejection.
-   - drivers still not capable of IRQF_SHARED (or not telling us so) may
-     use the deprecated pcmcia_request_exclusive_irq() for the time
-     being; they might receive a shared IRQ nonetheless.
 
 * no cs_error / CS_CHECK / CONFIG_PCMCIA_DEBUG (as of 2.6.33)
    Instead of the cs_error() callback or the CS_CHECK() macro, please use
diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index e8c19def1b0f..23a123da3dd7 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -712,45 +712,6 @@ int __must_check pcmcia_request_irq(struct pcmcia_device *p_dev,
 }
 EXPORT_SYMBOL(pcmcia_request_irq);
 
-
-/**
- * pcmcia_request_exclusive_irq() - attempt to request an exclusive IRQ first
- * @p_dev: the associated PCMCIA device
- * @handler: IRQ handler to register
- *
- * pcmcia_request_exclusive_irq() is a wrapper around request_irq() which
- * attempts first to request an exclusive IRQ. If it fails, it also accepts
- * a shared IRQ, but prints out a warning. PCMCIA drivers should allow for
- * IRQ sharing and either use request_irq directly (then they need to call
- * free_irq() themselves, too), or the pcmcia_request_irq() function.
- */
-int __must_check
-__pcmcia_request_exclusive_irq(struct pcmcia_device *p_dev,
-			irq_handler_t handler)
-{
-	int ret;
-
-	if (!p_dev->irq)
-		return -EINVAL;
-
-	ret = request_irq(p_dev->irq, handler, 0, p_dev->devname, p_dev->priv);
-	if (ret) {
-		ret = pcmcia_request_irq(p_dev, handler);
-		dev_printk(KERN_WARNING, &p_dev->dev, "pcmcia: "
-			"request for exclusive IRQ could not be fulfilled.\n");
-		dev_printk(KERN_WARNING, &p_dev->dev, "pcmcia: the driver "
-			"needs updating to supported shared IRQ lines.\n");
-	}
-	if (ret)
-		dev_printk(KERN_INFO, &p_dev->dev, "request_irq() failed\n");
-	else
-		p_dev->_irq = 1;
-
-	return ret;
-} /* pcmcia_request_exclusive_irq */
-EXPORT_SYMBOL(__pcmcia_request_exclusive_irq);
-
-
 #ifdef CONFIG_PCMCIA_PROBE
 
 /* mask of IRQs already reserved by other cards, we should avoid using them */
diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
index 2d56e428506c..3037157855f0 100644
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -206,16 +206,6 @@ int pcmcia_write_config_byte(struct pcmcia_device *p_dev, off_t where, u8 val);
 /* device configuration */
 int pcmcia_request_io(struct pcmcia_device *p_dev);
 
-int __must_check
-__pcmcia_request_exclusive_irq(struct pcmcia_device *p_dev,
-				irq_handler_t handler);
-static inline __must_check __deprecated int
-pcmcia_request_exclusive_irq(struct pcmcia_device *p_dev,
-				irq_handler_t handler)
-{
-	return __pcmcia_request_exclusive_irq(p_dev, handler);
-}
-
 int __must_check pcmcia_request_irq(struct pcmcia_device *p_dev,
 				irq_handler_t handler);
 

