Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3HEMs2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 08:48:28 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:35365 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab3HEMsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 08:48:25 -0400
Date: Mon, 5 Aug 2013 14:48:18 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.11-rc5
Message-ID: <20130805144818.47eaf735@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080512-0542-0000-0000-0000060EB0B5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
Enable LZ4 compression for the kernel image, add the machine id for
the new zBC12 model, fix an issue with hanging dasd devices, correct
a Kconfig dependency, fix a compile error in the perf module with
CONFIG_KVM=n and fix the find_next_bit_left primitive for the PCI
base layer.

Chen Gang (1):
      s390/Kconfig: select 'TTY' when 'S390_GUEST' is enabled

Heiko Carstens (3):
      s390: add support for LZ4-compressed kernel
      s390: add support for IBM zBC12 machine
      s390/perf: fix compile error (undefined reference sie_exit)

Martin Schwidefsky (1):
      s390/bitops: fix find_next_bit_left

Stefan Haberland (1):
      s390/dasd: fix hanging devices after path events

 arch/s390/Kconfig                  |    9 ++++++---
 arch/s390/boot/compressed/Makefile |    9 ++++++---
 arch/s390/boot/compressed/misc.c   |    4 ++++
 arch/s390/include/asm/bitops.h     |    2 +-
 arch/s390/kernel/perf_event.c      |    9 +++++----
 arch/s390/kernel/setup.c           |    1 +
 arch/s390/mm/init.c                |    1 +
 arch/s390/oprofile/init.c          |    2 +-
 drivers/s390/block/dasd.c          |    6 ++++++
 9 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 22f75b5..8a4cae7 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -118,6 +118,7 @@ config S390
 	select HAVE_FUNCTION_TRACE_MCOUNT_TEST
 	select HAVE_KERNEL_BZIP2
 	select HAVE_KERNEL_GZIP
+	select HAVE_KERNEL_LZ4
 	select HAVE_KERNEL_LZMA
 	select HAVE_KERNEL_LZO
 	select HAVE_KERNEL_XZ
@@ -227,11 +228,12 @@ config MARCH_Z196
 	  not work on older machines.
 
 config MARCH_ZEC12
-	bool "IBM zEC12"
+	bool "IBM zBC12 and zEC12"
 	select HAVE_MARCH_ZEC12_FEATURES if 64BIT
 	help
-	  Select this to enable optimizations for IBM zEC12 (2827 series). The
-	  kernel will be slightly faster but will not work on older machines.
+	  Select this to enable optimizations for IBM zBC12 and zEC12 (2828 and
+	  2827 series). The kernel will be slightly faster but will not work on
+	  older machines.
 
 endchoice
 
@@ -709,6 +711,7 @@ config S390_GUEST
 	def_bool y
 	prompt "s390 support for virtio devices"
 	depends on 64BIT
+	select TTY
 	select VIRTUALIZATION
 	select VIRTIO
 	select VIRTIO_CONSOLE
diff --git a/arch/s390/boot/compressed/Makefile b/arch/s390/boot/compressed/Makefile
index 3ad8f61..866ecbe 100644
--- a/arch/s390/boot/compressed/Makefile
+++ b/arch/s390/boot/compressed/Makefile
@@ -6,9 +6,9 @@
 
 BITS := $(if $(CONFIG_64BIT),64,31)
 
-targets	:= vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 \
-	   vmlinux.bin.xz vmlinux.bin.lzma vmlinux.bin.lzo misc.o piggy.o \
-	   sizes.h head$(BITS).o
+targets	:= vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2
+targets += vmlinux.bin.xz vmlinux.bin.lzma vmlinux.bin.lzo vmlinux.bin.lz4
+targets += misc.o piggy.o sizes.h head$(BITS).o
 
 KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
@@ -48,6 +48,7 @@ vmlinux.bin.all-y := $(obj)/vmlinux.bin
 
 suffix-$(CONFIG_KERNEL_GZIP)  := gz
 suffix-$(CONFIG_KERNEL_BZIP2) := bz2
+suffix-$(CONFIG_KERNEL_LZ4)  := lz4
 suffix-$(CONFIG_KERNEL_LZMA)  := lzma
 suffix-$(CONFIG_KERNEL_LZO)  := lzo
 suffix-$(CONFIG_KERNEL_XZ)  := xz
@@ -56,6 +57,8 @@ $(obj)/vmlinux.bin.gz: $(vmlinux.bin.all-y)
 	$(call if_changed,gzip)
 $(obj)/vmlinux.bin.bz2: $(vmlinux.bin.all-y)
 	$(call if_changed,bzip2)
