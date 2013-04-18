Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966960Ab3DRKfk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:35:40 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:52492 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966176Ab3DRKfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:35:39 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH v3] pinctrl/pinconfig: add debug interface
Date: Thu, 18 Apr 2013 12:35:14 +0200
Message-ID: <1366281314-14613-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.11.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Meunier <laurent.meunier@st.com>

This update adds a debugfs interface to modify a pin configuration
for a given state in the pinctrl map. This allows to modify the
configuration for a non-active state, typically sleep state.
This configuration is not applied right away, but only when the state
will be entered.

This solution is mandated for us by HW validation: in order
to test and verify several pin configurations during sleep without
recompiling the software.

Change log in this patch set;
Take into account latest feedback from Stephen Warren:
- stale comments update
- improved code efficiency and readibility
- limit size of global variable pinconf_dbg_conf
- remove req_type as it can easily be added later when
add/delete requests support is implemented

Signed-off-by: Laurent Meunier <laurent.meunier@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinconf.c       | 232 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pinctrl/pinconf.h |   6 ++
 2 files changed, 238 insertions(+)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index baee2cc..1b6047d 100644
--- a/drivers/pinctrl/pinconf.c
+++ b/drivers/pinctrl/pinconf.c
@@ -17,6 +17,7 @@
 #include <linux/slab.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
+#include <linux/uaccess.h>
 #include <linux/pinctrl/machine.h>
 #include <linux/pinctrl/pinctrl.h>
 #include <linux/pinctrl/pinconf.h>
@@ -574,6 +575,235 @@ static const struct file_operations pinconf_groups_ops = {
 	.release	= single_release,
 };
 
