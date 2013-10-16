Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416Ab3JPMdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:33:00 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:42404 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934344Ab3JPMcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:32:03 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 15/16] m68k/UAPI: Use proper types (endianness/size) in <asm/bootinfo*.h>
Date: Wed, 16 Oct 2013 14:31:32 +0200
Message-Id: <1381926693-6392-16-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
References: <1381926693-6392-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
---
 arch/m68k/amiga/config.c                     |   18 +++++++--------
 arch/m68k/apollo/config.c                    |   15 ++++++------
 arch/m68k/atari/config.c                     |    9 ++++----
 arch/m68k/bvme6000/config.c                  |    3 ++-
 arch/m68k/hp300/config.c                     |    9 ++++----
 arch/m68k/include/uapi/asm/bootinfo-amiga.h  |   14 +++++------
 arch/m68k/include/uapi/asm/bootinfo-apollo.h |    2 +-
 arch/m68k/include/uapi/asm/bootinfo-atari.h  |    4 ++--
 arch/m68k/include/uapi/asm/bootinfo-hp300.h  |    6 ++---
 arch/m68k/include/uapi/asm/bootinfo-mac.h    |    2 +-
 arch/m68k/include/uapi/asm/bootinfo-vme.h    |   17 ++++++++------
 arch/m68k/include/uapi/asm/bootinfo.h        |   29 ++++++++++++-----------
 arch/m68k/kernel/bootinfo_proc.c             |    8 ++++---
 arch/m68k/kernel/setup_mm.c                  |   31 ++++++++++++++++---------
 arch/m68k/mac/config.c                       |   32 ++++++++++++++------------
 arch/m68k/mvme147/config.c                   |    4 +++-
 arch/m68k/mvme16x/config.c                   |   27 ++++++++++++----------
 17 files changed, 129 insertions(+), 101 deletions(-)

