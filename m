Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaHKRDD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 13:03:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754495AbaHKRDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 13:03:00 -0400
Date: Mon, 11 Aug 2014 19:00:30 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Greg Ungerer <gerg@uclinux.org>
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
Subject: [PATCH 1/3] fs/proc/task_nommu.c: change maps_open() to use
	__seq_open_private()
Message-ID: <20140811170030.GA24793@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811170008.GA24629@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup and preparation. maps_open() can use __seq_open_private()
like proc_maps_open() does.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/proc/task_nommu.c |   22 +++++++---------------
 1 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
index 678455d..c12eab3 100644
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -268,21 +268,13 @@ static const struct seq_operations proc_tid_maps_ops = {
 static int maps_open(struct inode *inode, struct file *file,
 		     const struct seq_operations *ops)
 {
-	struct proc_maps_private *priv;
-	int ret = -ENOMEM;
-
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
+	struct proc_maps_private *priv = __seq_open_private(file, ops,
+					 sizeof(struct proc_maps_private));
+	if (!priv)
+		return -ENOMEM;
+
+	priv->pid = proc_pid(inode);
+	return 0;
 }
 
 static int pid_maps_open(struct inode *inode, struct file *file)
-- 
1.5.5.1

