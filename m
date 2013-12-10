Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab3LJIIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 03:08:42 -0500
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:46224 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753116Ab3LJIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 03:08:36 -0500
Date: Tue, 10 Dec 2013 09:08:27 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.13-rc4
Message-ID: <20131210090827.52735ab4@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13121008-6892-0000-0000-000007274216
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
One patch to increase the number of possible CPUs to 256, with the latest
machine a single LPAR can have up to 101 CPUs. Plus a number of bug fixes,
the clock_gettime patch fixes a regression added in the 3.13 merge window.

Heiko Carstens (2):
      s390/smp,sclp: fix size of sclp_cpu_info structure
      s390/vdso: fix access-list entry initialization

Hendrik Brueckner (1):
      s390/sclp: replace uninitialized early_event_mask_sccb variable with sccb_early

Martin Schwidefsky (2):
      s390/vdso: ectg gettime support for CLOCK_THREAD_CPUTIME_ID
      s390/time,vdso: fix clock_gettime for CLOCK_MONOTONIC

Stefan Weinhuber (1):
      s390/dasd: fix memory leak caused by dangling references to request_queue

Xose Vazquez Perez (1):
      s390: increase CONFIG_NR_CPUS limit

 arch/s390/Kconfig                       |    6 +++---
 arch/s390/include/asm/sclp.h            |    3 ++-
 arch/s390/kernel/asm-offsets.c          |    1 +
 arch/s390/kernel/vdso.c                 |    2 +-
 arch/s390/kernel/vdso32/clock_gettime.S |    9 ++-------
 arch/s390/kernel/vdso64/clock_getres.S  |    4 +++-
 arch/s390/kernel/vdso64/clock_gettime.S |   10 +++++-----
 drivers/s390/block/dasd_genhd.c         |    1 -
 drivers/s390/char/sclp_early.c          |    5 ++---
 9 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 5877e71..1e1a03d 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -347,14 +347,14 @@ config SMP
 	  Even if you don't know what to do here, say Y.
 
 config NR_CPUS
-	int "Maximum number of CPUs (2-64)"
-	range 2 64
+	int "Maximum number of CPUs (2-256)"
+	range 2 256
 	depends on SMP
 	default "32" if !64BIT
 	default "64" if 64BIT
 	help
 	  This allows you to specify the maximum number of CPUs which this
-	  kernel will support.  The maximum supported value is 64 and the
+	  kernel will support. The maximum supported value is 256 and the
 	  minimum value which makes sense is 2.
 
 	  This is purely to save memory - each supported CPU adds
diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
index 30ef748..2f39095 100644
--- a/arch/s390/include/asm/sclp.h
+++ b/arch/s390/include/asm/sclp.h
@@ -8,6 +8,7 @@
 
 #include <linux/types.h>
 #include <asm/chpid.h>
+#include <asm/cpu.h>
 
 #define SCLP_CHP_INFO_MASK_SIZE		32
 
@@ -37,7 +38,7 @@ struct sclp_cpu_info {
 	unsigned int standby;
 	unsigned int combined;
 	int has_cpu_type;
-	struct sclp_cpu_entry cpu[255];
+	struct sclp_cpu_entry cpu[MAX_CPU_ADDRESS + 1];
 };
 
 int sclp_get_cpu_info(struct sclp_cpu_info *info);
diff --git a/arch/s390/kernel/asm-offsets.c b/arch/s390/kernel/asm-offsets.c
index 496116c..e4c99a1 100644
--- a/arch/s390/kernel/asm-offsets.c
+++ b/arch/s390/kernel/asm-offsets.c
@@ -72,6 +72,7 @@ int main(void)
 	/* constants used by the vdso */
 	DEFINE(__CLOCK_REALTIME, CLOCK_REALTIME);
 	DEFINE(__CLOCK_MONOTONIC, CLOCK_MONOTONIC);
+	DEFINE(__CLOCK_THREAD_CPUTIME_ID, CLOCK_THREAD_CPUTIME_ID);
 	DEFINE(__CLOCK_REALTIME_RES, MONOTONIC_RES_NSEC);
 	BLANK();
 	/* idle data offsets */
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index a84476f..6136490 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -125,7 +125,7 @@ int vdso_alloc_per_cpu(struct _lowcore *lowcore)
 		psal[i] = 0x80000000;
 
 	lowcore->paste[4] = (u32)(addr_t) psal;
-	psal[0] = 0x20000000;
+	psal[0] = 0x02000000;
 	psal[2] = (u32)(addr_t) aste;
 	*(unsigned long *) (aste + 2) = segment_table +
 		_ASCE_TABLE_LENGTH + _ASCE_USER_BITS + _ASCE_TYPE_SEGMENT;
diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index 5be8e47..65fc397 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -46,18 +46,13 @@ __kernel_clock_gettime:
 	jnm	3f
 	a	%r0,__VDSO_TK_MULT(%r5)
 3:	alr	%r0,%r2
