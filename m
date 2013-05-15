Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab3EODNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 23:13:44 -0400
Received: from mga02.intel.com ([134.134.136.20]:28690 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932241Ab3EODNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 23:13:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,675,1363158000"; 
   d="scan'208";a="313741930"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        "Signed-off-by: Gang Wei" <gang.wei@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Subject: [PATCH v3 2/3] driver: provide sysfs interfaces to access TXT config space
Date: Wed, 15 May 2013 11:04:33 +0800
Message-Id: <1368587074-12712-3-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368587074-12712-1-git-send-email-qiaowei.ren@intel.com>
References: <1368587074-12712-1-git-send-email-qiaowei.ren@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These interfaces are located in /sys/devices/platform/intel_txt/config,
and including totally 37 files, providing access to Intel TXT
configuration registers.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
Signed-off-by: Xiaoyan Zhang <xiaoyan.zhang@intel.com>
Signed-off-by: Gang Wei <gang.wei@intel.com>
---
 Documentation/ABI/testing/sysfs-platform-intel-txt |  309 ++++++
 drivers/platform/x86/intel_txt/Makefile            |    2 +-
 drivers/platform/x86/intel_txt/txt-config.c        | 1029 ++++++++++++++++++++
 drivers/platform/x86/intel_txt/txt-config.h        |  138 +++
 drivers/platform/x86/intel_txt/txt-sysfs.c         |   12 +
 5 files changed, 1489 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-intel-txt
 create mode 100644 drivers/platform/x86/intel_txt/txt-config.c
 create mode 100644 drivers/platform/x86/intel_txt/txt-config.h

diff --git a/Documentation/ABI/testing/sysfs-platform-intel-txt b/Documentation/ABI/testing/sysfs-platform-intel-txt
new file mode 100644
index 0000000..fa20a9f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-platform-intel-txt
@@ -0,0 +1,309 @@
+What:		/sys/devices/platform/intel_txt/config/
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The config/ directory exposes Intel TXT configuration
+		registers. These registers are a subset of chipset registers.
+		They are mapped into two regions of memory, representing the
+		public and private configuration spaces.
+
+		Registers in the private space can only be accessed after a
+		measured environment has been established and before the
+		TXT.CMD.CLOSE-PRIVATE command has been issued. The public space
+		registers are available before, during and after a measured
+		environment launch. All registers are available within both
+		spaces, though with different permissions.
+
+What:		/sys/devices/platform/intel_txt/config/STS_raw
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.STS is the general status register. This read-only register
+		is used by AC modules and the MLE to get the status of various
+		Intel TXT features.
+
+What:		/sys/devices/platform/intel_txt/config/STS_enter_done
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	The chipset sets SENTER.DONE.STS status bit when it sees all
+		of the threads have done an TXT.CYC.SENTER-ACK.
+
+What:		/sys/devices/platform/intel_txt/config/STS_sexit_done
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	SEXIT.DONE.STS status bit is set when all of the bits in the
+		TXT.THREADS.JOIN register are clear. Thus, this bit will be
+		set immediately after reset.
+
+What:		/sys/devices/platform/intel_txt/config/STS_mem_config_lock
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	MEM-CONFIG-LOCK.STS status bit will be set to 1 when the memory
+		configuration has been locked. Cleared by
+		TXT.CMD.UNLOCK.MEMCONFIG or by a system reset.
+
+What:		/sys/devices/platform/intel_txt/config/STS_private_open
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	PRIVATE-OPEN.STS status bit will be set to 1 when
+		TXT.CMD.OPEN-PRIVATE is performed. Cleared by
+		TXT.CMD.CLOSE-PRIVATE or by a system reset.
+
+What:		/sys/devices/platform/intel_txt/config/STS_locality_1_open
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.LOCALITY1.OPEN.STS status bit is set when the
+		TXT.CMD.OPEN.LOCALITY1 command is seen by the chipset.
+		It is cleared on reset or when TXT.CMD.CLOSE.LOCALITY1 is seen.
+
+What:		/sys/devices/platform/intel_txt/config/STS_locality_2_open
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.LOCALITY2.OPEN.STS status bit is set when either the
+		TXT.CMD.OPEN.LOCALITY2 command or the TXT.CMD.OPEN.PRIVATE
+		is seen by the chipset. It is cleared on reset, when either
+		TXT.CMD.CLOSE.LOCALITY2 or TXT.CMD.CLOSE.PRIVATE is seen,
+		and by the GETSEC[SEXIT] instruction.
+
+What:		/sys/devices/platform/intel_txt/config/ESTS_raw
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.ESTS is the error status register which contains status
+		information associated with various error conditions. The
+		contents of this read-only register are preserved across
+		soft resets.
+
+What:		/sys/devices/platform/intel_txt/config/ESTS_intel_txt_reset
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT_RESET.STS bit is set to '1' to indicate that an event
+		occurred which may prevent the proper use of TXT (possibly
+		including a TXT reset).
+
+What:		/sys/devices/platform/intel_txt/config/ERRORCODE
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.ERRORCODE register holds the Intel TXT shutdown error code.
+		A soft reset does not clear the contents of this register;
+		a hard reset/power cycle will clear the contents. This was
+		formerly labeled the TXT.CRASH register.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_RESET
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	A write to TXT.CMD.RESET register causes a system reset.
+		This is performed by the processor as part of an Intel TXT
+		shutdown, after writing to the TXT.ERRORCODE register.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_CLOSE_PRIVATE
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	A write to TXT.CMD.CLOSE-PRIVATE register causes the Intel
+		TXT-capable chipset private configuration space to be locked.
+		Locality 2 will also be closed. Once locked, conventional
+		memory read/write operations can no longer be used to access
+		these registers. The private configuration space can only be
+		opened for the MLE by successfully executing GETSEC[SENTER].
+
+What:		/sys/devices/platform/intel_txt/config/VER_FSBIF
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.VER.FSBIF register identifies whether the chipset is
+		debug or release fused.
+
+What:		/sys/devices/platform/intel_txt/config/DIDVID_raw
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.DIDVID register contains the vendor, device, and revision
+		IDs for the memory controller or chipset.
+
+What:		/sys/devices/platform/intel_txt/config/DIDVID_vendor_id
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Vendor ID.
+
+What:		/sys/devices/platform/intel_txt/config/DIDVID_device_id
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Device ID.
+
+What:		/sys/devices/platform/intel_txt/config/DIDVID_revision_id
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Revision ID.
+
+What:		/sys/devices/platform/intel_txt/config/VER_QPIIF
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.VER.QPIIF register identifies whether the memory
+		controller or chipset is debug or release fused.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_UNLOCK_MEM_CONFIG
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	When TXT.CMD.UNLOCK-MEM-CONFIG command is invoked, the
+		chipset unlocks all memory configuration registers.
+
+What:		/sys/devices/platform/intel_txt/config/SINIT_BASE
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.SINIT.BASE register contains the physical base address
+		of the memory region set aside by the BIOS for loading an
+		SINIT AC module. If BIOS has provided an SINIT AC module,
+		it will be located at this address. System software that
+		provides an SINIT AC module must store it to this location.
+
+What:		/sys/devices/platform/intel_txt/config/SINIT_SIZE
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.SINIT.SIZE register contains the size (in bytes) of
+		the memory region set aside by the BIOS for loading an
+		SINIT AC module. This register is initialized by the BIOS.
+
+What:		/sys/devices/platform/intel_txt/config/MLE_JOIN
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Holds a physical address pointer to the base of the join
+		data structure used to initialize RLPs in response to
+		GETSEC[WAKEUP].
+
+What:		/sys/devices/platform/intel_txt/config/HEAP_BASE
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.HEAP.BASE register contains the physical base address
+		of the Intel TXT Heap memory region. The BIOS initializes
+		this register.
+
+What:		/sys/devices/platform/intel_txt/config/HEAP_SIZE
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.HEAP.SIZE register contains the size (in bytes) of the
+		Intel TXT Heap memory region. The BIOS initializes this
+		register.
+
+What:		/sys/devices/platform/intel_txt/config/DPR_raw
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	TXT.DPR register defines the DMA Protected Range of memory
+		in which the TXT heap and SINIT region are located.
+
+What:		/sys/devices/platform/intel_txt/config/DPR_lock
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Bits 19:0 are locked down in this register when this Lock
+		bit is set.
+
+What:		/sys/devices/platform/intel_txt/config/DPR_top
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Top address + 1 of DPR.
+
+What:		/sys/devices/platform/intel_txt/config/DPR_size
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	This is the size of memory, in MB, that will be protected from
+		DMA accesses. A value of 0x00 in this field means no additional
+		memory is protected.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_OPEN_LOCALITY1
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Writing to this TXT.CMD.OPEN.LOCALITY1 register "opens" the
+		TPM locality 1 address range, enabling decoding by the chipset
+		and thus access to the TPM.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_CLOSE_LOCALITY1
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Writing to this TXT.CMD.CLOSE.LOCALITY1 register "closes" the
+		TPM locality 1 address range, disabling decoding by the chipset
+		and thus access to the TPM.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_OPEN_LOCALITY2
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Writing to this TXT.CMD.OPEN.LOCALITY2 register "opens" the
+		TPM locality 2 address range, enabling decoding by the chipset
+		and thus access to the TPM.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_CLOSE_LOCALITY2
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Writing to this TXT.CMD.CLOSE.LOCALITY2 register "closes" the
+		TPM locality 2 address range, disabling decoding by the chipset
+		and thus access to the TPM.
+
+What:		/sys/devices/platform/intel_txt/config/PUBLIC_KEY
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	This read-only TXT.PUBLIC.KEY register contains the hash of
+		the public key used for the verification of AC Modules.
+		The size, hash algorithm, and value are specific to the memory
+		controller or chipset.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_SECRETS
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Writing to this TXT.CMD.SECRETS register indicates to the
+		chipset that there are secrets in memory. The chipset tracks
+		this fact with a sticky bit. If the platform reboots with this
+		sticky bit set the BIOS AC module (or BIOS on multiprocessor
+		TXT systems) will scrub memory. The chipset also uses this
+		bit to detect invalid sleep state transitions. If software
+		tries to transition to S3, S4, or S5 while secrets are in
+		memory then the chipset will reset the system.
+
+What:		/sys/devices/platform/intel_txt/config/CMD_NO_SECRETS
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	Writing to this TXT.CMD.NO-SECRETS register indicates there
+		are no secrets in memory.
+
+What:		/sys/devices/platform/intel_txt/config/E2STS_raw
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	This TXT.E2STS register is used to read the status associated
+		with various errors that might be detected.
+
+What:		/sys/devices/platform/intel_txt/config/E2STS_secrets
+Date:		May 2013
+KernelVersion:	3.9
+Contact:	"Qiaowei Ren" <qiaowei.ren@intel.com>
+Description:	0 = Chipset acknowledges that no secrets are in memory.
+		1 = Chipset believes that secrets are in memory and will
+		provide reset protection.
diff --git a/drivers/platform/x86/intel_txt/Makefile b/drivers/platform/x86/intel_txt/Makefile
index a130308..8d5258e 100644
--- a/drivers/platform/x86/intel_txt/Makefile
+++ b/drivers/platform/x86/intel_txt/Makefile
@@ -2,4 +2,4 @@
 # Makefile for the intel TXT drivers.
 #
 obj-$(CONFIG_INTEL_TXT_DRIVER) += intel_txt.o
-intel_txt-y := txt-sysfs.o
+intel_txt-y := txt-sysfs.o txt-config.o
diff --git a/drivers/platform/x86/intel_txt/txt-config.c b/drivers/platform/x86/intel_txt/txt-config.c
new file mode 100644
index 0000000..c16b7e7
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/txt-config.c
@@ -0,0 +1,1029 @@
+/*
+ * txt-config.c
+ *
+ * Totally 37 sysfs files with owner root, each related with a register.
+ *
+ * Intel TXT configuration registers are a subset of chipset registers.
+ * These registers are mapped into two regions of memory, representing
+ * the public and private configuration spaces.
+ *
+ * STS_raw		-r--r--r--	ERRORCODE		-rw-rw-r--
+ * STS_senter_done	-r--r--r--	STS_sexit_done		-r--r--r--
+ * STS_mem_config_lock	-r--r--r--	STS_private_open	-r--r--r--
+ * STS_locality_1_open	-r--r--r--	STS_locality_2_open	-r--r--r--
+ * ESTS_raw		-r--r--r--	ESTS_txt_reset		-r--r--r--
+ * E2STS_raw		-r--r--r--	E2STS_secrets		-rw-rw-r--
+ * VER_FSBIF		-r--r--r--	VER_QPIIF		-r--r--r--
+ * DIDVID_raw		-r--r--r--	DIDVID_vendor_id	-r--r--r--
+ * DIDVID_device_id	-r--r--r--	DIDVID_revision_id	-r--r--r--
+ * SINIT_BASE		-rw-rw-r--	SINIT_SIZE		-rw-rw-r--
+ * HEAP_BASE		-rw-rw-r--	HEAP_SIZE		-rw-rw-r--
+ * PUBLIC_KEY		-r--r--r--	MLE_JOIN		-rw-rw-r--
+ * DPR_raw		-rw-rw-r--	DPR_lock		-rw-rw-r--
+ * DPR_top		-rw-rw-r--	DPR_size		-rw-rw-r--
+ * CMD_RESET		--w--w----	CMD_CLOSE_PRIVATE	--w--w----
+ * CMD_SECRETS		--w--w----	CMD_NO_SECRETS		--w--w----
+ * CMD_OPEN_LOCALITY1	--w--w----	CMD_OPEN_LOCALITY2	--w--w----
+ * CMD_CLOSE_LOCALITY1	--w--w----	CMD_CLOSE_LOCALITY2	--w--w----
+ * CMD_UNLOCK_MEM_CONFIG	--w--w----
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/sysfs.h>
+#include <linux/io.h>
+#include <linux/stat.h>
+
+#include "txt-config.h"
+
+static ssize_t print_hex(char *buf, void *start, size_t len)
+{
+	char *str = buf;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		str += scnprintf(str, PAGE_SIZE, "%02x ", *(uint8_t *)start);
+		start++;
+		if ((i + 1) % 16 == 0)
+			str += scnprintf(str, PAGE_SIZE, "\n");
+	}
+
+	return str - buf;
+}
+
+static ssize_t show_config(char *buf, u32 offset)
+{
+	void __iomem *config;
+	int retval;
+
+	config = ioremap_nocache(TXT_PUB_CONFIG_REGS_BASE,
+				 TXT_CONFIG_REGS_SIZE);
+	if (config == NULL)
+		return -ENOMEM;
+
+	switch (offset) {
+	case off_STS_raw:
+	{
+		txt_sts_t sts;
+
+		sts._raw = read_txt_config_reg(config, TXTCR_STS);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%08llx\n", sts._raw);
+		break;
+	}
+
+	case off_STS_senter_done:
+	{
+		txt_sts_t sts;
+
+		sts._raw = read_txt_config_reg(config, TXTCR_STS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n", sts.senter_done_sts);
+		break;
+	}
+
+	case off_STS_sexit_done:
+	{
+		txt_sts_t sts;
+
+		sts._raw = read_txt_config_reg(config, TXTCR_STS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n", sts.sexit_done_sts);
+		break;
+	}
+
+	case off_STS_mem_config_lock:
+	{
+		txt_sts_t sts;
+
+		sts._raw = read_txt_config_reg(config, TXTCR_STS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       sts.mem_config_lock_sts);
+		break;
+	}
+
+	case off_STS_private_open:
+	{
+		txt_sts_t sts;
+
+		sts._raw = read_txt_config_reg(config, TXTCR_STS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       sts.private_open_sts);
+		break;
+	}
+
+	case off_STS_locality_1_open:
+	{
+		txt_sts_t sts;
+
+		sts._raw = read_txt_config_reg(config, TXTCR_STS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       sts.locality_1_open_sts);
+		break;
+	}
+
+	case off_STS_locality_2_open:
+	{
+		txt_sts_t sts;
+
+		sts._raw = read_txt_config_reg(config, TXTCR_STS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n",
+			       sts.locality_2_open_sts);
+		break;
+	}
+
+	case off_ERRORCODE:
+		retval = scnprintf(buf, PAGE_SIZE, "0x%08llx\n",
+			       read_txt_config_reg(config, TXTCR_ERRORCODE));
+		break;
+
+	case off_ESTS_raw:
+	{
+		txt_ests_t ests;
+
+		ests._raw = read_txt_config_reg(config, TXTCR_ESTS);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%02llx\n", ests._raw);
+		break;
+	}
+
+	case off_ESTS_txt_reset:
+	{
+		txt_ests_t ests;
+
+		ests._raw = read_txt_config_reg(config, TXTCR_ESTS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n", ests.txt_reset_sts);
+		break;
+	}
+
+	case off_E2STS_raw:
+	{
+		txt_e2sts_t e2sts;
+
+		e2sts._raw = read_txt_config_reg(config, TXTCR_E2STS);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%016llx\n", e2sts._raw);
+		break;
+	}
+
+	case off_E2STS_secrets:
+	{
+		txt_e2sts_t e2sts;
+
+		e2sts._raw = read_txt_config_reg(config, TXTCR_E2STS);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n", e2sts.secrets_sts);
+		break;
+	}
+
+	case off_VER_FSBIF:
+		retval = scnprintf(buf, PAGE_SIZE, "0x%016llx\n",
+			       read_txt_config_reg(config, TXTCR_VER_FSBIF));
+		break;
+
+	case off_VER_QPIIF:
+		retval = scnprintf(buf, PAGE_SIZE, "0x%016llx\n",
+			       read_txt_config_reg(config, TXTCR_VER_QPIIF));
+		break;
+
+	case off_DIDVID_raw:
+	{
+		txt_didvid_t didvid;
+
+		didvid._raw = read_txt_config_reg(config, TXTCR_DIDVID);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%016llx\n", didvid._raw);
+		break;
+	}
+
+	case off_DIDVID_vendor_id:
+	{
+		txt_didvid_t didvid;
+
+		didvid._raw = read_txt_config_reg(config, TXTCR_DIDVID);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%x\n", didvid.vendor_id);
+		break;
+	}
+
+	case off_DIDVID_device_id:
+	{
+		txt_didvid_t didvid;
+
+		didvid._raw = read_txt_config_reg(config, TXTCR_DIDVID);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%x\n", didvid.device_id);
+		break;
+	}
+
+	case off_DIDVID_revision_id:
+	{
+		txt_didvid_t didvid;
+
+		didvid._raw = read_txt_config_reg(config, TXTCR_DIDVID);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%x\n",
+				didvid.revision_id);
+		break;
+	}
+
+	case off_SINIT_BASE:
+		retval = scnprintf(buf, PAGE_SIZE, "0x%08llx\n",
+			       read_txt_config_reg(config, TXTCR_SINIT_BASE));
+		break;
+
+	case off_SINIT_SIZE:
+		retval = scnprintf(buf, PAGE_SIZE, "%lluB (0x%llx)\n",
+			       read_txt_config_reg(config, TXTCR_SINIT_SIZE),
+			       read_txt_config_reg(config, TXTCR_SINIT_SIZE));
+		break;
+
+	case off_HEAP_BASE:
+		retval = scnprintf(buf, PAGE_SIZE, "0x%08llx\n",
+			       read_txt_config_reg(config, TXTCR_HEAP_BASE));
+		break;
+
+	case off_HEAP_SIZE:
+		retval = scnprintf(buf, PAGE_SIZE, "%lluB (0x%llx)\n",
+			       read_txt_config_reg(config, TXTCR_HEAP_SIZE),
+			       read_txt_config_reg(config, TXTCR_HEAP_SIZE));
+		break;
+
+	case off_PUBLIC_KEY:
+	{
+		uint8_t key[256/8];
+		unsigned int i = 0;
+
+		do {
+			*(uint64_t *)&key[i] = read_txt_config_reg(config,
+						TXTCR_PUBLIC_KEY + i);
+			i += sizeof(uint64_t);
+		} while (i < sizeof(key));
+
+		retval = print_hex(buf, key, sizeof(key));
+		break;
+	}
+
+	case off_MLE_JOIN:
+		retval = scnprintf(buf, PAGE_SIZE, "0x%08llx\n",
+			       read_txt_config_reg(config, TXTCR_MLE_JOIN));
+		break;
+
+	case off_DPR_raw:
+	{
+		txt_dpr_t dpr;
+
+		dpr._raw = read_txt_config_reg(config, TXTCR_DPR);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%016llx\n", dpr._raw);
+		break;
+	}
+
+	case off_DPR_lock:
+	{
+		txt_dpr_t dpr;
+
+		dpr._raw = read_txt_config_reg(config, TXTCR_DPR);
+		retval = scnprintf(buf, PAGE_SIZE, "%d\n", dpr.lock);
+		break;
+	}
+
+	case off_DPR_top:
+	{
+		txt_dpr_t dpr;
+
+		dpr._raw = read_txt_config_reg(config, TXTCR_DPR);
+		retval = scnprintf(buf, PAGE_SIZE, "0x%08x\n", dpr.top << 20);
+		break;
+	}
+
+	case off_DPR_size:
+	{
+		txt_dpr_t dpr;
+
+		dpr._raw = read_txt_config_reg(config, TXTCR_DPR);
+		retval = scnprintf(buf, PAGE_SIZE, "%uMB (%uB)\n",
+			       dpr.size, dpr.size*1024*1024);
+		break;
+	}
+
+	default:
+		retval = -EINVAL;
+	}
+
+	iounmap(config);
+	return retval;
+}
+
+static ssize_t store_pub_config(const char *buf, u32 offset)
+{
+	void __iomem *config;
+	long value;
+
+	config = ioremap_nocache(TXT_PUB_CONFIG_REGS_BASE,
+				 TXT_CONFIG_REGS_SIZE);
+	if (config == NULL)
+		return -ENOMEM;
+
+	if (kstrtol(buf, 0, &value))
+		return -EINVAL;
+
+	switch (offset) {
+	case off_SINIT_BASE:
+		write_txt_config_reg(config, TXTCR_SINIT_BASE, value);
+		break;
+
+	case off_SINIT_SIZE:
+		write_txt_config_reg(config, TXTCR_SINIT_SIZE, value);
+		break;
+
+	case off_HEAP_BASE:
+		write_txt_config_reg(config, TXTCR_HEAP_BASE, value);
+		break;
+
+	case off_HEAP_SIZE:
+		write_txt_config_reg(config, TXTCR_HEAP_SIZE, value);
+		break;
+
+	case off_MLE_JOIN:
+		write_txt_config_reg(config, TXTCR_MLE_JOIN, value);
+		break;
+
+	case off_DPR_raw:
+		write_txt_config_reg(config, TXTCR_DPR, value);
+		break;
+
+	case off_DPR_lock:
+	{
+		txt_dpr_t dpr;
+
+		dpr._raw = read_txt_config_reg(config, TXTCR_DPR);
+		dpr.lock = value;
+
+		write_txt_config_reg(config, TXTCR_DPR, dpr._raw);
+		break;
+	}
+
+	case off_DPR_top:
+	{
+		txt_dpr_t dpr;
+
+		dpr._raw = read_txt_config_reg(config, TXTCR_DPR);
+		dpr.top = value;
+
+		write_txt_config_reg(config, TXTCR_DPR, dpr._raw);
+		break;
+	}
+
+	case off_DPR_size:
+	{
+		txt_dpr_t dpr;
+
+		dpr._raw = read_txt_config_reg(config, TXTCR_DPR);
+		dpr.size = value;
+
+		write_txt_config_reg(config, TXTCR_DPR, dpr._raw);
+		break;
+	}
+
+	default:
+		return -EINVAL;
+	}
+
+	iounmap(config);
+	return 0;
+}
+
+static ssize_t store_priv_config(const char *buf, u32 offset)
+{
+	void __iomem *config;
+	long value;
+	int retval = 0;
+
+	config = ioremap_nocache(TXT_PRIV_CONFIG_REGS_BASE,
+				 TXT_CONFIG_REGS_SIZE);
+	if (config == NULL)
+		return -ENOMEM;
+
+	if (kstrtol(buf, 0, &value))
+		return -EINVAL;
+
+	if (offset != off_ERRORCODE && offset != off_E2STS_secrets) {
+		if (value != 0 && value != 1) {
+			retval = -EINVAL;
+			goto out;
+		}
+	}
+
+	switch (offset) {
+	case off_ERRORCODE:
+		write_txt_config_reg(config, TXTCR_ERRORCODE, value);
+		break;
+
+	case off_E2STS_secrets:
+		write_txt_config_reg(config, TXTCR_E2STS, value);
+		break;
+
+	case off_CMD_RESET:
+		write_txt_config_reg(config, TXTCR_CMD_RESET, value);
+		break;
+
+	case off_CMD_CLOSE_PRIVATE:
+		write_txt_config_reg(config, TXTCR_CMD_CLOSE_PRIVATE, value);
+		break;
+
+	case off_CMD_SECRETS:
+		write_txt_config_reg(config, TXTCR_CMD_SECRETS, value);
+		break;
+
+	case off_CMD_NO_SECRETS:
+		write_txt_config_reg(config, TXTCR_CMD_NO_SECRETS, value);
+		break;
+
+	case off_CMD_OPEN_LOCALITY1:
+		write_txt_config_reg(config, TXTCR_CMD_OPEN_LOCALITY1, value);
+		break;
+
+	case off_CMD_OPEN_LOCALITY2:
+		write_txt_config_reg(config, TXTCR_CMD_OPEN_LOCALITY2, value);
+		break;
+
+	case off_CMD_CLOSE_LOCALITY1:
+		write_txt_config_reg(config, TXTCR_CMD_CLOSE_LOCALITY1,
+				     value);
+		break;
+
+	case off_CMD_CLOSE_LOCALITY2:
+		write_txt_config_reg(config, TXTCR_CMD_CLOSE_LOCALITY2,
+				     value);
+		break;
+
+	case off_CMD_UNLOCK_MEM_CONFIG:
+		write_txt_config_reg(config, TXTCR_CMD_UNLOCK_MEM_CONFIG,
+				     value);
+		break;
+
+	default:
+		retval = -EINVAL;
+	}
+
+out:
+	iounmap(config);
+	return retval;
+}
+
+static ssize_t txt_show_STS_raw(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_config(buf, off_STS_raw);
+}
+static DEVICE_ATTR(STS_raw, S_IRUGO, txt_show_STS_raw, NULL);
+
+static ssize_t txt_show_STS_senter_done(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	return show_config(buf, off_STS_senter_done);
+}
+static DEVICE_ATTR(STS_senter_done, S_IRUGO, txt_show_STS_senter_done, NULL);
+
+static ssize_t txt_show_STS_sexit_done(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return show_config(buf, off_STS_sexit_done);
+}
+static DEVICE_ATTR(STS_sexit_done, S_IRUGO, txt_show_STS_sexit_done, NULL);
+
+static ssize_t txt_show_STS_mem_config_lock(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	return show_config(buf, off_STS_mem_config_lock);
+}
+static DEVICE_ATTR(STS_mem_config_lock, S_IRUGO,
+		   txt_show_STS_mem_config_lock, NULL);
+
+static ssize_t txt_show_STS_private_open(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return show_config(buf, off_STS_private_open);
+}
+static DEVICE_ATTR(STS_private_open, S_IRUGO,
+		   txt_show_STS_private_open, NULL);
+
+static ssize_t txt_show_STS_locality_1_open(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	return show_config(buf, off_STS_locality_1_open);
+}
+static DEVICE_ATTR(STS_locality_1_open, S_IRUGO,
+		   txt_show_STS_locality_1_open, NULL);
+
+static ssize_t txt_show_STS_locality_2_open(struct device *dev,
+					    struct device_attribute *attr,
+					    char *buf)
+{
+	return show_config(buf, off_STS_locality_2_open);
+}
+static DEVICE_ATTR(STS_locality_2_open, S_IRUGO,
+		   txt_show_STS_locality_2_open, NULL);
+
+static ssize_t txt_show_ERRORCODE(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	return show_config(buf, off_ERRORCODE);
+}
+
+static ssize_t txt_store_ERRORCODE(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_ERRORCODE);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(ERRORCODE, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_ERRORCODE, txt_store_ERRORCODE);
+
+static ssize_t txt_show_ESTS_raw(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	return show_config(buf, off_ESTS_raw);
+}
+static DEVICE_ATTR(ESTS_raw, S_IRUGO, txt_show_ESTS_raw, NULL);
+
+static ssize_t txt_show_ESTS_txt_reset(struct device *dev,
+				       struct device_attribute *attr,
+				       char *buf)
+{
+	return show_config(buf, off_ESTS_txt_reset);
+}
+static DEVICE_ATTR(ESTS_txt_reset, S_IRUGO, txt_show_ESTS_txt_reset, NULL);
+
+static ssize_t txt_show_E2STS_raw(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	return show_config(buf, off_E2STS_raw);
+}
+static DEVICE_ATTR(E2STS_raw, S_IRUGO, txt_show_E2STS_raw, NULL);
+
+static ssize_t txt_show_E2STS_secrets(struct device *dev,
+				      struct device_attribute *attr,
+				      char *buf)
+{
+	return show_config(buf, off_E2STS_secrets);
+}
+
+static ssize_t txt_store_E2STS_secrets(struct device *dev,
+				       struct device_attribute *attr,
+				       const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_E2STS_secrets);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(E2STS_secrets, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_E2STS_secrets, txt_store_E2STS_secrets);
+
+static ssize_t txt_show_VER_FSBIF(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	return show_config(buf, off_VER_FSBIF);
+}
+static DEVICE_ATTR(VER_FSBIF, S_IRUGO, txt_show_VER_FSBIF, NULL);
+
+static ssize_t txt_show_VER_QPIIF(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_config(buf, off_VER_QPIIF);
+}
+static DEVICE_ATTR(VER_QPIIF, S_IRUGO, txt_show_VER_QPIIF, NULL);
+
+static ssize_t txt_show_DIDVID_raw(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	return show_config(buf, off_DIDVID_raw);
+}
+static DEVICE_ATTR(DIDVID_raw, S_IRUGO, txt_show_DIDVID_raw, NULL);
+
+static ssize_t txt_show_DIDVID_vendor_id(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return show_config(buf, off_DIDVID_vendor_id);
+}
+static DEVICE_ATTR(DIDVID_vendor_id, S_IRUGO,
+		   txt_show_DIDVID_vendor_id, NULL);
+
+static ssize_t txt_show_DIDVID_device_id(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return show_config(buf, off_DIDVID_device_id);
+}
+static DEVICE_ATTR(DIDVID_device_id, S_IRUGO,
+		   txt_show_DIDVID_device_id, NULL);
+
+static ssize_t txt_show_DIDVID_revision_id(struct device *dev,
+					   struct device_attribute *attr,
+					   char *buf)
+{
+	return show_config(buf, off_DIDVID_revision_id);
+}
+static DEVICE_ATTR(DIDVID_revision_id, S_IRUGO,
+		   txt_show_DIDVID_revision_id, NULL);
+
+static ssize_t txt_show_SINIT_BASE(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return show_config(buf, off_SINIT_BASE);
+}
+
+static ssize_t txt_store_SINIT_BASE(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_SINIT_BASE);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(SINIT_BASE, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_SINIT_BASE, txt_store_SINIT_BASE);
+
+static ssize_t txt_show_SINIT_SIZE(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return show_config(buf, off_SINIT_SIZE);
+}
+
+static ssize_t txt_store_SINIT_SIZE(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_SINIT_SIZE);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(SINIT_SIZE, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_SINIT_SIZE, txt_store_SINIT_SIZE);
+
+static ssize_t txt_show_HEAP_BASE(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_config(buf, off_HEAP_BASE);
+}
+
+static ssize_t txt_store_HEAP_BASE(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_HEAP_BASE);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(HEAP_BASE, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_HEAP_BASE, txt_store_HEAP_BASE);
+
+static ssize_t txt_show_HEAP_SIZE(struct device *dev,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	return show_config(buf, off_HEAP_SIZE);
+}
+
+static ssize_t txt_store_HEAP_SIZE(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_HEAP_SIZE);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(HEAP_SIZE, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_HEAP_SIZE, txt_store_HEAP_SIZE);
+
+static ssize_t txt_show_PUBLIC_KEY(struct device *dev,
+				   struct device_attribute *attr,
+				   char *buf)
+{
+	return show_config(buf, off_PUBLIC_KEY);
+}
+static DEVICE_ATTR(PUBLIC_KEY, S_IRUGO, txt_show_PUBLIC_KEY, NULL);
+
+static ssize_t txt_show_MLE_JOIN(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return show_config(buf, off_MLE_JOIN);
+}
+
+static ssize_t txt_store_MLE_JOIN(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_MLE_JOIN);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(MLE_JOIN, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_MLE_JOIN, txt_store_MLE_JOIN);
+
+static ssize_t txt_show_DPR_raw(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_config(buf, off_DPR_raw);
+}
+
+static ssize_t txt_store_DPR_raw(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_DPR_raw);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(DPR_raw, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_DPR_raw, txt_store_DPR_raw);
+
+static ssize_t txt_show_DPR_lock(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return show_config(buf, off_DPR_lock);
+}
+
+static ssize_t txt_store_DPR_lock(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_DPR_lock);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(DPR_lock, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_DPR_lock, txt_store_DPR_lock);
+
+static ssize_t txt_show_DPR_top(struct device *dev,
+				struct device_attribute *attr,
+				char *buf)
+{
+	return show_config(buf, off_DPR_top);
+}
+
+static ssize_t txt_store_DPR_top(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_DPR_top);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(DPR_top, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_DPR_top, txt_store_DPR_top);
+
+static ssize_t txt_show_DPR_size(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	return show_config(buf, off_DPR_size);
+}
+
+static ssize_t txt_store_DPR_size(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_pub_config(buf, off_DPR_size);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(DPR_size, S_IRUGO | S_IWUSR | S_IWGRP,
+		   txt_show_DPR_size, txt_store_DPR_size);
+
+static ssize_t txt_store_CMD_RESET(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_RESET);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_RESET, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_RESET);
+
+static ssize_t txt_store_CMD_CLOSE_PRIVATE(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_CLOSE_PRIVATE);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_CLOSE_PRIVATE, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_CLOSE_PRIVATE);
+
+static ssize_t txt_store_CMD_SECRETS(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_SECRETS);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_SECRETS, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_SECRETS);
+
+static ssize_t txt_store_CMD_NO_SECRETS(struct device *dev,
+					struct device_attribute *attr,
+					const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_NO_SECRETS);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_NO_SECRETS, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_NO_SECRETS);
+
+static ssize_t txt_store_CMD_OPEN_LOCALITY1(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_OPEN_LOCALITY1);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_OPEN_LOCALITY1, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_OPEN_LOCALITY1);
+
+static ssize_t txt_store_CMD_OPEN_LOCALITY2(struct device *dev,
+					    struct device_attribute *attr,
+					    const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_OPEN_LOCALITY2);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_OPEN_LOCALITY2, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_OPEN_LOCALITY2);
+
+static ssize_t txt_store_CMD_CLOSE_LOCALITY1(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_CLOSE_LOCALITY1);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_CLOSE_LOCALITY1, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_CLOSE_LOCALITY1);
+
+static ssize_t txt_store_CMD_CLOSE_LOCALITY2(struct device *dev,
+					     struct device_attribute *attr,
+					     const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_CLOSE_LOCALITY2);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_CLOSE_LOCALITY2, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_CLOSE_LOCALITY2);
+
+static ssize_t txt_store_CMD_UNLOCK_MEM_CONFIG(struct device *dev,
+					       struct device_attribute *attr,
+					       const char *buf, size_t count)
+{
+	int ret;
+
+	ret = store_priv_config(buf, off_CMD_UNLOCK_MEM_CONFIG);
+	if (!ret)
+		return count;
+
+	return ret;
+}
+static DEVICE_ATTR(CMD_UNLOCK_MEM_CONFIG, S_IWUSR | S_IWGRP,
+		   NULL, txt_store_CMD_UNLOCK_MEM_CONFIG);
+
+static struct attribute *config_attrs[] = {
+	&dev_attr_STS_raw.attr,
+	&dev_attr_STS_senter_done.attr,
+	&dev_attr_STS_sexit_done.attr,
+	&dev_attr_STS_mem_config_lock.attr,
+	&dev_attr_STS_private_open.attr,
+	&dev_attr_STS_locality_1_open.attr,
+	&dev_attr_STS_locality_2_open.attr,
+	&dev_attr_ERRORCODE.attr,
+	&dev_attr_ESTS_raw.attr,
+	&dev_attr_ESTS_txt_reset.attr,
+	&dev_attr_E2STS_raw.attr,
+	&dev_attr_E2STS_secrets.attr,
+	&dev_attr_VER_FSBIF.attr,
+	&dev_attr_VER_QPIIF.attr,
+	&dev_attr_DIDVID_raw.attr,
+	&dev_attr_DIDVID_vendor_id.attr,
+	&dev_attr_DIDVID_device_id.attr,
+	&dev_attr_DIDVID_revision_id.attr,
+	&dev_attr_SINIT_BASE.attr,
+	&dev_attr_SINIT_SIZE.attr,
+	&dev_attr_HEAP_BASE.attr,
+	&dev_attr_HEAP_SIZE.attr,
+	&dev_attr_PUBLIC_KEY.attr,
+	&dev_attr_MLE_JOIN.attr,
+	&dev_attr_DPR_raw.attr,
+	&dev_attr_DPR_lock.attr,
+	&dev_attr_DPR_top.attr,
+	&dev_attr_DPR_size.attr,
+	&dev_attr_CMD_RESET.attr,
+	&dev_attr_CMD_CLOSE_PRIVATE.attr,
+	&dev_attr_CMD_SECRETS.attr,
+	&dev_attr_CMD_NO_SECRETS.attr,
+	&dev_attr_CMD_OPEN_LOCALITY1.attr,
+	&dev_attr_CMD_OPEN_LOCALITY2.attr,
+	&dev_attr_CMD_CLOSE_LOCALITY1.attr,
+	&dev_attr_CMD_CLOSE_LOCALITY2.attr,
+	&dev_attr_CMD_UNLOCK_MEM_CONFIG.attr,
+	NULL,
+};
+
+static struct attribute_group config_attr_grp = {
+	.name = "config",
+	.attrs = config_attrs
+};
+
+int sysfs_create_config(struct kobject *parent)
+{
+	return sysfs_create_group(parent, &config_attr_grp);
+}
+
diff --git a/drivers/platform/x86/intel_txt/txt-config.h b/drivers/platform/x86/intel_txt/txt-config.h
new file mode 100644
index 0000000..d88cc83
--- /dev/null
+++ b/drivers/platform/x86/intel_txt/txt-config.h
@@ -0,0 +1,138 @@
+#ifndef __CONFIG_H__
+#define __CONFIG_H__
+
+#define TXT_PUB_CONFIG_REGS_BASE	0xfed30000
+#define TXT_PRIV_CONFIG_REGS_BASE	0xfed20000
+#define TXT_CONFIG_REGS_SIZE		0x10000
+
+#define TXTCR_STS			0x0000
+#define TXTCR_ESTS			0x0008
+#define TXTCR_ERRORCODE			0x0030
+#define TXTCR_CMD_RESET			0x0038
+#define TXTCR_CMD_CLOSE_PRIVATE		0x0048
+#define TXTCR_VER_FSBIF			0x0100
+#define TXTCR_DIDVID			0x0110
+#define TXTCR_VER_QPIIF			0x0200
+#define TXTCR_CMD_UNLOCK_MEM_CONFIG	0x0218
+#define TXTCR_SINIT_BASE		0x0270
+#define TXTCR_SINIT_SIZE		0x0278
+#define TXTCR_MLE_JOIN			0x0290
+#define TXTCR_HEAP_BASE			0x0300
+#define TXTCR_HEAP_SIZE			0x0308
+#define TXTCR_MSEG_BASE			0x0310
+#define TXTCR_MSEG_SIZE			0x0318
+#define TXTCR_DPR			0x0330
+#define TXTCR_CMD_OPEN_LOCALITY1	0x0380
+#define TXTCR_CMD_CLOSE_LOCALITY1	0x0388
+#define TXTCR_CMD_OPEN_LOCALITY2	0x0390
+#define TXTCR_CMD_CLOSE_LOCALITY2	0x0398
+#define TXTCR_PUBLIC_KEY		0x0400
+#define TXTCR_CMD_SECRETS		0x08e0
+#define TXTCR_CMD_NO_SECRETS		0x08e8
+#define TXTCR_E2STS			0x08f0
+
+#define off_STS_raw			1
+#define off_STS_senter_done		2
+#define off_STS_sexit_done		3
+#define off_STS_mem_config_lock		4
+#define off_STS_private_open		5
+#define off_STS_locality_1_open		6
+#define off_STS_locality_2_open		7
+#define off_ERRORCODE			8
+#define off_ESTS_raw			9
+#define off_ESTS_txt_reset		10
+#define off_E2STS_raw			11
+#define off_E2STS_secrets		12
+#define off_VER_FSBIF			13
+#define off_VER_QPIIF			14
+#define off_DIDVID_raw			15
+#define off_DIDVID_vendor_id		16
+#define off_DIDVID_device_id		17
+#define off_DIDVID_revision_id		18
+#define off_SINIT_BASE			19
+#define off_SINIT_SIZE			20
+#define off_HEAP_BASE			21
+#define off_HEAP_SIZE			22
+#define off_PUBLIC_KEY			23
+#define off_MLE_JOIN			24
+#define off_DPR_raw			25
+#define off_DPR_lock			26
+#define off_DPR_top			27
+#define off_DPR_size			28
+#define off_CMD_RESET			29
+#define off_CMD_CLOSE_PRIVATE		30
+#define off_CMD_SECRETS			31
+#define off_CMD_NO_SECRETS		32
+#define off_CMD_OPEN_LOCALITY1		33
+#define off_CMD_OPEN_LOCALITY2		34
+#define off_CMD_CLOSE_LOCALITY1		35
+#define off_CMD_CLOSE_LOCALITY2		36
+#define off_CMD_UNLOCK_MEM_CONFIG	37
+
+typedef union txt_ests {
+	uint64_t _raw;
+	struct {
+		uint64_t txt_reset_sts:1;
+	};
+} txt_ests_t;
+
+typedef union txt_e2sts {
+	uint64_t _raw;
+	struct {
+		uint64_t reserved:1;
+		uint64_t secrets_sts:1;
+	};
+} txt_e2sts_t;
+
+typedef union txt_sts {
+	uint64_t _raw;
+	struct {
+		uint64_t senter_done_sts:1;
+		uint64_t sexit_done_sts:1;
+		uint64_t reserved1:4;
+		uint64_t mem_config_lock_sts:1;
+		uint64_t private_open_sts:1;
+		uint64_t reserved2:7;
+		uint64_t locality_1_open_sts:1;
+		uint64_t locality_2_open_sts:1;
+	};
+} txt_sts_t;
+
+typedef union txt_divid {
+	uint64_t _raw;
+	struct {
+		uint16_t vendor_id;
+		uint16_t device_id;
+		uint16_t revision_id;
+		uint16_t reserved;
+	};
+} txt_didvid_t;
+
+typedef union txt_dpr {
+	uint64_t _raw;
+	struct {
+		uint64_t lock:1;
+		uint64_t reserved1:3;
+		uint64_t size:8;
+		uint64_t reserved2:8;
+		uint64_t top:12;
+		uint64_t reserved3:32;
+	};
+} txt_dpr_t;
+
+static inline uint64_t
+read_txt_config_reg(void *config_regs_base, uint32_t reg)
+{
+	return readq(config_regs_base + reg);
+}
+
+static inline void
+write_txt_config_reg(void *config_regs_base, uint32_t reg, uint64_t val)
+{
+	writeq(val, config_regs_base + reg);
+}
+
+extern int sysfs_create_config(struct kobject *parent);
+
+#endif /* __CONFIG_H__ */
+
diff --git a/drivers/platform/x86/intel_txt/txt-sysfs.c b/drivers/platform/x86/intel_txt/txt-sysfs.c
index def33cb..ac889f7 100644
--- a/drivers/platform/x86/intel_txt/txt-sysfs.c
+++ b/drivers/platform/x86/intel_txt/txt-sysfs.c
@@ -36,11 +36,15 @@
 #include <linux/sysfs.h>
 #include <linux/tboot.h>
 
+#include "txt-config.h"
+
 #define DEV_NAME "intel_txt"
 static struct platform_device *txt_pdev;
 
 static int __init txt_sysfs_init(void)
 {
+	int retval;
+
 	if (!tboot_enabled())
 		return -ENODEV;
 
@@ -48,7 +52,15 @@ static int __init txt_sysfs_init(void)
 	if (IS_ERR(txt_pdev))
 		return PTR_ERR(txt_pdev);
 
+	retval = sysfs_create_config(&txt_pdev->dev.kobj);
+	if (retval)
+		goto err;
+
 	return 0;
+
+err:
+	platform_device_unregister(txt_pdev);
+	return retval;
 }
 
 static void __exit txt_sysfs_exit(void)
-- 
1.7.9.5

