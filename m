Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab3LLWI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 17:08:28 -0500
Received: from smtp.outflux.net ([198.145.64.163]:48318 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751761Ab3LLWIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 17:08:24 -0500
Date: Thu, 12 Dec 2013 14:07:57 -0800
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>, Hugh Dickins <hughd@google.com>,
        linux-mm@kvack.org, PaX Team <pageexec@freemail.hu>,
        Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH] mm: fix use-after-free in sys_remap_file_pages
Message-ID: <20131212220757.GA14928@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: PaX Team <pageexec@freemail.hu>

http://lkml.org/lkml/2013/9/17/30

SyS_remap_file_pages() calls mmap_region(), which calls remove_vma_list(),
which calls remove_vma(), which frees the vma.  Later (after out label)
SyS_remap_file_pages() accesses the freed vma in vm_flags = vma->vm_flags.

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
 mm/fremap.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/fremap.c b/mm/fremap.c
index 5bff08147768..afad07b85ef2 100644
--- a/mm/fremap.c
+++ b/mm/fremap.c
@@ -218,6 +218,8 @@ get_write_lock:
 				BUG_ON(addr != start);
 				err = 0;
 			}
+			vm_flags = vma->vm_flags;
+			vma = NULL;
 			goto out;
 		}
 		mutex_lock(&mapping->i_mmap_mutex);
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
