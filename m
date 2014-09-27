Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaI0Ab5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:31:57 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:60819 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755944AbaI0Abz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:31:55 -0400
From: Behan Webster <behanw@converseincode.com>
To: mturquette@linaro.org, t-kristo@ti.com
Cc: behanw@converseincode.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH] clk, ti, LLVMLinux: Move __init outside of type definition
Date: Fri, 26 Sep 2014 17:31:48 -0700
Message-Id: <1411777908-16016-1-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As written, the __init for ti_clk_get_div_table is in the middle of the return
type.

The gcc documentation indicates that section attributes should be added to the
end of the function declaration:

  extern void foobar (void) __attribute__ ((section ("bar")));

However gcc seems to be very permissive with where attributes can be placed.
clang on the other hand isn't so permissive, and fails if you put the section
definition in the middle of the return type:

drivers/clk/ti/divider.c:298:28: error: expected ';' after struct
static struct clk_div_table
                           ^
                           ;
drivers/clk/ti/divider.c:298:1: warning: 'static' ignored on this
      declaration [-Wmissing-declarations]
static struct clk_div_table
^
drivers/clk/ti/divider.c:299:9: error: type specifier missing,
      defaults to 'int' [-Werror,-Wimplicit-int]
__init *ti_clk_get_div_table(struct device_node *node)
~~~~~~  ^
drivers/clk/ti/divider.c:345:9: warning: incompatible pointer types
      returning 'struct clk_div_table *' from a function with result type 'int *' [-Wincompatible-pointer-types]
        return table;
               ^~~~~
drivers/clk/ti/divider.c:419:9: warning: incompatible pointer types
      assigning to 'const struct clk_div_table *' from 'int *' [-Wincompatible-pointer-types]
        *table = ti_clk_get_div_table(node);
               ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
3 warnings and 2 errors generated.

By convention, most of the kernel code puts section attributes between the
return type and function name. In the case where the return type is a pointer,
it's important to place the '*' on left of the __init.

This updated code works for both gcc and clang.

Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Mark Charlebois <charlebm@gmail.com>
---
 drivers/clk/ti/divider.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index a837f70..bff2b5b 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -300,8 +300,8 @@ static struct clk *_register_divider(struct device *dev, const char *name,
 	return clk;
 }
 
-static struct clk_div_table
-__init *ti_clk_get_div_table(struct device_node *node)
+static struct clk_div_table *
+__init ti_clk_get_div_table(struct device_node *node)
 {
 	struct clk_div_table *table;
 	const __be32 *divspec;
-- 
1.9.1

