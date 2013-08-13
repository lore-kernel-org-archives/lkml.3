Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab3HMVrG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 17:47:06 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:18347 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904Ab3HMVrD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 17:47:03 -0400
From: Linn Crosetto <linn@hp.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        paulmck@linux.vnet.ibm.com, dhowells@redhat.com,
        mtk.manpages@gmail.com, yinghai@kernel.org, penberg@kernel.org,
        jacob.shin@amd.com
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [PATCH v3] x86: avoid remapping data in parse_setup_data()
Date: Tue, 13 Aug 2013 15:46:41 -0600
Message-Id: <1376430401-67445-1-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1376348482-1357-1-git-send-email-linn@hp.com>
References: <1376348482-1357-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Type SETUP_PCI, added by setup_efi_pci(), may advertise a ROM size
larger than early_memremap() is able to handle, which is currently
limited to 256kB. If this occurs it leads to a NULL dereference in
parse_setup_data().

To avoid this, remap the setup_data header and allow parsing functions
for individual types to handle their own data remapping.

Signed-off-by: Linn Crosetto <linn@hp.com>
---
v3: Remove data remapping code from parse_setup_data() and add it to
parse_e820_ext().

 arch/x86/include/asm/e820.h |  2 +-
 arch/x86/kernel/e820.c      |  5 ++++-
 arch/x86/kernel/setup.c     | 19 ++++++++-----------
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index cccd07f..779c2ef 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -29,7 +29,7 @@ extern void e820_setup_gap(void);
 extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 			unsigned long start_addr, unsigned long long end_addr);
 struct setup_data;
-extern void parse_e820_ext(struct setup_data *data);
+extern void parse_e820_ext(u64 phys_addr, u32 data_len);
 
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index d32abea..174da5f 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -658,15 +658,18 @@ __init void e820_setup_gap(void)
  * boot_params.e820_map, others are passed via SETUP_E820_EXT node of
  * linked list of struct setup_data, which is parsed here.
  */
-void __init parse_e820_ext(struct setup_data *sdata)
+void __init parse_e820_ext(u64 phys_addr, u32 data_len)
 {
 	int entries;
 	struct e820entry *extmap;
+	struct setup_data *sdata;
 
+	sdata = early_memremap(phys_addr, data_len);
 	entries = sdata->len / sizeof(struct e820entry);
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	early_iounmap(sdata, data_len);
 	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
 }
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..234e1e3 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -426,25 +426,23 @@ static void __init reserve_initrd(void)
 static void __init parse_setup_data(void)
 {
 	struct setup_data *data;
-	u64 pa_data;
+	u64 pa_data, pa_next;
 
 	pa_data = boot_params.hdr.setup_data;
 	while (pa_data) {
-		u32 data_len, map_len;
+		u32 data_len, map_len, data_type;
 
 		map_len = max(PAGE_SIZE - (pa_data & ~PAGE_MASK),
 			      (u64)sizeof(struct setup_data));
 		data = early_memremap(pa_data, map_len);
 		data_len = data->len + sizeof(struct setup_data);
-		if (data_len > map_len) {
-			early_iounmap(data, map_len);
-			data = early_memremap(pa_data, data_len);
-			map_len = data_len;
-		}
+		data_type = data->type;
+		pa_next = data->next;
+		early_iounmap(data, map_len);
 
-		switch (data->type) {
+		switch (data_type) {
 		case SETUP_E820_EXT:
-			parse_e820_ext(data);
+			parse_e820_ext(pa_data, data_len);
 			break;
 		case SETUP_DTB:
 			add_dtb(pa_data);
@@ -452,8 +450,7 @@ static void __init parse_setup_data(void)
 		default:
 			break;
 		}
-		pa_data = data->next;
-		early_iounmap(data, map_len);
+		pa_data = pa_next;
 	}
 }
 
-- 
1.7.11.3

