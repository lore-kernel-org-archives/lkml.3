Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965829AbaFQVqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:46:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965791AbaFQVqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:46:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 057/212] net: gro: make sure skb->cb[] initial content has not to be zero
Date: Tue, 17 Jun 2014 14:42:31 -0700
Message-Id: <1403041506-13646-58-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 29e98242783ed3ba569797846a606ba66f781625 ]

Starting from linux-3.13, GRO attempts to build full size skbs.

Problem is the commit assumed one particular field in skb->cb[]
was clean, but it is not the case on some stacked devices.

Timo reported a crash in case traffic is decrypted before
reaching a GRE device.

Fix this by initializing NAPI_GRO_CB(skb)->last at the right place,
this also removes one conditional.

Thanks a lot to Timo for providing full reports and bisecting this.

Fixes: 8a29111c7ca6 ("net: gro: allow to build full sized skb")
Bisected-by: Timo Teras <timo.teras@iki.fi>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Tested-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/core/dev.c    | 1 +
 net/core/skbuff.c | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 233d1c4..4c0ff6f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3882,6 +3882,7 @@ static enum gro_result dev_gro_receive(struct napi_struct *napi, struct sk_buff
 	napi->gro_count++;
 	NAPI_GRO_CB(skb)->count = 1;
 	NAPI_GRO_CB(skb)->age = jiffies;
+	NAPI_GRO_CB(skb)->last = skb;
 	skb_shinfo(skb)->gso_size = skb_gro_len(skb);
 	skb->next = napi->gro_list;
 	napi->gro_list = skb;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index bdd6955..f45d60d 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2980,7 +2980,7 @@ int skb_gro_receive(struct sk_buff **head, struct sk_buff *skb)
 	if (unlikely(p->len + len >= 65536))
 		return -E2BIG;
 
-	lp = NAPI_GRO_CB(p)->last ?: p;
+	lp = NAPI_GRO_CB(p)->last;
 	pinfo = skb_shinfo(lp);
 
 	if (headlen <= offset) {
@@ -3096,7 +3096,7 @@ merge:
 
 	__skb_pull(skb, offset);
 
-	if (!NAPI_GRO_CB(p)->last)
+	if (NAPI_GRO_CB(p)->last == p)
 		skb_shinfo(p)->frag_list = skb;
 	else
 		NAPI_GRO_CB(p)->last->next = skb;
-- 
1.9.1

