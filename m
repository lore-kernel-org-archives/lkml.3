Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaAKST3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jan 2014 13:19:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbaAKST1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jan 2014 13:19:27 -0500
Date: Sat, 11 Jan 2014 19:19:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] change close_files() to use
	rcu_dereference_raw(files->fdt)
Message-ID: <20140111181953.GC7358@redhat.com>
References: <20140107181258.GA29288@redhat.com> <20140108132852.GF10038@linux.vnet.ibm.com> <20140108151918.GA5156@redhat.com> <20140109011650.GI10038@linux.vnet.ibm.com> <20140110153459.GA31491@redhat.com> <20140111063438.GY10038@linux.vnet.ibm.com> <20140111181908.GA7358@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140111181908.GA7358@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_files_struct() and close_files() do rcu_read_lock() to make
rcu_dereference_check_fdtable() happy.

This looks a bit ugly, files_fdtable() just reads the pointer,
we can simply use rcu_dereference_raw() to avoid the warning.

The patch also changes close_files() to return fdt, this avoids
another rcu_read_lock()/files_fdtable() in put_files_struct().

I think close_files() needs more cleanups:

	- we do not need xchg() exactly because we are the last
	  user of this files_struct

	- "if (file)" should be turned into WARN_ON(!file)

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/file.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 957cbc0..d34e59e 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -348,21 +348,16 @@ out:
 	return NULL;
 }
 
-static void close_files(struct files_struct * files)
+static struct fdtable *close_files(struct files_struct * files)
 {
-	int i, j;
-	struct fdtable *fdt;
-
-	j = 0;
-
 	/*
 	 * It is safe to dereference the fd table without RCU or
 	 * ->file_lock because this is the last reference to the
-	 * files structure.  But use RCU to shut RCU-lockdep up.
+	 * files structure.
 	 */
-	rcu_read_lock();
-	fdt = files_fdtable(files);
-	rcu_read_unlock();
+	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
+	int i, j = 0;
+
 	for (;;) {
 		unsigned long set;
 		i = j * BITS_PER_LONG;
@@ -381,6 +376,8 @@ static void close_files(struct files_struct * files)
 			set >>= 1;
 		}
 	}
+
+	return fdt;
 }
 
 struct files_struct *get_files_struct(struct task_struct *task)
@@ -398,14 +395,9 @@ struct files_struct *get_files_struct(struct task_struct *task)
 
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


