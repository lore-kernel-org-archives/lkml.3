Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab3KFLwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:52:09 -0500
Received: from mail-lb0-f179.google.com ([209.85.217.179]:63015 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241Ab3KFLsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:48:18 -0500
Message-Id: <20131106114812.909228541@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 15:47:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        James Bottomley <jbottomley@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 5/7] signalfd: Use sequential fdinfo engine
References: <20131106114742.988532945@openvz.org>
Content-Disposition: inline; filename=0004-procfs-signalfd-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <jbottomley@parallels.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/signalfd.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

Index: linux-2.6.git/fs/signalfd.c
===================================================================
--- linux-2.6.git.orig/fs/signalfd.c
+++ linux-2.6.git/fs/signalfd.c
@@ -230,9 +230,9 @@ static ssize_t signalfd_read(struct file
 }
 
 #ifdef CONFIG_PROC_FS
-static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+static int seq_show(struct seq_file *m, void *v)
 {
-	struct signalfd_ctx *ctx = f->private_data;
+	struct signalfd_ctx *ctx = ((struct file *)m->private)->private_data;
 	sigset_t sigmask;
 
 	sigmask = ctx->sigmask;
@@ -241,11 +241,18 @@ static int signalfd_show_fdinfo(struct s
 
 	return 0;
 }
+
+static struct seq_operations signalfd_fdinfo_op = {
+	.start		= single_start,
+	.next		= single_next,
+	.stop		= single_stop,
+	.show		= seq_show,
+};
 #endif
 
 static const struct file_operations signalfd_fops = {
 #ifdef CONFIG_PROC_FS
-	.show_fdinfo	= signalfd_show_fdinfo,
+	.fdinfo_op	= &signalfd_fdinfo_op,
 #endif
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,

