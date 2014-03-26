Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbaCZJ2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:28:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:36177 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751045AbaCZJ2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 05:28:25 -0400
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, "3.9+" <stable@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] usb: gadget: zero: Fix SuperSpeed enumeration for alternate setting 1
Date: Wed, 26 Mar 2014 11:28:06 +0200
Message-ID: <1395826086-5097-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was impossible to enumerate on a SuperSpeed (XHCI) host
with alternate setting = 1 due to the wrongly set 'bMaxBurst'
field in the SuperSpeed Endpoint Companion descriptor.

Testcase:
<host> modprobe -r usbtest; modprobe usbtest alt=1
<device> modprobe g_zero
plug device to SuperSpeed port on the host.

Without this patch the host always complains like so
"usb 12-2: Not enough bandwidth for new device state.
 usb 12-2: Not enough bandwidth for altsetting 1"

Bug was introduced by commit cf9a08ae in v3.9

Cc: 3.9+ <stable@vger.kernel.org> # 3.9+
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/gadget/zero.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 9f170c5..134f354 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -300,7 +300,7 @@ static int __init zero_bind(struct usb_composite_dev *cdev)
 	ss_opts->isoc_interval = gzero_options.isoc_interval;
 	ss_opts->isoc_maxpacket = gzero_options.isoc_maxpacket;
 	ss_opts->isoc_mult = gzero_options.isoc_mult;
-	ss_opts->isoc_maxburst = gzero_options.isoc_maxpacket;
+	ss_opts->isoc_maxburst = gzero_options.isoc_maxburst;
 	ss_opts->bulk_buflen = gzero_options.bulk_buflen;
 
 	func_ss = usb_get_function(func_inst_ss);
-- 
1.8.3.2

