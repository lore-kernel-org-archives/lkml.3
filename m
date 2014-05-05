Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679AbaEEM4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:56:36 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:40983 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932256AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 07/50] usbatm: Fix dynamic_debug / ratelimited atm_dbg and atm_rldbg macros
Date: Mon,  5 May 2014 14:42:49 +0200
Message-Id: <1b667c7507f5a34d4f4d2a18c63ebba0139a6d70.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 32e24930fb71c47a1366325b6f139e039cacaca4 upstream.

Fix atm_dbg to use normal pr_debug not dynamic_pr_debug
because dynamic_pr_debug may not be compiled in at all.

Signed-off-by: Joe Perches <joe@perches.com>
Tested-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/atm/usbatm.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/atm/usbatm.h b/drivers/usb/atm/usbatm.h
index 5651231a7437..f3eecd967a8a 100644
--- a/drivers/usb/atm/usbatm.h
+++ b/drivers/usb/atm/usbatm.h
@@ -34,6 +34,7 @@
 #include <linux/stringify.h>
 #include <linux/usb.h>
 #include <linux/mutex.h>
+#include <linux/ratelimit.h>
 
 /*
 #define VERBOSE_DEBUG
@@ -59,13 +60,12 @@
 	atm_printk(KERN_INFO, instance , format , ## arg)
 #define atm_warn(instance, format, arg...)	\
 	atm_printk(KERN_WARNING, instance , format , ## arg)
-#define atm_dbg(instance, format, arg...)		\
-	dynamic_pr_debug("ATM dev %d: " format ,	\
-	(instance)->atm_dev->number , ## arg)
-#define atm_rldbg(instance, format, arg...)		\
-	if (printk_ratelimit())				\
-		atm_dbg(instance , format , ## arg)
-
+#define atm_dbg(instance, format, ...)					\
+	pr_debug("ATM dev %d: " format,					\
+		 (instance)->atm_dev->number, ##__VA_ARGS__)
+#define atm_rldbg(instance, format, ...)				\
+	pr_debug_ratelimited("ATM dev %d: " format,			\
+			     (instance)->atm_dev->number, ##__VA_ARGS__)
 
 /* flags, set by mini-driver in bind() */
 
-- 
1.9.2

