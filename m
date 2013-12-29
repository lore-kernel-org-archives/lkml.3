Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab3L2Bp0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 20:45:26 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39600 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3L2BpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 20:45:24 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill@shutemov.name,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [RFC 2/2] mm: additional checks to page flag set/clear
Date: Sat, 28 Dec 2013 20:45:04 -0500
Message-Id: <1388281504-11453-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388281504-11453-1-git-send-email-sasha.levin@oracle.com>
References: <1388281504-11453-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check if the flag is already set before setting it, and vice versa
for clearing.

Obviously setting or clearing a flag twice isn't a problem on it's
own, but it implies that there's an issue where some piece of code
assumed an opposite state of the flag.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 include/linux/page-flags.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index d1fe1a7..36b0bef 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -130,6 +130,12 @@ enum pageflags {
 
 #ifndef __GENERATING_BOUNDS_H
 
+#ifdef CONFIG_DEBUG_VM_PAGE_FLAGS
+#define VM_ASSERT_FLAG(assert, page) VM_BUG_ON_PAGE(assert, page)
+#else
+#define VM_ASSERT_FLAG(assert, page) do { } while (0)
+#endif
+
 /*
  * Macros to create function definitions for page flags
  */
@@ -139,11 +145,13 @@ static inline int Page##uname(const struct page *page)			\
 
 #define SETPAGEFLAG(uname, lname)					\
 static inline void SetPage##uname(struct page *page)			\
-			{ set_bit(PG_##lname, &page->flags); }
+			{ VM_ASSERT_FLAG(Page##uname(page), page);	\
+			set_bit(PG_##lname, &page->flags); }
 
 #define CLEARPAGEFLAG(uname, lname)					\
 static inline void ClearPage##uname(struct page *page)			\
-			{ clear_bit(PG_##lname, &page->flags); }
+			{ VM_ASSERT_FLAG(!Page##uname(page), page);	\
+			clear_bit(PG_##lname, &page->flags); }
 
 #define __SETPAGEFLAG(uname, lname)					\
 static inline void __SetPage##uname(struct page *page)			\
-- 
1.8.3.2

