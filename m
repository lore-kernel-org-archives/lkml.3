Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbaJWNaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:30:35 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:47163 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960AbaJWNac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:30:32 -0400
Message-ID: <1414071030.2094.46.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATHC] net: napi_reuse_skb() should check pfmemalloc
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Roman Gushchin <klamm@yandex-team.ru>
Cc: "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "bruce.w.allan@intel.com" <bruce.w.allan@intel.com>,
        "carolyn.wyborny@intel.com" <carolyn.wyborny@intel.com>,
        "donald.c.skidmore@intel.com" <donald.c.skidmore@intel.com>,
        "gregory.v.rose@intel.com" <gregory.v.rose@intel.com>,
        "peter.p.waskiewicz.jr@intel.com" <peter.p.waskiewicz.jr@intel.com>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "john.ronciak@intel.com" <john.ronciak@intel.com>,
        "tushar.n.dave@intel.com" <tushar.n.dave@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sassmann@kpanic.de" <sassmann@kpanic.de>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Oct 2014 06:30:30 -0700
In-Reply-To: <1811414063272@webcorp02e.yandex-team.ru>
References: <1413985819-9553-1-git-send-email-klamm@yandex-team.ru>
	 <1413992737.9031.1.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1811414063272@webcorp02e.yandex-team.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Do not reuse skb if it was pfmemalloc tainted, otherwise
future frame might be dropped anyway.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/dev.c b/net/core/dev.c
index b793e3521a36..945bbd001359 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4157,6 +4157,10 @@ EXPORT_SYMBOL(napi_gro_receive);
 
 static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 {
+	if (unlikely(skb->pfmemalloc)) {
+		consume_skb(skb);
+		return;
+	}
 	__skb_pull(skb, skb_headlen(skb));
 	/* restore the reserve we had after netdev_alloc_skb_ip_align() */
 	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN - skb_headroom(skb));


