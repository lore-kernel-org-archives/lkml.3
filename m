Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbaDPKdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:33:18 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51841 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaDPKdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:33:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Andrey Vagin <avagin@openvz.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 44/46] netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len
Date: Wed, 16 Apr 2014 11:32:00 +0100
Message-Id: <1397644322-13905-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Vagin <avagin@openvz.org>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/netfilter/nf_conntrack_extend.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_extend.h b/include/net/netfilter/nf_conntrack_extend.h
index 3313108..86dd7dd 100644
--- a/include/net/netfilter/nf_conntrack_extend.h
+++ b/include/net/netfilter/nf_conntrack_extend.h
@@ -41,8 +41,8 @@ enum nf_ct_ext_id {
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
1.9.1

