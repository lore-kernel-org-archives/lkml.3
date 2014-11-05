Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaKEHHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:07:06 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:54820 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaKEHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:07:01 -0500
Date: Wed, 5 Nov 2014 08:06:54 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 3.18-rc4
Message-ID: <20141105080654.3f797961@mschwide>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14110507-0029-0000-0000-00000188578C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:
One small improvement for the cputime accounting, two bug fixes and
an update for the default configuration files.

Heiko Carstens (2):
      s390/vdso: fix stack corruption
      s390/ftrace: add ftrace_graph_is_dead() check

Martin Schwidefsky (2):
      s390/time: use stck clock fast for do_account_vtime
      s390: update default configuration

 arch/s390/configs/default_defconfig     | 36 +++++++++++++--------------------
 arch/s390/configs/gcov_defconfig        | 25 +++++------------------
 arch/s390/configs/performance_defconfig | 30 +++++++++------------------
 arch/s390/configs/zfcpdump_defconfig    | 10 ++-------
 arch/s390/defconfig                     |  5 ++---
 arch/s390/kernel/ftrace.c               |  2 ++
 arch/s390/kernel/vdso32/clock_gettime.S | 12 +++++++----
 arch/s390/kernel/vdso32/gettimeofday.S  | 14 +++++++------
 arch/s390/kernel/vdso64/clock_gettime.S | 13 ++++++++----
 arch/s390/kernel/vdso64/gettimeofday.S  |  6 ++++--
 arch/s390/kernel/vtime.c                |  4 ++++
 11 files changed, 67 insertions(+), 90 deletions(-)

diff --git a/arch/s390/configs/default_defconfig b/arch/s390/configs/default_defconfig
index 9d94fdd..9432d0f 100644
--- a/arch/s390/configs/default_defconfig
+++ b/arch/s390/configs/default_defconfig
@@ -35,7 +35,6 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_MODULE_SRCVERSION_ALL=y
-CONFIG_BLK_DEV_INTEGRITY=y
 CONFIG_BLK_DEV_THROTTLING=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_IBM_PARTITION=y
@@ -245,6 +244,7 @@ CONFIG_NF_TABLES_IPV4=m
 CONFIG_NFT_CHAIN_ROUTE_IPV4=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NF_TABLES_ARP=m
+CONFIG_NF_NAT_IPV4=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_MATCH_AH=m
 CONFIG_IP_NF_MATCH_ECN=m
@@ -252,11 +252,6 @@ CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP_NF_MATCH_TTL=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
-CONFIG_IP_NF_TARGET_ULOG=m
-CONFIG_NF_NAT_IPV4=m
-CONFIG_IP_NF_TARGET_MASQUERADE=m
-CONFIG_IP_NF_TARGET_NETMAP=m
-CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_CLUSTERIP=m
 CONFIG_IP_NF_TARGET_ECN=m
@@ -270,6 +265,7 @@ CONFIG_NF_CONNTRACK_IPV6=m
 CONFIG_NF_TABLES_IPV6=m
 CONFIG_NFT_CHAIN_ROUTE_IPV6=m
 CONFIG_NFT_CHAIN_NAT_IPV6=m
+CONFIG_NF_NAT_IPV6=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP6_NF_MATCH_AH=m
 CONFIG_IP6_NF_MATCH_EUI64=m
@@ -286,9 +282,6 @@ CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP6_NF_MANGLE=m
 CONFIG_IP6_NF_RAW=m
 CONFIG_IP6_NF_SECURITY=m
-CONFIG_NF_NAT_IPV6=m
-CONFIG_IP6_NF_TARGET_MASQUERADE=m
-CONFIG_IP6_NF_TARGET_NPT=m
 CONFIG_NF_TABLES_BRIDGE=m
 CONFIG_NET_SCTPPROBE=m
 CONFIG_RDS=m
@@ -374,14 +367,13 @@ CONFIG_BLK_DEV_SR=m
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_ENCLOSURE=m
-CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SPI_ATTRS=m
+CONFIG_SCSI_FC_ATTRS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
 CONFIG_ISCSI_TCP=m
-CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
 CONFIG_ZFCP=y
 CONFIG_SCSI_VIRTIO=m
