Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab3AXDeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:34:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44461 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755040Ab3AXDcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:32:00 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 69/74] x86/Sandy Bridge: reserve pages when integrated graphics is present
Date: Thu, 24 Jan 2013 01:27:21 -0200
Message-Id: <1358998046-613-70-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358998046-613-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

commit a9acc5365dbda29f7be2884efb63771dc24bd815 upstream.

SNB graphics devices have a bug that prevent them from accessing certain
memory ranges, namely anything below 1M and in the pages listed in the
table.  So reserve those at boot if set detect a SNB gfx device on the
CPU to avoid GPU hangs.

Stephane Marchesin had a similar patch to the page allocator awhile
back, but rather than reserving pages up front, it leaked them at
allocation time.

[ hpa: made a number of stylistic changes, marked arrays as static
  const, and made less verbose; use "memblock=debug" for full
  verbosity. ]

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 arch/x86/kernel/setup.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 78 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index e860517..a0ee620 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -613,6 +613,81 @@ static __init void reserve_ibft_region(void)
 
 static unsigned reserve_low = CONFIG_X86_RESERVE_LOW << 10;
 
+static bool __init snb_gfx_workaround_needed(void)
+{
+	int i;
+	u16 vendor, devid;
+	static const u16 snb_ids[] = {
+		0x0102,
+		0x0112,
+		0x0122,
+		0x0106,
+		0x0116,
+		0x0126,
+		0x010a,
+	};
+
+	/* Assume no if something weird is going on with PCI */
+	if (!early_pci_allowed())
+		return false;
+
+	vendor = read_pci_config_16(0, 2, 0, PCI_VENDOR_ID);
+	if (vendor != 0x8086)
+		return false;
+
+	devid = read_pci_config_16(0, 2, 0, PCI_DEVICE_ID);
+	for (i = 0; i < ARRAY_SIZE(snb_ids); i++)
+		if (devid == snb_ids[i])
+			return true;
+
+	return false;
+}
+
+/*
+ * Sandy Bridge graphics has trouble with certain ranges, exclude
+ * them from allocation.
+ */
+static void __init trim_snb_memory(void)
+{
+	static const unsigned long bad_pages[] = {
+		0x20050000,
+		0x20110000,
+		0x20130000,
+		0x20138000,
+		0x40004000,
+	};
+	int i;
+
+	if (!snb_gfx_workaround_needed())
+		return;
+
+	printk(KERN_DEBUG "reserving inaccessible SNB gfx pages\n");
+
+	/*
+	 * Reserve all memory below the 1 MB mark that has not
+	 * already been reserved.
+	 */
+	memblock_reserve(0, 1<<20);
+	
+	for (i = 0; i < ARRAY_SIZE(bad_pages); i++) {
+		if (memblock_reserve(bad_pages[i], PAGE_SIZE))
+			printk(KERN_WARNING "failed to reserve 0x%08lx\n",
+			       bad_pages[i]);
+	}
+}
+
+/*
+ * Here we put platform-specific memory range workarounds, i.e.
+ * memory known to be corrupt or otherwise in need to be reserved on
+ * specific platforms.
+ *
+ * If this gets used more widely it could use a real dispatch mechanism.
+ */
+static void __init trim_platform_memory_ranges(void)
+{
+	trim_snb_memory();
+}
+
 static void __init trim_bios_range(void)
 {
 	/*
@@ -633,6 +708,7 @@ static void __init trim_bios_range(void)
 	 * take them out.
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
+
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
 
@@ -911,6 +987,8 @@ void __init setup_arch(char **cmdline_p)
 
 	setup_real_mode();
 
+	trim_platform_memory_ranges();
+
 	init_gbpages();
 
 	/* max_pfn_mapped is updated here */
-- 
1.7.9.5

