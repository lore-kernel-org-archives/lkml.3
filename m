Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaBGLsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:48:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaBGLs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:48:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 038/233] mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL
Date: Fri,  7 Feb 2014 11:44:17 +0000
Message-Id: <1391773652-25214-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit f92f455f67fef27929e6043499414605b0c94872 upstream.

{,set}page_address() are macros if WANT_PAGE_VIRTUAL.  If
!WANT_PAGE_VIRTUAL, they're plain C functions.

If someone calls them with a void *, this pointer is auto-converted to
struct page * if !WANT_PAGE_VIRTUAL, but causes a build failure on
architectures using WANT_PAGE_VIRTUAL (arc, m68k and sparc64):

  drivers/md/bcache/bset.c: In function `__btree_sort':
  drivers/md/bcache/bset.c:1190: warning: dereferencing `void *' pointer
  drivers/md/bcache/bset.c:1190: error: request for member `virtual' in something not a structure or union

Convert them to static inline functions to fix this.  There are already
plenty of users of struct page members inside <linux/mm.h>, so there's
no reason to keep them as macros.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/mm.h | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f022460..a6154b1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -769,11 +769,14 @@ static __always_inline void *lowmem_page_address(const struct page *page)
 #endif
 
 #if defined(WANT_PAGE_VIRTUAL)
-#define page_address(page) ((page)->virtual)
-#define set_page_address(page, address)			\
-	do {						\
-		(page)->virtual = (address);		\
-	} while(0)
+static inline void *page_address(const struct page *page)
+{
+	return page->virtual;
+}
+static inline void set_page_address(struct page *page, void *address)
+{
+	page->virtual = address;
+}
 #define page_address_init()  do { } while(0)
 #endif
 
-- 
1.8.3.2

