Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaESRZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:25:15 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:53552 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaESRZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:25:13 -0400
X-AuditID: cbfee61b-b7fbb6d000001be3-74-537a3e76cf88
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        mturquette@linaro.org
Cc: linux@arm.linux.org.uk, robh+dt@kernel.org, grant.likely@linaro.org,
        mark.rutland@arm.com, galak@codeaurora.org, pawel.moll@arm.com,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH/RFC V6 1/2] clk: Add of_clk_get_by_clkspec() helper
Date: Mon, 19 May 2014 19:22:50 +0200
Message-id: <1400520171-6698-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
References: <1400520171-6698-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t9jAd1yu6pggx2LWC3mHznHatH/ZiGr
	xYE/Oxgtzja9YbfY9Pgaq8XlXXPYLG5f5rVYe+Quu8XS6xeZLJ5OuMhmMWH6WhaL1r1H2C0O
	v2lntZgx+SWbxfoZr1kc+D3WzFvD6NHS3MPmcbmvl8lj06pONo871/aweWxeUu/Rt2UVo8fn
	TXIBHFFcNimpOZllqUX6dglcGb/XX2EtmCla0XiwroHxiGAXIyeHhICJxLLt89ghbDGJC/fW
	s3UxcnEICSxilGh6eJEVwulgkvi6rp0NpIpNwFCi92gfI4gtIhArseHZXkaQImaB3UwS6z8d
	Aepg5xAWcJZYWAZSwiKgKnG//yUriM0r4Cox7cEjpi5GDqBlChJzJtmAhDkF3CSevpnGChIW
	Aio598BjAiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBgftMegfjqgaLQ4wCHIxK
	PLwHxKuChVgTy4orcw8xSnAwK4nwupkAhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJI
	TyxJzU5NLUgtgskycXBKNTAqPXduTI5mj+D0+iD121PPYMN9H33lkDficXNuSl7OjNy38Nnm
	P3MD9F5umX9TmHPfLnu2BG6ZZXcXWPxz/O0rf7huZkuejojUGVt93TMV821TeT682Dl3ZYyZ
	asSVuoOyX2s9z4dcX6R+z2D9WlaN8zL7H2x8dlHw1sW3aUb3C2bd9Zry+w2DEktxRqKhFnNR
	cSIAB2426lgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds of_clk_get_by_clkspec() helper function, which does only
a struct clk lookup from the clock providers. It is used in the subsequent
patch where parsing of a clock from device tree and the lookup from
providers needed to be split.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
Changes since v5:
 - dropped of_clk_get_by_property(), added of_clk_get_by_clkspec().

Changes since v4:
 - none.

Changes since v3:
 - added missing 'static inline' to the function stub definition.

Changes since v2:
 - moved the function declaration from drivers/clk/clk.h to
   include/linux/clk.h

Changes since v1:
 - s/of_clk_get_list_entry/of_clk_get_by_property.
---
 drivers/clk/clk.h    |    1 +
 drivers/clk/clkdev.c |   34 +++++++++++++++++++++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index 795cc9f..c798138 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -10,6 +10,7 @@
  */

 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
+struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
 struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
 void of_clk_lock(void);
 void of_clk_unlock(void);
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index a360b2e..f890b90 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -27,6 +27,32 @@ static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);

 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
+
+/**
+ * of_clk_get_by_clkspec() - Lookup a clock form a clock provider
+ * @clkspec: pointer to a clock specifier data structure
+ *
+ * This function looks up a struct clk from the registered list of clock
+ * providers, an input is a clock specifier data structure as returned
+ * from the of_parse_phandle_with_args() function call.
+ */
+struct clk *of_clk_get_by_clkspec(struct of_phandle_args *clkspec)
+{
+	struct clk *clk;
+
+	if (!clkspec)
+		return ERR_PTR(-EINVAL);
+
+	of_clk_lock();
+	clk = __of_clk_get_from_provider(clkspec);
+
+	if (!IS_ERR(clk) && !__clk_get(clk))
+		clk = ERR_PTR(-ENOENT);
+
+	of_clk_unlock();
+	return clk;
+}
+
 struct clk *of_clk_get(struct device_node *np, int index)
 {
 	struct of_phandle_args clkspec;
@@ -41,13 +67,7 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	if (rc)
 		return ERR_PTR(rc);

-	of_clk_lock();
-	clk = __of_clk_get_from_provider(&clkspec);
-
-	if (!IS_ERR(clk) && !__clk_get(clk))
-		clk = ERR_PTR(-ENOENT);
-
-	of_clk_unlock();
+	clk = of_clk_get_by_clkspec(&clkspec);
 	of_node_put(clkspec.np);
 	return clk;
 }
--
1.7.9.5

