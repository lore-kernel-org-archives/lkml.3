Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240AbaDIL1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:27:08 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:31971 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaDIL1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:27:02 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-9c-53452e846e83
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Cc: gregkh@linuxfoundation.org, mturquette@linaro.org, linux@arm.linux.org.uk,
        robh+dt@kernel.org, grant.likely@linaro.org, mark.rutland@arm.com,
        galak@codeaurora.org, laurent.pinchart@ideasonboard.com,
        s.hauer@pengutronix.de, ben.dooks@codethink.co.uk,
        pdeschrijver@nvidia.com, kyungmin.park@samsung.com, t-kristo@ti.com,
        sw0312.kim@samsung.com, m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [PATCH RFC v5 1/2] clk: Add function parsing arbitrary clock list DT
 property
Date: Wed, 09 Apr 2014 13:26:29 +0200
Message-id: <1397042790-10636-2-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
References: <1397042790-10636-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t9jAd0WPddgg483JCwe3Gplsph/5Byr
	Rf+bhawWB/7sYLRoXryezeJs0xt2i86JS9gtNj2+xmpxedccNovbl3kt1h65y26x9PpFJoun
	Ey6yWUxaO5XRonXvEXaLv9s3sVgcftPOajFj8ks2iyVPO9gs1s94zeIg4rFm3hpGj5bmHjaP
	y329TB7PXk5m8pjdMZPVY9OqTjaPO9f2sHnsn7uG3WPzknqP3uZ3bB79fw08+rasYvQ4fmM7
	k8fnTXIBfFFcNimpOZllqUX6dglcGe3T/rAVzJWs+DrnCVMD41WRLkZODgkBE4np05YxQdhi
	EhfurWfrYuTiEBJYxCgxb9UOFging0li3ssl7CBVbAKGEr1H+xhBbBEBF4nOB+vAipgF7jFL
	HD8/hwUkISwQIbHi+y1mEJtFQFXi0fvjYM28Am4Sbzq/Aq3jAFqnIDFnkg1ImFPAXWLb12aw
	mUJAJR+uz2eawMi7gJFhFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwtDyT2sG4ssHiEKMA
	B6MSD6+ipUuwEGtiWXFl7iFGCQ5mJRHe52yuwUK8KYmVValF+fFFpTmpxYcYpTlYlMR5D7Ra
	BwoJpCeWpGanphakFsFkmTg4pRoY94T7Lzm5ZT6rg/Oz1KqKm9qHDh9RaulfbeHcbMpvszs0
	sbB9r7W2Xv/m0MWxLdciT6/UqtWO4j9v/kp6/bnME79/hay655J1m/PH5YhCx1zts2s2LXVn
	VU36Y9zd6tVq9eL7i7mJs6YnpTWIfTn8UFZ0z7slhdptK/oen3+yI3w+w+ZPH3QYlFiKMxIN
	tZiLihMBJPKs/JICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_clk_get_by_property() function added by this patch is similar to
of_clk_get(), except it allows to pass name of a DT property containing
list of phandles and clock specifiers. For of_clk_get() this has been
hard coded to "clocks".

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
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
 drivers/clk/clkdev.c |   25 +++++++++++++++++++++----
 include/linux/clk.h  |    7 +++++++
 2 files changed, 28 insertions(+), 4 deletions(-)

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
diff --git a/include/linux/clk.h b/include/linux/clk.h
index fb5e097..f3811d3 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -397,6 +397,8 @@ struct of_phandle_args;
 
 #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
 struct clk *of_clk_get(struct device_node *np, int index);
+struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index);
 struct clk *of_clk_get_by_name(struct device_node *np, const char *name);
 struct clk *of_clk_get_from_provider(struct of_phandle_args *clkspec);
 #else
@@ -409,6 +411,11 @@ static inline struct clk *of_clk_get_by_name(struct device_node *np,
 {
 	return ERR_PTR(-ENOENT);
 }
+static inline struct clk *of_clk_get_by_property(struct device_node *np,
+				   const char *list_name, int index)
+{
+	return ERR_PTR(-ENOENT);
+}
 #endif
 
 #endif
-- 
1.7.9.5

