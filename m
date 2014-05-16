Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaEPNfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 09:35:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54209 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492AbaEPNfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 09:35:31 -0400
Date: Fri, 16 May 2014 06:34:33 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-7e5f01b1a1504b2777342628e365c1a0c6600b0e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, cmetcalf@tilera.com,
        tony.luck@intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, grant.likely@linaro.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        cmetcalf@tilera.com, tony.luck@intel.com, tglx@linutronix.de
In-Reply-To: <20140507154337.177939962@linutronix.de>
References: <20140507154337.177939962@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:irq/core] tile: usb: Use irq_alloc/free_hwirq
Git-Commit-ID: 7e5f01b1a1504b2777342628e365c1a0c6600b0e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7e5f01b1a1504b2777342628e365c1a0c6600b0e
Gitweb:     http://git.kernel.org/tip/7e5f01b1a1504b2777342628e365c1a0c6600b0e
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Wed, 7 May 2014 15:44:13 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 16 May 2014 14:05:20 +0200

tile: usb: Use irq_alloc/free_hwirq

No functional change. Just convert to the new interface.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Grant Likely <grant.likely@linaro.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Acked-by: Chris Metcalf <cmetcalf@tilera.com>
Link: http://lkml.kernel.org/r/20140507154337.177939962@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/usb/host/ehci-tilegx.c | 8 ++++----
 drivers/usb/host/ohci-tilegx.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-tilegx.c b/drivers/usb/host/ehci-tilegx.c
index f3713d3..0d24767 100644
--- a/drivers/usb/host/ehci-tilegx.c
+++ b/drivers/usb/host/ehci-tilegx.c
@@ -142,8 +142,8 @@ static int ehci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	ehci->hcs_params = readl(&ehci->caps->hcs_params);
 
 	/* Create our IRQs and register them. */
-	pdata->irq = create_irq();
-	if (pdata->irq < 0) {
+	pdata->irq = irq_alloc_hwirq(-1);
+	if (!pdata->irq) {
 		ret = -ENXIO;
 		goto err_no_irq;
 	}
@@ -175,7 +175,7 @@ static int ehci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	}
 
 err_have_irq:
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 err_no_irq:
 	tilegx_stop_ehc();
 	usb_put_hcd(hcd);
@@ -193,7 +193,7 @@ static int ehci_hcd_tilegx_drv_remove(struct platform_device *pdev)
 	usb_put_hcd(hcd);
 	tilegx_stop_ehc();
 	gxio_usb_host_destroy(&pdata->usb_ctx);
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 
 	return 0;
 }
diff --git a/drivers/usb/host/ohci-tilegx.c b/drivers/usb/host/ohci-tilegx.c
index 0b183e0..bef6dfb 100644
--- a/drivers/usb/host/ohci-tilegx.c
+++ b/drivers/usb/host/ohci-tilegx.c
@@ -129,8 +129,8 @@ static int ohci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	tilegx_start_ohc();
 
 	/* Create our IRQs and register them. */
-	pdata->irq = create_irq();
-	if (pdata->irq < 0) {
+	pdata->irq = irq_alloc_hwirq(-1);
+	if (!pdata->irq) {
 		ret = -ENXIO;
 		goto err_no_irq;
 	}
@@ -164,7 +164,7 @@ static int ohci_hcd_tilegx_drv_probe(struct platform_device *pdev)
 	}
 
 err_have_irq:
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 err_no_irq:
 	tilegx_stop_ohc();
 	usb_put_hcd(hcd);
@@ -182,7 +182,7 @@ static int ohci_hcd_tilegx_drv_remove(struct platform_device *pdev)
 	usb_put_hcd(hcd);
 	tilegx_stop_ohc();
 	gxio_usb_host_destroy(&pdata->usb_ctx);
-	destroy_irq(pdata->irq);
+	irq_free_hwirq(pdata->irq);
 
 	return 0;
 }
