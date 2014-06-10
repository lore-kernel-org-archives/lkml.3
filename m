Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaFJSKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 14:10:32 -0400
Received: from smtp.outflux.net ([198.145.64.163]:60498 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbaFJSKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 14:10:31 -0400
Date: Tue, 10 Jun 2014 11:10:03 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gulsah Kose <gulsah.1004@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        devel@driverdev.osuosl.org
Subject: [PATCH] staging: r8192ee: avoid leaking format string
Message-ID: <20140610181003.GA17732@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes sure a format string cannot leak into the work queue name nor
the printk buffer.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/staging/rtl8192ee/base.c                   |    2 +-
 drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192ee/base.c b/drivers/staging/rtl8192ee/base.c
index 64ade216a153..a7c69f704623 100644
--- a/drivers/staging/rtl8192ee/base.c
+++ b/drivers/staging/rtl8192ee/base.c
@@ -469,7 +469,7 @@ static void _rtl_init_deferred_work(struct ieee80211_hw *hw)
 		    rtl92e_easy_concurrent_retrytimer_callback, (unsigned long)hw);
 	/* <2> work queue */
 	rtlpriv->works.hw = hw;
-	rtlpriv->works.rtl_wq = alloc_workqueue(rtlpriv->cfg->name, 0, 0);
+	rtlpriv->works.rtl_wq = alloc_workqueue("%s", 0, 0, rtlpriv->cfg->name);
 	INIT_DELAYED_WORK(&rtlpriv->works.watchdog_wq,
 			  (void *)rtl92e_watchdog_wq_callback);
 	INIT_DELAYED_WORK(&rtlpriv->works.ips_nic_off_wq,
diff --git a/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h b/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h
index c0a4286430a5..1231b16205f2 100644
--- a/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h
+++ b/drivers/staging/rtl8192ee/btcoexist/halbtcoutsrc.h
@@ -94,7 +94,7 @@ extern u32 btc_92edbg_type[];
 
 
 #define	CL_SPRINTF	snprintf
-#define	CL_PRINTF	printk
+#define	CL_PRINTF(buf)	printk("%s", buf)
 
 #define	BTC_PRINT(dbgtype, dbgflag, printstr, ...)		\
 	do {							\
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
