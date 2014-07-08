Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaGHTWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:22:00 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:42182 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755996AbaGHTVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:21:54 -0400
Date: Tue, 8 Jul 2014 23:21:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm: Don't forget to set softdirty on file mapped fault
Message-ID: <20140708192151.GD17860@moon.sw.swsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise we may not notice that pte was softdirty because pte_mksoft_dirty
helper _returns_ new pte but not modifies argument.

CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/mm/memory.c
===================================================================
--- linux-2.6.git.orig/mm/memory.c
+++ linux-2.6.git/mm/memory.c
@@ -2744,7 +2744,7 @@ void do_set_pte(struct vm_area_struct *v
 	if (write)
 		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
 	else if (pte_file(*pte) && pte_file_soft_dirty(*pte))
-		pte_mksoft_dirty(entry);
+		entry = pte_mksoft_dirty(entry);
 	if (anon) {
 		inc_mm_counter_fast(vma->vm_mm, MM_ANONPAGES);
 		page_add_new_anon_rmap(page, vma, address);
