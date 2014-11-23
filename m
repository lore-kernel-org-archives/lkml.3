Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaKWQke (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 11:40:34 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:64594 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbaKWQkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 11:40:33 -0500
Message-ID: <1416760829.17888.19.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH ] drivers/md: use proper rcu accessor
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, dvhart@linux.intel.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
Date: Sun, 23 Nov 2014 08:40:29 -0800
In-Reply-To: <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
	 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20141121133145.GA17245@node.dhcp.inet.fi> <546F4C8C.4040904@gmail.com>
	 <20141121145817.GA17710@node.dhcp.inet.fi>
	 <CAJhHMCCE_p+xTibLZwoS5OqW--NO_uEVsW6tfN6LcgZGBquBTQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

rcu_dereference() should be used in sections protected by rcu_read_lock.

For writers, holding some kind of mutex or lock,
rcu_dereference_protected() is the way to go, adding explicit lockdep
bits.

In __unbind(), although there is no mutex or lock held, we are about
to free the mapped device, so can use the constant '1' instead of a
lockdep_is_held()

Reported-by: Kirill A. Shutemov <kirill@shutemov.name>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Fixes: 33423974bfc1 ("dm: Use rcu_dereference() for accessing rcu pointer")
Cc: Pranith Kumar <bobby.prani@gmail.com>
---
 drivers/md/dm.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a0ece87ad426..2e0aa2273382 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2335,7 +2335,8 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	merge_is_optional = dm_table_merge_is_optional(t);
 
-	old_map = rcu_dereference(md->map);
+	old_map = rcu_dereference_protected(md->map,
+					    lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
@@ -2355,7 +2356,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
  */
 static struct dm_table *__unbind(struct mapped_device *md)
 {
-	struct dm_table *map = rcu_dereference(md->map);
+	struct dm_table *map = rcu_dereference_protected(md->map, 1);
 
 	if (!map)
 		return NULL;
@@ -2850,7 +2851,8 @@ retry:
 		goto retry;
 	}
 
-	map = rcu_dereference(md->map);
+	map = rcu_dereference_protected(md->map,
+					lockdep_is_held(&md->suspend_lock));
 
 	r = __dm_suspend(md, map, suspend_flags, TASK_INTERRUPTIBLE);
 	if (r)


