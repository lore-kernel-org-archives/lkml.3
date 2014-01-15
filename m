Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaAOJeH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 04:34:07 -0500
Received: from juliette.telenet-ops.be ([195.130.137.74]:36254 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaAOJeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 04:34:02 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-mm@kvack.org, linux-bcache@vger.kernel.org,
        Vineet Gupta <vgupta@synopsys.com>, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mm: Make {,set}page_address() static inline if WANT_PAGE_VIRTUAL
Date: Wed, 15 Jan 2014 10:33:46 +0100
Message-Id: <1389778426-14836-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

{,set}page_address() are macros if WANT_PAGE_VIRTUAL.
If !WANT_PAGE_VIRTUAL, they're plain C functions.

If someone calls them with a void *, this pointer is auto-converted to
struct page * if !WANT_PAGE_VIRTUAL, but causes a build failure on
architectures using WANT_PAGE_VIRTUAL (arc, m68k and sparc):

drivers/md/bcache/bset.c: In function ‘__btree_sort’:
drivers/md/bcache/bset.c:1190: warning: dereferencing ‘void *’ pointer
drivers/md/bcache/bset.c:1190: error: request for member ‘virtual’ in something not a structure or union

Convert them to static inline functions to fix this. There are already
plenty of  users of struct page members inside <linux/mm.h>, so there's no
reason to keep them as macros.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/10469287/ (m68k/next)
http://kisskb.ellerman.id.au/kisskb/buildresult/10469488/ (sparc64/next)
https://lkml.org/lkml/2014/1/13/1044 (m68k & sparc/3.10.27-stable)

 include/linux/mm.h |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 35527173cf50..9fac6dd69b11 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -846,11 +846,14 @@ static __always_inline void *lowmem_page_address(const struct page *page)
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
1.7.9.5

