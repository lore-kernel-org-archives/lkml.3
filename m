Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaAOWZR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:25:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41022 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbaAOV5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:41 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 055/166] selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
Date: Wed, 15 Jan 2014 13:51:09 -0800
Message-Id: <1389822780-4729-56-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 47180068276a04ed31d24fe04c673138208b07a9 upstream.

In selinux_ip_output() we always label packets based on the parent
socket.  While this approach works in almost all cases, it doesn't
work in the case of TCP SYN-ACK packets when the correct label is not
the label of the parent socket, but rather the label of the larval
socket represented by the request_sock struct.

Unfortunately, since the request_sock isn't queued on the parent
socket until *after* the SYN-ACK packet is sent, we can't lookup the
request_sock to determine the correct label for the packet; at this
point in time the best we can do is simply pass/NF_ACCEPT the packet.
It must be said that simply passing the packet without any explicit
labeling action, while far from ideal, is not terrible as the SYN-ACK
packet will inherit any IP option based labeling from the initial
connection request so the label *should* be correct and all our
access controls remain in place so we shouldn't have to worry about
information leaks.

Reported-by: Janak Desai <Janak.Desai@gtri.gatech.edu>
Tested-by: Janak Desai <Janak.Desai@gtri.gatech.edu>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 security/selinux/hooks.c | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 9e8bcf3..1ce432d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -52,6 +52,7 @@
 #include <net/icmp.h>
 #include <net/ip.h>		/* for local_port_range[] */
 #include <net/tcp.h>		/* struct or_callable used in sock_rcv_skb */
+#include <net/inet_connection_sock.h>
 #include <net/net_namespace.h>
 #include <net/netlabel.h>
 #include <linux/uaccess.h>
@@ -4612,6 +4613,7 @@ static unsigned int selinux_ipv6_forward(unsigned int hooknum,
 static unsigned int selinux_ip_output(struct sk_buff *skb,
 				      u16 family)
 {
+	struct sock *sk;
 	u32 sid;
 
 	if (!netlbl_enabled())
@@ -4620,8 +4622,27 @@ static unsigned int selinux_ip_output(struct sk_buff *skb,
 	/* we do this in the LOCAL_OUT path and not the POST_ROUTING path
 	 * because we want to make sure we apply the necessary labeling
 	 * before IPsec is applied so we can leverage AH protection */
-	if (skb->sk) {
-		struct sk_security_struct *sksec = skb->sk->sk_security;
+	sk = skb->sk;
+	if (sk) {
+		struct sk_security_struct *sksec;
+
+		if (sk->sk_state == TCP_LISTEN)
+			/* if the socket is the listening state then this
+			 * packet is a SYN-ACK packet which means it needs to
+			 * be labeled based on the connection/request_sock and
+			 * not the parent socket.  unfortunately, we can't
+			 * lookup the request_sock yet as it isn't queued on
+			 * the parent socket until after the SYN-ACK is sent.
+			 * the "solution" is to simply pass the packet as-is
+			 * as any IP option based labeling should be copied
+			 * from the initial connection request (in the IP
+			 * layer).  it is far from ideal, but until we get a
+			 * security label in the packet itself this is the
+			 * best we can do. */
+			return NF_ACCEPT;
+
+		/* standard practice, label using the parent socket */
+		sksec = sk->sk_security;
 		sid = sksec->sid;
 	} else
 		sid = SECINITSID_KERNEL;
-- 
1.8.3.2

