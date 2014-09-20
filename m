Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaITIDP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 04:03:15 -0400
Received: from mail-ob0-f202.google.com ([209.85.214.202]:36916 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389AbaITIDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 04:03:11 -0400
From: Peter Feiner <pfeiner@google.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Feiner <pfeiner@google.com>
Subject: [PATCH] mm: softdirty: keep bit when zapping file pte
Date: Sat, 20 Sep 2014 01:03:07 -0700
Message-Id: <1411200187-40896-1-git-send-email-pfeiner@google.com>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the same bug as b43790eedd31e9535b89bbfa45793919e9504c34 and
9aed8614af5a05cdaa32a0b78b0f1a424754a958 where the return value of
pte_*mksoft_dirty was being ignored.

To be sure that no other pte/pmd "mk" function return values were
being ignored, I annotated the functions in
arch/x86/include/asm/pgtable.h with __must_check and rebuilt.

Signed-off-by: Peter Feiner <pfeiner@google.com>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index adeac30..fc46934 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1125,7 +1125,7 @@ again:
 						addr) != page->index) {
 				pte_t ptfile = pgoff_to_pte(page->index);
 				if (pte_soft_dirty(ptent))
-					pte_file_mksoft_dirty(ptfile);
+					ptfile = pte_file_mksoft_dirty(ptfile);
 				set_pte_at(mm, addr, pte, ptfile);
 			}
 			if (PageAnon(page))
-- 
2.1.0.rc2.206.gedb03e5

