Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbaCRUvp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:51:45 -0400
Received: from mail-pa0-f73.google.com ([209.85.220.73]:33047 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755423AbaCRUvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:51:44 -0400
From: Dylan Reid <dgreid@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: broonie@kernel.org, Dylan Reid <dgreid@chromium.org>
Subject: [PATCH 2/2] regmap: cache: Don't attempt to sync non-writeable registers.
Date: Tue, 18 Mar 2014 13:45:09 -0700
Message-Id: <1395175509-19113-2-git-send-email-dgreid@chromium.org>
X-Mailer: git-send-email 1.8.1.3.605.g02339dd
In-Reply-To: <1395175509-19113-1-git-send-email-dgreid@chromium.org>
References: <1395175509-19113-1-git-send-email-dgreid@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the regcache_default_sync, if a register isn't writeable, then
_regmap_write will return an error and the rest of the sync will be
aborted.  Avoid this by checking if a register is writeable before
trying to sync it.

Signed-off-by: Dylan Reid <dgreid@chromium.org>
---
 drivers/base/regmap/regcache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regcache.c b/drivers/base/regmap/regcache.c
index 44af125..29b4128 100644
--- a/drivers/base/regmap/regcache.c
+++ b/drivers/base/regmap/regcache.c
@@ -253,7 +253,8 @@ static int regcache_default_sync(struct regmap *map, unsigned int min,
 		unsigned int val;
 		int ret;
 
-		if (regmap_volatile(map, reg))
+		if (regmap_volatile(map, reg) ||
+		    !regmap_writeable(map, reg))
 			continue;
 
 		ret = regcache_read(map, reg, &val);
-- 
1.8.1.3.605.g02339dd

