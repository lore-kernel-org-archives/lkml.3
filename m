Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888Ab3HOQFL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 12:05:11 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:12350 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab3HOQFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 12:05:09 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f5f6d00000105f-0a-520cfc33da49
Content-transfer-encoding: 8BIT
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com
Cc: dmitry.kasatkin@gmail.com, stable@vger.kernel.org
Subject: [PATCH 1/2] dev-core: fix build break when DEBUG is enabled
Date: Thu, 15 Aug 2013 19:04:54 +0300
Message-id: <71bb3fcd9f1a99aa7bd8f6dd1fb6267173db51d2.1376582695.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xy7rGf3iCDLZcZrf4srTOonnxejaL
	y7vmsFk0nzjFbLFg4yNGB1aPnbPusnvMOxnosX/uGnaPz5vkAliiuGxSUnMyy1KL9O0SuDLa
	zlxmLbgiXvF9zx+2Bsb9wl2MnBwSAiYSh1duZYOwxSQu3FsPZHNxCAksZZTYP+8YE0iCV0BQ
	4sfkeyxdjBwczALyEkcuZYOEmQXUJSbNW8QMUd/JJNH/vpkFJMEmoCexofkHO4gtIhAr8ej8
	EkaIBlOJXf93s4LYwgIuEr2tl8DiLAKqEo93tEHtipN4dvooC8RBChI/L59gm8DINwvJGbMQ
	zpiF5IwFjMyrGEVTS5MLipPSc430ihNzi0vz0vWS83M3MUIC8usOxqXHrA4xCnAwKvHwRrRx
	BwmxJpYVV+YeYpTgYFYS4f16jydIiDclsbIqtSg/vqg0J7X4ECMTB6dUA6Pt/J4mQ50SFtef
	L3PvTXlS0yZ6ZLXRAfVLLa8k7FkKs5f8E5Yt5XPteh28aMk0lqxZjmdXLJGcLnx4aXHhA/cp
	E7n5r1a/7PDY8f7bbcGOR681lhioph8rVJrHV/nqk5VVPPvnHxV+7CsZdjwLW2+7a5nIXqGP
	abmzZ8YeCvi49KmllEB/S6wSS3FGoqEWc1FxIgBcCxEQJgIAAA==
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
Cc: stable@vger.kernel.org
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

