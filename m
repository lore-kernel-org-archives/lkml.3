Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaIXVHz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 17:07:55 -0400
Received: from mail-by2on0110.outbound.protection.outlook.com ([207.46.100.110]:13728
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753576AbaIXVE2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 17:04:28 -0400
X-WSS-ID: 0NCFB5M-08-8JK-02
X-M-MSG: 
From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        "John Bridgman" <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH v4 10/23] amdkfd: Add basic modules to amdkfd
Date: Wed, 24 Sep 2014 23:45:24 +0300
Message-ID: <1411591537-31636-11-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
References: <1411591537-31636-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [10.20.0.84]
Content-Transfer-Encoding: 8BIT
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(51234002)(85306004)(77096002)(36756003)(83072002)(50986999)(97736003)(76176999)(62966002)(107046002)(19580405001)(77156001)(229853001)(33646002)(105586002)(76482002)(85852003)(106466001)(101416001)(99396003)(10300001)(90102001)(44976005)(120916001)(19580395003)(95666004)(102836001)(21056001)(87936001)(89996001)(87286001)(81342003)(88136002)(68736004)(83322001)(23676002)(93916002)(50466002)(80022003)(92726001)(86362001)(20776003)(81542003)(46102003)(47776003)(77982003)(79102003)(84676001)(92566001)(74502003)(31966008)(50226001)(64706001)(4396001)(104166001)(74662003)(129583001)(579004)(559001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR02MB197;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR02MB197;
X-Forefront-PRVS: 03449D5DD1
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Oded.Gabbay@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lewycky <Andrew.Lewycky@amd.com>

This patch adds the process module and three helper modules:

- kfd_process, which handles process which open /dev/kfd

- kfd_doorbell, which provides helper functions for doorbell allocation,
  release and mapping to userspace

- kfd_pasid, which provides helper functions for pasid allocation and release

- kfd_aperture, which provides helper functions for managing the LDS, Local GPU
  memory and Scratch memory apertures of the process

This patch only contains the basic kfd_process module, which doesn't contain
the reference to the queue scheduler. This was done to allow easier code review.

Also, this patch doesn't contain the calls to the IOMMU driver for binding the
pasid to the device. Again, this was done to allow easier code review

The kfd_process object is created when a process opens /dev/kfd and is closed
when the mm_struct of that process is teared-down.

v3:

Removed kfd_vidmem.c file
Replaced direct mmput call to mmu_notifier release
Removed typedefs
Moved bool field to end of the structure
Added new kernel params for gart usage limitation
Added initialization of sa manager
Fixed debug messages
Remove support for LDS in 32 bit
Changed code to support mmap of doorbell pages from userspace
Added documentation for apertures

v4:

Replaced RCU by SRCU for kfd_process list management

Signed-off-by: Andrew Lewycky <Andrew.Lewycky@amd.com>
Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/gpu/drm/radeon/amdkfd/Makefile       |   4 +-
 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c | 350 +++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c  |  31 ++-
 drivers/gpu/drm/radeon/amdkfd/kfd_device.c   |  45 +++-
 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c | 236 ++++++++++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_module.c   |  32 ++-
 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c    |  95 ++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_priv.h     | 141 +++++++++++
 drivers/gpu/drm/radeon/amdkfd/kfd_process.c  | 322 ++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon_kfd.c          |  21 +-
 10 files changed, 1250 insertions(+), 27 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
 create mode 100644 drivers/gpu/drm/radeon/amdkfd/kfd_process.c

diff --git a/drivers/gpu/drm/radeon/amdkfd/Makefile b/drivers/gpu/drm/radeon/amdkfd/Makefile
index 08ecfcd..6d6746e 100644
--- a/drivers/gpu/drm/radeon/amdkfd/Makefile
+++ b/drivers/gpu/drm/radeon/amdkfd/Makefile
@@ -4,6 +4,8 @@
 
 ccflags-y := -Iinclude/drm
 
-amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o
+amdkfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o kfd_topology.o \
+		kfd_pasid.o kfd_doorbell.o kfd_aperture.o \
+		kfd_process.o
 
 obj-$(CONFIG_HSA_RADEON)	+= amdkfd.o
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c b/drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
new file mode 100644
index 0000000..8cfb720
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_aperture.c
@@ -0,0 +1,350 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/compat.h>
+#include <uapi/linux/kfd_ioctl.h>
+#include <linux/time.h>
+#include "kfd_priv.h"
+#include <linux/mm.h>
+#include <uapi/asm-generic/mman-common.h>
+#include <asm/processor.h>
+
+/*
+ * The primary memory I/O features being added for revisions of gfxip
+ * beyond 7.0 (Kaveri) are:
+ *
+ * Access to ATC/IOMMU mapped memory w/ associated extension of VA to 48b
+ *
+ * “Flat” shader memory access – These are new shader vector memory operations
+ * that do not reference a T#/V# so a “pointer” is what is sourced from the
+ * vector gprs for direct access to memory.  This pointer space has the
+ * Shared(LDS) and Private(Scratch) memory mapped into this pointer space as
+ * apertures.  The hardware then determines how to direct the memory request
+ * based on what apertures the request falls in.
+ *
+ * Unaligned support and alignment check
+ *
+ *
+ * System Unified Address - SUA
+ *
+ * The standard usage for GPU virtual addresses are that they are mapped by
+ * a set of page tables we call GPUVM and these page tables are managed by
+ * a combination of vidMM/driver software components.  The current virtual
+ * address (VA) range for GPUVM is 40b.
+ *
+ * As of gfxip7.1 and beyond we’re adding the ability for compute memory
+ * clients (CP/RLC, DMA, SHADER(ifetch, scalar, and vector ops)) to access
+ * the same page tables used by host x86 processors and that are managed by
+ * the operating system. This is via a technique and hardware called ATC/IOMMU.
+ * The GPU has the capability of accessing both the GPUVM and ATC address
+ * spaces for a given VMID (process) simultaneously and we call this feature
+ * system unified address (SUA).
+ *
+ * There are three fundamental address modes of operation for a given VMID
+ * (process) on the GPU:
+ *
+ *	HSA64 – 64b pointers and the default address space is ATC
+ *	HSA32 – 32b pointers and the default address space is ATC
+ *	GPUVM – 64b pointers and the default address space is GPUVM (driver
+ *		model mode)
+ *
+ *
+ * HSA64 - ATC/IOMMU 64b
+ *
+ * A 64b pointer in the AMD64/IA64 CPU architecture is not fully utilized
+ * by the CPU so an AMD CPU can only access the high area
+ * (VA[63:47] == 0x1FFFF) and low area (VA[63:47 == 0) of the address space
+ * so the actual VA carried to translation is 48b.  There is a “hole” in
+ * the middle of the 64b VA space.
+ *
+ * The GPU not only has access to all of the CPU accessible address space via
+ * ATC/IOMMU, but it also has access to the GPUVM address space.  The “system
+ * unified address” feature (SUA) is the mapping of GPUVM and ATC address spaces
+ * into a unified pointer space.  The method we take for 64b mode is to map the
+ * full 40b GPUVM address space into the hole of the 64b address space.
+
+ * The GPUVM_Base/GPUVM_Limit defines the aperture in the 64b space where we
+ * direct requests to be translated via GPUVM page tables instead of the
+ * IOMMU path.
+ *
+ *
+ * 64b to 49b Address conversion
+ *
+ * Note that there are still significant portions of unused regions (holes)
+ * in the 64b address space even for the GPU.  There are several places in
+ * the pipeline (sw and hw), we wish to compress the 64b virtual address
+ * to a 49b address.  This 49b address is constituted of an “ATC” bit
+ * plus a 48b virtual address.  This 49b address is what is passed to the
+ * translation hardware.  ATC==0 means the 48b address is a GPUVM address
+ * (max of 2^40 – 1) intended to be translated via GPUVM page tables.
+ * ATC==1 means the 48b address is intended to be translated via IOMMU
+ * page tables.
+ *
+ * A 64b pointer is compared to the apertures that are defined (Base/Limit), in
+ * this case the GPUVM aperture (red) is defined and if a pointer falls in this
+ * aperture, we subtract the GPUVM_Base address and set the ATC bit to zero
+ * as part of the 64b to 49b conversion.
+ *
+ * Where this 64b to 49b conversion is done is a function of the usage.
+ * Most GPU memory access is via memory objects where the driver builds
+ * a descriptor which consists of a base address and a memory access by
+ * the GPU usually consists of some kind of an offset or Cartesian coordinate
+ * that references this memory descriptor.  This is the case for shader
+ * instructions that reference the T# or V# constants, or for specified
+ * locations of assets (ex. the shader program location).  In these cases
+ * the driver is what handles the 64b to 49b conversion and the base
+ * address in the descriptor (ex. V# or T# or shader program location)
+ * is defined as a 48b address w/ an ATC bit.  For this usage a given
+ * memory object cannot straddle multiple apertures in the 64b address
+ * space. For example a shader program cannot jump in/out between ATC
+ * and GPUVM space.
+ *
+ * In some cases we wish to pass a 64b pointer to the GPU hardware and
+ * the GPU hw does the 64b to 49b conversion before passing memory
+ * requests to the cache/memory system.  This is the case for the
+ * S_LOAD and FLAT_* shader memory instructions where we have 64b pointers
+ * in scalar and vector GPRs respectively.
+ *
+ * In all cases (no matter where the 64b -> 49b conversion is done), the gfxip
+ * hardware sends a 48b address along w/ an ATC bit, to the memory controller
+ * on the memory request interfaces.
+ *
+ *	<client>_MC_rdreq_atc   // read request ATC bit
+ *
+ *		0 : <client>_MC_rdreq_addr is a GPUVM VA
+ *
+ *		1 : <client>_MC_rdreq_addr is a ATC VA
+ *
+ *
+ * “Spare” aperture (APE1)
+ *
+ * We use the GPUVM aperture to differentiate ATC vs. GPUVM, but we also use
+ * apertures to set the Mtype field for S_LOAD/FLAT_* ops which is input to the
+ * config tables for setting cache policies. The “spare” (APE1) aperture is
+ * motivated by getting a different Mtype from the default.
+ * The default aperture isn’t an actual base/limit aperture; it is just the
+ * address space that doesn’t hit any defined base/limit apertures.
+ * The following diagram is a complete picture of the gfxip7.x SUA apertures.
+ * The APE1 can be placed either below or above
+ * the hole (cannot be in the hole).
+ *
+ *
+ * General Aperture definitions and rules
+ *
+ * An aperture register definition consists of a Base, Limit, Mtype, and
+ * usually an ATC bit indicating which translation tables that aperture uses.
+ * In all cases (for SUA and DUA apertures discussed later), aperture base
+ * and limit definitions are 64KB aligned.
+ *
+ *	<ape>_Base[63:0] = { <ape>_Base_register[63:16], 0x0000 }
+ *
+ *	<ape>_Limit[63:0] = { <ape>_Limit_register[63:16], 0xFFFF }
+ *
+ * The base and limit are considered inclusive to an aperture so being inside an
+ * aperture means (address >= Base) AND (address <= Limit).
+ *
+ * In no case is a payload that straddles multiple apertures expected to work.
+ * For example a load_dword_x4 that starts in one aperture and ends in another,
+ * does not work.  For the vector FLAT_* ops we have detection capability in
+ * the shader for reporting a “memory violation” back to the SQ block for use
+ * in traps. A memory violation results when an op falls into the hole,
+ * or a payload straddles multiple apertures.  The S_LOAD instruction
+ * does not have this detection.
+ *
+ * Apertures cannot overlap.
+ *
+ *
+ *
+ * HSA32 - ATC/IOMMU 32b
+ *
+ * For HSA32 mode, the pointers are interpreted as 32 bits and use a single GPR
+ * instead of two for the S_LOAD and FLAT_* ops. The entire GPUVM space of 40b
+ * will not fit so there is only partial visibility to the GPUVM
+ * space (defined by the aperture) for S_LOAD and FLAT_* ops.
+ * There is no spare (APE1) aperture for HSA32 mode.
+ *
+ *
+ * GPUVM 64b mode (driver model)
+ *
+ * This mode is related to HSA64 in that the difference really is that
+ * the default aperture is GPUVM (ATC==0) and not ATC space.
+ * We have gfxip7.x hardware that has FLAT_* and S_LOAD support for
+ * SUA GPUVM mode, but does not support HSA32/HSA64.
+ *
+ *
+ * Device Unified Address - DUA
+ *
+ * Device unified address (DUA) is the name of the feature that maps the
+ * Shared(LDS) memory and Private(Scratch) memory into the overall address
+ * space for use by the new FLAT_* vector memory ops.  The Shared and
+ * Private memories are mapped as apertures into the address space,
+ * and the hardware detects when a FLAT_* memory request is to be redirected
+ * to the LDS or Scratch memory when it falls into one of these apertures.
+ * Like the SUA apertures, the Shared/Private apertures are 64KB aligned and
+ * the base/limit is “in” the aperture. For both HSA64 and GPUVM SUA modes,
+ * the Shared/Private apertures are always placed in a limited selection of
+ * options in the hole of the 64b address space. For HSA32 mode, the
+ * Shared/Private apertures can be placed anywhere in the 32b space except at 0.
+ *
+ *
+ * HSA64 Apertures for FLAT_* vector ops
+ *
+ * For HSA64 SUA mode, the Shared and Private apertures are always placed
+ * in the hole w/ a limited selection of possible locations. The requests
+ * that fall in the private aperture are expanded as a function of the
+ * work-item id (tid) and redirected to the location of the
+ * “hidden private memory”. The hidden private can be placed in either GPUVM
+ * or ATC space. The addresses that fall in the shared aperture are
+ * re-directed to the on-chip LDS memory hardware.
+ *
+ *
+ * HSA32 Apertures for FLAT_* vector ops
+ *
+ * In HSA32 mode, the Private and Shared apertures can be placed anywhere
+ * in the 32b space except at 0 (Private or Shared Base at zero disables
+ * the apertures). If the base address of the apertures are non-zero
+ * (ie apertures exists), the size is always 64KB.
+ *
+ *
+ * GPUVM Apertures for FLAT_* vector ops
+ *
+ * In GPUVM mode, the Shared/Private apertures are specified identically
+ * to HSA64 mode where they are always in the hole at a limited selection
+ * of locations.
+ *
+ *
+ * Aperture Definitions for SUA and DUA
+ *
+ * The interpretation of the aperture register definitions for a given
+ * VMID is a function of the “SUA Mode” which is one of HSA64, HSA32, or
+ * GPUVM64 discussed in previous sections. The mode is first decoded, and
+ * then the remaining register decode is a function of the mode.
+ *
+ *
+ * SUA Mode Decode
+ *
+ * For the S_LOAD and FLAT_* shader operations, the SUA mode is decoded from
+ * the COMPUTE_DISPATCH_INITIATOR:DATA_ATC bit and
+ * the SH_MEM_CONFIG:PTR32 bits.
+ *
+ * COMPUTE_DISPATCH_INITIATOR:DATA_ATC    SH_MEM_CONFIG:PTR32        Mode
+ *
+ * 1                                              0                  HSA64
+ *
+ * 1                                              1                  HSA32
+ *
+ * 0                                              X                 GPUVM64
+ *
+ * In general the hardware will ignore the PTR32 bit and treat as “0” whenever
+ * DATA_ATC = “0”, but sw should set PTR32=0 when DATA_ATC=0.
+ *
+ * The DATA_ATC bit is only set for compute dispatches.
+ * All “Draw” dispatches are hardcoded to GPUVM64 mode
+ * for FLAT_* / S_LOAD operations.
+ */
+
+#define MAKE_GPUVM_APP_BASE(gpu_num) \
+	(((uint64_t)(gpu_num) << 61) + 0x1000000000000)
+
+#define MAKE_GPUVM_APP_LIMIT(base) \
+	(((uint64_t)(base) & 0xFFFFFF0000000000) | 0xFFFFFFFFFF)
+
+#define MAKE_SCRATCH_APP_BASE(gpu_num) \
+	(((uint64_t)(gpu_num) << 61) + 0x100000000)
+
+#define MAKE_SCRATCH_APP_LIMIT(base) \
+	(((uint64_t)base & 0xFFFFFFFF00000000) | 0xFFFFFFFF)
+
+#define MAKE_LDS_APP_BASE(gpu_num) \
+	(((uint64_t)(gpu_num) << 61) + 0x0)
+#define MAKE_LDS_APP_LIMIT(base) \
+	(((uint64_t)(base) & 0xFFFFFFFF00000000) | 0xFFFFFFFF)
+
+int kfd_init_apertures(struct kfd_process *process)
+{
+	uint8_t id  = 0;
+	struct kfd_dev *dev;
+	struct kfd_process_device *pdd;
+
+	mutex_lock(&process->mutex);
+
+	/*Iterating over all devices*/
+	while ((dev = kfd_topology_enum_kfd_devices(id)) != NULL &&
+		id < NUM_OF_SUPPORTED_GPUS) {
+
+		pdd = kfd_get_process_device_data(dev, process, 1);
+
+		/*
+		 * For 64 bit process aperture will be statically reserved in
+		 * the x86_64 non canonical process address space
+		 * amdkfd doesn't currently support apertures for 32 bit process
+		 */
+		if (process->is_32bit_user_mode) {
+			pdd->lds_base = pdd->lds_limit = 0;
+			pdd->gpuvm_base = pdd->gpuvm_limit = 0;
+			pdd->scratch_base = pdd->scratch_limit = 0;
+		} else {
+			/*
+			 * node id couldn't be 0 - the three MSB bits of
+			 * aperture shoudn't be 0
+			 */
+			pdd->lds_base = MAKE_LDS_APP_BASE(id + 1);
+
+			pdd->lds_limit = MAKE_LDS_APP_LIMIT(pdd->lds_base);
+
+			pdd->gpuvm_base = MAKE_GPUVM_APP_BASE(id + 1);
+
+			pdd->gpuvm_limit =
+					MAKE_GPUVM_APP_LIMIT(pdd->gpuvm_base);
+
+			pdd->scratch_base = MAKE_SCRATCH_APP_BASE(id + 1);
+
+			pdd->scratch_limit =
+				MAKE_SCRATCH_APP_LIMIT(pdd->scratch_base);
+		}
+
+		dev_dbg(kfd_device, "node id %u\n", id);
+		dev_dbg(kfd_device, "gpu id %u\n", pdd->dev->id);
+		dev_dbg(kfd_device, "lds_base %llX\n", pdd->lds_base);
+		dev_dbg(kfd_device, "lds_limit %llX\n", pdd->lds_limit);
+		dev_dbg(kfd_device, "gpuvm_base %llX\n", pdd->gpuvm_base);
+		dev_dbg(kfd_device, "gpuvm_limit %llX\n", pdd->gpuvm_limit);
+		dev_dbg(kfd_device, "scratch_base %llX\n", pdd->scratch_base);
+		dev_dbg(kfd_device, "scratch_limit %llX\n", pdd->scratch_limit);
+
+		id++;
+	}
+
+	mutex_unlock(&process->mutex);
+
+	return 0;
+}
+
+
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
index f198e5a..c42f53b 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_chardev.c
@@ -38,6 +38,7 @@
 
 static long kfd_ioctl(struct file *, unsigned int, unsigned long);
 static int kfd_open(struct inode *, struct file *);
+static int kfd_mmap(struct file *, struct vm_area_struct *);
 
 static const char kfd_dev_name[] = "kfd";
 
@@ -46,6 +47,7 @@ static const struct file_operations kfd_fops = {
 	.unlocked_ioctl = kfd_ioctl,
 	.compat_ioctl = kfd_ioctl,
 	.open = kfd_open,
+	.mmap = kfd_mmap,
 };
 
 static int kfd_char_dev_major = -1;
@@ -96,9 +98,22 @@ struct device *kfd_chardev(void)
 
 static int kfd_open(struct inode *inode, struct file *filep)
 {
+	struct kfd_process *process;
+
 	if (iminor(inode) != 0)
 		return -ENODEV;
 
+	process = kfd_create_process(current);
+	if (IS_ERR(process))
+		return PTR_ERR(process);
+
+	process->is_32bit_user_mode = is_compat_task();
+
+	dev_dbg(kfd_device, "process %d opened, compat mode (32 bit) - %d\n",
+		process->pasid, process->is_32bit_user_mode);
+
+	kfd_init_apertures(process);
+
 	return 0;
 }
 
@@ -142,8 +157,9 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		"ioctl cmd 0x%x (#%d), arg 0x%lx\n",
 		cmd, _IOC_NR(cmd), arg);
 
