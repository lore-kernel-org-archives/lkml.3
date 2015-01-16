Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752414AbbAPH6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 02:58:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbbAPH6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 02:58:14 -0500
Date: Fri, 16 Jan 2015 08:57:46 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: perf fuzzer crash [PATCH] perf: Get group events reference before
 moving the group
Message-ID: <20150116075746.GB2658@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Vince,
I was able to reproduce the issue you described in:
  http://marc.info/?l=linux-kernel&m=141806390822670&w=2

I might have found one way that could lead to screwing up
context's refcounts.. could you please try attached patch?

I'm now on 2 days of no crash while it used to happen
3 times a day before.

Or you can use following git branch:
  git://git.kernel.org/pub/scm/linux/kernel/git/jolsa/perf.git
  perf/trinity_fix

thanks,
jirka


---
We need to make sure, that no event in the group lost
the last reference and gets removed from the context
during the group move in perf syscall.

This could happen if the child exits and calls put_event
on the parent event which got already closed, like in
following scenario:

  - T1 creates software event E1
  - T1 creates other software events as group with E1 as group leader
  - T1 forks T2
  - T2 has cloned E1 event that holds reference on E1
  - T1 closes event within E1 group (say E3), the event stays alive
    due to the T2 reference
  - following happens concurently:
    A) T1 creates hardware event E2 with groupleader E1
    B) T2 exits

ad A) T1 triggers the E1 group move into hardware context:
        mutex_lock(E1->ctx)
          - remove E1 group only from the E1->ctx context, leaving
            the goup links untouched
        mutex_unlock(E1->ctx)
        mutex_lock(E2->ctx)
          - install E1 group into E2->ctx using the E1 group links
        mutex_unlock(E2->ctx)

ad B) put_event(E3) is called and E3 is removed from E1->ctx
      completely, including group links

If 'A' and 'B' races, we will get unbalanced refcounts,
because of removed group links.

Adding get_group/put_group functions to handle the event
ref's increase/decrease for the whole group.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/events/core.c | 61 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index af0a5ba4e21d..1922bae9f24e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7250,6 +7250,55 @@ out:
 	return ret;
 }
 
+static void put_group(struct perf_event **group_arr)
+{
+	struct perf_event *event;
+	int i = 0;
+
+	while (event = group_arr[i++]) {
+		put_event(event);
+	}
+
+	kfree(group_arr);
+}
+
+static int get_group(struct perf_event *leader, struct perf_event ***group_arr)
+{
+	struct perf_event_context *ctx = leader->ctx;
+	struct perf_event *sibling, **arr = NULL;
+	int i = 0, err = -ENOMEM;
+	size_t size;
+
+	if (!atomic_long_inc_not_zero(&leader->refcount))
+		return -EINVAL;
+
+	mutex_lock(&ctx->mutex);
+	/* + 1 for leader and +1 for final NULL */
+	size = (leader->nr_siblings + 2) * sizeof(leader);
+
+	arr = *group_arr = kzalloc(size, GFP_KERNEL);
+	if (!arr)
+		goto err;
+
+	err = -EINVAL;
+	arr[i++] = leader;
+
+	list_for_each_entry(sibling, &leader->sibling_list, group_entry) {
+		if (!atomic_long_inc_not_zero(&sibling->refcount))
+			goto err;
+
+		arr[i++] = sibling;
+	}
+
+	mutex_unlock(&ctx->mutex);
+	return 0;
+err:
+	mutex_unlock(&ctx->mutex);
+	if (arr)
+		put_group(arr);
+	return err;
+}
+
 /**
  * sys_perf_event_open - open a performance event, associate it to a task/cpu
  *
@@ -7263,6 +7312,7 @@ SYSCALL_DEFINE5(perf_event_open,
 		pid_t, pid, int, cpu, int, group_fd, unsigned long, flags)
 {
 	struct perf_event *group_leader = NULL, *output_event = NULL;
+	struct perf_event **group_arr = NULL;
 	struct perf_event *event, *sibling;
 	struct perf_event_attr attr;
 	struct perf_event_context *ctx;
@@ -7443,6 +7493,12 @@ SYSCALL_DEFINE5(perf_event_open,
 			goto err_context;
 	}
 
+	if (move_group) {
+		err = get_group(group_leader, &group_arr);
+		if (err)
+			goto err_context;
+	}
+
 	event_file = anon_inode_getfile("[perf_event]", &perf_fops, event,
 					f_flags);
 	if (IS_ERR(event_file)) {
@@ -7490,6 +7546,9 @@ SYSCALL_DEFINE5(perf_event_open,
 	perf_unpin_context(ctx);
 	mutex_unlock(&ctx->mutex);
 
+	if (move_group)
+		put_group(group_arr);
+
 	put_online_cpus();
 
 	event->owner = current;
@@ -7515,6 +7574,8 @@ SYSCALL_DEFINE5(perf_event_open,
 	return event_fd;
 
 err_context:
+	if (group_arr)
+		put_group(group_arr);
 	perf_unpin_context(ctx);
 	put_ctx(ctx);
 err_alloc:
-- 
1.9.3

