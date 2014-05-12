Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaELBob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:44:31 -0400
Received: from 1wt.eu ([62.212.114.60]:34795 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbaELBo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:44:27 -0400
Message-Id: <20140512003201.838833795@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:32:29 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 029/143] net: heap overflow in __audit_sockaddr()
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
[wt: 2.6.32: msg_sys is a struct, not a pointer]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/compat.c |  2 ++
 net/socket.c | 24 ++++++++++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/net/compat.c b/net/compat.c
index 9559afc..da3d0fc 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -69,6 +69,8 @@ int get_compat_msghdr(struct msghdr *kmsg, struct compat_msghdr __user *umsg)
 	    __get_user(kmsg->msg_controllen, &umsg->msg_controllen) ||
 	    __get_user(kmsg->msg_flags, &umsg->msg_flags))
 		return -EFAULT;
+	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
+		return -EINVAL;
 	kmsg->msg_name = compat_ptr(tmp1);
 	kmsg->msg_iov = compat_ptr(tmp2);
 	kmsg->msg_control = compat_ptr(tmp3);
diff --git a/net/socket.c b/net/socket.c
index bf9fc68..9f8cd74 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1863,6 +1863,16 @@ SYSCALL_DEFINE2(shutdown, int, fd, int, how)
 #define COMPAT_NAMELEN(msg)	COMPAT_MSG(msg, msg_namelen)
 #define COMPAT_FLAGS(msg)	COMPAT_MSG(msg, msg_flags)
 
+static int copy_msghdr_from_user(struct msghdr *kmsg,
+                                 struct msghdr __user *umsg)
+{
+	if (copy_from_user(kmsg, umsg, sizeof(struct msghdr)))
+		return -EFAULT;
+	if (kmsg->msg_namelen > sizeof(struct sockaddr_storage))
+		return -EINVAL;
+	return 0;
+}
+
 /*
  *	BSD sendmsg interface
  */
@@ -1887,8 +1897,11 @@ SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned, flags)
 		if (get_compat_msghdr(&msg_sys, msg_compat))
 			return -EFAULT;
 	}
-	else if (copy_from_user(&msg_sys, msg, sizeof(struct msghdr)))
-		return -EFAULT;
+	else {
+		err = copy_msghdr_from_user(&msg_sys, msg);
+		if (err)
+			return err;
+	}
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
@@ -1997,8 +2010,11 @@ SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
 		if (get_compat_msghdr(&msg_sys, msg_compat))
 			return -EFAULT;
 	}
-	else if (copy_from_user(&msg_sys, msg, sizeof(struct msghdr)))
-		return -EFAULT;
+	else {
+		err = copy_msghdr_from_user(&msg_sys, msg);
+		if (err)
+			return err;
+	}
 
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
-- 
1.7.12.2.21.g234cd45.dirty



