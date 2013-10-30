Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961Ab3J3UXo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 16:23:44 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42492 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752440Ab3J3UWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 16:22:24 -0400
Message-Id: <20131030202221.150139278@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 30 Oct 2013 23:59:53 +0400
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
Subject: [patch 2/6] epoll: Use sequential fdinfo engine
References: <20131030195951.201688764@openvz.org>
Content-Disposition: inline; filename=0002-procfs-fdinfo-epoll
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
 fs/eventpoll.c |   45 +++++++++++++++++++++++++++++++++------------
 1 file changed, 33 insertions(+), 12 deletions(-)

Index: linux-2.6.git/fs/eventpoll.c
===================================================================
--- linux-2.6.git.orig/fs/eventpoll.c
+++ linux-2.6.git/fs/eventpoll.c
@@ -834,32 +834,53 @@ static unsigned int ep_eventpoll_poll(st
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
+	return seq_printf(m, "tfd: %8d events: %8x data: %16llx\n",
+			  epi->ffd.fd, epi->event.events,
+			  (long long)epi->event.data);
+}
+
+static struct seq_operations ep_fdinfo_ops = {
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
+	.fdinfo_ops	= &ep_fdinfo_ops,
 #endif
 	.release	= ep_eventpoll_release,
 	.poll		= ep_eventpoll_poll,