+$(obj)/vmlinux.bin.lz4: $(vmlinux.bin.all-y)
+	$(call if_changed,lz4)
 $(obj)/vmlinux.bin.lzma: $(vmlinux.bin.all-y)
 	$(call if_changed,lzma)
 $(obj)/vmlinux.bin.lzo: $(vmlinux.bin.all-y)
diff --git a/arch/s390/boot/compressed/misc.c b/arch/s390/boot/compressed/misc.c
index c4c6a1c..57cbaff 100644
--- a/arch/s390/boot/compressed/misc.c
+++ b/arch/s390/boot/compressed/misc.c
@@ -47,6 +47,10 @@ static unsigned long free_mem_end_ptr;
 #include "../../../../lib/decompress_bunzip2.c"
 #endif
 
+#ifdef CONFIG_KERNEL_LZ4
+#include "../../../../lib/decompress_unlz4.c"
+#endif
+
 #ifdef CONFIG_KERNEL_LZMA
 #include "../../../../lib/decompress_unlzma.c"
 #endif
diff --git a/arch/s390/include/asm/bitops.h b/arch/s390/include/asm/bitops.h
index 4d8604e..7d46767 100644
--- a/arch/s390/include/asm/bitops.h
+++ b/arch/s390/include/asm/bitops.h
@@ -693,7 +693,7 @@ static inline int find_next_bit_left(const unsigned long *addr,
 	size -= offset;
 	p = addr + offset / BITS_PER_LONG;
 	if (bit) {
-		set = __flo_word(0, *p & (~0UL << bit));
+		set = __flo_word(0, *p & (~0UL >> bit));
 		if (set >= size)
 			return size + offset;
 		if (set < BITS_PER_LONG)
diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
index a6fc037..500aa10 100644
--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -52,12 +52,13 @@ static struct kvm_s390_sie_block *sie_block(struct pt_regs *regs)
 
 static bool is_in_guest(struct pt_regs *regs)
 {
-	unsigned long ip = instruction_pointer(regs);
-
 	if (user_mode(regs))
 		return false;
-
-	return ip == (unsigned long) &sie_exit;
+#if defined(CONFIG_KVM) || defined(CONFIG_KVM_MODULE)
+	return instruction_pointer(regs) == (unsigned long) &sie_exit;
+#else
+	return false;
+#endif
 }
 
 static unsigned long guest_is_user_mode(struct pt_regs *regs)
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 497451e..aeed8a6 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -994,6 +994,7 @@ static void __init setup_hwcaps(void)
 		strcpy(elf_platform, "z196");
 		break;
 	case 0x2827:
+	case 0x2828:
 		strcpy(elf_platform, "zEC12");
 		break;
 	}
diff --git a/arch/s390/mm/init.c b/arch/s390/mm/init.c
index ce36ea8..ad446b0 100644
--- a/arch/s390/mm/init.c
+++ b/arch/s390/mm/init.c
@@ -69,6 +69,7 @@ static void __init setup_zero_pages(void)
 		order = 2;
 		break;
 	case 0x2827:	/* zEC12 */
+	case 0x2828:	/* zEC12 */
 	default:
 		order = 5;
 		break;
diff --git a/arch/s390/oprofile/init.c b/arch/s390/oprofile/init.c
index ffeb17c..930783d 100644
--- a/arch/s390/oprofile/init.c
+++ b/arch/s390/oprofile/init.c
@@ -440,7 +440,7 @@ static int oprofile_hwsampler_init(struct oprofile_operations *ops)
 		switch (id.machine) {
 		case 0x2097: case 0x2098: ops->cpu_type = "s390/z10"; break;
 		case 0x2817: case 0x2818: ops->cpu_type = "s390/z196"; break;
-		case 0x2827:              ops->cpu_type = "s390/zEC12"; break;
+		case 0x2827: case 0x2828: ops->cpu_type = "s390/zEC12"; break;
 		default: return -ENODEV;
 		}
 	}
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 17150a7..451bf99 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2392,6 +2392,12 @@ int dasd_sleep_on_immediatly(struct dasd_ccw_req *cqr)
 		rc = cqr->intrc;
 	else
 		rc = -EIO;
+
+	/* kick tasklets */
+	dasd_schedule_device_bh(device);
+	if (device->block)
+		dasd_schedule_block_bh(device->block);
+
 	return rc;
 }
 

