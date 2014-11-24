Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaKXWXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:23:43 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:64745 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaKXWXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:23:40 -0500
From: Leif Lindholm <leif.lindholm@linaro.org>
To: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org
Subject: [PATCH] of: support passing console options with stdout-path
Date: Mon, 24 Nov 2014 22:23:58 +0000
Message-Id: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support specifying console options (like with console=ttyXN,<options>)
by appending them to the stdout-path property after a separating ':'.

Example:
	stdout-path = "uart0:115200";

This patch also modifies of_find_node_by_path() to match only the
portion of the path before a ':'.

Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
---
 drivers/of/base.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 3823edf..89c6b33 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -37,6 +37,7 @@ EXPORT_SYMBOL(of_allnodes);
 struct device_node *of_chosen;
 struct device_node *of_aliases;
 struct device_node *of_stdout;
+static char *of_stdout_options;
 
 struct kset *of_kset;
 
@@ -703,6 +704,8 @@ static struct device_node *__of_find_node_by_path(struct device_node *parent,
 	if (!len)
 		return NULL;
 
+	len = strchrnul(path, ':') - path;
+
 	__for_each_child_of_node(parent, child) {
 		const char *name = strrchr(child->full_name, '/');
 		if (WARN(!name, "malformed device_node %s\n", child->full_name))
@@ -747,6 +750,8 @@ struct device_node *of_find_node_by_path(const char *path)
 		if (!of_aliases)
 			return NULL;
 
+		len = strchrnul(path, ':') - path;
+
 		for_each_property_of_node(of_aliases, pp) {
 			if (strlen(pp->name) == len && !strncmp(pp->name, path, len)) {
 				np = of_find_node_by_path(pp->value);
@@ -1830,8 +1835,12 @@ void of_alias_scan(void * (*dt_alloc)(u64 size, u64 align))
 			name = of_get_property(of_chosen, "linux,stdout-path", NULL);
 		if (IS_ENABLED(CONFIG_PPC) && !name)
 			name = of_get_property(of_aliases, "stdout", NULL);
-		if (name)
+		if (name) {
 			of_stdout = of_find_node_by_path(name);
+			of_stdout_options = strchr(name, ':');
+			if (of_stdout_options != NULL)
+				of_stdout_options++;
+		}
 	}
 
 	if (!of_aliases)
@@ -1957,7 +1966,7 @@ bool of_console_check(struct device_node *dn, char *name, int index)
 {
 	if (!dn || dn != of_stdout || console_set_on_cmdline)
 		return false;
-	return !add_preferred_console(name, index, NULL);
+	return !add_preferred_console(name, index, of_stdout_options);
 }
 EXPORT_SYMBOL_GPL(of_console_check);
 
-- 
1.9.1

