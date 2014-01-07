Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365AbaAGSN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:13:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbaAGSNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:13:49 -0500
Date: Tue, 7 Jan 2014 19:13:19 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] change close_files() to use rcu_lock_acquire() to shut
	up RCU-lockdep
Message-ID: <20140107181319.GA29309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140107181258.GA29288@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_files_struct() and close_files() do rcu_read_lock() to make
rcu_dereference_check_fdtable() happy.

We can use rcu_lock_acquire(&rcu_lock_map) instead, this looks
self-explanatory and this is nop without CONFIG_DEBUG_LOCK_ALLOC().

While at it, change close_files() to return fdt, this avoids another
rcu_read_lock() + files_fdtable() in put_files_struct().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/file.c |   20 +++++++++-----------
 1 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 957cbc0..716d747 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -348,7 +348,7 @@ out:
 	return NULL;
 }
 
-static void close_files(struct files_struct * files)
+static struct fdtable *close_files(struct files_struct * files)
 {
 	int i, j;
 	struct fdtable *fdt;
@@ -358,11 +358,12 @@ static void close_files(struct files_struct * files)
 	/*
 	 * It is safe to dereference the fd table without RCU or
 	 * ->file_lock because this is the last reference to the
-	 * files structure.  But use RCU to shut RCU-lockdep up.
+	 * files structure. But we need to shut RCU-lockdep up.
 	 */
-	rcu_read_lock();
+	rcu_lock_acquire(&rcu_lock_map);
 	fdt = files_fdtable(files);
-	rcu_read_unlock();
+	rcu_lock_release(&rcu_lock_map);
+
 	for (;;) {
 		unsigned long set;
 		i = j * BITS_PER_LONG;
@@ -381,6 +382,8 @@ static void close_files(struct files_struct * files)
 			set >>= 1;
 		}
 	}
+
+	return fdt;
 }
 
 struct files_struct *get_files_struct(struct task_struct *task)
@@ -398,14 +401,9 @@ struct files_struct *get_files_struct(struct task_struct *task)
 
 void put_files_struct(struct files_struct *files)
 {
-	struct fdtable *fdt;
-
 	if (atomic_dec_and_test(&files->count)) {
-		close_files(files);
-		/* not really needed, since nobody can see us */
-		rcu_read_lock();
-		fdt = files_fdtable(files);
-		rcu_read_unlock();
+		struct fdtable *fdt = close_files(files);
+
 		/* free the arrays if they are not embedded */
 		if (fdt != &files->fdtab)
 			__free_fdtable(fdt);
-- 
1.5.5.1

