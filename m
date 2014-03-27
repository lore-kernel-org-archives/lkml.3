Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756412AbaC0Pde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 11:33:34 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:39215 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbaC0Pdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 11:33:33 -0400
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org, vvs@parallels.com,
        Andrey Vagin <avagin@openvz.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len
Date: Thu, 27 Mar 2014 19:32:34 +0400
Message-Id: <1395934354-13226-1-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"len" contains sizeof(nf_ct_ext) and size of extensions. In a worst
case it can contain all extensions. Bellow you can find sizes for all
types of extensions. Their sum is definitely bigger than 256.

nf_ct_ext_types[0]->len = 24
nf_ct_ext_types[1]->len = 32
nf_ct_ext_types[2]->len = 24
nf_ct_ext_types[3]->len = 32
nf_ct_ext_types[4]->len = 152
nf_ct_ext_types[5]->len = 2
nf_ct_ext_types[6]->len = 16
nf_ct_ext_types[7]->len = 8

I have seen "len" up to 280 and my host has crashes w/o this patch.

Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 include/net/netfilter/nf_conntrack_extend.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 956b175..36fd6bf 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -48,7 +48,7 @@ enum nf_ct_ext_id {
 struct nf_ct_ext {
 	struct rcu_head rcu;
 	u8 offset[NF_CT_EXT_NUM];
-	u8 len;
+	u16 len;
 	char data[0];
 };
 
-- 
1.8.5.3

