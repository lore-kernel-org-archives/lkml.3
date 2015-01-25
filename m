Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbbAYSr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:47:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbbAYSKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michael Turquette <mturquette@linaro.org>
Subject: [PATCH 3.18 088/183] clk: Dont try to use a struct clk* after it could have been freed
Date: Sun, 25 Jan 2015 10:06:50 -0800
Message-Id: <20150125180814.009968774@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomeu Vizoso <tomeu.vizoso@collabora.com>

commit 10cdfe54dab034311c8e2fad9ba2dffbe616caa9 upstream.

As __clk_release could call kfree on clk and then we wouldn't have a safe way
of getting the module that owns the clock.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Fixes: fcb0ee6a3d33 ("clk: Implement clk_unregister")
Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Michael Turquette <mturquette@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/clk/clk.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2274,14 +2274,17 @@ int __clk_get(struct clk *clk)
 
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


