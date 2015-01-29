Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759758AbbA2L31 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 06:29:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56105 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbbA2L30 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 06:29:26 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/base/node: Avoid manual device_create_file() calls
Date: Thu, 29 Jan 2015 12:29:22 +0100
Message-Id: <1422530962-2460-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of manual calls of multiple device_create_file() and
device_remove_file(), use the static attribute groups assigned to the
new device.  This also fixes the possible races, too.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/node.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index a3b82e9c7f20..6ce1d4343cf0 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -200,6 +200,25 @@ static ssize_t node_read_distance(struct device *dev,
 }
 static DEVICE_ATTR(distance, S_IRUGO, node_read_distance, NULL);
 
+static struct attribute *node_dev_attrs[] = {
+	&dev_attr_cpumap.attr,
+	&dev_attr_cpulist.attr,
+	&dev_attr_meminfo.attr,
+	&dev_attr_numastat.attr,
+	&dev_attr_distance.attr,
+	&dev_attr_vmstat.attr,
+	NULL
+};
+
+static struct attribute_group node_dev_attr_group = {
+	.attrs	= node_dev_attrs,
+};
+
+static const struct attribute_group *node_dev_attr_groups[] = {
+	&node_dev_attr_group,
+	NULL
+};
+
 #ifdef CONFIG_HUGETLBFS
 /*
  * hugetlbfs per node attributes registration interface:
@@ -273,16 +292,10 @@ static int register_node(struct node *node, int num, struct node *parent)
 	node->dev.id = num;
 	node->dev.bus = &node_subsys;
 	node->dev.release = node_device_release;
+	node->dev.groups = node_dev_attr_groups;
 	error = device_register(&node->dev);
 
 	if (!error){
-		device_create_file(&node->dev, &dev_attr_cpumap);
-		device_create_file(&node->dev, &dev_attr_cpulist);
-		device_create_file(&node->dev, &dev_attr_meminfo);
-		device_create_file(&node->dev, &dev_attr_numastat);
-		device_create_file(&node->dev, &dev_attr_distance);
-		device_create_file(&node->dev, &dev_attr_vmstat);
-
 		hugetlb_register_node(node);
 
 		compaction_register_node(node);
@@ -299,13 +312,6 @@ static int register_node(struct node *node, int num, struct node *parent)
  */
 void unregister_node(struct node *node)
 {
-	device_remove_file(&node->dev, &dev_attr_cpumap);
-	device_remove_file(&node->dev, &dev_attr_cpulist);
-	device_remove_file(&node->dev, &dev_attr_meminfo);
-	device_remove_file(&node->dev, &dev_attr_numastat);
-	device_remove_file(&node->dev, &dev_attr_distance);
-	device_remove_file(&node->dev, &dev_attr_vmstat);
-
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
 	device_unregister(&node->dev);
-- 
2.2.2

