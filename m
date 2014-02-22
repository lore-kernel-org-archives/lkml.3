Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaBVTx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:53:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:21981 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaBVTxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:53:24 -0500
Date: Sat, 22 Feb 2014 20:55:21 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jon Mason <jon.mason@intel.com>, linux-pci@vger.kernel.org
Subject: [PATCH v2 3/4] ntb: Split ntb_setup_msix() into separate BWD/SNB
 routines
Message-ID: <20140222195521.GA14528@dhcp-26-207.brq.redhat.com>
References: <cover.1392996332.git.agordeev@redhat.com>
 <bb2b61719e4dd15c29bc8022e76a9463d548f561.1392996332.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb2b61719e4dd15c29bc8022e76a9463d548f561.1392996332.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an cleanup effort to make ntb_setup_msix() more
readable - use ntb_setup_bwd_msix() to init MSI-Xs on
BWD hardware and ntb_setup_snb_msix() - on SNB hardware.

Function ntb_setup_snb_msix() also initializes MSI-Xs the
way it should has been done - looping pci_enable_msix()
until success or failure.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Jon Mason <jon.mason@intel.com>
Cc: linux-pci@vger.kernel.org
---
 drivers/ntb/ntb_hw.c |  171 +++++++++++++++++++++++++++++++-------------------
 1 files changed, 106 insertions(+), 65 deletions(-)

diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
index 53468f4..679d4d0 100644
--- a/drivers/ntb/ntb_hw.c
+++ b/drivers/ntb/ntb_hw.c
@@ -1079,10 +1079,110 @@ static irqreturn_t ntb_interrupt(int irq, void *dev)
 	return IRQ_HANDLED;
 }
 
