Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3LBT7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 14:59:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39379 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754667Ab3LBTSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:18:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Mathias Krause <minipli@googlemail.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 3.12 106/212] audit: use nlmsg_len() to get message payload length
Date: Mon,  2 Dec 2013 11:14:57 -0800
Message-Id: <20131202191259.121496094@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -670,7 +670,7 @@ static int audit_receive_msg(struct sk_b
 				 &status_set, sizeof(status_set));
 		break;
 	case AUDIT_SET:
-		if (nlh->nlmsg_len < sizeof(struct audit_status))
+		if (nlmsg_len(nlh) < sizeof(struct audit_status))
 			return -EINVAL;
 		status_get   = (struct audit_status *)data;
 		if (status_get->mask & AUDIT_STATUS_ENABLED) {
@@ -832,7 +832,7 @@ static int audit_receive_msg(struct sk_b
 
 		memset(&s, 0, sizeof(s));
 		/* guard against past and future API changes */
-		memcpy(&s, data, min(sizeof(s), (size_t)nlh->nlmsg_len));
+		memcpy(&s, data, min_t(size_t, sizeof(s), nlmsg_len(nlh)));
 		if ((s.enabled != 0 && s.enabled != 1) ||
 		    (s.log_passwd != 0 && s.log_passwd != 1))
 			return -EINVAL;


