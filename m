Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaLBJ1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 04:27:43 -0500
Received: from cnbjrel01.sonyericsson.com ([219.141.167.165]:5576 "EHLO
	cnbjrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbaLBJ1k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 04:27:40 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 2 Dec 2014 17:27:36 +0800
Subject: [RFC V2] mm:add zero_page _mapcount when mapped into user space
Thread-Topic: [RFC V2] mm:add zero_page _mapcount when mapped into user space
Thread-Index: AdAOEjVZ7CVTZrZqRRuSy8tkAu1Gbw==
Message-ID: <35FD53F367049845BC99AC72306C23D103E688B313E0@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add/dec zero_page's _mapcount to make sure
the mapcount is correct for zero_page,
so that when read from /proc/kpagecount, zero_page's
mapcount is also correct, userspace process like procrank can
calculate PSS correctly.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 mm/memory.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 3e50383..7215423 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2198,6 +2198,7 @@ gotten:
 		new_page = alloc_zeroed_user_highpage_movable(vma, address);
 		if (!new_page)
 			goto oom;
+		atomic_dec(&pfn_to_page(pte_pfn(orig_pte))->_mapcount);
 	} else {
 		new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
 		if (!new_page)
@@ -2647,6 +2648,7 @@ static int do_anonymous_page(struct mm_struct *mm, struct vm_area_struct *vma,
 		page_table = pte_offset_map_lock(mm, pmd, address, &ptl);
 		if (!pte_none(*page_table))
 			goto unlock;
+		atomic_inc(&pfn_to_page(my_zero_pfn(address))->_mapcount);
 		goto setpte;
 	}
 
-- 
2.1.3
