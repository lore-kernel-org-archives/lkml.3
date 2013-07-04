Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3GDLR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:17:27 -0400
Received: from svenfoo.org ([82.94.215.22]:58181 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756529Ab3GDLRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:17:25 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Jul 2013 07:17:25 EDT
From: Daniel Mack <zonque@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, Daniel Mack <zonque@gmail.com>, stable@vger.kernel.org,
        "[v3.10 only]"@mail.zonque.de
Subject: [PATCH] regmap: cache: bail in regmap_async_complete() for bus-less maps
Date: Thu,  4 Jul 2013 13:11:03 +0200
Message-Id: <1372936263-14472-1-git-send-email-zonque@gmail.com>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit f8bd822cb ("regmap: cache: Factor out block sync") made
regcache_rbtree_sync() call regmap_async_complete(), which in turn does
not check for map->bus before dereferencing it.

This causes a NULL pointer dereference on bus-less maps.

Signed-off-by: Daniel Mack <zonque@gmail.com>
Cc: stable@vger.kernel.org [v3.10 only]
---
 drivers/base/regmap/regmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index a941dcf..d0c81d1 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -1717,7 +1717,7 @@ int regmap_async_complete(struct regmap *map)
 	int ret;
 
 	/* Nothing to do with no async support */
-	if (!map->bus->async_write)
+	if (!map->bus || !map->bus->async_write)
 		return 0;
 
 	trace_regmap_async_complete_start(map->dev);
-- 
1.8.1.4