@@ -427,7 +419,6 @@ CONFIG_VIRTIO_NET=m
 CONFIG_NLMON=m
 CONFIG_VHOST_NET=m
 # CONFIG_NET_VENDOR_ARC is not set
-# CONFIG_NET_CADENCE is not set
 # CONFIG_NET_VENDOR_CHELSIO is not set
 # CONFIG_NET_VENDOR_INTEL is not set
 # CONFIG_NET_VENDOR_MARVELL is not set
@@ -481,14 +472,14 @@ CONFIG_JFS_FS=m
 CONFIG_JFS_POSIX_ACL=y
 CONFIG_JFS_SECURITY=y
 CONFIG_JFS_STATISTICS=y
-CONFIG_XFS_FS=m
+CONFIG_XFS_FS=y
 CONFIG_XFS_QUOTA=y
 CONFIG_XFS_POSIX_ACL=y
 CONFIG_XFS_RT=y
 CONFIG_XFS_DEBUG=y
 CONFIG_GFS2_FS=m
 CONFIG_OCFS2_FS=m
-CONFIG_BTRFS_FS=m
+CONFIG_BTRFS_FS=y
 CONFIG_BTRFS_FS_POSIX_ACL=y
 CONFIG_NILFS2_FS=m
 CONFIG_FANOTIFY=y
@@ -574,7 +565,6 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_HUNG_TASK=y
 CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_RT_MUTEXES=y
-CONFIG_RT_MUTEX_TESTER=y
 CONFIG_DEBUG_WW_MUTEX_SLOWPATH=y
 CONFIG_PROVE_LOCKING=y
 CONFIG_LOCK_STAT=y
@@ -600,8 +590,13 @@ CONFIG_FAULT_INJECTION_DEBUG_FS=y
 CONFIG_FAULT_INJECTION_STACKTRACE_FILTER=y
 CONFIG_LATENCYTOP=y
 CONFIG_DEBUG_STRICT_USER_COPY_CHECKS=y
+CONFIG_IRQSOFF_TRACER=y
+CONFIG_PREEMPT_TRACER=y
+CONFIG_SCHED_TRACER=y
+CONFIG_FTRACE_SYSCALLS=y
+CONFIG_STACK_TRACER=y
 CONFIG_BLK_DEV_IO_TRACE=y
-# CONFIG_KPROBE_EVENT is not set
+CONFIG_UPROBE_EVENT=y
 CONFIG_LKDTM=m
 CONFIG_TEST_LIST_SORT=y
 CONFIG_KPROBES_SANITY_TEST=y
@@ -609,7 +604,10 @@ CONFIG_RBTREE_TEST=y
 CONFIG_INTERVAL_TREE_TEST=m
 CONFIG_PERCPU_TEST=m
 CONFIG_ATOMIC64_SELFTEST=y
+CONFIG_TEST_STRING_HELPERS=y
+CONFIG_TEST_KSTRTOX=y
 CONFIG_DMA_API_DEBUG=y
+CONFIG_TEST_BPF=m
 # CONFIG_STRICT_DEVMEM is not set
 CONFIG_S390_PTDUMP=y
 CONFIG_ENCRYPTED_KEYS=m
@@ -673,12 +671,6 @@ CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
 CONFIG_X509_CERTIFICATE_PARSER=m
 CONFIG_CRC7=m
 CONFIG_CRC8=m
-CONFIG_XZ_DEC_X86=y
-CONFIG_XZ_DEC_POWERPC=y
-CONFIG_XZ_DEC_IA64=y
-CONFIG_XZ_DEC_ARM=y
-CONFIG_XZ_DEC_ARMTHUMB=y
-CONFIG_XZ_DEC_SPARC=y
 CONFIG_CORDIC=m
 CONFIG_CMM=m
 CONFIG_APPLDATA_BASE=y
diff --git a/arch/s390/configs/gcov_defconfig b/arch/s390/configs/gcov_defconfig
index 90f514b..219dca6 100644
--- a/arch/s390/configs/gcov_defconfig
+++ b/arch/s390/configs/gcov_defconfig
@@ -35,7 +35,6 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_MODULE_SRCVERSION_ALL=y
-CONFIG_BLK_DEV_INTEGRITY=y
 CONFIG_BLK_DEV_THROTTLING=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_IBM_PARTITION=y
