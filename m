Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757345Ab3LERhn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:37:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303Ab3LERhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:37:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Mathias Krause <minipli@googlemail.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 53/90] audit: use nlmsg_len() to get message payload length
Date: Thu,  5 Dec 2013 17:35:35 +0000
Message-Id: <1386264972-5399-54-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5:
  - adjusted 2nd hunk context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index 39b0438..03900ab 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -696,7 +696,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				 &status_set, sizeof(status_set));
 		break;
 	case AUDIT_SET:
-		if (nlh->nlmsg_len < sizeof(struct audit_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_status))
 			return -EINVAL;
 		status_get   = (struct audit_status *)data;
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {
@@ -900,7 +900,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 		struct task_struct *tsk;
 		unsigned long flags;
 
-		if (nlh->nlmsg_len < sizeof(struct audit_tty_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_tty_status))
 			return -EINVAL;
 		s = data;
 		if (s->enabled != 0 && s->enabled != 1)
-- 
1.8.3.2

