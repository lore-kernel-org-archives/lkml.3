Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbaHYKev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 06:34:51 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63184 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbaHYKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 06:34:50 -0400
Date: Mon, 25 Aug 2014 11:34:47 +0100
From: Matt Fleming <matt@console-pimps.org>
To: harald@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] efi_high_alloc: use EFI_ALLOCATE_MAX_ADDRESS
Message-ID: <20140825103447.GP29733@console-pimps.org>
References: <1408715303-2215-1-git-send-email-harald@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408715303-2215-1-git-send-email-harald@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Adding linux-efi to Cc)

On Fri, 22 Aug, at 03:48:23PM, harald@redhat.com wrote:
> From: Harald Hoyer <harald@redhat.com>
> 
> On my Lenovo T420s with 4GB memory, efi_high_alloc() was checking the
> following memory regions:
> 
> 0x0000000000100000 - 0x0000000020000000
> 0x0000000020200000 - 0x0000000040000000
> 0x0000000040200000 - 0x00000000d2c02000
> 0x00000000d6e9f000 - 0x000000011e600000
> 
> and decided to allocate 2649 pages at address 0x11dba7000.
> As I understand this is the physical address and this machine only
> has 4GB mem!!
 
Yeah, but RAM doesn't necessarily start at the physical address
0x000000000000. Nor is it necessarily contiguous.

In other words, it's perfectly legitimate to allocate at physical
addresses above 0x10000000 if the above memory map tells us RAM lives
there.

> Nevertheless, unpacking of the initramfs later on failed.
> This was mainly caused by commit 4bf7111f50167133a71c23530ca852a41355e739,
> which enables loading the initramfs above 4G addresses.
> 
> With this patch efi_high_alloc() now uses EFI_ALLOCATE_MAX_ADDRESS.
> This returns 0x00000000d2c02000 on my machine and the resulting
> address at which the initramfs is loaded is then 0x00000000d21a9000,
> which seems to work fine.

Well yeah, that makes sense because you've obviously got a buggy EFI
firmware that doesn't load things correctly above 4GB. It turns out that
this is a common bug.

Can you try the following patch and see whether booting with
efi=nochunk results in a functioning initramfs? I've had some success
with disabling the chunking workaround when reading files in the EFI
boot stub. Also, including a copy of a dmesg would be helpful.

---

>From 1c24a2bef39f041eb578189207240d0457ef0ac3 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Tue, 5 Aug 2014 11:52:11 +0100
Subject: [PATCH] efi: Add efi= parameter parsing to the EFI boot stub

We need a way to customize the behaviour of the EFI boot stub, in
particular, we need a way to disable the "chunking" workaround, used
when reading files from the EFI System Partition.

One of my machines doesn't cope well when reading files in 1MB chunks to
a buffer above the 4GB mark - it appears that the "chunking" bug
workaround triggers another firmware bug. This was only discovered with
commit 4bf7111f5016 ("x86/efi: Support initrd loaded above 4G"), and
that commit is perfectly valid. The symptom I observed was a corrupt
initrd rather than any kind of crash.

efi= is now used to specify EFI parameters in two very different
execution environments, the EFI boot stub and during kernel boot.

There is also a slight performance optimization by enabling efi=nochunk,
but that's offset by the fact that you're more likely to run into
firmware issues, at least on x86. This is the rationale behind leaving
the workaround enabled by default.

Also provide some documentation for EFI_READ_CHUNK_SIZE and why we're
using the current value of 1MB.

Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Roy Franz <roy.franz@linaro.org>
Cc: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>
Cc: Borislav Petkov <bp@suse.de>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 Documentation/kernel-parameters.txt            |  5 ++-
 arch/x86/boot/compressed/eboot.c               |  4 ++
 arch/x86/platform/efi/efi.c                    | 19 +++++++-
 drivers/firmware/efi/libstub/arm-stub.c        |  4 ++
 drivers/firmware/efi/libstub/efi-stub-helper.c | 62 +++++++++++++++++++++++++-
 include/linux/efi.h                            |  2 +
 6 files changed, 91 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 6eaa9cdb7094..7c5fc8ec9be8 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -981,10 +981,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: {"off" | "on" | "skip[mbr]"}
 
 	efi=		[EFI]
-			Format: { "old_map" }
+			Format: { "old_map", "nochunk" }
 			old_map [X86-64]: switch to the old ioremap-based EFI
 			runtime services mapping. 32-bit still uses this one by
 			default.
