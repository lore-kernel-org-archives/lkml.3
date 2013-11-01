Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3KAWH5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 18:07:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55295 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171Ab3KAWHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 18:07:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?J=C3=BCri=20Aedla?= <juri.aedla@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 12/66] net: heap overflow in __audit_sockaddr()
Date: Fri,  1 Nov 2013 15:06:48 -0700
Message-Id: <20131101220638.135223176@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131101220634.605745564@linuxfoundation.org>
References: <20131101220634.605745564@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/compat.c |    2 ++
 net/socket.c |   24 ++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/net/compat.c
+++ b/net/compat.c
@@ -71,6 +71,8 @@ int get_compat_msghdr(struct msghdr *kms
 	    __get_user(kmsg->msg_controllen, &umsg->msg_controllen) ||
 	    __get_user(kmsg->msg_flags, &umsg->msg_flags))
 		return -EFAULT;
+	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
+		return -EINVAL;
 	kmsg->msg_name = compat_ptr(tmp1);
 	kmsg->msg_iov = compat_ptr(tmp2);
 	kmsg->msg_control = compat_ptr(tmp3);
--- a/net/socket.c
+++ b/net/socket.c
@@ -1973,6 +1973,16 @@ struct used_address {
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
@@ -1991,8 +2001,11 @@ static int ___sys_sendmsg(struct socket
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
@@ -2200,8 +2213,11 @@ static int ___sys_recvmsg(struct socket
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