@@ -243,6 +242,7 @@ CONFIG_NF_TABLES_IPV4=m
 CONFIG_NFT_CHAIN_ROUTE_IPV4=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NF_TABLES_ARP=m
+CONFIG_NF_NAT_IPV4=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_MATCH_AH=m
 CONFIG_IP_NF_MATCH_ECN=m
@@ -250,11 +250,6 @@ CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP_NF_MATCH_TTL=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
-CONFIG_IP_NF_TARGET_ULOG=m
-CONFIG_NF_NAT_IPV4=m
-CONFIG_IP_NF_TARGET_MASQUERADE=m
-CONFIG_IP_NF_TARGET_NETMAP=m
-CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_CLUSTERIP=m
 CONFIG_IP_NF_TARGET_ECN=m
@@ -268,6 +263,7 @@ CONFIG_NF_CONNTRACK_IPV6=m
 CONFIG_NF_TABLES_IPV6=m
 CONFIG_NFT_CHAIN_ROUTE_IPV6=m
 CONFIG_NFT_CHAIN_NAT_IPV6=m
+CONFIG_NF_NAT_IPV6=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP6_NF_MATCH_AH=m
 CONFIG_IP6_NF_MATCH_EUI64=m
@@ -284,9 +280,6 @@ CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP6_NF_MANGLE=m
 CONFIG_IP6_NF_RAW=m
 CONFIG_IP6_NF_SECURITY=m
-CONFIG_NF_NAT_IPV6=m
-CONFIG_IP6_NF_TARGET_MASQUERADE=m
-CONFIG_IP6_NF_TARGET_NPT=m
 CONFIG_NF_TABLES_BRIDGE=m
 CONFIG_NET_SCTPPROBE=m
 CONFIG_RDS=m
@@ -371,14 +364,13 @@ CONFIG_BLK_DEV_SR=m
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_ENCLOSURE=m
-CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SPI_ATTRS=m
+CONFIG_SCSI_FC_ATTRS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
 CONFIG_ISCSI_TCP=m
-CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
 CONFIG_ZFCP=y
 CONFIG_SCSI_VIRTIO=m
@@ -424,7 +416,6 @@ CONFIG_VIRTIO_NET=m
 CONFIG_NLMON=m
 CONFIG_VHOST_NET=m
 # CONFIG_NET_VENDOR_ARC is not set
-# CONFIG_NET_CADENCE is not set
 # CONFIG_NET_VENDOR_CHELSIO is not set
 # CONFIG_NET_VENDOR_INTEL is not set
 # CONFIG_NET_VENDOR_MARVELL is not set
@@ -478,13 +469,13 @@ CONFIG_JFS_FS=m
 CONFIG_JFS_POSIX_ACL=y
 CONFIG_JFS_SECURITY=y
 CONFIG_JFS_STATISTICS=y
-CONFIG_XFS_FS=m
+CONFIG_XFS_FS=y
 CONFIG_XFS_QUOTA=y
 CONFIG_XFS_POSIX_ACL=y
 CONFIG_XFS_RT=y
 CONFIG_GFS2_FS=m
 CONFIG_OCFS2_FS=m
-CONFIG_BTRFS_FS=m
+CONFIG_BTRFS_FS=y
 CONFIG_BTRFS_FS_POSIX_ACL=y
 CONFIG_NILFS2_FS=m
 CONFIG_FANOTIFY=y
@@ -626,12 +617,6 @@ CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
 CONFIG_X509_CERTIFICATE_PARSER=m
 CONFIG_CRC7=m
 CONFIG_CRC8=m
-CONFIG_XZ_DEC_X86=y
-CONFIG_XZ_DEC_POWERPC=y
-CONFIG_XZ_DEC_IA64=y
-CONFIG_XZ_DEC_ARM=y
-CONFIG_XZ_DEC_ARMTHUMB=y
-CONFIG_XZ_DEC_SPARC=y
 CONFIG_CORDIC=m
 CONFIG_CMM=m
 CONFIG_APPLDATA_BASE=y
