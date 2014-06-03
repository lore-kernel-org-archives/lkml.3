Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbaFCLmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:42:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43769 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaFCLmb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:42:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 105/138] filter: prevent nla extensions to peek beyond the end of the message
Date: Tue,  3 Jun 2014 12:39:11 +0100
Message-Id: <1401795584-22664-106-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 05ab8f2647e4221cbdb3856dd7d32bd5407316b3 upstream.

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
[ luis: backported to 3.11: used davem's backport to 3.10 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/filter.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 52f01229ee01..c6c18d8a2d88 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -355,6 +355,8 @@ load_b:
 
 			if (skb_is_nonlinear(skb))
 				return 0;
+			if (skb->len < sizeof(struct nlattr))
+				return 0;
 			if (A > skb->len - sizeof(struct nlattr))
 				return 0;
 
@@ -371,11 +373,13 @@ load_b:
 
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
-- 
1.9.1

