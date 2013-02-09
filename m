Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593Ab3BID2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 22:28:53 -0500
Received: from vms173013pub.verizon.net ([206.46.173.13]:38579 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542Ab3BID2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 22:28:52 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 22:28:52 EST
From: minyard@acm.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Corey Minyard <cminyard@mvista.com>
Subject: [PATCH] Move console redirect to pid namespace
Date: Fri, 08 Feb 2013 20:28:40 -0600
Message-id: <1360376920-30824-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corey Minyard <cminyard@mvista.com>

The console redirect - ioctl(fd, TIOCCONS) - is not in a namespace,
thus a container can do a redirect and grab all the I/O on the host
and all container consoles.

This change puts the redirect in the pid namespace.

Signed-off-by: Corey Minyard <cminyard@mvista.com>
---

I'm pretty sure this patch is not correct, but I'm not quite sure the
best way to fix this.  I'm not 100% sure that the pid namespace is the
right place, but it seemed the most reasonable of all the choices.  The
other obvious choice is the mount namespace, but it didn't seem as good
a fit.

The other problem is that I don't think you can call fput() from
destroy_pid_namespace().  That can be called from interrupt context,
and I don't think fput() is safe there.  I know it's not safe in 3.4
with the RT patch applied.  However, the only way I've come up with to
fix it is to add a workqueue, and that seems a bit heavy for this.

 drivers/tty/tty_io.c          |   29 ++++++++++++++++++-----------
 include/linux/pid_namespace.h |    1 +
 kernel/pid_namespace.c        |    3 +++
 3 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index da9fde8..c93c23d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -95,6 +95,7 @@
 #include <linux/seq_file.h>
 #include <linux/serial.h>
 #include <linux/ratelimit.h>
+#include <linux/pid_namespace.h>
 
 #include <linux/uaccess.h>
 
@@ -503,8 +504,10 @@ static const struct file_operations hung_up_tty_fops = {
 	.release	= tty_release,
 };
 
+/*
+ * redirect is in the pid namespace, but we use a global lock.
+ */
 static DEFINE_SPINLOCK(redirect_lock);
-static struct file *redirect;
 
 /**
  *	tty_wakeup	-	request more data
@@ -563,15 +566,17 @@ static void __tty_hangup(struct tty_struct *tty)
 	int    closecount = 0, n;
 	unsigned long flags;
 	int refs = 0;
+	struct file *redir;
 
 	if (!tty)
 		return;
 
 
 	spin_lock(&redirect_lock);
-	if (redirect && file_tty(redirect) == tty) {
-		f = redirect;
-		redirect = NULL;
+	redir = current->nsproxy->pid_ns->redirect;
+	if (redir && file_tty(redir) == tty) {
+		f = redir;
+		current->nsproxy->pid_ns->redirect = NULL;
 	}
 	spin_unlock(&redirect_lock);
 
@@ -1163,10 +1168,12 @@ ssize_t redirected_tty_write(struct file *file, const char __user *buf,
 						size_t count, loff_t *ppos)
 {
 	struct file *p = NULL;
+	struct file *redir;
 
 	spin_lock(&redirect_lock);
-	if (redirect)
-		p = get_file(redirect);
+	redir = current->nsproxy->pid_ns->redirect;
+	if (redir)
+		p = get_file(redir);
 	spin_unlock(&redirect_lock);
 
 	if (p) {
@@ -2247,19 +2254,19 @@ static int tioccons(struct file *file)
 	if (file->f_op->write == redirected_tty_write) {
 		struct file *f;
 		spin_lock(&redirect_lock);
-		f = redirect;
-		redirect = NULL;
+		f = current->nsproxy->pid_ns->redirect;
+		current->nsproxy->pid_ns->redirect = NULL;
 		spin_unlock(&redirect_lock);
 		if (f)
 			fput(f);
 		return 0;
 	}
 	spin_lock(&redirect_lock);
-	if (redirect) {
+	if (current->nsproxy->pid_ns->redirect) {
 		spin_unlock(&redirect_lock);
 		return -EBUSY;
 	}
-	redirect = get_file(file);
+	current->nsproxy->pid_ns->redirect = get_file(file);
 	spin_unlock(&redirect_lock);
 	return 0;
 }
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 215e5e3..b04870f 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -38,6 +38,7 @@ struct pid_namespace {
 	int hide_pid;
 	int reboot;	/* group exit code if this pidns was rebooted */
 	unsigned int proc_inum;
+	struct file *redirect;
 };
 
 extern struct pid_namespace init_pid_ns;
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index c1c3dc1..af1bfce 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -18,6 +18,7 @@
 #include <linux/proc_fs.h>
 #include <linux/reboot.h>
 #include <linux/export.h>
+#include <linux/file.h>
 
 #define BITS_PER_PAGE		(PAGE_SIZE*8)
 
@@ -138,6 +139,8 @@ static void destroy_pid_namespace(struct pid_namespace *ns)
 {
 	int i;
 
+	if (ns->redirect)
+	    fput(ns->redirect);
 	proc_free_inum(ns->proc_inum);
 	for (i = 0; i < PIDMAP_ENTRIES; i++)
 		kfree(ns->pidmap[i].page);
-- 
1.7.4.1

