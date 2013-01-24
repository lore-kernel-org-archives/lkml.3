Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756369Ab3AXUWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:22:32 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:50030 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030229Ab3AXUVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:21:22 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/35] x86, mm: Introduce memmap=reserveram
Date: Thu, 24 Jan 2013 12:19:44 -0800
Message-Id: <1359058816-7615-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kdump voided the whole original e820 map with exactmap and half way
made it up via memmap= options passed via kdump boot params again.

But this is conceptionally wrong. The whole original memory ranges
which are declared reserved, ACPI data/nvs or however are not usable
must stay the same and get honored by the kdump kernel.

Therefore memmap=reserveram gets introduced.
kdump passes this one and only the usable e820 ranges are updated to
reserved at first by kernel, then when kdump passes the usable ranges
to use via memmap=x@y parameter(s), kernel will remove reserved range
and add usable range accordingly.

This for example fixes mmconf (extended PCI config access) and
possibly other kernel parts which rely on remapped memory to be
in reserved or ACPI (data/nvs) declared e820 memory areas.

Changelog is from Thomas Renninger, and updated to reserveram

-v2: According to HPA, use reserveram instead of resetusablemap.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/e820.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index dc0b9f0..503859c 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -836,6 +836,7 @@ static int __init parse_memopt(char *p)
 early_param("mem", parse_memopt);
 
 static bool __initdata exactmap_parsed;
+static bool __initdata reserveram_parsed;
 
 static int __init parse_memmap_one(char *p)
 {
@@ -845,7 +846,7 @@ static int __init parse_memmap_one(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strncmp(p, "exactmap", 8)) {
+	if (!strncmp(p, "exactmap", 8) || !strncmp(p, "reserveram", 10)) {
 		if (exactmap_parsed)
 			return 0;
 
@@ -858,7 +859,12 @@ static int __init parse_memmap_one(char *p)
 		 */
 		saved_max_pfn = e820_end_of_ram_pfn();
 #endif
-		e820.nr_map = 0;
+		if (!strncmp(p, "reserveram", 10)) {
+			e820_update_range(0, ULLONG_MAX, E820_RAM,
+					  E820_RESERVED);
+			reserveram_parsed = true;
+		} else
+			e820.nr_map = 0;
 		userdef = 1;
 		return 0;
 	}
@@ -871,6 +877,10 @@ static int __init parse_memmap_one(char *p)
 	userdef = 1;
 	if (*p == '@') {
 		start_at = memparse(p+1, &p);
+		if (reserveram_parsed) {
+			/* Remove old reserved so new ram could take over. */
+			e820_remove_range(start_at, mem_size, E820_RESERVED, 0);
+		}
 		e820_add_region(start_at, mem_size, E820_RAM);
 	} else if (*p == '#') {
 		start_at = memparse(p+1, &p);
@@ -890,6 +900,11 @@ static int __init parse_memmap_opt(char *str)
 	p = strstr(p, "exactmap");
 	if (p)
 		parse_memmap_one("exactmap");
+	else {
+		p = strstr(boot_command_line, "reserveram");
+		if (p)
+			parse_memmap_one("reserveram");
+	}
 
 	while (str) {
 		char *k = strchr(str, ',');
-- 
1.7.10.4

