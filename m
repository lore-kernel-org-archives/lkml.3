Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaBQVgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:58655 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753501AbaBQVgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH tip/core/rcu 09/12] fs: Substitute rcu_access_pointer() for rcu_dereference_raw()
Date: Mon, 17 Feb 2014 13:35:56 -0800
Message-Id: <1392672959-6386-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-8236-0000-0000-0000074EED31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

(Trivial patch.)

If the code is looking at the RCU-protected pointer itself, but not
dereferencing it, the rcu_dereference() functions can be downgraded to
rcu_access_pointer().  This commit makes this downgrade in __alloc_fd(),
which simply compares the RCU-protected pointer against NULL with no
dereferencing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
---
 fs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/file.c b/fs/file.c
index db25c2bdfe46..18f7d27855c4 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -497,7 +497,7 @@ repeat:
 	error = fd;
 #if 1
 	/* Sanity check */
-	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
+	if (rcu_access_pointer(fdt->fd[fd]) != NULL) {
 		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
 		rcu_assign_pointer(fdt->fd[fd], NULL);
 	}
-- 
1.8.1.5

