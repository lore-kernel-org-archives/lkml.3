Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaKFXCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:02:54 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58882 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752845AbaKFWme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:42:34 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felipe Balbi <balbi@ti.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 115/162] usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
Date: Thu,  6 Nov 2014 14:36:19 -0800
Message-Id: <1415313426-9622-116-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/gadget/f_acm.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/f_acm.c b/drivers/usb/gadget/f_acm.c
index ab1065a..d3d7d1b 100644
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
+		if (acm->notify->desc)
 			if (config_ep_by_speed(cdev->gadget, f, acm->notify))
 				return -EINVAL;
-		}
+
 		usb_ep_enable(acm->notify);
 		acm->notify->driver_data = acm;
 
-- 
1.9.1

