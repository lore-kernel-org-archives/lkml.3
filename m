Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab3KFLs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:48:26 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:55619 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab3KFLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:48:17 -0500
Message-Id: <20131106114812.801879299@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 15:47:46 +0400
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
Subject: [patch 4/7] eventfd: Use sequential fdinfo engine
References: <20131106114742.988532945@openvz.org>
Content-Disposition: inline; filename=0003-procfs-eventfd-2
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
 fs/eventfd.c |   19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

Index: linux-2.6.git/fs/eventfd.c
===================================================================
--- linux-2.6.git.orig/fs/eventfd.c
+++ linux-2.6.git/fs/eventfd.c
@@ -287,23 +287,28 @@ static ssize_t eventfd_write(struct file
 }
 
 #ifdef CONFIG_PROC_FS
-static int eventfd_show_fdinfo(struct seq_file *m, struct file *f)
+static int seq_show(struct seq_file *m, void *v)
 {
-	struct eventfd_ctx *ctx = f->private_data;
-	int ret;
+	struct eventfd_ctx *ctx = ((struct file *)m->private)->private_data;
 
 	spin_lock_irq(&ctx->wqh.lock);
-	ret = seq_printf(m, "eventfd-count: %16llx\n",
-			 (unsigned long long)ctx->count);
+	seq_printf(m, "eventfd-count: %16llx\n", (unsigned long long)ctx->count);
 	spin_unlock_irq(&ctx->wqh.lock);
 
-	return ret;
+	return 0;
 }
+
+static struct seq_operations eventfd_fdinfo_op = {
+	.start		= single_start,
+	.next		= single_next,
+	.stop		= single_stop,
+	.show		= seq_show,
+};
 #endif
 
 static const struct file_operations eventfd_fops = {
 #ifdef CONFIG_PROC_FS
-	.show_fdinfo	= eventfd_show_fdinfo,
+	.fdinfo_op	= &eventfd_fdinfo_op,
 #endif
 	.release	= eventfd_release,
 	.poll		= eventfd_poll,

