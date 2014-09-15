Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbaIOWMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:12:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50646 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932397AbaIOWMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Trond Myklebust <trond.myklebust@primarydata.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 144/187] NFS: Fix /proc/fs/nfsfs/servers and /proc/fs/nfsfs/volumes
Date: Mon, 15 Sep 2014 15:09:14 -0700
Message-Id: <1410818997-9432-145-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

commit 65b38851a17472d31fec9019fc3a55b0802dab88 upstream.

The usage of pid_ns->child_reaper->nsproxy->net_ns in
nfs_server_list_open and nfs_client_list_open is not safe.

/proc for a pid namespace can remain mounted after the all of the
process in that pid namespace have exited.  There are also times
before the initial process in a pid namespace has started or after the
initial process in a pid namespace has exited where
pid_ns->child_reaper can be NULL or stale.  Making the idiom
pid_ns->child_reaper->nsproxy a double whammy of problems.

Luckily all that needs to happen is to move /proc/fs/nfsfs/servers and
/proc/fs/nfsfs/volumes under /proc/net to /proc/net/nfsfs/servers and
/proc/net/nfsfs/volumes and add a symlink from the original location,
and to use seq_open_net as it has been designed.

Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/nfs/client.c   | 95 ++++++++++++++++++++++++++++++++-----------------------
 fs/nfs/inode.c    |  3 +-
 fs/nfs/internal.h |  9 ++++++
 fs/nfs/netns.h    |  3 ++
 4 files changed, 69 insertions(+), 41 deletions(-)

diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 1d09289..180d1ec 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -1205,7 +1205,7 @@ static const struct file_operations nfs_server_list_fops = {
 	.open		= nfs_server_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_net,
 	.owner		= THIS_MODULE,
 };
 
@@ -1226,7 +1226,7 @@ static const struct file_operations nfs_volume_list_fops = {
 	.open		= nfs_volume_list_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= seq_release_net,
 	.owner		= THIS_MODULE,
 };
 
@@ -1236,19 +1236,8 @@ static const struct file_operations nfs_volume_list_fops = {
  */
 static int nfs_server_list_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *m;
-	int ret;
-	struct pid_namespace *pid_ns = file->f_dentry->d_sb->s_fs_info;
-	struct net *net = pid_ns->child_reaper->nsproxy->net_ns;
-
-	ret = seq_open(file, &nfs_server_list_ops);
-	if (ret < 0)
-		return ret;
-
-	m = file->private_data;
-	m->private = net;
-
-	return 0;
+	return seq_open_net(inode, file, &nfs_server_list_ops,
+			   sizeof(struct seq_net_private));
 }
 
 /*
@@ -1256,7 +1245,7 @@ static int nfs_server_list_open(struct inode *inode, struct file *file)
  */
 static void *nfs_server_list_start(struct seq_file *m, loff_t *_pos)
 {
-	struct nfs_net *nn = net_generic(m->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(m), nfs_net_id);
 
 	/* lock the list against modification */
 	spin_lock(&nn->nfs_client_lock);
@@ -1268,7 +1257,7 @@ static void *nfs_server_list_start(struct seq_file *m, loff_t *_pos)
  */
 static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos)
 {
-	struct nfs_net *nn = net_generic(p->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(p), nfs_net_id);
 
 	return seq_list_next(v, &nn->nfs_client_list, pos);
 }
@@ -1278,7 +1267,7 @@ static void *nfs_server_list_next(struct seq_file *p, void *v, loff_t *pos)
  */
 static void nfs_server_list_stop(struct seq_file *p, void *v)
 {
-	struct nfs_net *nn = net_generic(p->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(p), nfs_net_id);
 
 	spin_unlock(&nn->nfs_client_lock);
 }
