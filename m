Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbaHHVM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:12:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41128 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbaHHUwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:52:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 207/259] netlink: Only check file credentials for implicit destinations
Date: Fri,  8 Aug 2014 13:40:30 -0700
Message-Id: <1407530482-4483-208-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Eric W. Biederman" <ebiederm@xmission.com>

[ Upstream commit 2d7a85f4b06e9c27ff629f07a524c48074f07f81 ]

It was possible to get a setuid root or setcap executable to write to
it's stdout or stderr (which has been set made a netlink socket) and
inadvertently reconfigure the networking stack.

To prevent this we check that both the creator of the socket and
the currentl applications has permission to reconfigure the network
stack.

Unfortunately this breaks Zebra which always uses sendto/sendmsg
and creates it's socket without any privileges.

To keep Zebra working don't bother checking if the creator of the
socket has privilege when a destination address is specified.  Instead
rely exclusively on the privileges of the sender of the socket.

Note from Andy: This is exactly Eric's code except for some comment
clarifications and formatting fixes.  Neither I nor, I think, anyone
else is thrilled with this approach, but I'm hesitant to wait on a
better fix since 3.15 is almost here.

Note to stable maintainers: This is a mess.  An earlier series of
patches in 3.15 fix a rather serious security issue (CVE-2014-0181),
but they did so in a way that breaks Zebra.  The offending series
includes:

    commit aa4cf9452f469f16cea8c96283b641b4576d4a7b
    Author: Eric W. Biederman <ebiederm@xmission.com>
    Date:   Wed Apr 23 14:28:03 2014 -0700

        net: Add variants of capable for use on netlink messages

If a given kernel version is missing that series of fixes, it's
probably worth backporting it and this patch.  if that series is
present, then this fix is critical if you care about Zebra.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/linux/netlink.h  | 7 ++++---
 net/netlink/af_netlink.c | 7 ++++++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 8d11541..8b50a62 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -16,9 +16,10 @@ static inline struct nlmsghdr *nlmsg_hdr(const struct sk_buff *skb)
 }
 
 enum netlink_skb_flags {
-	NETLINK_SKB_MMAPED	= 0x1,		/* Packet data is mmaped */
-	NETLINK_SKB_TX		= 0x2,		/* Packet was sent by userspace */
-	NETLINK_SKB_DELIVERED	= 0x4,		/* Packet was delivered */
+	NETLINK_SKB_MMAPED	= 0x1,	/* Packet data is mmaped */
+	NETLINK_SKB_TX		= 0x2,	/* Packet was sent by userspace */
+	NETLINK_SKB_DELIVERED	= 0x4,	/* Packet was delivered */
+	NETLINK_SKB_DST		= 0x8,	/* Dst set in sendto or sendmsg */
 };
 
 struct netlink_skb_parms {
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index bd0ce97..ba45917 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -1365,7 +1365,9 @@ retry:
 bool __netlink_ns_capable(const struct netlink_skb_parms *nsp,
 			struct user_namespace *user_ns, int cap)
 {
-	return sk_ns_capable(nsp->sk, user_ns, cap);
+	return ((nsp->flags & NETLINK_SKB_DST) ||
+		file_ns_capable(nsp->sk->sk_socket->file, user_ns, cap)) &&
+		ns_capable(user_ns, cap);
 }
 EXPORT_SYMBOL(__netlink_ns_capable);
 
@@ -2285,6 +2287,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	struct sk_buff *skb;
 	int err;
 	struct scm_cookie scm;
+	u32 netlink_skb_flags = 0;
 
 	if (msg->msg_flags&MSG_OOB)
 		return -EOPNOTSUPP;
@@ -2306,6 +2309,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 		if ((dst_group || dst_portid) &&
 		    !netlink_allowed(sock, NL_CFG_F_NONROOT_SEND))
 			goto out;
+		netlink_skb_flags |= NETLINK_SKB_DST;
 	} else {
 		dst_portid = nlk->dst_portid;
 		dst_group = nlk->dst_group;
@@ -2335,6 +2339,7 @@ static int netlink_sendmsg(struct kiocb *kiocb, struct socket *sock,
 	NETLINK_CB(skb).portid	= nlk->portid;
 	NETLINK_CB(skb).dst_group = dst_group;
 	NETLINK_CB(skb).creds	= siocb->scm->creds;
+	NETLINK_CB(skb).flags	= netlink_skb_flags;
 
 	err = -EFAULT;
 	if (memcpy_fromiovec(skb_put(skb, len), msg->msg_iov, len)) {
-- 
1.9.1

