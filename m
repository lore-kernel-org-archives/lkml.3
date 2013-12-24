Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3LXLuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 06:50:44 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:52242 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3LXLun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 06:50:43 -0500
X-Nat-Received: from [202.181.97.72]:59749 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1387885825.17897
To: chris@chris-wilson.co.uk, ben@bwidawsk.net, daniel.vetter@ffwll.ch
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer dereference.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201312242050.CGH78112.JQFOSVMLOFtHOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Tue, 24 Dec 2013 20:50:23 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 24122013 #7223428, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 482be6384379072eb4c0d45d0ab8a25df4f59ed7 Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Tue, 24 Dec 2013 18:04:14 +0900
Subject: [PATCH] drm/i915: Fix refcount leak and possible NULL pointer dereference.

Since get_pid_task() grabs a reference on the task_struct, we have to drop the
refcount after reading that task's comm name. Also, directly reading like
get_pid_task()->comm can trigger an oops when get_pid_task() returned NULL.

This patch fixes both problems.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
---
 drivers/gpu/drm/i915/i915_debugfs.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 6ed45a9..d0a8e0a 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -406,11 +406,20 @@ static int i915_gem_object_info(struct seq_file *m, void* data)
 	seq_putc(m, '\n');
 	list_for_each_entry_reverse(file, &dev->filelist, lhead) {
 		struct file_stats stats;
+		struct task_struct *task;
+		char name[TASK_COMM_LEN];
 
 		memset(&stats, 0, sizeof(stats));
 		idr_for_each(&file->object_idr, per_file_stats, &stats);
+		task = get_pid_task(file->pid, PIDTYPE_PID);
+		if (task) {
+			get_task_comm(name, task);
+			put_task_struct(task);
+		} else {
+			strlcpy(name, "<unknown>", sizeof(name));
+		}
 		seq_printf(m, "%s: %u objects, %zu bytes (%zu active, %zu inactive, %zu unbound)\n",
-			   get_pid_task(file->pid, PIDTYPE_PID)->comm,
+			   name,
 			   stats.count,
 			   stats.total,
 			   stats.active,
-- 
1.7.1
