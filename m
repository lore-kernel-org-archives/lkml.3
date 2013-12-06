Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930Ab3LFXXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:23:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49046 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423049Ab3LFXU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:20:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Mathias Krause <minipli@googlemail.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 052/152] audit: use nlmsg_len() to get message payload length
Date: Fri,  6 Dec 2013 15:09:36 -0800
Message-Id: <1386371476-2477-53-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 4d8fe7376a12bf4524783dd95cbc00f1fece6232 upstream.

Using the nlmsg_len member of the netlink header to test if the message
is valid is wrong as it includes the size of the netlink header itself.
Thereby allowing to send short netlink messages that pass those checks.

Use nlmsg_len() instead to test for the right message length. The result
of nlmsg_len() is guaranteed to be non-negative as the netlink message
already passed the checks of nlmsg_ok().

Also switch to min_t() to please checkpatch.pl.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Paris <eparis@redhat.com>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
[ kamal: backport to 3.8 (addtional bits from 46e959ea) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/audit.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index bccbce0..5924919 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -688,7 +688,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				 &status_set, sizeof(status_set));
 		break;
 	case AUDIT_SET:
-		if (nlh->nlmsg_len < sizeof(struct audit_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_status))
 			return -EINVAL;
 		status_get   = (struct audit_status *)data;
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {
@@ -881,17 +881,17 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		break;
 	}
 	case AUDIT_TTY_SET: {
-		struct audit_tty_status *s;
+		struct audit_tty_status s;
 		struct task_struct *tsk = current;
 
-		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
-			return -EINVAL;
-		s = data;
-		if (s->enabled != 0 && s->enabled != 1)
+		memset(&s, 0, sizeof(s));
+		/* guard against past and future API changes */
+		memcpy(&s, data, min_t(size_t, sizeof(s), nlmsg_len(nlh)));
+		if (s.enabled != 0 && s.enabled != 1)
 			return -EINVAL;
 
 		spin_lock_irq(&tsk->sighand->siglock);
-		tsk->signal->audit_tty = s->enabled != 0;
+		tsk->signal->audit_tty = s.enabled != 0;
 		spin_unlock_irq(&tsk->sighand->siglock);
 		break;
 	}
-- 
1.8.3.2

