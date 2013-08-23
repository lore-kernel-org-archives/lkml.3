Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3HWLDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 07:03:38 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:48309 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363Ab3HWLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 07:03:37 -0400
MIME-Version: 1.0
Date: Fri, 23 Aug 2013 19:03:37 +0800
Message-ID: <CAL1ERfPzB=CvKJ6kAq2YYTkkg-EgSOWRyfSFWkvKp8ZdQkCDxA@mail.gmail.com>
Subject: [PATCH 1/4] zswap bugfix: memory leaks when re-swapon
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Minchan Kim <minchan@kernel.org>, Bob Liu <bob.liu@oracle.com>,
        sjenning@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, weijie.yang@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap_tree is not freed when swapoff, and it got re-kzalloc in swapon,
memory leak occurs.
Add check statement in zswap_frontswap_init so that zswap_tree is
inited only once.

---
 mm/zswap.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index deda2b6..1cf1c07 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -826,6 +826,11 @@ static void zswap_frontswap_init(unsigned type)
 {
 	struct zswap_tree *tree;

+	if (zswap_trees[type]) {
+		BUG_ON(zswap_trees[type]->rbroot != RB_ROOT);  /* invalidate_area set it */
+		return;
+	}
+
 	tree = kzalloc(sizeof(struct zswap_tree), GFP_KERNEL);
 	if (!tree)
 		goto err;
-- 
1.7.0.4
