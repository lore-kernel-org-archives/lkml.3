Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791AbaEJD3q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 23:29:46 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:51568 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbaEJD3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 23:29:44 -0400
Date: Fri, 9 May 2014 23:29:41 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: kbuild test robot <fengguang.wu@intel.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.16] cgroup: fix rcu_read_lock() leak in
 update_if_frozen()
Message-ID: <20140510032941.GE22539@mtj.dyndns.org>
References: <5369104d.Nn5Lpp7nwOehwnnC%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5369104d.Nn5Lpp7nwOehwnnC%fengguang.wu@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While updating cgroup_freezer locking, 68fafb77d827 ("cgroup_freezer:
replace freezer->lock with freezer_mutex") introduced a bug in
update_if_frozen() where it returns with rcu_read_lock() held.  Fix it
by adding rcu_read_unlock() before returning.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
---
 kernel/cgroup_freezer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -267,8 +267,10 @@ static void update_if_frozen(struct cgro
 		struct freezer *child = css_freezer(pos);
 
 		if ((child->state & CGROUP_FREEZER_ONLINE) &&
-		    !(child->state & CGROUP_FROZEN))
+		    !(child->state & CGROUP_FROZEN)) {
+			rcu_read_unlock();
 			return;
+		}
 	}
 	rcu_read_unlock();
 
