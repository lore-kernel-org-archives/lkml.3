Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763133Ab3DCTC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:02:27 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:55216 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763103Ab3DCTCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:02:25 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>
Subject: [PATCH] pinctrl/pinconf: partial revert of pin config debugfs
Date: Wed, 3 Apr 2013 21:02:09 +0200
Message-ID: <1365015729-9192-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

I accidentally left this patch:

commit 6f9e41f4e673bf9ae6a5c0831b1524a91ea1c440
"pinctrl/pinconfig: add debug interface"

in the tree though the patch was not yet finished.
Revert it partially (we need the infrastructural changes).

Cc: Laurent Meunier <laurent.meunier@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinconf.c | 207 ----------------------------------------------
 1 file changed, 207 deletions(-)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index 8aefd28..baee2cc 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -574,207 +574,6 @@ static const struct file_operations pinconf_groups_ops = {
 	.release	= single_release,
 };
 
-/* 32bit read/write ressources */
-#define MAX_NAME_LEN 16
-char dbg_pinname[MAX_NAME_LEN]; /* shared: name of the state of the pin*/
-char dbg_state_name[MAX_NAME_LEN]; /* shared: state of the pin*/
-static u32 dbg_config; /* shared: config to be read/set for the pin & state*/
-
-static int pinconf_dbg_pinname_print(struct seq_file *s, void *d)
-{
-	if (strlen(dbg_pinname))
-		seq_printf(s, "%s\n", dbg_pinname);
-	else
-		seq_printf(s, "No pin name set\n");
-	return 0;
-}
-
-static int pinconf_dbg_pinname_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinconf_dbg_pinname_print, inode->i_private);
-}
-
-static int pinconf_dbg_pinname_write(struct file *file,
-	const char __user *user_buf, size_t count, loff_t *ppos)
-{
-	int err;
-
-	if (count > MAX_NAME_LEN)
-		return -EINVAL;
-
-	err = sscanf(user_buf, "%15s", dbg_pinname);
-
-	if (err != 1)
-		return -EINVAL;
-
-	return count;
-}
-
-static const struct file_operations pinconf_dbg_pinname_fops = {
-	.open = pinconf_dbg_pinname_open,
-	.write = pinconf_dbg_pinname_write,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-static int pinconf_dbg_state_print(struct seq_file *s, void *d)
-{
-	if (strlen(dbg_state_name))
-		seq_printf(s, "%s\n", dbg_pinname);
-	else
-		seq_printf(s, "No pin state set\n");
-	return 0;
-}
-
-static int pinconf_dbg_state_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinconf_dbg_state_print, inode->i_private);
-}
-
-static int pinconf_dbg_state_write(struct file *file,
-	const char __user *user_buf, size_t count, loff_t *ppos)
-{
-	int err;
-
-	if (count > MAX_NAME_LEN)
-		return -EINVAL;
-
-	err = sscanf(user_buf, "%15s", dbg_state_name);
-
-	if (err != 1)
-		return -EINVAL;
-
-	return count;
-}
-
-static const struct file_operations pinconf_dbg_pinstate_fops = {
-	.open = pinconf_dbg_state_open,
-	.write = pinconf_dbg_state_write,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
-/**
- * pinconf_dbg_config_print() - display the pinctrl config from the pinctrl
- * map, of a pin/state pair based on pinname and state that have been
- * selected with the debugfs entries pinconf-name and pinconf-state
- * @s: contains the 32bits config to be written
- * @d: not used
- */
-static int pinconf_dbg_config_print(struct seq_file *s, void *d)
-{
-	struct pinctrl_maps *maps_node;
-	struct pinctrl_map const *map;
-	struct pinctrl_dev *pctldev = NULL;
-	const struct pinconf_ops *confops = NULL;
-	int i, j;
-	bool found = false;
-
-	mutex_lock(&pinctrl_mutex);
-
-	/* Parse the pinctrl map and look for the elected pin/state */
-	for_each_maps(maps_node, i, map) {
-		if (map->type != PIN_MAP_TYPE_CONFIGS_PIN)
-			continue;
-
-		if (strncmp(map->name, dbg_state_name, MAX_NAME_LEN) > 0)
-			continue;
-
-		for (j = 0; j < map->data.configs.num_configs; j++) {
-			if (0 == strncmp(map->data.configs.group_or_pin,
-						dbg_pinname, MAX_NAME_LEN)) {
-				/* We found the right pin / state, read the
-				 * config and store the pctldev */
-				dbg_config = map->data.configs.configs[j];
-				pctldev = get_pinctrl_dev_from_devname
-					(map->ctrl_dev_name);
-				found = true;
-				break;
-			}
-		}
-	}
-
-	mutex_unlock(&pinctrl_mutex);
-
-	if (found) {
-		seq_printf(s, "Config of %s in state %s: 0x%08X\n", dbg_pinname,
-				 dbg_state_name, dbg_config);
-
-		if (pctldev)
-			confops = pctldev->desc->confops;
-
-		if (confops && confops->pin_config_config_dbg_show)
-			confops->pin_config_config_dbg_show(pctldev,
-					s, dbg_config);
-	} else {
-		seq_printf(s, "No pin found for defined name/state\n");
-	}
-
-	return 0;
-}
-
-static int pinconf_dbg_config_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, pinconf_dbg_config_print, inode->i_private);
-}
-
-/**
- * pinconf_dbg_config_write() - overwrite the pinctrl config in thepinctrl
- * map, of a pin/state pair based on pinname and state that have been
- * selected with the debugfs entries pinconf-name and pinconf-state
- */
-static int pinconf_dbg_config_write(struct file *file,
-	const char __user *user_buf, size_t count, loff_t *ppos)
-{
-	int err;
-	unsigned long config;
-	struct pinctrl_maps *maps_node;
-	struct pinctrl_map const *map;
-	int i, j;
-
-	err = kstrtoul_from_user(user_buf, count, 0, &config);
-
-	if (err)
-		return err;
-
-	dbg_config = config;
-
-	mutex_lock(&pinctrl_mutex);
-
-	/* Parse the pinctrl map and look for the selected pin/state */
-	for_each_maps(maps_node, i, map) {
-		if (map->type != PIN_MAP_TYPE_CONFIGS_PIN)
-			continue;
-
-		if (strncmp(map->name, dbg_state_name, MAX_NAME_LEN) > 0)
-			continue;
-
-		/*  we found the right pin / state, so overwrite config */
-		for (j = 0; j < map->data.configs.num_configs; j++) {
-			if (strncmp(map->data.configs.group_or_pin, dbg_pinname,
-						MAX_NAME_LEN) == 0)
-				map->data.configs.configs[j] = dbg_config;
-		}
-	}
-
-	mutex_unlock(&pinctrl_mutex);
-
-	return count;
-}
-
-static const struct file_operations pinconf_dbg_pinconfig_fops = {
-	.open = pinconf_dbg_config_open,
-	.write = pinconf_dbg_config_write,
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-	.owner = THIS_MODULE,
-};
-
 void pinconf_init_device_debugfs(struct dentry *devroot,
 			 struct pinctrl_dev *pctldev)
 {
@@ -782,12 +581,6 @@ void pinconf_init_device_debugfs(struct dentry *devroot,
 			    devroot, pctldev, &pinconf_pins_ops);
 	debugfs_create_file("pinconf-groups", S_IFREG | S_IRUGO,
 			    devroot, pctldev, &pinconf_groups_ops);
-	debugfs_create_file("pinconf-name", (S_IRUGO | S_IWUSR | S_IWGRP),
-			    devroot, pctldev, &pinconf_dbg_pinname_fops);
-	debugfs_create_file("pinconf-state",  (S_IRUGO | S_IWUSR | S_IWGRP),
-			    devroot, pctldev, &pinconf_dbg_pinstate_fops);
-	debugfs_create_file("pinconf-config",  (S_IRUGO | S_IWUSR | S_IWGRP),
-			    devroot, pctldev, &pinconf_dbg_pinconfig_fops);
 }
 
 #endif
-- 
1.7.11.3

