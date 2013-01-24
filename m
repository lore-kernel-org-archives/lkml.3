Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411Ab3AXUWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:22:21 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:49928 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030217Ab3AXUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:21:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 04/35] x86: Clean up e820 add kernel range
Date: Thu, 24 Jan 2013 12:19:45 -0800
Message-Id: <1359058816-7615-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate it out to another function instead.

Also add support for case when memmap=xxM$yyM is used without exactmap.
Need to remove reserved range at first before we add E820_RAM
range, otherwise added E820_RAM range will be ignored.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Jacob Shin <jacob.shin@amd.com>
---
 arch/x86/kernel/setup.c |   36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index b23362f..2242356 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -702,6 +702,27 @@ static void __init trim_bios_range(void)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
+/* called before trim_bios_range() to spare extra sanitize */
+static void __init e820_add_kernel_range(void)
+{
+	u64 start = __pa_symbol(_text);
+	u64 size = __pa_symbol(_end) - start;
+
+	/*
+	 * Complain if .text .data and .bss are not marked as E820_RAM and
+	 * attempt to fix it by adding the range. We may have a confused BIOS,
+	 * or the user may have used memmap=exactmap or memmap=xxM$yyM to
+	 * exclude kernel range. If we really are running on top non-RAM,
+	 * we will crash later anyways.
+	 */
+	if (e820_all_mapped(start, start + size, E820_RAM))
+		return;
+
+	pr_warn(".text .data .bss are not marked as E820_RAM!\n");
+	e820_remove_range(start, size, E820_RAM, 0);
+	e820_add_region(start, size, E820_RAM);
+}
+
 static int __init parse_reservelow(char *p)
 {
 	unsigned long long size;
@@ -897,20 +918,7 @@ void __init setup_arch(char **cmdline_p)
 	insert_resource(&iomem_resource, &data_resource);
 	insert_resource(&iomem_resource, &bss_resource);
 
-	/*
-	 * Complain if .text .data and .bss are not marked as E820_RAM and
-	 * attempt to fix it by adding the range. We may have a confused BIOS,
-	 * or the user may have incorrectly supplied it via memmap=exactmap. If
-	 * we really are running on top non-RAM, we will crash later anyways.
-	 */
-	if (!e820_all_mapped(code_resource.start, __pa(__brk_limit), E820_RAM)) {
-		pr_warn(".text .data .bss are not marked as E820_RAM!\n");
-
-		e820_add_region(code_resource.start,
-				__pa(__brk_limit) - code_resource.start + 1,
-				E820_RAM);
-	}
-
+	e820_add_kernel_range();
 	trim_bios_range();
 #ifdef CONFIG_X86_32
 	if (ppro_with_ram_bug()) {
-- 
1.7.10.4

