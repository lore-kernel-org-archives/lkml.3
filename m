Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3APA4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 19:56:47 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:53417 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab3APA4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 19:56:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Joe Perches <joe@perches.com>, James Hogan <james.hogan@imgtec.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1358274665.2597.11.camel@joe-AO722>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        rnayak@ti.com
References: <1358245685-4392-1-git-send-email-james.hogan@imgtec.com>
 <1358274665.2597.11.camel@joe-AO722>
Message-ID: <20130116005639.8920.45989@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH 1/1] clk-divider: fix is_power_of_two()
Date: Tue, 15 Jan 2013 16:56:39 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Joe Perches (2013-01-15 10:31:05)
> On Tue, 2013-01-15 at 10:28 +0000, James Hogan wrote:
> > The macro is_power_of_two() in clk-divider.c was defined as !(i & ~i)
> > which is always true. Correct it to !(i & (i - 1)).
> []
> > diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
> []
> > @@ -29,8 +29,8 @@
> []
> > -#define div_mask(d)  ((1 << (d->width)) - 1)
> > -#define is_power_of_two(i)   !(i & ~i)
> > +#define div_mask(d)  ((1 << ((d)->width)) - 1)
> > +#define is_power_of_two(i)   (!((i) & ((i) - 1)))
> 
> Use is_power_of_2 in log2.h instead?

Both are fine suggestions.  How about I apply the below patch?

Thanks,
Mike



>From 54c6c9e5f61693effbe6e4fb28ef9f2f9b3d7a23 Mon Sep 17 00:00:00 2001
From: James Hogan <james.hogan@imgtec.com>
Date: Tue, 15 Jan 2013 10:28:05 +0000
Subject: [PATCH] clk-divider: fix macros

The macro is_power_of_two() in clk-divider.c was defined as !(i & ~i)
which is always true.  Instead use is_power_of_2() from log2.h.

Also add brackets around the macro arguments in div_mask to avoid any
future operator precedence problems.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Mike Turquette <mturquette@linaro.org>
[mturquette@linaro.org: use log2.h per Joe Perches; update changelog]
---
 drivers/clk/clk-divider.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
index a9204c6..68b4021 100644
--- a/drivers/clk/clk-divider.c
+++ b/drivers/clk/clk-divider.c
@@ -16,6 +16,7 @@
 #include <linux/io.h>
 #include <linux/err.h>
 #include <linux/string.h>
+#include <linux/log2.h>
 
 /*
  * DOC: basic adjustable divider clock that cannot gate
@@ -29,8 +30,7 @@
 
 #define to_clk_divider(_hw) container_of(_hw, struct clk_divider, hw)
 
-#define div_mask(d)	((1 << (d->width)) - 1)
-#define is_power_of_two(i)	!(i & ~i)
+#define div_mask(d)	((1 << ((d)->width)) - 1)
 
 static unsigned int _get_table_maxdiv(const struct clk_div_table *table)
 {
@@ -137,7 +137,7 @@ static bool _is_valid_table_div(const struct clk_div_table *table,
 static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
 {
 	if (divider->flags & CLK_DIVIDER_POWER_OF_TWO)
-		return is_power_of_two(div);
+		return is_power_of_2(div);
 	if (divider->table)
 		return _is_valid_table_div(divider->table, div);
 	return true;
-- 
1.7.10.4

