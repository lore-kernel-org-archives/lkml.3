Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab3DPS3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 14:29:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40429 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965239Ab3DPS1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 14:27:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 21/28] dgrp: Clean up the use of procfs [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, devel@driverdev.osuosl.org,
        Tommi Rantala <tt.rantala@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, viro@zeniv.linux.org.uk
Date: Tue, 16 Apr 2013 19:27:13 +0100
Message-ID: <20130416182713.27773.66239.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the use of procfs by the dgrp driver:

 (1) Use remove_proc_subtree() for the mass slaughter of a subdir full of proc
     files rather than doing it manually.

 (2) When creating files, only call ID_TO_CHAR() once to generate the name.

Signed-off-by : David Howells <dhowells@redhat.com>
cc: Bill Pemberton <wfp5p@virginia.edu>
cc: Tommi Rantala <tt.rantala@gmail.com>
cc: devel@driverdev.osuosl.org
---

 drivers/staging/dgrp/dgrp_specproc.c |   82 ++++++++++++----------------------
 1 file changed, 28 insertions(+), 54 deletions(-)

diff --git a/drivers/staging/dgrp/dgrp_specproc.c b/drivers/staging/dgrp/dgrp_specproc.c
index 205d80e..e3c16a9 100644
--- a/drivers/staging/dgrp/dgrp_specproc.c
+++ b/drivers/staging/dgrp/dgrp_specproc.c
@@ -45,13 +45,8 @@
 
 #include "dgrp_common.h"
 
-static struct proc_dir_entry *dgrp_proc_dir_entry;
-
 static int dgrp_add_id(long id);
 static int dgrp_remove_nd(struct nd_struct *nd);
-static struct proc_dir_entry *add_proc_file(struct nd_struct *node,
-				 struct proc_dir_entry *root,
-				 const struct file_operations *fops);
 
 /* File operation declarations */
 static int parse_write_config(char *);
@@ -94,51 +89,23 @@ static struct proc_dir_entry *mon_entry_pointer;
 static struct proc_dir_entry *dpa_entry_pointer;
 static struct proc_dir_entry *ports_entry_pointer;
 
-static void remove_files(struct nd_struct *nd)
-{
-	char buf[3];
-	ID_TO_CHAR(nd->nd_ID, buf);
-	dgrp_remove_node_class_sysfs_files(nd);
-	if (nd->nd_net_de)
-		remove_proc_entry(buf, net_entry_pointer);
-	if (nd->nd_mon_de)
-		remove_proc_entry(buf, mon_entry_pointer);
-	if (nd->nd_dpa_de)
-		remove_proc_entry(buf, dpa_entry_pointer);
-	if (nd->nd_ports_de)
-		remove_proc_entry(buf, ports_entry_pointer);
-}
-
 void dgrp_unregister_proc(void)
 {
+	struct nd_struct *nd;
+
 	net_entry_pointer = NULL;
 	mon_entry_pointer = NULL;
 	dpa_entry_pointer = NULL;
 	ports_entry_pointer = NULL;
 
-	if (dgrp_proc_dir_entry) {
-		struct nd_struct *nd;
-		list_for_each_entry(nd, &nd_struct_list, list)
-			remove_files(nd);
-		remove_proc_entry("dgrp/config", NULL);
-		remove_proc_entry("dgrp/info", NULL);
-		remove_proc_entry("dgrp/nodeinfo", NULL);
-		remove_proc_entry("dgrp/net", NULL);
-		remove_proc_entry("dgrp/mon", NULL);
-		remove_proc_entry("dgrp/dpa", NULL);
-		remove_proc_entry("dgrp/ports", NULL);
-		remove_proc_entry("dgrp", NULL);
-		dgrp_proc_dir_entry = NULL;
-	}
+	list_for_each_entry(nd, &nd_struct_list, list)
+		dgrp_remove_node_class_sysfs_files(nd);
+	remove_proc_subtree("dgrp", NULL);
 }
 
 void dgrp_register_proc(void)
 {
-	/*
-	 *	Register /proc/dgrp
-	 */
-	dgrp_proc_dir_entry = proc_mkdir("dgrp", NULL);
-	if (!dgrp_proc_dir_entry)
+	if (!proc_mkdir("dgrp", NULL))
 		return;
 	proc_create("dgrp/config", 0644, NULL, &config_proc_file_ops);
 	proc_create("dgrp/info", 0644, NULL, &info_proc_file_ops);
@@ -455,6 +422,14 @@ static int dgrp_nodeinfo_proc_open(struct inode *inode, struct file *file)
 	return seq_open(file, &nodeinfo_ops);
 }
 
+static struct proc_dir_entry *add_proc_file(struct nd_struct *nd,
+					    const char *name,
+					    struct proc_dir_entry *root,
+					    const struct file_operations *fops)
+{
+	return proc_create_data(name, 0600, root, fops, nd);
+}
+
 /**
  * dgrp_add_id() -- creates new nd struct and adds it to list
  * @id: id of device to add
@@ -462,6 +437,7 @@ static int dgrp_nodeinfo_proc_open(struct inode *inode, struct file *file)
 static int dgrp_add_id(long id)
 {
 	struct nd_struct *nd;
+	char name[3];
 	int ret;
 	int i;
 
@@ -496,11 +472,11 @@ static int dgrp_add_id(long id)
 		goto error_out;
 
 	dgrp_create_node_class_sysfs_files(nd);
-	nd->nd_net_de = add_proc_file(nd, net_entry_pointer, &dgrp_net_ops);
-	nd->nd_mon_de = add_proc_file(nd, mon_entry_pointer, &dgrp_mon_ops);
-	nd->nd_dpa_de = add_proc_file(nd, dpa_entry_pointer, &dgrp_dpa_ops);
-	nd->nd_ports_de = add_proc_file(nd, ports_entry_pointer,
-					&dgrp_ports_ops);
+	ID_TO_CHAR(nd->nd_ID, name);
+	add_proc_file(nd, name, net_entry_pointer, &dgrp_net_ops);
+	add_proc_file(nd, name, mon_entry_pointer, &dgrp_mon_ops);
+	add_proc_file(nd, name, dpa_entry_pointer, &dgrp_dpa_ops);
+	add_proc_file(nd, name, ports_entry_pointer, &dgrp_ports_ops);
 	return 0;
 
 	/* FIXME this guy should free the tty driver stored in nd and destroy
@@ -513,13 +489,20 @@ error_out:
 
 static int dgrp_remove_nd(struct nd_struct *nd)
 {
+	char name[3];
 	int ret;
 
 	/* Check to see if the selected structure is in use */
 	if (nd->nd_tty_ref_cnt)
 		return -EBUSY;
 
-	remove_files(nd);
+
+	dgrp_remove_node_class_sysfs_files(nd);
+	ID_TO_CHAR(nd->nd_ID, name);
+	remove_proc_entry(name, net_entry_pointer);
+	remove_proc_entry(name, mon_entry_pointer);
+	remove_proc_entry(name, dpa_entry_pointer);
+	remove_proc_entry(name, ports_entry_pointer);
 
 	dgrp_tty_uninit(nd);
 
@@ -530,12 +513,3 @@ static int dgrp_remove_nd(struct nd_struct *nd)
 	kfree(nd);
 	return 0;
 }
-
-static struct proc_dir_entry *add_proc_file(struct nd_struct *node,
-				 struct proc_dir_entry *root,
-				 const struct file_operations *fops)
-{
-	char buf[3];
-	ID_TO_CHAR(node->nd_ID, buf);
-	return proc_create_data(buf, 0600, root, fops, node);
-}

