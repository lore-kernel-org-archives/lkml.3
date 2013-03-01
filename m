Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab3CAUOg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 15:14:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51539 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938Ab3CATpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 14:45:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [ 63/77] cgroup: fix exit() vs rmdir() race
Date: Fri,  1 Mar 2013 11:44:48 -0800
Message-Id: <20130301194358.650244539@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130301194351.913471337@linuxfoundation.org>
References: <20130301194351.913471337@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -426,12 +426,20 @@ static void __put_css_set(struct css_set
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