diff --git a/arch/s390/configs/performance_defconfig b/arch/s390/configs/performance_defconfig
index 13559d3..822c2f2 100644
--- a/arch/s390/configs/performance_defconfig
+++ b/arch/s390/configs/performance_defconfig
@@ -33,7 +33,6 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 CONFIG_MODVERSIONS=y
 CONFIG_MODULE_SRCVERSION_ALL=y
-CONFIG_BLK_DEV_INTEGRITY=y
 CONFIG_BLK_DEV_THROTTLING=y
 CONFIG_PARTITION_ADVANCED=y
 CONFIG_IBM_PARTITION=y
@@ -241,6 +240,7 @@ CONFIG_NF_TABLES_IPV4=m
 CONFIG_NFT_CHAIN_ROUTE_IPV4=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NF_TABLES_ARP=m
+CONFIG_NF_NAT_IPV4=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP_NF_MATCH_AH=m
 CONFIG_IP_NF_MATCH_ECN=m
@@ -248,11 +248,6 @@ CONFIG_IP_NF_MATCH_RPFILTER=m
 CONFIG_IP_NF_MATCH_TTL=m
 CONFIG_IP_NF_FILTER=m
 CONFIG_IP_NF_TARGET_REJECT=m
-CONFIG_IP_NF_TARGET_ULOG=m
-CONFIG_NF_NAT_IPV4=m
-CONFIG_IP_NF_TARGET_MASQUERADE=m
-CONFIG_IP_NF_TARGET_NETMAP=m
-CONFIG_IP_NF_TARGET_REDIRECT=m
 CONFIG_IP_NF_MANGLE=m
 CONFIG_IP_NF_TARGET_CLUSTERIP=m
 CONFIG_IP_NF_TARGET_ECN=m
@@ -266,6 +261,7 @@ CONFIG_NF_CONNTRACK_IPV6=m
 CONFIG_NF_TABLES_IPV6=m
 CONFIG_NFT_CHAIN_ROUTE_IPV6=m
 CONFIG_NFT_CHAIN_NAT_IPV6=m
+CONFIG_NF_NAT_IPV6=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP6_NF_MATCH_AH=m
 CONFIG_IP6_NF_MATCH_EUI64=m
@@ -282,9 +278,6 @@ CONFIG_IP6_NF_TARGET_REJECT=m
 CONFIG_IP6_NF_MANGLE=m
 CONFIG_IP6_NF_RAW=m
 CONFIG_IP6_NF_SECURITY=m
-CONFIG_NF_NAT_IPV6=m
-CONFIG_IP6_NF_TARGET_MASQUERADE=m
-CONFIG_IP6_NF_TARGET_NPT=m
 CONFIG_NF_TABLES_BRIDGE=m
 CONFIG_NET_SCTPPROBE=m
 CONFIG_RDS=m
@@ -369,14 +362,13 @@ CONFIG_BLK_DEV_SR=m
 CONFIG_CHR_DEV_SG=y
 CONFIG_CHR_DEV_SCH=m
 CONFIG_SCSI_ENCLOSURE=m
-CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SPI_ATTRS=m
+CONFIG_SCSI_FC_ATTRS=y
 CONFIG_SCSI_SAS_LIBSAS=m
 CONFIG_SCSI_SRP_ATTRS=m
 CONFIG_ISCSI_TCP=m
-CONFIG_LIBFCOE=m
 CONFIG_SCSI_DEBUG=m
 CONFIG_ZFCP=y
 CONFIG_SCSI_VIRTIO=m
@@ -422,7 +414,6 @@ CONFIG_VIRTIO_NET=m
 CONFIG_NLMON=m
 CONFIG_VHOST_NET=m
 # CONFIG_NET_VENDOR_ARC is not set
-# CONFIG_NET_CADENCE is not set
 # CONFIG_NET_VENDOR_CHELSIO is not set
 # CONFIG_NET_VENDOR_INTEL is not set
 # CONFIG_NET_VENDOR_MARVELL is not set
@@ -476,13 +467,13 @@ CONFIG_JFS_FS=m
 CONFIG_JFS_POSIX_ACL=y
 CONFIG_JFS_SECURITY=y
 CONFIG_JFS_STATISTICS=y
-CONFIG_XFS_FS=m
+CONFIG_XFS_FS=y
 CONFIG_XFS_QUOTA=y
 CONFIG_XFS_POSIX_ACL=y
 CONFIG_XFS_RT=y
 CONFIG_GFS2_FS=m
 CONFIG_OCFS2_FS=m
