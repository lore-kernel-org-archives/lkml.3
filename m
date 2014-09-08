Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947AbaIHHXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 03:23:32 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:36496 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaIHHXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 03:23:30 -0400
Date: Mon, 8 Sep 2014 09:23:23 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.17-rc5
Message-ID: <20140908092323.58f378cb@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090807-2966-0000-0000-0000010C7DB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
A bug fix for the vdso code, the loadparm for booting from SCSI is
added and the access permissions for the dasd module parameters
are corrected.

Martin Schwidefsky (1):
      s390/vdso: remove NULL pointer check from clock_gettime

Michael Holzheu (1):
      s390/ipl: Add missing SCSI loadparm attributes to /sys/firmware

Peter Oberparleiter (1):
      s390/dasd: Make module parameter visible in sysfs

 arch/s390/include/asm/ipl.h             |   8 +-
 arch/s390/kernel/ipl.c                  | 128 +++++++++++++++++++++-----------
 arch/s390/kernel/vdso32/clock_gettime.S |  10 +--
 arch/s390/kernel/vdso64/clock_gettime.S |  10 +--
 drivers/s390/block/dasd_devmap.c        |   2 +-
 5 files changed, 96 insertions(+), 62 deletions(-)

diff --git a/arch/s390/include/asm/ipl.h b/arch/s390/include/asm/ipl.h
index 2fcccc0..c81661e 100644
--- a/arch/s390/include/asm/ipl.h
+++ b/arch/s390/include/asm/ipl.h
@@ -17,12 +17,12 @@
 #define IPL_PARM_BLK_FCP_LEN (sizeof(struct ipl_list_hdr) + \
 			      sizeof(struct ipl_block_fcp))
 
-#define IPL_PARM_BLK0_FCP_LEN (sizeof(struct ipl_block_fcp) + 8)
+#define IPL_PARM_BLK0_FCP_LEN (sizeof(struct ipl_block_fcp) + 16)
 
 #define IPL_PARM_BLK_CCW_LEN (sizeof(struct ipl_list_hdr) + \
 			      sizeof(struct ipl_block_ccw))
 
-#define IPL_PARM_BLK0_CCW_LEN (sizeof(struct ipl_block_ccw) + 8)
+#define IPL_PARM_BLK0_CCW_LEN (sizeof(struct ipl_block_ccw) + 16)
 
 #define IPL_MAX_SUPPORTED_VERSION (0)
 
