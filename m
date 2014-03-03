Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaCCSWd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:22:33 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:50898 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269AbaCCSWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:22:31 -0500
X-AuditID: cbfee61b-b7f456d000006dfd-fd-5314c864b795
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mturquette@linaro.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, grant.likely@linaro.org, mark.rutland@arm.com,
        galak@codeaurora.org, kyungmin.park@samsung.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RFC PATCH v2 1/2] clk: Add function parsing arbitrary clock list DT
 property
Date: Mon, 03 Mar 2014 19:22:10 +0100
Message-id: <1393870930-20971-1-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
References: <1393870533-20845-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd2UEyLBBlcuCVjMP3KO1aL/zUJW
	iwN/djBaNC9ez2ZxtukNu8Wmx9dYLS7vmsNmcfsyr8XaI3fZLZZev8hk8XTCRTaL1r1H2C0O
	v2lntZgx+SWbxfoZr1kc+D3WzFvD6NHS3MPmcbmvl8lj06pONo871/aweeyfu4bdY/OSeo++
	LasYPT5vkgvgjOKySUnNySxLLdK3S+DKmDH7NlvBdZGK4+tYGxj/CnQxcnBICJhI9JyU72Lk
	BDLFJC7cW8/WxcjFISSwiFHi96P17BBOB5PEyg3b2UCq2AQMJXqP9jGC2CICLhKdD9axgNjM
	AreYJKaclAKxhQUiJDZ+nQYWZxFQldjYuwPM5hVwk+j/18cCsVhBYs4kG5Awp4C7xOyjncwg
	thBQycuZF9knMPIuYGRYxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcxM+kdzCuarA4xCjA
	wajEw+swRSRYiDWxrLgy9xCjBAezkghvRA1QiDclsbIqtSg/vqg0J7X4EKM0B4uSOO/BVutA
	IYH0xJLU7NTUgtQimCwTB6dUA2Pody5WtRvTZLd0K1nur97bXSiWfC+nnemDzYd98e+Ob1gT
	5lO7VPjHfE6N7MdHJjgn2j+7JWD291h+6tXg0CdX0zPtF4gUpciv0vZ32sD/QniTts3zjlW+
	/fnrZ/V9aFzIenqSa8V/bqGt1xVmNG88tC1hDkvH8mnNFbt3X1zjd7z7U/fagy1KLMUZiYZa
	zEXFiQDzTZZtXgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_clk_get_by_property() function added by this patch is similar to
of_clk_get(), except it allows to pass name of a DT property containing
list of phandles and clock specifiers. For of_clk_get() this has been
hard coded to "clocks".

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
Changes since v1:
 - s/of_clk_get_list_entry/of_clk_get_by_property.
---
 drivers/clk/clk.h    |    3 +++
 drivers/clk/clkdev.c |   25 +++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
index 795cc9f..666bc50 100644
--- a/drivers/clk/clk.h
+++ b/drivers/clk/clk.h
@@ -10,7 +10,10 @@
  */
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
+
 struct clk *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
 void of_clk_lock(void);
 void of_clk_unlock(void);
+struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index);
 #endif
diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index a360b2e..1d41540 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -27,17 +27,28 @@ static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
-struct clk *of_clk_get(struct device_node *np, int index)
+/**
+ * of_clk_get_by_property() - Parse and lookup a clock referenced by a device node
+ * @np: pointer to clock consumer node
+ * @list_name: name of the clock list property
+ * @index: index to the clock list
+ *
+ * This function parses the @list_name property and together with @index
+ * value indicating an entry of the list uses it to look up the struct clk
+ * from the registered list of clock providers.
+ */
+struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index)
 {
 	struct of_phandle_args clkspec;
 	struct clk *clk;
 	int rc;
 
-	if (index < 0)
+	if (index < 0 || !list_name)
 		return ERR_PTR(-EINVAL);
 
-	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index,
-					&clkspec);
+	rc = of_parse_phandle_with_args(np, list_name, "#clock-cells",
+					index, &clkspec);
 	if (rc)
 		return ERR_PTR(rc);
 
@@ -51,6 +62,12 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	of_node_put(clkspec.np);
 	return clk;
 }
+EXPORT_SYMBOL(of_clk_get_by_property);
+
+struct clk *of_clk_get(struct device_node *np, int index)
+{
+	return of_clk_get_by_property(np, "clocks", index);
+}
 EXPORT_SYMBOL(of_clk_get);
 
 /**
-- 
1.7.9.5