-CONFIG_BTRFS_FS=m
+CONFIG_BTRFS_FS=y
 CONFIG_BTRFS_FS_POSIX_ACL=y
 CONFIG_NILFS2_FS=m
 CONFIG_FANOTIFY=y
@@ -550,8 +541,11 @@ CONFIG_TIMER_STATS=y
 CONFIG_RCU_TORTURE_TEST=m
 CONFIG_RCU_CPU_STALL_TIMEOUT=60
 CONFIG_LATENCYTOP=y
+CONFIG_SCHED_TRACER=y
+CONFIG_FTRACE_SYSCALLS=y
+CONFIG_STACK_TRACER=y
 CONFIG_BLK_DEV_IO_TRACE=y
-# CONFIG_KPROBE_EVENT is not set
+CONFIG_UPROBE_EVENT=y
 CONFIG_LKDTM=m
 CONFIG_PERCPU_TEST=m
 CONFIG_ATOMIC64_SELFTEST=y
@@ -618,12 +612,6 @@ CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=m
 CONFIG_X509_CERTIFICATE_PARSER=m
 CONFIG_CRC7=m
 CONFIG_CRC8=m
-CONFIG_XZ_DEC_X86=y
-CONFIG_XZ_DEC_POWERPC=y
-CONFIG_XZ_DEC_IA64=y
-CONFIG_XZ_DEC_ARM=y
-CONFIG_XZ_DEC_ARMTHUMB=y
-CONFIG_XZ_DEC_SPARC=y
 CONFIG_CORDIC=m
 CONFIG_CMM=m
 CONFIG_APPLDATA_BASE=y
diff --git a/arch/s390/configs/zfcpdump_defconfig b/arch/s390/configs/zfcpdump_defconfig
index e376789..9d63051 100644
--- a/arch/s390/configs/zfcpdump_defconfig
+++ b/arch/s390/configs/zfcpdump_defconfig
@@ -22,8 +22,8 @@ CONFIG_HZ_100=y
 CONFIG_CRASH_DUMP=y
 # CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS is not set
 # CONFIG_SECCOMP is not set
-# CONFIG_IUCV is not set
 CONFIG_NET=y
+# CONFIG_IUCV is not set
 CONFIG_ATM=y
 CONFIG_ATM_LANE=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
@@ -36,9 +36,9 @@ CONFIG_ENCLOSURE_SERVICES=y
 CONFIG_SCSI=y
 CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_ENCLOSURE=y
-CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
+CONFIG_SCSI_FC_ATTRS=y
 CONFIG_SCSI_SRP_ATTRS=y
 CONFIG_ZFCP=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
@@ -75,12 +75,6 @@ CONFIG_DEBUG_KERNEL=y
 CONFIG_RCU_CPU_STALL_TIMEOUT=60
 # CONFIG_FTRACE is not set
 # CONFIG_STRICT_DEVMEM is not set
-CONFIG_XZ_DEC_X86=y
-CONFIG_XZ_DEC_POWERPC=y
-CONFIG_XZ_DEC_IA64=y
-CONFIG_XZ_DEC_ARM=y
-CONFIG_XZ_DEC_ARMTHUMB=y
-CONFIG_XZ_DEC_SPARC=y
 # CONFIG_PFAULT is not set
 # CONFIG_S390_HYPFS_FS is not set
 # CONFIG_VIRTUALIZATION is not set
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index fab35a8..785c5f2 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -92,10 +92,10 @@ CONFIG_CHR_DEV_ST=y
 CONFIG_BLK_DEV_SR=y
 CONFIG_BLK_DEV_SR_VENDOR=y
 CONFIG_CHR_DEV_SG=y
-CONFIG_SCSI_MULTI_LUN=y
 CONFIG_SCSI_CONSTANTS=y
 CONFIG_SCSI_LOGGING=y
 CONFIG_SCSI_SCAN_ASYNC=y
+CONFIG_SCSI_FC_ATTRS=y
 CONFIG_ZFCP=y
 CONFIG_SCSI_VIRTIO=y
 CONFIG_NETDEVICES=y
