Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab3JUJ1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 05:27:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39419 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504Ab3JUIvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:51:07 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Fengguang Wu" <fengguang.wu@intel.com>,
        "Li Zefan" <lizefan@huawei.com>,
        "Josh Triplett" <josh@joshtriplett.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Patrick McHardy" <kaber@trash.net>, "Tejun Heo" <tj@kernel.org>,
        "Dipankar Sarma" <dipankar@in.ibm.com>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.933204393@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 029/149] rculist: list_first_or_null_rcu() should use
 list_entry_rcu()
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/rculist.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -254,8 +254,9 @@ static inline void list_splice_init_rcu(
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

