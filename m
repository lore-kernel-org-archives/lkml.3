Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3ISJvH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:51:07 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:35563 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab3ISJvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:51:03 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-ba-523ac90636bf
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 7/7] USB: gadget: s3c-hsotg: fix interrupt configuration in
 dedicated-fifo mode
Date: Thu, 19 Sep 2013 11:50:23 +0200
Message-id: <1379584223-15232-8-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jQV22k1ZBBs938llsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGau/72cuuMZbMXHNXuYGxh9cXYycHBICJhJ3Zv5khbDFJC7cW8/W
	xcjFISQwnVFi9/bfUE47k8Se/1/YQKrYBHQktnyfwAhiiwgISKx/cYkdpIhZ4AmjxNQjr4Ac
	Dg5hgRSJW3+4QWpYBFQlTux8xAwS5hVwlXi/QBPElBBQkJgzyQakglPATWLi+dcsILYQUMXj
	TV/YJjDyLmBkWMUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHFDPpHYwrmywOMQowMGoxMMb
	ccEySIg1say4MvcQowQHs5II75xDVkFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeQ+0WgcKCaQn
	lqRmp6YWpBbBZJk4OKUaGI3fHg2f+zvFyclJInJBxyT+ze5CdjseJ70s+B56e71G58qQ9Qlz
	T7+aVbOnPbt8Ese79IWXUn3XSyuwb5md5bnk9uPjFf0PfLqbjeadEJNuVD/g9emgh5P19enZ
	75uObC89Z/7PKjS4ccoWMR+be/pLGSc9jPjde3Zu9amS3hxulw+u+y9zKiuxFGckGmoxFxUn
	AgCBmNHKJAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In dedicated-fifo mode TxFIFOEmpty interrupt should be asserted when TxFIFO
for this endpoint is completly empty, so NPTxFEmpLvl and PTxFEmpLvl bits are
set in GAHBCFG register.
In DIEPMSK register INTknTXFEmpMsk is set, becouse it's needed to indicate
FIFO Empty state.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 5c4c41282..d5d951d 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -2269,15 +2269,19 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
 		       GAHBCFG_HBstLen_Incr4,
 		       hsotg->regs + GAHBCFG);
 	else
-		writel(GAHBCFG_GlblIntrEn, hsotg->regs + GAHBCFG);
+		writel(((hsotg->dedicated_fifos) ? (GAHBCFG_NPTxFEmpLvl |
+						    GAHBCFG_PTxFEmpLvl) : 0) |
+		       GAHBCFG_GlblIntrEn,
+		       hsotg->regs + GAHBCFG);
 
 	/*
-	 * Enabling INTknTXFEmpMsk here seems to be a big mistake, we end
-	 * up being flooded with interrupts if the host is polling the
-	 * endpoint to try and read data.
+	 * If INTknTXFEmpMsk is enabled, it's important to disable ep interrupts
+	 * when we have no data to transfer. Otherwise we get being flooded by
+	 * interrupts.
 	 */
 
-	writel(((hsotg->dedicated_fifos) ? DIEPMSK_TxFIFOEmpty : 0) |
+	writel(((hsotg->dedicated_fifos) ? DIEPMSK_TxFIFOEmpty |
+	       DIEPMSK_INTknTXFEmpMsk : 0) |
 	       DIEPMSK_EPDisbldMsk | DIEPMSK_XferComplMsk |
 	       DIEPMSK_TimeOUTMsk | DIEPMSK_AHBErrMsk |
 	       DIEPMSK_INTknEPMisMsk,
-- 
1.7.9.5

