Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab3ILOTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:19:45 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15698 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab3ILOTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:19:43 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-58-5231cd7ec746
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 4/6] USB: gadget: s3c-hsotg: fix "protocol stall" handling
Date: Thu, 12 Sep 2013 16:18:50 +0200
Message-id: <1378995532-32142-5-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.10
In-reply-to: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
References: <1378995532-32142-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t9jQd26s4ZBBhN2iFhsnLGe1eLg/XqL
	5sXr2SzONr1ht7i8aw6bxaJlrcwWa4/cZbd4cHgnuwOHx/65a9g9+rasYvQ4fmM7k8fnTXIB
	LFFcNimpOZllqUX6dglcGasf/GYrOM1d0X6mhaWB8RBnFyMnh4SAiUTr+x5WCFtM4sK99Wwg
	tpDAdEaJKXsyuxi5gOwuJok9vT1gCTYBHYkt3ycwgtgiAgIS619cYgcpYhZ4wigx9cgrdpCE
	sICXxLt9z5lAbBYBVYl9X74DNXNw8Aq4SkxvhVomL/H0fh/YTE4BN4m+3evBSoSASiZuTZnA
	yLuAkWEVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnBAPZPewbiqweIQowAHoxIPb+JiwyAh
	1sSy4srcQ4wSHMxKIryfJwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8x5stQ4UEkhPLEnNTk0t
	SC2CyTJxcEo1MMof3Fj2MoK5VpCBdW/CdMWTn+dM8Uj99/30meZvF7Z0Xnrr7zf92ZPrPl6v
	g0x6osJXVE7clfx7Riq/dmnHgYOndrue//HUbaPNt9lSe9pdvzXM2BhoPenb2U+9PvL9E9dV
	MKd/XWGZe0CYf0GCpmSNVHhS1+mzc3org3ofcNqz/7P45OJk4aLEUpyRaKjFXFScCAD72EAh
	JAIAAA==
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
 drivers/usb/gadget/s3c-hsotg.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index dd5524c..c581cd7 100644
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
@@ -1245,11 +1247,12 @@ static void s3c_hsotg_process_control(struct s3c_hsotg *hsotg,
 		 * don't believe we need to anything more to get the EP
 		 * to reply with a STALL packet
 		 */
+
+		 /* complete won't by called, so we enqueue setup request here */
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

