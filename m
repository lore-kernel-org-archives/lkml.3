Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbaJNCar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 22:30:47 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:63345 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754626AbaJNCaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 22:30:46 -0400
From: Martin Kelly <martin@martingkelly.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        x86@kernel.org
Cc: david.vrabel@citrix.com, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, Martin Kelly <martin@martingkelly.com>,
        Martin Kelly <martkell@amazon.com>
Subject: [PATCH 1/2] x86: separate out sanitize_e820_map return codes
Date: Mon, 13 Oct 2014 19:30:16 -0700
Message-Id: <1413253817-6943-1-git-send-email-martin@martingkelly.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously, sanitize_e820_map returned -1 in all cases in which it did
nothing. However, sanitize_e820_map can do nothing either because the
input map has size 1 (this is ok) or because the input map passed in is
invalid (likely an issue). It is nice for the caller to be able to
distinguish the two cases and treat them separately.

Signed-off-by: Martin Kelly <martkell@amazon.com>
---
 arch/x86/include/asm/e820.h |  5 +++++
 arch/x86/kernel/e820.c      | 18 +++++++++++-------
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 779c2ef..96377df 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -12,6 +12,11 @@
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
 extern struct e820map e820_saved;
+/* sanitize_e820_map return codes */
+#define E820_RC_ONLY_ONE (-1)  /* return code when there's only one memory
+				  region in the map */
+#define E820_RC_BAD_MAP (-2)   /* return code when passed a map containing an
+				  invalid memory region */
 
 extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 49f8864..3e1fd63 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -189,11 +189,15 @@ void __init e820_print_map(char *who)
  * (something no more than max_nr_map.)
  *
  * The return value from sanitize_e820_map() is zero if it
- * successfully 'sanitized' the map entries passed in, and is -1
- * if it did nothing, which can happen if either of (1) it was
- * only passed one map entry, or (2) any of the input map entries
- * were invalid (start + size < start, meaning that the size was
- * so big the described memory range wrapped around through zero.)
+ * successfully 'sanitized' the map entries passed in and negative if it did
+ * nothing. There are two cases in which sanitize_e820_map() does nothing:
+ * (1) it was passed only one map entry, so nothing needs to be done. In this
+ *     case, it returns E820_RC_ONLY_ONE.
+ * (2) any of the input map entries * were invalid (start + size < start)
+ *     meaning that the size was so big the described memory range wrapped
+ *     around through zero. In this case, it returns E820_RC_BAD_MAP.
+ * Since (1) is sometimes an expected case and (2) indicates an error, the
+ * distinct return codes allow callers to handle the two cases separately.
  *
  *	Visually we're performing the following
  *	(1,2,3,4 = memory types)...
@@ -269,7 +273,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 
 	/* if there's only one memory region, don't bother */
 	if (*pnr_map < 2)
-		return -1;
+		return E820_RC_ONLY_ONE;
 
 	old_nr = *pnr_map;
 	BUG_ON(old_nr > max_nr_map);
@@ -277,7 +281,7 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 	/* bail out if we find any unreasonable addresses in bios map */
 	for (i = 0; i < old_nr; i++)
 		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr)
-			return -1;
+			return E820_RC_BAD_MAP;
 
 	/* create pointers for initial change-point information (for sorting) */
 	for (i = 0; i < 2 * old_nr; i++)
-- 
2.1.1

