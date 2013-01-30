Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013Ab3A3BVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:21:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43601 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3BVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:21:32 -0500
Date: Tue, 29 Jan 2013 17:21:17 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-b422a3091748c38b68052e8ba021652590b1f25c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, jacob.shin@amd.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-5-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-5-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86: Factor out e820_add_kernel_range()
Git-Commit-ID: b422a3091748c38b68052e8ba021652590b1f25c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:21:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b422a3091748c38b68052e8ba021652590b1f25c
Gitweb:     http://git.kernel.org/tip/b422a3091748c38b68052e8ba021652590b1f25c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:45 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:12:24 -0800

x86: Factor out e820_add_kernel_range()

Separate out the reservation of the kernel static memory areas into a
separate function.

Also add support for case when memmap=xxM$yyM is used without exactmap.
Need to remove reserved range at first before we add E820_RAM
range, otherwise added E820_RAM range will be ignored.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-5-git-send-email-yinghai@kernel.org
Cc: Jacob Shin <jacob.shin@amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/setup.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 2681937..5552d04 100644
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
