Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105Ab3ITUOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:14:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41678 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab3ITUOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:14:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Dipankar Sarma <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 23/93] rculist: list_first_or_null_rcu() should use list_entry_rcu()
Date: Fri, 20 Sep 2013 13:08:18 -0700
Message-Id: <1379707768-1804-24-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1379707768-1804-1-git-send-email-kamal@canonical.com>
References: <1379707768-1804-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit c34ac00caefbe49d40058ae7200bd58725cebb45 upstream.

list_first_or_null() should test whether the list is empty and return
pointer to the first entry if not in a RCU safe manner.  It's broken
in several ways.

* It compares __kernel @__ptr with __rcu @__next triggering the
  following sparse warning.

  net/core/dev.c:4331:17: error: incompatible types in comparison expression (different address spaces)

* It doesn't perform rcu_dereference*() and computes the entry address
  using container_of() directly from the __rcu pointer which is
  inconsitent with other rculist interface.  As a result, all three
  in-kernel users - net/core/dev.c, macvlan, cgroup - are buggy.  They
  dereference the pointer w/o going through read barrier.

* While ->next dereference passes through list_next_rcu(), the
  compiler is still free to fetch ->next more than once and thus
  nullify the "__ptr != __next" condition check.

Fix it by making list_first_or_null_rcu() dereference ->next directly
using ACCESS_ONCE() and then use list_entry_rcu() on it like other
rculist accessors.

v2: Paul pointed out that the compiler may fetch the pointer more than
    once nullifying the condition check.  ACCESS_ONCE() added on
    ->next dereference.

v3: Restored () around macro param which was accidentally removed.
    Spotted by Paul.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Patrick McHardy <kaber@trash.net>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/rculist.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index c92dd28..c9e7330 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -267,8 +267,9 @@ static inline void list_splice_init_rcu(struct list_head *list,
  */
 #define list_first_or_null_rcu(ptr, type, member) \
 	({struct list_head *__ptr = (ptr); \
-	  struct list_head __rcu *__next = list_next_rcu(__ptr); \
-	  likely(__ptr != __next) ? container_of(__next, type, member) : NULL; \
+	  struct list_head *__next = ACCESS_ONCE(__ptr->next); \
+	  likely(__ptr != __next) ? \
+		list_entry_rcu(__next, type, member) : NULL; \
 	})
 
 /**
-- 
1.8.1.2

