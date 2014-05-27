Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258AbaE0Qzw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 12:55:52 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:51059 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaE0Qzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 12:55:51 -0400
Message-ID: <1401209749.5367.245.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: [PATCH] mm/zswap : NUMA aware allocation for zswap_dstmem
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Date: Tue, 27 May 2014 09:55:49 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

zswap_dstmem is a percpu block of memory, which should
be allocated using kmalloc_node(), to get better NUMA
locality.

Without it, all the blocks are allocated from a single node.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 mm/zswap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index aeaef0fb5624..008388fe7b0f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -347,7 +347,7 @@ static int __zswap_cpu_notifier(unsigned long action, unsigned long cpu)
 			return NOTIFY_BAD;
 		}
 		*per_cpu_ptr(zswap_comp_pcpu_tfms, cpu) = tfm;
-		dst = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
+		dst = kmalloc_node(PAGE_SIZE * 2, GFP_KERNEL, cpu_to_node(cpu));
 		if (!dst) {
 			pr_err("can't allocate compressor buffer\n");
 			crypto_free_comp(tfm);


