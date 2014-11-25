Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaKYLqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:46:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58283 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbaKYKlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:41:06 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sabrina Dubroca <sd@queasysnail.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 063/254] netfilter: nf_tables: check for NULL in nf_tables_newchain pcpu stats allocation
Date: Tue, 25 Nov 2014 10:36:53 +0000
Message-Id: <1416912004-5928-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

commit c123bb7163043bb8f33858cf8e45b01c17dbd171 upstream.

alloc_percpu returns NULL on failure, not a negative error code.

Fixes: ff3cd7b3c922 ("netfilter: nf_tables: refactor chain statistic routines")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62101ed0d2af..594afb3e7c40 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1102,10 +1102,10 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 			basechain->stats = stats;
 		} else {
 			stats = netdev_alloc_pcpu_stats(struct nft_stats);
-			if (IS_ERR(stats)) {
+			if (stats == NULL) {
 				module_put(type->owner);
 				kfree(basechain);
-				return PTR_ERR(stats);
+				return -ENOMEM;
 			}
 			rcu_assign_pointer(basechain->stats, stats);
 		}
-- 
2.1.0

