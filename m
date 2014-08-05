Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaHETtT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 15:49:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49417 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbaHETtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 15:49:14 -0400
Date: Tue, 5 Aug 2014 21:46:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/7] fs/proc/task_mmu.c: unify/simplify do_maps_open()
	and numa_maps_open()
Message-ID: <20140805194648.GA30718@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140805194627.GA30693@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_maps_open() and numa_maps_open() are overcomplicated, they could
use __seq_open_private(). Plus they do the same, just sizeof(*priv)
differs.

Change them to use a new simple helper, proc_maps_open(ops, psize).
This simplifies the code and allows us to do the next changes.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_mmu.c |   44 ++++++++++++++++----------------------------
 1 files changed, 16 insertions(+), 28 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8a5271e..794aeb6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -231,23 +231,23 @@ static void m_stop(struct seq_file *m, void *v)
 		put_task_struct(priv->task);
 }
 
+static int proc_maps_open(struct inode *inode, struct file *file,
+			const struct seq_operations *ops, int psize)
+{
+	struct proc_maps_private *priv = __seq_open_private(file, ops, psize);
+
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pid = proc_pid(inode);
+	return 0;
+}
+
 static int do_maps_open(struct inode *inode, struct file *file,
 			const struct seq_operations *ops)
 {
-	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+	return proc_maps_open(inode, file, ops,
+				sizeof(struct proc_maps_private));
 }
 
 static void
@@ -1502,20 +1502,8 @@ static const struct seq_operations proc_tid_numa_maps_op = {
 static int numa_maps_open(struct inode *inode, struct file *file,
 			  const struct seq_operations *ops)
 {
-	struct numa_maps_private *priv;
-	int ret = -ENOMEM;
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (priv) {
-		priv->proc_maps.pid = proc_pid(inode);
-		ret = seq_open(file, ops);
-		if (!ret) {
-			struct seq_file *m = file->private_data;
-			m->private = priv;
-		} else {
-			kfree(priv);
-		}
-	}
-	return ret;
+	return proc_maps_open(inode, file, ops,
+				sizeof(struct numa_maps_private));
 }
 
 static int pid_numa_maps_open(struct inode *inode, struct file *file)
-- 
1.5.5.1

