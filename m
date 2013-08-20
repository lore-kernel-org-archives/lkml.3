Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883Ab3HTCEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:04:42 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:55974 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764Ab3HTCEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:04:34 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [RFC 01/17] clk: ensure __clk_of_table is only initialized once
Date: Tue, 20 Aug 2013 04:04:15 +0200
Message-Id: <1376964271-22715-2-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch ensures DT clock providers are only initialized once by
using a static bool that is set after first call to of_clk_init().

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/clk/clk.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 56a00db..0a8a750 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -2117,9 +2117,15 @@ EXPORT_SYMBOL_GPL(of_clk_get_parent_name);
 void __init of_clk_init(const struct of_device_id *matches)
 {
 	struct device_node *np;
+	static bool table_done;
 
-	if (!matches)
+	if (!matches) {
+		/* init __clk_of_table drivers only once */
+		if (table_done)
+			return;
 		matches = __clk_of_table;
+		table_done = true;
+	}
 
 	for_each_matching_node(np, matches) {
 		const struct of_device_id *match = of_match_node(matches, np);
-- 
1.7.10.4

