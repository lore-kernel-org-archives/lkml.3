Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760125Ab3EXI3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:29:50 -0400
Received: from smtp-out-103.synserver.de ([212.40.185.103]:1033 "EHLO
	smtp-out-103.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437Ab3EXI3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:29:47 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22449
From: Lars-Peter Clausen <lars@metafoo.de>
To: Mark Brown <broonie@kernel.org>, Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH] regmap: Make regmap-mmio usable from atomic contexts
Date: Fri, 24 May 2013 10:29:22 +0200
Message-Id: <1369384162-25196-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for locking.
To be able to use the regmap API from different contexts (atomic vs non-atomic),
without the risk of race conditions, we need to use spin_lock_irqsave() and
spin_lock_irqrestore() instead. A new field, the spinlock_flags field, is added
to regmap struct to store the flags between regmap_{,un}lock_spinlock(). The
spinlock_flags field itself is also protected by the spinlock.

Thanks to Stephen Warren for the suggestion of this particular solution.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
---
 drivers/base/regmap/internal.h | 1 +
 drivers/base/regmap/regmap.c   | 7 +++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/internal.h b/drivers/base/regmap/internal.h
index b33a4ff..ae23d83 100644
--- a/drivers/base/regmap/internal.h
+++ b/drivers/base/regmap/internal.h
@@ -52,6 +52,7 @@ struct regmap_async {
 struct regmap {
 	struct mutex mutex;
 	spinlock_t spinlock;
+	unsigned long spinlock_flags;
 	regmap_lock lock;
 	regmap_unlock unlock;
 	void *lock_arg; /* This is passed to lock/unlock functions */
diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index 307f5a1..1a01553 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -302,13 +302,16 @@ static void regmap_unlock_mutex(void *__map)
 static void regmap_lock_spinlock(void *__map)
 {
 	struct regmap *map = __map;
-	spin_lock(&map->spinlock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&map->spinlock, flags);
+	map->spinlock_flags = flags;
 }
 
 static void regmap_unlock_spinlock(void *__map)
 {
 	struct regmap *map = __map;
-	spin_unlock(&map->spinlock);
+	spin_unlock_irqrestore(&map->spinlock, map->spinlock_flags);
 }
 
 static void dev_get_regmap_release(struct device *dev, void *res)
-- 
1.8.0