diff --git a/arch/m68k/amiga/config.c b/arch/m68k/amiga/config.c
index 0c92c1baf9bf..06920e85fac9 100644
--- a/arch/m68k/amiga/config.c
+++ b/arch/m68k/amiga/config.c
@@ -145,37 +145,37 @@ static struct resource ram_resource[NUM_MEMINFO];
 int __init amiga_parse_bootinfo(const struct bi_record *record)
 {
 	int unknown = 0;
-	const unsigned long *data = record->data;
+	const void *data = record->data;
 
-	switch (record->tag) {
+	switch (be16_to_cpu(record->tag)) {
 	case BI_AMIGA_MODEL:
-		amiga_model = *data;
+		amiga_model = be32_to_cpup(data);
 		break;
 
 	case BI_AMIGA_ECLOCK:
-		amiga_eclock = *data;
+		amiga_eclock = be32_to_cpup(data);
 		break;
 
 	case BI_AMIGA_CHIPSET:
-		amiga_chipset = *data;
+		amiga_chipset = be32_to_cpup(data);
 		break;
 
 	case BI_AMIGA_CHIP_SIZE:
-		amiga_chip_size = *(const int *)data;
+		amiga_chip_size = be32_to_cpup(data);
 		break;
 
 	case BI_AMIGA_VBLANK:
-		amiga_vblank = *(const unsigned char *)data;
+		amiga_vblank = *(const __u8 *)data;
 		break;
 
 	case BI_AMIGA_PSFREQ:
-		amiga_psfreq = *(const unsigned char *)data;
+		amiga_psfreq = *(const __u8 *)data;
 		break;
 
 	case BI_AMIGA_AUTOCON:
 #ifdef CONFIG_ZORRO
 		if (zorro_num_autocon < ZORRO_NUM_AUTO) {
-			const struct ConfigDev *cd = (struct ConfigDev *)data;
+			const struct ConfigDev *cd = data;
 			struct zorro_dev_init *dev = &zorro_autocon_init[zorro_num_autocon++];
 			dev->rom = cd->cd_Rom;
 			dev->slotaddr = be16_to_cpu(cd->cd_SlotAddr);
diff --git a/arch/m68k/apollo/config.c b/arch/m68k/apollo/config.c
index c90c19e904bc..9268c0f96376 100644
--- a/arch/m68k/apollo/config.c
+++ b/arch/m68k/apollo/config.c
@@ -11,6 +11,7 @@
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-apollo.h>
+#include <asm/byteorder.h>
 #include <asm/pgtable.h>
 #include <asm/apollohw.h>
 #include <asm/irq.h>
@@ -48,15 +49,15 @@ static const char *apollo_models[] = {
 int __init apollo_parse_bootinfo(const struct bi_record *record)
 {
 	int unknown = 0;
-	const unsigned long *data = record->data;
+	const void *data = record->data;
 
-	switch(record->tag) {
-		case BI_APOLLO_MODEL:
-			apollo_model=*data;
-			break;
+	switch (be16_to_cpu(record->tag)) {
+	case BI_APOLLO_MODEL:
+		apollo_model = be32_to_cpup(data);
+		break;
 
-		default:
-			 unknown=1;
+	default:
+		 unknown=1;
 	}
 
 	return unknown;
diff --git a/arch/m68k/atari/config.c b/arch/m68k/atari/config.c
index 9159195505d5..01a62161b08a 100644
--- a/arch/m68k/atari/config.c
+++ b/arch/m68k/atari/config.c
@@ -38,6 +38,7 @@
 
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-atari.h>
+#include <asm/byteorder.h>
 #include <asm/setup.h>
 #include <asm/atarihw.h>
 #include <asm/atariints.h>
@@ -130,14 +131,14 @@ static int __init scc_test(volatile char *ctla)
 int __init atari_parse_bootinfo(const struct bi_record *record)
 {
 	int unknown = 0;
-	const u_long *data = record->data;
+	const void *data = record->data;
 
-	switch (record->tag) {
+	switch (be16_to_cpu(record->tag)) {
 	case BI_ATARI_MCH_COOKIE:
-		atari_mch_cookie = *data;
+		atari_mch_cookie = be32_to_cpup(data);
 		break;
 	case BI_ATARI_MCH_TYPE:
-		atari_mch_type = *data;
+		atari_mch_type = be32_to_cpup(data);
 		break;
 	default:
 		unknown = 1;
diff --git a/arch/m68k/bvme6000/config.c b/arch/m68k/bvme6000/config.c
index 4d1b403822fa..478623dbb209 100644
--- a/arch/m68k/bvme6000/config.c
+++ b/arch/m68k/bvme6000/config.c
@@ -29,6 +29,7 @@
 
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-vme.h>
+#include <asm/byteorder.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -53,7 +54,7 @@ static irq_handler_t tick_handler;
 
 int __init bvme6000_parse_bootinfo(const struct bi_record *bi)
 {
-	if (bi->tag == BI_VME_TYPE)
+	if (be16_to_cpu(bi->tag) == BI_VME_TYPE)
 		return 0;
 	else
 		return 1;
diff --git a/arch/m68k/hp300/config.c b/arch/m68k/hp300/config.c
index 892d0794fc0b..2e5a787ea11b 100644
--- a/arch/m68k/hp300/config.c
+++ b/arch/m68k/hp300/config.c
@@ -15,6 +15,7 @@
 
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-hp300.h>
+#include <asm/byteorder.h>
 #include <asm/machdep.h>
 #include <asm/blinken.h>
 #include <asm/io.h>                               /* readb() and writeb() */
@@ -71,15 +72,15 @@ extern int hp300_setup_serial_console(void) __init;
 int __init hp300_parse_bootinfo(const struct bi_record *record)
 {
 	int unknown = 0;
-	const unsigned long *data = record->data;
+	const void *data = record->data;
 
-	switch (record->tag) {
+	switch (be16_to_cpu(record->tag)) {
 	case BI_HP300_MODEL:
-		hp300_model = *data;
+		hp300_model = be32_to_cpup(data);
 		break;
 
 	case BI_HP300_UART_SCODE:
-		hp300_uart_scode = *data;
+		hp300_uart_scode = be32_to_cpup(data);
 		break;
 
 	case BI_HP300_UART_ADDR:
diff --git a/arch/m68k/include/uapi/asm/bootinfo-amiga.h b/arch/m68k/include/uapi/asm/bootinfo-amiga.h
index 28b6da07874a..daad3c58d2da 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-amiga.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-amiga.h
@@ -10,15 +10,15 @@
      *  Amiga-specific tags
      */
 
-#define BI_AMIGA_MODEL		0x8000	/* model (u_long) */
+#define BI_AMIGA_MODEL		0x8000	/* model (__be32) */
 #define BI_AMIGA_AUTOCON	0x8001	/* AutoConfig device */
 					/* (AmigaOS struct ConfigDev) */
-#define BI_AMIGA_CHIP_SIZE	0x8002	/* size of Chip RAM (u_long) */
-#define BI_AMIGA_VBLANK		0x8003	/* VBLANK frequency (u_char) */
-#define BI_AMIGA_PSFREQ		0x8004	/* power supply frequency (u_char) */
-#define BI_AMIGA_ECLOCK		0x8005	/* EClock frequency (u_long) */
-#define BI_AMIGA_CHIPSET	0x8006	/* native chipset present (u_long) */
-#define BI_AMIGA_SERPER		0x8007	/* serial port period (u_short) */
+#define BI_AMIGA_CHIP_SIZE	0x8002	/* size of Chip RAM (__be32) */
+#define BI_AMIGA_VBLANK		0x8003	/* VBLANK frequency (__u8) */
+#define BI_AMIGA_PSFREQ		0x8004	/* power supply frequency (__u8) */
+#define BI_AMIGA_ECLOCK		0x8005	/* EClock frequency (__be32) */
+#define BI_AMIGA_CHIPSET	0x8006	/* native chipset present (__be32) */
+#define BI_AMIGA_SERPER		0x8007	/* serial port period (__be16) */
 
 
     /*
diff --git a/arch/m68k/include/uapi/asm/bootinfo-apollo.h b/arch/m68k/include/uapi/asm/bootinfo-apollo.h
index 69923697e131..a93e0af1c6fe 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-apollo.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-apollo.h
@@ -10,7 +10,7 @@
      *  Apollo-specific tags
      */
 
-#define BI_APOLLO_MODEL		0x8000	/* model (u_long) */
+#define BI_APOLLO_MODEL		0x8000	/* model (__be32) */
 
 
     /*
diff --git a/arch/m68k/include/uapi/asm/bootinfo-atari.h b/arch/m68k/include/uapi/asm/bootinfo-atari.h
index cca0a83fc0e5..a817854049bb 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-atari.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-atari.h
@@ -10,8 +10,8 @@
      *  Atari-specific tags
      */
 
-#define BI_ATARI_MCH_COOKIE	0x8000	/* _MCH cookie from TOS (u_long) */
-#define BI_ATARI_MCH_TYPE	0x8001	/* special machine type (u_long) */
+#define BI_ATARI_MCH_COOKIE	0x8000	/* _MCH cookie from TOS (__be32) */
+#define BI_ATARI_MCH_TYPE	0x8001	/* special machine type (__be32) */
 
 
     /*
diff --git a/arch/m68k/include/uapi/asm/bootinfo-hp300.h b/arch/m68k/include/uapi/asm/bootinfo-hp300.h
index 08530e12d4c3..c90cb71ed89a 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-hp300.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-hp300.h
@@ -10,9 +10,9 @@
      *  HP9000/300-specific tags
      */
 
-#define BI_HP300_MODEL		0x8000	/* model (u_long) */
-#define BI_HP300_UART_SCODE	0x8001	/* UART select code (u_long) */
-#define BI_HP300_UART_ADDR	0x8002	/* phys. addr of UART (u_long) */
+#define BI_HP300_MODEL		0x8000	/* model (__be32) */
+#define BI_HP300_UART_SCODE	0x8001	/* UART select code (__be32) */
+#define BI_HP300_UART_ADDR	0x8002	/* phys. addr of UART (__be32) */
 
 
     /*
diff --git a/arch/m68k/include/uapi/asm/bootinfo-mac.h b/arch/m68k/include/uapi/asm/bootinfo-mac.h
index 0667c041d1a7..cc97ea0a6731 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-mac.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-mac.h
@@ -7,7 +7,7 @@
 
 
     /*
-     *  Macintosh-specific tags (all u_long)
+     *  Macintosh-specific tags (all __be32)
      */
 
 #define BI_MAC_MODEL		0x8000	/* Mac Gestalt ID (model type) */
diff --git a/arch/m68k/include/uapi/asm/bootinfo-vme.h b/arch/m68k/include/uapi/asm/bootinfo-vme.h
index 13ba5e19fe24..a135eb41d672 100644
--- a/arch/m68k/include/uapi/asm/bootinfo-vme.h
+++ b/arch/m68k/include/uapi/asm/bootinfo-vme.h
@@ -6,11 +6,14 @@
 #define _UAPI_ASM_M68K_BOOTINFO_VME_H
 
 
+#include <linux/types.h>
+
+
     /*
      *  VME-specific tags
      */
 
-#define BI_VME_TYPE		0x8000	/* VME sub-architecture (u_long) */
+#define BI_VME_TYPE		0x8000	/* VME sub-architecture (__be32) */
 #define BI_VME_BRDINFO		0x8001	/* VME board information (struct) */
 
 
@@ -43,13 +46,13 @@
 
 typedef struct {
 	char	bdid[4];
-	u_char	rev, mth, day, yr;
-	u_short	size, reserved;
-	u_short	brdno;
+	__u8	rev, mth, day, yr;
+	__be16	size, reserved;
+	__be16	brdno;
 	char	brdsuffix[2];
-	u_long	options;
-	u_short	clun, dlun, ctype, dnum;
-	u_long	option2;
+	__be32	options;
+	__be16	clun, dlun, ctype, dnum;
+	__be32	option2;
 } t_bdid, *p_bdid;
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/m68k/include/uapi/asm/bootinfo.h b/arch/m68k/include/uapi/asm/bootinfo.h
index 9d64599d7bf5..cdeb26a015b0 100644
--- a/arch/m68k/include/uapi/asm/bootinfo.h
+++ b/arch/m68k/include/uapi/asm/bootinfo.h
@@ -12,6 +12,9 @@
 #define _UAPI_ASM_M68K_BOOTINFO_H
 
 
+#include <linux/types.h>
+
+
 #ifndef __ASSEMBLY__
 
     /*
@@ -28,15 +31,15 @@
      */
 
 struct bi_record {
-	unsigned short tag;		/* tag ID */
-	unsigned short size;		/* size of record (in bytes) */
-	unsigned long data[0];		/* data */
+	__be16 tag;			/* tag ID */
+	__be16 size;			/* size of record (in bytes) */
+	__be32 data[0];			/* data */
 };
 
 
 struct mem_info {
-	unsigned long addr;		/* physical address of memory chunk */
-	unsigned long size;		/* length of memory chunk (in bytes) */
+	__be32 addr;			/* physical address of memory chunk */
+	__be32 size;			/* length of memory chunk (in bytes) */
 };
 
 #endif /* __ASSEMBLY__ */
@@ -50,10 +53,10 @@ struct mem_info {
      */
 
 #define BI_LAST			0x0000	/* last record (sentinel) */
-#define BI_MACHTYPE		0x0001	/* machine type (u_long) */
-#define BI_CPUTYPE		0x0002	/* cpu type (u_long) */
-#define BI_FPUTYPE		0x0003	/* fpu type (u_long) */
-#define BI_MMUTYPE		0x0004	/* mmu type (u_long) */
+#define BI_MACHTYPE		0x0001	/* machine type (__be32) */
+#define BI_CPUTYPE		0x0002	/* cpu type (__be32) */
+#define BI_FPUTYPE		0x0003	/* fpu type (__be32) */
+#define BI_MMUTYPE		0x0004	/* mmu type (__be32) */
 #define BI_MEMCHUNK		0x0005	/* memory chunk address and size */
 					/* (struct mem_info) */
 #define BI_RAMDISK		0x0006	/* ramdisk address and size */
@@ -157,11 +160,11 @@ struct mem_info {
 #ifndef __ASSEMBLY__
 
 struct bootversion {
-	unsigned short branch;
-	unsigned long magic;
+	__be16 branch;
+	__be32 magic;
 	struct {
-		unsigned long machtype;
-		unsigned long version;
+		__be32 machtype;
+		__be32 version;
 	} machversions[0];
 } __packed;
 
diff --git a/arch/m68k/kernel/bootinfo_proc.c b/arch/m68k/kernel/bootinfo_proc.c
index a22eac1dfdd1..7ee853e1432b 100644
--- a/arch/m68k/kernel/bootinfo_proc.c
+++ b/arch/m68k/kernel/bootinfo_proc.c
@@ -10,6 +10,7 @@
 #include <linux/string.h>
 
 #include <asm/bootinfo.h>
+#include <asm/byteorder.h>
 
 
 static char bootinfo_tmp[1536] __initdata;
@@ -34,9 +35,10 @@ void __init save_bootinfo(const struct bi_record *bi)
 	const void *start = bi;
 	size_t size = sizeof(bi->tag);
 
-	while (bi->tag != BI_LAST) {
-		size += bi->size;
-		bi = (struct bi_record *)((unsigned long)bi + bi->size);
+	while (be16_to_cpu(bi->tag) != BI_LAST) {
+		uint16_t n = be16_to_cpu(bi->size);
+		size += n;
+		bi = (struct bi_record *)((unsigned long)bi + n);
 	}
 
 	if (size > sizeof(bootinfo_tmp)) {
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index d3f3fe6374c6..99cfe0577ad0 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -26,6 +26,7 @@
 #include <linux/initrd.h>
 
 #include <asm/bootinfo.h>
+#include <asm/byteorder.h>
 #include <asm/sections.h>
 #include <asm/setup.h>
 #include <asm/fpu.h>
@@ -143,13 +144,16 @@ extern void paging_init(void);
 
 static void __init m68k_parse_bootinfo(const struct bi_record *record)
 {
+	uint16_t tag;
+
 	save_bootinfo(record);
 
-	while (record->tag != BI_LAST) {
+	while ((tag = be16_to_cpu(record->tag)) != BI_LAST) {
 		int unknown = 0;
-		const unsigned long *data = record->data;
+		const void *data = record->data;
+		uint16_t size = be16_to_cpu(record->size);
 
-		switch (record->tag) {
+		switch (tag) {
 		case BI_MACHTYPE:
 		case BI_CPUTYPE:
 		case BI_FPUTYPE:
@@ -159,8 +163,11 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 
 		case BI_MEMCHUNK:
 			if (m68k_num_memory < NUM_MEMINFO) {
-				m68k_memory[m68k_num_memory].addr = data[0];
-				m68k_memory[m68k_num_memory].size = data[1];
+				const struct mem_info *m = data;
+				m68k_memory[m68k_num_memory].addr =
+					be32_to_cpu(m->addr);
+				m68k_memory[m68k_num_memory].size =
+					be32_to_cpu(m->size);
 				m68k_num_memory++;
 			} else
 				pr_warn("%s: too many memory chunks\n",
@@ -168,12 +175,15 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 			break;
 
 		case BI_RAMDISK:
-			m68k_ramdisk.addr = data[0];
-			m68k_ramdisk.size = data[1];
+			{
+				const struct mem_info *m = data;
+				m68k_ramdisk.addr = be32_to_cpu(m->addr);
+				m68k_ramdisk.size = be32_to_cpu(m->size);
+			}
 			break;
 
 		case BI_COMMAND_LINE:
-			strlcpy(m68k_command_line, (const char *)data,
+			strlcpy(m68k_command_line, data,
 				sizeof(m68k_command_line));
 			break;
 
@@ -201,9 +211,8 @@ static void __init m68k_parse_bootinfo(const struct bi_record *record)
 		}
 		if (unknown)
 			pr_warn("%s: unknown tag 0x%04x ignored\n", __func__,
-				   record->tag);
-		record = (struct bi_record *)((unsigned long)record +
-					      record->size);
+				tag);
+		record = (struct bi_record *)((unsigned long)record + size);
 	}
 
 	m68k_realnum_memory = m68k_num_memory;
diff --git a/arch/m68k/mac/config.c b/arch/m68k/mac/config.c
index e48069da04ed..982c3fe73c4a 100644
--- a/arch/m68k/mac/config.c
+++ b/arch/m68k/mac/config.c
@@ -29,6 +29,7 @@
 #include <asm/setup.h>
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-mac.h>
+#include <asm/byteorder.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -107,45 +108,46 @@ static void __init mac_sched_init(irq_handler_t vector)
 int __init mac_parse_bootinfo(const struct bi_record *record)
 {
 	int unknown = 0;
-	const u_long *data = record->data;
+	const void *data = record->data;
 
-	switch (record->tag) {
+	switch (be16_to_cpu(record->tag)) {
 	case BI_MAC_MODEL:
-		mac_bi_data.id = *data;
+		mac_bi_data.id = be32_to_cpup(data);
 		break;
 	case BI_MAC_VADDR:
-		mac_bi_data.videoaddr = *data;
+		mac_bi_data.videoaddr = be32_to_cpup(data);
 		break;
 	case BI_MAC_VDEPTH:
-		mac_bi_data.videodepth = *data;
+		mac_bi_data.videodepth = be32_to_cpup(data);
 		break;
 	case BI_MAC_VROW:
-		mac_bi_data.videorow = *data;
+		mac_bi_data.videorow = be32_to_cpup(data);
 		break;
 	case BI_MAC_VDIM:
-		mac_bi_data.dimensions = *data;
+		mac_bi_data.dimensions = be32_to_cpup(data);
 		break;
 	case BI_MAC_VLOGICAL:
-		mac_bi_data.videological = VIDEOMEMBASE + (*data & ~VIDEOMEMMASK);
-		mac_orig_videoaddr = *data;
+		mac_orig_videoaddr = be32_to_cpup(data);
+		mac_bi_data.videological =
+			VIDEOMEMBASE + (mac_orig_videoaddr & ~VIDEOMEMMASK);
 		break;
 	case BI_MAC_SCCBASE:
-		mac_bi_data.sccbase = *data;
+		mac_bi_data.sccbase = be32_to_cpup(data);
 		break;
 	case BI_MAC_BTIME:
-		mac_bi_data.boottime = *data;
+		mac_bi_data.boottime = be32_to_cpup(data);
 		break;
 	case BI_MAC_GMTBIAS:
-		mac_bi_data.gmtbias = *data;
+		mac_bi_data.gmtbias = be32_to_cpup(data);
 		break;
 	case BI_MAC_MEMSIZE:
-		mac_bi_data.memsize = *data;
+		mac_bi_data.memsize = be32_to_cpup(data);
 		break;
 	case BI_MAC_CPUID:
-		mac_bi_data.cpuid = *data;
+		mac_bi_data.cpuid = be32_to_cpup(data);
 		break;
 	case BI_MAC_ROMBASE:
-		mac_bi_data.rombase = *data;
+		mac_bi_data.rombase = be32_to_cpup(data);
 		break;
 	default:
 		unknown = 1;
diff --git a/arch/m68k/mvme147/config.c b/arch/m68k/mvme147/config.c
index 3a1d47564e52..1bb3ce6634d3 100644
--- a/arch/m68k/mvme147/config.c
+++ b/arch/m68k/mvme147/config.c
@@ -27,6 +27,7 @@
 
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-vme.h>
+#include <asm/byteorder.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -54,7 +55,8 @@ irq_handler_t tick_handler;
 
 int __init mvme147_parse_bootinfo(const struct bi_record *bi)
 {
-	if (bi->tag == BI_VME_TYPE || bi->tag == BI_VME_BRDINFO)
+	uint16_t tag = be16_to_cpu(bi->tag);
+	if (tag == BI_VME_TYPE || tag == BI_VME_BRDINFO)
 		return 0;
 	else
 		return 1;
diff --git a/arch/m68k/mvme16x/config.c b/arch/m68k/mvme16x/config.c
index e05994fd048c..eab7d342757e 100644
--- a/arch/m68k/mvme16x/config.c
+++ b/arch/m68k/mvme16x/config.c
@@ -30,6 +30,7 @@
 
 #include <asm/bootinfo.h>
 #include <asm/bootinfo-vme.h>
+#include <asm/byteorder.h>
 #include <asm/pgtable.h>
 #include <asm/setup.h>
 #include <asm/irq.h>
@@ -63,7 +64,8 @@ EXPORT_SYMBOL(mvme16x_config);
 
 int __init mvme16x_parse_bootinfo(const struct bi_record *bi)
 {
-	if (bi->tag == BI_VME_TYPE || bi->tag == BI_VME_BRDINFO)
+	uint16_t tag = be16_to_cpu(bi->tag);
+	if (tag == BI_VME_TYPE || tag == BI_VME_BRDINFO)
 		return 0;
 	else
 		return 1;
@@ -88,15 +90,15 @@ static void mvme16x_get_model(char *model)
     suf[3] = '\0';
     suf[0] = suf[1] ? '-' : '\0';
 
-    sprintf(model, "Motorola MVME%x%s", p->brdno, suf);
+    sprintf(model, "Motorola MVME%x%s", be16_to_cpu(p->brdno), suf);
 }
 
 
 static void mvme16x_get_hardware_list(struct seq_file *m)
 {
-    p_bdid p = &mvme_bdid;
+    uint16_t brdno = be16_to_cpu(mvme_bdid.brdno);
 
-    if (p->brdno == 0x0162 || p->brdno == 0x0172)
+    if (brdno == 0x0162 || brdno == 0x0172)
     {
 	unsigned char rev = *(unsigned char *)MVME162_VERSION_REG;
 
@@ -286,6 +288,7 @@ void __init config_mvme16x(void)
 {
     p_bdid p = &mvme_bdid;
     char id[40];
+    uint16_t brdno = be16_to_cpu(p->brdno);
 
     mach_max_dma_address = 0xffffffff;
     mach_sched_init      = mvme16x_sched_init;
@@ -307,18 +310,18 @@ void __init config_mvme16x(void)
     }
     /* Board type is only set by newer versions of vmelilo/tftplilo */
     if (vme_brdtype == 0)
-	vme_brdtype = p->brdno;
+	vme_brdtype = brdno;
 
     mvme16x_get_model(id);
     printk ("\nBRD_ID: %s   BUG %x.%x %02x/%02x/%02x\n", id, p->rev>>4,
 					p->rev&0xf, p->yr, p->mth, p->day);
-    if (p->brdno == 0x0162 || p->brdno == 0x172)
+    if (brdno == 0x0162 || brdno == 0x172)
     {
 	unsigned char rev = *(unsigned char *)MVME162_VERSION_REG;
 
 	mvme16x_config = rev | MVME16x_CONFIG_GOT_SCCA;
 
-	printk ("MVME%x Hardware status:\n", p->brdno);
+	printk ("MVME%x Hardware status:\n", brdno);
 	printk ("    CPU Type           68%s040\n",
 			rev & MVME16x_CONFIG_GOT_FPU ? "" : "LC");
 	printk ("    CPU clock          %dMHz\n",
@@ -348,12 +351,12 @@ void __init config_mvme16x(void)
 
 static irqreturn_t mvme16x_abort_int (int irq, void *dev_id)
 {
-	p_bdid p = &mvme_bdid;
 	unsigned long *new = (unsigned long *)vectors;
 	unsigned long *old = (unsigned long *)0xffe00000;
 	volatile unsigned char uc, *ucp;
+	uint16_t brdno = be16_to_cpu(mvme_bdid.brdno);
 
-	if (p->brdno == 0x0162 || p->brdno == 0x172)
+	if (brdno == 0x0162 || brdno == 0x172)
 	{
 		ucp = (volatile unsigned char *)0xfff42043;
 		uc = *ucp | 8;
@@ -367,7 +370,7 @@ static irqreturn_t mvme16x_abort_int (int irq, void *dev_id)
 	*(new+9) = *(old+9);		/* Trace */
 	*(new+47) = *(old+47);		/* Trap #15 */
 
-	if (p->brdno == 0x0162 || p->brdno == 0x172)
+	if (brdno == 0x0162 || brdno == 0x172)
 		*(new+0x5e) = *(old+0x5e);	/* ABORT switch */
 	else
 		*(new+0x6e) = *(old+0x6e);	/* ABORT switch */
@@ -382,7 +385,7 @@ static irqreturn_t mvme16x_timer_int (int irq, void *dev_id)
 
 void mvme16x_sched_init (irq_handler_t timer_routine)
 {
-    p_bdid p = &mvme_bdid;
+    uint16_t brdno = be16_to_cpu(mvme_bdid.brdno);
     int irq;
 
     tick_handler = timer_routine;
@@ -395,7 +398,7 @@ void mvme16x_sched_init (irq_handler_t timer_routine)
 				"timer", mvme16x_timer_int))
 	panic ("Couldn't register timer int");
 
-    if (p->brdno == 0x0162 || p->brdno == 0x172)
+    if (brdno == 0x0162 || brdno == 0x172)
 	irq = MVME162_IRQ_ABORT;
     else
         irq = MVME167_IRQ_ABORT;
-- 
1.7.9.5

