Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932571AbbA0MUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:20:22 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35469 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758748AbbA0MUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:20:14 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Michael Turquette <mturquette@linaro.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 119/126] clk: Don't try to use a struct clk* after it could have been freed
Date: Tue, 27 Jan 2015 12:17:04 +0000
Message-Id: <1422361031-19364-120-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
References: <1422361031-19364-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomeu Vizoso <tomeu.vizoso@collabora.com>

commit 10cdfe54dab034311c8e2fad9ba2dffbe616caa9 upstream.

As __clk_release could call kfree on clk and then we wouldn't have a safe way
of getting the module that owns the clock.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Fixes: fcb0ee6a3d33 ("clk: Implement clk_unregister")
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/clk/clk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 4cc83ef7ef61..1dee8d2086fb 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2234,14 +2234,17 @@ int __clk_get(struct clk *clk)
 
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
2.1.4

