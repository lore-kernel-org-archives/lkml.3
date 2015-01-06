Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbbAFVGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:06:24 -0500
Received: from g4t3427.houston.hp.com ([15.201.208.55]:46991 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756429AbbAFVGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:06:16 -0500
From: Toshi Kani <toshi.kani@hp.com>
To: hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com,
        akpm@linux-foundation.org, arnd@arndb.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgross@suse.com,
        stefan.bader@canonical.com, luto@amacapital.net, hmh@hmh.eng.br,
        yigal@plexistor.com, konrad.wilk@oracle.com, Elliott@hp.com,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH v7 2/7] x86, mm, pat: Change reserve_memtype() to handle WT
Date: Tue,  6 Jan 2015 13:49:47 -0700
Message-Id: <1420577392-21235-3-git-send-email-toshi.kani@hp.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1420577392-21235-1-git-send-email-toshi.kani@hp.com>
References: <1420577392-21235-1-git-send-email-toshi.kani@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes reserve_memtype() to handle the WT cache mode
with PAT.  When PAT is not enabled, WB and UC- are the only types
supported.

When a target range is in RAM, reserve_ram_pages_type() verifies
the requested type.  In this case, WT and WP requests fail with
-EINVAL and UC gets redirected to UC- since set_page_memtype() is
limited to handle three types, WB, WC and UC-.

Signed-off-by: Toshi Kani <toshi.kani@hp.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/mm/pat.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 3d9da74..99d2eb0 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -360,6 +360,8 @@ static int pat_pagerange_is_ram(resource_size_t start, resource_size_t end)
 
 /*
  * For RAM pages, we use page flags to mark the pages with appropriate type.
+ * The page flags are limited to three types, WB, WC and UC-.
+ * WT and WP requests fail with -EINVAL, and UC gets redirected to UC-.
  * Here we do two pass:
  * - Find the memtype of all the pages in the range, look for any conflicts
  * - In case of no conflicts, set the new memtype for pages in the range
@@ -371,6 +373,13 @@ static int reserve_ram_pages_type(u64 start, u64 end,
 	struct page *page;
 	u64 pfn;
 
+	if ((req_type == _PAGE_CACHE_MODE_WT) ||
+	    (req_type == _PAGE_CACHE_MODE_WP)) {
+		if (new_type)
+			*new_type = _PAGE_CACHE_MODE_UC_MINUS;
+		return -EINVAL;
+	}
+
 	if (req_type == _PAGE_CACHE_MODE_UC) {
 		/* We do not support strong UC */
 		WARN_ON_ONCE(1);
@@ -420,6 +429,7 @@ static int free_ram_pages_type(u64 start, u64 end)
  * - _PAGE_CACHE_MODE_WC
  * - _PAGE_CACHE_MODE_UC_MINUS
  * - _PAGE_CACHE_MODE_UC
+ * - _PAGE_CACHE_MODE_WT
  *
  * If new_type is NULL, function will return an error if it cannot reserve the
  * region with req_type. If new_type is non-NULL, function will return
@@ -437,12 +447,12 @@ int reserve_memtype(u64 start, u64 end, enum page_cache_mode req_type,
 	BUG_ON(start >= end); /* end is exclusive */
 
 	if (!pat_enabled) {
-		/* This is identical to page table setting without PAT */
+		/* WB and UC- are the only types supported without PAT */
 		if (new_type) {
-			if (req_type == _PAGE_CACHE_MODE_WC)
-				*new_type = _PAGE_CACHE_MODE_UC_MINUS;
+			if (req_type == _PAGE_CACHE_MODE_WB)
+				*new_type = _PAGE_CACHE_MODE_WB;
 			else
-				*new_type = req_type;
+				*new_type = _PAGE_CACHE_MODE_UC_MINUS;
 		}
 		return 0;
 	}
