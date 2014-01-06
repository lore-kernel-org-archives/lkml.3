Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757522AbaAFXhr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:37:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47988 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932724AbaAFWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:40:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Janak Desai <Janak.Desai@gtri.gatech.edu>,
        Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.12 138/144] selinux: process labeled IPsec TCP SYN-ACK packets properly in selinux_ip_postroute()
Date: Mon,  6 Jan 2014 14:38:19 -0800
Message-Id: <20140106223749.303313710@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223745.326293132@linuxfoundation.org>
References: <20140106223745.326293132@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit c0828e50485932b7e019df377a6b0a8d1ebd3080 upstream.

Due to difficulty in arriving at the proper security label for
TCP SYN-ACK packets in selinux_ip_postroute(), we need to check packets
while/before they are undergoing XFRM transforms instead of waiting
until afterwards so that we can determine the correct security label.

Reported-by: Janak Desai <Janak.Desai@gtri.gatech.edu>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/selinux/hooks.c |   43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4811,22 +4811,32 @@ static unsigned int selinux_ip_postroute
 	 * as fast and as clean as possible. */
 	if (!selinux_policycap_netpeer)
 		return selinux_ip_postroute_compat(skb, ifindex, family);
+
+	secmark_active = selinux_secmark_enabled();
+	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
+	if (!secmark_active && !peerlbl_active)
+		return NF_ACCEPT;
+
+	sk = skb->sk;
+
 #ifdef CONFIG_XFRM
 	/* If skb->dst->xfrm is non-NULL then the packet is undergoing an IPsec
 	 * packet transformation so allow the packet to pass without any checks
 	 * since we'll have another chance to perform access control checks
 	 * when the packet is on it's final way out.
 	 * NOTE: there appear to be some IPv6 multicast cases where skb->dst
-	 *       is NULL, in this case go ahead and apply access control. */
-	if (skb_dst(skb) != NULL && skb_dst(skb)->xfrm != NULL)
+	 *       is NULL, in this case go ahead and apply access control.
+	 *       is NULL, in this case go ahead and apply access control.
+	 * NOTE: if this is a local socket (skb->sk != NULL) that is in the
+	 *       TCP listening state we cannot wait until the XFRM processing
+	 *       is done as we will miss out on the SA label if we do;
+	 *       unfortunately, this means more work, but it is only once per
+	 *       connection. */
+	if (skb_dst(skb) != NULL && skb_dst(skb)->xfrm != NULL &&
+	    !(sk != NULL && sk->sk_state == TCP_LISTEN))
 		return NF_ACCEPT;
 #endif
-	secmark_active = selinux_secmark_enabled();
-	peerlbl_active = netlbl_enabled() || selinux_xfrm_enabled();
-	if (!secmark_active && !peerlbl_active)
-		return NF_ACCEPT;
 
-	sk = skb->sk;
 	if (sk == NULL) {
 		/* Without an associated socket the packet is either coming
 		 * from the kernel or it is being forwarded; check the packet
@@ -4854,6 +4864,25 @@ static unsigned int selinux_ip_postroute
 		struct sk_security_struct *sksec = sk->sk_security;
 		if (selinux_skb_peerlbl_sid(skb, family, &skb_sid))
 			return NF_DROP;
+		/* At this point, if the returned skb peerlbl is SECSID_NULL
+		 * and the packet has been through at least one XFRM
+		 * transformation then we must be dealing with the "final"
+		 * form of labeled IPsec packet; since we've already applied
+		 * all of our access controls on this packet we can safely
+		 * pass the packet. */
+		if (skb_sid == SECSID_NULL) {
+			switch (family) {
+			case PF_INET:
+				if (IPCB(skb)->flags & IPSKB_XFRM_TRANSFORMED)
+					return NF_ACCEPT;
+				break;
+			case PF_INET6:
+				if (IP6CB(skb)->flags & IP6SKB_XFRM_TRANSFORMED)
+					return NF_ACCEPT;
+			default:
+				return NF_DROP_ERR(-ECONNREFUSED);
+			}
+		}
 		if (selinux_conn_sid(sksec->sid, skb_sid, &peer_sid))
 			return NF_DROP;
 		secmark_perm = PACKET__SEND;


