Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab3FYSjy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:39:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41409 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3FYSjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:39:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [ 10/17] net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
Date: Tue, 25 Jun 2013 11:39:25 -0700
Message-Id: <20130625183916.605109568@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183915.443950649@linuxfoundation.org>
References: <20130625183915.443950649@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/socket.h |    3 ++
 net/compat.c           |   13 ++++++++-
 net/socket.c           |   67 ++++++++++++++++++++++++++++++++-----------------
 3 files changed, 59 insertions(+), 24 deletions(-)

--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -332,6 +332,9 @@ extern int put_cmsg(struct msghdr*, int
 
 struct timespec;
 
+/* The __sys_...msg variants allow MSG_CMSG_COMPAT */
+extern long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags);
+extern long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
--- a/net/compat.c
+++ b/net/compat.c
@@ -732,19 +732,25 @@ static unsigned char nas[21] = {
 
 asmlinkage long compat_sys_sendmsg(int fd, struct compat_msghdr __user *msg, unsigned flags)
 {
-	return sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+	return __sys_sendmsg(fd, (struct msghdr __user *)msg, flags | MSG_CMSG_COMPAT);
 }
 
 asmlinkage long compat_sys_sendmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 				    unsigned vlen, unsigned int flags)
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
 
 asmlinkage long compat_sys_recv(int fd, void __user *buf, size_t len, unsigned flags)
@@ -766,6 +772,9 @@ asmlinkage long compat_sys_recvmmsg(int
 	int datagrams;
 	struct timespec ktspec;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (timeout == NULL)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
--- a/net/socket.c
+++ b/net/socket.c
@@ -1876,9 +1876,9 @@ struct used_address {
 	unsigned int name_len;
 };
 
-static int __sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned flags,
-			 struct used_address *used_address)
+static int ___sys_sendmsg(struct socket *sock, struct msghdr __user *msg,
+			  struct msghdr *msg_sys, unsigned flags,
+			  struct used_address *used_address)
 {
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
@@ -1998,22 +1998,30 @@ out:
  *	BSD sendmsg interface
  */
 
-SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned, flags)
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
@@ -2044,15 +2052,16 @@ int __sys_sendmmsg(int fd, struct mmsghd
 
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
@@ -2076,11 +2085,13 @@ int __sys_sendmmsg(int fd, struct mmsghd
 SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, mmsg, vlen, flags);
 }
 
-static int __sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
-			 struct msghdr *msg_sys, unsigned flags, int nosec)
+static int ___sys_recvmsg(struct socket *sock, struct msghdr __user *msg,
+			  struct msghdr *msg_sys, unsigned flags, int nosec)
 {
 	struct compat_msghdr __user *msg_compat =
 	    (struct compat_msghdr __user *)msg;
@@ -2177,23 +2188,31 @@ out:
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
@@ -2231,17 +2250,18 @@ int __sys_recvmmsg(int fd, struct mmsghd
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
@@ -2308,6 +2328,9 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struc
 	int datagrams;
 	struct timespec timeout_sys;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 


