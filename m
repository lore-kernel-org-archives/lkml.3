Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932228Ab3DCTbd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 15:31:33 -0400
Received: from eu1sys200aog113.obsmtp.com ([207.126.144.135]:41037 "EHLO
	eu1sys200aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762100Ab3DCTbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 15:31:32 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Cc: Stephen Warren <swarren@nvidia.com>, Anmar Oueja <anmar.oueja@linaro.org>,
        Laurent Meunier <laurent.meunier@st.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH] pinctrl/pinconfig: add debug interface
Date: Wed, 3 Apr 2013 21:31:07 +0200
Message-ID: <1365017467-23554-1-git-send-email-linus.walleij@stericsson.com>
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

Signed-off-by: Laurent Meunier <laurent.meunier@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/pinctrl/pinconf.c       | 231 ++++++++++++++++++++++++++++++++++++++++
 include/linux/pinctrl/pinconf.h |   4 +
 2 files changed, 235 insertions(+)

diff --git a/drivers/pinctrl/pinconf.c b/drivers/pinctrl/pinconf.c
index baee2cc..a95ac8d 100644
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
@@ -574,6 +575,234 @@ static const struct file_operations pinconf_groups_ops = {
 	.release	= single_release,
 };
 
+/* 32bit read/write resources */
+#define MAX_NAME_LEN 15
+
+enum pinconf_dbg_request_type {
+	PINCONF_DBG_REQ_TYPE_INVALID,
+	PINCONF_DBG_REQ_TYPE_MODIFY,
+};
+
+struct dbg_cfg {
+	enum pinconf_dbg_request_type req_type;
+	enum pinctrl_map_type map_type;
+	char dev_name[MAX_NAME_LEN+1];
+	char state_name[MAX_NAME_LEN+1];
+	char pin_name[MAX_NAME_LEN+1];
+	char config[MAX_NAME_LEN+1];
+};
+
+static struct dbg_cfg pinconf_dbg_conf;
+
+/**
+ * pinconf_dbg_config_print() - display the pinctrl config from the pinctrl
+ * map, of a pin/state pair based on pinname and state that have been
+ * selected with the debugfs entries pinconf-name and pinconf-state
+ * @s: contains the 32bits config to be written
+ * @d: not used
+ */
+static int pinconf_dbg_config_print(struct seq_file *s, void *d)
+{
+	struct pinctrl_maps *maps_node;
+	struct pinctrl_map const *map;
+	struct pinctrl_dev *pctldev = NULL;
+	struct pinconf_ops const *confops = NULL;
+	int i, j;
+	bool found = false;
+	struct dbg_cfg *dbg = &pinconf_dbg_conf;
+	unsigned long config = 0;
+
+	mutex_lock(&pinctrl_mutex);
+
+	/* Parse the pinctrl map and look for the elected pin/state */
+	for_each_maps(maps_node, i, map) {
+		if (map->type != dbg->map_type)
+			continue;
+		if (strncmp(map->dev_name, dbg->dev_name, MAX_NAME_LEN) != 0)
+			continue;
+		if (strncmp(map->name, dbg->state_name, MAX_NAME_LEN) != 0)
+			continue;
+
+		for (j = 0; j < map->data.configs.num_configs; j++) {
+			if (0 == strncmp(map->data.configs.group_or_pin,
+						dbg->pin_name, MAX_NAME_LEN)) {
+				/*
+				 * We found the right pin / state, read the
+				 * config and store the pctldev
+				 */
+				config = map->data.configs.configs[j];
+				pctldev = get_pinctrl_dev_from_devname
+					(map->ctrl_dev_name);
+				found = true;
+				break;
+			}
+		}
+	}
+
+	mutex_unlock(&pinctrl_mutex);
+
+	if (!found) {
+		seq_printf(s, "No config found for dev/state/pin, expected:\n");
+		seq_printf(s, "modify config_pins devname " \
+			   "state pinname value\n");
+	}
+
+	seq_printf(s, "Dev %s has config of %s in state %s: 0x%08lX\n",
+		   dbg->dev_name, dbg->pin_name,
+		   dbg->state_name, config);
+
+	if (pctldev)
+		confops = pctldev->desc->confops;
+
+	if (confops && confops->pin_config_config_dbg_show)
+		confops->pin_config_config_dbg_show(pctldev,
+						    s, config);
+	return 0;
+}
+
+/**
+ * pinconf_dbg_config_write() - overwrite the pinctrl config in the pinctrl
+ * map, of a pin/state pair based on pinname and state that have been
+ * selected with the debugfs entries pinconf-name and pinconf-state
+ * @user_buf: contains 'modify configs_pin devicename state pinname newvalue'
+ */
+static int pinconf_dbg_config_write(struct file *file,
+	const char __user *user_buf, size_t count, loff_t *ppos)
+{
+	struct pinctrl_maps *maps_node;
+	struct pinctrl_map const *map;
+	struct pinctrl_dev *pctldev = NULL;
+	struct pinconf_ops const *confops = NULL;
+	struct dbg_cfg *dbg = &pinconf_dbg_conf;
+	bool found = false;
+	char buf[128];
+	char *b = &buf[0];
+	int buf_size;
+	char *token;
+	struct pinctrl_map_configs const *configs;
+	int i;
+
+	/* Get userspace string and assure termination */
+	buf_size = min(count, (sizeof(buf)-1));
+	if (copy_from_user(buf, user_buf, buf_size))
+		return -EFAULT;
+
+	buf[buf_size] = 0;
+
+	/*
+	 * need to parse entry and extract parameters:
+	 * modify configs_pin devicename state pinname newvalue
+	 */
+
+	/* Get arg: 'modify' */
+	if (!strncmp(b, "modify ", strlen("modify "))) {
+		dbg->req_type = PINCONF_DBG_REQ_TYPE_MODIFY;
+		b += strlen("modify ");
+	} else {
+		return -EINVAL;
+	}
+
+	/* Get arg type: "config_pin" type supported so far */
+	if (!strncmp(b, "config_pins ", strlen("config_pins "))) {
+		dbg->map_type = PIN_MAP_TYPE_CONFIGS_PIN;
+		b += strlen("config_pins ");
+	} else {
+		return -EINVAL;
+	}
+
+	/* get arg 'device_name' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+	if (strlen(token) < MAX_NAME_LEN)
+		sscanf(token, "%s", dbg->dev_name);
+	else
+		return -EINVAL;
+
+	/* get arg 'state_name' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+	if (strlen(token) < MAX_NAME_LEN)
+		sscanf(token, "%s", dbg->state_name);
+	else
+		return -EINVAL;
+
+	/* get arg 'pin_name' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+	if (strlen(token) < MAX_NAME_LEN)
+		sscanf(token, "%s", dbg->pin_name);
+	else
+		return -EINVAL;
+
+	/* get new_value of config' */
+	token = strsep(&b, " ");
+	if (token == NULL)
+		return -EINVAL;
+
+	if (strlen(token) < MAX_NAME_LEN)
+		sscanf(token, "%s", dbg->config);
+	else
+		return -EINVAL;
+
+	mutex_lock(&pinctrl_mutex);
+
+	/* Parse the pinctrl map and look for the selected dev/state/pin */
+	for_each_maps(maps_node, i, map) {
+		if (strncmp(map->dev_name, dbg->dev_name, MAX_NAME_LEN) != 0)
+			continue;
+		if (map->type != dbg->map_type)
+			continue;
+		if (strncmp(map->name, dbg->state_name, MAX_NAME_LEN) != 0)
+			continue;
+
+		/*  we found the right pin / state, so overwrite config */
+		if (strncmp(map->data.configs.group_or_pin,
+			dbg->pin_name, MAX_NAME_LEN) == 0) {
+
+			found = true;
+			pctldev = get_pinctrl_dev_from_devname(
+					map->ctrl_dev_name);
+			configs = &map->data.configs;
+			break;
+		}
+	}
+
+	mutex_unlock(&pinctrl_mutex);
+
+	if (!found)
+		return -EINVAL;
+
+	if (pctldev)
+		confops = pctldev->desc->confops;
+
+	if (confops && confops->pin_config_dbg_set) {
+		for (i = 0; i < configs->num_configs; i++) {
+			confops->pin_config_dbg_set(pctldev,
+						    dbg->config,
+						    configs->configs[i]);
+		}
+	}
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
@@ -581,6 +810,8 @@ void pinconf_init_device_debugfs(struct dentry *devroot,
 			    devroot, pctldev, &pinconf_pins_ops);
 	debugfs_create_file("pinconf-groups", S_IFREG | S_IRUGO,
 			    devroot, pctldev, &pinconf_groups_ops);
+	debugfs_create_file("pinconf-config",  (S_IRUGO | S_IWUSR | S_IWGRP),
+			    devroot, pctldev, &pinconf_dbg_pinconfig_fops);
 }
 
 #endif
diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
index e7a7201..2cc8d2c 100644
--- a/include/linux/pinctrl/pinconf.h
+++ b/include/linux/pinctrl/pinconf.h
@@ -28,6 +28,7 @@ struct seq_file;
  * @pin_config_set: configure an individual pin
  * @pin_config_group_get: get configurations for an entire pin group
  * @pin_config_group_set: configure all pins in a group
+ * @pin_config_group_dbg_set: optional debugfs to modify a pin configuration
  * @pin_config_dbg_show: optional debugfs display hook that will provide
  *	per-device info for a certain pin in debugfs
  * @pin_config_group_dbg_show: optional debugfs display hook that will provide
@@ -51,6 +52,9 @@ struct pinconf_ops {
 	int (*pin_config_group_set) (struct pinctrl_dev *pctldev,
 				     unsigned selector,
 				     unsigned long config);
+	int (*pin_config_dbg_set) (struct pinctrl_dev *pctldev,
+				   const char *arg,
+				   unsigned long config);
 	void (*pin_config_dbg_show) (struct pinctrl_dev *pctldev,
 				     struct seq_file *s,
 				     unsigned offset);
-- 
1.7.11.3

