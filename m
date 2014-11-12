Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161197AbaKLB4e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:56:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161161AbaKLB4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:56:30 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.10 114/123] usb: gadget: function: acm: make f_acm pass USB20CV Chapter9
Date: Wed, 12 Nov 2014 10:18:00 +0900
Message-Id: <20141112011724.156626485@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

[ Upstream commit 52ec49a5e56a27c5b6f8217708783eff39f24c16 ]

During Halt Endpoint Test, our interrupt endpoint
will be disabled, which will clear out ep->desc
to NULL. Unless we call config_ep_by_speed() again,
we will not be able to enable this endpoint which
will make us fail that test.

Fixes: f9c56cd (usb: gadget: Clear usb_endpoint_descriptor
	inside the struct usb_ep on disable)
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/f_acm.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/f_acm.c
+++ b/drivers/usb/gadget/f_acm.c
@@ -430,11 +430,12 @@ static int acm_set_alt(struct usb_functi
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
 


