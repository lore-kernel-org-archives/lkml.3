Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363Ab3AVPVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 10:21:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab3AVPUw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 10:20:52 -0500
From: Thomas Renninger <trenn@suse.de>
To: hpa@zytor.com
Cc: yinghai@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au,
        Thomas Renninger <trenn@suse.de>
Subject: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump usage
Date: Tue, 22 Jan 2013 16:20:49 +0100
Message-Id: <1358868049-19884-3-git-send-email-trenn@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1358868049-19884-1-git-send-email-trenn@suse.de>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@kernel.org>

kdump voided the whole original e820 map and half way made
it up via memmap= options passed via kdump boot params again.

But this is conceptionally wrong. The whole original memory ranges
which are declared reserved, ACPI data/nvs or however are not usable
must stay the same and get honored by the kdump kernel.

Therefore memmap=resetusablemap gets introduced.
kdump passes this one and only the usable e820 ranges are removed.
kdump passes the usable ranges to use via memmap=x@y parameter(s).
The not usable e820 ranges are preserved.

This for example fixes mmconf (extended PCI config access) and
possibly other kernel parts which rely on remapped memory to be
in reserved or ACPI (data/nvs) declared e820 memory areas.

Tested-by: Thomas Renninger <trenn@suse.de>
Reviewed-by: Thomas Renninger <trenn@suse.de>
Signed-off-by: Thomas Renninger <trenn@suse.de>
---
 Documentation/kernel-parameters.txt |    9 +++++++++
 arch/x86/kernel/e820.c              |   13 +++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 9776f06..fe2f677 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1498,6 +1498,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			BIOS output or other requirements. See the memmap=nn@ss
 			option description.
 
+	memmap=resetusablemap
+			[KNL,X86] Similar to exactmap, but instead of discarding
+			the whole original e820 map, only the usable memory
+			areas are ignored.
+			Those must be passed via memmap=X@Y parameters,
+			reserved, ACPI and ACPI NVS areas are preserved.
+			This boot parameter is intended for kdump usage.
+			Also passing exactmap overrules resetusablemap.
+
 	memmap=nn[KMG]@ss[KMG]
 			[KNL] Force usage of a specific region of memory
 			Region of memory to be used, from ss to ss+nn.
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index dc0b9f0..4e0ef9d 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -845,7 +845,7 @@ static int __init parse_memmap_one(char *p)
 	if (!p)
 		return -EINVAL;
 
-	if (!strncmp(p, "exactmap", 8)) {
+	if (!strncmp(p, "exactmap", 8) || !strncmp(p, "resetusablemap", 14)) {
 		if (exactmap_parsed)
 			return 0;
 
@@ -858,7 +858,11 @@ static int __init parse_memmap_one(char *p)
 		 */
 		saved_max_pfn = e820_end_of_ram_pfn();
 #endif
-		e820.nr_map = 0;
+		if (!strncmp(p, "resetusablemap", 14)) {
+			/* remove all old E820_RAM ranges */
+			e820_remove_range(0, ULLONG_MAX, E820_RAM, 1);
+		} else
+			e820.nr_map = 0;
 		userdef = 1;
 		return 0;
 	}
@@ -890,6 +894,11 @@ static int __init parse_memmap_opt(char *str)
 	p = strstr(p, "exactmap");
 	if (p)
 		parse_memmap_one("exactmap");
+	else {
+		p = strstr(boot_command_line, "resetusablemap");
+		if (p)
+			parse_memmap_one("resetusablemap");
+	}
 
 	while (str) {
 		char *k = strchr(str, ',');
-- 
1.7.6.1

