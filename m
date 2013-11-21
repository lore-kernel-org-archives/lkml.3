Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193Ab3KUMt7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 07:49:59 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:21738 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754060Ab3KUMt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 07:49:57 -0500
X-AuditID: cbfee61a-b7f836d0000025d7-bf-528e01743c64
From: Robert Baldyga <r.baldyga@samsung.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, andrzej.p@samsung.com,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] USB: gadget: s3c-hsotg: fix spinlock locking
Date: Thu, 21 Nov 2013 13:49:17 +0100
Message-id: <1385038158-20151-2-git-send-email-r.baldyga@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1385038158-20151-1-git-send-email-r.baldyga@samsung.com>
References: <1385038158-20151-1-git-send-email-r.baldyga@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKLMWRmVeSWpSXmKPExsVy+t9jQd0Sxr4gg7+tGhazXrazWGycsZ7V
	4uD9eovmxevZLM42vWG3uLxrDpvFomWtzBZrj9xlt3hweCe7A6fH/rlr2D36tqxi9Dh+YzuT
	x+dNcgEsUVw2Kak5mWWpRfp2CVwZ91Z+YypYx1lxq/kuUwPjPfYuRk4OCQETiZPH1rBA2GIS
	F+6tZ+ti5OIQEpjOKNHwZjMbSEJIoJ1Jom+/MYjNJqAjseX7BEYQW0RAQGL9i0vsIA3MAn8Z
	JW4/7ARq4OAQFnCU2POmHMRkEVCVmNzkClLOK+AqsWfvUnaQsISAgsScSTYgYU4BN4mpp56y
	Q2xyldh6+jHLBEbeBYwMqxhFUwuSC4qT0nMN9YoTc4tL89L1kvNzNzGCA+uZ1A7GlQ0WhxgF
	OBiVeHg7HvcECbEmlhVX5h5ilOBgVhLhjfzYGyTEm5JYWZValB9fVJqTWnyIUZqDRUmc90Cr
	daCQQHpiSWp2ampBahFMlomDU6qBkTnjW/+5P8ulZn0ueOBh6XVObJHq59yKv98LGJSkNfS5
	Y2ftPNfDrOIi5nCYYW5uR5amRKnfRpkDXx8wfMmwtJu65tvTfc4r1m9MLPoV5GUqZ1nzctps
	E6MffHM99x/NnHRD7OQilhaVwKqnP+WrNaJmLOe+l2mlwtgr4swrYb3igUHrNIaFSizFGYmG
	WsxFxYkAIlJghSgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missing spinlock locking in s3c_hsotg_complete_setup function,
and unlocking for gadget setup call.

Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/gadget/s3c-hsotg.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 0646587..f709b13 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -1245,7 +1245,9 @@ static void s3c_hsotg_process_control(struct s3c_hsotg *hsotg,
 	/* as a fallback, try delivering it to the driver to deal with */
 
 	if (ret == 0 && hsotg->driver) {
+		spin_unlock(&hsotg->lock);
 		ret = hsotg->driver->setup(&hsotg->gadget, ctrl);
+		spin_lock(&hsotg->lock);
 		if (ret < 0)
 			dev_dbg(hsotg->dev, "driver->setup() ret %d\n", ret);
 	}
@@ -1308,10 +1310,12 @@ static void s3c_hsotg_complete_setup(struct usb_ep *ep,
 		return;
 	}
 
+	spin_lock(&hsotg->lock);
 	if (req->actual == 0)
 		s3c_hsotg_enqueue_setup(hsotg);
 	else
 		s3c_hsotg_process_control(hsotg, req->buf);
+	spin_unlock(&hsotg->lock);
 }
 
 /**
-- 
1.7.9.5

