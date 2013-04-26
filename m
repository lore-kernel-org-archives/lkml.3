Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3DZXkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 19:40:05 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:44682 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755890Ab3DZXkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 19:40:03 -0400
From: Olof Johansson <olof@lixom.net>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH] clk: add option to keep boot clocks on
Date: Fri, 26 Apr 2013 16:39:51 -0700
Message-Id: <1367019591-31685-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is primarily useful when there's a driver that doesn't claim clocks
properly, but the bootloader does. It's not expected to be used in normal
cases, but for bringup and debug it's very useful to have the option to
not gate unclaimed clocks that are still on.

Signed-off-by: Olof Johansson <olof@lixom.net>
---

Mike, this is a pretty trivial patch that I would love to see in 3.10
even though it's getting late. I'm definitely not picky about the naming
of the boot option, so feel free to change it.


-Olof

 drivers/clk/clk.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 20ce67f..b22551e 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -499,10 +499,24 @@ out:
 	return;
 }
 
+
+static bool keep_boot_clocks;
+static int __init clk_keep_boot_clocks(char *__unused)
+{
+	keep_boot_clocks = true;
+	return 1;
+}
+__setup("clk_keep_boot_clocks", clk_keep_boot_clocks);
+
 static int clk_disable_unused(void)
 {
 	struct clk *clk;
 
+	if (keep_boot_clocks) {
+		pr_warn("clk: Not disabling unused clocks\n");
+		return 0;
+	}
+
 	clk_prepare_lock();
 
 	hlist_for_each_entry(clk, &clk_root_list, child_node)
-- 
1.8.1.192.gc4361b8

