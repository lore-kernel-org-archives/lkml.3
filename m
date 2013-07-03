Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965120Ab3GCUUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:20:50 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:24339 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab3GCUUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:20:47 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Mike Marciniszyn <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v3 05/25] infiniband: Change how dentry's d_lock field is accessed
Date: Wed,  3 Jul 2013 16:20:31 -0400
Message-Id: <1372882831-22671-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of the changes made in dcache.h header file, files that
use the d_lock field of the dentry structure need to be changed
accordingly. All the d_lock's spin_lock() and spin_unlock() calls
are replaced by the corresponding d_lock() and d_unlock() calls.
There is no change in logic and everything should just work.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 drivers/infiniband/hw/ipath/ipath_fs.c |    6 +++---
 drivers/infiniband/hw/qib/qib_fs.c     |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_fs.c b/drivers/infiniband/hw/ipath/ipath_fs.c
index e0c404b..1efee26 100644
--- a/drivers/infiniband/hw/ipath/ipath_fs.c
+++ b/drivers/infiniband/hw/ipath/ipath_fs.c
@@ -277,14 +277,14 @@ static int remove_file(struct dentry *parent, char *name)
 		goto bail;
 	}
 
-	spin_lock(&tmp->d_lock);
+	d_lock(tmp);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
-		spin_unlock(&tmp->d_lock);
+		d_unlock(tmp);
 		simple_unlink(parent->d_inode, tmp);
 	} else
-		spin_unlock(&tmp->d_lock);
+		d_unlock(tmp);
 
 	ret = 0;
 bail:
diff --git a/drivers/infiniband/hw/qib/qib_fs.c b/drivers/infiniband/hw/qib/qib_fs.c
index f247fc6..63713ee 100644
--- a/drivers/infiniband/hw/qib/qib_fs.c
+++ b/drivers/infiniband/hw/qib/qib_fs.c
@@ -454,14 +454,14 @@ static int remove_file(struct dentry *parent, char *name)
 		goto bail;
 	}
 
-	spin_lock(&tmp->d_lock);
+	d_lock(tmp);
 	if (!(d_unhashed(tmp) && tmp->d_inode)) {
 		dget_dlock(tmp);
 		__d_drop(tmp);
-		spin_unlock(&tmp->d_lock);
+		d_unlock(tmp);
 		simple_unlink(parent->d_inode, tmp);
 	} else {
-		spin_unlock(&tmp->d_lock);
+		d_unlock(tmp);
 	}
 
 	ret = 0;
-- 
1.7.1

