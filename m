Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaJTNln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 09:41:43 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36802 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaJTNl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 09:41:28 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/8] clk: Don't try to use a struct clk* after it could have been freed
Date: Mon, 20 Oct 2014 15:40:03 +0200
Message-Id: <1413812442-24956-4-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1413812442-24956-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As __clk_release could call kfree on clk and then we wouldn't have a safe way
of getting the module that owns the clock.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Fixes: fcb0ee6a3d33 ("clk: Implement clk_unregister")

---

v4:	* Move out module_put from the critical section
	* Add Fixes: tag
---
 drivers/clk/clk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index d0712b7..d2f0fb6 100644
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

