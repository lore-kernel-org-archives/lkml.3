Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471Ab3FXPcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab3FXPcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:32:00 -0400
From: Denys Vlasenko <dvlasenk@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] epoll_wait: fix EINTR leak
Date: Mon, 24 Jun 2013 17:31:53 +0200
Message-Id: <1372087913-7854-1-git-send-email-dvlasenk@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of EINTR is wrong. For one, it causes epoll_wait
to spuriously return with EINTR on ptrace attach.
One of ERESTARTfoo's should be used.

By analogy with poll syscall family, epoll_wait should be interrupted
by signals regardless of SA_RESTART, thus ERESTARTNOHAND is used,
not ERESTARTSYS.

Signed-off-by: Denys Vlasenko <dvlasenk@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>
---
 fs/eventpoll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 0cff4434..08f8076 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1598,7 +1598,7 @@ fetch_events:
 			if (ep_events_available(ep) || timed_out)
 				break;
 			if (signal_pending(current)) {
-				res = -EINTR;
+				res = -ERESTARTNOHAND;
 				break;
 			}
 
@@ -1990,7 +1990,7 @@ SYSCALL_DEFINE6(epoll_pwait, int, epfd, struct epoll_event __user *, events,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (error == -EINTR) {
+		if (error == -ERESTARTNOHAND) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
@@ -2035,7 +2035,7 @@ COMPAT_SYSCALL_DEFINE6(epoll_pwait, int, epfd,
 	 * the way back to userspace, before the signal mask is restored.
 	 */
 	if (sigmask) {
-		if (err == -EINTR) {
+		if (err == -ERESTARTNOHAND) {
 			memcpy(&current->saved_sigmask, &sigsaved,
 			       sizeof(sigsaved));
 			set_restore_sigmask();
-- 
1.8.1.4

