Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaBFX5O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 18:57:14 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:47518 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaBFX5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 18:57:12 -0500
Date: Thu, 6 Feb 2014 15:56:01 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Tejun Heo <tj@kernel.org>
cc: Filipe Brandenburger <filbranden@google.com>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>,
        Markus Blank-Burian <burian@muenster.de>,
        Shawn Bohrer <shawn.bohrer@gmail.com>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] cgroup: use an ordered workqueue for cgroup destruction
Message-ID: <alpine.LSU.2.11.1402061541560.31342@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes the cleanup after memcg hierarchy testing gets stuck in
mem_cgroup_reparent_charges(), unable to bring non-kmem usage down to 0.

There may turn out to be several causes, but a major cause is this: the
workitem to offline parent can get run before workitem to offline child;
parent's mem_cgroup_reparent_charges() circles around waiting for the
child's pages to be reparented to its lrus, but it's holding cgroup_mutex
which prevents the child from reaching its mem_cgroup_reparent_charges().

Just use an ordered workqueue for cgroup_destroy_wq.

Fixes: e5fca243abae ("cgroup: use a dedicated workqueue for cgroup destruction")
Suggested-by: Filipe Brandenburger <filbranden@google.com>
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: stable@vger.kernel.org # 3.10+
---

 kernel/cgroup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.14-rc1/kernel/cgroup.c	2014-02-02 18:49:07.737302111 -0800
+++ linux/kernel/cgroup.c	2014-02-06 15:20:35.548904965 -0800
@@ -4845,12 +4845,12 @@ static int __init cgroup_wq_init(void)
 	/*
 	 * There isn't much point in executing destruction path in
 	 * parallel.  Good chunk is serialized with cgroup_mutex anyway.
-	 * Use 1 for @max_active.
+	 * Must be ordered to make sure parent is offlined after children.
 	 *
 	 * We would prefer to do this in cgroup_init() above, but that
 	 * is called before init_workqueues(): so leave this until after.
 	 */
-	cgroup_destroy_wq = alloc_workqueue("cgroup_destroy", 0, 1);
+	cgroup_destroy_wq = alloc_ordered_workqueue("cgroup_destroy", 0);
 	BUG_ON(!cgroup_destroy_wq);
 
 	/*
