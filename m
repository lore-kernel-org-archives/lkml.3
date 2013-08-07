Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334Ab3HGRa7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 13:30:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40051 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756581Ab3HGRa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 13:30:57 -0400
Date: Wed, 7 Aug 2013 19:30:51 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re: [PATCH 2/3] memcg: Limit the number of events registered on
 oom_control
Message-ID: <20130807173051.GD16343@dhcp22.suse.cz>
References: <1375874907-22013-1-git-send-email-mhocko@suse.cz>
 <1375874907-22013-2-git-send-email-mhocko@suse.cz>
 <20130807130836.GB27006@htj.dyndns.org>
 <20130807133746.GI8184@dhcp22.suse.cz>
 <20130807134741.GF27006@htj.dyndns.org>
 <20130807135734.GK8184@dhcp22.suse.cz>
 <20130807144730.GB13279@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130807144730.GB13279@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 07-08-13 16:47:30, Michal Hocko wrote:
> On Wed 07-08-13 15:57:34, Michal Hocko wrote:
> [...]
> > Hmm, OK so you think that the fd limit is sufficient already?
> 
> Hmm, that would need to touch the code as well (the register callback
> would need to make sure only one event is registered per cfile). But yes
> this way would be better. I will send a new patch once I have an idle
> moment.

What do you think about the following? I am not sure about EINVAL maybe
there is a better way to tell userspace it is doing something wrong. I
would appreciate any suggestions. If this looks good I will post a
similar patch for vmpressure.
---
>From 180614714348300836701bec618608059438efc2 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 7 Aug 2013 18:51:40 +0200
Subject: [PATCH] memcg: Limit the number of events registered on oom_control

There is no limit for the maximum number of oom_control events
registered per memcg. This might lead to an user triggered memory
depletion if a regular user is allowed to register events because one
file descriptor might be used for arbitrary number of registrations.

Let's be more strict and cap the number of events to the number of
open file descriptors. Teach mem_cgroup_oom_register_event to check
the registered events and fail if the given cftype (target file file
descriptor) has been already registered. This will cap the number of
events to the maximum number of allowed open files so no user who is
allowed to register event can runaway the an existing limit.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 mm/memcontrol.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8247db3..f893a39 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -212,6 +212,7 @@ struct mem_cgroup_thresholds {
 struct mem_cgroup_eventfd_list {
 	struct list_head list;
 	struct eventfd_ctx *eventfd;
+	struct cftype *cft;
 };
 
 static void mem_cgroup_threshold(struct mem_cgroup *memcg);
@@ -5577,6 +5578,7 @@ static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
 	struct mem_cgroup_eventfd_list *event;
 	enum res_type type = MEMFILE_TYPE(cft->private);
+	struct mem_cgroup_eventfd_list *ev, *tmp;
 
 	BUG_ON(type != _OOM_TYPE);
 	event = kmalloc(sizeof(*event),	GFP_KERNEL);
@@ -5585,7 +5587,20 @@ static int mem_cgroup_oom_register_event(struct cgroup *cgrp,
 
 	spin_lock(&memcg_oom_lock);
 
+	/*
+	 * Make sure that only one event is registered for the given
+	 * cftype - aka file descriptor. This caps the number of events
+	 * to number of file descriptors per process so the userspace doesn't
+	 * escape and depleate the memory.
+	 */
+	list_for_each_entry_safe(ev, tmp, &memcg->oom_notify, list) {
+		if (ev->cft == cft) {
+			kfree(event);
+			return -EINVAL;
+		}
+	}
 	event->eventfd = eventfd;
+	event->cft = cft;
 	list_add(&event->list, &memcg->oom_notify);
 
 	/* already in OOM ? */
-- 
1.7.10.4

-- 
Michal Hocko
SUSE Labs
