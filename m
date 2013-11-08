Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932232Ab3KHCRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:17:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34521 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab3KHCQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:16:15 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 18/91] net: heap overflow in __audit_sockaddr()
Date: Thu,  7 Nov 2013 18:14:33 -0800
Message-Id: <1383876946-2396-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1661bf364ae9c506bc8795fef70d1532931be1e8 ]

We need to cap ->msg_namelen or it leads to a buffer overflow when we
to the memcpy() in __audit_sockaddr().  It requires CAP_AUDIT_CONTROL to
exploit this bug.

The call tree is:
___sys_recvmsg()
  move_addr_to_user()
    audit_sockaddr()
      __audit_sockaddr()

Reported-by: Jüri Aedla <juri.aedla@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/compat.c |  2 ++
 net/socket.c | 24 ++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index f0a1ba6..8903258 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -71,6 +71,8 @@ int get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg)
 	    __get_user(kmsg->msg_controllen, &umsg->msg_controllen) ||
 	    __get_user(kmsg->msg_flags, &umsg->msg_flags))
 		return -EFAULT;
+	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
+		return -EINVAL;
 	kmsg->msg_name = compat_ptr(tmp1);
 	kmsg->msg_iov = compat_ptr(tmp2);
 	kmsg->msg_control = compat_ptr(tmp3);
diff --git a/net/socket.c b/net/socket.c
index a61db06..809e941 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1980,6 +1980,16 @@ struct used_address {
 	unsigned int name_len;
 };
 
+static int copy_msghdr_from_user(struct msghdr *kmsg,
+				 struct msghdr __user *umsg)
+{
+	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
+		return -EFAULT;
+	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
+		return -EINVAL;
+	return 0;
+}
+
 static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags,
 			 struct used_address *used_address)
@@ -1998,8 +2008,11 @@ static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 	if (MSG_CMSG_COMPAT & flags) {
 		if (get_compat_msghdr(msg_sys, msg_compat))
 			return -EFAULT;
-	} else if (copy_from_user(msg_sys, msg, sizeof(struct msghdr)))
-		return -EFAULT;
+	} else {
+		err = copy_msghdr_from_user(msg_sys, msg);
+		if (err)
+			return err;
+	}
 
 	if (msg_sys->msg_iovlen > UIO_FASTIOV) {
 		err = -EMSGSIZE;
@@ -2207,8 +2220,11 @@ static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
 	if (MSG_CMSG_COMPAT & flags) {
 		if (get_compat_msghdr(msg_sys, msg_compat))
 			return -EFAULT;
-	} else if (copy_from_user(msg_sys, msg, sizeof(struct msghdr)))
-		return -EFAULT;
+	} else {
+		err = copy_msghdr_from_user(msg_sys, msg);
+		if (err)
+			return err;
+	}
 
 	if (msg_sys->msg_iovlen > UIO_FASTIOV) {
 		err = -EMSGSIZE;
-- 
1.8.1.2

