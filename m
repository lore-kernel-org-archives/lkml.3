Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbaD0RL2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:11:28 -0400
Received: from smtp2-g21.free.fr ([212.27.42.2]:22046 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754539AbaD0RLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:11:23 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH 2/2] staging/rtl8192e: userspace ptr deref + incorrect declarations
Date: Sun, 27 Apr 2014 19:11:16 +0200
Message-Id: <1398618676-31095-2-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1398618676-31095-1-git-send-email-domdevlin@free.fr>
References: <1398618676-31095-1-git-send-email-domdevlin@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. userspace pointer dereference ;
. missing inclusions of needed header files ;
. unrequired static function declaration (confusing another *.c file).

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
I submit this patch as a result for Task #16 of the Eudyptula Challenge.

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 498995d..d87cdfa 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -17,8 +17,10 @@
  * wlanfae <wlanfae@realtek.com>
 ******************************************************************************/
 
+#include <linux/uaccess.h>
 #include <linux/string.h>
 #include "rtl_core.h"
+#include "rtl_wx.h"
 
 #define RATE_COUNT 12
 static u32 rtl8192_rates[] = {
@@ -1130,11 +1132,18 @@ static int r8192_wx_set_PromiscuousMode(struct net_device *dev,
 	struct r8192_priv *priv = rtllib_priv(dev);
 	struct rtllib_device *ieee = priv->rtllib;
 
-	u32 *info_buf = (u32 *)(wrqu->data.pointer);
+	u32 info_buf[3];
 
-	u32 oid = info_buf[0];
-	u32 bPromiscuousOn = info_buf[1];
-	u32 bFilterSourceStationFrame = info_buf[2];
+	u32 oid;
+	u32 bPromiscuousOn;
+	u32 bFilterSourceStationFrame;
+
+	if (copy_from_user(info_buf, wrqu->data.pointer, sizeof(info_buf)))
+		return -EFAULT;
+
+	oid = info_buf[0];
+	bPromiscuousOn = info_buf[1];
+	bFilterSourceStationFrame = info_buf[2];
 
 	if (OID_RT_INTEL_PROMISCUOUS_MODE == oid) {
 		ieee->IntelPromiscuousModeInfo.bPromiscuousOn =
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
index 6a51a25..6437664 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
@@ -25,7 +25,6 @@ struct iw_handler_def;
 struct iw_statistics;
 
 extern struct iw_handler_def r8192_wx_handlers_def;
-struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev);
 u16 rtl8192_11n_user_show_rates(struct net_device *dev);
 
 #endif
