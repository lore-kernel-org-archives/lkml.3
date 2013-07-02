Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab3GBLIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:08:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36195 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3GBLIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:07 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "x86@kernel.org, trinity@vger.kernel.org, Andy Lutomirski" 
	<luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 13/50] net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
Date: Tue,  2 Jul 2013 12:07:01 +0100
Message-Id: <1372763258-20664-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

commit 1be374a0518a288147c6a7398792583200a67261 upstream.

To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, trinity@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, netdev@vger.kernel.org, "David S.
	Miller" <davem@davemloft.net>
Subject: [PATCH 5/5] net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/socket.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index bce45cc..a8e03b9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2017,8 +2017,12 @@ SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, fla
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
+
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
@@ -2091,6 +2095,8 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, mmsg, vlen, flags);
 }
 
@@ -2191,8 +2197,12 @@ SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
 {
 	int fput_needed, err;
 	struct msghdr msg_sys;
-	struct socket *sock = sockfd_lookup_light(fd, &err, &fput_needed);
+	struct socket *sock;
+
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 
+	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
 
@@ -2317,6 +2327,9 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	int datagrams;
 	struct timespec timeout_sys;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 
@@ -2432,15 +2445,31 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
 				   (int __user *)a[4]);
 		break;
 	case SYS_SENDMSG:
+		if (a[2] & MSG_CMSG_COMPAT) {
+			err = -EINVAL;
+			break;
+		}
 		err = sys_sendmsg(a0, (struct msghdr __user *)a1, a[2]);
 		break;
 	case SYS_SENDMMSG:
+		if (a[3] & MSG_CMSG_COMPAT) {
+			err = -EINVAL;
+			break;
+		}
 		err = sys_sendmmsg(a0, (struct mmsghdr __user *)a1, a[2], a[3]);
 		break;
 	case SYS_RECVMSG:
+		if (a[2] & MSG_CMSG_COMPAT) {
+			err = -EINVAL;
+			break;
+		}
 		err = sys_recvmsg(a0, (struct msghdr __user *)a1, a[2]);
 		break;
 	case SYS_RECVMMSG:
+		if (a[3] & MSG_CMSG_COMPAT) {
+			err = -EINVAL;
+			break;
+		}
 		err = sys_recvmmsg(a0, (struct mmsghdr __user *)a1, a[2], a[3],
 				   (struct timespec __user *)a[4]);
 		break;
-- 
1.8.1.2