@@ -164,14 +164,13 @@ CONFIG_CRYPTO_CMAC=m
 CONFIG_CRYPTO_XCBC=m
 CONFIG_CRYPTO_VMAC=m
 CONFIG_CRYPTO_CRC32=m
-CONFIG_CRYPTO_CRCT10DIF=m
 CONFIG_CRYPTO_MD4=m
 CONFIG_CRYPTO_MICHAEL_MIC=m
 CONFIG_CRYPTO_RMD128=m
 CONFIG_CRYPTO_RMD160=m
 CONFIG_CRYPTO_RMD256=m
 CONFIG_CRYPTO_RMD320=m
-CONFIG_CRYPTO_SHA256=m
+CONFIG_CRYPTO_SHA256=y
 CONFIG_CRYPTO_SHA512=m
 CONFIG_CRYPTO_TGR192=m
 CONFIG_CRYPTO_WP512=m
diff --git a/arch/s390/kernel/ftrace.c b/arch/s390/kernel/ftrace.c
index 51d14fe5..ca1cabb 100644
--- a/arch/s390/kernel/ftrace.c
+++ b/arch/s390/kernel/ftrace.c
@@ -121,6 +121,8 @@ unsigned long __kprobes prepare_ftrace_return(unsigned long parent,
 {
 	struct ftrace_graph_ent trace;
 
+	if (unlikely(ftrace_graph_is_dead()))
+		goto out;
 	if (unlikely(atomic_read(&current->tracing_graph_pause)))
 		goto out;
 	ip = (ip & PSW_ADDR_INSN) - MCOUNT_INSN_SIZE;
diff --git a/arch/s390/kernel/vdso32/clock_gettime.S b/arch/s390/kernel/vdso32/clock_gettime.S
index 48c2206..5eec9af 100644
--- a/arch/s390/kernel/vdso32/clock_gettime.S
+++ b/arch/s390/kernel/vdso32/clock_gettime.S
@@ -19,6 +19,7 @@
 	.type  __kernel_clock_gettime,@function
 __kernel_clock_gettime:
 	.cfi_startproc
+	ahi	%r15,-16
 	basr	%r5,0
 0:	al	%r5,21f-0b(%r5)			/* get &_vdso_data */
 	chi	%r2,__CLOCK_REALTIME_COARSE
@@ -34,8 +35,8 @@ __kernel_clock_gettime:
 1:	l	%r4,__VDSO_UPD_COUNT+4(%r5)	/* load update counter */
 	tml	%r4,0x0001			/* pending update ? loop */
 	jnz	1b
-	stcke	24(%r15)			/* Store TOD clock */
-	lm	%r0,%r1,25(%r15)
+	stcke	0(%r15)				/* Store TOD clock */
+	lm	%r0,%r1,1(%r15)
 	s	%r0,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,2f
@@ -70,6 +71,7 @@ __kernel_clock_gettime:
 8:	st	%r2,0(%r3)			/* store tp->tv_sec */
 	st	%r1,4(%r3)			/* store tp->tv_nsec */
 	lhi	%r2,0
+	ahi	%r15,16
 	br	%r14
 
 	/* CLOCK_MONOTONIC_COARSE */
@@ -96,8 +98,8 @@ __kernel_clock_gettime:
 11:	l	%r4,__VDSO_UPD_COUNT+4(%r5)	/* load update counter */
 	tml	%r4,0x0001			/* pending update ? loop */
 	jnz	11b
-	stcke	24(%r15)			/* Store TOD clock */
-	lm	%r0,%r1,25(%r15)
+	stcke	0(%r15)				/* Store TOD clock */
+	lm	%r0,%r1,1(%r15)
 	s	%r0,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,12f
@@ -132,11 +134,13 @@ __kernel_clock_gettime:
 17:	st	%r2,0(%r3)			/* store tp->tv_sec */
 	st	%r1,4(%r3)			/* store tp->tv_nsec */
 	lhi	%r2,0
+	ahi	%r15,16
 	br	%r14
 
 	/* Fallback to system call */
 19:	lhi	%r1,__NR_clock_gettime
 	svc	0
+	ahi	%r15,16
 	br	%r14
 
 20:	.long	1000000000
diff --git a/arch/s390/kernel/vdso32/gettimeofday.S b/arch/s390/kernel/vdso32/gettimeofday.S
index 60def5f..719de61 100644
--- a/arch/s390/kernel/vdso32/gettimeofday.S
+++ b/arch/s390/kernel/vdso32/gettimeofday.S
@@ -19,6 +19,7 @@
 	.type  __kernel_gettimeofday,@function
 __kernel_gettimeofday:
 	.cfi_startproc
+	ahi	%r15,-16
 	basr	%r5,0
 0:	al	%r5,13f-0b(%r5)			/* get &_vdso_data */
 1:	ltr	%r3,%r3				/* check if tz is NULL */
@@ -29,30 +30,30 @@ __kernel_gettimeofday:
 	l	%r4,__VDSO_UPD_COUNT+4(%r5)	/* load update counter */
 	tml	%r4,0x0001			/* pending update ? loop */
 	jnz	1b
-	stcke	24(%r15)			/* Store TOD clock */
-	lm	%r0,%r1,25(%r15)
+	stcke	0(%r15)				/* Store TOD clock */
+	lm	%r0,%r1,1(%r15)
 	s	%r0,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	sl	%r1,__VDSO_XTIME_STAMP+4(%r5)
 	brc	3,3f
 	ahi	%r0,-1
 3:	ms	%r0,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
-	st	%r0,24(%r15)
+	st	%r0,0(%r15)
 	l	%r0,__VDSO_TK_MULT(%r5)
 	ltr	%r1,%r1
 	mr	%r0,%r0
 	jnm	4f
 	a	%r0,__VDSO_TK_MULT(%r5)
-4:	al	%r0,24(%r15)
+4:	al	%r0,0(%r15)
 	al	%r0,__VDSO_XTIME_NSEC(%r5)	/*  + xtime */
 	al	%r1,__VDSO_XTIME_NSEC+4(%r5)
 	brc	12,5f
 	ahi	%r0,1
-5:	mvc	24(4,%r15),__VDSO_XTIME_SEC+4(%r5)
+5:	mvc	0(4,%r15),__VDSO_XTIME_SEC+4(%r5)
 	cl	%r4,__VDSO_UPD_COUNT+4(%r5)	/* check update counter */
 	jne	1b
 	l	%r4,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
 	srdl	%r0,0(%r4)			/*  >> tk->shift */
-	l	%r4,24(%r15)			/* get tv_sec from stack */
+	l	%r4,0(%r15)			/* get tv_sec from stack */
 	basr	%r5,0
 6:	ltr	%r0,%r0
 	jnz	7f
@@ -71,6 +72,7 @@ __kernel_gettimeofday:
 9:	srl	%r0,6
 	st	%r0,4(%r2)			/* store tv->tv_usec */
 10:	slr	%r2,%r2
+	ahi	%r15,16
 	br	%r14
 11:	.long	1000000000
 12:	.long	274877907
diff --git a/arch/s390/kernel/vdso64/clock_gettime.S b/arch/s390/kernel/vdso64/clock_gettime.S
index 9d9761f..7699e73 100644
--- a/arch/s390/kernel/vdso64/clock_gettime.S
+++ b/arch/s390/kernel/vdso64/clock_gettime.S
@@ -19,6 +19,7 @@
 	.type  __kernel_clock_gettime,@function
 __kernel_clock_gettime:
 	.cfi_startproc
+	aghi	%r15,-16
 	larl	%r5,_vdso_data
 	cghi	%r2,__CLOCK_REALTIME_COARSE
 	je	4f
@@ -37,10 +38,10 @@ __kernel_clock_gettime:
 0:	lg	%r4,__VDSO_UPD_COUNT(%r5)	/* load update counter */
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	0b
-	stcke	48(%r15)			/* Store TOD clock */
+	stcke	0(%r15)				/* Store TOD clock */
 	lgf	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
 	lg	%r0,__VDSO_WTOM_SEC(%r5)
-	lg	%r1,49(%r15)
+	lg	%r1,1(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
 	alg	%r1,__VDSO_WTOM_NSEC(%r5)
@@ -56,6 +57,7 @@ __kernel_clock_gettime:
 2:	stg	%r0,0(%r3)			/* store tp->tv_sec */
 	stg	%r1,8(%r3)			/* store tp->tv_nsec */
 	lghi	%r2,0
+	aghi	%r15,16
 	br	%r14
 
 	/* CLOCK_MONOTONIC_COARSE */
@@ -82,9 +84,9 @@ __kernel_clock_gettime:
 5:	lg	%r4,__VDSO_UPD_COUNT(%r5)	/* load update counter */
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	5b
-	stcke	48(%r15)			/* Store TOD clock */
+	stcke	0(%r15)				/* Store TOD clock */
 	lgf	%r2,__VDSO_TK_SHIFT(%r5)	/* Timekeeper shift */
-	lg	%r1,49(%r15)
+	lg	%r1,1(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
 	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
@@ -101,6 +103,7 @@ __kernel_clock_gettime:
 7:	stg	%r0,0(%r3)			/* store tp->tv_sec */
 	stg	%r1,8(%r3)			/* store tp->tv_nsec */
 	lghi	%r2,0
+	aghi	%r15,16
 	br	%r14
 
 	/* CLOCK_THREAD_CPUTIME_ID for this thread */
@@ -134,11 +137,13 @@ __kernel_clock_gettime:
 	slgr	%r4,%r0				/* r4 = tv_nsec */
 	stg	%r4,8(%r3)
 	lghi	%r2,0
+	aghi	%r15,16
 	br	%r14
 
 	/* Fallback to system call */
 12:	lghi	%r1,__NR_clock_gettime
 	svc	0
+	aghi	%r15,16
 	br	%r14
 
 13:	.quad	1000000000
diff --git a/arch/s390/kernel/vdso64/gettimeofday.S b/arch/s390/kernel/vdso64/gettimeofday.S
index 7a34499..6ce4670 100644
--- a/arch/s390/kernel/vdso64/gettimeofday.S
+++ b/arch/s390/kernel/vdso64/gettimeofday.S
@@ -19,6 +19,7 @@
 	.type  __kernel_gettimeofday,@function
 __kernel_gettimeofday:
 	.cfi_startproc
+	aghi	%r15,-16
 	larl	%r5,_vdso_data
 0:	ltgr	%r3,%r3				/* check if tz is NULL */
 	je	1f
@@ -28,8 +29,8 @@ __kernel_gettimeofday:
 	lg	%r4,__VDSO_UPD_COUNT(%r5)	/* load update counter */
 	tmll	%r4,0x0001			/* pending update ? loop */
 	jnz	0b
-	stcke	48(%r15)			/* Store TOD clock */
-	lg	%r1,49(%r15)
+	stcke	0(%r15)				/* Store TOD clock */
+	lg	%r1,1(%r15)
 	sg	%r1,__VDSO_XTIME_STAMP(%r5)	/* TOD - cycle_last */
 	msgf	%r1,__VDSO_TK_MULT(%r5)		/*  * tk->mult */
 	alg	%r1,__VDSO_XTIME_NSEC(%r5)	/*  + tk->xtime_nsec */
@@ -50,6 +51,7 @@ __kernel_gettimeofday:
 	srlg	%r0,%r0,6
 	stg	%r0,8(%r2)			/* store tv->tv_usec */
 4:	lghi	%r2,0
+	aghi	%r15,16
 	br	%r14
 5:	.quad	1000000000
 	.long	274877907
diff --git a/arch/s390/kernel/vtime.c b/arch/s390/kernel/vtime.c
index 416f2a3..7f0089d 100644
--- a/arch/s390/kernel/vtime.c
+++ b/arch/s390/kernel/vtime.c
@@ -66,7 +66,11 @@ static int do_account_vtime(struct task_struct *tsk, int hardirq_offset)
 	clock = S390_lowcore.last_update_clock;
 	asm volatile(
 		"	stpt	%0\n"	/* Store current cpu timer value */
+#ifdef CONFIG_HAVE_MARCH_Z9_109_FEATURES
+		"	stckf	%1"	/* Store current tod clock value */
+#else
 		"	stck	%1"	/* Store current tod clock value */
+#endif
 		: "=m" (S390_lowcore.last_update_timer),
 		  "=m" (S390_lowcore.last_update_clock));
 	S390_lowcore.system_timer += timer - S390_lowcore.last_update_timer;

