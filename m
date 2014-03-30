Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbaCaAcK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:32:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36237 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752828AbaC3XY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Janak Desai" <Janak.Desai@gtri.gatech.edu>,
        "Paul Moore" <pmoore@redhat.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.92829290@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 004/200] selinux: process labeled IPsec TCP SYN-ACK
 packets properly in selinux_ip_postroute()
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 5c6c26813a209e7075baf908e3ad81c1a9d389e8 upstream.

Due to difficulty in arriving at the proper security label for
TCP SYN-ACK packets in selinux_ip_postroute(), we need to check packets
while/before they are undergoing XFRM transforms instead of waiting
until afterwards so that we can determine the correct security label.

Reported-by: Janak Desai <Janak.Desai@gtri.gatech.edu>
Signed-off-by: Paul Moore <pmoore@redhat.com>
[bwh: Backported to 3.2:
 s/selinux_peerlbl_enabled()/netlbl_enabled() || selinux_xfrm_enabled()/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 security/selinux/hooks.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -4676,22 +4676,31 @@ static unsigned int selinux_ip_postroute
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
@@ -4719,6 +4728,25 @@ static unsigned int selinux_ip_postroute
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

