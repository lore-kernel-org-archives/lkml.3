Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab3A1DsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 22:48:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810Ab3A1Dqx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 22:46:53 -0500
From: Richard Guy Briggs <rbriggs@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Richard Guy Briggs <rbriggs@redhat.com>
Subject: [PATCH 3/6] audit: move kaudit thread start from auditd registration to kaudit init
Date: Sun, 27 Jan 2013 22:45:15 -0500
Message-Id: <1359344718-3953-4-git-send-email-rbriggs@redhat.com>
In-Reply-To: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
References: <1359344718-3953-1-git-send-email-rbriggs@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Guy Briggs <rgb@redhat.com>

The kauditd_thread() task was started only after the auditd userspace daemon
registers itself with kaudit.  This was fine when only auditd consumed messages
from the kaudit netlink unicast socket.  With the addition of a multicast group
to that socket it is more convenient to have the thread start on init of the
kaudit kernel subsystem.

Signed-off-by: Richard Guy Briggs <rbriggs@redhat.com>
---

This is a code clean up in preparation to add a multicast netlink socket to
kaudit for read-only userspace clients such as systemd, in addition to the
bidirectional audit userspace client.

 kernel/audit.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 1531efb..02a5d9e 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -676,16 +676,6 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	if (err)
 		return err;
 
-	/* As soon as there's any sign of userspace auditd,
-	 * start kauditd to talk to it */
-	if (!kauditd_task)
-		kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
-	if (IS_ERR(kauditd_task)) {
-		err = PTR_ERR(kauditd_task);
-		kauditd_task = NULL;
-		return err;
-	}
-
 	loginuid = audit_get_loginuid(current);
 	sessionid = audit_get_sessionid(current);
 	security_task_getsecid(current, &sid);
@@ -974,6 +964,10 @@ static int __init audit_init(void)
 	else
 		audit_sock->sk_sndtimeo = MAX_SCHEDULE_TIMEOUT;
 
+	kauditd_task = kthread_run(kauditd_thread, NULL, "kauditd");
+	if (IS_ERR(kauditd_task))
+		return PTR_ERR(kauditd_task);
+
 	skb_queue_head_init(&audit_skb_queue);
 	skb_queue_head_init(&audit_skb_hold_queue);
 	audit_initialized = AUDIT_INITIALIZED;
-- 
1.8.0.2