-	/* TODO: add function that retrieves process */
-	process = NULL;
+	process = kfd_get_process(current);
+	if (IS_ERR(process))
+		return PTR_ERR(process);
 
 	switch (cmd) {
 	case KFD_IOC_CREATE_QUEUE:
@@ -185,3 +201,14 @@ static long kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 	return err;
 }
+
+static int kfd_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct kfd_process *process;
+
+	process = kfd_get_process(current);
+	if (IS_ERR(process))
+		return PTR_ERR(process);
+
+	return kfd_doorbell_mmap(process, vma);
+}
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
index 4138694..8e2b075 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_device.c
@@ -26,6 +26,8 @@
 #include <linux/slab.h>
 #include "kfd_priv.h"
 
+#define MQD_SIZE_ALIGNED 768
+
 static const struct kfd_device_info kaveri_device_info = {
 	.max_pasid_bits = 16,
 };
@@ -91,6 +93,7 @@ struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
 	kfd->kgd = kgd;
 	kfd->device_info = device_info;
 	kfd->pdev = pdev;
+	kfd->init_complete = false;
 
 	return kfd;
 }
@@ -98,23 +101,53 @@ struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
 bool kgd2kfd_device_init(struct kfd_dev *kfd,
 			 const struct kgd2kfd_shared_resources *gpu_resources)
 {
+	unsigned int size;
+
 	kfd->shared_resources = *gpu_resources;
 
-	if (kfd_topology_add_device(kfd) != 0)
-		return false;
+	/* calculate max size of mqds needed for queues */
+	size = max_num_of_processes *
+		max_num_of_queues_per_process *
+		MQD_SIZE_ALIGNED;
+
+	/* add another 512KB for all other allocations on gart */
+	size += 512 * 1024;
+
+	if (kfd2kgd->init_sa_manager(kfd->kgd, size)) {
+		dev_err(kfd_device,
+			"Error initializing sa manager for device (%x:%x)\n",
+			kfd->pdev->vendor, kfd->pdev->device);
+		goto out;
+	}
+
+	kfd_doorbell_init(kfd);
+
+	if (kfd_topology_add_device(kfd) != 0) {
+		dev_err(kfd_device,
+			"Error adding device (%x:%x) to topology\n",
+			kfd->pdev->vendor, kfd->pdev->device);
+		goto kfd_topology_add_device_error;
+	}
+
 
 	kfd->init_complete = true;
 	dev_info(kfd_device, "added device (%x:%x)\n", kfd->pdev->vendor,
 		 kfd->pdev->device);
 
-	return true;
+	goto out;
+
+kfd_topology_add_device_error:
+	kfd2kgd->fini_sa_manager(kfd->kgd);
+	dev_err(kfd_device,
+		"device (%x:%x) NOT added due to errors\n",
+		kfd->pdev->vendor, kfd->pdev->device);
+out:
+	return kfd->init_complete;
 }
 
 void kgd2kfd_device_exit(struct kfd_dev *kfd)
 {
-	int err = kfd_topology_remove_device(kfd);
-
-	BUG_ON(err != 0);
+	kfd_topology_remove_device(kfd);
 
 	kfree(kfd);
 }
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c b/drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
new file mode 100644
index 0000000..0590f5c
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_doorbell.c
@@ -0,0 +1,236 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+#include "kfd_priv.h"
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/slab.h>
+
+/*
+ * This extension supports a kernel level doorbells management for
+ * the kernel queues.
+ * Basically the last doorbells page is devoted to kernel queues
+ * and that's assures that any user process won't get access to the
+ * kernel doorbells page
+ */
+static DEFINE_MUTEX(doorbell_mutex);
+static unsigned long doorbell_available_index[DIV_ROUND_UP(KFD_MAX_NUM_OF_QUEUES_PER_PROCESS, BITS_PER_LONG)] = { 0 };
+#define KERNEL_DOORBELL_PASID 1
+#define KFD_SIZE_OF_DOORBELL_IN_BYTES 4
+
+/*
+ * Each device exposes a doorbell aperture, a PCI MMIO aperture that
+ * receives 32-bit writes that are passed to queues as wptr values.
+ * The doorbells are intended to be written by applications as part
+ * of queueing work on user-mode queues.
+ * We assign doorbells to applications in PAGE_SIZE-sized and aligned chunks.
+ * We map the doorbell address space into user-mode when a process creates
+ * its first queue on each device.
+ * Although the mapping is done by KFD, it is equivalent to an mmap of
+ * the /dev/kfd with the particular device encoded in the mmap offset.
+ * There will be other uses for mmap of /dev/kfd, so only a range of
+ * offsets (KFD_MMAP_DOORBELL_START-END) is used for doorbells.
+ */
+
+/* # of doorbell bytes allocated for each process. */
+static inline size_t doorbell_process_allocation(void)
+{
+	return roundup(KFD_SIZE_OF_DOORBELL_IN_BYTES *
+			KFD_MAX_NUM_OF_QUEUES_PER_PROCESS,
+			PAGE_SIZE);
+}
+
+/* Doorbell calculations for device init. */
+void kfd_doorbell_init(struct kfd_dev *kfd)
+{
+	size_t doorbell_start_offset;
+	size_t doorbell_aperture_size;
+	size_t doorbell_process_limit;
+
+	/*
+	 * We start with calculations in bytes because the input data might
+	 * only be byte-aligned.
+	 * Only after we have done the rounding can we assume any alignment.
+	 */
+
+	doorbell_start_offset = roundup(kfd->shared_resources.doorbell_start_offset,
+					doorbell_process_allocation());
+	doorbell_aperture_size = rounddown(kfd->shared_resources.doorbell_aperture_size,
+					doorbell_process_allocation());
+
+	if (doorbell_aperture_size > doorbell_start_offset)
+		doorbell_process_limit =
+			(doorbell_aperture_size - doorbell_start_offset) / doorbell_process_allocation();
+	else
+		doorbell_process_limit = 0;
+
+	kfd->doorbell_base = kfd->shared_resources.doorbell_physical_address + doorbell_start_offset;
+	kfd->doorbell_id_offset = doorbell_start_offset / sizeof(u32);
+	kfd->doorbell_process_limit = doorbell_process_limit - 1;
+
+	kfd->doorbell_kernel_ptr = ioremap(kfd->doorbell_base, doorbell_process_allocation());
+	BUG_ON(!kfd->doorbell_kernel_ptr);
+
+	pr_debug("kfd: doorbell initialization:\n");
+	pr_debug("kfd: doorbell base           == 0x%08lX\n",
+			(uintptr_t)kfd->doorbell_base);
+
+	pr_debug("kfd: doorbell_id_offset      == 0x%08lX\n",
+			kfd->doorbell_id_offset);
+
+	pr_debug("kfd: doorbell_process_limit  == 0x%08lX\n",
+			doorbell_process_limit);
+
+	pr_debug("kfd: doorbell_kernel_offset  == 0x%08lX\n",
+			(uintptr_t)kfd->doorbell_base);
+
+	pr_debug("kfd: doorbell aperture size  == 0x%08lX\n",
+			kfd->shared_resources.doorbell_aperture_size);
+
+	pr_debug("kfd: doorbell kernel address == 0x%08lX\n",
+			(uintptr_t)kfd->doorbell_kernel_ptr);
+}
+
+int kfd_doorbell_mmap(struct kfd_process *process, struct vm_area_struct *vma)
+{
+	phys_addr_t address;
+	struct kfd_dev *dev;
+
+	/*
+	 * For simplicitly we only allow mapping of the entire doorbell
+	 * allocation of a single device & process.
+	 */
+	if (vma->vm_end - vma->vm_start != doorbell_process_allocation())
+		return -EINVAL;
+
+	/* Find kfd device according to gpu id */
+	dev = kfd_device_by_id(vma->vm_pgoff);
+	if (dev == NULL)
+		return -EINVAL;
+
+	/* Find if pdd exists for combination of process and gpu id */
+	if (!kfd_get_process_device_data(dev, process, 0))
+		return -EINVAL;
+
+	/* Calculate physical address of doorbell */
+	address = kfd_get_process_doorbells(dev, process);
+
+	vma->vm_flags |= VM_IO | VM_DONTCOPY | VM_DONTEXPAND | VM_NORESERVE | VM_DONTDUMP | VM_PFNMAP;
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+
+	pr_debug("kfd: mapping doorbell page in kfd_doorbell_mmap\n"
+		 "     target user address == 0x%08llX\n"
+		 "     physical address    == 0x%08llX\n"
+		 "     vm_flags            == 0x%04lX\n"
+		 "     size                == 0x%04lX\n",
+		 (unsigned long long) vma->vm_start, address, vma->vm_flags,
+		 doorbell_process_allocation());
+
+
+	return io_remap_pfn_range(vma,
+				vma->vm_start,
+				address >> PAGE_SHIFT,
+				doorbell_process_allocation(),
+				vma->vm_page_prot);
+}
+
+
+/* get kernel iomem pointer for a doorbell */
+u32 __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd, unsigned int *doorbell_off)
+{
+	u32 inx;
+
+	BUG_ON(!kfd || !doorbell_off);
+
+	mutex_lock(&doorbell_mutex);
+	inx = find_first_zero_bit(doorbell_available_index, KFD_MAX_NUM_OF_QUEUES_PER_PROCESS);
+	__set_bit(inx, doorbell_available_index);
+	mutex_unlock(&doorbell_mutex);
+
+	if (inx >= KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)
+		return NULL;
+
+	/* caluculating the kernel doorbell offset using "faked" kernel pasid that allocated for kernel queues only */
+	*doorbell_off = KERNEL_DOORBELL_PASID * (doorbell_process_allocation()/sizeof(u32)) + inx;
+
+	pr_debug("kfd: get kernel queue doorbell\n"
+			 "     doorbell offset   == 0x%08d\n"
+			 "     kernel address    == 0x%08lX\n",
+			 *doorbell_off, (uintptr_t)(kfd->doorbell_kernel_ptr + inx));
+
+	return kfd->doorbell_kernel_ptr + inx;
+}
+
+void kfd_release_kernel_doorbell(struct kfd_dev *kfd, u32 __iomem *db_addr)
+{
+	unsigned int inx;
+
+	BUG_ON(!kfd || !db_addr);
+
+	inx = (unsigned int)(db_addr - kfd->doorbell_kernel_ptr);
+
+	mutex_lock(&doorbell_mutex);
+	__clear_bit(inx, doorbell_available_index);
+	mutex_unlock(&doorbell_mutex);
+}
+
+inline void write_kernel_doorbell(u32 __iomem *db, u32 value)
+{
+	if (db) {
+		writel(value, db);
+		pr_debug("writing %d to doorbell address 0x%p\n", value, db);
+	}
+}
+
+/*
+ * queue_ids are in the range [0,MAX_PROCESS_QUEUES) and are mapped 1:1
+ * to doorbells with the process's doorbell page
+ */
+unsigned int kfd_queue_id_to_doorbell(struct kfd_dev *kfd,
+					struct kfd_process *process,
+					unsigned int queue_id)
+{
+	/*
+	 * doorbell_id_offset accounts for doorbells taken by KGD.
+	 * pasid * doorbell_process_allocation/sizeof(u32) adjusts
+	 * to the process's doorbells
+	 */
+	return kfd->doorbell_id_offset +
+		process->pasid * (doorbell_process_allocation()/sizeof(u32)) +
+		queue_id;
+}
+
+uint64_t kfd_get_number_elems(struct kfd_dev *kfd)
+{
+	uint64_t num_of_elems = (kfd->shared_resources.doorbell_aperture_size -
+				kfd->shared_resources.doorbell_start_offset) /
+					doorbell_process_allocation() + 1;
+
+	return num_of_elems;
+
+}
+
+phys_addr_t kfd_get_process_doorbells(struct kfd_dev *dev,
+					struct kfd_process *process)
+{
+	return dev->doorbell_base +
+		process->pasid * doorbell_process_allocation();
+}
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
index 0002518..a31bf03 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_module.c
@@ -22,7 +22,6 @@
 
 #include <linux/module.h>
 #include <linux/sched.h>
