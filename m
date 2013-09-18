Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab3IRKWG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:22:06 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:13693 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3IRKWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:22:01 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-d8-52397ec7a723
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 2/6] USB: gadget: s3c-hsotg: fix s3c_hsotg_write_fifo
 function for dedicated fifo mode
Date: Wed, 18 Sep 2013 12:21:31 +0200
Message-id: <1379499695-5279-3-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
References: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprELMWRmVeSWpSXmKPExsVy+t9jAd3jdZZBBqevmVtsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGZsPnWEt2M5TseXhA6YGxm+cXYycHBICJhLPdrWyQ9hiEhfurWfr
	YuTiEBJYxCix+PpnRginnUniw+5HbCBVbAI6Elu+T2AEsUUEBCTWv7jEDlLELPCEUWLqkVdg
	o4QFsiWuNp8CauDgYBFQlfhyXR8kzCvgItH1fQcTSFhCQEFiziQbkDCngKvErj93WEFsIaCS
	mf3zWCcw8i5gZFjFKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERxSz6R3MK5qsDjEKMDBqMTD
	e6HcIkiINbGsuDL3EKMEB7OSCK9LmWWQEG9KYmVValF+fFFpTmrxIUZpDhYlcd6DrdaBQgLp
	iSWp2ampBalFMFkmDk6pBkad7QfDvM/0Bb3d0LTTUUR57bxT07ISN/3etPnR2hlT+nmE973c
	PSOib22BSKz7l1Sn7/2Nb9S+bedwim4s4+L75Xb4dI3UgWqtSPkUlZI+7gULK5+/nnBGY/sS
	jaTAw2u+CDGsfqX0YrLe7lTN1Yz7Vn4v+NLONm3DLaNnxntcRPnUJj26JOerxFKckWioxVxU
	nAgAr2vpECUCAAA=
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

