Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaKPWEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 17:04:24 -0500
Received: from 1wt.eu ([62.212.114.60]:48014 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbaKPWEW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 17:04:22 -0500
Message-Id: <20141116215329.103693290@1wt.eu>
User-Agent: quilt/0.48-1
Date: Sun, 16 Nov 2014 22:53:39 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Mathias Krause <minipli@googlemail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 11/48] filter: prevent nla extensions to peek beyond the end
In-Reply-To: <28c765bc23bd4bae1611534e510f49f8@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 of the message

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
[geissert: backport to 2.6.32]
[wt: fixes CVE-2014-3144]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/core/filter.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d162169..a2dcdb9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -316,6 +316,9 @@ load_b:
 
 			if (skb_is_nonlinear(skb))
 				return 0;
+			if (skb->len < sizeof(struct nlattr))
+				return 0;
+
 			if (A > skb->len - sizeof(struct nlattr))
 				return 0;
 
@@ -332,11 +335,14 @@ load_b:
 
 			if (skb_is_nonlinear(skb))
 				return 0;
+			if (skb->len < sizeof(struct nlattr))
+				return 0;
+
 			if (A > skb->len - sizeof(struct nlattr))
 				return 0;
 
 			nla = (struct nlattr *)&skb->data[A];
-			if (nla->nla_len > A - skb->len)
+			if (nla->nla_len > skb->len - A)
 				return 0;
 
 			nla = nla_find_nested(nla, X);
-- 
1.7.12.2.21.g234cd45.dirty



