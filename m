Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203Ab3ISIRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:17:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:32786 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780Ab3ISIQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:16:59 -0400
Date: Thu, 19 Sep 2013 10:16:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vince@deater.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org, eranian@googlemail.com
Subject: Re: [tip:perf/core] perf: Fix broken union in ' struct
 perf_event_mmap_page'
Message-ID: <20130919081642.GL9326@twins.programming.kicks-ass.net>
References: <1372425741-1676-2-git-send-email-adrian.hunter@intel.com>
 <tip-860f085b74e9f0075de8140ed3a1e5b5e3e39aa8@git.kernel.org>
 <alpine.DEB.2.02.1309171617400.13303@pianoman.cluster.toy>
 <20130918085722.GL12926@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181013100.23210@pianoman.cluster.toy>
 <20130918154224.GK9326@twins.programming.kicks-ass.net>
 <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1309181556370.26402@pianoman.cluster.toy>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 18, 2013 at 04:07:52PM -0400, Vince Weaver wrote:
> It would be nice if there was some way to detect this change; I liked the 
> idea of a "cap_usr_fixed" bit.

How about we start using the version field for this? Arguably we should
have incremented that value every time we changed the thing but we might
as well start now.

---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dd236b6..c44d55c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3660,6 +3660,25 @@ static void calc_timer_values(struct perf_event *event,
 	*running = ctx_time - event->tstamp_running;
 }
 
+static void perf_event_init_userpage(struct perf_event *event)
+{
+	struct perf_event_mmap_page *userpg;
+	struct ring_buffer *rb;
+
+	rcu_read_lock();
+	rb = rcu_dereference(event->rb);
+	if (!rb)
+		goto unlock;
+
+	userpg = rb->user_page;
+
+	userpg->version = 1;
+	userpg->compat_version = 0;
+
+unlock:
+	rcu_read_unlock();
+}
+
 void __weak arch_perf_update_userpage(struct perf_event_mmap_page *userpg, u64 now)
 {
 }
@@ -4044,6 +4063,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	ring_buffer_attach(event, rb);
 	rcu_assign_pointer(event->rb, rb);
 
+	perf_event_init_userpage(event);
 	perf_event_update_userpage(event);
 
 unlock:
