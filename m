Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757523AbaE2N5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 09:57:18 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59477 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933472AbaE2Ntd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 09:49:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrey Vagin <avagin@openvz.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 022/103] netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len
Date: Thu, 29 May 2014 15:48:07 +0200
Message-Id: <62c97a8612f753ffa6c5c7bebe140cc0951e539f.1401371259.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
References: <bcbac220dab16a4038ac1a7c5cfe3e7f034b3836.1401371258.git.jslaby@suse.cz>
In-Reply-To: <cover.1401371258.git.jslaby@suse.cz>
References: <cover.1401371258.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 223b02d923ecd7c84cf9780bb3686f455d279279 upstream.

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

The right way to fix this problem is reducing the size of the ecache
extension (4) and Florian is going to do this, but these changes will
be quite large to be appropriate for a stable tree.

Fixes: 5b423f6a40a0 (netfilter: nf_conntrack: fix racy timer handling with reliable)
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/net/netfilter/nf_conntrack_extend.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 88a1d4060d52..88877224473f 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -47,8 +47,8 @@ enum nf_ct_ext_id {
 /* Extensions: optional stuff which isn't permanently in struct. */
 struct nf_ct_ext {
 	struct rcu_head rcu;
-	u8 offset[NF_CT_EXT_NUM];
-	u8 len;
+	u16 offset[NF_CT_EXT_NUM];
+	u16 len;
 	char data[0];
 };
 
-- 
1.9.3

