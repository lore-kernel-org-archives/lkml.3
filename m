Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab3EHKYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:24:54 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:38708 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754046Ab3EHKYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:24:53 -0400
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: broonie@kernel.org
Cc: srinivas.kandagatla@st.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] regmap: debugfs: Fix start_reg calculation (v2)
Date: Wed,  8 May 2013 11:20:09 +0100
Message-Id: <1368008409-15250-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

If we dump syscon regmap registers via debugfs you will notice that the
dump contains lot of XXXXXXXX values.

An example configuration is:
syscon@fdde0000{
	compatible      = "syscon";
	reg		= <0xfdde0000 0x15c>;
};

example dump:
cat  /sys/kernel/debug/regmap/myregmap/registers
...
154: 001c1dff
158: 00000003
05a: XXXXXXXX
05e: XXXXXXXX
...

regmap_debugfs_get_dump_start should return the offset of the register
it should start reading from, However in the current code it does not
consider stride while calculating this. If we use the return value to
dump the registers we can endup with wrong start address, in the example
case for the second loop the code ends up with start_reg = 0x56. Which
is incorrect. Also this keeps incremeting by stride, which can than
result in unaligned address

This patch fixes this issue by considering the stride value at all
required places in regmap_debugfs_get_dump_start function.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
---
 drivers/base/regmap/regmap-debugfs.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 81d6f60..6cd1b78a 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -97,7 +97,8 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 					c->max = p - 1;
 					fpos_offset = c->max - c->min;
 					reg_offset = fpos_offset / map->debugfs_tot_len;
-					c->max_reg = c->base_reg + reg_offset;
+					c->max_reg = c->base_reg +
+						(reg_offset * map->reg_stride);
 					list_add_tail(&c->list,
 						      &map->debugfs_off_cache);
 					c = NULL;
@@ -126,7 +127,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 		c->max = p - 1;
 		fpos_offset = c->max - c->min;
 		reg_offset = fpos_offset / map->debugfs_tot_len;
-		c->max_reg = c->base_reg + reg_offset;
+		c->max_reg = c->base_reg + (reg_offset * map->reg_stride);
 		list_add_tail(&c->list,
 			      &map->debugfs_off_cache);
 	}
@@ -145,7 +146,7 @@ static unsigned int regmap_debugfs_get_dump_start(struct regmap *map,
 			fpos_offset = from - c->min;
 			reg_offset = fpos_offset / map->debugfs_tot_len;
 			*pos = c->min + (reg_offset * map->debugfs_tot_len);
-			return c->base_reg + reg_offset;
+			return c->base_reg + (reg_offset * map->reg_stride);
 		}
 
 		*pos = c->max;
-- 
1.7.6.5

