Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172AbaGQRuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:50:12 -0400
Received: from smtp.outflux.net ([198.145.64.163]:40043 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaGQRuK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:50:10 -0400
Date: Thu, 17 Jul 2014 10:49:59 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, James Morris <jmorris@namei.org>,
        Andy Lutomirski <luto@amacapital.net>, Oleg Nesterov <oleg@redhat.com>,
        David Drysdale <drysdale@google.com>
Subject: [PATCH] seccomp: do not reject initial filter using TSYNC
Message-ID: <20140717174959.GA12788@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was an unneeded sanity check in the TSYNC code that was causing
the first filter applied to not allow the TSYNC flag. Additionally,
this optimizes the thread loops to skip "current". It was harmless, but
better to not cause problems in the future.

Reported-by: David Drysdale <drysdale@google.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This goes on top of the v11 seccomp-tsync series. If I should respin
as v12, please let me know.

Thanks!
---
 kernel/seccomp.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 2125b83ccfd4..0e0c6905b81d 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -255,14 +255,15 @@ static inline pid_t seccomp_can_sync_threads(void)
 	BUG_ON(!mutex_is_locked(&current->signal->cred_guard_mutex));
 	BUG_ON(!spin_is_locked(&current->sighand->siglock));
 
-	if (current->seccomp.mode != SECCOMP_MODE_FILTER)
-		return -EACCES;
-
 	/* Validate all threads being eligible for synchronization. */
 	caller = current;
 	for_each_thread(caller, thread) {
 		pid_t failed;
 
+		/* Skip current, since it is initiating the sync. */
+		if (thread == current)
+			continue;
+
 		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED ||
 		    (thread->seccomp.mode == SECCOMP_MODE_FILTER &&
 		     is_ancestor(thread->seccomp.filter,
@@ -298,6 +299,10 @@ static inline void seccomp_sync_threads(void)
 	/* Synchronize all threads. */
 	caller = current;
 	for_each_thread(caller, thread) {
+		/* Skip current, since it needs no changes. */
+		if (thread == current)
+			continue;
+
 		/* Get a task reference for the new leaf node. */
 		get_seccomp_filter(caller);
 		/*
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
