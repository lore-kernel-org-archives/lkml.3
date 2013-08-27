Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab3H0Orn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:47:43 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27176 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753190Ab3H0Orm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:47:42 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f0a6d000007b1b-5c-521cbc0d0bfa
Content-transfer-encoding: 8BIT
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: sarah.a.sharp@linux.intel.com, gregkh@linuxfoundation.org
Cc: dmitry.kasatkin@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCHv2 1/2] dev-core: fix build break when DEBUG is enabled
Date: Tue, 27 Aug 2013 17:47:34 +0300
Message-id: <7f53397d0aa93e644124037d44188da5067336fc.1377614854.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4VV3ePTJBBgt2c1l8WVpn0bx4PZvF
	5V1z2CyaT5xidmDx2DnrLrvHvJOBHvvnrmH3+LxJLoAlissmJTUnsyy1SN8ugSvjwK2ZbAU7
	xCt+Xd3P1sC4TLiLkZNDQsBE4vnUP6wQtpjEhXvr2UBsIYGljBIPd+WA2LwCghI/Jt9j6WLk
	4GAWkJc4cikbJMwsoC4xad4i5i5GLqDyTiaJpTea2EESbAJ6Ehuaf4DZIgK2El/vHWSGaLCW
	WNT4mwXEFhZwk1j16R3YLhYBVYmGE60sELviJGbsf8MEcY+CxM/LJ9gmMPLNQnLGLIQzZiE5
	YwEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkCD8soNx8TGrQ4wCHIxKPLwWm2WChFgT
	y4orcw8xSnAwK4nw7l4BFOJNSaysSi3Kjy8qzUktPsTIxMEp1cBoKRx2b5PEeuc3hmJaXwMO
	ah+/7li6v936mq+5r6nM06NPbS52KF4tOO+35K73pTPqKcZP7iSaP321VPp2gI/rg2WTz2ok
	Wbt6+Ycr+v06IPv0O8uSB7XPKzrLNnS3tTjuaD36nP/j7IO76k/ltYp2m+yxU423e2q2n1/y
	N39ZuXfQwr/Pdp1SYinOSDTUYi4qTgQAJF/DiiACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When DEBUG is defined, dev_dbg_ratelimited uses dynamic debug data
structures even when CONFIG_DYNAMIC_DEBUG is not defined.
It leads to build break.
For example, when I try to use dev_dbg_ratelimited in USB code and
CONFIG_USB_DEBUG is enabled, but CONFIG_DYNAMIC_DEBUG is not, I get:

  CC [M]  drivers/usb/host/xhci-ring.o
  drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_intr_tx’:
  drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘DEFINE_DYNAMIC_DEBUG_METADATA’ [-Werror=implicit-function-declaration]
  drivers/usb/host/xhci-ring.c:3059:3: error: ‘descriptor’ undeclared (first use in this function)
  drivers/usb/host/xhci-ring.c:3059:3: note: each undeclared identifier is reported only once for each function it appears in
  drivers/usb/host/xhci-ring.c:3059:3: error: implicit declaration of function ‘__dynamic_pr_debug’ [-Werror=implicit-function-declaration]
  drivers/usb/host/xhci-ring.c: In function ‘xhci_queue_isoc_tx_prepare’:
  drivers/usb/host/xhci-ring.c:3847:3: error: ‘descriptor’ undeclared (first use in this function)
  cc1: some warnings being treated as errors
  make[2]: *** [drivers/usb/host/xhci-ring.o] Error 1
  make[1]: *** [drivers/usb/host] Error 2
  make: *** [drivers/usb/] Error 2

This patch separates definition for CONFIG_DYNAMIC_DEBUG and DEBUG cases.

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
---
 include/linux/device.h | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 22b546a..d336beb 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1099,17 +1099,28 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
-#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
 do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
 				      DEFAULT_RATELIMIT_INTERVAL,	\
 				      DEFAULT_RATELIMIT_BURST);		\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	/* descriptor check is first to prevent flooding with		\
+	   "callbacks suppressed" */					\
 	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
 	    __ratelimit(&_rs))						\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
-				   ##__VA_ARGS__);			\
+		__dynamic_dev_dbg(&descriptor, dev, fmt,		\
+				  ##__VA_ARGS__);			\
+} while (0)
+#elif defined(DEBUG)
+#define dev_dbg_ratelimited(dev, fmt, ...)				\
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))						\
+		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 } while (0)
 #else
 #define dev_dbg_ratelimited(dev, fmt, ...)			\
-- 
1.8.1.2