+#define MAX_NAME_LEN 15
+
+struct dbg_cfg {
+	enum pinctrl_map_type map_type;
+	char dev_name[MAX_NAME_LEN+1];
+	char state_name[MAX_NAME_LEN+1];
+	char pin_name[MAX_NAME_LEN+1];
+};
+
+/*
+ * Goal is to keep this structure as global in order to simply read the
+ * pinconf-config file after a write to check config is as expected
+ */
+static struct dbg_cfg pinconf_dbg_conf;
+
+/**
+ * pinconf_dbg_config_print() - display the pinctrl config from the pinctrl
+ * map, of the dev/pin/state that was last written to pinconf-config file.
+ * @s: string filled in  with config description
+ * @d: not used
+ */
+static int pinconf_dbg_config_print(struct seq_file *s, void *d)
+{
+	struct pinctrl_maps *maps_node;
+	const struct pinctrl_map *map;
+	struct pinctrl_dev *pctldev = NULL;
+	const struct pinconf_ops *confops = NULL;
+	const struct pinctrl_map_configs *configs;
+	struct dbg_cfg *dbg = &pinconf_dbg_conf;
+	int i, j;
+	bool found = false;
+	unsigned long config;
+
+	mutex_lock(&pinctrl_mutex);
+
+	/* Parse the pinctrl map and look for the elected pin/state */
+	for_each_maps(maps_node, i, map) {
+		if (map->type != dbg->map_type)
+			continue;
+		if (!!strcmp(map->dev_name, dbg->dev_name))
+			continue;
+		if (!!strcmp(map->name, dbg->state_name))
+			continue;
+
+		for (j = 0; j < map->data.configs.num_configs; j++) {
+			if (!strcmp(map->data.configs.group_or_pin,
+					dbg->pin_name)) {
+				/*
+				 * We found the right pin / state, read the
+				 * config and he pctldev for later use
+				 */
+				configs = &map->data.configs;
+				pctldev = get_pinctrl_dev_from_devname
+					(map->ctrl_dev_name);
+				found = true;
+				break;
+			}
+		}
+	}
+
+	if (!found) {
+		seq_printf(s, "No config found for dev/state/pin, expected:\n");
+		seq_printf(s, "Searched dev:%s\n", dbg->dev_name);
+		seq_printf(s, "Searched state:%s\n", dbg->state_name);
+		seq_printf(s, "Searched pin:%s\n", dbg->pin_name);
+		seq_printf(s, "Use: modify config_pin <devname> "\
+				"<state> <pinname> <value>\n");
+		goto exit;
+	}
+
+	config = *(configs->configs);
+	seq_printf(s, "Dev %s has config of %s in state %s: 0x%08lX\n",
+			dbg->dev_name, dbg->pin_name,
+			dbg->state_name, config);
+
+	if (pctldev)
+		confops = pctldev->desc->confops;
+
+	if (confops && confops->pin_config_config_dbg_show)
+		confops->pin_config_config_dbg_show(pctldev, s, config);
+
+exit:
+	mutex_unlock(&pinctrl_mutex);
+
+	return 0;
+}
+
+/**
+ * pinconf_dbg_config_write() - modify the pinctrl config in the pinctrl
+ * map, of a dev/pin/state entry based on user entries to pinconf-config
+ * @user_buf: contains the modification request with expected format:
+ *     modify config_pin <devicename> <state> <pinname> <newvalue>
+ * modify is literal string, alternatives like add/delete not supported yet
+ * config_pin is literal, alternatives like config_mux not supported yet
+ * <devicename> <state> <pinname> are values that should match the pinctrl-maps
+ * <newvalue> reflects the new config and is driver dependant
+ */
+static int pinconf_dbg_config_write(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct pinctrl_maps *maps_node;
+	const struct pinctrl_map *map;
+	struct pinctrl_dev *pctldev = NULL;
+	const struct pinconf_ops *confops = NULL;
+	struct dbg_cfg *dbg = &pinconf_dbg_conf;
+	const struct pinctrl_map_configs *configs;
+	char config[MAX_NAME_LEN+1];
+	bool found = false;
+	char buf[128];
+	char *b = &buf[0];
+	int buf_size;
+	char *token;
+	int i;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+	buf[buf_size] = 0;
+
+	/*
+	 * need to parse entry and extract parameters:
+	 * modify configs_pin devicename state pinname newvalue
+	 */
+
+	/* Get arg: 'modify' */
+	token = strsep(&b, " ");
+	if (!token)
+		return -EINVAL;
+	if (!!strcmp(token, "modify"))
+		return -EINVAL;
+
+	/* Get arg type: "config_pin" type supported so far */
+	token = strsep(&b, " ");
+	if (!token)
+		return -EINVAL;
+	if (!!strcmp(token, "config_pin"))
+		return -EINVAL;
+	dbg->map_type = PIN_MAP_TYPE_CONFIGS_PIN;
+
+	/* get arg 'device_name' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+	if (strlen(token) >= MAX_NAME_LEN)
+		return -EINVAL;
+	strncpy(dbg->dev_name, token, MAX_NAME_LEN);
+
+	/* get arg 'state_name' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+	if (strlen(token) >= MAX_NAME_LEN)
+		return -EINVAL;
+	strncpy(dbg->state_name, token, MAX_NAME_LEN);
+
+	/* get arg 'pin_name' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+	if (strlen(token) >= MAX_NAME_LEN)
+		return -EINVAL;
+	strncpy(dbg->pin_name, token, MAX_NAME_LEN);
+
+	/* get new_value of config' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+	if (strlen(token) >= MAX_NAME_LEN)
+		return -EINVAL;
+	strncpy(config, token, MAX_NAME_LEN);
+
+	mutex_lock(&pinctrl_mutex);
+
+	/* Parse the pinctrl map and look for the selected dev/state/pin */
+	for_each_maps(maps_node, i, map) {
+		if (!!strcmp(map->dev_name, dbg->dev_name))
+			continue;
+		if (map->type != dbg->map_type)
+			continue;
+		if (!!strcmp(map->name, dbg->state_name))
+			continue;
+
+		/*  we found the right pin / state, so overwrite config */
+		if (!strcmp(map->data.configs.group_or_pin, dbg->pin_name)) {
+			found = true;
+			pctldev = get_pinctrl_dev_from_devname(
+					map->ctrl_dev_name);
+			configs = &map->data.configs;
+			break;
+		}
+	}
+
+	if (!found) {
+		goto exit;
+		count = -EINVAL;
+	}
+
+	if (pctldev)
+		confops = pctldev->desc->confops;
+
+	if (confops && confops->pin_config_dbg_parse_modify) {
+		for (i = 0; i < configs->num_configs; i++) {
+			confops->pin_config_dbg_parse_modify(pctldev,
+						     config,
+						     &configs->configs[i]);
+		}
+	}
+
+exit:
+	mutex_unlock(&pinctrl_mutex);
+
+	return count;
+}
+
+static int pinconf_dbg_config_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pinconf_dbg_config_print, inode->i_private);
+}
+
+static const struct file_operations pinconf_dbg_pinconfig_fops = {
+	.open = pinconf_dbg_config_open,
+	.write = pinconf_dbg_config_write,
+	.read = seq_read,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 void pinconf_init_device_debugfs(struct dentry *devroot,
 			 struct pinctrl_dev *pctldev)
 {
@@ -581,6 +811,8 @@ void pinconf_init_device_debugfs(struct dentry *devroot,
 			    devroot, pctldev, &pinconf_pins_ops);
 	debugfs_create_file("pinconf-groups", S_IFREG | S_IRUGO,
 			    devroot, pctldev, &pinconf_groups_ops);
+	debugfs_create_file("pinconf-config",  (S_IRUGO | S_IWUSR | S_IWGRP),
+			    devroot, pctldev, &pinconf_dbg_pinconfig_fops);
 }
 
 #endif
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index e7a7201..1ad4f31 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -14,6 +14,8 @@
 
 #ifdef CONFIG_PINCONF
 
+#include <linux/pinctrl/machine.h>
+
 struct pinctrl_dev;
 struct seq_file;
 
@@ -28,6 +30,7 @@ struct seq_file;
  * @pin_config_set: configure an individual pin
  * @pin_config_group_get: get configurations for an entire pin group
  * @pin_config_group_set: configure all pins in a group
+ * @pin_config_group_dbg_set: optional debugfs to modify a pin configuration
  * @pin_config_dbg_show: optional debugfs display hook that will provide
  *	per-device info for a certain pin in debugfs
  * @pin_config_group_dbg_show: optional debugfs display hook that will provide
@@ -51,6 +54,9 @@ struct pinconf_ops {
 	int (*pin_config_group_set) (struct pinctrl_dev *pctldev,
 				     unsigned selector,
 				     unsigned long config);
+	int (*pin_config_dbg_parse_modify) (struct pinctrl_dev *pctldev,
+					   const char *arg,
+					   unsigned long *config);
 	void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
 				     struct seq_file *s,
 				     unsigned offset);
-- 
1.7.11.3

