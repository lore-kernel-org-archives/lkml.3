Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3HTCmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:42:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39649 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3HTCmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:42:25 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Tejun Heo <tj@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>, Li Zefan <lizefan@huawei.com>,
        Patrick McHardy <kaber@trash.net>, stable@vger.kernel.org
Subject: [PATCH tip/core/rcu 6/9] rculist: list_first_or_null_rcu() should use list_entry_rcu()
Date: Mon, 19 Aug 2013 19:42:11 -0700
Message-Id: <1376966534-30775-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20130820024148.GA30283@linux.vnet.ibm.com>
 <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A46F30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

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
Cc: stable@vger.kernel.org
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 include/linux/rculist.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index f4b1001..4106721 100644
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
1.8.1.5

