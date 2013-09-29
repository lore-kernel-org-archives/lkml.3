Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3I2NcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 09:32:12 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:59828 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab3I2NcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 09:32:10 -0400
From: baker.kernel@gmail.com
To: davem@davemloft.net
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "baker.zhang" <baker.kernel@gmail.com>
Subject: [PATCH V2 net-next] fib_trie: avoid a redundant bit judgement in inflate
Date: Sun, 29 Sep 2013 21:31:58 +0800
Message-Id: <1380461518-10095-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "baker.zhang" <baker.kernel@gmail.com>

Because 'node' is the i'st child of 'oldnode',
thus, here 'i' equals
tkey_extract_bits(node->key, oldtnode->pos, oldtnode->bits)

we just get 1 more bit,
and need not care the detail value of this bits.

Signed-off-by: baker.zhang <baker.kernel@gmail.com>
---
 net/ipv4/fib_trie.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 3df6d3e..45c74ba 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -762,12 +762,9 @@ static struct tnode *inflate(struct trie *t, struct tnode *tn)
 
 		if (IS_LEAF(node) || ((struct tnode *) node)->pos >
 		   tn->pos + tn->bits - 1) {
-			if (tkey_extract_bits(node->key,
-					      oldtnode->pos + oldtnode->bits,
-					      1) == 0)
-				put_child(tn, 2*i, node);
-			else
-				put_child(tn, 2*i+1, node);
+			put_child(tn,
+				tkey_extract_bits(node->key, oldtnode->pos, oldtnode->bits + 1),
+				node);
 			continue;
 		}
 
-- 
1.8.1.2

