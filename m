Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab3LRKKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 05:10:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53506 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab3LRKK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 05:10:27 -0500
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <stern@rowland.harvard.edu>, <ray.huang@amd.com>, <balbi@ti.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH 2/2] usb: usbtest: Always clear halt else further tests will fail
Date: Wed, 18 Dec 2013 15:40:11 +0530
Message-ID: <1387361411-15139-2-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387361411-15139-1-git-send-email-rogerq@ti.com>
References: <1387361411-15139-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In test_halt() we set an endpoint halt condition and return on halt verification
failure, then the enpoint will remain halted and all further tests related
to that enpoint will fail. This is because we don't tackle endpoint halt error condition
in any of the tests. To avoid that situation, make sure to clear the
halt condition before exiting test_halt().

Signed-off-by: Roger Quadros <rogerq@ti.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/misc/usbtest.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 6294e1b..300b726 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1545,8 +1545,17 @@ static int test_halt(struct usbtest_dev *tdev, int ep, struct urb *urb)
 		return retval;
 	}
 	retval = verify_halted(tdev, ep, urb);
-	if (retval < 0)
+	if (retval < 0) {
+		int ret;
+
+		/* clear halt anyways, else further tests will fail */
+		ret = usb_clear_halt(urb->dev, urb->pipe);
+		if (ret)
+			ERROR(tdev, "ep %02x couldn't clear halt, %d\n",
+			      ep, ret);
+
 		return retval;
+	}
 
 	/* clear halt (tests API + protocol), verify it worked */
 	retval = usb_clear_halt(urb->dev, urb->pipe);
-- 
1.8.3.2

