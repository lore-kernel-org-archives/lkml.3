Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbaLBH4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 02:56:12 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:40700 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933023AbaLBH4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 02:56:04 -0500
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v7 2/7] clk: Don't try to use a struct clk* after it could have been freed
Date: Tue,  2 Dec 2014 08:54:19 +0100
Message-Id: <1417506933-8915-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1417506933-8915-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As __clk_release could call kfree on clk and then we wouldn't have a safe way
of getting the module that owns the clock.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Fixes: fcb0ee6a3d33 ("clk: Implement clk_unregister")
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

---

v4:	* Move out module_put from the critical section
	* Add Fixes: tag
---
 drivers/clk/clk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 42f940f..609e9db 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2268,14 +2268,17 @@ int __clk_get(struct clk *clk)
 
 void __clk_put(struct clk *clk)
 {
+	struct module *owner;
+
 	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
 		return;
 
 	clk_prepare_lock();
+	owner = clk->owner;
 	kref_put(&clk->ref, __clk_release);
 	clk_prepare_unlock();
 
-	module_put(clk->owner);
+	module_put(owner);
 }
 
 /***        clk rate change notifiers        ***/
-- 
1.9.3

