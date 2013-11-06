Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab3KFLsU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 06:48:20 -0500
Received: from mail-lb0-f181.google.com ([209.85.217.181]:51958 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932232Ab3KFLsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 06:48:17 -0500
Message-Id: <20131106114812.694531787@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 15:47:45 +0400
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
Subject: [patch 3/7] epoll: Use sequential fdinfo engine
References: <20131106114742.988532945@openvz.org>
Content-Disposition: inline; filename=0002-procfs-fdinfo-epoll-2
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
 fs/eventpoll.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

Index: linux-2.6.git/fs/eventpoll.c
===================================================================
--- linux-2.6.git.orig/fs/eventpoll.c
+++ linux-2.6.git/fs/eventpoll.c
@@ -833,32 +833,54 @@ static unsigned int ep_eventpoll_poll(st
 }
 
 #ifdef CONFIG_PROC_FS
-static int ep_show_fdinfo(struct seq_file *m, struct file *f)
+static void *seq_start(struct seq_file *m, loff_t *pos)
 {
-	struct eventpoll *ep = f->private_data;
+	struct eventpoll *ep = ((struct file *)m->private)->private_data;
 	struct rb_node *rbp;
-	int ret = 0;
+	loff_t num = *pos;
 
 	mutex_lock(&ep->mtx);
 	for (rbp = rb_first(&ep->rbr); rbp; rbp = rb_next(rbp)) {
-		struct epitem *epi = rb_entry(rbp, struct epitem, rbn);
-
-		ret = seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
-				 epi->ffd.fd, epi->event.events,
-				 (long long)epi->event.data);
-		if (ret)
-			break;
+		if (num-- == 0)
+			return rbp;
 	}
+	return NULL;
+}
+
+static void seq_stop(struct seq_file *m, void *v)
+{
+	struct eventpoll *ep = ((struct file *)m->private)->private_data;
 	mutex_unlock(&ep->mtx);
+}
 
-	return ret;
+static void *seq_next(struct seq_file *m, void *p, loff_t *pos)
+{
+	++*pos;
+	return (void *)rb_next(p);
 }
+
+static int seq_show(struct seq_file *m, void *v)
+{
+	struct epitem *epi = rb_entry(v, struct epitem, rbn);
+
+	seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+		   epi->ffd.fd, epi->event.events,
+		   (long long)epi->event.data);
+	return 0;
+}
+
+static struct seq_operations ep_fdinfo_op = {
+	.start		= seq_start,
+	.next		= seq_next,
+	.stop		= seq_stop,
+	.show		= seq_show,
+};
 #endif
 
 /* File callbacks that implement the eventpoll file behaviour */
 static const struct file_operations eventpoll_fops = {
 #ifdef CONFIG_PROC_FS
-	.show_fdinfo	= ep_show_fdinfo,
+	.fdinfo_op	= &ep_fdinfo_op,
 #endif
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll,

