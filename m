Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3H1Rud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:50:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:27689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3H1Ruc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,977,1367996400"; 
   d="scan'208";a="369874210"
Date: Wed, 28 Aug 2013 10:50:31 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Jason Baron <jbaron@akamai.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH v3 1/1] dev-core: fix build break when DEBUG is enabled
Message-ID: <20130828175031.GA26807@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACE9dm_msF7e2aKEeT0J6maxnka1NpaAbTWTp5r1MbpDHSw4Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any objections to queuing this patch through Greg's usb-next tree?  I've
already sent the 2/2 patch, which will cause build breakage without this
patch.

Changes since v2:
 - Fixed a checkpatch warning caused by a comment in a macro.

Sarah Sharp

>8----------------------------------------------------------------8<

From: Dmitry Kasatkin <d.kasatkin@samsung.com>

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

[Note, Sarah moved the comment above the macro to avoid checkpatch
warnings.]

Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
---
 include/linux/device.h | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 22b546a..7d960d5 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1099,7 +1099,8 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
-#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
+#if defined(CONFIG_DYNAMIC_DEBUG)
+/* descriptor check is first to prevent flooding with "callbacks suppressed" */
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
 do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
@@ -1108,8 +1109,17 @@ do {									\
 	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
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
1.8.3.3

