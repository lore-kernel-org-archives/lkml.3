Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaKKLk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:40:57 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57590 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbaKKLKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 098/170] usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
Date: Tue, 11 Nov 2014 11:07:37 +0000
Message-Id: <1415704129-12709-99-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 52ec49a5e56a27c5b6f8217708783eff39f24c16 upstream.

During Halt Endpoint Test, our interrupt endpoint
will be disabled, which will clear out ep->desc
to NULL. Unless we call config_ep_by_speed() again,
we will not be able to enable this endpoint which
will make us fail that test.

Fixes: f9c56cd (usb: gadget: Clear usb_endpoint_descriptor
	inside the struct usb_ep on disable)
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backported to 3.16: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/gadget/f_acm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index ab1065afbbd0..3384486c2884 100644
--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -430,11 +430,12 @@ static int acm_set_alt(struct usb_function *f, unsigned intf, unsigned alt)
 		if (acm->notify->driver_data) {
 			VDBG(cdev, "reset acm control interface %d\n", intf);
 			usb_ep_disable(acm->notify);
-		} else {
-			VDBG(cdev, "init acm ctrl interface %d\n", intf);
+		}
+
+		if (!acm->notify->desc)
 			if (config_ep_by_speed(cdev->gadget, f, acm->notify))
 				return -EINVAL;
-		}
+
 		usb_ep_enable(acm->notify);
 		acm->notify->driver_data = acm;
 
-- 
2.1.0

