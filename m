Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750845Ab3IFFT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 01:19:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:57813 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab3IFFTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 01:19:24 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-56-522965dbfd3e
From: Weijie Yang <weijie.yang@samsung.com>
To: sjenning@linux.vnet.ibm.com
Cc: minchan@kernel.org, bob.liu@oracle.com, weijie.yang.kh@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/4] mm/zswap: bugfix: memory leak when re-swapon
Date: Fri, 06 Sep 2013 13:16:45 +0800
Message-id: <000901ceaac0$a5f28420$f1d78c60$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6qwBw2B9l6Cf6OR2iYOg31tuWrtg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9jQd3bqZpBBj3rDS26Tk1lsbi8aw6b
	xb01/1ktln19z25xaN8qdosnJ/6zOLB57Jx1l91j06pONo9Nnyaxezw4tJnF4+PTWywenzfJ
	BbBFcdmkpOZklqUW6dslcGVcbdrFXLCFtWJuzzfGBsYtLF2MnBwSAiYSB2+vYIOwxSQu3FsP
	ZHNxCAlMZ5TYdrGFEcL5wyhx//dRsCo2AW2Ju/0bWUFsEQF5id3fvoPZzAIVEs+nfWcGsYUF
	XCQ2zvoPtoFFQFVi2ffNYL28AnYS6ybNY4GwBSV+TL4HZHMA9apLTJmSCzFGXmLzmrfMIGEJ
	oPCjv7oQm/Qkuv/fYYQoEZfYeOQWywRGgVlIBs1CGDQLyaBZSDoWMLKsYhRNLUguKE5KzzXU
	K07MLS7NS9dLzs/dxAgO/GdSOxhXNlgcYhTgYFTi4eXo0QgSYk0sK67MPcQowcGsJMIrrqEZ
	JMSbklhZlVqUH19UmpNafIhRmoNFSZz3QKt1oJBAemJJanZqakFqEUyWiYNTqoFRsld5/x5v
	scU/czWcT0zs4DkeynlqXqNV1Np+P75m0eVi3d2bYyd9fNK2UUPi9tpu77LI8Pmn25bFLc41
	e71vmaaOD0f0ZifONV8MHW6lGN9RzL0cwtAhtb+DR+7EbhtF53xlmbLbjYW2k5cbfGO5KH1u
	orPiVxaOY7lvb8rkTshtvpCx+6cSS3FGoqEWc1FxIgA1PjdBeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zswap_tree is not freed when swapoff, and it got re-kmalloc in swapon,
so memory-leak occurs.

Modify: free memory of zswap_tree in zswap_frontswap_invalidate_area().

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 mm/zswap.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index deda2b6..cbd9578 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -816,6 +816,10 @@ static void zswap_frontswap_invalidate_area(unsigned type)
 	}
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
+
+	zbud_destroy_pool(tree->pool);
+	kfree(tree);
+	zswap_trees[type] = NULL;
 }
 
 static struct zbud_ops zswap_zbud_ops = {
-- 
1.7.10.4


