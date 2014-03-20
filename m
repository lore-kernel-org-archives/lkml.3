Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124AbaCTXnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 19:43:07 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759420AbaCTXnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 19:43:05 -0400
From: Richard Weinberger <richard@nod.at>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH] staging/rtl8821ae: Fix OOM handling in _rtl_init_deferred_work()
Date: Fri, 21 Mar 2014 00:42:54 +0100
Message-Id: <1395358974-25474-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_workqueue() can fail, handle this case.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/staging/rtl8821ae/base.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8821ae/base.c b/drivers/staging/rtl8821ae/base.c
index fce9c3f..8dbe13c 100644
--- a/drivers/staging/rtl8821ae/base.c
+++ b/drivers/staging/rtl8821ae/base.c
@@ -388,7 +388,7 @@ static void _rtl_init_mac80211(struct ieee80211_hw *hw)
 
 }
 
-static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
+static int _rtl_init_deferred_work(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
@@ -410,6 +410,9 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	rtlpriv->works.rtl_wq = create_workqueue(rtlpriv->cfg->name);
 #endif
 /*<delete in kernel end>*/
+	if (!rtlpriv->works.rtl_wq)
+		return -ENOMEM;
+
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
@@ -421,6 +424,8 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 	INIT_DELAYED_WORK(&rtlpriv->works.fwevt_wq,
 			  (void *)rtl_fwevt_wq_callback);
 
+	return 0;
+
 }
 
 void rtl_deinit_deferred_work(struct ieee80211_hw *hw)
@@ -519,7 +524,8 @@ int rtl_init_core(struct ieee80211_hw *hw)
 	INIT_LIST_HEAD(&rtlpriv->entry_list);
 
 	/* <6> init deferred work */
-	_rtl_init_deferred_work(hw);
+	if (_rtl_init_deferred_work(hw))
+		return 1;
 
 	/* <7> */
 #ifdef VIF_TODO
-- 
1.8.1.4

