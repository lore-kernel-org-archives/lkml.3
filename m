Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab3LRVMd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:12:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36060 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab3LRVMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:12:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Janak Desai <Janak.Desai@gtri.gatech.edu>,
        Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.10 38/78] selinux: handle TCP SYN-ACK packets correctly in selinux_ip_output()
Date: Wed, 18 Dec 2013 13:11:06 -0800
Message-Id: <20131218211112.980775937@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211111.903835960@linuxfoundation.org>
References: <20131218211111.903835960@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |   25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -53,6 +53,7 @@
 #include <net/ip.h>		/* for local_port_range[] */
 #include <net/sock.h>
 #include <net/tcp.h>		/* struct or_callable used in sock_rcv_skb */
+#include <net/inet_connection_sock.h>
 #include <net/net_namespace.h>
 #include <net/netlabel.h>
 #include <linux/uaccess.h>
@@ -4621,6 +4622,7 @@ static unsigned int selinux_ipv6_forward
 static unsigned int selinux_ip_output(struct sk_buff *skb,
 				      u16 family)
 {
+	struct sock *sk;
 	u32 sid;
 
 	if (!netlbl_enabled())
@@ -4629,8 +4631,27 @@ static unsigned int selinux_ip_output(st
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