-#include <linux/notifier.h>
 #include <linux/moduleparam.h>
 #include <linux/device.h>
 #include "kfd_priv.h"
@@ -46,6 +45,16 @@ static const struct kgd2kfd_calls kgd2kfd = {
 	.resume		= kgd2kfd_resume,
 };
 
+int max_num_of_processes = KFD_MAX_NUM_OF_PROCESSES_DEFAULT;
+module_param(max_num_of_processes, int, 0444);
+MODULE_PARM_DESC(max_num_of_processes,
+	"Kernel cmdline parameter that defines the amdkfd maximum number of supported processes");
+
+int max_num_of_queues_per_process = KFD_MAX_NUM_OF_QUEUES_PER_PROCESS_DEFAULT;
+module_param(max_num_of_queues_per_process, int, 0444);
+MODULE_PARM_DESC(max_num_of_queues_per_process,
+	"Kernel cmdline parameter that defines the amdkfd maximum number of supported queues per process");
+
 bool kgd2kfd_init(unsigned interface_version,
 		  const struct kfd2kgd_calls *f2g,
 		  const struct kgd2kfd_calls **g2f)
@@ -69,6 +78,24 @@ static int __init kfd_module_init(void)
 {
 	int err;
 
+	/* Verify module parameters */
+	if ((max_num_of_processes < 0) ||
+		(max_num_of_processes > KFD_MAX_NUM_OF_PROCESSES)) {
+		pr_err("kfd: max_num_of_processes must be between 0 to KFD_MAX_NUM_OF_PROCESSES\n");
+		return -1;
+	}
+
+	if ((max_num_of_queues_per_process < 0) ||
+		(max_num_of_queues_per_process >
+			KFD_MAX_NUM_OF_QUEUES_PER_PROCESS)) {
+		pr_err("kfd: max_num_of_queues_per_process must be between 0 to KFD_MAX_NUM_OF_QUEUES_PER_PROCESS\n");
+		return -1;
+	}
+
+	err = kfd_pasid_init();
+	if (err < 0)
+		goto err_pasid;
+
 	err = kfd_chardev_init();
 	if (err < 0)
 		goto err_ioctl;
@@ -84,6 +111,8 @@ static int __init kfd_module_init(void)
 err_topology:
 	kfd_chardev_exit();
 err_ioctl:
+	kfd_pasid_exit();
+err_pasid:
 	return err;
 }
 
