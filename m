Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaACLmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 06:42:31 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56905 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbaACLma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 06:42:30 -0500
X-Nat-Received: from [202.181.97.72]:55067 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1388749339.9182
To: chris@chris-wilson.co.uk
Cc: ben@bwidawsk.net, daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Fix refcount leak and possible NULL pointerdereference.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp>
	<20131225215249.GA3832@nuc-i3427.alporthouse.com>
In-Reply-To: <20131225215249.GA3832@nuc-i3427.alporthouse.com>
Message-Id: <201401032042.BJF09317.FJFQOFOVtSOLMH@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Fri, 3 Jan 2014 20:42:18 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 03012014 #7234623, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wilson wrote:
> On Tue, Dec 24, 2013 at 08:50:23PM +0900, Tetsuo Handa wrote:
> > >From 482be6384379072eb4c0d45d0ab8a25df4f59ed7 Mon Sep 17 00:00:00 2001
> > From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> > Date: Tue, 24 Dec 2013 18:04:14 +0900
> > Subject: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer dereference.
> > 
> > Since get_pid_task() grabs a reference on the task_struct, we have to drop the
> > refcount after reading that task's comm name. Also, directly reading like
> > get_pid_task()->comm can trigger an oops when get_pid_task() returned NULL.
> 
> The second issue is moot as file itself cannot exist if the task_struct
> is NULL, and the task_struct cannot be destroyed until we finish the
> function. The simpler fix would appear to be s/get_pid_task/pid_task/

If I understand correctly, priv->pid = get_pid(task_pid(current)); in
drm_open_helper() grabs a reference on "struct pid" before adding to
&dev->filelist, and put_pid(file_priv->pid); in drm_release() releases that
reference after removing from &dev->filelist.

So, you meant that mutex_lock_interruptible(&dev->struct_mutex); in
i915_gem_object_info() prevents drm_release() from calling put_pid() ?

Then, this file->pid in &dev->filelist keeps at least one reference.
OK. Updated patch follows.
----------
>From 5ea824bc84f65d2265addc81e1adacc8baf82d48 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Fri, 3 Jan 2014 20:30:41 +0900
Subject: [PATCH v2] drm/i915: Fix refcount leak and possible NULL pointer dereference.

Since get_pid_task() grabs a reference on the task_struct, we have to drop the
refcount after reading that task's comm name. Use pid_task() with RCU instead.

Also, avoid directly reading like pid_task()->comm because
pid_task() will return NULL if the task have already exit()ed.

This patch fixes both problems.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/gpu/drm/i915/i915_debugfs.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 6ed45a9..91c26b6 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -406,16 +406,26 @@ static int i915_gem_object_info(struct seq_file *m, void* data)
 	seq_putc(m, '\n');
 	list_for_each_entry_reverse(file, &dev->filelist, lhead) {
 		struct file_stats stats;
+		struct task_struct *task;
 
 		memset(&stats, 0, sizeof(stats));
 		idr_for_each(&file->object_idr, per_file_stats, &stats);
+		/*
+		 * Although we have a valid reference on file->pid, that does
+		 * not guarantee that the task_struct who called get_pid() is
+		 * still alive (e.g. get_pid(current) => fork() => exit()).
+		 * Therefore, we need to protect this ->comm access using RCU.
+		 */
+		rcu_read_lock();
+		task = pid_task(file->pid, PIDTYPE_PID);
 		seq_printf(m, "%s: %u objects, %zu bytes (%zu active, %zu inactive, %zu unbound)\n",
-			   get_pid_task(file->pid, PIDTYPE_PID)->comm,
+			   task ? task->comm : "<unknown>",
 			   stats.count,
 			   stats.total,
 			   stats.active,
 			   stats.inactive,
 			   stats.unbound);
+		rcu_read_unlock();
 	}
 
 	mutex_unlock(&dev->struct_mutex);
-- 
1.7.1
