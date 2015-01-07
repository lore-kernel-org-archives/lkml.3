Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718AbbAGDjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 22:39:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbbAGDjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 22:39:45 -0500
From: WANG Chao <chaowang@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org (maintainer:X86 ARCHITECTURE...),
        Andrew Morton <akpm@linux-foundation.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Pavel Machek <pavel@ucw.cz>, David Rientjes <rientjes@google.com>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        Xishi Qiu <qiuxishi@huawei.com>,
        linux-kernel@vger.kernel.org (open list:X86 ARCHITECTURE...)
Subject: [PATCH] x86, e820: clean up around sanitize_e820_map()
Date: Wed,  7 Jan 2015 11:37:38 +0800
Message-Id: <1420601859-18439-1-git-send-email-chaowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The argument 3 of sanitize_e820_map() will only update upon a successful
sanitization. Some of the callers may not be aware of this in the past.
Now clean up these callers.

Signed-off-by: WANG Chao <chaowang@redhat.com>
---
 arch/x86/kernel/e820.c | 22 ++++++----------------
 1 file changed, 6 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index dd2f07a..ae70de8 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -185,7 +185,7 @@ void __init e820_print_map(char *who)
  *
  * The integer pointed to by pnr_map must be valid on entry (the
  * current number of valid entries located at biosmap) and will
- * be updated on return, with the new number of valid entries
+ * only be updated on return 0, with the new number of valid entries
  * (something no more than max_nr_map.)
  *
  * The return value from sanitize_e820_map() is zero if it
@@ -561,23 +561,15 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 
 void __init update_e820(void)
 {
-	u32 nr_map;
-
-	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
+	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map))
 		return;
-	e820.nr_map = nr_map;
 	printk(KERN_INFO "e820: modified physical RAM map:\n");
 	e820_print_map("modified");
 }
 static void __init update_e820_saved(void)
 {
-	u32 nr_map;
-
-	nr_map = e820_saved.nr_map;
-	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
-		return;
-	e820_saved.nr_map = nr_map;
+	sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map),
+				&e820_saved.nr_map);
 }
 #define MAX_GAP_END 0x100000000ull
 /*
@@ -898,11 +890,9 @@ early_param("memmap", parse_memmap_opt);
 void __init finish_e820_parsing(void)
 {
 	if (userdef) {
-		u32 nr = e820.nr_map;
-
-		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
+		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map),
+					&e820.nr_map) < 0)
 			early_panic("Invalid user supplied memory map");
-		e820.nr_map = nr;
 
 		printk(KERN_INFO "e820: user-defined physical RAM map:\n");
 		e820_print_map("user");
-- 
2.1.0

