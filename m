Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932339AbaJIVGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:06:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59042 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115AbaJIVG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:06:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Feiner <pfeiner@google.com>, Pavel Emelyanov <xemul@parallels.com>,
        Jamie Liu <jamieliu@google.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 146/163] mm: softdirty: keep bit when zapping file pte
Date: Thu,  9 Oct 2014 14:02:51 -0700
Message-Id: <1412888588-26755-147-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Feiner <pfeiner@google.com>

commit dbab31aa2ceec2d201966fa0b552f151310ba5f4 upstream.

This fixes the same bug as b43790eedd31 ("mm: softdirty: don't forget to
save file map softdiry bit on unmap") and 9aed8614af5a ("mm/memory.c:
don't forget to set softdirty on file mapped fault") where the return
value of pte_*mksoft_dirty was being ignored.

To be sure that no other pte/pmd "mk" function return values were being
ignored, I annotated the functions in arch/x86/include/asm/pgtable.h
with __must_check and rebuilt.

The userspace effect of this bug is that the softdirty mark might be
lost if a file mapped pte get zapped.

Signed-off-by: Peter Feiner <pfeiner@google.com>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Jamie Liu <jamieliu@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index d411f0d..e3c11e4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1119,7 +1119,7 @@ again:
 						addr) != page->index) {
 				pte_t ptfile = pgoff_to_pte(page->index);
 				if (pte_soft_dirty(ptent))
-					pte_file_mksoft_dirty(ptfile);
+					ptfile = pte_file_mksoft_dirty(ptfile);
 				set_pte_at(mm, addr, pte, ptfile);
 			}
 			if (PageAnon(page))
-- 
1.9.1

