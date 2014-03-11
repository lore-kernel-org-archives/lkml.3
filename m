Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbaCKA4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 20:56:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63722 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbaCKA4n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 20:56:43 -0400
Date: Tue, 11 Mar 2014 01:56:12 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Stephane Eranian <eranian@google.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [reboot] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655
 perf_swevent_add()
Message-ID: <20140311005611.GA1286@krava.redhat.com>
References: <20140308065153.GA30311@localhost>
 <20140310125319.GE26334@krava.redhat.com>
 <20140310224023.GA1205@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310224023.GA1205@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 10, 2014 at 11:40:23PM +0100, Jiri Olsa wrote:
> On Mon, Mar 10, 2014 at 01:53:19PM +0100, Jiri Olsa wrote:
> > On Sat, Mar 08, 2014 at 02:51:53PM +0800, Fengguang Wu wrote:
> > > 
> > > Hi all,
> > > 
> > > This is a very old WARNING, too old to be bisectable. The below 3 different
> > > back traces show that it's always triggered by trinity at system reboot time.
> > > Any ideas to quiet it? Thank you!
> > 
> > hi,
> > is there cpu hotplug involved? like writing to:
> >   /sys/devices/system/cpu/cpu*/online
> > 
> 
> I think there's race with hotplug code,
> I can reproduce this with:
> 
>   $ ./perf record -e faults ./perf bench sched pipe
> 
> and put one of the cpus offline:
> 
>   [root@krava cpu]# pwd
>   /sys/devices/system/cpu
>   [root@krava cpu]# echo 0 > cpu1/online 

the perf cpu offline callback takes down all cpu context events
and release swhash->swevent_hlist

this could race with task context software events being
just scheduled in on this cpu via perf_swevent_add
(note only cpu ctx events are terminated in the hotplug code)

the race happens in the gap between the cpu notifier code and the
cpu being actually taken down (and become un-sched-able)

I wonder what should we do:

- terminate task ctx events on hotplug-ed cpu (same as for cpu ctx)
  this seems too much..

- schedule out task ctx events on hotplug-ed cpu
  we might race again with another events sched in (during the race gap)
  (if this could be prevented, this would be the best option i think)

- dont release that 'struct swevent_hlist' at all.. it's about 2KB size per cpu

- remove the warning ;-) or make it omit the hotplug-ed cpu case, so
  we dont loose potentional bug warning, please check attached patch

thoughts?
jirka


---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 661951a..a53857e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5423,6 +5423,8 @@ struct swevent_htable {
 
 	/* Recursion avoidance in each contexts */
 	int				recursion[PERF_NR_CONTEXTS];
+
+	bool				offline;
 };
 
 static DEFINE_PER_CPU(struct swevent_htable, swevent_htable);
@@ -5669,8 +5671,10 @@ static int perf_swevent_add(struct perf_event *event, int flags)
 	hwc->state = !(flags & PERF_EF_START);
 
 	head = find_swevent_head(swhash, event);
-	if (WARN_ON_ONCE(!head))
+	if (!head) {
+		WARN_ON_ONCE(!swhash->offline);
 		return -EINVAL;
+	}
 
 	hlist_add_head_rcu(&event->hlist_entry, head);
 
@@ -7850,6 +7854,7 @@ static void perf_event_init_cpu(int cpu)
 	struct swevent_htable *swhash = &per_cpu(swevent_htable, cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
+	swhash->offline = false;
 	if (swhash->hlist_refcount > 0) {
 		struct swevent_hlist *hlist;
 
@@ -7907,6 +7912,7 @@ static void perf_event_exit_cpu(int cpu)
 	perf_event_exit_cpu_context(cpu);
 
 	mutex_lock(&swhash->hlist_mutex);
+	swhash->offline = true;
 	swevent_hlist_release(swhash);
 	mutex_unlock(&swhash->hlist_mutex);
 }
