Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaJ0S7C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:59:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52446 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaJ0S66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:58:58 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/105] regmap: debugfs: fix possbile NULL pointer dereference
Date: Mon, 27 Oct 2014 11:56:32 -0700
Message-Id: <1414436240-13879-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414436240-13879-1-git-send-email-kamal@canonical.com>
References: <1414436240-13879-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiubo Li <Li.Xiubo@freescale.com>

commit 2c98e0c1cc6b8e86f1978286c3d4e0769ee9d733 upstream.

If 'map->dev' is NULL and there will lead dev_name() to be NULL pointer
dereference. So before dev_name(), we need to have check of the map->dev
pionter.

We also should make sure that the 'name' pointer shouldn't be NULL for
debugfs_create_dir(). So here using one default "dummy" debugfs name when
the 'name' pointer and 'map->dev' are both NULL.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/regmap/regmap-debugfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index f89d382..004e132 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -473,6 +473,7 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 {
 	struct rb_node *next;
 	struct regmap_range_node *range_node;
+	const char *devname = "dummy";
 
 	/* If we don't have the debugfs root yet, postpone init */
 	if (!regmap_debugfs_root) {
@@ -491,12 +492,15 @@ void regmap_debugfs_init(struct regmap *map, const char *name)
 	INIT_LIST_HEAD(&map->debugfs_off_cache);
 	mutex_init(&map->cache_lock);
 
+	if (map->dev)
+		devname = dev_name(map->dev);
+
 	if (name) {
 		map->debugfs_name = kasprintf(GFP_KERNEL, "%s-%s",
-					      dev_name(map->dev), name);
+					      devname, name);
 		name = map->debugfs_name;
 	} else {
-		name = dev_name(map->dev);
+		name = devname;
 	}
 
 	map->debugfs = debugfs_create_dir(name, regmap_debugfs_root);
-- 
1.9.1

