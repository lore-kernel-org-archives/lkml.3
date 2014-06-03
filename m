Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbaFCSXw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:23:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:56227 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073AbaFCSXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:23:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,967,1392192000"; 
   d="scan'208";a="541915368"
Date: Tue, 3 Jun 2014 11:23:33 -0700
From: Tadeusz Struk <tadeusz.struk@intel.com>
To: herbert@gondor.apana.org.au
Cc: tadeusz.struk@intel.com, john.griffin@intel.com, bruce.w.allan@intel.com,
        karen.xiang@intel.com, pingchaox.yang@intel.com, bo.cui@intel.com,
        davem@davemloft.net, qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org, ben@decadent.org.uk
Subject: [RFC][PATCH 2/4] crypto: QAT FW Loader
Message-ID: <20140603182333.GA18701@gitlad.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a firmware loader module that loads microcode and manages acceleration engines.

Signed-off-by: Karen Xiang <karen.xiang@intel.com>
Signed-off-by: Pingchaox Yang <pingchaox.yang@intel.com>
Acked-by: Bo Cui <bo.cui@intel.com>
Reviewed-by: Bruce W. Allan <bruce.w.allan@intel.com>
---
 drivers/crypto/qat/qat_common/Makefile             |    4 +-
 .../qat/qat_common/icp_qat_fw_loader_handle.h      |   78 ++
 drivers/crypto/qat/qat_common/icp_qat_hal.h        |  125 ++
 drivers/crypto/qat/qat_common/icp_qat_uclo.h       |  377 ++++++
 drivers/crypto/qat/qat_common/qat_hal.c            | 1402 ++++++++++++++++++++
 drivers/crypto/qat/qat_common/qat_uclo.c           | 1191 +++++++++++++++++
 6 files changed, 3176 insertions(+), 1 deletion(-)
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_hal.h
 create mode 100644 drivers/crypto/qat/qat_common/icp_qat_uclo.h
 create mode 100644 drivers/crypto/qat/qat_common/qat_hal.c
 create mode 100644 drivers/crypto/qat/qat_common/qat_uclo.c

diff --git a/drivers/crypto/qat/qat_common/Makefile b/drivers/crypto/qat/qat_common/Makefile
index a0c21ea..5f71a52 100644
--- a/drivers/crypto/qat/qat_common/Makefile
+++ b/drivers/crypto/qat/qat_common/Makefile
@@ -8,4 +8,6 @@ intel_qat-objs := adf_cfg.o \
 	adf_transport.o \
 	adf_transport_debug.o \
 	qat_crypto.o \
