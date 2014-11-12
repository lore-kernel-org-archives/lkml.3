Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaKLSRj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 13:17:39 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:52784 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaKLSRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 13:17:38 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: Chen-Yu Tsai <wens@csie.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH] of: pass name argument for of_io_request_and_map as const char *
Date: Thu, 13 Nov 2014 02:17:02 +0800
Message-Id: <1415816222-32200-1-git-send-email-wens@csie.org>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The name argument for of_io_request_and_map is only passed to
request_mem_region, which is a macro of __request_region, which
takes a const name argument.

Make the name argument const, so when we pass const strings we
don't get the following warnings:

    warning: passing argument 3 of 'of_io_request_and_map' discards
    'const' qualifier from pointer target type [enabled by default]

    In file included from drivers/clk/sunxi/clk-sunxi.c:20:0:
    include/linux/of_address.h:108:15: note: expected 'char *' but
    argument is of type 'const char *'

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
---

I ran into this while switching some of the sunxi clock code to use
of_io_request_and_map.

---
 drivers/of/address.c       | 2 +-
 include/linux/of_address.h | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index afdb782..e02828f 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -871,7 +871,7 @@ EXPORT_SYMBOL(of_iomap);
  *		return PTR_ERR(base);
  */
 void __iomem *of_io_request_and_map(struct device_node *np, int index,
-					char *name)
+					const char *name)
 {
 	struct resource res;
 	void __iomem *mem;
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 8cb14eb..d88e81b 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -106,7 +106,7 @@ extern int of_address_to_resource(struct device_node *dev, int index,
 				  struct resource *r);
 void __iomem *of_iomap(struct device_node *node, int index);
 void __iomem *of_io_request_and_map(struct device_node *device,
-					int index, char *name);
+					int index, const char *name);
 #else
 
 #include <linux/io.h>
@@ -123,7 +123,7 @@ static inline void __iomem *of_iomap(struct device_node *device, int index)
 }
 
 static inline void __iomem *of_io_request_and_map(struct device_node *device,
-					int index, char *name)
+					int index, const char *name)
 {
 	return IOMEM_ERR_PTR(-EINVAL);
 }
-- 
2.1.3