-	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
-	al	%r1,__VDSO_XTIME_NSEC+4(%r5)
-	brc	12,4f
-	ahi	%r0,1
-4:	al	%r0,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic.nsec */
+	al	%r0,__VDSO_WTOM_NSEC(%r5)
 	al	%r1,__VDSO_WTOM_NSEC+4(%r5)
 	brc	12,5f
 	ahi	%r0,1
 5:	l	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
 	srdl	%r0,0(%r2)			/*  >> tk->shift */
-	l	%r2,__VDSO_XTIME_SEC+4(%r5)
-	al	%r2,__VDSO_WTOM_SEC+4(%r5)
+	l	%r2,__VDSO_WTOM_SEC+4(%r5)
 	cl	%r4,__VDSO_UPD_COUNT+4(%r5)	/* check update counter */
 	jne	1b
 	basr	%r5,0
diff --git a/arch/s390/kernel/vdso64/clock_getres.S b/arch/s390/kernel/vdso64/clock_getres.S
index 176e1f7..34deba7 100644
--- a/arch/s390/kernel/vdso64/clock_getres.S
+++ b/arch/s390/kernel/vdso64/clock_getres.S
@@ -23,7 +23,9 @@ __kernel_clock_getres:
 	je	0f
 	cghi	%r2,__CLOCK_MONOTONIC
 	je	0f
-	cghi	%r2,-2		/* CLOCK_THREAD_CPUTIME_ID for this thread */
+	cghi	%r2,__CLOCK_THREAD_CPUTIME_ID
+	je	0f
+	cghi	%r2,-2		/* Per-thread CPUCLOCK with PID=0, VIRT=1 */
 	jne	2f
 	larl	%r5,_vdso_data
 	icm	%r0,15,__LC_ECTG_OK(%r5)
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index 0add107..91940ed 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -22,7 +22,9 @@ __kernel_clock_gettime:
 	larl	%r5,_vdso_data
 	cghi	%r2,__CLOCK_REALTIME
 	je	4f
-	cghi	%r2,-2		/* CLOCK_THREAD_CPUTIME_ID for this thread */
+	cghi	%r2,__CLOCK_THREAD_CPUTIME_ID
+	je	9f
+	cghi	%r2,-2		/* Per-thread CPUCLOCK with PID=0, VIRT=1 */
 	je	9f
 	cghi	%r2,__CLOCK_MONOTONIC
 	jne	12f
@@ -35,13 +37,11 @@ __kernel_clock_gettime:
 	jnz	0b
 	stck	48(%r15)			/* Store TOD clock */
 	lgf	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
-	lg	%r0,__VDSO_XTIME_SEC(%r5)	/* tk->xtime_sec */
-	alg	%r0,__VDSO_WTOM_SEC(%r5)	/*  + wall_to_monotonic.sec */
+	lg	%r0,__VDSO_WTOM_SEC(%r5)
 	lg	%r1,48(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
-	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
-	alg	%r1,__VDSO_WTOM_NSEC(%r5)	/*  + wall_to_monotonic.nsec */
+	alg	%r1,__VDSO_WTOM_NSEC(%r5)
 	srlg	%r1,%r1,0(%r2)			/*  >> tk->shift */
 	clg	%r4,__VDSO_UPD_COUNT(%r5)	/* check update counter */
 	jne	0b
diff --git a/drivers/s390/block/dasd_genhd.c b/drivers/s390/block/dasd_genhd.c
index f649217..f224d59 100644
--- a/drivers/s390/block/dasd_genhd.c
+++ b/drivers/s390/block/dasd_genhd.c
@@ -87,7 +87,6 @@ void dasd_gendisk_free(struct dasd_block *block)
 {
 	if (block->gdp) {
 		del_gendisk(block->gdp);
-		block->gdp->queue = NULL;
 		block->gdp->private_data = NULL;
 		put_disk(block->gdp);
 		block->gdp = NULL;
diff --git a/drivers/s390/char/sclp_early.c b/drivers/s390/char/sclp_early.c
index f7aa080..1465e95 100644
--- a/drivers/s390/char/sclp_early.c
+++ b/drivers/s390/char/sclp_early.c
@@ -35,7 +35,6 @@ struct read_info_sccb {
 	u8	_reserved5[4096 - 112];	/* 112-4095 */
 } __packed __aligned(PAGE_SIZE);
 
-static __initdata struct init_sccb early_event_mask_sccb __aligned(PAGE_SIZE);
 static __initdata struct read_info_sccb early_read_info_sccb;
 static __initdata char sccb_early[PAGE_SIZE] __aligned(PAGE_SIZE);
 static unsigned long sclp_hsa_size;
@@ -113,7 +112,7 @@ static void __init sclp_facilities_detect(void)
 
 bool __init sclp_has_linemode(void)
 {
-	struct init_sccb *sccb = &early_event_mask_sccb;
+	struct init_sccb *sccb = (void *) &sccb_early;
 
 	if (sccb->header.response_code != 0x20)
 		return 0;
@@ -126,7 +125,7 @@ bool __init sclp_has_linemode(void)
 
 bool __init sclp_has_vt220(void)
 {
-	struct init_sccb *sccb = &early_event_mask_sccb;
+	struct init_sccb *sccb = (void *) &sccb_early;
 
 	if (sccb->header.response_code != 0x20)
 		return 0;

