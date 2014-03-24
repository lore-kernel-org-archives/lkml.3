Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbaCXNAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:00:49 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:45391 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbaCXM7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 08:59:30 -0400
Message-Id: <20140324125925.911631019@openvz.org>
User-Agent: quilt/0.60-1
Date: Mon, 24 Mar 2014 16:28:39 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: hughd@google.com, xemul@parallels.com, akpm@linux-foundation.org,
        gorcunov@openvz.org
Subject: [patch 1/4] mm: Make freshly remapped file pages being softdirty unconditionally
References: <20140324122838.490106581@openvz.org>
Content-Disposition: inline; filename=mm-file-pte-softdirty-update-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hugh reported:

 | I noticed your soft_dirty work in install_file_pte(): which looked
 | good at first, until I realized that it's propagating the soft_dirty
 | of a pte it's about to zap completely, to the unrelated entry it's
 | about to insert in its place.  Which seems very odd to me.

Indeed this code ends up being nop in result -- pte_file_mksoft_dirty()
operates with pte_t argument and returns new pte_t which were never
used after. After looking more I think what we need is to soft-dirtify
all newely remapped file pages because it should look like a new mapping
for memory tracker.

Reported-by: Hugh Dickins <hughd@google.com>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 mm/fremap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6.git/mm/fremap.c
===================================================================
--- linux-2.6.git.orig/mm/fremap.c
+++ linux-2.6.git/mm/fremap.c
@@ -66,13 +66,10 @@ static int install_file_pte(struct mm_st
 
 	ptfile = pgoff_to_pte(pgoff);
 
-	if (!pte_none(*pte)) {
-		if (pte_present(*pte) && pte_soft_dirty(*pte))
-			pte_file_mksoft_dirty(ptfile);
+	if (!pte_none(*pte))
 		zap_pte(mm, vma, addr, pte);
-	}
 
-	set_pte_at(mm, addr, pte, ptfile);
+	set_pte_at(mm, addr, pte, pte_file_mksoft_dirty(ptfile));
 	/*
 	 * We don't need to run update_mmu_cache() here because the "file pte"
 	 * being installed by install_file_pte() is not a real pte - it's a

