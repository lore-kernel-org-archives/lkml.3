Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551AbaI1DgD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 23:36:03 -0400
Received: from mail-bn1bon0130.outbound.protection.outlook.com ([157.56.111.130]:7257
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752180AbaI1DgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 23:36:01 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <broonie@kernel.org>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] regmap: debugfs: fix possbile NULL pointer dereference
Date: Sun, 28 Sep 2014 11:35:25 +0800
Message-ID: <1411875325-19293-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 2.1.0.27.g96db324
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(189002)(199003)(68736004)(6806004)(44976005)(20776003)(229853001)(102836001)(69596002)(46102003)(79102003)(74502003)(74662003)(81542003)(81342003)(77982003)(83322001)(19580395003)(19580405001)(62966002)(64706001)(50226001)(47776003)(4396001)(31966008)(87286001)(87936001)(88136002)(77156001)(80022003)(106466001)(85306004)(10300001)(21056001)(48376002)(81156004)(105606002)(2351001)(107046002)(50466002)(120916001)(95666004)(99396003)(575784001)(93916002)(36756003)(86362001)(26826002)(85852003)(84676001)(90102001)(104166001)(92726001)(92566001)(50986999)(104016003)(97736003)(110136001)(89996001)(76482002)(83072002);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0619;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:CY1PR0301MB0619;
X-Forefront-PRVS: 03484C0ABF
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If 'map->dev' is NULL and there will lead dev_name() to be NULL pointer
dereference. So before dev_name(), we need to have check of the map->dev
pionter.

We also should make sure that the 'name' pointer shouldn't be NULL for
debugfs_create_dir(). So here using one default "dummy" debugfs name when
the 'name' pointer and 'map->dev' are both NULL.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/base/regmap/regmap-debugfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 0c94b66..5799a0b 100644
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
2.1.0.27.g96db324

