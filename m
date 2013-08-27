Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275Ab3H0B3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:29:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59336 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab3H0BGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>
Subject: [ 01/13] workqueue: fix possible stall on try_to_grab_pending() of a delayed work item
Date: Mon, 26 Aug 2013 18:08:33 -0700
Message-Id: <20130827010309.960499859@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010309.850395966@linuxfoundation.org>
References: <20130827010309.850395966@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 3aa62497594430ea522050b75c033f71f2c60ee6 upstream.

Currently, when try_to_grab_pending() grabs a delayed work item, it
leaves its linked work items alone on the delayed_works.  The linked
work items are always NO_COLOR and will cause future
cwq_activate_first_delayed() increase cwq->nr_active incorrectly, and
may cause the whole cwq to stall.  For example,

state: cwq->max_active = 1, cwq->nr_active = 1
       one work in cwq->pool, many in cwq->delayed_works.

step1: try_to_grab_pending() removes a work item from delayed_works
       but leaves its NO_COLOR linked work items on it.

step2: Later on, cwq_activate_first_delayed() activates the linked
       work item increasing ->nr_active.

step3: cwq->nr_active = 1, but all activated work items of the cwq are
       NO_COLOR.  When they finish, cwq->nr_active will not be
       decreased due to NO_COLOR, and no further work items will be
       activated from cwq->delayed_works. the cwq stalls.

Fix it by ensuring the target work item is activated before stealing
PENDING in try_to_grab_pending().  This ensures that all the linked
work items are activated without incorrectly bumping cwq->nr_active.

tj: Updated comment and description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[lizf: backported to 3.4: adjust context]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1721,10 +1721,9 @@ static void move_linked_works(struct wor
 		*nextp = n;
 }
 
-static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+static void cwq_activate_delayed_work(struct work_struct *work)
 {
-	struct work_struct *work = list_first_entry(&cwq->delayed_works,
-						    struct work_struct, entry);
+	struct cpu_workqueue_struct *cwq = get_work_cwq(work);
 	struct list_head *pos = gcwq_determine_ins_pos(cwq->gcwq, cwq);
 
 	trace_workqueue_activate_work(work);
@@ -1733,6 +1732,14 @@ static void cwq_activate_first_delayed(s
 	cwq->nr_active++;
 }
 
+static void cwq_activate_first_delayed(struct cpu_workqueue_struct *cwq)
+{
+	struct work_struct *work = list_first_entry(&cwq->delayed_works,
+						    struct work_struct, entry);
+
+	cwq_activate_delayed_work(work);
+}
+
 /**
  * cwq_dec_nr_in_flight - decrement cwq's nr_in_flight
  * @cwq: cwq of interest
@@ -2625,6 +2632,18 @@ static int try_to_grab_pending(struct wo
 		smp_rmb();
 		if (gcwq == get_work_gcwq(work)) {
 			debug_work_deactivate(work);
+
+			/*
+			 * A delayed work item cannot be grabbed directly
+			 * because it might have linked NO_COLOR work items
+			 * which, if left on the delayed_list, will confuse
+			 * cwq->nr_active management later on and cause
+			 * stall.  Make sure the work item is activated
+			 * before grabbing.
+			 */
+			if (*work_data_bits(work) & WORK_STRUCT_DELAYED)
+				cwq_activate_delayed_work(work);
+
 			list_del_init(&work->entry);
 			cwq_dec_nr_in_flight(get_work_cwq(work),
 				get_work_color(work),