@@ -1289,7 +1278,7 @@ static void nfs_server_list_stop(struct seq_file *p, void *v)
 static int nfs_server_list_show(struct seq_file *m, void *v)
 {
 	struct nfs_client *clp;
-	struct nfs_net *nn = net_generic(m->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(m), nfs_net_id);
 
 	/* display header on line 1 */
 	if (v == &nn->nfs_client_list) {
@@ -1321,19 +1310,8 @@ static int nfs_server_list_show(struct seq_file *m, void *v)
  */
 static int nfs_volume_list_open(struct inode *inode, struct file *file)
 {
-	struct seq_file *m;
-	int ret;
-	struct pid_namespace *pid_ns = file->f_dentry->d_sb->s_fs_info;
-	struct net *net = pid_ns->child_reaper->nsproxy->net_ns;
-
-	ret = seq_open(file, &nfs_volume_list_ops);
-	if (ret < 0)
-		return ret;
-
-	m = file->private_data;
-	m->private = net;
-
-	return 0;
+	return seq_open_net(inode, file, &nfs_server_list_ops,
+			   sizeof(struct seq_net_private));
 }
 
 /*
@@ -1341,7 +1319,7 @@ static int nfs_volume_list_open(struct inode *inode, struct file *file)
  */
 static void *nfs_volume_list_start(struct seq_file *m, loff_t *_pos)
 {
-	struct nfs_net *nn = net_generic(m->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(m), nfs_net_id);
 
 	/* lock the list against modification */
 	spin_lock(&nn->nfs_client_lock);
@@ -1353,7 +1331,7 @@ static void *nfs_volume_list_start(struct seq_file *m, loff_t *_pos)
  */
 static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos)
 {
-	struct nfs_net *nn = net_generic(p->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(p), nfs_net_id);
 
 	return seq_list_next(v, &nn->nfs_volume_list, pos);
 }
@@ -1363,7 +1341,7 @@ static void *nfs_volume_list_next(struct seq_file *p, void *v, loff_t *pos)
  */
 static void nfs_volume_list_stop(struct seq_file *p, void *v)
 {
-	struct nfs_net *nn = net_generic(p->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(p), nfs_net_id);
 
 	spin_unlock(&nn->nfs_client_lock);
 }
@@ -1376,7 +1354,7 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 	struct nfs_server *server;
 	struct nfs_client *clp;
 	char dev[8], fsid[17];
-	struct nfs_net *nn = net_generic(m->private, nfs_net_id);
+	struct nfs_net *nn = net_generic(seq_file_net(m), nfs_net_id);
 
 	/* display header on line 1 */
 	if (v == &nn->nfs_volume_list) {
@@ -1407,6 +1385,45 @@ static int nfs_volume_list_show(struct seq_file *m, void *v)
 	return 0;
 }
 
+int nfs_fs_proc_net_init(struct net *net)
+{
+	struct nfs_net *nn = net_generic(net, nfs_net_id);
+	struct proc_dir_entry *p;
+
+	nn->proc_nfsfs = proc_net_mkdir(net, "nfsfs", net->proc_net);
+	if (!nn->proc_nfsfs)
+		goto error_0;
+
+	/* a file of servers with which we're dealing */
+	p = proc_create("servers", S_IFREG|S_IRUGO,
+			nn->proc_nfsfs, &nfs_server_list_fops);
+	if (!p)
+		goto error_1;
+
+	/* a file of volumes that we have mounted */
+	p = proc_create("volumes", S_IFREG|S_IRUGO,
+			nn->proc_nfsfs, &nfs_volume_list_fops);
+	if (!p)
+		goto error_2;
+	return 0;
+
+error_2:
+	remove_proc_entry("servers", nn->proc_nfsfs);
+error_1:
+	remove_proc_entry("fs/nfsfs", NULL);
+error_0:
+	return -ENOMEM;
+}
+
+void nfs_fs_proc_net_exit(struct net *net)
+{
+	struct nfs_net *nn = net_generic(net, nfs_net_id);
+
+	remove_proc_entry("volumes", nn->proc_nfsfs);
+	remove_proc_entry("servers", nn->proc_nfsfs);
+	remove_proc_entry("fs/nfsfs", NULL);
+}
+
 /*
  * initialise the /proc/fs/nfsfs/ directory
  */
@@ -1419,14 +1436,12 @@ int __init nfs_fs_proc_init(void)
 		goto error_0;
 
 	/* a file of servers with which we're dealing */
-	p = proc_create("servers", S_IFREG|S_IRUGO,
-			proc_fs_nfs, &nfs_server_list_fops);
+	p = proc_symlink("servers", proc_fs_nfs, "../../net/nfsfs/servers");
 	if (!p)
 		goto error_1;
 
 	/* a file of volumes that we have mounted */
-	p = proc_create("volumes", S_IFREG|S_IRUGO,
-			proc_fs_nfs, &nfs_volume_list_fops);
+	p = proc_symlink("volumes", proc_fs_nfs, "../../net/nfsfs/volumes");
 	if (!p)
 		goto error_2;
 	return 0;
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 25063e1..be955cf 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1767,11 +1767,12 @@ EXPORT_SYMBOL_GPL(nfs_net_id);
 static int nfs_net_init(struct net *net)
 {
 	nfs_clients_init(net);
-	return 0;
+	return nfs_fs_proc_net_init(net);
 }
 
 static void nfs_net_exit(struct net *net)
 {
+	nfs_fs_proc_net_exit(net);
 	nfs_cleanup_cb_ident_idr(net);
 }
 
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index b46cf5a..18537f9 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -195,7 +195,16 @@ extern struct rpc_clnt *nfs4_find_or_create_ds_client(struct nfs_client *,
 #ifdef CONFIG_PROC_FS
 extern int __init nfs_fs_proc_init(void);
 extern void nfs_fs_proc_exit(void);
+extern int nfs_fs_proc_net_init(struct net *net);
+extern void nfs_fs_proc_net_exit(struct net *net);
 #else
+static inline int nfs_fs_proc_net_init(struct net *net)
+{
+	return 0;
+}
+static inline void nfs_fs_proc_net_exit(struct net *net)
+{
+}
 static inline int nfs_fs_proc_init(void)
 {
 	return 0;
diff --git a/fs/nfs/netns.h b/fs/nfs/netns.h
index 8ee1fab..ef221fb 100644
--- a/fs/nfs/netns.h
+++ b/fs/nfs/netns.h
@@ -29,6 +29,9 @@ struct nfs_net {
 #endif
 	spinlock_t nfs_client_lock;
 	struct timespec boot_time;
+#ifdef CONFIG_PROC_FS
+	struct proc_dir_entry *proc_nfsfs;
+#endif
 };
 
 extern int nfs_net_id;
-- 
1.9.1

