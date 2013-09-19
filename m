Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab3ISJus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 05:50:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57991 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921Ab3ISJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 05:50:43 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-0b-523ac8f2fce8
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v3 1/7] USB: gadget: s3c-hsotg: fix "protocol stall" handling
Date: Thu, 19 Sep 2013 11:50:17 +0200
Message-id: <1379584223-15232-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
References: <1379584223-15232-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t9jQd1PJ6yCDHreClhsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGZ9e/WMseMJdMad3FXMD42nOLkZODgkBE4nPV9YyQdhiEhfurWfr
	YuTiEBKYziix68hJVginnUni7I01YFVsAjoSW75PYASxRQQEJNa/uMQOUsQs8IRRYuqRV+wg
	CWEBX4n+pq9sIDaLgKrExpcHmUFsXgFXiUfLTwE1cwCtU5CYM8kGJMwp4CYx8fxrFhBbCKjk
	8aYvbBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECA6qZ9I7GFc1WBxiFOBgVOLh
	jbhgGSTEmlhWXJl7iFGCg1lJhHfOIasgId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rwHW60DhQTS
	E0tSs1NTC1KLYLJMHJxSDYwcnlLqOu+e7Fcq/v2IlWnjvim1Zw6GC4maaws+Zy58eCR2x6fS
	Tl6bDK8r8/1tmaqO68nnay8WNp6x/NsV79Dbecd4mJwfHMpU++mt47icQajq0cVLUraX2zu/
	ZfB9DPyV5/LG+26h7qqWI8Ki/7ZMsKx6t/9TlQxjU461plirY5iW120FdiWW4oxEQy3mouJE
	AOjPN2YmAgAA
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

