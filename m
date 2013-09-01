Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3IALlB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 07:41:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab3IALk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 07:40:59 -0400
Date: Sun, 1 Sep 2013 04:40:31 -0700
From: tip-bot for Linn Crosetto <tipbot@zytor.com>
Message-ID: <tip-30e46b574a1db7d14404e52dca8e1aa5f5155fd2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, penberg@kernel.org, linn@hp.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, penberg@kernel.org, linn@hp.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1376430401-67445-1-git-send-email-linn@hp.com>
References: <1376430401-67445-1-git-send-email-linn@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: avoid remapping data in parse_setup_data()
Git-Commit-ID: 30e46b574a1db7d14404e52dca8e1aa5f5155fd2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sun, 01 Sep 2013 04:40:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30e46b574a1db7d14404e52dca8e1aa5f5155fd2
Gitweb:     http://git.kernel.org/tip/30e46b574a1db7d14404e52dca8e1aa5f5155fd2
Author:     Linn Crosetto <linn@hp.com>
AuthorDate: Tue, 13 Aug 2013 15:46:41 -0600
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 13 Aug 2013 23:29:19 -0700

x86: avoid remapping data in parse_setup_data()

Type SETUP_PCI, added by setup_efi_pci(), may advertise a ROM size
larger than early_memremap() is able to handle, which is currently
limited to 256kB. If this occurs it leads to a NULL dereference in
parse_setup_data().

To avoid this, remap the setup_data header and allow parsing functions
for individual types to handle their own data remapping.

Signed-off-by: Linn Crosetto <linn@hp.com>
Link: http://lkml.kernel.org/r/1376430401-67445-1-git-send-email-linn@hp.com
Acked-by: Yinghai Lu <yinghai@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
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
index de33798..b6b45e4 100644
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
 
