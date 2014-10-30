Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003AbaJ3KvP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 06:51:15 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:44317 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbaJ3KvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 06:51:12 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 2/7] clk: Don't try to use a struct clk* after it could have been freed
Date: Thu, 30 Oct 2014 11:48:28 +0100
Message-Id: <1414666135-14313-3-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1414666135-14313-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1414666135-14313-1-git-send-email-tomeu.vizoso@collabora.com>
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