-	qat_algs.o
+	qat_algs.o \
+	qat_uclo.o \
+	qat_hal.o
diff --git a/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
new file mode 100644
index 0000000..5e1aa40
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_fw_loader_handle.h
@@ -0,0 +1,78 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef __ICP_QAT_FW_LOADER_HANDLE_H__
+#define __ICP_QAT_FW_LOADER_HANDLE_H__
+#include "icp_qat_uclo.h"
+
+struct icp_qat_fw_loader_ae_data {
+	unsigned int state;
+	unsigned int ustore_size;
+	unsigned int free_addr;
+	unsigned int free_size;
+	unsigned int live_ctx_mask;
+};
+
+struct icp_qat_fw_loader_hal_handle {
+	struct icp_qat_fw_loader_ae_data aes[ICP_QAT_UCLO_MAX_AE];
+	unsigned int ae_mask;
+	unsigned int slice_mask;
+	unsigned int revision_id;
+	unsigned int ae_max_num;
+	unsigned int upc_mask;
+	unsigned int max_ustore;
+};
+
+struct icp_qat_fw_loader_handle {
+	struct icp_qat_fw_loader_hal_handle *hal_handle;
+	void *obj_handle;
+	void __iomem *hal_sram_addr_v;
+	void __iomem *hal_cap_g_ctl_csr_addr_v;
+	void __iomem *hal_cap_ae_xfer_csr_addr_v;
+	void __iomem *hal_cap_ae_local_csr_addr_v;
+	void __iomem *hal_ep_csr_addr_v;
+};
+#endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_hal.h b/drivers/crypto/qat/qat_common/icp_qat_hal.h
new file mode 100644
index 0000000..85b6d24
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_hal.h
@@ -0,0 +1,125 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef __ICP_QAT_HAL_H
+#define __ICP_QAT_HAL_H
+#include "icp_qat_fw_loader_handle.h"
+
+enum hal_global_csr {
+	MISC_CONTROL = 0x04,
+	ICP_RESET = 0x0c,
+	ICP_GLOBAL_CLK_ENABLE = 0x50
+};
+
+enum hal_ae_csr {
+	USTORE_ADDRESS = 0x000,
+	USTORE_DATA_LOWER = 0x004,
+	USTORE_DATA_UPPER = 0x008,
+	ALU_OUT = 0x010,
+	CTX_ARB_CNTL = 0x014,
+	CTX_ENABLES = 0x018,
+	CC_ENABLE = 0x01c,
+	CSR_CTX_POINTER = 0x020,
+	CTX_STS_INDIRECT = 0x040,
+	ACTIVE_CTX_STATUS = 0x044,
+	CTX_SIG_EVENTS_INDIRECT = 0x048,
+	CTX_SIG_EVENTS_ACTIVE = 0x04c,
+	CTX_WAKEUP_EVENTS_INDIRECT = 0x050,
+	LM_ADDR_0_INDIRECT = 0x060,
+	LM_ADDR_1_INDIRECT = 0x068,
+	INDIRECT_LM_ADDR_0_BYTE_INDEX = 0x0e0,
+	INDIRECT_LM_ADDR_1_BYTE_INDEX = 0x0e8,
+	FUTURE_COUNT_SIGNAL_INDIRECT = 0x078,
+	TIMESTAMP_LOW = 0x0c0,
+	TIMESTAMP_HIGH = 0x0c4,
+	PROFILE_COUNT = 0x144,
+	SIGNATURE_ENABLE = 0x150,
+	AE_MISC_CONTROL = 0x160,
+	LOCAL_CSR_STATUS = 0x180,
+};
+
+#define UA_ECS                      (0x1 << 31)
+#define ACS_ABO_BITPOS              31
+#define ACS_ACNO                    0x7
+#define CE_ENABLE_BITPOS            0x8
+#define CE_LMADDR_0_GLOBAL_BITPOS   16
+#define CE_LMADDR_1_GLOBAL_BITPOS   17
+#define CE_NN_MODE_BITPOS           20
+#define CE_REG_PAR_ERR_BITPOS       25
+#define CE_BREAKPOINT_BITPOS        27
+#define CE_CNTL_STORE_PARITY_ERROR_BITPOS 29
+#define CE_INUSE_CONTEXTS_BITPOS    31
+#define CE_NN_MODE                  (0x1 << CE_NN_MODE_BITPOS)
+#define CE_INUSE_CONTEXTS           (0x1 << CE_INUSE_CONTEXTS_BITPOS)
+#define XCWE_VOLUNTARY              (0x1)
+#define LCS_STATUS          (0x1)
+#define MMC_SHARE_CS_BITPOS         2
+#define GLOBAL_CSR                0xA00
+
+#define SET_CAP_CSR(handle, csr, val) \
+	ADF_CSR_WR(handle->hal_cap_g_ctl_csr_addr_v, csr, val)
+#define GET_CAP_CSR(handle, csr) \
+	ADF_CSR_RD(handle->hal_cap_g_ctl_csr_addr_v, csr)
+#define SET_GLB_CSR(handle, csr, val) SET_CAP_CSR(handle, csr + GLOBAL_CSR, val)
+#define GET_GLB_CSR(handle, csr) GET_CAP_CSR(handle, GLOBAL_CSR + csr)
+#define AE_CSR(handle, ae) \
+	(handle->hal_cap_ae_local_csr_addr_v + \
+	((ae & handle->hal_handle->ae_mask) << 12))
+#define AE_CSR_ADDR(handle, ae, csr) (AE_CSR(handle, ae) + (0x3ff & csr))
+#define SET_AE_CSR(handle, ae, csr, val) \
+	ADF_CSR_WR(AE_CSR_ADDR(handle, ae, csr), 0, val)
+#define GET_AE_CSR(handle, ae, csr) ADF_CSR_RD(AE_CSR_ADDR(handle, ae, csr), 0)
+#define AE_XFER(handle, ae) \
+	(handle->hal_cap_ae_xfer_csr_addr_v + \
+	((ae & handle->hal_handle->ae_mask) << 12))
+#define AE_XFER_ADDR(handle, ae, reg) (AE_XFER(handle, ae) + \
+	((reg & 0xff) << 2))
+#define SET_AE_XFER(handle, ae, reg, val) \
+	ADF_CSR_WR(AE_XFER_ADDR(handle, ae, reg), 0, val)
+#define SRAM_WRITE(handle, addr, val) \
+	ADF_CSR_WR(handle->hal_sram_addr_v, addr, val)
+#define SRAM_READ(handle, addr) ADF_CSR_RD(handle->hal_sram_addr_v, addr)
+#endif
diff --git a/drivers/crypto/qat/qat_common/icp_qat_uclo.h b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
new file mode 100644
index 0000000..120fbce
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/icp_qat_uclo.h
@@ -0,0 +1,377 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#ifndef __ICP_QAT_UCLO_H__
+#define __ICP_QAT_UCLO_H__
+
+#define ICP_QAT_AC_C_CPU_TYPE     0x00400000
+#define ICP_QAT_UCLO_MAX_AE       12
+#define ICP_QAT_UCLO_MAX_CTX      8
+#define ICP_QAT_UCLO_MAX_UIMAGE   (ICP_QAT_UCLO_MAX_AE * ICP_QAT_UCLO_MAX_CTX)
+#define ICP_QAT_UCLO_MAX_USTORE   0x4000
+#define ICP_QAT_UCLO_MAX_XFER_REG 128
+#define ICP_QAT_UCLO_MAX_GPR_REG  128
+#define ICP_QAT_UCLO_MAX_NN_REG   128
+#define ICP_QAT_UCLO_MAX_LMEM_REG 1024
+#define ICP_QAT_UCLO_AE_ALL_CTX   0xff
+#define ICP_QAT_UOF_OBJID_LEN     8
+#define ICP_QAT_UOF_FID 0xc6c2
+#define ICP_QAT_UOF_MAJVER 0x4
+#define ICP_QAT_UOF_MINVER 0x11
+#define ICP_QAT_UOF_NN_MODE_NOTCARE   0xff
+#define ICP_QAT_UOF_OBJS        "UOF_OBJS"
+#define ICP_QAT_UOF_STRT        "UOF_STRT"
+#define ICP_QAT_UOF_GTID        "UOF_GTID"
+#define ICP_QAT_UOF_IMAG        "UOF_IMAG"
+#define ICP_QAT_UOF_IMEM        "UOF_IMEM"
+#define ICP_QAT_UOF_MSEG        "UOF_MSEG"
+#define ICP_QAT_UOF_LOCAL_SCOPE     1
+#define ICP_QAT_UOF_INIT_EXPR               0
+#define ICP_QAT_UOF_INIT_REG                1
+#define ICP_QAT_UOF_INIT_REG_CTX            2
+#define ICP_QAT_UOF_INIT_EXPR_ENDIAN_SWAP   3
+
+#define ICP_QAT_CTX_MODE(ae_mode) ((ae_mode) & 0xf)
+#define ICP_QAT_NN_MODE(ae_mode) (((ae_mode) >> 0x4) & 0xf)
+#define ICP_QAT_SHARED_USTORE_MODE(ae_mode) (((ae_mode) >> 0xb) & 0x1)
+#define RELOADABLE_CTX_SHARED_MODE(ae_mode) (((ae_mode) >> 0xc) & 0x1)
+
+#define ICP_QAT_LOC_MEM0_MODE(ae_mode) (((ae_mode) >> 0x8) & 0x1)
+#define ICP_QAT_LOC_MEM1_MODE(ae_mode) (((ae_mode) >> 0x9) & 0x1)
+
+enum icp_qat_uof_mem_region {
+	ICP_QAT_UOF_SRAM_REGION = 0x0,
+	ICP_QAT_UOF_LMEM_REGION = 0x3,
+	ICP_QAT_UOF_UMEM_REGION = 0x5
+};
+
+enum icp_qat_uof_regtype {
+	ICP_NO_DEST,
+	ICP_GPA_REL,
+	ICP_GPA_ABS,
+	ICP_GPB_REL,
+	ICP_GPB_ABS,
+	ICP_SR_REL,
+	ICP_SR_RD_REL,
+	ICP_SR_WR_REL,
+	ICP_SR_ABS,
+	ICP_SR_RD_ABS,
+	ICP_SR_WR_ABS,
+	ICP_DR_REL,
+	ICP_DR_RD_REL,
+	ICP_DR_WR_REL,
+	ICP_DR_ABS,
+	ICP_DR_RD_ABS,
+	ICP_DR_WR_ABS,
+	ICP_LMEM,
+	ICP_LMEM0,
+	ICP_LMEM1,
+	ICP_NEIGH_REL,
+};
+
+struct icp_qat_uclo_page {
+	struct icp_qat_uclo_encap_page *encap_page;
+	struct icp_qat_uclo_region *region;
+	unsigned int flags;
+};
+
+struct icp_qat_uclo_region {
+	struct icp_qat_uclo_page *loaded;
+	struct icp_qat_uclo_page *page;
+};
+
+struct icp_qat_uclo_aeslice {
+	struct icp_qat_uclo_region *regions;
+	struct icp_qat_uclo_page *page;
+	struct icp_qat_uclo_page *cur_page[ICP_QAT_UCLO_MAX_CTX];
+	struct icp_qat_uclo_encapme *encap_image;
+	unsigned int ctx_mask_assigned;
+	unsigned int new_uaddr[ICP_QAT_UCLO_MAX_CTX];
+};
+
+struct icp_qat_uclo_aedata {
+	unsigned int slice_num;
+	unsigned int eff_ustore_size;
+	struct icp_qat_uclo_aeslice ae_slices[ICP_QAT_UCLO_MAX_CTX];
+};
+
+struct icp_qat_uof_encap_obj {
+	char *beg_uof;
+	struct icp_qat_uof_objhdr *obj_hdr;
+	struct icp_qat_uof_chunkhdr *chunk_hdr;
+	struct icp_qat_uof_varmem_seg *var_mem_seg;
+};
+
+struct icp_qat_uclo_encap_uwblock {
+	unsigned int start_addr;
+	unsigned int words_num;
+	uint64_t micro_words;
+};
+
+struct icp_qat_uclo_encap_page {
+	unsigned int def_page;
+	unsigned int page_region;
+	unsigned int beg_addr_v;
+	unsigned int beg_addr_p;
+	unsigned int micro_words_num;
+	unsigned int uwblock_num;
+	struct icp_qat_uclo_encap_uwblock *uwblock;
+};
+
+struct icp_qat_uclo_encapme {
+	struct icp_qat_uof_image *img_ptr;
+	struct icp_qat_uclo_encap_page *page;
+	unsigned int ae_reg_num;
+	struct icp_qat_uof_ae_reg *ae_reg;
+	unsigned int init_regsym_num;
+	struct icp_qat_uof_init_regsym *init_regsym;
+	unsigned int sbreak_num;
+	struct icp_qat_uof_sbreak *sbreak;
+	unsigned int uwords_num;
+};
+
+struct icp_qat_uclo_init_mem_table {
+	unsigned int entry_num;
+	struct icp_qat_uof_initmem *init_mem;
+};
+
+struct icp_qat_uclo_objhdr {
+	char *file_buff;
+	unsigned int checksum;
+	unsigned int size;
+};
+
+struct icp_qat_uof_strtable {
+	unsigned int table_len;
+	unsigned int reserved;
+	uint64_t strings;
+};
+
+struct icp_qat_uclo_objhandle {
+	unsigned int prod_type;
+	unsigned int prod_rev;
+	struct icp_qat_uclo_objhdr *obj_hdr;
+	struct icp_qat_uof_encap_obj encap_uof_obj;
+	struct icp_qat_uof_strtable str_table;
+	struct icp_qat_uclo_encapme ae_uimage[ICP_QAT_UCLO_MAX_UIMAGE];
+	struct icp_qat_uclo_aedata ae_data[ICP_QAT_UCLO_MAX_AE];
+	struct icp_qat_uclo_init_mem_table init_mem_tab;
+	struct icp_qat_uof_batch_init *lm_init_tab[ICP_QAT_UCLO_MAX_AE];
+	struct icp_qat_uof_batch_init *umem_init_tab[ICP_QAT_UCLO_MAX_AE];
+	int uimage_num;
+	int uword_in_bytes;
+	int global_inited;
+	unsigned int ae_num;
+	unsigned int ustore_phy_size;
+	void *obj_buf;
+	uint64_t *uword_buf;
+};
+
+struct icp_qat_uof_uword_block {
+	unsigned int start_addr;
+	unsigned int words_num;
+	unsigned int uword_offset;
+	unsigned int reserved;
+};
+
+struct icp_qat_uof_filehdr {
+	unsigned short file_id;
+	unsigned short reserved1;
+	char min_ver;
+	char maj_ver;
+	unsigned short reserved2;
+	unsigned short max_chunks;
+	unsigned short num_chunks;
+};
+
+struct icp_qat_uof_filechunkhdr {
+	char chunk_id[ICP_QAT_UOF_OBJID_LEN];
+	unsigned int checksum;
+	unsigned int offset;
+	unsigned int size;
+};
+
+struct icp_qat_uof_objhdr {
+	unsigned int cpu_type;
+	unsigned short min_cpu_ver;
+	unsigned short max_cpu_ver;
+	short max_chunks;
+	short num_chunks;
+	unsigned int reserved1;
+	unsigned int reserved2;
+};
+
+struct icp_qat_uof_chunkhdr {
+	char chunk_id[ICP_QAT_UOF_OBJID_LEN];
+	unsigned int offset;
+	unsigned int size;
+};
+
+struct icp_qat_uof_memvar_attr {
+	unsigned int offset_in_byte;
+	unsigned int value;
+};
+
+struct icp_qat_uof_initmem {
+	unsigned int sym_name;
+	char region;
+	char scope;
+	unsigned short reserved1;
+	unsigned int addr;
+	unsigned int num_in_bytes;
+	unsigned int val_attr_num;
+};
+
+struct icp_qat_uof_init_regsym {
+	unsigned int sym_name;
+	char init_type;
+	char value_type;
+	char reg_type;
+	unsigned char ctx;
+	unsigned int reg_addr;
+	unsigned int value;
+};
+
+struct icp_qat_uof_varmem_seg {
+	unsigned int sram_base;
+	unsigned int sram_size;
+	unsigned int sram_alignment;
+	unsigned int sdram_base;
+	unsigned int sdram_size;
+	unsigned int sdram_alignment;
+	unsigned int sdram1_base;
+	unsigned int sdram1_size;
+	unsigned int sdram1_alignment;
+	unsigned int scratch_base;
+	unsigned int scratch_size;
+	unsigned int scratch_alignment;
+};
+
+struct icp_qat_uof_gtid {
+	char tool_id[ICP_QAT_UOF_OBJID_LEN];
+	int tool_ver;
+	unsigned int reserved1;
+	unsigned int reserved2;
+};
+
+struct icp_qat_uof_sbreak {
+	unsigned int page_num;
+	unsigned int virt_uaddr;
+	unsigned char sbreak_type;
+	unsigned char reg_type;
+	unsigned short reserved1;
+	unsigned int addr_offset;
+	unsigned int reg_addr;
+};
+
+struct icp_qat_uof_code_page {
+	unsigned int page_region;
+	unsigned int page_num;
+	unsigned char def_page;
+	unsigned char reserved2;
+	unsigned short reserved1;
+	unsigned int beg_addr_v;
+	unsigned int beg_addr_p;
+	unsigned int neigh_reg_tab_offset;
+	unsigned int uc_var_tab_offset;
+	unsigned int imp_var_tab_offset;
+	unsigned int imp_expr_tab_offset;
+	unsigned int code_area_offset;
+};
+
+struct icp_qat_uof_image {
+	unsigned int img_name;
+	unsigned int ae_assigned;
+	unsigned int ctx_assigned;
+	unsigned int cpu_type;
+	unsigned int entry_address;
+	unsigned int fill_pattern[2];
+	unsigned int reloadable_size;
+	unsigned char sensitivity;
+	unsigned char reserved;
+	unsigned short ae_mode;
+	unsigned short max_ver;
+	unsigned short min_ver;
+	unsigned short image_attrib;
+	unsigned short reserved2;
+	unsigned short page_region_num;
+	unsigned short numpages;
+	unsigned int reg_tab_offset;
+	unsigned int init_reg_sym_tab;
+	unsigned int sbreak_tab;
+	unsigned int app_metadata;
+};
+
+struct icp_qat_uof_objtable {
+	unsigned int entry_num;
+};
+
+struct icp_qat_uof_ae_reg {
+	unsigned int name;
+	unsigned int vis_name;
+	unsigned short type;
+	unsigned short addr;
+	unsigned short access_mode;
+	unsigned char visible;
+	unsigned char reserved1;
+	unsigned short ref_count;
+	unsigned short reserved2;
+	unsigned int xo_id;
+};
+
+struct icp_qat_uof_code_area {
+	unsigned int micro_words_num;
+	unsigned int uword_block_tab;
+};
+
+struct icp_qat_uof_batch_init {
+	unsigned int ae;
+	unsigned int addr;
+	unsigned int *value;
+	unsigned int size;
+	struct icp_qat_uof_batch_init *next;
+};
+#endif
diff --git a/drivers/crypto/qat/qat_common/qat_hal.c b/drivers/crypto/qat/qat_common/qat_hal.c
new file mode 100644
index 0000000..c0b3519
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_hal.c
@@ -0,0 +1,1402 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/slab.h>
+
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "icp_qat_hal.h"
+#include "icp_qat_uclo.h"
+
+#define BAD_REGADDR               0xffff
+#define MAX_RETRY_TIMES           10000
+#define INIT_CTX_ARB_VALUE        0x0
+#define INIT_CTX_ENABLE_VALUE     0x0
+#define INIT_PC_VALUE             0x0
+#define INIT_WAKEUP_EVENTS_VALUE  0x1
+#define INIT_SIG_EVENTS_VALUE     0x1
+#define INIT_CCENABLE_VALUE       0x2000
+#define RST_CSR_QAT_LSB           20
+#define RST_CSR_AE_LSB		  0
+#define MC_TIMESTAMP_ENABLE       (0x1 << 7)
+
+#define IGNORE_W1C_MASK ((~(1 << CE_BREAKPOINT_BITPOS)) & \
+	(~(1 << CE_CNTL_STORE_PARITY_ERROR_BITPOS)) & \
+	(~(1 << CE_REG_PAR_ERR_BITPOS)))
+#define INSERT_IMMED_GPRA_CONST(inst, const_val) \
+	(inst = ((inst & 0xFFFF00C03FFull) | \
+		((((const_val) << 12) & 0x0FF00000ull) | \
+		(((const_val) << 10) & 0x0003FC00ull))))
+#define INSERT_IMMED_GPRB_CONST(inst, const_val) \
+	(inst = ((inst & 0xFFFF00FFF00ull) | \
+		((((const_val) << 12) & 0x0FF00000ull) | \
+		(((const_val) <<  0) & 0x000000FFull))))
+
+#define AE(handle, ae) handle->hal_handle->aes[ae]
+
+static const uint64_t inst_4b[] = {
+	0x0F0400C0000ull, 0x0F4400C0000ull, 0x0F040000300ull, 0x0F440000300ull,
+	0x0FC066C0000ull, 0x0F0000C0300ull, 0x0F0000C0300ull, 0x0F0000C0300ull,
+	0x0A021000000ull
+};
+
+static const uint64_t inst[] = {
+	0x0F0000C0000ull, 0x0F000000380ull, 0x0D805000011ull, 0x0FC082C0300ull,
+	0x0F0000C0300ull, 0x0F0000C0300ull, 0x0F0000C0300ull, 0x0F0000C0300ull,
+	0x0A0643C0000ull, 0x0BAC0000301ull, 0x0D802000101ull, 0x0F0000C0001ull,
+	0x0FC066C0001ull, 0x0F0000C0300ull, 0x0F0000C0300ull, 0x0F0000C0300ull,
+	0x0F000400300ull, 0x0A0610C0000ull, 0x0BAC0000301ull, 0x0D804400101ull,
+	0x0A0580C0000ull, 0x0A0581C0000ull, 0x0A0582C0000ull, 0x0A0583C0000ull,
+	0x0A0584C0000ull, 0x0A0585C0000ull, 0x0A0586C0000ull, 0x0A0587C0000ull,
+	0x0A0588C0000ull, 0x0A0589C0000ull, 0x0A058AC0000ull, 0x0A058BC0000ull,
+	0x0A058CC0000ull, 0x0A058DC0000ull, 0x0A058EC0000ull, 0x0A058FC0000ull,
+	0x0A05C0C0000ull, 0x0A05C1C0000ull, 0x0A05C2C0000ull, 0x0A05C3C0000ull,
+	0x0A05C4C0000ull, 0x0A05C5C0000ull, 0x0A05C6C0000ull, 0x0A05C7C0000ull,
+	0x0A05C8C0000ull, 0x0A05C9C0000ull, 0x0A05CAC0000ull, 0x0A05CBC0000ull,
+	0x0A05CCC0000ull, 0x0A05CDC0000ull, 0x0A05CEC0000ull, 0x0A05CFC0000ull,
+	0x0A0400C0000ull, 0x0B0400C0000ull, 0x0A0401C0000ull, 0x0B0401C0000ull,
+	0x0A0402C0000ull, 0x0B0402C0000ull, 0x0A0403C0000ull, 0x0B0403C0000ull,
+	0x0A0404C0000ull, 0x0B0404C0000ull, 0x0A0405C0000ull, 0x0B0405C0000ull,
+	0x0A0406C0000ull, 0x0B0406C0000ull, 0x0A0407C0000ull, 0x0B0407C0000ull,
+	0x0A0408C0000ull, 0x0B0408C0000ull, 0x0A0409C0000ull, 0x0B0409C0000ull,
+	0x0A040AC0000ull, 0x0B040AC0000ull, 0x0A040BC0000ull, 0x0B040BC0000ull,
+	0x0A040CC0000ull, 0x0B040CC0000ull, 0x0A040DC0000ull, 0x0B040DC0000ull,
+	0x0A040EC0000ull, 0x0B040EC0000ull, 0x0A040FC0000ull, 0x0B040FC0000ull,
+	0x0D81581C010ull, 0x0E000010000ull, 0x0E000010000ull,
+};
+
+void qat_hal_set_live_ctx(struct icp_qat_fw_loader_handle *handle,
+			  unsigned char ae, unsigned int ctx_mask)
+{
+	AE(handle, ae).live_ctx_mask = ctx_mask;
+}
+
+#define CSR_RETRY_TIMES 500
+static int qat_hal_rd_ae_csr(struct icp_qat_fw_loader_handle *handle,
+			     unsigned char ae, unsigned int csr,
+			     unsigned int *value)
+{
+	unsigned int iterations = CSR_RETRY_TIMES;
+
+	do {
+		*value = GET_AE_CSR(handle, ae, csr);
+		if (!(GET_AE_CSR(handle, ae, LOCAL_CSR_STATUS) & LCS_STATUS))
+			return 0;
+	} while (iterations--);
+
+	pr_err("QAT: Read CSR timeout\n");
+	return -EFAULT;
+}
+
+static int qat_hal_wr_ae_csr(struct icp_qat_fw_loader_handle *handle,
+			     unsigned char ae, unsigned int csr,
+			     unsigned int value)
+{
+	unsigned int iterations = CSR_RETRY_TIMES;
+
+	do {
+		SET_AE_CSR(handle, ae, csr, value);
+		if (!(GET_AE_CSR(handle, ae, LOCAL_CSR_STATUS) & LCS_STATUS))
+			return 0;
+	} while (iterations--);
+
+	pr_err("QAT: Write CSR Timeout\n");
+	return -EFAULT;
+}
+
+static void qat_hal_get_wakeup_event(struct icp_qat_fw_loader_handle *handle,
+				     unsigned char ae, unsigned char ctx,
+				     unsigned int *events)
+{
+	unsigned int cur_ctx;
+
+	qat_hal_rd_ae_csr(handle, ae, CSR_CTX_POINTER, &cur_ctx);
+	qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, ctx);
+	qat_hal_rd_ae_csr(handle, ae, CTX_WAKEUP_EVENTS_INDIRECT, events);
+	qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, cur_ctx);
+}
+
+static int qat_hal_wait_cycles(struct icp_qat_fw_loader_handle *handle,
+			       unsigned char ae, unsigned int cycles,
+			       int chk_inactive)
+{
+	unsigned int base_cnt = 0, cur_cnt = 0;
+	unsigned int csr = (1 << ACS_ABO_BITPOS);
+	int times = MAX_RETRY_TIMES;
+	int elapsed_cycles = 0;
+
+	qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT, &base_cnt);
+	base_cnt &= 0xffff;
+	while ((int)cycles > elapsed_cycles && times--) {
+		if (chk_inactive)
+			qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &csr);
+
+		qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT, &cur_cnt);
+		cur_cnt &= 0xffff;
+		elapsed_cycles = cur_cnt - base_cnt;
+
+		if (elapsed_cycles < 0)
+			elapsed_cycles += 0x10000;
+
+		/* ensure at least 8 time cycles elapsed in wait_cycles */
+		if (elapsed_cycles >= 8 && !(csr & (1 << ACS_ABO_BITPOS)))
+			return 0;
+	}
+	if (!times) {
+		pr_err("QAT: wait_num_cycles time out\n");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+#define CLR_BIT(wrd, bit) (wrd & ~(1 << bit))
+#define SET_BIT(wrd, bit) (wrd | 1 << bit)
+
+int qat_hal_set_ae_ctx_mode(struct icp_qat_fw_loader_handle *handle,
+			    unsigned char ae, unsigned char mode)
+{
+	unsigned int csr, new_csr;
+
+	if ((mode != 4) && (mode != 8)) {
+		pr_err("QAT: bad ctx mode=%d\n", mode);
+		return -EINVAL;
+	}
+
+	/* Sets the accelaration engine context mode to either four or eight */
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &csr);
+	csr = IGNORE_W1C_MASK & csr;
+	new_csr = (mode == 4) ?
+		SET_BIT(csr, CE_INUSE_CONTEXTS_BITPOS) :
+		CLR_BIT(csr, CE_INUSE_CONTEXTS_BITPOS);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, new_csr);
+	return 0;
+}
+
+int qat_hal_set_ae_nn_mode(struct icp_qat_fw_loader_handle *handle,
+			   unsigned char ae, unsigned char mode)
+{
+	unsigned int csr, new_csr;
+
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &csr);
+	csr &= IGNORE_W1C_MASK;
+
+	new_csr = (mode) ?
+		SET_BIT(csr, CE_NN_MODE_BITPOS) :
+		CLR_BIT(csr, CE_NN_MODE_BITPOS);
+
+	if (new_csr != csr)
+		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, new_csr);
+
+	return 0;
+}
+
+int qat_hal_set_ae_lm_mode(struct icp_qat_fw_loader_handle *handle,
+			   unsigned char ae, enum icp_qat_uof_regtype lm_type,
+			   unsigned char mode)
+{
+	unsigned int csr, new_csr;
+
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &csr);
+	csr &= IGNORE_W1C_MASK;
+	switch (lm_type) {
+	case ICP_LMEM0:
+		new_csr = (mode) ?
+			SET_BIT(csr, CE_LMADDR_0_GLOBAL_BITPOS) :
+			CLR_BIT(csr, CE_LMADDR_0_GLOBAL_BITPOS);
+		break;
+	case ICP_LMEM1:
+		new_csr = (mode) ?
+			SET_BIT(csr, CE_LMADDR_1_GLOBAL_BITPOS) :
+			CLR_BIT(csr, CE_LMADDR_1_GLOBAL_BITPOS);
+		break;
+	default:
+		pr_err("QAT: lmType = 0x%x\n", lm_type);
+		return -EINVAL;
+	}
+
+	if (new_csr != csr)
+		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, new_csr);
+	return 0;
+}
+
+static unsigned short qat_hal_get_reg_addr(unsigned int type,
+					   unsigned short reg_num)
+{
+	unsigned short reg_addr;
+	switch (type) {
+	case ICP_GPA_ABS:
+	case ICP_GPB_ABS:
+		reg_addr = 0x80 | (reg_num & 0x7f);
+		break;
+	case ICP_GPA_REL:
+	case ICP_GPB_REL:
+		reg_addr = reg_num & 0x1f;
+		break;
+	case ICP_SR_RD_REL:
+	case ICP_SR_WR_REL:
+	case ICP_SR_REL:
+		reg_addr = 0x180 | (reg_num & 0x1f);
+		break;
+	case ICP_SR_ABS:
+		reg_addr = 0x140 | ((reg_num & 0x3) << 1);
+		break;
+	case ICP_DR_RD_REL:
+	case ICP_DR_WR_REL:
+	case ICP_DR_REL:
+		reg_addr = 0x1c0 | (reg_num & 0x1f);
+		break;
+	case ICP_DR_ABS:
+		reg_addr = 0x100 | ((reg_num & 0x3) << 1);
+		break;
+	case ICP_NEIGH_REL:
+		reg_addr = 0x280 | (reg_num & 0x1f);
+		break;
+	case ICP_LMEM0:
+		reg_addr = 0x200;
+		break;
+	case ICP_LMEM1:
+		reg_addr = 0x220;
+		break;
+	case ICP_NO_DEST:
+		reg_addr = 0x300 | (reg_num & 0xff);
+		break;
+	default:
+		reg_addr = BAD_REGADDR;
+		break;
+	}
+	return reg_addr;
+}
+
+void qat_hal_reset(struct icp_qat_fw_loader_handle *handle)
+{
+	unsigned int ae_reset_csr;
+
+	ae_reset_csr = GET_GLB_CSR(handle, ICP_RESET);
+	ae_reset_csr |= handle->hal_handle->ae_mask << RST_CSR_AE_LSB;
+	ae_reset_csr |= handle->hal_handle->slice_mask << RST_CSR_QAT_LSB;
+	SET_GLB_CSR(handle, ICP_RESET, ae_reset_csr);
+}
+
+static void qat_hal_wr_indr_csr(struct icp_qat_fw_loader_handle *handle,
+				unsigned char ae, unsigned int ctx_mask,
+				unsigned int ae_csr, unsigned int csr_val)
+{
+	unsigned int ctx, cur_ctx;
+
+	qat_hal_rd_ae_csr(handle, ae, CSR_CTX_POINTER, &cur_ctx);
+
+	for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++) {
+		if (!(ctx_mask & (1 << ctx)))
+			continue;
+		qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, ctx);
+		qat_hal_wr_ae_csr(handle, ae, ae_csr, csr_val);
+	}
+
+	qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, cur_ctx);
+}
+
+static void qat_hal_rd_indr_csr(struct icp_qat_fw_loader_handle *handle,
+				unsigned char ae, unsigned char ctx,
+				unsigned int ae_csr, unsigned int *csr_val)
+{
+	unsigned int cur_ctx;
+
+	qat_hal_rd_ae_csr(handle, ae, CSR_CTX_POINTER, &cur_ctx);
+	qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, ctx);
+	qat_hal_rd_ae_csr(handle, ae, ae_csr, csr_val);
+	qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, cur_ctx);
+}
+
+static void qat_hal_put_sig_event(struct icp_qat_fw_loader_handle *handle,
+				  unsigned char ae, unsigned int ctx_mask,
+				  unsigned int events)
+{
+	unsigned int ctx, cur_ctx;
+
+	qat_hal_rd_ae_csr(handle, ae, CSR_CTX_POINTER, &cur_ctx);
+	for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++) {
+		if (!(ctx_mask & (1 << ctx)))
+			continue;
+		qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, ctx);
+		qat_hal_wr_ae_csr(handle, ae, CTX_SIG_EVENTS_INDIRECT, events);
+	}
+	qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, cur_ctx);
+}
+
+static void qat_hal_put_wakeup_event(struct icp_qat_fw_loader_handle *handle,
+				     unsigned char ae, unsigned int ctx_mask,
+				     unsigned int events)
+{
+	unsigned int ctx, cur_ctx;
+
+	qat_hal_rd_ae_csr(handle, ae, CSR_CTX_POINTER, &cur_ctx);
+	for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++) {
+		if (!(ctx_mask & (1 << ctx)))
+			continue;
+		qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, ctx);
+		qat_hal_wr_ae_csr(handle, ae, CTX_WAKEUP_EVENTS_INDIRECT,
+				  events);
+	}
+	qat_hal_wr_ae_csr(handle, ae, CSR_CTX_POINTER, cur_ctx);
+}
+
+static int qat_hal_check_ae_alive(struct icp_qat_fw_loader_handle *handle)
+{
+	unsigned int base_cnt, cur_cnt;
+	unsigned char ae;
+	unsigned int times = MAX_RETRY_TIMES;
+
+	for (ae = 0; ae < handle->hal_handle->ae_max_num; ae++) {
+		if (!(handle->hal_handle->ae_mask & (1 << ae)))
+			continue;
+
+		qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT,
+				  (unsigned int *)&base_cnt);
+		base_cnt &= 0xffff;
+
+		do {
+			qat_hal_rd_ae_csr(handle, ae, PROFILE_COUNT,
+					  (unsigned int *)&cur_cnt);
+			cur_cnt &= 0xffff;
+		} while (times-- && (cur_cnt == base_cnt));
+
+		if (!times) {
+			pr_err("QAT: AE%d is inactive!!\n", ae);
+			return -EFAULT;
+		}
+	}
+
+	return 0;
+}
+
+static void qat_hal_reset_timestamp(struct icp_qat_fw_loader_handle *handle)
+{
+	unsigned int misc_ctl;
+	unsigned char ae;
+
+	/* stop the timestamp timers */
+	misc_ctl = GET_GLB_CSR(handle, MISC_CONTROL);
+	if (misc_ctl & MC_TIMESTAMP_ENABLE)
+		SET_GLB_CSR(handle, MISC_CONTROL, misc_ctl &
+			    (~MC_TIMESTAMP_ENABLE));
+
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!(handle->hal_handle->ae_mask & (1 << ae)))
+			continue;
+		qat_hal_wr_ae_csr(handle, ae, TIMESTAMP_LOW, 0);
+		qat_hal_wr_ae_csr(handle, ae, TIMESTAMP_HIGH, 0);
+	}
+	/* start timestamp timers */
+	SET_GLB_CSR(handle, MISC_CONTROL, misc_ctl | MC_TIMESTAMP_ENABLE);
+}
+
+#define ESRAM_AUTO_TINIT (1<<2)
+#define ESRAM_AUTO_TINIT_DONE (1<<3)
+#define ESRAM_AUTO_INIT_USED_CYCLES (1640)
+#define ESRAM_AUTO_INIT_CSR_OFFSET 0xC1C
+static int qat_hal_init_esram(struct icp_qat_fw_loader_handle *handle)
+{
+	void __iomem *csr_addr = handle->hal_ep_csr_addr_v +
+				 ESRAM_AUTO_INIT_CSR_OFFSET;
+	unsigned int csr_val, times = 30;
+
+	csr_val = ADF_CSR_RD(csr_addr, 0);
+	if ((csr_val & ESRAM_AUTO_TINIT) && (csr_val & ESRAM_AUTO_TINIT_DONE))
+		return 0;
+
+	csr_val = ADF_CSR_RD(csr_addr, 0);
+	csr_val |= ESRAM_AUTO_TINIT;
+	ADF_CSR_WR(csr_addr, 0, csr_val);
+
+	do {
+		qat_hal_wait_cycles(handle, 0, ESRAM_AUTO_INIT_USED_CYCLES, 0);
+		csr_val = ADF_CSR_RD(csr_addr, 0);
+	} while (!(csr_val & ESRAM_AUTO_TINIT_DONE) && times--);
+	if ((!times)) {
+		pr_err("QAT: Fail to init eSram!\n");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+#define SHRAM_INIT_CYCLES 2060
+int qat_hal_clr_reset(struct icp_qat_fw_loader_handle *handle)
+{
+	unsigned int ae_reset_csr;
+	unsigned char ae;
+	unsigned int clk_csr;
+	unsigned int times = 100;
+	unsigned int csr;
+
+	/* write to the reset csr */
+	ae_reset_csr = GET_GLB_CSR(handle, ICP_RESET);
+	ae_reset_csr &= ~(handle->hal_handle->ae_mask << RST_CSR_AE_LSB);
+	ae_reset_csr &= ~(handle->hal_handle->slice_mask << RST_CSR_QAT_LSB);
+	do {
+		SET_GLB_CSR(handle, ICP_RESET, ae_reset_csr);
+		if (!(times--))
+			goto out_err;
+		csr = GET_GLB_CSR(handle, ICP_RESET);
+	} while (csr & (handle->hal_handle->ae_mask |
+		 (handle->hal_handle->slice_mask << RST_CSR_QAT_LSB)));
+	/* enable clock */
+	clk_csr = GET_GLB_CSR(handle, ICP_GLOBAL_CLK_ENABLE);
+	clk_csr |= handle->hal_handle->ae_mask << 0;
+	clk_csr |= handle->hal_handle->slice_mask << 20;
+	SET_GLB_CSR(handle, ICP_GLOBAL_CLK_ENABLE, clk_csr);
+	if (qat_hal_check_ae_alive(handle))
+		goto out_err;
+
+	/* Set undefined power-up/reset states to reasonable default values */
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!(handle->hal_handle->ae_mask & (1 << ae)))
+			continue;
+		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES,
+				  INIT_CTX_ENABLE_VALUE);
+		qat_hal_wr_indr_csr(handle, ae, ICP_QAT_UCLO_AE_ALL_CTX,
+				    CTX_STS_INDIRECT,
+				    handle->hal_handle->upc_mask &
+				    INIT_PC_VALUE);
+		qat_hal_wr_ae_csr(handle, ae, CTX_ARB_CNTL, INIT_CTX_ARB_VALUE);
+		qat_hal_wr_ae_csr(handle, ae, CC_ENABLE, INIT_CCENABLE_VALUE);
+		qat_hal_put_wakeup_event(handle, ae,
+					 ICP_QAT_UCLO_AE_ALL_CTX,
+					 INIT_WAKEUP_EVENTS_VALUE);
+		qat_hal_put_sig_event(handle, ae,
+				      ICP_QAT_UCLO_AE_ALL_CTX,
+				      INIT_SIG_EVENTS_VALUE);
+	}
+	if (qat_hal_init_esram(handle))
+		goto out_err;
+	if (qat_hal_wait_cycles(handle, 0, SHRAM_INIT_CYCLES, 0))
+		goto out_err;
+	qat_hal_reset_timestamp(handle);
+
+	return 0;
+out_err:
+	pr_err("QAT: failed to get device out of reset\n");
+	return -EFAULT;
+}
+
+static void qat_hal_disable_ctx(struct icp_qat_fw_loader_handle *handle,
+				unsigned char ae, unsigned int ctx_mask)
+{
+	unsigned int ctx;
+
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx);
+	ctx &= IGNORE_W1C_MASK &
+		(~((ctx_mask & ICP_QAT_UCLO_AE_ALL_CTX) << CE_ENABLE_BITPOS));
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx);
+}
+
+static uint64_t qat_hal_parity_64bit(uint64_t word)
+{
+	word ^= word >> 1;
+	word ^= word >> 2;
+	word ^= word >> 4;
+	word ^= word >> 8;
+	word ^= word >> 16;
+	word ^= word >> 32;
+	return word & 1;
+}
+
+static uint64_t qat_hal_set_uword_ecc(uint64_t uword)
+{
+	uint64_t bit0_mask = 0xff800007fffULL, bit1_mask = 0x1f801ff801fULL,
+		bit2_mask = 0xe387e0781e1ULL, bit3_mask = 0x7cb8e388e22ULL,
+		bit4_mask = 0xaf5b2c93244ULL, bit5_mask = 0xf56d5525488ULL,
+		bit6_mask = 0xdaf69a46910ULL;
+
+	/* clear the ecc bits */
+	uword &= ~(0x7fULL << 0x2C);
+	uword |= qat_hal_parity_64bit(bit0_mask & uword) << 0x2C;
+	uword |= qat_hal_parity_64bit(bit1_mask & uword) << 0x2D;
+	uword |= qat_hal_parity_64bit(bit2_mask & uword) << 0x2E;
+	uword |= qat_hal_parity_64bit(bit3_mask & uword) << 0x2F;
+	uword |= qat_hal_parity_64bit(bit4_mask & uword) << 0x30;
+	uword |= qat_hal_parity_64bit(bit5_mask & uword) << 0x31;
+	uword |= qat_hal_parity_64bit(bit6_mask & uword) << 0x32;
+	return uword;
+}
+
+void qat_hal_wr_uwords(struct icp_qat_fw_loader_handle *handle,
+		       unsigned char ae, unsigned int uaddr,
+		       unsigned int words_num, uint64_t *uword)
+{
+	unsigned int ustore_addr;
+	unsigned int i;
+
+	qat_hal_rd_ae_csr(handle, ae, USTORE_ADDRESS, &ustore_addr);
+	uaddr |= UA_ECS;
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, uaddr);
+	for (i = 0; i < words_num; i++) {
+		unsigned int uwrd_lo, uwrd_hi;
+		uint64_t tmp;
+
+		tmp = qat_hal_set_uword_ecc(uword[i]);
+		uwrd_lo = (unsigned int)(tmp & 0xffffffff);
+		uwrd_hi = (unsigned int)(tmp >> 0x20);
+		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_LOWER, uwrd_lo);
+		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_UPPER, uwrd_hi);
+	}
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, ustore_addr);
+}
+
+static void qat_hal_enable_ctx(struct icp_qat_fw_loader_handle *handle,
+			       unsigned char ae, unsigned int ctx_mask)
+{
+	unsigned int ctx;
+
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx);
+	ctx &= IGNORE_W1C_MASK;
+	ctx_mask &= (ctx & CE_INUSE_CONTEXTS) ? 0x55 : 0xFF;
+	ctx |= (ctx_mask << CE_ENABLE_BITPOS);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx);
+}
+
+static int qat_hal_clear_gpr(struct icp_qat_fw_loader_handle *handle)
+{
+	unsigned char ae;
+	unsigned int ctx_mask = ICP_QAT_UCLO_AE_ALL_CTX;
+	int times = MAX_RETRY_TIMES;
+	unsigned int csr_val = 0;
+	unsigned short reg;
+	unsigned int savctx = 0;
+	int ret = 0;
+
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!(handle->hal_handle->ae_mask & (1 << ae)))
+			continue;
+		for (reg = 0; reg < ICP_QAT_UCLO_MAX_GPR_REG; reg++) {
+			qat_hal_init_rd_xfer(handle, ae, 0, ICP_SR_RD_ABS,
+					     reg, 0);
+			qat_hal_init_rd_xfer(handle, ae, 0, ICP_DR_RD_ABS,
+					     reg, 0);
+		}
+		qat_hal_rd_ae_csr(handle, ae, AE_MISC_CONTROL, &csr_val);
+		csr_val &= ~(1 << MMC_SHARE_CS_BITPOS);
+		qat_hal_wr_ae_csr(handle, ae, AE_MISC_CONTROL, csr_val);
+		qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &csr_val);
+		csr_val &= IGNORE_W1C_MASK;
+		csr_val |= CE_NN_MODE;
+		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, csr_val);
+		qat_hal_wr_uwords(handle, ae, 0, ARRAY_SIZE(inst),
+				  (uint64_t *)inst);
+		qat_hal_wr_indr_csr(handle, ae, ctx_mask, CTX_STS_INDIRECT,
+				    handle->hal_handle->upc_mask &
+				    INIT_PC_VALUE);
+		qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &savctx);
+		qat_hal_wr_ae_csr(handle, ae, ACTIVE_CTX_STATUS, 0);
+		qat_hal_put_wakeup_event(handle, ae, ctx_mask, XCWE_VOLUNTARY);
+		qat_hal_wr_indr_csr(handle, ae, ctx_mask,
+				    CTX_SIG_EVENTS_INDIRECT, 0);
+		qat_hal_wr_ae_csr(handle, ae, CTX_SIG_EVENTS_ACTIVE, 0);
+		qat_hal_enable_ctx(handle, ae, ctx_mask);
+	}
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!(handle->hal_handle->ae_mask & (1 << ae)))
+			continue;
+		/* wait for AE to finish */
+		do {
+			ret = qat_hal_wait_cycles(handle, ae, 20, 1);
+		} while (ret && times--);
+
+		if (!times) {
+			pr_err("QAT: clear GPR of AE %d failed", ae);
+			return -EINVAL;
+		}
+		qat_hal_disable_ctx(handle, ae, ctx_mask);
+		qat_hal_wr_ae_csr(handle, ae, ACTIVE_CTX_STATUS,
+				  savctx & ACS_ACNO);
+		qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES,
+				  INIT_CTX_ENABLE_VALUE);
+		qat_hal_wr_indr_csr(handle, ae, ctx_mask, CTX_STS_INDIRECT,
+				    handle->hal_handle->upc_mask &
+				    INIT_PC_VALUE);
+		qat_hal_wr_ae_csr(handle, ae, CTX_ARB_CNTL, INIT_CTX_ARB_VALUE);
+		qat_hal_wr_ae_csr(handle, ae, CC_ENABLE, INIT_CCENABLE_VALUE);
+		qat_hal_put_wakeup_event(handle, ae, ctx_mask,
+					 INIT_WAKEUP_EVENTS_VALUE);
+		qat_hal_put_sig_event(handle, ae, ctx_mask,
+				      INIT_SIG_EVENTS_VALUE);
+	}
+	return 0;
+}
+
+#define ICP_DH895XCC_AE_OFFSET      0x20000
+#define ICP_DH895XCC_CAP_OFFSET     (ICP_DH895XCC_AE_OFFSET + 0x10000)
+#define LOCAL_TO_XFER_REG_OFFSET    0x800
+#define ICP_DH895XCC_EP_OFFSET      0x3a000
+#define ICP_DH895XCC_PMISC_BAR 1
+int qat_hal_init(struct adf_accel_dev *accel_dev)
+{
+	unsigned char ae = 0;
+	unsigned int csr_val = 0;
+	unsigned int max_en_ae_num = 0;
+	struct icp_qat_fw_loader_handle *handle = NULL;
+	struct adf_accel_pci *pci_info = &accel_dev->accel_pci_dev;
+	struct adf_hw_device_data *hw_data = accel_dev->hw_device;
+	struct adf_bar *bar = &pci_info->pci_bars[ADF_DH895XCC_PMISC_BAR];
+
+	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
+	if (!handle)
+		goto out_handle;
+
+	handle->hal_cap_g_ctl_csr_addr_v = bar->virt_addr +
+						ICP_DH895XCC_CAP_OFFSET;
+	handle->hal_cap_ae_xfer_csr_addr_v = bar->virt_addr +
+						ICP_DH895XCC_AE_OFFSET;
+	handle->hal_ep_csr_addr_v = bar->virt_addr + ICP_DH895XCC_EP_OFFSET;
+	handle->hal_cap_ae_local_csr_addr_v =
+		handle->hal_cap_ae_xfer_csr_addr_v + LOCAL_TO_XFER_REG_OFFSET;
+
+	handle->hal_handle = kzalloc(sizeof(*handle->hal_handle), GFP_KERNEL);
+	if (!handle->hal_handle)
+		goto out_hal_handle;
+	handle->hal_handle->revision_id = accel_dev->accel_pci_dev.revid;
+	handle->hal_handle->ae_mask = hw_data->ae_mask;
+	handle->hal_handle->slice_mask = hw_data->accel_mask;
+	/* create AE objects */
+	handle->hal_handle->upc_mask = 0x1ffff;
+	handle->hal_handle->max_ustore = 0x4000;
+	for (ae = 0; ae < ICP_QAT_UCLO_MAX_AE; ae++) {
+		if (!(hw_data->ae_mask & (1 << ae)))
+			continue;
+		handle->hal_handle->aes[ae].free_addr = 0;
+		handle->hal_handle->aes[ae].free_size =
+		    handle->hal_handle->max_ustore;
+		handle->hal_handle->aes[ae].ustore_size =
+		    handle->hal_handle->max_ustore;
+		handle->hal_handle->aes[ae].live_ctx_mask =
+						ICP_QAT_UCLO_AE_ALL_CTX;
+		max_en_ae_num = ae;
+	}
+	handle->hal_handle->ae_max_num = max_en_ae_num;
+	/* take all AEs out of reset */
+	if (qat_hal_clr_reset(handle)) {
+		pr_err("QAT: qat_hal_clr_reset error\n");
+		goto out_err;
+	}
+	if (qat_hal_clear_gpr(handle))
+		goto out_err;
+	/* Set SIGNATURE_ENABLE[0] to 0x1 in order to enable ALU_OUT csr */
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!(hw_data->ae_mask & (1 << ae)))
+			continue;
+		qat_hal_rd_ae_csr(handle, ae, SIGNATURE_ENABLE, &csr_val);
+		csr_val |= 0x1;
+		qat_hal_wr_ae_csr(handle, ae, SIGNATURE_ENABLE, csr_val);
+	}
+	accel_dev->fw_loader->fw_loader = handle;
+	return 0;
+
+out_err:
+	kfree(handle->hal_handle);
+out_hal_handle:
+	kfree(handle);
+out_handle:
+	return -EFAULT;
+}
+
+void qat_hal_deinit(struct icp_qat_fw_loader_handle *handle)
+{
+	if (!handle)
+		return;
+	kfree(handle->hal_handle);
+	kfree(handle);
+}
+
+void qat_hal_start(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
+		   unsigned int ctx_mask)
+{
+	qat_hal_put_wakeup_event(handle, ae, (~ctx_mask) &
+				 ICP_QAT_UCLO_AE_ALL_CTX, 0x10000);
+	qat_hal_enable_ctx(handle, ae, ctx_mask);
+}
+
+void qat_hal_stop(struct icp_qat_fw_loader_handle *handle, unsigned char ae,
+		  unsigned int ctx_mask)
+{
+	qat_hal_disable_ctx(handle, ae, ctx_mask);
+}
+
+void qat_hal_set_pc(struct icp_qat_fw_loader_handle *handle,
+		    unsigned char ae, unsigned int ctx_mask, unsigned int upc)
+{
+	qat_hal_wr_indr_csr(handle, ae, ctx_mask, CTX_STS_INDIRECT,
+			    handle->hal_handle->upc_mask & upc);
+}
+
+static void qat_hal_get_uwords(struct icp_qat_fw_loader_handle *handle,
+			       unsigned char ae, unsigned int uaddr,
+			       unsigned int words_num, uint64_t *uword)
+{
+	unsigned int i, uwrd_lo, uwrd_hi;
+	unsigned int ustore_addr, misc_control;
+
+	qat_hal_rd_ae_csr(handle, ae, AE_MISC_CONTROL, &misc_control);
+	qat_hal_wr_ae_csr(handle, ae, AE_MISC_CONTROL,
+			  misc_control & 0xfffffffb);
+	qat_hal_rd_ae_csr(handle, ae, USTORE_ADDRESS, &ustore_addr);
+	uaddr |= UA_ECS;
+	for (i = 0; i < words_num; i++) {
+		qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, uaddr);
+		uaddr++;
+		qat_hal_rd_ae_csr(handle, ae, USTORE_DATA_LOWER, &uwrd_lo);
+		qat_hal_rd_ae_csr(handle, ae, USTORE_DATA_UPPER, &uwrd_hi);
+		uword[i] = uwrd_hi;
+		uword[i] = (uword[i] << 0x20) | uwrd_lo;
+	}
+	qat_hal_wr_ae_csr(handle, ae, AE_MISC_CONTROL, misc_control);
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, ustore_addr);
+}
+
+static int qat_hal_count_bits(unsigned int word)
+{
+	int n = 0;
+
+	while (word) {
+		n++;
+		word &= word - 1;
+	}
+	return n;
+}
+
+void qat_hal_wr_umem(struct icp_qat_fw_loader_handle *handle,
+		     unsigned char ae, unsigned int uaddr,
+		     unsigned int words_num, unsigned int *data)
+{
+	unsigned int i, ustore_addr;
+
+	qat_hal_rd_ae_csr(handle, ae, USTORE_ADDRESS, &ustore_addr);
+	uaddr |= UA_ECS;
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, uaddr);
+	for (i = 0; i < words_num; i++) {
+		unsigned int uwrd_lo, uwrd_hi, tmp;
+		uwrd_lo = ((data[i] & 0xfff0000) << 4) | (0x3 << 18) |
+			  ((data[i] & 0xff00) << 2) |
+			  (0x3 << 8) | (data[i] & 0xff);
+		uwrd_hi = (0xf << 4) | ((data[i] & 0xf0000000) >> 28);
+		uwrd_hi |= (qat_hal_count_bits(data[i] & 0xffff) & 0x1) << 8;
+		tmp = ((data[i] >> 0x10) & 0xffff);
+		uwrd_hi |= (qat_hal_count_bits(tmp) & 0x1) << 9;
+		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_LOWER, uwrd_lo);
+		qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_UPPER, uwrd_hi);
+	}
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, ustore_addr);
+}
+
+#define MAX_EXEC_INST 100
+static int qat_hal_exec_micro_inst(struct icp_qat_fw_loader_handle *handle,
+				   unsigned char ae, unsigned char ctx,
+				   uint64_t *micro_inst, unsigned int inst_num,
+				   int code_off, unsigned int max_cycle,
+				   unsigned int *endpc)
+{
+	uint64_t savuwords[MAX_EXEC_INST];
+	unsigned int ind_lm_addr0, ind_lm_addr1;
+	unsigned int ind_lm_addr_byte0, ind_lm_addr_byte1;
+	unsigned int ind_cnt_sig;
+	unsigned int ind_sig, act_sig;
+	unsigned int csr_val = 0, newcsr_val;
+	unsigned int savctx;
+	unsigned int savcc, wakeup_events, savpc;
+	unsigned int ctxarb_ctl, ctx_enables;
+
+	if ((inst_num > handle->hal_handle->max_ustore) || !micro_inst) {
+		pr_err("QAT: invalid instructs inst_num=%d, micro_inst=0x%p\n ",
+		       inst_num, (unsigned int *)micro_inst);
+		return -EINVAL;
+	}
+	/* save current context */
+	qat_hal_rd_indr_csr(handle, ae, ctx, LM_ADDR_0_INDIRECT, &ind_lm_addr0);
+	qat_hal_rd_indr_csr(handle, ae, ctx, LM_ADDR_1_INDIRECT, &ind_lm_addr1);
+	qat_hal_rd_indr_csr(handle, ae, ctx, INDIRECT_LM_ADDR_0_BYTE_INDEX,
+			    &ind_lm_addr_byte0);
+	qat_hal_rd_indr_csr(handle, ae, ctx, INDIRECT_LM_ADDR_1_BYTE_INDEX,
+			    &ind_lm_addr_byte1);
+	if (inst_num <= MAX_EXEC_INST)
+		qat_hal_get_uwords(handle, ae, 0, inst_num, savuwords);
+	qat_hal_get_wakeup_event(handle, ae, ctx, &wakeup_events);
+	qat_hal_rd_indr_csr(handle, ae, ctx, CTX_STS_INDIRECT, &savpc);
+	savpc = (savpc & handle->hal_handle->upc_mask) >> 0;
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx_enables);
+	ctx_enables &= IGNORE_W1C_MASK;
+	qat_hal_rd_ae_csr(handle, ae, CC_ENABLE, &savcc);
+	qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &savctx);
+	qat_hal_rd_ae_csr(handle, ae, CTX_ARB_CNTL, &ctxarb_ctl);
+	qat_hal_rd_indr_csr(handle, ae, ctx, FUTURE_COUNT_SIGNAL_INDIRECT,
+			    &ind_cnt_sig);
+	qat_hal_rd_indr_csr(handle, ae, ctx, CTX_SIG_EVENTS_INDIRECT, &ind_sig);
+	qat_hal_rd_ae_csr(handle, ae, CTX_SIG_EVENTS_ACTIVE, &act_sig);
+	/* execute micro codes */
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx_enables);
+	qat_hal_wr_uwords(handle, ae, 0, inst_num, micro_inst);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx), CTX_STS_INDIRECT, 0);
+	qat_hal_wr_ae_csr(handle, ae, ACTIVE_CTX_STATUS, ctx & ACS_ACNO);
+	if (code_off)
+		qat_hal_wr_ae_csr(handle, ae, CC_ENABLE, savcc & 0xffffdfff);
+	qat_hal_put_wakeup_event(handle, ae, (1 << ctx), XCWE_VOLUNTARY);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx), CTX_SIG_EVENTS_INDIRECT, 0);
+	qat_hal_wr_ae_csr(handle, ae, CTX_SIG_EVENTS_ACTIVE, 0);
+	qat_hal_enable_ctx(handle, ae, (1 << ctx));
+	/* wait for micro codes to finish */
+	if (qat_hal_wait_cycles(handle, ae, max_cycle, 1) != 0)
+		return -EFAULT;
+	if (endpc) {
+		unsigned int ctx_status;
+		qat_hal_rd_indr_csr(handle, ae, ctx, CTX_STS_INDIRECT,
+				    &ctx_status);
+		*endpc = ctx_status & handle->hal_handle->upc_mask;
+	}
+	/* retore to saved context */
+	qat_hal_disable_ctx(handle, ae, (1 << ctx));
+	if (inst_num <= MAX_EXEC_INST)
+		qat_hal_wr_uwords(handle, ae, 0, inst_num, savuwords);
+	qat_hal_put_wakeup_event(handle, ae, (1 << ctx), wakeup_events);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx), CTX_STS_INDIRECT,
+			    handle->hal_handle->upc_mask & savpc);
+	qat_hal_rd_ae_csr(handle, ae, AE_MISC_CONTROL, &csr_val);
+	newcsr_val = CLR_BIT(csr_val, MMC_SHARE_CS_BITPOS);
+	qat_hal_wr_ae_csr(handle, ae, AE_MISC_CONTROL, newcsr_val);
+	qat_hal_wr_ae_csr(handle, ae, CC_ENABLE, savcc);
+	qat_hal_wr_ae_csr(handle, ae, ACTIVE_CTX_STATUS, savctx & ACS_ACNO);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ARB_CNTL, ctxarb_ctl);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx),
+			    LM_ADDR_0_INDIRECT, ind_lm_addr0);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx),
+			    LM_ADDR_1_INDIRECT, ind_lm_addr1);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx),
+			    INDIRECT_LM_ADDR_0_BYTE_INDEX, ind_lm_addr_byte0);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx),
+			    INDIRECT_LM_ADDR_1_BYTE_INDEX, ind_lm_addr_byte1);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx),
+			    FUTURE_COUNT_SIGNAL_INDIRECT, ind_cnt_sig);
+	qat_hal_wr_indr_csr(handle, ae, (1 << ctx),
+			    CTX_SIG_EVENTS_INDIRECT, ind_sig);
+	qat_hal_wr_ae_csr(handle, ae, CTX_SIG_EVENTS_ACTIVE, act_sig);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx_enables);
+
+	return 0;
+}
+
+static int qat_hal_rd_rel_reg(struct icp_qat_fw_loader_handle *handle,
+			      unsigned char ae, unsigned char ctx,
+			      enum icp_qat_uof_regtype reg_type,
+			      unsigned short reg_num, unsigned int *data)
+{
+	unsigned int savctx, uaddr, uwrd_lo, uwrd_hi;
+	unsigned int ctxarb_cntl, ustore_addr, ctx_enables;
+	unsigned short reg_addr;
+	int status = 0;
+	uint64_t insts, savuword;
+
+	reg_addr = qat_hal_get_reg_addr(reg_type, reg_num);
+	if (reg_addr == BAD_REGADDR) {
+		pr_err("QAT: bad regaddr=0x%x\n", reg_addr);
+		return -EINVAL;
+	}
+	switch (reg_type) {
+	case ICP_GPA_REL:
+		insts = 0xA070000000ull | (reg_addr & 0x3ff);
+		break;
+	default:
+		insts = (uint64_t)0xA030000000ull | ((reg_addr & 0x3ff) << 10);
+		break;
+	}
+	qat_hal_rd_ae_csr(handle, ae, ACTIVE_CTX_STATUS, &savctx);
+	qat_hal_rd_ae_csr(handle, ae, CTX_ARB_CNTL, &ctxarb_cntl);
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx_enables);
+	ctx_enables &= IGNORE_W1C_MASK;
+	if (ctx != (savctx & ACS_ACNO))
+		qat_hal_wr_ae_csr(handle, ae, ACTIVE_CTX_STATUS,
+				  ctx & ACS_ACNO);
+	qat_hal_get_uwords(handle, ae, 0, 1, &savuword);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx_enables);
+	qat_hal_rd_ae_csr(handle, ae, USTORE_ADDRESS, &ustore_addr);
+	uaddr = UA_ECS;
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, uaddr);
+	insts = qat_hal_set_uword_ecc(insts);
+	uwrd_lo = (unsigned int)(insts & 0xffffffff);
+	uwrd_hi = (unsigned int)(insts >> 0x20);
+	qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_LOWER, uwrd_lo);
+	qat_hal_wr_ae_csr(handle, ae, USTORE_DATA_UPPER, uwrd_hi);
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, uaddr);
+	/* delay for at least 8 cycles */
+	qat_hal_wait_cycles(handle, ae, 0x8, 0);
+	/*
+	 * read ALU output
+	 * the instruction should have been executed
+	 * prior to clearing the ECS in putUwords
+	 */
+	qat_hal_rd_ae_csr(handle, ae, ALU_OUT, data);
+	qat_hal_wr_ae_csr(handle, ae, USTORE_ADDRESS, ustore_addr);
+	qat_hal_wr_uwords(handle, ae, 0, 1, &savuword);
+	if (ctx != (savctx & ACS_ACNO))
+		qat_hal_wr_ae_csr(handle, ae, ACTIVE_CTX_STATUS,
+				  savctx & ACS_ACNO);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ARB_CNTL, ctxarb_cntl);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx_enables);
+
+	return status;
+}
+
+static int qat_hal_wr_rel_reg(struct icp_qat_fw_loader_handle *handle,
+			      unsigned char ae, unsigned char ctx,
+			      enum icp_qat_uof_regtype reg_type,
+			      unsigned short reg_num, unsigned int data)
+{
+	unsigned short src_hiaddr, src_lowaddr, dest_addr, data16hi, data16lo;
+	uint64_t insts[] = {
+		0x0F440000000ull,
+		0x0F040000000ull,
+		0x0F0000C0300ull,
+		0x0E000010000ull
+	};
+	const int num_inst = ARRAY_SIZE(insts), code_off = 1;
+	const int imm_w1 = 0, imm_w0 = 1;
+
+	dest_addr = qat_hal_get_reg_addr(reg_type, reg_num);
+	if (dest_addr == BAD_REGADDR) {
+		pr_err("QAT: bad destAddr=0x%x\n", dest_addr);
+		return -EINVAL;
+	}
+
+	data16lo = 0xffff & data;
+	data16hi = 0xffff & (data >> 0x10);
+	src_hiaddr = qat_hal_get_reg_addr(ICP_NO_DEST, (unsigned short)
+					  (0xff & data16hi));
+	src_lowaddr = qat_hal_get_reg_addr(ICP_NO_DEST, (unsigned short)
+					   (0xff & data16lo));
+	switch (reg_type) {
+	case ICP_GPA_REL:
+		insts[imm_w1] = insts[imm_w1] | ((data16hi >> 8) << 20) |
+		    ((src_hiaddr & 0x3ff) << 10) | (dest_addr & 0x3ff);
+		insts[imm_w0] = insts[imm_w0] | ((data16lo >> 8) << 20) |
+		    ((src_lowaddr & 0x3ff) << 10) | (dest_addr & 0x3ff);
+		break;
+	default:
+		insts[imm_w1] = insts[imm_w1] | ((data16hi >> 8) << 20) |
+		    ((dest_addr & 0x3ff) << 10) | (src_hiaddr & 0x3ff);
+
+		insts[imm_w0] = insts[imm_w0] | ((data16lo >> 8) << 20) |
+		    ((dest_addr & 0x3ff) << 10) | (src_lowaddr & 0x3ff);
+		break;
+	}
+
+	return qat_hal_exec_micro_inst(handle, ae, ctx, insts, num_inst,
+				       code_off, num_inst * 0x5, NULL);
+}
+
+int qat_hal_get_ins_num(void)
+{
+	return ARRAY_SIZE(inst_4b);
+}
+
+static int qat_hal_concat_micro_code(uint64_t *micro_inst,
+				     unsigned int inst_num, unsigned int size,
+				     unsigned int addr, unsigned int *value)
+{
+	int i, val_indx;
+	unsigned int cur_value;
+	const uint64_t *inst_arr;
+	int fixup_offset;
+	int usize = 0;
+	int orig_num;
+
+	orig_num = inst_num;
+	val_indx = 0;
+	cur_value = value[val_indx++];
+	inst_arr = inst_4b;
+	usize = ARRAY_SIZE(inst_4b);
+	fixup_offset = inst_num;
+	for (i = 0; i < usize; i++)
+		micro_inst[inst_num++] = inst_arr[i];
+	INSERT_IMMED_GPRA_CONST(micro_inst[fixup_offset], (addr));
+	fixup_offset++;
+	INSERT_IMMED_GPRA_CONST(micro_inst[fixup_offset], 0);
+	fixup_offset++;
+	INSERT_IMMED_GPRB_CONST(micro_inst[fixup_offset], (cur_value >> 0));
+	fixup_offset++;
+	INSERT_IMMED_GPRB_CONST(micro_inst[fixup_offset], (cur_value >> 0x10));
+
+	return inst_num - orig_num;
+}
+
+static int qat_hal_exec_micro_init_lm(struct icp_qat_fw_loader_handle *handle,
+				      unsigned char ae, unsigned char ctx,
+				      int *pfirst_exec, uint64_t *micro_inst,
+				      unsigned int inst_num)
+{
+	int stat = 0;
+	unsigned int gpra0 = 0, gpra1 = 0, gpra2 = 0;
+	unsigned int gprb0 = 0, gprb1 = 0;
+
+	if (*pfirst_exec) {
+		qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPA_REL, 0, &gpra0);
+		qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPA_REL, 0x1, &gpra1);
+		qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPA_REL, 0x2, &gpra2);
+		qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPB_REL, 0, &gprb0);
+		qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPB_REL, 0x1, &gprb1);
+		*pfirst_exec = 0;
+	}
+	stat = qat_hal_exec_micro_inst(handle, ae, ctx, micro_inst, inst_num, 1,
+				       inst_num * 0x5, NULL);
+	if (stat != 0)
+		return -EFAULT;
+	qat_hal_wr_rel_reg(handle, ae, ctx, ICP_GPA_REL, 0, gpra0);
+	qat_hal_wr_rel_reg(handle, ae, ctx, ICP_GPA_REL, 0x1, gpra1);
+	qat_hal_wr_rel_reg(handle, ae, ctx, ICP_GPA_REL, 0x2, gpra2);
+	qat_hal_wr_rel_reg(handle, ae, ctx, ICP_GPB_REL, 0, gprb0);
+	qat_hal_wr_rel_reg(handle, ae, ctx, ICP_GPB_REL, 0x1, gprb1);
+
+	return 0;
+}
+
+int qat_hal_batch_wr_lm(struct icp_qat_fw_loader_handle *handle,
+			unsigned char ae,
+			struct icp_qat_uof_batch_init *lm_init_header)
+{
+	struct icp_qat_uof_batch_init *plm_init;
+	uint64_t *micro_inst_arry;
+	int micro_inst_num;
+	int alloc_inst_size;
+	int first_exec = 1;
+	int stat = 0;
+
+	plm_init = lm_init_header->next;
+	alloc_inst_size = lm_init_header->size;
+	if ((unsigned int)alloc_inst_size > handle->hal_handle->max_ustore)
+		alloc_inst_size = handle->hal_handle->max_ustore;
+	micro_inst_arry = kmalloc(alloc_inst_size * sizeof(uint64_t),
+				  GFP_KERNEL);
+	if (!micro_inst_arry)
+		return -ENOMEM;
+	micro_inst_num = 0;
+	while (plm_init) {
+		unsigned int addr, *value, size;
+
+		ae = plm_init->ae;
+		addr = plm_init->addr;
+		value = plm_init->value;
+		size = plm_init->size;
+		micro_inst_num += qat_hal_concat_micro_code(micro_inst_arry,
+							    micro_inst_num,
+							    size, addr, value);
+		plm_init = plm_init->next;
+	}
+	/* exec micro codes */
+	if (micro_inst_arry && (micro_inst_num > 0)) {
+		micro_inst_arry[micro_inst_num++] = 0x0E000010000ull;
+		stat = qat_hal_exec_micro_init_lm(handle, ae, 0, &first_exec,
+						  micro_inst_arry,
+						  micro_inst_num);
+	}
+	kfree(micro_inst_arry);
+	return stat;
+}
+
+static int qat_hal_put_rel_rd_xfer(struct icp_qat_fw_loader_handle *handle,
+				   unsigned char ae, unsigned char ctx,
+				   enum icp_qat_uof_regtype reg_type,
+				   unsigned short reg_num, unsigned int val)
+{
+	int status = 0;
+	unsigned int reg_addr;
+	unsigned int ctx_enables;
+	unsigned short mask;
+	unsigned short dr_offset = 0x10;
+
+	status = qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx_enables);
+	if (CE_INUSE_CONTEXTS & ctx_enables) {
+		if (ctx & 0x1) {
+			pr_err("QAT: bad 4-ctx mode,ctx=0x%x\n", ctx);
+			return -EINVAL;
+		}
+		mask = 0x1f;
+		dr_offset = 0x20;
+	} else {
+		mask = 0x0f;
+	}
+	if (reg_num & ~mask)
+		return -EINVAL;
+	reg_addr = reg_num + (ctx << 0x5);
+	switch (reg_type) {
+	case ICP_SR_RD_REL:
+	case ICP_SR_REL:
+		SET_AE_XFER(handle, ae, reg_addr, val);
+		break;
+	case ICP_DR_RD_REL:
+	case ICP_DR_REL:
+		SET_AE_XFER(handle, ae, (reg_addr + dr_offset), val);
+		break;
+	default:
+		status = -EINVAL;
+		break;
+	}
+	return status;
+}
+
+static int qat_hal_put_rel_wr_xfer(struct icp_qat_fw_loader_handle *handle,
+				   unsigned char ae, unsigned char ctx,
+				   enum icp_qat_uof_regtype reg_type,
+				   unsigned short reg_num, unsigned int data)
+{
+	unsigned int gprval, ctx_enables;
+	unsigned short src_hiaddr, src_lowaddr, gpr_addr, xfr_addr, data16hi,
+	    data16low;
+	unsigned short reg_mask;
+	int status = 0;
+	uint64_t micro_inst[] = {
+		0x0F440000000ull,
+		0x0F040000000ull,
+		0x0A000000000ull,
+		0x0F0000C0300ull,
+		0x0E000010000ull
+	};
+	const int num_inst = ARRAY_SIZE(micro_inst), code_off = 1;
+	const unsigned short gprnum = 0, dly = num_inst * 0x5;
+
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx_enables);
+	if (CE_INUSE_CONTEXTS & ctx_enables) {
+		if (ctx & 0x1) {
+			pr_err("QAT: 4-ctx mode,ctx=0x%x\n", ctx);
+			return -EINVAL;
+		}
+		reg_mask = (unsigned short)~0x1f;
+	} else {
+		reg_mask = (unsigned short)~0xf;
+	}
+	if (reg_num & reg_mask)
+		return -EINVAL;
+	xfr_addr = qat_hal_get_reg_addr(reg_type, reg_num);
+	if (xfr_addr == BAD_REGADDR) {
+		pr_err("QAT: bad xfrAddr=0x%x\n", xfr_addr);
+		return -EINVAL;
+	}
+	qat_hal_rd_rel_reg(handle, ae, ctx, ICP_GPB_REL, gprnum, &gprval);
+	gpr_addr = qat_hal_get_reg_addr(ICP_GPB_REL, gprnum);
+	data16low = 0xffff & data;
+	data16hi = 0xffff & (data >> 0x10);
+	src_hiaddr = qat_hal_get_reg_addr(ICP_NO_DEST,
+					  (unsigned short)(0xff & data16hi));
+	src_lowaddr = qat_hal_get_reg_addr(ICP_NO_DEST,
+					   (unsigned short)(0xff & data16low));
+	micro_inst[0] = micro_inst[0x0] | ((data16hi >> 8) << 20) |
+	    ((gpr_addr & 0x3ff) << 10) | (src_hiaddr & 0x3ff);
+	micro_inst[1] = micro_inst[0x1] | ((data16low >> 8) << 20) |
+	    ((gpr_addr & 0x3ff) << 10) | (src_lowaddr & 0x3ff);
+	micro_inst[0x2] = micro_inst[0x2] |
+	    ((xfr_addr & 0x3ff) << 20) | ((gpr_addr & 0x3ff) << 10);
+	status = qat_hal_exec_micro_inst(handle, ae, ctx, micro_inst, num_inst,
+					 code_off, dly, NULL);
+	qat_hal_wr_rel_reg(handle, ae, ctx, ICP_GPB_REL, gprnum, gprval);
+	return status;
+}
+
+static int qat_hal_put_rel_nn(struct icp_qat_fw_loader_handle *handle,
+			      unsigned char ae, unsigned char ctx,
+			      unsigned short nn, unsigned int val)
+{
+	unsigned int ctx_enables;
+	int stat = 0;
+
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx_enables);
+	ctx_enables &= IGNORE_W1C_MASK;
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx_enables | CE_NN_MODE);
+
+	stat = qat_hal_put_rel_wr_xfer(handle, ae, ctx, ICP_NEIGH_REL, nn, val);
+	qat_hal_wr_ae_csr(handle, ae, CTX_ENABLES, ctx_enables);
+	return stat;
+}
+
+static int qat_hal_convert_abs_to_rel(struct icp_qat_fw_loader_handle
+				      *handle, unsigned char ae,
+				      unsigned short absreg_num,
+				      unsigned short *relreg,
+				      unsigned char *ctx)
+{
+	unsigned int ctx_enables;
+
+	qat_hal_rd_ae_csr(handle, ae, CTX_ENABLES, &ctx_enables);
+	if (ctx_enables & CE_INUSE_CONTEXTS) {
+		/* 4-ctx mode */
+		*relreg = absreg_num & 0x1F;
+		*ctx = (absreg_num >> 0x4) & 0x6;
+	} else {
+		/* 8-ctx mode */
+		*relreg = absreg_num & 0x0F;
+		*ctx = (absreg_num >> 0x4) & 0x7;
+	}
+	return 0;
+}
+
+int qat_hal_init_gpr(struct icp_qat_fw_loader_handle *handle,
+		     unsigned char ae, unsigned char ctx_mask,
+		     enum icp_qat_uof_regtype reg_type,
+		     unsigned short reg_num, unsigned int regdata)
+{
+	int stat = 0;
+	unsigned short reg;
+	unsigned char ctx = 0;
+	enum icp_qat_uof_regtype type;
+
+	if (reg_num >= ICP_QAT_UCLO_MAX_GPR_REG)
+		return -EINVAL;
+
+	do {
+		if (ctx_mask == 0) {
+			qat_hal_convert_abs_to_rel(handle, ae, reg_num, &reg,
+						   &ctx);
+			type = reg_type - 1;
+		} else {
+			reg = reg_num;
+			type = reg_type;
+			if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+				continue;
+		}
+		stat = qat_hal_wr_rel_reg(handle, ae, ctx, type, reg, regdata);
+		if (stat) {
+			pr_err("QAT: write gpr fail\n");
+			return -EINVAL;
+		}
+	} while (ctx_mask && (ctx++ < ICP_QAT_UCLO_MAX_CTX));
+
+	return 0;
+}
+
+int qat_hal_init_wr_xfer(struct icp_qat_fw_loader_handle *handle,
+			 unsigned char ae, unsigned char ctx_mask,
+			 enum icp_qat_uof_regtype reg_type,
+			 unsigned short reg_num, unsigned int regdata)
+{
+	int stat = 0;
+	unsigned short reg;
+	unsigned char ctx = 0;
+	enum icp_qat_uof_regtype type;
+
+	if (reg_num >= ICP_QAT_UCLO_MAX_XFER_REG)
+		return -EINVAL;
+
+	do {
+		if (ctx_mask == 0) {
+			qat_hal_convert_abs_to_rel(handle, ae, reg_num, &reg,
+						   &ctx);
+			type = reg_type - 3;
+		} else {
+			reg = reg_num;
+			type = reg_type;
+			if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+				continue;
+		}
+		stat = qat_hal_put_rel_wr_xfer(handle, ae, ctx, type, reg,
+					       regdata);
+		if (stat) {
+			pr_err("QAT: write wr xfer fail\n");
+			return -EINVAL;
+		}
+	} while (ctx_mask && (ctx++ < ICP_QAT_UCLO_MAX_CTX));
+
+	return 0;
+}
+
+int qat_hal_init_rd_xfer(struct icp_qat_fw_loader_handle *handle,
+			 unsigned char ae, unsigned char ctx_mask,
+			 enum icp_qat_uof_regtype reg_type,
+			 unsigned short reg_num, unsigned int regdata)
+{
+	int stat = 0;
+	unsigned short reg;
+	unsigned char ctx = 0;
+	enum icp_qat_uof_regtype type;
+
+	if (reg_num >= ICP_QAT_UCLO_MAX_XFER_REG)
+		return -EINVAL;
+
+	do {
+		if (ctx_mask == 0) {
+			qat_hal_convert_abs_to_rel(handle, ae, reg_num, &reg,
+						   &ctx);
+			type = reg_type - 3;
+		} else {
+			reg = reg_num;
+			type = reg_type;
+			if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+				continue;
+		}
+		stat = qat_hal_put_rel_rd_xfer(handle, ae, ctx, type, reg,
+					       regdata);
+		if (stat) {
+			pr_err("QAT: write rd xfer fail\n");
+			return -EINVAL;
+		}
+	} while (ctx_mask && (ctx++ < ICP_QAT_UCLO_MAX_CTX));
+
+	return 0;
+}
+
+int qat_hal_init_nn(struct icp_qat_fw_loader_handle *handle,
+		    unsigned char ae, unsigned char ctx_mask,
+		    unsigned short reg_num, unsigned int regdata)
+{
+	int stat = 0;
+	unsigned char ctx;
+
+	if (ctx_mask == 0)
+		return -EINVAL;
+
+	for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++) {
+		if (!test_bit(ctx, (unsigned long *)&ctx_mask))
+			continue;
+		stat = qat_hal_put_rel_nn(handle, ae, ctx, reg_num, regdata);
+		if (stat) {
+			pr_err("QAT: write neigh error\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
diff --git a/drivers/crypto/qat/qat_common/qat_uclo.c b/drivers/crypto/qat/qat_common/qat_uclo.c
new file mode 100644
index 0000000..4b6f850
--- /dev/null
+++ b/drivers/crypto/qat/qat_common/qat_uclo.c
@@ -0,0 +1,1191 @@
+/*
+  This file is provided under a dual BSD/GPLv2 license.  When using or
+  redistributing this file, you may do so under either license.
+
+  GPL LICENSE SUMMARY
+  Copyright(c) 2014 Intel Corporation.
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of version 2 of the GNU General Public License as
+  published by the Free Software Foundation.
+
+  This program is distributed in the hope that it will be useful, but
+  WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+  General Public License for more details.
+
+  Contact Information:
+  qat-linux@intel.com
+
+  BSD LICENSE
+  Copyright(c) 2014 Intel Corporation.
+  Redistribution and use in source and binary forms, with or without
+  modification, are permitted provided that the following conditions
+  are met:
+
+    * Redistributions of source code must retain the above copyright
+      notice, this list of conditions and the following disclaimer.
+    * Redistributions in binary form must reproduce the above copyright
+      notice, this list of conditions and the following disclaimer in
+      the documentation and/or other materials provided with the
+      distribution.
+    * Neither the name of Intel Corporation nor the names of its
+      contributors may be used to endorse or promote products derived
+      from this software without specific prior written permission.
+
+  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+#include <linux/slab.h>
+#include <linux/ctype.h>
+#include <linux/kernel.h>
+
+#include "adf_accel_devices.h"
+#include "adf_common_drv.h"
+#include "icp_qat_uclo.h"
+#include "icp_qat_hal.h"
+#include "icp_qat_fw_loader_handle.h"
+
+#define UWORD_CPYBUF_SIZE 1024
+#define INVLD_UWORD 0xffffffffffull
+#define PID_MINOR_REV 0xf
+#define PID_MAJOR_REV (0xf << 4)
+
+static int qat_uclo_init_ae_data(struct icp_qat_uclo_objhandle *obj_handle,
+				 unsigned int ae, unsigned int image_num)
+{
+	struct icp_qat_uclo_aedata *ae_data;
+	struct icp_qat_uclo_encapme *encap_image;
+	struct icp_qat_uclo_page *page = NULL;
+	struct icp_qat_uclo_aeslice *ae_slice = NULL;
+
+	ae_data = &obj_handle->ae_data[ae];
+	encap_image = &obj_handle->ae_uimage[image_num];
+	ae_slice = &ae_data->ae_slices[ae_data->slice_num];
+	ae_slice->encap_image = encap_image;
+
+	if (encap_image->img_ptr) {
+		ae_slice->ctx_mask_assigned =
+					encap_image->img_ptr->ctx_assigned;
+		ae_data->eff_ustore_size = obj_handle->ustore_phy_size;
+	} else {
+		ae_slice->ctx_mask_assigned = 0;
+	}
+	ae_slice->regions = kzalloc(sizeof(*(ae_slice->regions)), GFP_KERNEL);
+	if (!(ae_slice->regions))
+		return -ENOMEM;
+	ae_slice->page = kzalloc(sizeof(*(ae_slice->page)), GFP_KERNEL);
+	if (!(ae_slice->page))
+		goto out_err;
+	page = ae_slice->page;
+	page->encap_page = encap_image->page;
+	ae_slice->page->region = ae_slice->regions;
+	ae_data->slice_num++;
+	return 0;
+out_err:
+	kfree(ae_slice->regions);
+	ae_slice->regions = NULL;
+	return -ENOMEM;
+}
+
+static int qat_uclo_free_ae_data(struct icp_qat_uclo_aedata *ae_data)
+{
+	unsigned int ss = 0;
+
+	if (!ae_data) {
+		pr_err("QAT: bad argument, ae_data is NULL\n ");
+		return -EINVAL;
+	}
+
+	for (ss = 0; ss < ae_data->slice_num; ss++) {
+		kfree(ae_data->ae_slices[ss].regions);
+		ae_data->ae_slices[ss].regions = NULL;
+		kfree(ae_data->ae_slices[ss].page);
+		ae_data->ae_slices[ss].page = NULL;
+	}
+	return 0;
+}
+
+static char *qat_uclo_get_string(struct icp_qat_uof_strtable *str_table,
+				 unsigned int str_offset)
+{
+	if ((!str_table->table_len) || (str_offset > str_table->table_len))
+		return NULL;
+	return (char *)(((unsigned long)(str_table->strings)) + str_offset);
+}
+
+static int qat_uclo_check_format(struct icp_qat_uof_filehdr *hdr)
+{
+	int maj = hdr->maj_ver & 0xff;
+	int min = hdr->min_ver & 0xff;
+
+	if (hdr->file_id != ICP_QAT_UOF_FID) {
+		pr_err("QAT: Invalid header 0x%x\n", hdr->file_id);
+		return -EINVAL;
+	}
+	if (min != ICP_QAT_UOF_MINVER || maj != ICP_QAT_UOF_MAJVER) {
+		pr_err("QAT: bad uof version, major 0x%x, minor 0x%x\n",
+		       maj, min);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static void qat_uclo_wr_sram_by_words(struct icp_qat_fw_loader_handle *handle,
+				      unsigned int addr, unsigned int *val,
+				      unsigned int num_in_bytes)
+{
+	unsigned int outval;
+	unsigned char *ptr = (unsigned char *)val;
+
+	while (num_in_bytes) {
+		memcpy(&outval, ptr, 4);
+		SRAM_WRITE(handle, addr, outval);
+		num_in_bytes -= 4;
+		ptr += 4;
+		addr += 4;
+	}
+}
+
+static void qat_uclo_wr_umem_by_words(struct icp_qat_fw_loader_handle *handle,
+				      unsigned char ae, unsigned int addr,
+				      unsigned int *val,
+				      unsigned int num_in_bytes)
+{
+	unsigned int outval;
+	unsigned char *ptr = (unsigned char *)val;
+
+	addr >>= 0x2; /* convert to uword address */
+
+	while (num_in_bytes) {
+		memcpy(&outval, ptr, 4);
+		qat_hal_wr_umem(handle, ae, addr++, 1, &outval);
+		num_in_bytes -= 4;
+		ptr += 4;
+	}
+	return;
+}
+
+static void qat_uclo_batch_wr_umem(struct icp_qat_fw_loader_handle *handle,
+				   unsigned char ae,
+				   struct icp_qat_uof_batch_init
+				   *umem_init_header)
+{
+	struct icp_qat_uof_batch_init *umem_init;
+
+	if (!umem_init_header)
+		return;
+	umem_init = umem_init_header->next;
+	while (umem_init) {
+		unsigned int addr, *value, size;
+		ae = umem_init->ae;
+		addr = umem_init->addr;
+		value = umem_init->value;
+		size = umem_init->size;
+		qat_uclo_wr_umem_by_words(handle, ae, addr, value, size);
+		umem_init = umem_init->next;
+	}
+}
+
+static void
+qat_uclo_cleanup_batch_init_list(struct icp_qat_fw_loader_handle *handle,
+				 struct icp_qat_uof_batch_init **base)
+{
+	struct icp_qat_uof_batch_init *umem_init;
+
+	umem_init = *base;
+	while (umem_init) {
+		struct icp_qat_uof_batch_init *pre;
+		pre = umem_init;
+		umem_init = umem_init->next;
+		kfree(pre);
+	}
+	*base = NULL;
+}
+
+static int qat_uclo_parse_num(char *str, unsigned int *num)
+{
+	char buf[16];
+	unsigned long ae = 0;
+	int i;
+
+	memset(buf, '\0', 16);
+	strncpy(buf, str, 15);
+	for (i = 0; i < 16; i++) {
+		if (!isdigit(buf[i])) {
+			buf[i] = '\0';
+			break;
+		}
+	}
+	if ((kstrtoul(buf, 10, &ae)))
+		return -EFAULT;
+
+	*num = (unsigned int)ae;
+	return 0;
+}
+
+static int qat_uclo_fetch_initmem_ae(struct icp_qat_fw_loader_handle *handle,
+				     struct icp_qat_uof_initmem *init_mem,
+				     unsigned int size_range, unsigned int *ae)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	char *str;
+
+	if ((init_mem->addr + init_mem->num_in_bytes) > (size_range << 0x2)) {
+		pr_err("QAT: initmem is out of range");
+		return -EINVAL;
+	}
+	if (init_mem->scope != ICP_QAT_UOF_LOCAL_SCOPE) {
+		pr_err("QAT: Memory scope for init_mem error\n");
+		return -EINVAL;
+	}
+	str = qat_uclo_get_string(&(obj_handle->str_table), init_mem->sym_name);
+	if (!str) {
+		pr_err("QAT: AE name assigned in uof init table is NULL\n");
+		return -EINVAL;
+	}
+	if (qat_uclo_parse_num(str, ae)) {
+		pr_err("QAT: Parse num for AE number failed\n");
+		return -EINVAL;
+	}
+	if (!test_bit(*ae, (unsigned long *)&(handle->hal_handle->ae_mask))) {
+		pr_err("QAT: ae %d to be init is fused off\n", *ae);
+		return -EINVAL;
+	}
+	if (*ae >= ICP_QAT_UCLO_MAX_AE) {
+		pr_err("QAT: ae %d out of range\n", *ae);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int qat_uclo_create_batch_init_list(struct icp_qat_fw_loader_handle
+					   *handle, struct icp_qat_uof_initmem
+					   *init_mem, unsigned int ae,
+					   struct icp_qat_uof_batch_init
+					   **init_tab_base)
+{
+	struct icp_qat_uof_batch_init *init_header, *tail;
+	struct icp_qat_uof_batch_init *mem_init, *tail_old;
+	struct icp_qat_uof_memvar_attr *mem_val_attr;
+	unsigned int i, flag = 0;
+
+	mem_val_attr =
+		(struct icp_qat_uof_memvar_attr *)((unsigned long)init_mem +
+		sizeof(struct icp_qat_uof_initmem));
+
+	init_header = *init_tab_base;
+	if (!init_header) {
+		init_header = kzalloc(sizeof(*init_header), GFP_KERNEL);
+		if (!init_header)
+			return -ENOMEM;
+		init_header->size = 1;
+		*init_tab_base = init_header;
+		flag = 1;
+	}
+	tail_old = init_header;
+	while (tail_old->next)
+		tail_old = tail_old->next;
+	tail = tail_old;
+	for (i = 0; i < init_mem->val_attr_num; i++) {
+		mem_init = kzalloc(sizeof(*mem_init), GFP_KERNEL);
+		if (!mem_init)
+			goto out_err;
+		mem_init->ae = ae;
+		mem_init->addr = init_mem->addr + mem_val_attr->offset_in_byte;
+		mem_init->value = &mem_val_attr->value;
+		mem_init->size = 4;
+		mem_init->next = NULL;
+		tail->next = mem_init;
+		tail = mem_init;
+		init_header->size += qat_hal_get_ins_num();
+		mem_val_attr++;
+	}
+	return 0;
+out_err:
+	while (tail_old) {
+		mem_init = tail_old->next;
+		kfree(tail_old);
+		tail_old = mem_init;
+	}
+	if (flag)
+		kfree(*init_tab_base);
+	return -ENOMEM;
+}
+
+static int qat_uclo_init_lmem_seg(struct icp_qat_fw_loader_handle *handle,
+				  struct icp_qat_uof_initmem *init_mem)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned int ae;
+
+	if (qat_uclo_fetch_initmem_ae(handle, init_mem,
+				      ICP_QAT_UCLO_MAX_LMEM_REG, &ae))
+		return -EINVAL;
+	if (qat_uclo_create_batch_init_list(handle, init_mem, ae,
+					    &(obj_handle->lm_init_tab[ae])))
+		return -EINVAL;
+	return 0;
+}
+
+static int qat_uclo_init_umem_seg(struct icp_qat_fw_loader_handle *handle,
+				  struct icp_qat_uof_initmem *init_mem)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned int ae, ustore_size, uaddr, i;
+
+	ustore_size = obj_handle->ustore_phy_size;
+	if (qat_uclo_fetch_initmem_ae(handle, init_mem, ustore_size, &ae))
+		return -EINVAL;
+	if (qat_uclo_create_batch_init_list(handle, init_mem, ae,
+					    &(obj_handle->umem_init_tab[ae])))
+		return -EINVAL;
+	/* set the highest ustore address referenced */
+	uaddr = (init_mem->addr + init_mem->num_in_bytes) >> 0x2;
+	for (i = 0; i < obj_handle->ae_data[ae].slice_num; i++) {
+		if (obj_handle->ae_data[ae].ae_slices[i].
+		    encap_image->uwords_num < uaddr)
+			obj_handle->ae_data[ae].ae_slices[i].
+			encap_image->uwords_num = uaddr;
+	}
+	return 0;
+}
+
+#define ICP_DH895XCC_PESRAM_BAR_SIZE 0x80000
+static int qat_uclo_init_ae_memory(struct icp_qat_fw_loader_handle *handle,
+				   struct icp_qat_uof_initmem *init_mem)
+{
+	unsigned int i;
+	struct icp_qat_uof_memvar_attr *mem_val_attr;
+
+	mem_val_attr =
+		(struct icp_qat_uof_memvar_attr *)((unsigned long)init_mem +
+		sizeof(struct icp_qat_uof_initmem));
+
+	switch (init_mem->region) {
+	case ICP_QAT_UOF_SRAM_REGION:
+		if ((init_mem->addr + init_mem->num_in_bytes) >
+		     ICP_DH895XCC_PESRAM_BAR_SIZE) {
+			pr_err("QAT: initmem on SRAM is out of range");
+			return -EINVAL;
+		}
+		for (i = 0; i < init_mem->val_attr_num; i++) {
+			qat_uclo_wr_sram_by_words(handle,
+						  init_mem->addr +
+						  mem_val_attr->offset_in_byte,
+						  &mem_val_attr->value, 4);
+			mem_val_attr++;
+		}
+		break;
+	case ICP_QAT_UOF_LMEM_REGION:
+		if (qat_uclo_init_lmem_seg(handle, init_mem))
+			return -EINVAL;
+		break;
+	case ICP_QAT_UOF_UMEM_REGION:
+		if (qat_uclo_init_umem_seg(handle, init_mem))
+			return -EINVAL;
+		break;
+	default:
+		pr_err("QAT: initmem region error. region type=0x%x\n",
+		       init_mem->region);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int qat_uclo_init_ustore(struct icp_qat_fw_loader_handle *handle,
+				struct icp_qat_uclo_encapme *image)
+{
+	unsigned int i;
+	struct icp_qat_uclo_encap_page *page;
+	struct icp_qat_uof_image *uof_image;
+	unsigned char ae;
+	unsigned int ustore_size;
+	unsigned int patt_pos;
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	uint64_t *fill_data;
+
+	uof_image = image->img_ptr;
+	fill_data = kzalloc(ICP_QAT_UCLO_MAX_USTORE * sizeof(uint64_t),
+			    GFP_KERNEL);
+	if (!fill_data)
+		return -EFAULT;
+	for (i = 0; i < ICP_QAT_UCLO_MAX_USTORE; i++)
+		memcpy(&fill_data[i], &uof_image->fill_pattern,
+		       sizeof(uint64_t));
+	page = image->page;
+
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!test_bit(ae, (unsigned long *)&(uof_image->ae_assigned)))
+			continue;
+		ustore_size = obj_handle->ae_data[ae].eff_ustore_size;
+		patt_pos = page->beg_addr_p + page->micro_words_num;
+
+		qat_hal_wr_uwords(handle, (unsigned char)ae, 0,
+				  page->beg_addr_p, &fill_data[0]);
+		qat_hal_wr_uwords(handle, (unsigned char)ae, patt_pos,
+				  ustore_size - patt_pos + 1,
+				  &fill_data[page->beg_addr_p]);
+	}
+	kfree(fill_data);
+	return 0;
+}
+
+static int qat_uclo_init_memory(struct icp_qat_fw_loader_handle *handle)
+{
+	unsigned int i;
+	int status = 0;
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	struct icp_qat_uof_initmem *initmem = obj_handle->init_mem_tab.init_mem;
+	int ae;
+
+	for (i = 0; i < obj_handle->init_mem_tab.entry_num; i++) {
+		if (initmem->num_in_bytes) {
+			if (qat_uclo_init_ae_memory(handle, initmem))
+				return -EINVAL;
+		}
+		initmem = (struct icp_qat_uof_initmem *)((unsigned long)(
+			(unsigned long)initmem +
+			sizeof(struct icp_qat_uof_initmem)) +
+			(sizeof(struct icp_qat_uof_memvar_attr) *
+			initmem->val_attr_num));
+	}
+	for (ae = 0; ae < ICP_QAT_UCLO_MAX_AE; ae++) {
+		if (qat_hal_batch_wr_lm(handle, ae,
+					obj_handle->lm_init_tab[ae])) {
+			pr_err("QAT: fail to batch init lmem for AE %d\n", ae);
+			return -EINVAL;
+		}
+		qat_uclo_cleanup_batch_init_list(handle,
+						 &obj_handle->lm_init_tab[ae]);
+		qat_uclo_batch_wr_umem(handle, ae,
+				       obj_handle->umem_init_tab[ae]);
+		qat_uclo_cleanup_batch_init_list(handle,
+						 &obj_handle->
+						 umem_init_tab[ae]);
+	}
+	return status;
+}
+
+static void *qat_uclo_find_chunk(struct icp_qat_uof_objhdr *obj_hdr,
+				 char *chunk_id, void *cur)
+{
+	int i;
+	struct icp_qat_uof_chunkhdr *chunk_hdr =
+	    (struct icp_qat_uof_chunkhdr *)
+	    ((unsigned long)obj_hdr + sizeof(struct icp_qat_uof_objhdr));
+
+	for (i = 0; i < obj_hdr->num_chunks; i++) {
+		if ((cur < (void *)&chunk_hdr[i]) &&
+		    !(strncmp(chunk_hdr[i].chunk_id, chunk_id,
+			      ICP_QAT_UOF_OBJID_LEN))) {
+			return &chunk_hdr[i];
+		}
+	}
+	return NULL;
+}
+
+static unsigned int qat_uclo_calc_checksum(unsigned int reg, int ch)
+{
+	int i;
+	unsigned int topbit = 1 << 0xF;
+	unsigned int inbyte = (unsigned int)((reg >> 0x18) ^ ch);
+
+	reg ^= inbyte << 0x8;
+	for (i = 0; i < 0x8; i++) {
+		if (reg & topbit)
+			reg = (reg << 1) ^ 0x1021;
+		else
+			reg <<= 1;
+	}
+	return reg & 0xFFFF;
+}
+
+static unsigned int qat_uclo_calc_str_checksum(char *ptr, int num)
+{
+	unsigned int chksum = 0;
+
+	if (ptr)
+		while (num--)
+			chksum = qat_uclo_calc_checksum(chksum, *ptr++);
+	return chksum;
+}
+
+static struct icp_qat_uclo_objhdr *
+qat_uclo_map_chunk(char *buf, struct icp_qat_uof_filehdr *file_hdr,
+		   char *chunk_id)
+{
+	struct icp_qat_uof_filechunkhdr *file_chunk;
+	struct icp_qat_uclo_objhdr *obj_hdr;
+	void *chunk;
+	int i;
+
+	file_chunk = (struct icp_qat_uof_filechunkhdr *)
+		(buf + sizeof(struct icp_qat_uof_filehdr));
+	for (i = 0; i < file_hdr->num_chunks; i++) {
+		if (!(strncmp(file_chunk->chunk_id, chunk_id,
+			      ICP_QAT_UOF_OBJID_LEN))) {
+			chunk = buf + file_chunk->offset;
+			if (file_chunk->checksum != qat_uclo_calc_str_checksum(
+				(char *)chunk, file_chunk->size))
+				break;
+			obj_hdr = kzalloc(sizeof(*obj_hdr), GFP_KERNEL);
+			if (!obj_hdr)
+				break;
+			obj_hdr->file_buff = chunk;
+			obj_hdr->checksum = file_chunk->checksum;
+			obj_hdr->size = file_chunk->size;
+			return obj_hdr;
+		}
+		file_chunk++;
+	}
+	return NULL;
+}
+
+static unsigned int
+qat_uclo_check_image_compat(struct icp_qat_uof_encap_obj *encap_uof_obj,
+			    struct icp_qat_uof_image *image)
+{
+	struct icp_qat_uof_objtable *uc_var_tab, *imp_var_tab, *imp_expr_tab;
+	struct icp_qat_uof_objtable *neigh_reg_tab;
+	struct icp_qat_uof_code_page *code_page;
+
+	code_page = (struct icp_qat_uof_code_page *)
+			((char *)image + sizeof(struct icp_qat_uof_image));
+	uc_var_tab = (struct icp_qat_uof_objtable *)(encap_uof_obj->beg_uof +
+		     code_page->uc_var_tab_offset);
+	imp_var_tab = (struct icp_qat_uof_objtable *)(encap_uof_obj->beg_uof +
+		      code_page->imp_var_tab_offset);
+	imp_expr_tab = (struct icp_qat_uof_objtable *)
+		       (encap_uof_obj->beg_uof +
+		       code_page->imp_expr_tab_offset);
+	if (uc_var_tab->entry_num || imp_var_tab->entry_num ||
+	    imp_expr_tab->entry_num) {
+		pr_err("QAT: UOF can't contain imported variable to be parsed");
+		return -EINVAL;
+	}
+	neigh_reg_tab = (struct icp_qat_uof_objtable *)
+			(encap_uof_obj->beg_uof +
+			code_page->neigh_reg_tab_offset);
+	if (neigh_reg_tab->entry_num) {
+		pr_err("QAT: UOF can't contain shared control store feature");
+		return -EINVAL;
+	}
+	if (image->numpages > 1) {
+		pr_err("QAT: UOF can't contain multiple pages");
+		return -EINVAL;
+	}
+	if (ICP_QAT_SHARED_USTORE_MODE(image->ae_mode)) {
+		pr_err("QAT: UOF can't use shared control store feature");
+		return -EFAULT;
+	}
+	if (RELOADABLE_CTX_SHARED_MODE(image->ae_mode)) {
+		pr_err("QAT: UOF can't use reloadable feature");
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static void qat_uclo_map_image_pages(struct icp_qat_uof_encap_obj
+				     *encap_uof_obj,
+				     struct icp_qat_uof_image *img,
+				     struct icp_qat_uclo_encap_page *page)
+{
+	struct icp_qat_uof_code_page *code_page;
+	struct icp_qat_uof_code_area *code_area;
+	struct icp_qat_uof_objtable *uword_block_tab;
+	struct icp_qat_uof_uword_block *uwblock;
+	int i;
+
+	code_page = (struct icp_qat_uof_code_page *)
+			((char *)img + sizeof(struct icp_qat_uof_image));
+	page->def_page = code_page->def_page;
+	page->page_region = code_page->page_region;
+	page->beg_addr_v = code_page->beg_addr_v;
+	page->beg_addr_p = code_page->beg_addr_p;
+	code_area = (struct icp_qat_uof_code_area *)(encap_uof_obj->beg_uof +
+						code_page->code_area_offset);
+	page->micro_words_num = code_area->micro_words_num;
+	uword_block_tab = (struct icp_qat_uof_objtable *)
+			  (encap_uof_obj->beg_uof +
+			  code_area->uword_block_tab);
+	page->uwblock_num = uword_block_tab->entry_num;
+	uwblock = (struct icp_qat_uof_uword_block *)((char *)uword_block_tab +
+			sizeof(struct icp_qat_uof_objtable));
+	page->uwblock = (struct icp_qat_uclo_encap_uwblock *)uwblock;
+	for (i = 0; i < uword_block_tab->entry_num; i++)
+		page->uwblock[i].micro_words =
+		(unsigned long)encap_uof_obj->beg_uof + uwblock[i].uword_offset;
+}
+
+static int qat_uclo_map_uimage(struct icp_qat_uclo_objhandle *obj_handle,
+			       struct icp_qat_uclo_encapme *ae_uimage,
+			       int max_image)
+{
+	int a = 0, i;
+	struct icp_qat_uof_chunkhdr *chunk_hdr = NULL;
+	struct icp_qat_uof_image *image;
+	struct icp_qat_uof_objtable *ae_regtab;
+	struct icp_qat_uof_objtable *init_reg_sym_tab;
+	struct icp_qat_uof_objtable *sbreak_tab;
+	struct icp_qat_uof_encap_obj *encap_uof_obj =
+					&obj_handle->encap_uof_obj;
+
+	for (a = 0; a < max_image; a++) {
+		chunk_hdr = qat_uclo_find_chunk(encap_uof_obj->obj_hdr,
+						ICP_QAT_UOF_IMAG, chunk_hdr);
+		if (!chunk_hdr)
+			break;
+		image = (struct icp_qat_uof_image *)(encap_uof_obj->beg_uof +
+						     chunk_hdr->offset);
+		ae_regtab = (struct icp_qat_uof_objtable *)
+			   (image->reg_tab_offset +
+			   obj_handle->obj_hdr->file_buff);
+		ae_uimage[a].ae_reg_num = ae_regtab->entry_num;
+		ae_uimage[a].ae_reg = (struct icp_qat_uof_ae_reg *)
+			(((char *)ae_regtab) +
+			sizeof(struct icp_qat_uof_objtable));
+		init_reg_sym_tab = (struct icp_qat_uof_objtable *)
+				   (image->init_reg_sym_tab +
+				   obj_handle->obj_hdr->file_buff);
+		ae_uimage[a].init_regsym_num = init_reg_sym_tab->entry_num;
+		ae_uimage[a].init_regsym = (struct icp_qat_uof_init_regsym *)
+			(((char *)init_reg_sym_tab) +
+			sizeof(struct icp_qat_uof_objtable));
+		sbreak_tab = (struct icp_qat_uof_objtable *)
+			(image->sbreak_tab + obj_handle->obj_hdr->file_buff);
+		ae_uimage[a].sbreak_num = sbreak_tab->entry_num;
+		ae_uimage[a].sbreak = (struct icp_qat_uof_sbreak *)
+				      (((char *)sbreak_tab) +
+				      sizeof(struct icp_qat_uof_objtable));
+		ae_uimage[a].img_ptr = image;
+		if (qat_uclo_check_image_compat(encap_uof_obj, image))
+			goto out_err;
+		ae_uimage[a].page =
+			kzalloc(sizeof(struct icp_qat_uclo_encap_page),
+				GFP_KERNEL);
+		if (!ae_uimage[a].page)
+			goto out_err;
+		qat_uclo_map_image_pages(encap_uof_obj, image,
+					 ae_uimage[a].page);
+	}
+	return a;
+out_err:
+	for (i = 0; i < a; i++)
+		kfree(ae_uimage[i].page);
+	return 0;
+}
+
+static int qat_uclo_map_ae(struct icp_qat_fw_loader_handle *handle, int max_ae)
+{
+	int i, ae;
+	int mflag = 0;
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+
+	for (ae = 0; ae <= max_ae; ae++) {
+		if (!test_bit(ae, (unsigned long *)
+			      &(handle->hal_handle->ae_mask)))
+			continue;
+		for (i = 0; i < obj_handle->uimage_num; i++) {
+			if (!test_bit(ae, (unsigned long *)
+			&(obj_handle->ae_uimage[i].img_ptr->ae_assigned)))
+				continue;
+			mflag = 1;
+			if (qat_uclo_init_ae_data(obj_handle, ae, i))
+				return -EINVAL;
+		}
+	}
+	if (!mflag) {
+		pr_err("QAT: uimage uses AE not set");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static struct icp_qat_uof_strtable *
+qat_uclo_map_str_table(struct icp_qat_uclo_objhdr *obj_hdr,
+		       char *tab_name, struct icp_qat_uof_strtable *str_table)
+{
+	struct icp_qat_uof_chunkhdr *chunk_hdr;
+
+	chunk_hdr = qat_uclo_find_chunk((struct icp_qat_uof_objhdr *)
+					obj_hdr->file_buff, tab_name, NULL);
+	if (chunk_hdr) {
+		int hdr_size;
+		memcpy(&str_table->table_len, obj_hdr->file_buff +
+		       chunk_hdr->offset, sizeof(str_table->table_len));
+		hdr_size = (char *)&str_table->strings - (char *)str_table;
+		str_table->strings = (unsigned long)obj_hdr->file_buff +
+					chunk_hdr->offset + hdr_size;
+		return str_table;
+	}
+	return NULL;
+}
+
+static void
+qat_uclo_map_initmem_table(struct icp_qat_uof_encap_obj *encap_uof_obj,
+			   struct icp_qat_uclo_init_mem_table *init_mem_tab)
+{
+	struct icp_qat_uof_chunkhdr *chunk_hdr;
+
+	chunk_hdr = qat_uclo_find_chunk(encap_uof_obj->obj_hdr,
+					ICP_QAT_UOF_IMEM, NULL);
+	if (chunk_hdr) {
+		memmove(&init_mem_tab->entry_num, encap_uof_obj->beg_uof +
+			chunk_hdr->offset, sizeof(unsigned int));
+		init_mem_tab->init_mem = (struct icp_qat_uof_initmem *)
+		(encap_uof_obj->beg_uof + chunk_hdr->offset +
+		sizeof(unsigned int));
+	}
+}
+
+static int qat_uclo_check_uof_compat(struct icp_qat_uclo_objhandle *obj_handle)
+{
+	unsigned int maj_ver, prod_type = obj_handle->prod_type;
+
+	if (!(prod_type & obj_handle->encap_uof_obj.obj_hdr->cpu_type)) {
+		pr_err("QAT: uof type 0x%x not match with cur platform 0x%x\n",
+		       obj_handle->encap_uof_obj.obj_hdr->cpu_type, prod_type);
+		return -EINVAL;
+	}
+	maj_ver = obj_handle->prod_rev & 0xff;
+	if ((obj_handle->encap_uof_obj.obj_hdr->max_cpu_ver < maj_ver) ||
+	    (obj_handle->encap_uof_obj.obj_hdr->min_cpu_ver > maj_ver)) {
+		pr_err("QAT: uof majVer 0x%x out of range\n", maj_ver);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int qat_uclo_init_reg(struct icp_qat_fw_loader_handle *handle,
+			     unsigned char ae, unsigned char ctx_mask,
+			     enum icp_qat_uof_regtype reg_type,
+			     unsigned short reg_addr, unsigned int value)
+{
+	switch (reg_type) {
+	case ICP_GPA_ABS:
+	case ICP_GPB_ABS:
+		ctx_mask = 0;
+	case ICP_GPA_REL:
+	case ICP_GPB_REL:
+		return qat_hal_init_gpr(handle, ae, ctx_mask, reg_type,
+					reg_addr, value);
+	case ICP_SR_ABS:
+	case ICP_DR_ABS:
+	case ICP_SR_RD_ABS:
+	case ICP_DR_RD_ABS:
+		ctx_mask = 0;
+	case ICP_SR_REL:
+	case ICP_DR_REL:
+	case ICP_SR_RD_REL:
+	case ICP_DR_RD_REL:
+		return qat_hal_init_rd_xfer(handle, ae, ctx_mask, reg_type,
+					    reg_addr, value);
+	case ICP_SR_WR_ABS:
+	case ICP_DR_WR_ABS:
+		ctx_mask = 0;
+	case ICP_SR_WR_REL:
+	case ICP_DR_WR_REL:
+		return qat_hal_init_wr_xfer(handle, ae, ctx_mask, reg_type,
+					    reg_addr, value);
+	case ICP_NEIGH_REL:
+		return qat_hal_init_nn(handle, ae, ctx_mask, reg_addr, value);
+	default:
+		pr_err("QAT: UOF uses not supported reg type 0x%x\n", reg_type);
+		return -EFAULT;
+	}
+	return 0;
+}
+
+static int qat_uclo_init_reg_sym(struct icp_qat_fw_loader_handle *handle,
+				 unsigned int ae,
+				 struct icp_qat_uclo_encapme *encap_ae)
+{
+	unsigned int i;
+	unsigned char ctx_mask;
+	struct icp_qat_uof_init_regsym *init_regsym;
+
+	if (ICP_QAT_CTX_MODE(encap_ae->img_ptr->ae_mode) ==
+	    ICP_QAT_UCLO_MAX_CTX)
+		ctx_mask = 0xff;
+	else
+		ctx_mask = 0x55;
+
+	for (i = 0; i < encap_ae->init_regsym_num; i++) {
+		unsigned int exp_res;
+		init_regsym = &encap_ae->init_regsym[i];
+		exp_res = init_regsym->value;
+		switch (init_regsym->init_type) {
+		case ICP_QAT_UOF_INIT_REG:
+			qat_uclo_init_reg(handle, ae, ctx_mask,
+					  (enum icp_qat_uof_regtype)
+					  init_regsym->reg_type,
+					  (unsigned short)init_regsym->reg_addr,
+					  exp_res);
+			break;
+		case ICP_QAT_UOF_INIT_REG_CTX:
+			/* check if ctx is appropriate for the ctxMode */
+			if (!((1 << init_regsym->ctx) & ctx_mask)) {
+				pr_err("QAT: invalid ctx num = 0x%x\n",
+				       init_regsym->ctx);
+				return -EINVAL;
+			}
+			qat_uclo_init_reg(handle, ae,
+					  (unsigned char)
+					  (1 << init_regsym->ctx),
+					  (enum icp_qat_uof_regtype)
+					  init_regsym->reg_type,
+					  (unsigned short)init_regsym->reg_addr,
+					  exp_res);
+			break;
+		case ICP_QAT_UOF_INIT_EXPR:
+			pr_err("QAT: INIT_EXPR feature not supported\n");
+			return -EINVAL;
+		case ICP_QAT_UOF_INIT_EXPR_ENDIAN_SWAP:
+			pr_err("QAT: INIT_EXPR_ENDIAN_SWAP feature not supported\n");
+			return -EINVAL;
+		default:
+			break;
+		}
+	}
+	return 0;
+}
+
+static int qat_uclo_init_globals(struct icp_qat_fw_loader_handle *handle)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned int s, ae;
+
+	if (obj_handle->global_inited)
+		return 0;
+	if (obj_handle->init_mem_tab.entry_num) {
+		if (qat_uclo_init_memory(handle)) {
+			pr_err("QAT: initalize memory failed\n");
+			return -EINVAL;
+		}
+	}
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		for (s = 0; s < obj_handle->ae_data[ae].slice_num; s++) {
+			if (!obj_handle->ae_data[ae].ae_slices[s].encap_image)
+				continue;
+			if (qat_uclo_init_reg_sym(handle, ae,
+						  obj_handle->ae_data[ae].
+						  ae_slices[s].encap_image))
+				return -EINVAL;
+		}
+	}
+	obj_handle->global_inited = 1;
+	return 0;
+}
+
+static int qat_uclo_set_ae_mode(struct icp_qat_fw_loader_handle *handle)
+{
+	unsigned char ae, nn_mode, s;
+	struct icp_qat_uof_image *uof_image;
+	struct icp_qat_uclo_aedata *ae_data;
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!test_bit(ae,
+			      (unsigned long *)&(handle->hal_handle->ae_mask)))
+			continue;
+		ae_data = &(obj_handle->ae_data[ae]);
+		for (s = 0; s < ae_data->slice_num && s < ICP_QAT_UCLO_MAX_CTX;
+		     s++) {
+			if (!(obj_handle->ae_data[ae].ae_slices[s].encap_image))
+				continue;
+			uof_image = ae_data->ae_slices[s].encap_image->img_ptr;
+			if (qat_hal_set_ae_ctx_mode(handle, ae,
+						    (char)ICP_QAT_CTX_MODE
+						    (uof_image->ae_mode))) {
+				pr_err("QAT: qat_hal_set_ae_ctx_mode error\n");
+				return -EFAULT;
+			}
+			nn_mode = ICP_QAT_NN_MODE(uof_image->ae_mode);
+			if (qat_hal_set_ae_nn_mode(handle, ae, nn_mode)) {
+				pr_err("QAT: qat_hal_set_ae_nn_mode error\n");
+				return -EFAULT;
+			}
+			if (qat_hal_set_ae_lm_mode(handle, ae, ICP_LMEM0,
+						   (char)ICP_QAT_LOC_MEM0_MODE
+						   (uof_image->ae_mode))) {
+				pr_err("QAT: qat_hal_set_ae_lm_mode error\n ");
+				return -EFAULT;
+			}
+			if (qat_hal_set_ae_lm_mode(handle, ae, ICP_LMEM1,
+						   (char)ICP_QAT_LOC_MEM1_MODE
+						   (uof_image->ae_mode))) {
+				pr_err("QAT: qat_hal_set_ae_lm_mode error\n ");
+				return -EFAULT;
+			}
+		}
+	}
+	return 0;
+}
+
+static void qat_uclo_init_uword_num(struct icp_qat_fw_loader_handle *handle)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	struct icp_qat_uclo_encapme *image;
+	int a;
+
+	for (a = 0; a < obj_handle->uimage_num; a++) {
+		image = &obj_handle->ae_uimage[a];
+		image->uwords_num = image->page->beg_addr_p +
+					image->page->micro_words_num;
+	}
+}
+
+static int qat_uclo_parse_uof_obj(struct icp_qat_fw_loader_handle *handle)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned int ae;
+
+	obj_handle->uword_buf = kzalloc(UWORD_CPYBUF_SIZE * sizeof(uint64_t),
+					GFP_KERNEL);
+	if (!obj_handle->uword_buf)
+		return -ENOMEM;
+	obj_handle->encap_uof_obj.beg_uof = obj_handle->obj_hdr->file_buff;
+	obj_handle->encap_uof_obj.obj_hdr = (struct icp_qat_uof_objhdr *)
+					     obj_handle->obj_hdr->file_buff;
+	obj_handle->encap_uof_obj.chunk_hdr = (struct icp_qat_uof_chunkhdr *)
+	    obj_handle->obj_hdr->file_buff + sizeof(struct icp_qat_uof_objhdr);
+	obj_handle->uword_in_bytes = 6;
+	obj_handle->prod_type = ICP_QAT_AC_C_CPU_TYPE;
+	obj_handle->prod_rev = PID_MAJOR_REV |
+			(PID_MINOR_REV & handle->hal_handle->revision_id);
+	if (qat_uclo_check_uof_compat(obj_handle)) {
+		pr_err("QAT: uof incompatible\n ");
+		return -EINVAL;
+	}
+	obj_handle->ustore_phy_size = ICP_QAT_UCLO_MAX_USTORE;
+	if (!(obj_handle->obj_hdr->file_buff) ||
+	    !(qat_uclo_map_str_table(obj_handle->obj_hdr, ICP_QAT_UOF_STRT,
+				     &(obj_handle->str_table)))) {
+		pr_err("QAT: uof doesn't have effective images");
+		goto out_err;
+	}
+	obj_handle->uimage_num =
+		qat_uclo_map_uimage(obj_handle, obj_handle->ae_uimage,
+				    ICP_QAT_UCLO_MAX_AE * ICP_QAT_UCLO_MAX_CTX);
+	if (!obj_handle->uimage_num)
+		goto out_err;
+	if (qat_uclo_map_ae(handle, handle->hal_handle->ae_max_num)) {
+		pr_err("QAT: Bad object\n ");
+		goto out_check_uof_aemask_err;
+	}
+	qat_uclo_init_uword_num(handle);
+	qat_uclo_map_initmem_table(&(obj_handle->encap_uof_obj),
+				   &(obj_handle->init_mem_tab));
+	if (qat_uclo_set_ae_mode(handle))
+		goto out_check_uof_aemask_err;
+	return 0;
+out_check_uof_aemask_err:
+	for (ae = 0; ae < obj_handle->uimage_num; ae++)
+		kfree(obj_handle->ae_uimage[ae].page);
+out_err:
+	kfree(obj_handle->uword_buf);
+	return -EFAULT;
+}
+
+int qat_uclo_map_uof_obj(struct icp_qat_fw_loader_handle *handle,
+			 void *addr_ptr, int mem_size)
+{
+	struct icp_qat_uof_filehdr *filehdr;
+	struct icp_qat_uclo_objhandle *objhdl;
+
+	BUILD_BUG_ON(ICP_QAT_UCLO_MAX_AE >=
+		     (sizeof(handle->hal_handle->ae_mask) * 8));
+
+	if (!handle || !addr_ptr || mem_size < 24)
+		return -EINVAL;
+	objhdl = kzalloc(sizeof(*objhdl), GFP_KERNEL);
+	if (!objhdl)
+		return -ENOMEM;
+	objhdl->obj_buf = kmemdup(addr_ptr, mem_size, GFP_KERNEL);
+	if (!objhdl->obj_buf)
+		goto out_objbuf_err;
+	filehdr = (struct icp_qat_uof_filehdr *)objhdl->obj_buf;
+	if (qat_uclo_check_format(filehdr))
+		goto out_objhdr_err;
+	objhdl->obj_hdr = qat_uclo_map_chunk((char *)objhdl->obj_buf, filehdr,
+					     ICP_QAT_UOF_OBJS);
+	if (!objhdl->obj_hdr) {
+		pr_err("QAT: object file chunk is null\n");
+		goto out_objhdr_err;
+	}
+	handle->obj_handle = objhdl;
+	if (qat_uclo_parse_uof_obj(handle))
+		goto out_overlay_obj_err;
+	return 0;
+
+out_overlay_obj_err:
+	handle->obj_handle = NULL;
+	kfree(objhdl->obj_hdr);
+out_objhdr_err:
+	kfree(objhdl->obj_buf);
+out_objbuf_err:
+	kfree(objhdl);
+	return -ENOMEM;
+}
+
+int qat_uclo_del_uof_obj(struct icp_qat_fw_loader_handle *handle)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	int a;
+
+	kfree(obj_handle->uword_buf);
+	for (a = 0; a < obj_handle->uimage_num; a++)
+		kfree(obj_handle->ae_uimage[a].page);
+
+	for (a = 0; a <= (int)handle->hal_handle->ae_max_num; a++)
+		qat_uclo_free_ae_data(&obj_handle->ae_data[a]);
+	kfree(obj_handle->obj_hdr);
+
+	kfree(obj_handle->obj_buf);
+	kfree(obj_handle);
+	handle->obj_handle = NULL;
+	return 0;
+}
+
+static void qat_uclo_fill_uwords(struct icp_qat_uclo_objhandle *obj_handle,
+				 struct icp_qat_uclo_encap_page *encap_page,
+				 uint64_t *uword, unsigned int addr_p,
+				 unsigned int raddr, uint64_t fill)
+{
+	uint64_t uwrd = 0;
+	unsigned int i;
+
+	if (!encap_page) {
+		*uword = fill;
+		return;
+	}
+	for (i = 0; i < encap_page->uwblock_num; i++) {
+		if (raddr >= encap_page->uwblock[i].start_addr &&
+		    raddr <= encap_page->uwblock[i].start_addr +
+		    encap_page->uwblock[i].words_num - 1) {
+			raddr -= encap_page->uwblock[i].start_addr;
+			raddr *= obj_handle->uword_in_bytes;
+			memcpy(&uwrd, (void *)(((unsigned long)
+			       encap_page->uwblock[i].micro_words) + raddr),
+			       obj_handle->uword_in_bytes);
+			uwrd = uwrd & 0xbffffffffffull;
+		}
+	}
+	*uword = uwrd;
+	if (*uword == INVLD_UWORD)
+		*uword = fill;
+}
+
+static int qat_uclo_wr_uimage_raw_page(struct icp_qat_fw_loader_handle *handle,
+				       struct icp_qat_uclo_encap_page
+				       *encap_page, unsigned int ae)
+{
+	unsigned int uw_physical_addr, uw_relative_addr, i, words_num, cpylen;
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	uint64_t fill_pat;
+	int status = 0;
+
+	/* load the page starting at appropriate ustore address */
+	/* get fill-pattern from an image -- they are all the same */
+	memcpy(&fill_pat, obj_handle->ae_uimage[0].img_ptr->fill_pattern,
+	       sizeof(uint64_t));
+	uw_physical_addr = encap_page->beg_addr_p;
+	uw_relative_addr = 0;
+	words_num = encap_page->micro_words_num;
+	while (words_num) {
+		if (words_num < UWORD_CPYBUF_SIZE)
+			cpylen = words_num;
+		else
+			cpylen = UWORD_CPYBUF_SIZE;
+
+		/* load the buffer */
+		for (i = 0; i < cpylen; i++)
+			qat_uclo_fill_uwords(obj_handle, encap_page,
+					     &obj_handle->uword_buf[i],
+					     uw_physical_addr + i,
+					     uw_relative_addr + i, fill_pat);
+
+		/* copy the buffer to ustore */
+		qat_hal_wr_uwords(handle, (unsigned char)ae,
+				  uw_physical_addr, cpylen,
+				  obj_handle->uword_buf);
+
+		uw_physical_addr += cpylen;
+		uw_relative_addr += cpylen;
+		words_num -= cpylen;
+	}
+	return status;
+}
+
+static int
+qat_uclo_wr_uimage_pages(struct icp_qat_fw_loader_handle *handle,
+			 struct icp_qat_uof_image *image)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned int ctx_mask, s;
+	struct icp_qat_uclo_page *page;
+	unsigned char ae;
+	int retval = 0;
+	int ctx;
+
+	if (ICP_QAT_CTX_MODE(image->ae_mode) == ICP_QAT_UCLO_MAX_CTX)
+		ctx_mask = 0xff;
+	else
+		ctx_mask = 0x55;
+	/* load the default page and set assigned CTX PC
+	 * to the entrypoint address */
+	for (ae = 0; ae <= handle->hal_handle->ae_max_num; ae++) {
+		if (!test_bit(ae, (unsigned long *)&(image->ae_assigned)))
+			continue;
+		/* find the slice to which this image is assigned */
+		for (s = 0; s < obj_handle->ae_data[ae].slice_num; s++) {
+			if (image->ctx_assigned & obj_handle->ae_data[ae].
+			    ae_slices[s].ctx_mask_assigned)
+				break;
+		}
+		if (s >= obj_handle->ae_data[ae].slice_num)
+			continue;
+		page = obj_handle->ae_data[ae].ae_slices[s].page;
+		if (!page->encap_page->def_page)
+			continue;
+		if (qat_uclo_wr_uimage_raw_page(handle, page->encap_page, ae))
+			return -EINVAL;
+
+		page = obj_handle->ae_data[ae].ae_slices[s].page;
+		for (ctx = 0; ctx < ICP_QAT_UCLO_MAX_CTX; ctx++)
+			obj_handle->ae_data[ae].ae_slices[s].cur_page[ctx] =
+					(ctx_mask & (1 << ctx)) ? page : NULL;
+		qat_hal_set_live_ctx(handle, (unsigned char)ae,
+				     image->ctx_assigned);
+		qat_hal_set_pc(handle, (unsigned char)ae, image->ctx_assigned,
+			       image->entry_address);
+	}
+	return retval;
+}
+int qat_uclo_wr_all_uimage(struct icp_qat_fw_loader_handle *handle)
+{
+	struct icp_qat_uclo_objhandle *obj_handle = handle->obj_handle;
+	unsigned int i;
+
+	if (qat_uclo_init_globals(handle))
+		return -EINVAL;
+	for (i = 0; i < obj_handle->uimage_num; i++) {
+		if (!(obj_handle->ae_uimage[i].img_ptr))
+			return -EINVAL;
+		if (qat_uclo_init_ustore(handle, &(obj_handle->ae_uimage[i])))
+			return -EINVAL;
+		if (qat_uclo_wr_uimage_pages(handle,
+					     obj_handle->ae_uimage[i].img_ptr))
+			return -EINVAL;
+	}
+	return 0;
+}
-- 
1.8.5.rc2.6.gc6f1b92.dirty

