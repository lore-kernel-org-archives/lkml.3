Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbaKROVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:21:02 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57177 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbaKROKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 192/206] usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
Date: Tue, 18 Nov 2014 15:09:07 +0100
Message-Id: <19342b6d5f7a7f0d7c8031e9db0b4f833e946f7a.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Balbi <balbi@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 52ec49a5e56a27c5b6f8217708783eff39f24c16 ]

During Halt Endpoint Test, our interrupt endpoint
will be disabled, which will clear out ep->desc
to NULL. Unless we call config_ep_by_speed() again,
we will not be able to enable this endpoint which
will make us fail that test.

Fixes: f9c56cd (usb: gadget: Clear usb_endpoint_descriptor
	inside the struct usb_ep on disable)
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

