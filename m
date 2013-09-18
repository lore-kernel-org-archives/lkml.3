Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab3IRKWB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 06:22:01 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:16318 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3IRKV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 06:21:57 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-16-52397ec40d04
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2 1/6] USB: gadget: s3c-hsotg: fix "protocol stall" handling
Date: Wed, 18 Sep 2013 12:21:30 +0200
Message-id: <1379499695-5279-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
References: <1379499695-5279-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jAd0jdZZBBq8PKltsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGZ9e/WMseMJdMad3FXMD42nOLkZODgkBE4lVX76xQ9hiEhfurWfr
	YuTiEBJYxCjx/fdSKKedSWLR38mMIFVsAjoSW75PALNFBAQk1r+4xA5SxCzwhFFi6pFXYKOE
	BXwlujatBCtiEVCVaFpxlQnE5hVwkZi6bSNQDQfQOgWJOZNsQMKcAq4Su/7cYQWxhYBKZvbP
	Y53AyLuAkWEVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRnBQPZPawbiyweIQowAHoxIP74Vy
	iyAh1sSy4srcQ4wSHMxKIrwuZZZBQrwpiZVVqUX58UWlOanFhxilOViUxHkPtFoHCgmkJ5ak
	ZqemFqQWwWSZODilGhgLPmy9Z7jof97B6U4uDutezpGtXMSV9nnDuxf2R6pC2Zxj3t+1y7f4
	Elq21cODe7Yph8/d2QdKZ1W/vfB1rZD53+m+Ey/MtHY+bxC/ZEVfekO7TP5cS/+TwfPyrt9l
	Npq25tWDan+rX+rSR2/J8/gnuB++/2zZ8j+t2+yueNQ9TlT7fe5dfvkHJZbijERDLeai4kQA
	HFa1ISYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After normal handling of SetupDone interrupt, XferCompl interrupt occurs, and
then we enqueue new setup request. But when ep0 is stalled, there is no
XferCompl, so we have to enqueue setup request immediately after stalling ep.
Otherwise incoming control requests won't be processed correctly.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index dd5524c..c00ce27 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -1146,6 +1146,8 @@ static int s3c_hsotg_process_req_feature(struct s3c_hsotg *hsotg,
 	return 1;
 }
 
+static void s3c_hsotg_enqueue_setup(struct s3c_hsotg *hsotg);
+
 /**
  * s3c_hsotg_process_control - process a control request
  * @hsotg: The device state
@@ -1245,11 +1247,15 @@ static void s3c_hsotg_process_control(struct s3c_hsotg *hsotg,
 		 * don't believe we need to anything more to get the EP
 		 * to reply with a STALL packet
 		 */
+
+		 /*
+		  * complete won't be called, so we enqueue
+		  * setup request here
+		  */
+		 s3c_hsotg_enqueue_setup(hsotg);
 	}
 }
 
-static void s3c_hsotg_enqueue_setup(struct s3c_hsotg *hsotg);
-
 /**
  * s3c_hsotg_complete_setup - completion of a setup transfer
  * @ep: The endpoint the request was on.
-- 
1.7.9.5

