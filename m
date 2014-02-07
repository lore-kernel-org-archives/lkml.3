Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbaBGTr1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:47:27 -0500
Received: from mga14.intel.com ([143.182.124.37]:32739 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaBGTr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:47:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,802,1384329600"; 
   d="scan'208";a="471566055"
From: Imre Deak <imre.deak@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: [PATCH] kernfs: skip lockdep annotation always if ignore_lockdep is set
Date: Fri,  7 Feb 2014 21:47:01 +0200
Message-Id: <1391802421-7829-1-git-send-email-imre.deak@intel.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We skip lockdep annotations for sysfs attributes with ignore_lockdep
set. An exception is kernfs_deactivate where we annotate even in this
case. Since the lockdep map key needed for the annotation is not
initialized whenever ignore_lockdep is set, we'll get a warning for
the uninitialized key.

Note that this happens since,

commit 517e64f57883bd63c5a4ab8b3d0d3ed68c55d0cf
Author: Tejun Heo <tj@kernel.org>
Date:   Thu Nov 28 14:54:29 2013 -0500

Before this change we had a valid key even in case of ignore_lockdep, so
the annotation in kernfs_deactivate worked, or at least didn't produce
the above warning. Fix this by skipping the annotation whenever
ignore_lockdep is set.

The actual attribute triggering the bug was 'delete_device' in
drivers/i2c/i2c-core.c, for the backtrace see the reference below.

Reported-by: Borislav Petkov <bp@alien8.de>
Reference: http://lists.freedesktop.org/archives/intel-gfx/2014-February/039663.html
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 fs/kernfs/dir.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 5104cf5..bd6e18b 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -187,19 +187,23 @@ static void kernfs_deactivate(struct kernfs_node *kn)
 
 	kn->u.completion = (void *)&wait;
 
-	rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
+	if (kn->flags & KERNFS_LOCKDEP)
+		rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
 	/* atomic_add_return() is a mb(), put_active() will always see
 	 * the updated kn->u.completion.
 	 */
 	v = atomic_add_return(KN_DEACTIVATED_BIAS, &kn->active);
 
 	if (v != KN_DEACTIVATED_BIAS) {
-		lock_contended(&kn->dep_map, _RET_IP_);
+		if (kn->flags & KERNFS_LOCKDEP)
+			lock_contended(&kn->dep_map, _RET_IP_);
 		wait_for_completion(&wait);
 	}
 
-	lock_acquired(&kn->dep_map, _RET_IP_);
-	rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	if (kn->flags & KERNFS_LOCKDEP) {
+		lock_acquired(&kn->dep_map, _RET_IP_);
+		rwsem_release(&kn->dep_map, 1, _RET_IP_);
+	}
 }
 
 /**
-- 
1.8.1.2

