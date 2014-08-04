Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbaHDRTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:19:46 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56438 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751684AbaHDQty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org
Date: Mon, 04 Aug 2014 17:48:31 +0100
Message-ID: <lsq.1407170911.284911304@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 01/94] Revert "net: ipv4: ip_forward: fix inverted
 local_df  test"
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

This reverts commit 59d9f389df3cdf72833d5ee17c3fe959b6bdc792, which
was commit ca6c5d4ad216d5942ae544bbf02503041bd802aa upstream.  It is a
valid fix, but depends on sk_buff::local_df being set in all the right
cases, which it wasn't in 3.2.  We need to defer it unless and until
the other fixes are also backported to 3.2.y.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv4/ip_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/ip_forward.c
+++ b/net/ipv4/ip_forward.c
@@ -42,12 +42,12 @@
 static bool ip_may_fragment(const struct sk_buff *skb)
 {
 	return unlikely((ip_hdr(skb)->frag_off & htons(IP_DF)) == 0) ||
-		skb->local_df;
+	       !skb->local_df;
 }
 
 static bool ip_exceeds_mtu(const struct sk_buff *skb, unsigned int mtu)
 {
-	if (skb->len <= mtu)
+	if (skb->len <= mtu || skb->local_df)
 		return false;
 
 	if (skb_is_gso(skb) && skb_gso_network_seglen(skb) <= mtu)

