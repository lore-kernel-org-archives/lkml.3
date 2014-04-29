Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818AbaD2R3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 13:29:44 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:28478 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932529AbaD2R3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 13:29:43 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIWAD3gX1NbsnvL/2dsb2JhbABZgwZPq0wFAQEBBAGZcwICgSQXdIJTExwjGIECJBOIRQHJPYVViHqEQAEDjwCKDwGKd4drgzM7
Date: Tue, 29 Apr 2014 19:31:46 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>, Joe Perches <joe@perches.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 2/2] mm/slub.c: convert vnsprintf-static to va_format
Message-Id: <20140429193146.34df9d8cfb14e436f9020eae@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inspired by Joe Perches suggestion in ntfs logging clean-up.

Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/slub.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 66ee34f..4991c44 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -581,28 +581,30 @@ static void print_page_info(struct page *page)
 
 static void slab_bug(struct kmem_cache *s, char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char buf[100];
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
-	va_end(args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 	pr_err("=============================================================================\n");
-	pr_err("BUG %s (%s): %s\n", s->name, print_tainted(), buf);
+	pr_err("BUG %s (%s): %pV\n", s->name, print_tainted(), &vaf);
 	pr_err("-----------------------------------------------------------------------------\n\n");
 
 	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
+	va_end(args);
 }
 
 static void slab_fix(struct kmem_cache *s, char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
-	char buf[100];
 
 	va_start(args, fmt);
-	vsnprintf(buf, sizeof(buf), fmt, args);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+	pr_err("FIX %s: %pV\n", s->name, &vaf);
 	va_end(args);
-	pr_err("FIX %s: %s\n", s->name, buf);
 }
 
 static void print_trailer(struct kmem_cache *s, struct page *page, u8 *p)
-- 
1.8.4.5

