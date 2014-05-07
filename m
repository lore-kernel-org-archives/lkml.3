Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325AbaEGCgO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 22:36:14 -0400
Received: from mga09.intel.com ([134.134.136.24]:13484 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751140AbaEGCgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 22:36:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1000,1389772800"; 
   d="scan'208";a="507343935"
From: Leon Ma <xindong.ma@intel.com>
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com,
        n-horiguchi@ah.jp.nec.com, kirill.shutemov@linux.intel.com,
        gorcunov@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Leon Ma <xindong.ma@intel.com>
Subject: [PATCH] rmap: validate pointer in anon_vma_clone
Date: Wed,  7 May 2014 10:32:09 +0800
Message-Id: <1399429930-5073-1-git-send-email-xindong.ma@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If memory allocation failed in first loop, root will be NULL and
will lead to kernel panic.

Signed-off-by: Leon Ma <xindong.ma@intel.com>
---
 mm/rmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 9c3e773..6e53aed 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -246,8 +246,10 @@ int anon_vma_clone(struct vm_area_struct *dst, struct vm_area_struct *src)
 
 		avc = anon_vma_chain_alloc(GFP_NOWAIT | __GFP_NOWARN);
 		if (unlikely(!avc)) {
-			unlock_anon_vma_root(root);
-			root = NULL;
+			if (!root) {
+				unlock_anon_vma_root(root);
+				root = NULL;
+			}
 			avc = anon_vma_chain_alloc(GFP_KERNEL);
 			if (!avc)
 				goto enomem_failure;
-- 
1.7.9.5

