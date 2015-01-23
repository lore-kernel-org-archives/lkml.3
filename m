Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbbAWPTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 10:19:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40107 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbbAWPTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 10:19:35 -0500
Date: Fri, 23 Jan 2015 07:18:53 -0800
From: tip-bot for WANG Chao <tipbot@zytor.com>
Message-ID: <tip-d574ffa1066003569ed5cdaeabf44597564ce975@git.kernel.org>
Cc: tglx@linutronix.de, qiuxishi@huawei.com, rientjes@google.com,
        linux-kernel@vger.kernel.org, chaowang@redhat.com, pavel@ucw.cz,
        joeyli.kernel@gmail.com, mingo@kernel.org, hpa@zytor.com,
        grygorii.strashko@ti.com
Reply-To: hpa@zytor.com, grygorii.strashko@ti.com, mingo@kernel.org,
        pavel@ucw.cz, joeyli.kernel@gmail.com, linux-kernel@vger.kernel.org,
        rientjes@google.com, chaowang@redhat.com, tglx@linutronix.de,
        qiuxishi@huawei.com
In-Reply-To: <1420601859-18439-1-git-send-email-chaowang@redhat.com>
References: <1420601859-18439-1-git-send-email-chaowang@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, e820: Clean up sanitize_e820_map() users
Git-Commit-ID: d574ffa1066003569ed5cdaeabf44597564ce975
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d574ffa1066003569ed5cdaeabf44597564ce975
Gitweb:     http://git.kernel.org/tip/d574ffa1066003569ed5cdaeabf44597564ce975
Author:     WANG Chao <chaowang@redhat.com>
AuthorDate: Wed, 7 Jan 2015 11:37:38 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 23 Jan 2015 16:14:27 +0100

x86, e820: Clean up sanitize_e820_map() users

The argument 3 of sanitize_e820_map() will only be updated upon a
successful sanitization. Some of the callers have extra conditionals
for the same purpose. Clean them up.

default_machine_specific_memory_setup() must keep the extra
conditional because boot_params.e820_entries is an u8 and not an u32,
so the direct update would overwrite other fields in boot_params.

[ tglx: Massaged changelog ]

Signed-off-by: WANG Chao <chaowang@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Cc: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Lee Chun-Yi <joeyli.kernel@gmail.com>
Cc: Xishi Qiu <qiuxishi@huawei.com>
Link: http://lkml.kernel.org/r/1420601859-18439-1-git-send-email-chaowang@redhat.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/e820.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index dd2f07a..46201de 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -184,9 +184,9 @@ void __init e820_print_map(char *who)
  * overwritten in the same location, starting at biosmap.
  *
  * The integer pointed to by pnr_map must be valid on entry (the
- * current number of valid entries located at biosmap) and will
- * be updated on return, with the new number of valid entries
- * (something no more than max_nr_map.)
+ * current number of valid entries located at biosmap). If the
+ * sanitizing succeeds the *pnr_map will be updated with the new
+ * number of valid entries (something no more than max_nr_map).
  *
  * The return value from sanitize_e820_map() is zero if it
  * successfully 'sanitized' the map entries passed in, and is -1
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
