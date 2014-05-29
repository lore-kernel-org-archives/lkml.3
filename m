Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbaE2EgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 00:36:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932803AbaE2EgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:36:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?q?Timo=20Ter=E4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 131/140] net: gro: make sure skb->cb[] initial content has not to be zero
Date: Wed, 28 May 2014 21:34:30 -0700
Message-Id: <20140529043106.210099864@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c    |    1 +
 net/core/skbuff.c |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3944,6 +3944,7 @@ static enum gro_result dev_gro_receive(s
 	}
 	NAPI_GRO_CB(skb)->count = 1;
 	NAPI_GRO_CB(skb)->age = jiffies;
+	NAPI_GRO_CB(skb)->last = skb;
 	skb_shinfo(skb)->gso_size = skb_gro_len(skb);
 	skb->next = napi->gro_list;
 	napi->gro_list = skb;
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3076,7 +3076,7 @@ int skb_gro_receive(struct sk_buff **hea
 	if (unlikely(p->len + len >= 65536))
 		return -E2BIG;
 
-	lp = NAPI_GRO_CB(p)->last ?: p;
+	lp = NAPI_GRO_CB(p)->last;
 	pinfo = skb_shinfo(lp);
 
 	if (headlen <= offset) {
@@ -3192,7 +3192,7 @@ merge:
 
 	__skb_pull(skb, offset);
 
-	if (!NAPI_GRO_CB(p)->last)
+	if (NAPI_GRO_CB(p)->last == p)
 		skb_shinfo(p)->frag_list = skb;
 	else
 		NAPI_GRO_CB(p)->last->next = skb;


