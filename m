Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864Ab3J3UWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:22:30 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:53531 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3J3UW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:22:26 -0400
Message-Id: <20131030202221.365598265@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 Oct 2013 23:59:55 +0400
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
        Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 4/6] signalfd: Use sequential fdinfo engine
References: <20131030195951.201688764@openvz.org>
Content-Disposition: inline; filename=0004-procfs-signalfd
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
Cc: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/signalfd.c |   30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

Index: linux-2.6.git/fs/signalfd.c
===================================================================
--- linux-2.6.git.orig/fs/signalfd.c
+++ linux-2.6.git/fs/signalfd.c
@@ -230,9 +230,26 @@ static ssize_t signalfd_read(struct file
 }
 
 #ifdef CONFIG_PROC_FS
-static int signalfd_show_fdinfo(struct seq_file *m, struct file *f)
+static void *seq_start(struct seq_file *m, loff_t *pos)
 {
-	struct signalfd_ctx *ctx = f->private_data;
+	if (*pos == 0)
+		return m->private;
+	return NULL;
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+}
+
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	++*pos;
+	return NULL;
+}
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct signalfd_ctx *ctx = ((struct file *)v)->private_data;
 	sigset_t sigmask;
 
 	sigmask = ctx->sigmask;
@@ -241,11 +258,18 @@ static int signalfd_show_fdinfo(struct s
 
 	return 0;
 }
+
+static struct seq_operations signalfd_fdinfo_ops = {
+	.start		= seq_start,
+	.next		= seq_next,
+	.stop		= seq_stop,
+	.show		= seq_show,
+};
 #endif
 
 static const struct file_operations signalfd_fops = {
 #ifdef CONFIG_PROC_FS
-	.show_fdinfo	= signalfd_show_fdinfo,
+	.fdinfo_ops	= &signalfd_fdinfo_ops,
 #endif
 	.release	= signalfd_release,
 	.poll		= signalfd_poll,

