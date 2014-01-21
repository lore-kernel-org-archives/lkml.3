Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaAUUXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:23:38 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34745 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaAUUXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:23:35 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: Seth Forshee <seth.forshee@canonical.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Allow stealing of controlling ttys within user namespaces
Date: Tue, 21 Jan 2014 14:22:23 -0600
Message-Id: <1390335754-32202-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

root is allowed to steal ttys from other sessions, but it
requires system-wide CAP_SYS_ADMIN and therefore is not possible
for root within a user namespace. This should be allowed so long
as the process doing the stealing is privileged towards the
session leader which currently owns the tty.

Update the tty code to only require CAP_SYS_ADMIN in the
namespace of the target session leader when stealing a tty. Fall
back to using init_user_ns to preserve the existing behavior for
system-wide root.

Cc: stable@vger.kernel.org # 3.8+
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 drivers/tty/tty_io.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c74a00a..1c47f16 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2410,7 +2410,19 @@ static int tiocsctty(struct tty_struct *tty, int arg)
 		 * This tty is already the controlling
 		 * tty for another session group!
 		 */
-		if (arg == 1 && capable(CAP_SYS_ADMIN)) {
+		struct user_namespace *ns = &init_user_ns;
+		struct task_struct *p;
+
+		read_lock(&tasklist_lock);
+		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
+			if (p->signal->leader) {
+				ns = task_cred_xxx(p, user_ns);
+				break;
+			}
+		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
+		read_unlock(&tasklist_lock);
+
+		if (arg == 1 && ns_capable(ns, CAP_SYS_ADMIN)) {
 			/*
 			 * Steal it away
 			 */
-- 
1.8.3.2

