Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab3KYOCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:02:33 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58968 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754020Ab3KYNxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:50 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "=?UTF-8?Q?J=C3=BCri=20?=Aedla" <juri.aedla@gmail.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.295382642@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 04/87] net: heap overflow in __audit_sockaddr()
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/compat.c |  2 ++
 net/socket.c | 24 ++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index 8c979cc..3139ef2 100644
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
index cf546a3..bf7adaa 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1876,6 +1876,16 @@ struct used_address {
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
 			  struct msghdr *msg_sys, unsigned flags,
 			  struct used_address *used_address)
@@ -1894,8 +1904,11 @@ static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
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
 
 	/* do not move before msg_sys is valid */
 	err = -EMSGSIZE;
@@ -2110,8 +2123,11 @@ static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
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
 
 	err = -EMSGSIZE;
 	if (msg_sys->msg_iovlen > UIO_MAXIOV)