-static int ntb_setup_msix(struct ntb_device *ndev)
+static int ntb_setup_snb_msix(struct ntb_device *ndev, int msix_entries)
+{
+	struct pci_dev *pdev = ndev->pdev;
+	struct msix_entry *msix;
+	int rc, i;
+
+	if (msix_entries < SNB_MSIX_CNT)
+		return -ENOSPC;
+
+	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
+	if (rc < 0)
+		return rc;
+	else if (rc > 0)
+		return -ENOSPC;
+
+	for (i = 0; i < msix_entries; i++) {
+		msix = &ndev->msix_entries[i];
+		WARN_ON(!msix->vector);
+
+		if (i == msix_entries - 1) {
+			rc = request_irq(msix->vector,
+					 xeon_event_msix_irq, 0,
+					 "ntb-event-msix", ndev);
+			if (rc)
+				goto err;
+		} else {
+			rc = request_irq(msix->vector,
+					 xeon_callback_msix_irq, 0,
+					 "ntb-callback-msix",
+					 &ndev->db_cb[i]);
+			if (rc)
+				goto err;
+		}
+	}
+
+	ndev->num_msix = msix_entries;
+	ndev->max_cbs = msix_entries - 1;
+
+	return 0;
+
+err:
+	while (--i >= 0) {
+		msix = &ndev->msix_entries[i];
+		WARN_ON(i == ndev->num_msix - 1);
+
+		if (i == ndev->num_msix - 1)
+			free_irq(msix->vector, ndev);
+		else
+			free_irq(msix->vector, &ndev->db_cb[i]);
+	}
+
+	pci_disable_msix(pdev);
+	ndev->num_msix = 0;
+
+	return rc;
+}
+
+static int ntb_setup_bwd_msix(struct ntb_device *ndev, int msix_entries)
 {
 	struct pci_dev *pdev = ndev->pdev;
 	struct msix_entry *msix;
+	int rc, i;
+
+retry:
+	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
+	if (rc < 0)
+		return rc;
+	else if (rc > 0) {
+		dev_warn(&pdev->dev,
+			 "Only %d MSI-X vectors. "
+			 "Limiting the number of queues to that number.\n",
+			 rc);
+		msix_entries = rc;
+		goto retry;
+	}
+
+	for (i = 0; i < msix_entries; i++) {
+		msix = &ndev->msix_entries[i];
+		WARN_ON(!msix->vector);
+
+		rc = request_irq(msix->vector, bwd_callback_msix_irq, 0,
+				 "ntb-callback-msix", &ndev->db_cb[i]);
+		if (rc)
+			goto err;
+	}
+
+	ndev->num_msix = msix_entries;
+	ndev->max_cbs = msix_entries;
+
+	return 0;
+
+err:
+	while (--i >= 0)
+		free_irq(msix->vector, &ndev->db_cb[i]);
+
+	pci_disable_msix(pdev);
+	ndev->num_msix = 0;
+
+	return rc;
+}
+
+static int ntb_setup_msix(struct ntb_device *ndev)
+{
+	struct pci_dev *pdev = ndev->pdev;
 	int msix_entries;
 	int rc, i;
 
@@ -1105,78 +1205,19 @@ static int ntb_setup_msix(struct ntb_device *ndev)
 	for (i = 0; i < msix_entries; i++)
 		ndev->msix_entries[i].entry = i;
 
-	rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
-	if (rc < 0)
-		goto err1;
-	if (rc > 0) {
-		/* On SNB, the link interrupt is always tied to 4th vector.  If
-		 * we can't get all 4, then we can't use MSI-X.
-		 */
-		if (ndev->hw_type != BWD_HW) {
-			rc = -EIO;
-			goto err1;
-		}
-
-		dev_warn(&pdev->dev,
-			 "Only %d MSI-X vectors.  Limiting the number of queues to that number.\n",
-			 rc);
-		msix_entries = rc;
-
-		rc = pci_enable_msix(pdev, ndev->msix_entries, msix_entries);
-		if (rc)
-			goto err1;
-	}
-
-	for (i = 0; i < msix_entries; i++) {
-		msix = &ndev->msix_entries[i];
-		WARN_ON(!msix->vector);
-
-		/* Use the last MSI-X vector for Link status */
-		if (ndev->hw_type == BWD_HW) {
-			rc = request_irq(msix->vector, bwd_callback_msix_irq, 0,
-					 "ntb-callback-msix", &ndev->db_cb[i]);
-			if (rc)
-				goto err2;
-		} else {
-			if (i == msix_entries - 1) {
-				rc = request_irq(msix->vector,
-						 xeon_event_msix_irq, 0,
-						 "ntb-event-msix", ndev);
-				if (rc)
-					goto err2;
-			} else {
-				rc = request_irq(msix->vector,
-						 xeon_callback_msix_irq, 0,
-						 "ntb-callback-msix",
-						 &ndev->db_cb[i]);
-				if (rc)
-					goto err2;
-			}
-		}
-	}
-
-	ndev->num_msix = msix_entries;
 	if (ndev->hw_type == BWD_HW)
-		ndev->max_cbs = msix_entries;
+		rc = ntb_setup_bwd_msix(ndev, msix_entries);
 	else
-		ndev->max_cbs = msix_entries - 1;
+		rc = ntb_setup_snb_msix(ndev, msix_entries);
+	if (rc)
+		goto err1;
 
 	return 0;
 
-err2:
-	while (--i >= 0) {
-		msix = &ndev->msix_entries[i];
-		if (ndev->hw_type != BWD_HW && i == ndev->num_msix - 1)
-			free_irq(msix->vector, ndev);
-		else
-			free_irq(msix->vector, &ndev->db_cb[i]);
-	}
-	pci_disable_msix(pdev);
 err1:
 	kfree(ndev->msix_entries);
-	dev_err(&pdev->dev, "Error allocating MSI-X interrupt\n");
 err:
-	ndev->num_msix = 0;
+	dev_err(&pdev->dev, "Error allocating MSI-X interrupt\n");
 	return rc;
 }
 
-- 
1.7.7.6

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
