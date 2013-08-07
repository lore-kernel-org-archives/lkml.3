Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab3HGL3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 07:29:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54740 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757254Ab3HGL2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 07:28:38 -0400
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: [PATCH 2/3] memcg: Limit the number of events registered on oom_control
Date: Wed,  7 Aug 2013 13:28:26 +0200
Message-Id: <1375874907-22013-2-git-send-email-mhocko@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no limit for the maximum number of oom_control events
registered per memcg. This might lead to an user triggered memory
depletion if a regular user is allowed to register events.

Let's be more strict and cap the number of events that might be
registered. MAX_OOM_NOTIFY_EVENTS value is more or less random. The
expectation is that it should be high enough to cover reasonable
usecases while not too high to allow excessive resources consumption.
1024 events consume something like 24KB which shouldn't be a big deal
and it should be good enough (even 1024 oom notification events sounds
crazy).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8247db3..233317a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -273,6 +273,7 @@ struct mem_cgroup {
 	struct mem_cgroup_thresholds memsw_thresholds;
 
 	/* For oom notifier event fd */
+	unsigned int oom_notify_count;
 	struct list_head oom_notify;
 
 	/*
@@ -5571,6 +5572,8 @@ unlock:
 	mutex_unlock(&memcg->thresholds_lock);
 }
 
+/* Maximum number of oom notify events per memcg */
+#define MAX_OOM_NOTIFY_EVENTS 1024
 static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 	struct cftype *cft, struct eventfd_ctx *eventfd, const char *args)
 {
@@ -5578,10 +5581,25 @@ static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 	struct mem_cgroup_eventfd_list *event;
 	enum res_type type = MEMFILE_TYPE(cft->private);
 
+	spin_lock(&memcg_oom_lock);
+	if (memcg->oom_notify_count == MAX_OOM_NOTIFY_EVENTS) {
+		spin_unlock(&memcg_oom_lock);
+		return -ENOSPC;
+	}
+	/*
+	 * Be optimistic that the allocation succeds and increase the count
+	 * now. This all is done because we have to drop the memcg_oom_lock
+	 * while allocating.
+	 */
+	memcg->oom_notify_count++;
+	spin_unlock(&memcg_oom_lock);
+
 	BUG_ON(type != _OOM_TYPE);
 	event = kmalloc(sizeof(*event),	GFP_KERNEL);
-	if (!event)
+	if (!event) {
+		memcg->oom_notify_count--;
 		return -ENOMEM;
+	}
 
 	spin_lock(&memcg_oom_lock);
 
@@ -5611,6 +5629,7 @@ static void mem_cgroup_oom_unregister_event(struct cgroup *cgrp,
 		if (ev->eventfd == eventfd) {
 			list_del(&ev->list);
 			kfree(ev);
+			memcg->oom_notify_count--;
 		}
 	}
 
-- 
1.7.10.4

