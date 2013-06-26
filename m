Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab3FZCpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:45:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54135 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab3FZCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Andy Lutomirski" <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.904571556@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [19/26] net: Block MSG_CMSG_COMPAT in send(m)msg and  recv(m)msg
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/socket.h |  3 +++
 net/compat.c           | 13 ++++++++--
 net/socket.c           | 67 +++++++++++++++++++++++++++++++++-----------------
 3 files changed, 59 insertions(+), 24 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 2acd2e2..7e9f2d3 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -336,6 +336,9 @@ extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec;
 
+/* The __sys_...msg variants allow MSG_CMSG_COMPAT */
+extern long __sys_recvmsg(int fd, struct msghdr __user *msg, unsigned flags);
+extern long __sys_sendmsg(int fd, struct msghdr __user *msg, unsigned flags);
 extern int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 			  unsigned int flags, struct timespec *timeout);
 extern int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg,
diff --git a/net/compat.c b/net/compat.c
index 6def90e..8c979cc 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -733,19 +733,25 @@ static unsigned char nas[21] = {
 
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
@@ -767,6 +773,9 @@ asmlinkage long compat_sys_recvmmsg(int fd, struct compat_mmsghdr __user *mmsg,
 	int datagrams;
 	struct timespec ktspec;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (timeout == NULL)
 		return __sys_recvmmsg(fd, (struct mmsghdr __user *)mmsg, vlen,
 				      flags | MSG_CMSG_COMPAT, NULL);
diff --git a/net/socket.c b/net/socket.c
index 68879db..cf546a3 100644
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
@@ -2044,15 +2052,16 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 
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
@@ -2076,11 +2085,13 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
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
@@ -2231,17 +2250,18 @@ int __sys_recvmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
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
@@ -2308,6 +2328,9 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	int datagrams;
 	struct timespec timeout_sys;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 

