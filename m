Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3CDD5m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:57:42 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32992 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756748Ab3CDDoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:09 -0500
Message-Id: <20130304033714.130705521@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:38:14 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Li Zefan <lizefan@huawei.com>,
        Tejun Heo <tj@kernel.org>
Subject: [ 067/153] cgroup: fix exit() vs rmdir() race
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zefan <lizefan@huawei.com>

commit 71b5707e119653039e6e95213f00479668c79b75 upstream.

In cgroup_exit() put_css_set_taskexit() is called without any lock,
which might lead to accessing a freed cgroup:

thread1                           thread2
---------------------------------------------
exit()
  cgroup_exit()
    put_css_set_taskexit()
      atomic_dec(cgrp->count);
                                   rmdir();
      /* not safe !! */
      check_for_release(cgrp);

rcu_read_lock() can be used to make sure the cgroup is alive.

Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/cgroup.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -361,12 +361,20 @@ static void __put_css_set(struct css_set
 		struct cgroup *cgrp = link->cgrp;
 		list_del(&link->cg_link_list);
 		list_del(&link->cgrp_link_list);
+
+		/*
+		 * We may not be holding cgroup_mutex, and if cgrp->count is
+		 * dropped to 0 the cgroup can be destroyed at any time, hence
+		 * rcu_read_lock is used to keep it alive.
+		 */
+		rcu_read_lock();
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
 				set_bit(CGRP_RELEASABLE, &cgrp->flags);
 			check_for_release(cgrp);
 		}
+		rcu_read_unlock();
 
 		kfree(link);
 	}