@@ -38,10 +38,11 @@ struct ipl_list_hdr {
 	u8  pbt;
 	u8  flags;
 	u16 reserved2;
+	u8  loadparm[8];
 } __attribute__((packed));
 
 struct ipl_block_fcp {
-	u8  reserved1[313-1];
+	u8  reserved1[305-1];
 	u8  opt;
 	u8  reserved2[3];
 	u16 reserved3;
@@ -62,7 +63,6 @@ struct ipl_block_fcp {
 				 offsetof(struct ipl_block_fcp, scp_data)))
 
 struct ipl_block_ccw {
-	u8  load_parm[8];
 	u8  reserved1[84];
 	u8  reserved2[2];
 	u16 devno;
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 22aac58..39badb9 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -455,22 +455,6 @@ DEFINE_IPL_ATTR_RO(ipl_fcp, bootprog, "%lld\n", (unsigned long long)
 DEFINE_IPL_ATTR_RO(ipl_fcp, br_lba, "%lld\n", (unsigned long long)
 		   IPL_PARMBLOCK_START->ipl_info.fcp.br_lba);
 
-static struct attribute *ipl_fcp_attrs[] = {
-	&sys_ipl_type_attr.attr,
-	&sys_ipl_device_attr.attr,
-	&sys_ipl_fcp_wwpn_attr.attr,
-	&sys_ipl_fcp_lun_attr.attr,
-	&sys_ipl_fcp_bootprog_attr.attr,
-	&sys_ipl_fcp_br_lba_attr.attr,
-	NULL,
-};
-
-static struct attribute_group ipl_fcp_attr_group = {
-	.attrs = ipl_fcp_attrs,
-};
-
-/* CCW ipl device attributes */
-
 static ssize_t ipl_ccw_loadparm_show(struct kobject *kobj,
 				     struct kobj_attribute *attr, char *page)
 {
@@ -487,6 +471,23 @@ static ssize_t ipl_ccw_loadparm_show(struct kobject *kobj,
 static struct kobj_attribute sys_ipl_ccw_loadparm_attr =
 	__ATTR(loadparm, 0444, ipl_ccw_loadparm_show, NULL);
 
+static struct attribute *ipl_fcp_attrs[] = {
+	&sys_ipl_type_attr.attr,
+	&sys_ipl_device_attr.attr,
+	&sys_ipl_fcp_wwpn_attr.attr,
+	&sys_ipl_fcp_lun_attr.attr,
+	&sys_ipl_fcp_bootprog_attr.attr,
+	&sys_ipl_fcp_br_lba_attr.attr,
+	&sys_ipl_ccw_loadparm_attr.attr,
+	NULL,
+};
+
+static struct attribute_group ipl_fcp_attr_group = {
+	.attrs = ipl_fcp_attrs,
+};
+
+/* CCW ipl device attributes */
+
 static struct attribute *ipl_ccw_attrs_vm[] = {
 	&sys_ipl_type_attr.attr,
 	&sys_ipl_device_attr.attr,
@@ -765,28 +766,10 @@ DEFINE_IPL_ATTR_RW(reipl_fcp, br_lba, "%lld\n", "%lld\n",
 DEFINE_IPL_ATTR_RW(reipl_fcp, device, "0.0.%04llx\n", "0.0.%llx\n",
 		   reipl_block_fcp->ipl_info.fcp.devno);
 
-static struct attribute *reipl_fcp_attrs[] = {
-	&sys_reipl_fcp_device_attr.attr,
-	&sys_reipl_fcp_wwpn_attr.attr,
-	&sys_reipl_fcp_lun_attr.attr,
-	&sys_reipl_fcp_bootprog_attr.attr,
-	&sys_reipl_fcp_br_lba_attr.attr,
-	NULL,
-};
-
-static struct attribute_group reipl_fcp_attr_group = {
-	.attrs = reipl_fcp_attrs,
-};
-
-/* CCW reipl device attributes */
-
-DEFINE_IPL_ATTR_RW(reipl_ccw, device, "0.0.%04llx\n", "0.0.%llx\n",
-	reipl_block_ccw->ipl_info.ccw.devno);
-
 static void reipl_get_ascii_loadparm(char *loadparm,
 				     struct ipl_parameter_block *ibp)
 {
-	memcpy(loadparm, ibp->ipl_info.ccw.load_parm, LOADPARM_LEN);
+	memcpy(loadparm, ibp->hdr.loadparm, LOADPARM_LEN);
 	EBCASC(loadparm, LOADPARM_LEN);
 	loadparm[LOADPARM_LEN] = 0;
 	strim(loadparm);
@@ -821,13 +804,50 @@ static ssize_t reipl_generic_loadparm_store(struct ipl_parameter_block *ipb,
 		return -EINVAL;
 	}
 	/* initialize loadparm with blanks */
-	memset(ipb->ipl_info.ccw.load_parm, ' ', LOADPARM_LEN);
+	memset(ipb->hdr.loadparm, ' ', LOADPARM_LEN);
 	/* copy and convert to ebcdic */
-	memcpy(ipb->ipl_info.ccw.load_parm, buf, lp_len);
-	ASCEBC(ipb->ipl_info.ccw.load_parm, LOADPARM_LEN);
+	memcpy(ipb->hdr.loadparm, buf, lp_len);
+	ASCEBC(ipb->hdr.loadparm, LOADPARM_LEN);
 	return len;
 }
 
+/* FCP wrapper */
+static ssize_t reipl_fcp_loadparm_show(struct kobject *kobj,
+				       struct kobj_attribute *attr, char *page)
+{
+	return reipl_generic_loadparm_show(reipl_block_fcp, page);
+}
+
+static ssize_t reipl_fcp_loadparm_store(struct kobject *kobj,
+					struct kobj_attribute *attr,
+					const char *buf, size_t len)
+{
+	return reipl_generic_loadparm_store(reipl_block_fcp, buf, len);
+}
+
+static struct kobj_attribute sys_reipl_fcp_loadparm_attr =
+	__ATTR(loadparm, S_IRUGO | S_IWUSR, reipl_fcp_loadparm_show,
+					    reipl_fcp_loadparm_store);
+
+static struct attribute *reipl_fcp_attrs[] = {
+	&sys_reipl_fcp_device_attr.attr,
+	&sys_reipl_fcp_wwpn_attr.attr,
+	&sys_reipl_fcp_lun_attr.attr,
+	&sys_reipl_fcp_bootprog_attr.attr,
+	&sys_reipl_fcp_br_lba_attr.attr,
+	&sys_reipl_fcp_loadparm_attr.attr,
+	NULL,
+};
+
+static struct attribute_group reipl_fcp_attr_group = {
+	.attrs = reipl_fcp_attrs,
+};
+
+/* CCW reipl device attributes */
+
+DEFINE_IPL_ATTR_RW(reipl_ccw, device, "0.0.%04llx\n", "0.0.%llx\n",
+	reipl_block_ccw->ipl_info.ccw.devno);
+
 /* NSS wrapper */
 static ssize_t reipl_nss_loadparm_show(struct kobject *kobj,
 				       struct kobj_attribute *attr, char *page)
@@ -1125,11 +1145,10 @@ static void reipl_block_ccw_fill_parms(struct ipl_parameter_block *ipb)
 	/* LOADPARM */
 	/* check if read scp info worked and set loadparm */
 	if (sclp_ipl_info.is_valid)
-		memcpy(ipb->ipl_info.ccw.load_parm,
-				&sclp_ipl_info.loadparm, LOADPARM_LEN);
+		memcpy(ipb->hdr.loadparm, &sclp_ipl_info.loadparm, LOADPARM_LEN);
 	else
 		/* read scp info failed: set empty loadparm (EBCDIC blanks) */
-		memset(ipb->ipl_info.ccw.load_parm, 0x40, LOADPARM_LEN);
+		memset(ipb->hdr.loadparm, 0x40, LOADPARM_LEN);
 	ipb->hdr.flags = DIAG308_FLAGS_LP_VALID;
 
 	/* VM PARM */
@@ -1251,9 +1270,16 @@ static int __init reipl_fcp_init(void)
 		return rc;
 	}
 
-	if (ipl_info.type == IPL_TYPE_FCP)
+	if (ipl_info.type == IPL_TYPE_FCP) {
 		memcpy(reipl_block_fcp, IPL_PARMBLOCK_START, PAGE_SIZE);
-	else {
+		/*
+		 * Fix loadparm: There are systems where the (SCSI) LOADPARM
+		 * is invalid in the SCSI IPL parameter block, so take it
+		 * always from sclp_ipl_info.
+		 */
+		memcpy(reipl_block_fcp->hdr.loadparm, sclp_ipl_info.loadparm,
+		       LOADPARM_LEN);
+	} else {
 		reipl_block_fcp->hdr.len = IPL_PARM_BLK_FCP_LEN;
 		reipl_block_fcp->hdr.version = IPL_PARM_BLOCK_VERSION;
 		reipl_block_fcp->hdr.blk0_len = IPL_PARM_BLK0_FCP_LEN;
@@ -1864,7 +1890,23 @@ static void __init shutdown_actions_init(void)
 
 static int __init s390_ipl_init(void)
 {
+	char str[8] = {0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40, 0x40};
+
 	sclp_get_ipl_info(&sclp_ipl_info);
+	/*
+	 * Fix loadparm: There are systems where the (SCSI) LOADPARM
+	 * returned by read SCP info is invalid (contains EBCDIC blanks)
+	 * when the system has been booted via diag308. In that case we use
+	 * the value from diag308, if available.
+	 *
+	 * There are also systems where diag308 store does not work in
+	 * case the system is booted from HMC. Fortunately in this case
+	 * READ SCP info provides the correct value.
+	 */
+	if (memcmp(sclp_ipl_info.loadparm, str, sizeof(str)) == 0 &&
+	    diag308_set_works)
+		memcpy(sclp_ipl_info.loadparm, ipl_block.hdr.loadparm,
+		       LOADPARM_LEN);
 	shutdown_actions_init();
 	shutdown_triggers_init();
 	return 0;
diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index 65fc397..7cf18f8 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -22,13 +22,11 @@ __kernel_clock_gettime:
 	basr	%r5,0
 0:	al	%r5,21f-0b(%r5)			/* get &_vdso_data */
 	chi	%r2,__CLOCK_REALTIME
-	je	10f
+	je	11f
 	chi	%r2,__CLOCK_MONOTONIC
 	jne	19f
 
 	/* CLOCK_MONOTONIC */
-	ltr	%r3,%r3
-	jz	9f				/* tp == NULL */
 1:	l	%r4,__VDSO_UPD_COUNT+4(%r5)	/* load update counter */
 	tml	%r4,0x0001			/* pending update ? loop */
 	jnz	1b
@@ -67,12 +65,10 @@ __kernel_clock_gettime:
 	j	6b
 8:	st	%r2,0(%r3)			/* store tp->tv_sec */
 	st	%r1,4(%r3)			/* store tp->tv_nsec */
-9:	lhi	%r2,0
+	lhi	%r2,0
 	br	%r14
 
 	/* CLOCK_REALTIME */
-10:	ltr	%r3,%r3				/* tp == NULL */
-	jz	18f
 11:	l	%r4,__VDSO_UPD_COUNT+4(%r5)	/* load update counter */
 	tml	%r4,0x0001			/* pending update ? loop */
 	jnz	11b
@@ -111,7 +107,7 @@ __kernel_clock_gettime:
 	j	15b
 17:	st	%r2,0(%r3)			/* store tp->tv_sec */
 	st	%r1,4(%r3)			/* store tp->tv_nsec */
-18:	lhi	%r2,0
+	lhi	%r2,0
 	br	%r14
 
 	/* Fallback to system call */
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index 91940ed..3f34e09 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -21,7 +21,7 @@ __kernel_clock_gettime:
 	.cfi_startproc
 	larl	%r5,_vdso_data
 	cghi	%r2,__CLOCK_REALTIME
-	je	4f
+	je	5f
 	cghi	%r2,__CLOCK_THREAD_CPUTIME_ID
 	je	9f
 	cghi	%r2,-2		/* Per-thread CPUCLOCK with PID=0, VIRT=1 */
@@ -30,8 +30,6 @@ __kernel_clock_gettime:
 	jne	12f
 
 	/* CLOCK_MONOTONIC */
-	ltgr	%r3,%r3
-	jz	3f				/* tp == NULL */
 0:	lg	%r4,__VDSO_UPD_COUNT(%r5)	/* load update counter */
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	0b
@@ -53,12 +51,10 @@ __kernel_clock_gettime:
 	j	1b
 2:	stg	%r0,0(%r3)			/* store tp->tv_sec */
 	stg	%r1,8(%r3)			/* store tp->tv_nsec */
-3:	lghi	%r2,0
+	lghi	%r2,0
 	br	%r14
 
 	/* CLOCK_REALTIME */
-4:	ltr	%r3,%r3				/* tp == NULL */
-	jz	8f
 5:	lg	%r4,__VDSO_UPD_COUNT(%r5)	/* load update counter */
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	5b
@@ -80,7 +76,7 @@ __kernel_clock_gettime:
 	j	6b
 7:	stg	%r0,0(%r3)			/* store tp->tv_sec */
 	stg	%r1,8(%r3)			/* store tp->tv_nsec */
-8:	lghi	%r2,0
+	lghi	%r2,0
 	br	%r14
 
 	/* CLOCK_THREAD_CPUTIME_ID for this thread */
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 2ead7e7..14ba80b 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -77,7 +77,7 @@ EXPORT_SYMBOL_GPL(dasd_nofcx);
  * strings when running as a module.
  */
 static char *dasd[256];
-module_param_array(dasd, charp, NULL, 0);
+module_param_array(dasd, charp, NULL, S_IRUGO);
 
 /*
  * Single spinlock to protect devmap and servermap structures and lists.

