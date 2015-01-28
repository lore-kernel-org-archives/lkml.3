Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbbA1FUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 00:20:17 -0500
Received: from mail.kernel.org ([198.145.29.136]:37655 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933763AbbA1EQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:16:14 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>,
        Mark Brown <broonie@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 031/177] regmap: debugfs: fix possbile NULL pointer dereference
Date: Wed, 28 Jan 2015 12:07:09 +0800
Message-Id: <1422418236-12852-62-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiubo Li <Li.Xiubo@freescale.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 2c98e0c1cc6b8e86f1978286c3d4e0769ee9d733 upstream.

If 'map->dev' is NULL and there will lead dev_name() to be NULL pointer
dereference. So before dev_name(), we need to have check of the map->dev
pionter.

We also should make sure that the 'name' pointer shouldn't be NULL for
debugfs_create_dir(). So here using one default "dummy" debugfs name when
the 'name' pointer and 'map->dev' are both NULL.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
[lizf: Backported to 3.4: dev_name() is passed to debugfs_create_dir() in 3.4]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/base/regmap/regmap-debugfs.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 8ab1eab..1db1289 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -244,7 +244,12 @@ static const struct file_operations regmap_access_fops = {
 
 void regmap_debugfs_init(struct regmap *map)
 {
-	map->debugfs = debugfs_create_dir(dev_name(map->dev),
+	const char *devname = "dummy";
+
+	if (map->dev)
+		devname = dev_name(map->dev);
+
+	map->debugfs = debugfs_create_dir(devname,
 					  regmap_debugfs_root);
 	if (!map->debugfs) {
 		dev_warn(map->dev, "Failed to create debugfs directory\n");
-- 
1.9.1

