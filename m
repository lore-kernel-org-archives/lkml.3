Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261AbaJCXqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:46:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46282 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757260AbaJCWDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Feiner <pfeiner@google.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jamie Liu <jamieliu@google.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.16 280/357] mm: softdirty: keep bit when zapping file pte
Date: Fri,  3 Oct 2014 14:31:06 -0700
Message-Id: <20141003212941.902530190@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


