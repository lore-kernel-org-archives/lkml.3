Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab3LBUip (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:38:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38822 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754320Ab3LBTOS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:14:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH 3.10 140/173] media: mxl111sf: Dont use dynamic static allocation
Date: Mon,  2 Dec 2013 11:12:03 -0800
Message-Id: <20131202191159.465023779@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <m.chehab@samsung.com>

commit c98300a0e8cf160aaea60bc05d2cd156a7666173 upstream.

Dynamic static allocation is evil, as Kernel stack is too low, and
compilation complains about it on some archs:
	drivers/media/usb/dvb-usb-v2/mxl111sf.c:74:1: warning: 'mxl111sf_ctrl_msg' uses dynamic stack allocation [enabled by default]
Instead, let's enforce a limit for the buffer to be the max size of
a control URB payload data (64 bytes).

Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb-v2/mxl111sf.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -23,6 +23,9 @@
 #include "lgdt3305.h"
 #include "lg2160.h"
 
+/* Max transfer size done by I2C transfer functions */
+#define MAX_XFER_SIZE  64
+
 int dvb_usb_mxl111sf_debug;
 module_param_named(debug, dvb_usb_mxl111sf_debug, int, 0644);
 MODULE_PARM_DESC(debug, "set debugging level "
@@ -63,7 +66,12 @@ int mxl111sf_ctrl_msg(struct dvb_usb_dev
 {
 	int wo = (rbuf == NULL || rlen == 0); /* write-only */
 	int ret;
-	u8 sndbuf[1+wlen];
+	u8 sndbuf[MAX_XFER_SIZE];
+
+	if (1 + wlen > sizeof(sndbuf)) {
+		pr_warn("%s: len=%d is too big!\n", __func__, wlen);
+		return -EOPNOTSUPP;
+	}
 
 	deb_adv("%s(wlen = %d, rlen = %d)\n", __func__, wlen, rlen);
 


