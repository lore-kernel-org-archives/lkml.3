Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbaJ1WPI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 18:15:08 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54106 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949AbaJ1WN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 18:13:59 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 3/9] drivers/md: Use rcu_dereference() for accessing rcu pointer
Date: Tue, 28 Oct 2014 15:09:56 -0700
Message-Id: <1414534202-27312-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20141028220944.GA26114@linux.vnet.ibm.com>
 <1414534202-27312-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102822-0033-0000-0000-0000028046C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranith Kumar <bobby.prani@gmail.com>

Got Paul's email wrong the first time.

The map field in 'struct mapped_device' is an rcu pointer. Use rcu_dereference()
while accessing it.

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 drivers/md/dm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 58f3927fd7cc..e7399362722e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2332,7 +2332,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 
 	merge_is_optional = dm_table_merge_is_optional(t);
 
-	old_map = md->map;
+	old_map = rcu_dereference(md->map);
 	rcu_assign_pointer(md->map, t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
 
@@ -2351,7 +2351,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
  */
 static struct dm_table *__unbind(struct mapped_device *md)
 {
-	struct dm_table *map = md->map;
+	struct dm_table *map = rcu_dereference(md->map);
 
 	if (!map)
 		return NULL;
@@ -2745,7 +2745,7 @@ int dm_suspend(struct mapped_device *md, unsigned suspend_flags)
 		goto out_unlock;
 	}
 
-	map = md->map;
+	map = rcu_dereference(md->map);
 
 	/*
 	 * DMF_NOFLUSH_SUSPENDING must be set before presuspend.
@@ -2839,7 +2839,7 @@ int dm_resume(struct mapped_device *md)
 	if (!dm_suspended_md(md))
 		goto out;
 
-	map = md->map;
+	map = rcu_dereference(md->map);
 	if (!map || !dm_table_get_size(map))
 		goto out;
 
-- 
1.8.1.5

