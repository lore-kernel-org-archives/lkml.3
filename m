Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbaB0D6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 22:58:31 -0500
Received: from mail-vc0-f202.google.com ([209.85.220.202]:55627 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbaB0D6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 22:58:30 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mark Brown <broonie@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH] regmap: don't use spinlocks with REGCACHE_{RBTREE,COMPRESSED}
Date: Wed, 26 Feb 2014 19:50:57 -0800
Message-Id: <1393473057-19919-1-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.9.0.rc1.175.g0b1dcb5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both REGCACHE_RBTREE and REGCACHE_COMPRESSED make GFP_KERNEL allocations
with the regmap lock held.  If we're initializing a regmap which would
normally use a spinlock (e.g. MMIO), fall back to using a mutex if one
of these caching types is to be used.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/base/regmap/regmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 2b4e72f..fb618d2 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -438,8 +438,9 @@ struct regmap *regmap_init(struct device *dev,
 		map->unlock = config->unlock;
 		map->lock_arg = config->lock_arg;
 	} else {
-		if ((bus && bus->fast_io) ||
-		    config->fast_io) {
+		if (((bus && bus->fast_io) || config->fast_io) &&
+		    config->cache_type != REGCACHE_RBTREE &&
+		    config->cache_type != REGCACHE_COMPRESSED) {
 			spin_lock_init(&map->spinlock);
 			map->lock = regmap_lock_spinlock;
 			map->unlock = regmap_unlock_spinlock;
-- 
1.9.0.rc1.175.g0b1dcb5

