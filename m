Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab3IYSQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 14:16:21 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50595 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3IYSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 14:16:20 -0400
Date: Wed, 25 Sep 2013 20:16:16 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20130925181616.GA16925@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   HEAD: 7a20c2fad61aa3624e83c671d36dbd36b2661476 x86/reboot: Fix apparent cut-n-paste mistake in Dell reboot workaround

An EFI fix and two reboot-quirk fixes.

 Thanks,

	Ingo

------------------>
Dave Jones (1):
      x86/reboot: Fix apparent cut-n-paste mistake in Dell reboot workaround

Josh Boyer (1):
      x86, efi: Don't map Boot Services on i386

Masoud Sharbiani (1):
      x86/reboot: Add quirk to make Dell C6100 use reboot=pci automatically


 arch/x86/kernel/reboot.c    | 18 +++++++++++++++++-
 arch/x86/platform/efi/efi.c | 11 +++++++----
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 563ed91..e643e74 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -352,12 +352,28 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 	},
 	{	/* Handle problems with rebooting on the Precision M6600. */
 		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+		.ident = "Dell Precision M6600",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "Precision M6600"),
 		},
 	},
+	{	/* Handle problems with rebooting on the Dell PowerEdge C6100. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
+	{	/* Some C6100 machines were shipped with vendor being 'Dell'. */
+		.callback = set_pci_reboot,
+		.ident = "Dell PowerEdge C6100",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "C6100"),
+		},
+	},
 	{ }
 };
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 90f6ed1..c7e22ab 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -912,10 +912,13 @@ void __init efi_enter_virtual_mode(void)
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
-		if (!(md->attribute & EFI_MEMORY_RUNTIME) &&
-		    md->type != EFI_BOOT_SERVICES_CODE &&
-		    md->type != EFI_BOOT_SERVICES_DATA)
-			continue;
+		if (!(md->attribute & EFI_MEMORY_RUNTIME)) {
+#ifdef CONFIG_X86_64
+			if (md->type != EFI_BOOT_SERVICES_CODE &&
+			    md->type != EFI_BOOT_SERVICES_DATA)
+#endif
+				continue;
+		}
 
 		size = md->num_pages << EFI_PAGE_SHIFT;
 		end = md->phys_addr + size;
