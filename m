Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757627AbaFYQW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:22:59 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:42227 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757520AbaFYQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:22:57 -0400
From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: haver@linux.vnet.ibm.com, gregkh@linuxfoundation.org,
        Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: [PATCH 3/4] GenWQE: Improve hardware error recovery
Date: Wed, 25 Jun 2014 13:22:06 -0300
Message-Id: <1403713327-27976-4-git-send-email-klebers@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
References: <1403713327-27976-1-git-send-email-klebers@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062516-1524-0000-0000-00000A1B22B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, in the event of a fatal hardware error, the driver tries a
recovery procedure that calls pci_reset_function() to reset the card.
This is not sufficient in some cases, needing a fundamental reset to
bring the card back.

This patch implements a call to the platform fundamental reset procedure
on the error recovery path if GENWQE_PLATFORM_ERROR_RECOVERY is enabled.
This is implemented by default only on PPC64, since this can cause
problems on other archs, e.g. zSeries, where the platform has its own
recovery procedures, leading to a potencial race conditition. For these
cases, the recovery is kept as it was before.

Signed-off-by: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
---
 drivers/misc/genwqe/card_base.c |   45 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
index 87ebaba..abb7961 100644
--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -797,6 +797,41 @@ static int genwqe_pci_fundamental_reset(struct pci_dev *pci_dev)
 	return rc;
 }
 
+
+static int genwqe_platform_recovery(struct genwqe_dev *cd)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+	int rc;
+
+	dev_info(&pci_dev->dev,
+		 "[%s] resetting card for error recovery\n", __func__);
+
+	/* Clear out error injection flags */
+	cd->err_inject &= ~(GENWQE_INJECT_HARDWARE_FAILURE |
+			    GENWQE_INJECT_GFIR_FATAL |
+			    GENWQE_INJECT_GFIR_INFO);
+
+	genwqe_stop(cd);
+
+	/* Try recoverying the card with fundamental reset */
+	rc = genwqe_pci_fundamental_reset(pci_dev);
+	if (!rc) {
+		rc = genwqe_start(cd);
+		if (!rc)
+			dev_info(&pci_dev->dev,
+				 "[%s] card recovered\n", __func__);
+		else
+			dev_err(&pci_dev->dev,
+				"[%s] err: cannot start card services! (err=%d)\n",
+				__func__, rc);
+	} else {
+		dev_err(&pci_dev->dev,
+			"[%s] card reset failed\n", __func__);
+	}
+
+	return rc;
+}
+
 /*
  * genwqe_reload_bistream() - reload card bitstream
  *
@@ -875,6 +910,7 @@ static int genwqe_health_thread(void *data)
 	struct pci_dev *pci_dev = cd->pci_dev;
 	u64 gfir, gfir_masked, slu_unitcfg, app_unitcfg;
 
+ health_thread_begin:
 	while (!kthread_should_stop()) {
 		rc = wait_event_interruptible_timeout(cd->health_waitq,
 			 (genwqe_health_check_cond(cd, &gfir) ||
@@ -960,6 +996,15 @@ static int genwqe_health_thread(void *data)
 		/* We do nothing if the card is going over PCI recovery */
 		if (pci_channel_offline(pci_dev))
 			return -EIO;
+
+		/*
+		 * If it's supported by the platform, we try a fundamental reset
+		 * to recover from a fatal error. Otherwise, we continue to wait
+		 * for an external recovery procedure to take care of it.
+		 */
+		rc = genwqe_platform_recovery(cd);
+		if (!rc)
+			goto health_thread_begin;
 	}
 
 	dev_err(&pci_dev->dev,
-- 
1.7.1

