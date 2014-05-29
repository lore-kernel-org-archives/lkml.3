Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731AbaE2Ew3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:52:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136AbaE2Eie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:38:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Mathias Krause <minipli@googlemail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 50/86] filter: prevent nla extensions to peek beyond the end of the message
Date: Wed, 28 May 2014 21:37:25 -0700
Message-Id: <20140529043520.269192726@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043513.451722422@linuxfoundation.org>
References: <20140529043513.451722422@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/filter.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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