@@ -91,6 +120,7 @@ static void __exit kfd_module_exit(void)
 {
 	kfd_topology_shutdown();
 	kfd_chardev_exit();
+	kfd_pasid_exit();
 	dev_info(kfd_device, "Removed module\n");
 }
 
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c b/drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
new file mode 100644
index 0000000..bfa5e2d
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_pasid.c
@@ -0,0 +1,95 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include "kfd_priv.h"
+
+static unsigned long *pasid_bitmap;
+static unsigned int pasid_limit;
+static DEFINE_MUTEX(pasid_mutex);
+
+int kfd_pasid_init(void)
+{
+	pasid_limit = max_num_of_processes;
+
+	pasid_bitmap = kzalloc(DIV_ROUND_UP(pasid_limit, BITS_PER_BYTE), GFP_KERNEL);
+	if (!pasid_bitmap)
+		return -ENOMEM;
+
+	set_bit(0, pasid_bitmap); /* PASID 0 is reserved. */
+
+	return 0;
+}
+
+void kfd_pasid_exit(void)
+{
+	kfree(pasid_bitmap);
+}
+
+bool kfd_set_pasid_limit(unsigned int new_limit)
+{
+	if (new_limit < pasid_limit) {
+		bool ok;
+
+		mutex_lock(&pasid_mutex);
+
+		/* ensure that no pasids >= new_limit are in-use */
+		ok = (find_next_bit(pasid_bitmap, pasid_limit, new_limit) == pasid_limit);
+		if (ok)
+			pasid_limit = new_limit;
+
+		mutex_unlock(&pasid_mutex);
+
+		return ok;
+	}
+
+	return true;
+}
+
+inline unsigned int kfd_get_pasid_limit(void)
+{
+	return pasid_limit;
+}
+
+unsigned int kfd_pasid_alloc(void)
+{
+	unsigned int found;
+
+	mutex_lock(&pasid_mutex);
+
+	found = find_first_zero_bit(pasid_bitmap, pasid_limit);
+	if (found == pasid_limit)
+		found = 0;
+	else
+		set_bit(found, pasid_bitmap);
+
+	mutex_unlock(&pasid_mutex);
+
+	return found;
+}
+
+void kfd_pasid_free(unsigned int pasid)
+{
+	BUG_ON(pasid == 0 || pasid >= pasid_limit);
+	clear_bit(pasid, pasid_bitmap);
+}
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
index 4b7ffb6..43f4bd4 100644
--- a/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_priv.h
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/spinlock.h>
 #include "../radeon_kfd.h"
