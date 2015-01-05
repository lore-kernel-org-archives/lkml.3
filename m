Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbbAEJwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:52:51 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34679 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbbAEJwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:52:49 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-09-54aa5eefdec3
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kukjin Kim <kgene@kernel.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/2] clk: exynos-audss: Fix memory leak on driver unbind or
 probe failure
Date: Mon, 05 Jan 2015 10:52:41 +0100
Message-id: <1420451561-12360-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420451561-12360-1-git-send-email-k.kozlowski@samsung.com>
References: <1420451561-12360-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgluLIzCtJLcpLzFFi42I5/e/4Fd33catCDI480rZ4/cLQov/xa2aL
	TY+vsVpc3jWHzWLG+X1MFk8nXGSzOPymndXix5luFotVu/4wOnB6XO7rZfLYOesuu8emVZ1s
	Hneu7WHz2Lyk3qNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgyDvzawFJwS6CisX8BWwPjJ94u
	Rk4OCQETidu3N7BB2GISF+6tB7K5OIQEljJKzJ7+nBXC6WOS2PDgMStIFZuAscTm5UvAqkQE
	NjJJ9OxbwA6SYBYwlPj57g+YLSwQLbGq/z9YA4uAqsTUBT/B4rwC7hJ/9ryBWicncfLYZLAa
	TgEPid0/XgPVcABtc5f4OFFzAiPvAkaGVYyiqaXJBcVJ6bmGesWJucWleel6yfm5mxghofdl
	B+PiY1aHGAU4GJV4eD1OrAwRYk0sK67MPcQowcGsJMK77hZQiDclsbIqtSg/vqg0J7X4ECMT
	B6dUA6O5mG30AYXc+dNmNzKcYvgqKHFqiqbu4e3br7lknDDMSVt5+2LZrfuvdr2siJTtbk5f
	w9b2isv1qfOzsjjDBvfyqb+Crf5sndg+OdVx19o9TYcW3bxhzTztjaCM3/qXNbHrmmumrNzE
	Hn7ffbuN3i+OnSFud9OKTTkj1m6/e8Y9fd0VbjX7GDYlluKMREMt5qLiRABV3kZaGwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The memory allocated by basic clock divider/gate/mux (struct clk_gate,
clk_divider and clk_mux) was leaking. During driver unbind or probe
failure the driver only unregistered the clocks.

Use clk_unregister_{gate,divider,mux} to release all resources.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/clk/samsung/clk-exynos-audss.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/clk/samsung/clk-exynos-audss.c b/drivers/clk/samsung/clk-exynos-audss.c
index f2c2ccce49bb..454b02ae486a 100644
--- a/drivers/clk/samsung/clk-exynos-audss.c
+++ b/drivers/clk/samsung/clk-exynos-audss.c
@@ -82,6 +82,26 @@ static const struct of_device_id exynos_audss_clk_of_match[] = {
 	{},
 };
 
+static void exynos_audss_clk_teardown(void)
+{
+	int i;
+
+	for (i = EXYNOS_MOUT_AUDSS; i < EXYNOS_DOUT_SRP; i++) {
+		if (!IS_ERR(clk_table[i]))
+			clk_unregister_mux(clk_table[i]);
+	}
+
+	for (; i < EXYNOS_SRP_CLK; i++) {
+		if (!IS_ERR(clk_table[i]))
+			clk_unregister_divider(clk_table[i]);
+	}
+
+	for (; i < clk_data.clk_num; i++) {
+		if (!IS_ERR(clk_table[i]))
+			clk_unregister_gate(clk_table[i]);
+	}
+}
+
 /* register exynos_audss clocks */
 static int exynos_audss_clk_probe(struct platform_device *pdev)
 {
@@ -219,10 +239,7 @@ static int exynos_audss_clk_probe(struct platform_device *pdev)
 	return 0;
 
 unregister:
-	for (i = 0; i < clk_data.clk_num; i++) {
-		if (!IS_ERR(clk_table[i]))
-			clk_unregister(clk_table[i]);
-	}
+	exynos_audss_clk_teardown();
 
 	if (!IS_ERR(epll))
 		clk_disable_unprepare(epll);
@@ -232,18 +249,13 @@ unregister:
 
 static int exynos_audss_clk_remove(struct platform_device *pdev)
 {
-	int i;
-
 #ifdef CONFIG_PM_SLEEP
 	unregister_syscore_ops(&exynos_audss_clk_syscore_ops);
 #endif
 
 	of_clk_del_provider(pdev->dev.of_node);
 
-	for (i = 0; i < clk_data.clk_num; i++) {
-		if (!IS_ERR(clk_table[i]))
-			clk_unregister(clk_table[i]);
-	}
+	exynos_audss_clk_teardown();
 
 	if (!IS_ERR(epll))
 		clk_disable_unprepare(epll);
-- 
1.9.1

