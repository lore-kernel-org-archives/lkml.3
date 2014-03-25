Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbaCYQh4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 12:37:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCYQhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 12:37:54 -0400
Date: Tue, 25 Mar 2014 09:37:26 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-ea2e64f280d2a34a8ed9ae3d783cd770d14b70ec@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, tj@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, tj@kernel.org, tglx@linutronix.de
In-Reply-To: <20140323141939.911487677@linutronix.de>
References: <20140323141939.911487677@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] workqueue:
  Provide destroy_delayed_work_on_stack()
Git-Commit-ID: ea2e64f280d2a34a8ed9ae3d783cd770d14b70ec
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea2e64f280d2a34a8ed9ae3d783cd770d14b70ec
Gitweb:     http://git.kernel.org/tip/ea2e64f280d2a34a8ed9ae3d783cd770d14b70ec
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sun, 23 Mar 2014 14:20:44 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 25 Mar 2014 17:33:42 +0100

workqueue: Provide destroy_delayed_work_on_stack()

If a delayed or deferrable work is on stack we need to tell debug
objects that we are destroying the timer and the work. Otherwise we
leak the tracking object.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Acked-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20140323141939.911487677@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/workqueue.h | 2 ++
 kernel/workqueue.c        | 7 +++++++
 2 files changed, 9 insertions(+)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 594521b..abdbe5a 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -191,6 +191,7 @@ struct execute_work {
 #ifdef CONFIG_DEBUG_OBJECTS_WORK
 extern void __init_work(struct work_struct *work, int onstack);
 extern void destroy_work_on_stack(struct work_struct *work);
+extern void destroy_delayed_work_on_stack(struct delayed_work *work);
 static inline unsigned int work_static(struct work_struct *work)
 {
 	return *work_data_bits(work) & WORK_STRUCT_STATIC;
@@ -198,6 +199,7 @@ static inline unsigned int work_static(struct work_struct *work)
 #else
 static inline void __init_work(struct work_struct *work, int onstack) { }
 static inline void destroy_work_on_stack(struct work_struct *work) { }
+static inline void destroy_delayed_work_on_stack(struct delayed_work *work) { }
 static inline unsigned int work_static(struct work_struct *work) { return 0; }
 #endif
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 82ef9f3..5b690b5 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -516,6 +516,13 @@ void destroy_work_on_stack(struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(destroy_work_on_stack);
 
+void destroy_delayed_work_on_stack(struct delayed_work *work)
+{
+	destroy_timer_on_stack(&work->timer);
+	debug_object_free(&work->work, &work_debug_descr);
+}
+EXPORT_SYMBOL_GPL(destroy_delayed_work_on_stack);
+
 #else
 static inline void debug_work_activate(struct work_struct *work) { }
 static inline void debug_work_deactivate(struct work_struct *work) { }
