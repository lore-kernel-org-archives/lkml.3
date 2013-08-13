Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab3HMQJ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:09:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9153 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642Ab3HMP63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:29 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=d23nV_cXnzQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=1iDf7ncrRWQA:10 a=SOq6UgPBAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=z9odyffjMVvEqKmo1QkA:9 a=5y_flRe8UpcA:10 a=LI9Vle30uBYA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155826.783323645@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:14 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [20/88] net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0020-net-Block-MSG_CMSG_COMPAT-in-send-m-msg-and-recv-m-m.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

[ Upstream commit 1be374a0518a288147c6a7398792583200a67261 ]

To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, trinity@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, netdev@vger.kernel.org, "David S.
	Miller" <davem@davemloft.net>
Subject: [20/88] [PATCH 5/5] net: Block MSG_CMSG_COMPAT in send(m)msg and recv(m)msg

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/socket.c |   33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/net/socket.c b/net/socket.c
index edc3c4a..3bc74ed 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -2016,8 +2016,12 @@ SYSCALL_DEFINE3(sendmsg, int, fd, struct msghdr __user *, msg, unsigned int, fla
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
 
@@ -2090,6 +2094,8 @@ int __sys_sendmmsg(int fd, struct mmsghdr __user *mmsg, unsigned int vlen,
 SYSCALL_DEFINE4(sendmmsg, int, fd, struct mmsghdr __user *, mmsg,
 		unsigned int, vlen, unsigned int, flags)
 {
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
 	return __sys_sendmmsg(fd, mmsg, vlen, flags);
 }
 
@@ -2190,8 +2196,12 @@ SYSCALL_DEFINE3(recvmsg, int, fd, struct msghdr __user *, msg,
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
 
@@ -2316,6 +2326,9 @@ SYSCALL_DEFINE5(recvmmsg, int, fd, struct mmsghdr __user *, mmsg,
 	int datagrams;
 	struct timespec timeout_sys;
 
+	if (flags & MSG_CMSG_COMPAT)
+		return -EINVAL;
+
 	if (!timeout)
 		return __sys_recvmmsg(fd, mmsg, vlen, flags, NULL);
 
@@ -2431,15 +2444,31 @@ SYSCALL_DEFINE2(socketcall, int, call, unsigned long __user *, args)
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
1.7.10.4