+			nochunk: disable reading files in "chunks" in the EFI
+			boot stub, as chunking can cause problems with some
+			firmware implementations.
 
 	efi_no_storage_paranoia [EFI; X86]
 			Using this parameter you can use more than 50% of
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f277184e2ac1..f4bdab1dbf66 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1100,6 +1100,10 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	else
 		initrd_addr_max = hdr->initrd_addr_max;
 
+	status = efi_parse_options(cmdline_ptr);
+	if (status != EFI_SUCCESS)
+		goto fail2;
+
 	status = handle_cmdline_files(sys_table, image,
 				      (char *)(unsigned long)hdr->cmd_line_ptr,
 				      "initrd=", initrd_addr_max,
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 850da94fef30..a1f745b0bf1d 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -943,8 +943,23 @@ static int __init parse_efi_cmdline(char *str)
 	if (*str == '=')
 		str++;
 
-	if (!strncmp(str, "old_map", 7))
-		set_bit(EFI_OLD_MEMMAP, &efi.flags);
+	while (*str) {
+		if (!strncmp(str, "old_map", 7)) {
+			set_bit(EFI_OLD_MEMMAP, &efi.flags);
+			str += strlen("old_map");
+		}
+
+		/*
+		 * Skip any options we don't understand. Presumably
+		 * they apply to the EFI boot stub.
+		 */
+		while (*str && *str != ',')
+			str++;
+
+		/* If we hit a delimiter, skip it */
+		if (*str == ',')
+			str++;
+	}
 
 	return 0;
 }
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 480339b6b110..75ee05964cbc 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -226,6 +226,10 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_image;
 	}
 
+	status = efi_parse_options(cmdline_ptr);
+	if (status != EFI_SUCCESS)
+		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
+
 	/*
 	 * Unauthenticated device tree data is a security hazard, so
 	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 32d5cca30f49..a920fec8fe88 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -15,8 +15,23 @@
 
 #include "efistub.h"
 
+/*
+ * Some firmware implementations have problems reading files in one go.
+ * A read chunk size of 1MB seems to work for most platforms.
+ *
+ * Unfortunately, reading files in chunks triggers *other* bugs on some
+ * platforms, so we provide a way to disable this workaround, which can
+ * be done by passing "efi=nochunk" on the EFI boot stub command line.
+ *
+ * If you experience issues with initrd images being corrupt it's worth
+ * trying efi=nochunk, but chunking is enabled by default because there
+ * are far more machines that require the workaround than those that
+ * break with it enabled.
+ */
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
+static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -281,6 +296,49 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 	efi_call_early(free_pages, addr, nr_pages);
 }
 
+/*
+ * Parse the ASCII string 'cmdline' for EFI options, denoted by the efi=
+ * option, e.g. efi=nochunk.
+ *
+ * It should be noted that efi= is parsed in two very different
+ * environments, first in the early boot environment of the EFI boot
+ * stub, and subsequently during the kernel boot.
+ */
+efi_status_t efi_parse_options(char *cmdline)
+{
+	char *str;
+
+	/*
+	 * If no EFI parameters were specified on the cmdline we've got
+	 * nothing to do.
+	 */
+	str = strstr(cmdline, "efi=");
+	if (!str)
+		return EFI_SUCCESS;
+
+	/* Skip ahead to first argument */
+	str += strlen("efi=");
+
+	/*
+	 * Remember, because efi= is also used by the kernel we need to
+	 * skip over arguments we don't understand.
+	 */
+	while (*str) {
+		if (!strncmp(str, "nochunk", 7)) {
+			str += strlen("nochunk");
+			__chunk_size = -1UL;
+		}
+
+		/* Group words together, delimited by "," */
+		while (*str && *str != ',')
+			str++;
+
+		if (*str == ',')
+			str++;
+	}
+
+	return EFI_SUCCESS;
+}
 
 /*
  * Check the cmdline for a LILO-style file= arguments.
@@ -423,8 +481,8 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			size = files[j].size;
 			while (size) {
 				unsigned long chunksize;
-				if (size > EFI_READ_CHUNK_SIZE)
-					chunksize = EFI_READ_CHUNK_SIZE;
+				if (size > __chunk_size)
+					chunksize = __chunk_size;
 				else
 					chunksize = size;
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index efc681fd5895..0d37d3372d99 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -1208,4 +1208,6 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
+efi_status_t efi_parse_options(char *cmdline);
+
 #endif /* _LINUX_EFI_H */
-- 
1.9.3

-- 
Matt Fleming, Intel Open Source Technology Center
