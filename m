Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaAVOyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:54:09 -0500
Received: from mail-oa0-f42.google.com ([209.85.219.42]:59596 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455AbaAVOyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:54:04 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] tty: Allow stealing of controlling ttys within user namespaces
Date: Wed, 22 Jan 2014 08:53:51 -0600
Message-Id: <1390402431-6371-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

root is allowed to steal ttys from other sessions, but it
requires system-wide CAP_SYS_ADMIN and therefore is not possible
for root within a user namespace. This should be allowed so long
as the process doing the stealing is privileged towards the
session which currently owns the tty.

Update this code to only require CAP_SYS_ADMIN in the user
namespaces of the target session's tasks, allowing the tty to be
stolen from sessions whose tasks are in the same or lesser
privileged user namespaces.

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/tty/tty_io.c | 31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..558e6dc 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2410,17 +2410,32 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 		 * This tty is already the controlling
 		 * tty for another session group!
 		 */
-		if (arg == 1 && capable(CAP_SYS_ADMIN)) {
-			/*
-			 * Steal it away
-			 */
-			read_lock(&tasklist_lock);
-			session_clear_tty(tty->session);
-			read_unlock(&tasklist_lock);
-		} else {
+		struct user_namespace *user_ns;
+		struct task_struct *p;
+
+		if (arg != 1) {
 			ret = -EPERM;
 			goto unlock;
 		}
+
+		read_lock(&tasklist_lock);
+		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
+			rcu_read_lock();
+			user_ns = task_cred_xxx(p, user_ns);
+			if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
+				rcu_read_unlock();
+				read_unlock(&tasklist_lock);
+				ret = -EPERM;
+				goto unlock;
+			}
+			rcu_read_unlock();
+		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
+
+		/*
+		 * Steal it away
+		 */
+		session_clear_tty(tty->session);
+		read_unlock(&tasklist_lock);
 	}
 	proc_set_tty(current, tty);
 unlock:
-- 
1.8.3.2

