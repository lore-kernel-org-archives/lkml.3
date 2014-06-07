Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaFGBXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:23:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35932 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752299AbaFGBXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mathias Krause" <minipli@googlemail.com>,
        "Daniel Borkmann" <dborkman@redhat.com>,
        "Pablo Neira Ayuso" <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Patrick McHardy" <kaber@trash.net>
Date: Sat, 07 Jun 2014 02:26:28 +0100
Message-ID: <lsq.1402104388.330778184@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 12/92] filter: prevent nla extensions to peek beyond
 the end  of the message
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 05ab8f2647e4221cbdb3856dd7d32bd5407316b3 ]

The BPF_S_ANC_NLATTR and BPF_S_ANC_NLATTR_NEST extensions fail to check
for a minimal message length before testing the supplied offset to be
within the bounds of the message. This allows the subtraction of the nla
header to underflow and therefore -- as the data type is unsigned --
allowing far to big offset and length values for the search of the
netlink attribute.

The remainder calculation for the BPF_S_ANC_NLATTR_NEST extension is
also wrong. It has the minuend and subtrahend mixed up, therefore
calculates a huge length value, allowing to overrun the end of the
message while looking for the netlink attribute.

The following three BPF snippets will trigger the bugs when attached to
a UNIX datagram socket and parsing a message with length 1, 2 or 3.

 ,-[ PoC for missing size check in BPF_S_ANC_NLATTR ]--
 | ld	#0x87654321
 | ldx	#42
 | ld	#nla
 | ret	a
 `---

 ,-[ PoC for the same bug in BPF_S_ANC_NLATTR_NEST ]--
 | ld	#0x87654321
 | ldx	#42
 | ld	#nlan
 | ret	a
 `---

 ,-[ PoC for wrong remainder calculation in BPF_S_ANC_NLATTR_NEST ]--
 | ; (needs a fake netlink header at offset 0)
 | ld	#0
 | ldx	#42
 | ld	#nlan
 | ret	a
 `---

Fix the first issue by ensuring the message length fulfills the minimal
size constrains of a nla header. Fix the second bug by getting the math
for the remainder calculation right.

Fixes: 4738c1db15 ("[SKFILTER]: Add SKF_ADF_NLATTR instruction")
Fixes: d214c7537b ("filter: add SKF_AD_NLATTR_NEST to look for nested..")
Cc: Patrick McHardy <kaber@trash.net>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Daniel Borkmann <dborkman@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[bwh: Fix misplacement of the first check due to a bug in the patch program]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/filter.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -320,6 +320,8 @@ load_b:
 
 			if (skb_is_nonlinear(skb))
 				return 0;
+			if (skb->len < sizeof(struct nlattr))
+				return 0;
 			if (A > skb->len - sizeof(struct nlattr))
 				return 0;
 
@@ -336,11 +338,13 @@ load_b:
 
 			if (skb_is_nonlinear(skb))
 				return 0;
+			if (skb->len < sizeof(struct nlattr))
+				return 0;
 			if (A > skb->len - sizeof(struct nlattr))
 				return 0;
 
 			nla = (struct nlattr *)&skb->data[A];
-			if (nla->nla_len > A - skb->len)
+			if (nla->nla_len > skb->len - A)
 				return 0;
 
 			nla = nla_find_nested(nla, X);

