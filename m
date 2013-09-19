Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753527Ab3ISJw0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:52:26 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35545 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3ISJuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:50:46 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-9e-523ac8f5082a
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 2/7] USB: gadget: s3c-hsotg: fix s3c_hsotg_write_fifo
 function for dedicated fifo mode
Date: Thu, 19 Sep 2013 11:50:18 +0200
Message-id: <1379584223-15232-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd2vJ6yCDHq3qFhsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGZsPnWEt2M5TseXhA6YGxm+cXYycHBICJhLPLv9mgbDFJC7cW8/W
	xcjFISQwnVHi2KvFTBBOO5PErQOzmECq2AR0JLZ8n8AIYosICEisf3GJHaSIWeAJo8TUI6/Y
	QRLCAtkSp/qOgdksAqoS3W+Os4LYvAKuEt+nvAUaxAG0TkFiziQbkDCngJvExPOvwa4QAip5
	vOkL2wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxgoPqmdQOxpUNFocYBTgYlXh4
	Iy5YBgmxJpYVV+YeYpTgYFYS4Z1zyCpIiDclsbIqtSg/vqg0J7X4EKM0B4uSOO+BVutAIYH0
	xJLU7NTUgtQimCwTB6dUA6PlHpczrM3XnlZ6nvxzbfrdmdtMjaekeaqIxC7PLdhWf2+inoCk
	/Jm9a50vPE5d/2Xizffhse63t8T6V5Rul0hmZYyfErJMKsngnhZ7a8Adw62n3pQLC/Z8T63k
	bGRX4dyb2Mt18mOd1AuTcyYsHPOqviYINK3tr54dUXjJfqa7383LKlYN8UosxRmJhlrMRcWJ
	AIsc+0QmAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In s3c_hsotg_write_fifo function PTxFEmp/NPTxFEmp interrupts are enabled
only in shared-fifo mode. In dedicated-fifo mode they should not be used
(when enabled then cause interrupt storm).

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index c00ce27..4fe2f9e 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -553,9 +553,11 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	if (to_write > hs_ep->ep.maxpacket) {
 		to_write = hs_ep->ep.maxpacket;
 
-		s3c_hsotg_en_gsint(hsotg,
-				   periodic ? GINTSTS_PTxFEmp :
-				   GINTSTS_NPTxFEmp);
+		/* it's needed only when we do not use dedicated fifos */
+		if (!hsotg->dedicated_fifos)
+			s3c_hsotg_en_gsint(hsotg,
+					   periodic ? GINTSTS_PTxFEmp :
+					   GINTSTS_NPTxFEmp);
 	}
 
 	/* see if we can write data */
@@ -580,9 +582,11 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 		 * is more room left.
 		 */
 
-		s3c_hsotg_en_gsint(hsotg,
-				   periodic ? GINTSTS_PTxFEmp :
-				   GINTSTS_NPTxFEmp);
+		/* it's needed only when we do not use dedicated fifos */
+		if (!hsotg->dedicated_fifos)
+			s3c_hsotg_en_gsint(hsotg,
+					   periodic ? GINTSTS_PTxFEmp :
+					   GINTSTS_NPTxFEmp);
 	}
 
 	dev_dbg(hsotg->dev, "write %d/%d, can_write %d, done %d\n",
-- 
1.7.9.5

