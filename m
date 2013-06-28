Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625Ab3F1TDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:03:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41930 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3F1S54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:57:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 077/105] net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
Date: Fri, 28 Jun 2013 11:51:39 -0700
Message-Id: <1372445527-24414-78-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

[ Upstream commits 1be374a0518a288147c6a7398792583200a67261 and
  a7526eb5d06b0084ef12d7b168d008fcf516caab ]

MSG_CMSG_COMPAT is (AFAIK) not intended to be part of the API --
it's a hack that steals a bit to indicate to other networking code
that a compat entry was used.  So don't allow it from a non-compat
syscall.

This prevents an oops when running this code:

int main()
{
	int s;
	struct sockaddr_in addr;
	struct msghdr *hdr;

	char *highpage = mmap((void*)(TASK_SIZE_MAX - 4096), 4096,
	                      PROT_READ | PROT_WRITE,
	                      MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
	if (highpage == MAP_FAILED)
		err(1, "mmap");

	s = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
	if (s == -1)
		err(1, "socket");

        addr.sin_family = AF_INET;
        addr.sin_port = htons(1);
        addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
	if (connect(s, (struct sockaddr*)&addr, sizeof(addr)) != 0)
		err(1, "connect");

	void *evil = highpage + 4096 - COMPAT_MSGHDR_SIZE;
	printf("Evil address is %p\n", evil);

	if (syscall(__NR_sendmmsg, s, evil, 1, MSG_CMSG_COMPAT) < 0)
		err(1, "sendmmsg");

	return 0;
}

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/socket.h |  3 +++
 net/compat.c           | 13 +++++++++--
 net/socket.c           | 61 ++++++++++++++++++++++++++++++++++----------------
 3 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 9a546ff..bd607b8 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -319,6 +319,9 @@ extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec;
 
+/* The __sys_...msg variants allow MSG_CMSG_COMPAT */
+extern long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags);
+extern long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
diff --git a/net/compat.c b/net/compat.c
index 79ae884..f0a1ba6 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -734,19 +734,25 @@ static unsigned char nas[21] = {
 
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg, unsigned int flags)
 {
-	return sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned int vlen, unsigned int flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 			      flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_recvmsg(int fd, struct compat_msghdr __user *msg, unsigned int flags)
 {
-	return sys_recvmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_recvmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len, unsigned int flags)
@@ -768,6 +774,9 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	int datagrams;
 	struct timespec ktspec;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (COMPAT_USE_64BIT_TIME)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT,
diff --git a/net/socket.c b/net/socket.c
index 2ca51c7..a61db06 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1980,7 +1980,7 @@ struct used_address {
 	unsigned int name_len;
 };
 
-static int __sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
+static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags,
 			 struct used_address *used_address)
 {
@@ -2095,22 +2095,30 @@ out:
  *	BSD sendmsg interface
  */
 
-SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, flags)
+long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags)
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
-	err = __sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
+	err = ___sys_sendmsg(sock, msg, &msg_sys, flags, NULL);
 
 	fput_light(sock->file, fput_needed);
 out:
 	return err;
 }
 
+SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, flags)
+{
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_sendmsg(fd, msg, flags);
+}
+
 /*
  *	Linux sendmmsg interface
  */
@@ -2141,15 +2149,16 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
 	while (datagrams < vlen) {
 		if (MSG_CMSG_COMPAT & flags) {
-			err = __sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags, &used_address);
+			err = ___sys_sendmsg(sock, (struct msghdr __user *)compat_entry,
+					     &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
-			err = __sys_sendmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags, &used_address);
+			err = ___sys_sendmsg(sock,
+					     (struct msghdr __user *)entry,
+					     &msg_sys, flags, &used_address);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);
@@ -2173,10 +2182,12 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, mmsg, vlen, flags);
 }
 
-static int __sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
+static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
 			 struct msghdr *msg_sys, unsigned int flags, int nosec)
 {
 	struct compat_msghdr __user *msg_compat =
@@ -2268,23 +2279,31 @@ out:
  *	BSD recvmsg interface
  */
 
-SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
-		unsigned int, flags)
+long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags)
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
-	err = __sys_recvmsg(sock, msg, &msg_sys, flags, 0);
+	err = ___sys_recvmsg(sock, msg, &msg_sys, flags, 0);
 
 	fput_light(sock->file, fput_needed);
 out:
 	return err;
 }
 
+SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
+		unsigned int, flags)
+{
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_recvmsg(fd, msg, flags);
+}
+
 /*
  *     Linux recvmmsg interface
  */
@@ -2322,17 +2341,18 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 		 * No need to ask LSM for more than the first datagram.
 		 */
 		if (MSG_CMSG_COMPAT & flags) {
-			err = __sys_recvmsg(sock, (struct msghdr __user *)compat_entry,
-					    &msg_sys, flags & ~MSG_WAITFORONE,
-					    datagrams);
+			err = ___sys_recvmsg(sock, (struct msghdr __user *)compat_entry,
+					     &msg_sys, flags & ~MSG_WAITFORONE,
+					     datagrams);
 			if (err < 0)
 				break;
 			err = __put_user(err, &compat_entry->msg_len);
 			++compat_entry;
 		} else {
-			err = __sys_recvmsg(sock, (struct msghdr __user *)entry,
-					    &msg_sys, flags & ~MSG_WAITFORONE,
-					    datagrams);
+			err = ___sys_recvmsg(sock,
+					     (struct msghdr __user *)entry,
+					     &msg_sys, flags & ~MSG_WAITFORONE,
+					     datagrams);
 			if (err < 0)
 				break;
 			err = put_user(err, &entry->msg_len);
@@ -2399,6 +2419,9 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	int datagrams;
 	struct timespec timeout_sys;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 
-- 
1.8.1.2

