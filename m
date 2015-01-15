Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbbAOHDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 02:03:48 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:50435 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbbAOHDq (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Thu, 15 Jan 2015 02:03:46 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Oleg Nesterov <oleg@redhat.com>, Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 3/3] signal: use current->state helpers
Date: Wed, 14 Jan 2015 22:59:14 -0800
Message-Id: <1421305154-14788-3-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1421305154-14788-1-git-send-email-dave@stgolabs.net>
References: <1421305154-14788-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call __set_current_state() instead of assigning the new state directly.
These interfaces also aid CONFIG_DEBUG_ATOMIC_SLEEP environments, keeping
track of who changed the state.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 33a5275..a390499 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -3550,7 +3550,7 @@ SYSCALL_DEFINE2(signal, int, sig, __sighandler_t, handler)
 SYSCALL_DEFINE0(pause)
 {
 	while (!signal_pending(current)) {
-		current->state = TASK_INTERRUPTIBLE;
+		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 	}
 	return -ERESTARTNOHAND;
@@ -3563,7 +3563,7 @@ int sigsuspend(sigset_t *set)
 	current->saved_sigmask = current->blocked;
 	set_current_blocked(set);
 
-	current->state = TASK_INTERRUPTIBLE;
+	__set_current_state(TASK_INTERRUPTIBLE);
 	schedule();
 	set_restore_sigmask();
 	return -ERESTARTNOHAND;
-- 
2.1.2

