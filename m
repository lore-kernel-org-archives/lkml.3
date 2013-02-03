Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab3BCImj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 03:42:39 -0500
Received: from kepler.killerwolves.net ([103.4.235.74]:44496 "EHLO
	kepler.killerwolves.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab3BCIm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 03:42:26 -0500
From: Ben Peddell <klightspeed@killerwolves.net>
To: linux-kernel@vger.kernel.org
References: <510E207F.1@killerwolves.net>
In-Reply-To: <510E207F.1@killerwolves.net>
Date: Sun, 3 Feb 2013 18:33:27 +1000
Subject: [PATCH 1/2] 3.4.y target: Move dev->dev_link_magic check
Message-Id: <20130203083415.90F01B6002@kepler.killerwolves.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit fdf9d862969f1be18814273b03fb9497ec2dbdae (target: Add link_magic
for fabric allow_link destination target_items) applied without commit
0fd97ccf45be26fb01b3a412f1f6c6b5044b2f16 (Simplify the code a lot by
killing the superflous struct se_subsystem_dev) has the
dev->dev_link_magic check before dev is initialized in
target_fabric_port_link.  This patch moves the dev->dev_link_magic
check to after dev is initialized.

Signed-off-by: Ben Peddell <klightspeed@killerwolves.net>
---
 drivers/target/target_core_fabric_configfs.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index b009b89..31de881 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -752,12 +752,6 @@ static int target_fabric_port_link(
 	struct target_fabric_configfs *tf;
 	int ret;
 
-	if (dev->dev_link_magic != SE_DEV_LINK_MAGIC) {
-		pr_err("Bad dev->dev_link_magic, not a valid se_dev_ci pointer:"
-			" %p to struct se_device: %p\n", se_dev_ci, dev);
-		return -EFAULT;
-	}
-
 	tpg_ci = &lun_ci->ci_parent->ci_group->cg_item;
 	se_tpg = container_of(to_config_group(tpg_ci),
 				struct se_portal_group, tpg_group);
@@ -776,6 +770,12 @@ static int target_fabric_port_link(
 		goto out;
 	}
 
+	if (dev->dev_link_magic != SE_DEV_LINK_MAGIC) {
+		pr_err("Bad dev->dev_link_magic, not a valid se_dev_ci pointer:"
+			" %p to struct se_device: %p\n", se_dev_ci, dev);
+		return -EFAULT;
+	}
+
 	lun_p = core_dev_add_lun(se_tpg, dev->se_hba, dev,
 				lun->unpacked_lun);
 	if (IS_ERR(lun_p)) {
-- 
1.7.8.6

