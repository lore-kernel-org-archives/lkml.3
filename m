Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbaJ1Dwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 23:52:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933712AbaJ1Dw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:52:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xiubo Li <Li.Xiubo@freescale.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 3.10 11/43] regmap: debugfs: fix possbile NULL pointer dereference
Date: Tue, 28 Oct 2014 11:36:09 +0800
Message-Id: <20141028033523.886188544@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033523.407092670@linuxfoundation.org>
References: <20141028033523.407092670@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/regmap/regmap-debugfs.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -460,16 +460,20 @@ void regmap_debugfs_init(struct regmap *
 {
 	struct rb_node *next;
 	struct regmap_range_node *range_node;
+	const char *devname = "dummy";
 
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


