Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbaDGC1A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 22:27:00 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:65512 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaDGC05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 22:26:57 -0400
Message-ID: <53420CEF.5040505@gmail.com>
Date: Sun, 06 Apr 2014 21:26:55 -0500
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] Staging: rtl8192e: Fix declaration of symbols
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two declarations with issues in rtl_wx.h:

  * function: struct iw_statistics *r8192_get_wireless_stats();
  * variable: extern struct iw_handler_def r8192_wx_handlers_def;

The symbol 'r8192_get_wireless_stats' is declared as 'extern'
but it is only used in the local scope. The declaration is deleted
of rtl_wx.h, fixing the conflict with the 'extern' and 'static' scope.

The symbol 'r8192_wx_handlers_def' was fixed of some issues related
to variable declaration marked as 'extern' implicitly,
causing this sparse warning:

drivers/staging/rtl8192e/rtl8192e/rtl_wx.c:1323:24: warning: symbol
'r8192_wx_handlers_def' was not declared. Should it be static?

Resolved incluing the fixed header to rtl_wx.c

Also, isn't declared as constant variable, so it declared as such.
And delete unnecessary cast in rtl_core.c.

Signed-off-by: Joel Pelaez Jorge <joelpelaez@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 3 +--
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c   | 3 ++-
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.h   | 3 +--
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index c01abc2..fa087b6 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2926,8 +2926,7 @@ static int rtl8192_pci_probe(struct pci_dev *pdev,

 	dev->netdev_ops = &rtl8192_netdev_ops;

-	dev->wireless_handlers = (struct iw_handler_def *)
-				 &r8192_wx_handlers_def;
+	dev->wireless_handlers = &r8192_wx_handlers_def;
 	dev->ethtool_ops = &rtl819x_ethtool_ops;

 	dev->type = ARPHRD_ETHER;
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
index 498995d..7d8fcde 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
@@ -19,6 +19,7 @@

 #include <linux/string.h>
 #include "rtl_core.h"
+#include "rtl_wx.h"

 #define RATE_COUNT 12
 static u32 rtl8192_rates[] = {
@@ -1320,7 +1321,7 @@ static struct iw_statistics
*r8192_get_wireless_stats(struct net_device *dev)
 	return wstats;
 }

-struct iw_handler_def  r8192_wx_handlers_def = {
+const struct iw_handler_def r8192_wx_handlers_def = {
 	.standard = r8192_wx_handlers,
 	.num_standard = ARRAY_SIZE(r8192_wx_handlers),
 	.private = r8192_private_handler,
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
index 6a51a25..5839851 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.h
@@ -24,8 +24,7 @@ struct net_device;
 struct iw_handler_def;
 struct iw_statistics;

-extern struct iw_handler_def r8192_wx_handlers_def;
-struct iw_statistics *r8192_get_wireless_stats(struct net_device *dev);
+extern const struct iw_handler_def r8192_wx_handlers_def;
 u16 rtl8192_11n_user_show_rates(struct net_device *dev);

 #endif
-- 
1.9.1