+#include <linux/kfd_ioctl.h>
 
 #define KFD_SYSFS_FILE_MODE 0444
 
@@ -40,6 +41,22 @@
 /* Macro for allocating structures */
 #define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
 
+/* Kernel module parameter to specify maximum number of supported processes */
+extern int max_num_of_processes;
+
+#define KFD_MAX_NUM_OF_PROCESSES_DEFAULT 32
+#define KFD_MAX_NUM_OF_PROCESSES 512
+
+/*
+ * Kernel module parameter to specify maximum number of supported queues
+ * per process
+ */
+extern int max_num_of_queues_per_process;
+
+#define KFD_MAX_NUM_OF_QUEUES_PER_PROCESS_DEFAULT 128
+#define KFD_MAX_NUM_OF_QUEUES_PER_PROCESS 1024
+
+
 struct kfd_device_info {
 	const struct kfd_scheduler_class *scheduler_class;
 	unsigned int max_pasid_bits;
@@ -54,6 +71,17 @@ struct kfd_dev {
 
 	unsigned int id;		/* topology stub index */
 
+	phys_addr_t doorbell_base;	/* Start of actual doorbells used by
+					 * KFD. It is aligned for mapping
+					 * into user mode
+					 */
+	size_t doorbell_id_offset;	/* Doorbell offset (from KFD doorbell
+					 * to HW doorbell, GFX reserved some
+					 * at the start)
+					 */
+	size_t doorbell_process_limit;	/* Number of processes we have doorbell space for. */
+	u32 __iomem *doorbell_kernel_ptr; /* this is a pointer for a doorbells page used by kernel queue */
+
 	struct kgd2kfd_shared_resources shared_resources;
 
 	bool init_complete;
@@ -69,15 +97,121 @@ void kgd2kfd_device_exit(struct kfd_dev *kfd);
 
 extern const struct kfd2kgd_calls *kfd2kgd;
 
+/* Dummy struct just to make kfd_mem_obj* a unique pointer type. */
+struct kfd_mem_obj {
+	void *sa_bo;
+	uint64_t gpu_addr;
+	uint32_t *ptr;
+};
+
+enum kfd_mempool {
+	KFD_MEMPOOL_SYSTEM_CACHEABLE = 1,
+	KFD_MEMPOOL_SYSTEM_WRITECOMBINE = 2,
+	KFD_MEMPOOL_FRAMEBUFFER = 3,
+};
+
 /* Character device interface */
 int kfd_chardev_init(void);
 void kfd_chardev_exit(void);
 struct device *kfd_chardev(void);
 
+
+/* Data that is per-process-per device. */
+struct kfd_process_device {
+	/*
+	 * List of all per-device data for a process.
+	 * Starts from kfd_process.per_device_data.
+	 */
+	struct list_head per_device_list;
+
+	/* The device that owns this data. */
+	struct kfd_dev *dev;
+
+
+	/*Apertures*/
+	uint64_t lds_base;
+	uint64_t lds_limit;
+	uint64_t gpuvm_base;
+	uint64_t gpuvm_limit;
+	uint64_t scratch_base;
+	uint64_t scratch_limit;
+
+	/* Is this process/pasid bound to this device? (amd_iommu_bind_pasid) */
+	bool bound;
+};
+
 /* Process data */
 struct kfd_process {
+	/*
+	 * kfd_process are stored in an mm_struct*->kfd_process*
+	 * hash table (kfd_processes in kfd_process.c)
+	 */
+	struct hlist_node kfd_processes;
+
+	struct mm_struct *mm;
+
+	struct mutex mutex;
+
+	/*
+	 * In any process, the thread that started main() is the lead
+	 * thread and outlives the rest.
+	 * It is here because amd_iommu_bind_pasid wants a task_struct.
+	 */
+	struct task_struct *lead_thread;
+
+	/* We want to receive a notification when the mm_struct is destroyed */
+	struct mmu_notifier mmu_notifier;
+
+	/* Use for delayed freeing of kfd_process structure */
+	struct rcu_head	rcu;
+
+	unsigned int pasid;
+
+	/*
+	 * List of kfd_process_device structures,
+	 * one for each device the process is using.
+	 */
+	struct list_head per_device_data;
+
+	/* The process's queues. */
+	size_t queue_array_size;
+
+	/* Size is queue_array_size, up to MAX_PROCESS_QUEUES. */
+	struct kfd_queue **queues;
+
+	unsigned long allocated_queue_bitmap[DIV_ROUND_UP(KFD_MAX_NUM_OF_QUEUES_PER_PROCESS, BITS_PER_LONG)];
+
+	/*Is the user space process 32 bit?*/
+	bool is_32bit_user_mode;
 };
 
+struct kfd_process *kfd_create_process(const struct task_struct *);
+struct kfd_process *kfd_get_process(const struct task_struct *);
+
+struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
+							struct kfd_process *p,
+							int create_pdd);
+
+/* PASIDs */
+int kfd_pasid_init(void);
+void kfd_pasid_exit(void);
+bool kfd_set_pasid_limit(unsigned int new_limit);
+unsigned int kfd_get_pasid_limit(void);
+unsigned int kfd_pasid_alloc(void);
+void kfd_pasid_free(unsigned int pasid);
+
+/* Doorbells */
+void kfd_doorbell_init(struct kfd_dev *kfd);
+int kfd_doorbell_mmap(struct kfd_process *process, struct vm_area_struct *vma);
+u32 __iomem *kfd_get_kernel_doorbell(struct kfd_dev *kfd,
+					unsigned int *doorbell_off);
+void kfd_release_kernel_doorbell(struct kfd_dev *kfd, u32 __iomem *db_addr);
+u32 read_kernel_doorbell(u32 __iomem *db);
+void write_kernel_doorbell(u32 __iomem *db, u32 value);
+unsigned int kfd_queue_id_to_doorbell(struct kfd_dev *kfd,
+					struct kfd_process *process,
+					unsigned int queue_id);
+
 extern struct device *kfd_device;
 
 /* Topology */
@@ -96,4 +230,11 @@ void kgd2kfd_interrupt(struct kfd_dev *dev, const void *ih_ring_entry);
 void kgd2kfd_suspend(struct kfd_dev *dev);
 int kgd2kfd_resume(struct kfd_dev *dev);
 
+/* amdkfd Apertures */
+int kfd_init_apertures(struct kfd_process *process);
+
+uint64_t kfd_get_number_elems(struct kfd_dev *kfd);
+phys_addr_t kfd_get_process_doorbells(struct kfd_dev *dev,
+					struct kfd_process *process);
+
 #endif
diff --git a/drivers/gpu/drm/radeon/amdkfd/kfd_process.c b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
new file mode 100644
index 0000000..c95fd93
--- /dev/null
+++ b/drivers/gpu/drm/radeon/amdkfd/kfd_process.c
@@ -0,0 +1,322 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/mutex.h>
+#include <linux/log2.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/notifier.h>
+struct mm_struct;
+
+#include "kfd_priv.h"
+
+/*
+ * Initial size for the array of queues.
+ * The allocated size is doubled each time
+ * it is exceeded up to MAX_PROCESS_QUEUES.
+ */
+#define INITIAL_QUEUE_ARRAY_SIZE 16
+
+/* List of struct kfd_process (field kfd_process). Unique/indexed by mm_struct*. */
+#define KFD_PROCESS_TABLE_SIZE 5 /* bits: 32 entries */
+static DEFINE_HASHTABLE(kfd_processes_table, KFD_PROCESS_TABLE_SIZE);
+static DEFINE_MUTEX(kfd_processes_mutex);
+
+DEFINE_STATIC_SRCU(kfd_processes_srcu);
+
+static struct kfd_process *find_process(const struct task_struct *thread);
+static struct kfd_process *create_process(const struct task_struct *thread);
+
+struct kfd_process *kfd_create_process(const struct task_struct *thread)
+{
+	struct kfd_process *process;
+
+	if (thread->mm == NULL)
+		return ERR_PTR(-EINVAL);
+
+	/* Only the pthreads threading model is supported. */
+	if (thread->group_leader->mm != thread->mm)
+		return ERR_PTR(-EINVAL);
+
+	/* Take mmap_sem because we call __mmu_notifier_register inside */
+	down_write(&thread->mm->mmap_sem);
+
+	/*
+	 * take kfd processes mutex before starting of process creation
+	 * so there won't be a case where two threads of the same process
+	 * create two kfd_process structures
+	 */
+	mutex_lock(&kfd_processes_mutex);
+
+	/* A prior open of /dev/kfd could have already created the process. */
+	process = find_process(thread);
+	if (process)
+		pr_debug("kfd: process already found\n");
+
+	if (!process)
+		process = create_process(thread);
+
+	mutex_unlock(&kfd_processes_mutex);
+
+	up_write(&thread->mm->mmap_sem);
+
+	return process;
+}
+
+struct kfd_process *kfd_get_process(const struct task_struct *thread)
+{
+	struct kfd_process *process;
+
+	if (thread->mm == NULL)
+		return ERR_PTR(-EINVAL);
+
+	/* Only the pthreads threading model is supported. */
+	if (thread->group_leader->mm != thread->mm)
+		return ERR_PTR(-EINVAL);
+
+	process = find_process(thread);
+
+	return process;
+}
+
+static struct kfd_process *find_process_by_mm(const struct mm_struct *mm)
+{
+	struct kfd_process *process;
+
+	hash_for_each_possible_rcu(kfd_processes_table, process, kfd_processes, (uintptr_t)mm)
+		if (process->mm == mm)
+			return process;
+
+	return NULL;
+}
+
+static struct kfd_process *find_process(const struct task_struct *thread)
+{
+	struct kfd_process *p;
+	int idx;
+
+	idx = srcu_read_lock(&kfd_processes_srcu);
+	p = find_process_by_mm(thread->mm);
+	srcu_read_unlock(&kfd_processes_srcu, idx);
+
+	return p;
+}
+
+static void kfd_process_destroy_delayed(struct rcu_head *rcu)
+{
+	struct kfd_process *p;
+
+	p = container_of(rcu, struct kfd_process, rcu);
+	BUG_ON(atomic_read(&p->mm->mm_count) <= 0);
+
+	mmdrop(p->mm);
+	kfree(p);
+}
+
+static void kfd_process_notifier_release(struct mmu_notifier *mn,
+					struct mm_struct *mm)
+{
+	struct kfd_process_device *pdd, *temp;
+	struct kfd_process *p;
+
+	/*
+	 * The kfd_process structure can not be free because the
+	 * mmu_notifier srcu is read locked
+	 */
+	p = container_of(mn, struct kfd_process, mmu_notifier);
+	BUG_ON(p->mm != mm);
+
+	mutex_lock(&kfd_processes_mutex);
+	hash_del_rcu(&p->kfd_processes);
+	mutex_unlock(&kfd_processes_mutex);
+	synchronize_srcu(&kfd_processes_srcu);
+
+	mutex_lock(&p->mutex);
+
+	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
+		list_del(&pdd->per_device_list);
+		kfree(pdd);
+	}
+
+	kfd_pasid_free(p->pasid);
+
+	mutex_unlock(&p->mutex);
+
+	mutex_destroy(&p->mutex);
+
+	kfree(p->queues);
+
+	/*
+	 * Because we drop mm_count inside kfd_process_destroy_delayed
+	 * and because the mmu_notifier_unregister function also drop
+	 * mm_count we need to take an extra count here.
+	 */
+	atomic_inc(&p->mm->mm_count);
+	mmu_notifier_unregister_no_release(&p->mmu_notifier, p->mm);
+	mmu_notifier_call_srcu(&p->rcu, &kfd_process_destroy_delayed);
+}
+
+static const struct mmu_notifier_ops kfd_process_mmu_notifier_ops = {
+	.release = kfd_process_notifier_release,
+};
+
+static struct kfd_process *create_process(const struct task_struct *thread)
+{
+	struct kfd_process *process;
+	int err = -ENOMEM;
+
+	process = kzalloc(sizeof(*process), GFP_KERNEL);
+
+	if (!process)
+		goto err_alloc_process;
+
+	process->queues = kmalloc_array(INITIAL_QUEUE_ARRAY_SIZE, sizeof(process->queues[0]), GFP_KERNEL);
+	if (!process->queues)
+		goto err_alloc_queues;
+
+	process->pasid = kfd_pasid_alloc();
+	if (process->pasid == 0)
+		goto err_alloc_pasid;
+
+	mutex_init(&process->mutex);
+
+	process->mm = thread->mm;
+
+	/* register notifier */
+	process->mmu_notifier.ops = &kfd_process_mmu_notifier_ops;
+	err = __mmu_notifier_register(&process->mmu_notifier, process->mm);
+	if (err)
+		goto err_mmu_notifier;
+
+	hash_add_rcu(kfd_processes_table, &process->kfd_processes, (uintptr_t)process->mm);
+
+	process->lead_thread = thread->group_leader;
+
+	process->queue_array_size = INITIAL_QUEUE_ARRAY_SIZE;
+
+	INIT_LIST_HEAD(&process->per_device_data);
+
+	return process;
+
+err_mmu_notifier:
+	kfd_pasid_free(process->pasid);
+err_alloc_pasid:
+	kfree(process->queues);
+err_alloc_queues:
+	kfree(process);
+err_alloc_process:
+	return ERR_PTR(err);
+}
+
+struct kfd_process_device *kfd_get_process_device_data(struct kfd_dev *dev,
+							struct kfd_process *p,
+							int create_pdd)
+{
+	struct kfd_process_device *pdd = NULL;
+
+	list_for_each_entry(pdd, &p->per_device_data, per_device_list)
+		if (pdd->dev == dev)
+			return pdd;
+
+	if (create_pdd) {
+		pdd = kzalloc(sizeof(*pdd), GFP_KERNEL);
+		if (pdd != NULL) {
+			pdd->dev = dev;
+			list_add(&pdd->per_device_list, &p->per_device_data);
+		}
+	}
+
+	return pdd;
+}
+
+/*
+ * Direct the IOMMU to bind the process (specifically the pasid->mm) to the device.
+ * Unbinding occurs when the process dies or the device is removed.
+ *
+ * Assumes that the process lock is held.
+ */
+struct kfd_process_device *kfd_bind_process_to_device(struct kfd_dev *dev,
+							struct kfd_process *p)
+{
+	struct kfd_process_device *pdd = kfd_get_process_device_data(dev, p, 1);
+
+	if (pdd == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	if (pdd->bound)
+		return pdd;
+
+	pdd->bound = true;
+
+	return pdd;
+}
+
+void kfd_unbind_process_from_device(struct kfd_dev *dev, unsigned int pasid)
+{
+	struct kfd_process *p;
+	struct kfd_process_device *pdd;
+	int idx, i;
+
+	BUG_ON(dev == NULL);
+
+	idx = srcu_read_lock(&kfd_processes_srcu);
+
+	hash_for_each_rcu(kfd_processes_table, i, p, kfd_processes)
+		if (p->pasid == pasid)
+			break;
+
+	srcu_read_unlock(&kfd_processes_srcu, idx);
+
+	BUG_ON(p->pasid != pasid);
+
+	mutex_lock(&p->mutex);
+
+	pdd = kfd_get_process_device_data(dev, p, 0);
+
+	/*
+	 * Just mark pdd as unbound, because we still need it to call
+	 * amd_iommu_unbind_pasid() in when the process exits.
+	 * We don't call amd_iommu_unbind_pasid() here
+	 * because the IOMMU called us.
+	 */
+	if (pdd)
+		pdd->bound = false;
+
+	mutex_unlock(&p->mutex);
+}
+
+struct kfd_process_device *kfd_get_first_process_device_data(struct kfd_process *p)
+{
+	return list_first_entry(&p->per_device_data, struct kfd_process_device, per_device_list);
+}
+
+struct kfd_process_device *kfd_get_next_process_device_data(struct kfd_process *p, struct kfd_process_device *pdd)
+{
+	if (list_is_last(&pdd->per_device_list, &p->per_device_data))
+		return NULL;
+	return list_next_entry(pdd, per_device_list);
+}
+
+bool kfd_has_process_device_data(struct kfd_process *p)
+{
+	return !(list_empty(&p->per_device_data));
+}
diff --git a/drivers/gpu/drm/radeon/radeon_kfd.c b/drivers/gpu/drm/radeon/radeon_kfd.c
index ebad935..6a87831 100644
--- a/drivers/gpu/drm/radeon/radeon_kfd.c
+++ b/drivers/gpu/drm/radeon/radeon_kfd.c
@@ -177,8 +177,7 @@ static u32 pool_to_domain(enum kgd_memory_pool p)
 static int init_sa_manager(struct kgd_dev *kgd, unsigned int size)
 {
 	struct radeon_device *rdev = (struct radeon_device *)kgd;
-	u64 max_offset[4];
-	int r, i;
+	int r;
 
 	BUG_ON(kgd == NULL);
 
@@ -191,21 +190,9 @@ static int init_sa_manager(struct kgd_dev *kgd, unsigned int size)
 	if (r)
 		return r;
 
-	/* Try to pin buffer in first 8MB, 16MB or 64MB of GART */
-	max_offset[0] = roundup(size, 8 * 1024 * 1024);
-	max_offset[1] = roundup(size, 16 * 1024 * 1024);
-	max_offset[2] = roundup(size, 64 * 1024 * 1024);
-	max_offset[3] = 0;
-
-	for (i = 0 ; i < 4 ; i++) {
-
-		r = radeon_sa_bo_manager_start(rdev, &rdev->kfd_bo,
-						max_offset[i]);
-		if (!r)
-			return r;
-	}
-
-	radeon_sa_bo_manager_fini(rdev, &rdev->kfd_bo);
+	r = radeon_sa_bo_manager_start(rdev, &rdev->kfd_bo);
+	if (r)
+		radeon_sa_bo_manager_fini(rdev, &rdev->kfd_bo);
 
 	return r;
 }
-- 
1.9.1

