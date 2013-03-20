Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab3CTXCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:02:12 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:55183 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3CTXCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:02:10 -0400
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] regmap: don't corrupt work buffer in _regmap_raw_write()
Date: Wed, 20 Mar 2013 17:02:02 -0600
Message-Id: <1363820522-25954-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

_regmap_raw_write() contains code to call regcache_write() to write
values to the cache. That code calls memcpy() to copy the value data to
the start of the work_buf. However, at least when _regmap_raw_write() is
called from _regmap_bus_raw_write(), the value data is in the work_buf,
and this memcpy() operation may over-write part of that value data,
depending on the value of reg_bytes + pad_bytes. At least when using
reg_bytes==1 and pad_bytes==0, corruption of the value data does occur.

To solve this, remove the memcpy() operation, and modify the subsequent
.parse_val() call to parse the original value buffer directly.

At least in the case of 8-bit register address and 16-bit values, and
writes of single registers at a time, this memcpy-then-parse combination
used to cancel each-other out; for a work-buffer containing xx 89 03,
the memcpy changed it to 89 03 03, and the parse_val changed it back to
89 89 03, thus leaving the value uncorrupted. This appears completely
accidental though. Since commit 8a819ff "regmap: core: Split out in
place value parsing", .parse_val only returns the parsed value, and does
not modify the buffer, and hence does not (accidentally) undo the
corruption caused by memcpy(). This caused bogus values to get written
to HW, thus preventing e.g. audio playback on systems with a WM8903
CODEC. This patch fixes that.

Cc: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 drivers/base/regmap/regmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index fed91ac..1ab4498 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -963,8 +963,7 @@ static int _regmap_raw_write(struct regmap *map, unsigned int reg,
 		unsigned int ival;
 		int val_bytes = map->format.val_bytes;
 		for (i = 0; i < val_len / val_bytes; i++) {
-			memcpy(map->work_buf, val + (i * val_bytes), val_bytes);
-			ival = map->format.parse_val(map->work_buf);
+			ival = map->format.parse_val(val + (i * val_bytes));
 			ret = regcache_write(map, reg + (i * map->reg_stride),
 					     ival);
 			if (ret) {
-- 
1.7.10.4

