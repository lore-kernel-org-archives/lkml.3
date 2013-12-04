Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab3LDRNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 12:13:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:13518 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933022Ab3LDRNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 12:13:38 -0500
X-AuditID: cbfee61a-b7f796d000004313-a1-529f62c1b109
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
To: mturquette@linaro.org, linux-arm-kernel@lists.infradead.org
Cc: linux@arm.linux.org.uk, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiada_wang@mentor.com,
        laurent.pinchart@ideasonboard.com, kyungmin.park@samsung.com,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: [RESEND PATCH v7 3/5] clkdev: Fix race condition in clock lookup from
 device tree
Date: Wed, 04 Dec 2013 18:12:05 +0100
Message-id: <1386177127-2894-4-git-send-email-s.nawrocki@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
References: <1386177127-2894-1-git-send-email-s.nawrocki@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsVy+t9jAd2DSfODDHbMFrTo+VNpcbbpDbtF
	58Ql7BabHl9jtbi8aw6bRc+GrawWty/zWjydcJHN4vCbdlYHTo+W5h42j9kdM1k97lzbw+ax
	eUm9x+6vTYwefVtWMXp83iQXwB7FZZOSmpNZllqkb5fAldHY+4Cp4Dp/xabNd9gaGL/ydDFy
	ckgImEj87rnBCGGLSVy4t56ti5GLQ0hgEaPElwmnmSCcDiaJpe9OsINUsQkYSvQe7QPrEBGw
	l2hveQHWwSxwl1Hi+bmHYAlhgRiJtlnrwWwWAVWJU1O62UBsXgFXidf3/wPZHEDrFCTmTLIB
	CXMKuEnsm7GFBcQWAio5v/Mx+wRG3gWMDKsYRVMLkguKk9JzDfWKE3OLS/PS9ZLzczcxggPv
	mdQOxpUNFocYBTgYlXh4XyTODxJiTSwrrsw9xCjBwawkwjs5ECjEm5JYWZValB9fVJqTWnyI
	UZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBUefucVEpD+kHS32fr1Pr2B1jyhLF82bb
	pO67txYGKro8t4/9fPH83twJK869PXFqvbn53aZf7JwPdWqLn768U7b545QV/ApzTOoCHKak
	t+8w3nJ1reP8R8l7JG/XGFf0Pe51FpSRi3tTsORu8vf7iyO1KxekCfaeMkk7/GGBwaQOWaPr
	x35JxiixFGckGmoxFxUnAgCH09ggOAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently a race condition in the device tree part of clk_get()
function, since the pointer returned from of_clk_get_by_name() may become
invalid before __clk_get() call. E.g. due to the clock provider driver
remove() callback being called in between of_clk_get_by_name() and
__clk_get().

Fix this by doing both the look up and __clk_get() operations with the
clock providers list mutex held. This ensures that the clock pointer
returned from __of_clk_get_from_provider() call and passed to __clk_get()
is valid, as long as the clock supplier module first removes its clock
provider instance and then does clk_unregister() on the corresponding
clocks.

Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mike Turquette <mturquette@linaro.org>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
Changes since v2:
 - none.

Changes since v1:
 - include "clk.h".
---
 drivers/clk/clkdev.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
index 442a313..48f6721 100644
--- a/drivers/clk/clkdev.c
+++ b/drivers/clk/clkdev.c
@@ -21,6 +21,8 @@
 #include <linux/clkdev.h>
 #include <linux/of.h>
 
+#include "clk.h"
+
 static LIST_HEAD(clocks);
 static DEFINE_MUTEX(clocks_mutex);
 
@@ -39,7 +41,13 @@ struct clk *of_clk_get(struct device_node *np, int index)
 	if (rc)
 		return ERR_PTR(rc);
 
-	clk = of_clk_get_from_provider(&clkspec);
+	of_clk_lock();
+	clk = __of_clk_get_from_provider(&clkspec);
+
+	if (!IS_ERR(clk) && !__clk_get(clk))
+		clk = ERR_PTR(-ENOENT);
+
+	of_clk_unlock();
 	of_node_put(clkspec.np);
 	return clk;
 }
@@ -157,7 +165,7 @@ struct clk *clk_get(struct device *dev, const char *con_id)
 
 	if (dev) {
 		clk = of_clk_get_by_name(dev->of_node, con_id);
-		if (!IS_ERR(clk) && __clk_get(clk))
+		if (!IS_ERR(clk))
 			return clk;
 	}
 
-- 
1.7.9.5

