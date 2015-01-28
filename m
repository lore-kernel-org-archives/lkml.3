Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761949AbbA1UqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:46:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59833 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754163AbbA1UqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:46:20 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/base/node: Use device_create_files() and device_remove_files()
Date: Wed, 28 Jan 2015 21:46:14 +0100
Message-Id: <1422477974-8369-3-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422477974-8369-1-git-send-email-tiwai@suse.de>
References: <1422477974-8369-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new helper functions to simplify the code.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
 drivers/base/node.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index a3b82e9c7f20..e567e7bde333 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -200,6 +200,16 @@ static ssize_t node_read_distance(struct device *dev,
 }
 static DEVICE_ATTR(distance, S_IRUGO, node_read_distance, NULL);
 
+static const struct device_attribute *node_dev_attrs[] = {
+	&dev_attr_cpumap,
+	&dev_attr_cpulist,
+	&dev_attr_meminfo,
+	&dev_attr_numastat,
+	&dev_attr_distance,
+	&dev_attr_vmstat,
+	NULL
+};
+
 #ifdef CONFIG_HUGETLBFS
 /*
  * hugetlbfs per node attributes registration interface:
@@ -276,12 +286,7 @@ static int register_node(struct node *node, int num, struct node *parent)
 	error = device_register(&node->dev);
 
 	if (!error){
-		device_create_file(&node->dev, &dev_attr_cpumap);
-		device_create_file(&node->dev, &dev_attr_cpulist);
-		device_create_file(&node->dev, &dev_attr_meminfo);
-		device_create_file(&node->dev, &dev_attr_numastat);
-		device_create_file(&node->dev, &dev_attr_distance);
-		device_create_file(&node->dev, &dev_attr_vmstat);
+		device_create_files(&node->dev, node_dev_attrs);
 
 		hugetlb_register_node(node);
 
@@ -299,12 +304,7 @@ static int register_node(struct node *node, int num, struct node *parent)
  */
 void unregister_node(struct node *node)
 {
-	device_remove_file(&node->dev, &dev_attr_cpumap);
-	device_remove_file(&node->dev, &dev_attr_cpulist);
-	device_remove_file(&node->dev, &dev_attr_meminfo);
-	device_remove_file(&node->dev, &dev_attr_numastat);
-	device_remove_file(&node->dev, &dev_attr_distance);
-	device_remove_file(&node->dev, &dev_attr_vmstat);
+	device_remove_files(&node->dev, node_dev_attrs);
 
 	hugetlb_unregister_node(node);		/* no-op, if memoryless node */
 
-- 
2.2.2

