Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161063Ab3LFM7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:59:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:43545 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3LFM7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:59:38 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Mathias Krause <minipli@googlemail.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 005/272] audit: use nlmsg_len() to get message payload length
Date: Fri,  6 Dec 2013 12:54:54 +0000
Message-Id: <1386334761-25517-6-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index d397a61..34eeb48 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -671,7 +671,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 				 &status_set, sizeof(status_set));
 		break;
 	case AUDIT_SET:
-		if (nlh->nlmsg_len < sizeof(struct audit_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_status))
 			return -EINVAL;
 		status_get   = (struct audit_status *)data;
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {
@@ -833,7 +833,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 		memset(&s, 0, sizeof(s));
 		/* guard against past and future API changes */
-		memcpy(&s, data, min(sizeof(s), (size_t)nlh->nlmsg_len));
+		memcpy(&s, data, min_t(size_t, sizeof(s), nlmsg_len(nlh)));
 		if ((s.enabled != 0 && s.enabled != 1) ||
 		    (s.log_passwd != 0 && s.log_passwd != 1))
 			return -EINVAL;
-- 
1.8.3.2

