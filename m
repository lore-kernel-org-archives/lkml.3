Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607AbaJDNYw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:24:52 -0400
Received: from mail-bl2on0122.outbound.protection.outlook.com ([65.55.169.122]:26604
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750997AbaJDNYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:24:47 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>, <bhamciu1@freescale.com>,
        <R89243@freescale.com>, <Geoff.Thorpe@freescale.com>,
        <bhupesh.sharma@freescale.com>, <nir.erez@freescale.com>,
        <richard.schmitt@freescale.com>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [PATCH 1/3 v3] drivers/bus: Added Freescale Management Complex APIs
Date: Sat, 4 Oct 2014 08:23:33 -0500
Message-ID: <1412429015-30564-2-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com>
References: <1412429015-30564-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(448002)(189002)(199003)(45074003)(4396001)(84676001)(104016003)(36756003)(89996001)(50226001)(68736004)(19580395003)(99396003)(10300001)(120916001)(6806004)(50986999)(85326001)(76176999)(31966008)(85852003)(104166001)(44976005)(87286001)(19580405001)(77156001)(88136002)(46102003)(87936001)(80022003)(85306004)(64706001)(20776003)(47776003)(97736003)(26826002)(2201001)(92566001)(102836001)(92726001)(106466001)(50466002)(95666004)(86362001)(229853001)(93916002)(76482002)(48376002)(107046002)(21056001)(62966002)(2004002)(579004)(559001)(569005);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2PR0301MB0742;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR0301MB0742;
X-Forefront-PRVS: 0354B4BED2
Authentication-Results: spf=permerror (sender IP is 192.88.168.50)
 smtp.mailfrom=German.Rivera@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "J. German Rivera" <German.Rivera@freescale.com>

APIs to access the Management Complex (MC) hardware
module of Freescale LS2 SoCs. This patch includes
APIs to check the MC firmware version and to manipulate
DPRC objects in the MC.

Signed-off-by: J. German Rivera <German.Rivera@freescale.com>
Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
Changes in v3:
- Addressed comment from Greg Kroah-Hartman:
  * Removed doxygen comments

- Addressed comment from Scott Wood:
  * Replaced udelay() call with usleep_range() call in polling loop
- Addressed comments from Kim Phillips:
  * Fixed license text in all files
  * Renamed files:
	drivers/bus/fsl-mc/fsl_dpmng_cmd.h -> drivers/bus/fsl-mc/dpmng-cmd.h
	drivers/bus/fsl-mc/fsl_dprc_cmd.h -> drivers/bus/fsl-mc/dprc-cmd.h
	drivers/bus/fsl-mc/fsl_mc_sys.c -> drivers/bus/fsl-mc/mc-sys.c
	include/linux/fsl_dpmng.h -> include/linux/fsl/dpmng.h
	include/linux/fsl_dprc.h -> include/linux/fsl/dprc.h
	include/linux/fsl_mc_cmd.h -> include/linux/fsl/mc-cmd.h
	include/linux/fsl_mc_sys.h -> include/linux/fsl/mc-sys.h
  * Changed dpmng_load_iop() to take the DMA address directly,
    instead of the image virtual address.
  * Removed if and WARN_ON that checks for NULL fsl_destroy_mc_io()
  * Removed locking from mc_send_command(). Now the caller of MC flib
    APIs is responsible for protecting concurrent accesses to the same
    MC portal.

Changes in v2:
- Addressed comment from Joe Perches:
  * Refactored logic to actively fail on err and proceed at
    the same indent level on success, for all functions in dprc.c
    and dpmng.c.

- Addressed comments from Kim Phillips:
  * Fixed warning in mc_send_command
  * Changed serialization logic in mc_send_command() to only use
    spinlock_irqsave() when both threads and interrupt handlers
    concurrently access the same portal.
  * Changed switch to lookup table in mc_status_to_error()
  * Removed macros iowrite64(), ioread64(), ENOTSUP from fsl_mc_sys.h
  * Removed #ifdef side for FSL_MC_FIRMWARE in fsl_mc_cmd.h
  * Changed non-devm_ API calls to devm_ API calls and refactored
    fsl_create_mc_io()/fsl_destroy_mc_io() to simplify cleanup logic.

- Addressed comments from Scott Wood:
  * Return -ENXIO instead of -EFAULT when ioremap_nocache() fails

- Addressed comments from Alex Graf:
  * Added MAINTAINERS file entries for new files
  * Added dev param to fsl_create_mc_io(), to enable the use
    of devm_ APIs in this function and fsl_destroy_mc_io().
  * Changed the value of the timeout for MC command completion
    to be a function of HZ instead of a hard-coded jiffies value.

 MAINTAINERS                    |    8 +
 drivers/bus/fsl-mc/dpmng-cmd.h |   83 +++++
 drivers/bus/fsl-mc/dpmng.c     |   94 +++++
 drivers/bus/fsl-mc/dprc-cmd.h  |  545 +++++++++++++++++++++++++++
 drivers/bus/fsl-mc/dprc.c      |  521 ++++++++++++++++++++++++++
 drivers/bus/fsl-mc/mc-sys.c    |  189 ++++++++++
 include/linux/fsl/dpmng.h      |  121 ++++++
 include/linux/fsl/dprc.h       |  791 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fsl/mc-cmd.h     |  169 +++++++++
 include/linux/fsl/mc-sys.h     |   68 ++++
 10 files changed, 2589 insertions(+)
 create mode 100644 drivers/bus/fsl-mc/dpmng-cmd.h
 create mode 100644 drivers/bus/fsl-mc/dpmng.c
 create mode 100644 drivers/bus/fsl-mc/dprc-cmd.h
 create mode 100644 drivers/bus/fsl-mc/dprc.c
 create mode 100644 drivers/bus/fsl-mc/mc-sys.c
 create mode 100644 include/linux/fsl/dpmng.h
 create mode 100644 include/linux/fsl/dprc.h
 create mode 100644 include/linux/fsl/mc-cmd.h
 create mode 100644 include/linux/fsl/mc-sys.h

diff --git a/MAINTAINERS b/MAINTAINERS
index 8fd05d4..907b50d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3874,6 +3874,14 @@ F:	sound/soc/fsl/fsl*
 F:	sound/soc/fsl/imx*
 F:	sound/soc/fsl/mpc8610_hpcd.c

+FREESCALE QORIQ MANAGEMENT COMPLEX DRIVER
+M:	J. German Rivera <German.Rivera@freescale.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	include/linux/fsl_mc*
+F:	include/linux/fsl_dp*
+F:	drivers/bus/fsl-mc/*
+
 FREEVXFS FILESYSTEM
 M:	Christoph Hellwig <hch@infradead.org>
 W:	ftp://ftp.openlinux.org/pub/people/hch/vxfs
diff --git a/drivers/bus/fsl-mc/dpmng-cmd.h b/drivers/bus/fsl-mc/dpmng-cmd.h
new file mode 100644
index 0000000..cdeaa16
--- /dev/null
+++ b/drivers/bus/fsl-mc/dpmng-cmd.h
@@ -0,0 +1,83 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/*************************************************************************//*
+ dpmng-cmd.h
+
+ defines portal commands
+
+ *//**************************************************************************/
+
+#ifndef __FSL_DPMNG_CMD_H
+#define __FSL_DPMNG_CMD_H
+
+/* Command IDs */
+#define DPMNG_CMDID_GET_VERSION			0x831
+#define DPMNG_CMDID_RESET_AIOP			0x832
+#define DPMNG_CMDID_LOAD_AIOP			0x833
+#define DPMNG_CMDID_RUN_AIOP			0x834
+
+/* Command sizes */
+#define DPMNG_CMDSZ_GET_VERSION			(8 * 2)
+#define DPMNG_CMDSZ_RESET_AIOP			8
+#define DPMNG_CMDSZ_LOAD_AIOP			(8 * 2)
+#define DPMNG_CMDSZ_RUN_AIOP			(8 * 2)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPMNG_RSP_GET_VERSION(cmd, mc_ver_info) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	32, uint32_t,	mc_ver_info->revision);\
+	MC_RSP_PARAM_OP(cmd, 0,	32,	32, uint32_t,	mc_ver_info->major); \
+	MC_RSP_PARAM_OP(cmd, 1,	0,	8,  uint32_t,	mc_ver_info->minor); \
+} while (0)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPMNG_CMD_RESET_AIOP(cmd, aiop_tile_id) \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,	aiop_tile_id)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPMNG_CMD_LOAD_AIOP(cmd, aiop_tile_id, img_size, img_paddr) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32, int,	aiop_tile_id); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	32, int,	img_size); \
+	MC_CMD_PARAM_OP(cmd, 1,	0,	64, uint64_t,	img_paddr); \
+} while (0)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPMNG_CMD_RUN_AIOP(cmd, aiop_tile_id, cores_mask, options) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,		aiop_tile_id); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	32,	uint32_t,	cores_mask); \
+	MC_CMD_PARAM_OP(cmd, 1,	0,	64,	uint64_t,	options); \
+} while (0)
+
+#endif /* __FSL_DPMNG_CMD_H */
diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
new file mode 100644
index 0000000..8a32448
--- /dev/null
+++ b/drivers/bus/fsl-mc/dpmng.c
@@ -0,0 +1,94 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/fsl/mc-sys.h>
+#include <linux/fsl/mc-cmd.h>
+#include <linux/fsl/dpmng.h>
+#include "dpmng-cmd.h"
+
+int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_GET_VERSION,
+					  DPMNG_CMDSZ_GET_VERSION,
+					  MC_CMD_PRI_LOW, 0);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);
+	return 0;
+}
+
+int dpmng_reset_aiop(struct fsl_mc_io *mc_io, int aiop_tile_id)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_RESET_AIOP,
+					  DPMNG_CMDSZ_RESET_AIOP,
+					  MC_CMD_PRI_LOW, 0);
+
+	DPMNG_CMD_RESET_AIOP(cmd, aiop_tile_id);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmng_load_aiop(struct fsl_mc_io *mc_io,
+		    int aiop_tile_id, dma_addr_t img_dma_addr, int img_size)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_LOAD_AIOP,
+					  DPMNG_CMDSZ_LOAD_AIOP,
+					  MC_CMD_PRI_LOW, 0);
+
+	DPMNG_CMD_LOAD_AIOP(cmd, aiop_tile_id, img_size, img_dma_addr);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dpmng_run_aiop(struct fsl_mc_io *mc_io,
+		   int aiop_tile_id, uint32_t cores_mask, uint64_t options)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_RUN_AIOP,
+					  DPMNG_CMDSZ_RUN_AIOP,
+					  MC_CMD_PRI_LOW, 0);
+
+	DPMNG_CMD_RUN_AIOP(cmd, aiop_tile_id, cores_mask, options);
+
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/bus/fsl-mc/dprc-cmd.h b/drivers/bus/fsl-mc/dprc-cmd.h
new file mode 100644
index 0000000..0ce3ada
--- /dev/null
+++ b/drivers/bus/fsl-mc/dprc-cmd.h
@@ -0,0 +1,545 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/*************************************************************************//*
+ dprc-cmd.h
+
+ defines dprc portal commands
+
+ *//**************************************************************************/
+
+#ifndef _FSL_DPRC_CMD_H
+#define _FSL_DPRC_CMD_H
+
+/* DPRC Version */
+#define DPRC_VER_MAJOR				1
+#define DPRC_VER_MINOR				0
+
+/* Command IDs */
+#define MC_CMDID_CLOSE				0x800
+#define MC_DPRC_CMDID_OPEN			0x805
+#define MC_DPRC_CMDID_CREATE			0x905
+
+#define DPRC_CMDID_CREATE_CONT			0x151
+#define DPRC_CMDID_DESTROY_CONT			0x152
+#define DPRC_CMDID_GET_CONT_ID			0x830
+#define DPRC_CMDID_RESET_CONT			0x154
+#define DPRC_CMDID_SET_RES_QUOTA		0x155
+#define DPRC_CMDID_GET_RES_QUOTA		0x156
+#define DPRC_CMDID_ASSIGN			0x157
+#define DPRC_CMDID_UNASSIGN			0x158
+#define DPRC_CMDID_GET_OBJ_COUNT		0x159
+#define DPRC_CMDID_GET_OBJECT			0x15A
+#define DPRC_CMDID_GET_RES_COUNT		0x15B
+#define DPRC_CMDID_GET_RES_IDS			0x15C
+#define DPRC_CMDID_GET_ATTR			0x15D
+#define DPRC_CMDID_GET_OBJ_REG			0x15E
+#define DPRC_CMDID_SET_IRQ			0x15F
+#define DPRC_CMDID_GET_IRQ			0x160
+#define DPRC_CMDID_SET_IRQ_ENABLE		0x161
+#define DPRC_CMDID_GET_IRQ_ENABLE		0x162
+#define DPRC_CMDID_SET_IRQ_MASK			0x163
+#define DPRC_CMDID_GET_IRQ_MASK			0x164
+#define DPRC_CMDID_GET_IRQ_STATUS		0x165
+#define DPRC_CMDID_CLEAR_IRQ_STATUS		0x166
+#define DPRC_CMDID_CONNECT			0x167
+#define DPRC_CMDID_DISCONNECT			0x168
+#define DPRC_CMDID_GET_POOL			0x169
+#define DPRC_CMDID_GET_POOL_COUNT		0x16A
+#define DPRC_CMDID_GET_PORTAL_PADDR		0x16B
+
+/* Command sizes */
+#define MC_CMD_OPEN_SIZE			8
+#define MC_CMD_CLOSE_SIZE			0
+#define DPRC_CMDSZ_CREATE_CONT			(8 * 2)
+#define DPRC_CMDSZ_DESTROY_CONT			8
+#define DPRC_CMDSZ_GET_CONT_ID			8
+#define DPRC_CMDSZ_RESET_CONT			8
+#define DPRC_CMDSZ_SET_RES_QUOTA		(8 * 3)
+#define DPRC_CMDSZ_GET_RES_QUOTA		(8 * 3)
+#define DPRC_CMDSZ_ASSIGN			(8 * 4)
+#define DPRC_CMDSZ_UNASSIGN			(8 * 4)
+#define DPRC_CMDSZ_GET_OBJ_COUNT		0
+#define DPRC_CMDSZ_GET_OBJECT			(8 * 5)
+#define DPRC_CMDSZ_GET_RES_COUNT		8
+#define DPRC_CMDSZ_GET_RES_IDS			(8 * 4)
+#define DPRC_CMDSZ_GET_ATTR			(8 * 3)
+#define DPRC_CMDSZ_GET_OBJ_REG			(8 * 5)
+#define DPRC_CMDSZ_SET_IRQ			(8 * 3)
+#define DPRC_CMDSZ_GET_IRQ			(8 * 3)
+#define DPRC_CMDSZ_SET_IRQ_ENABLE		8
+#define DPRC_CMDSZ_GET_IRQ_ENABLE		8
+#define DPRC_CMDSZ_SET_IRQ_MASK			8
+#define DPRC_CMDSZ_GET_IRQ_MASK			8
+#define DPRC_CMDSZ_GET_IRQ_STATUS		8
+#define DPRC_CMDSZ_CLEAR_IRQ_STATUS		8
+#define DPRC_CMDSZ_CONNECT			(8 * 7)
+#define DPRC_CMDSZ_DISCONNECT			(8 * 3)
+#define DPRC_CMDSZ_GET_POOL			(8 * 3)
+#define DPRC_CMDSZ_GET_POOL_COUNT		8
+#define DPRC_CMDSZ_GET_PORTAL_PADDR		(8 * 2)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_OPEN(cmd, container_id) \
+	MC_CMD_PARAM_OP(cmd, 0, 0, 32,	int, container_id)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_CONTAINER_ID(cmd, container_id) \
+	MC_RSP_PARAM_OP(cmd, 0,  0, 32, int, container_id)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_CREATE_CONTAINER(cmd, cfg) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0, 32, 16, uint16_t, cfg->icid); \
+	MC_CMD_PARAM_OP(cmd, 0, 0,  32, uint32_t, cfg->options); \
+	MC_CMD_PARAM_OP(cmd, 1, 32, 32, int,	  cfg->portal_id); \
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_CREATE_CONTAINER(cmd, child_container_id, child_portal_paddr) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 1, 0, 32,	int,	  child_container_id); \
+	MC_RSP_PARAM_OP(cmd, 2, 0, 64,	uint64_t, child_portal_paddr); \
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_DESTROY_CONTAINER(cmd, child_container_id) \
+	MC_CMD_PARAM_OP(cmd, 0,	0, 32, int, child_container_id)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_RESET_CONTAINER(cmd, child_container_id) \
+	MC_CMD_PARAM_OP(cmd, 0,	0, 32, int, child_container_id)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_SET_RES_QUOTA(cmd, child_container_id, type, quota) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	 0,	32,	int,	  child_container_id); \
+	MC_CMD_PARAM_OP(cmd, 0,  32,	16,	uint16_t, quota);\
+	MC_CMD_PARAM_OP(cmd, 1,  0,	8,	char,	  type[0]);\
+	MC_CMD_PARAM_OP(cmd, 1,  8,	8,	char,	  type[1]);\
+	MC_CMD_PARAM_OP(cmd, 1,  16,	8,	char,	  type[2]);\
+	MC_CMD_PARAM_OP(cmd, 1,  24,	8,	char,	  type[3]);\
+	MC_CMD_PARAM_OP(cmd, 1,  32,	8,	char,	  type[4]);\
+	MC_CMD_PARAM_OP(cmd, 1,  40,	8,	char,	  type[5]);\
+	MC_CMD_PARAM_OP(cmd, 1,  48,	8,	char,	  type[6]);\
+	MC_CMD_PARAM_OP(cmd, 1,  56,	8,	char,	  type[7]);\
+	MC_CMD_PARAM_OP(cmd, 2,  0,	8,	char,	  type[8]);\
+	MC_CMD_PARAM_OP(cmd, 2,  8,	8,	char,	  type[9]);\
+	MC_CMD_PARAM_OP(cmd, 2,  16,	8,	char,	  type[10]);\
+	MC_CMD_PARAM_OP(cmd, 2,  24,	8,	char,	  type[11]);\
+	MC_CMD_PARAM_OP(cmd, 2,  32,	8,	char,	  type[12]);\
+	MC_CMD_PARAM_OP(cmd, 2,  40,	8,	char,	  type[13]);\
+	MC_CMD_PARAM_OP(cmd, 2,  48,	8,	char,	  type[14]);\
+	MC_CMD_PARAM_OP(cmd, 2,  56,	8,	char,	  type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_RES_QUOTA(cmd, child_container_id, type) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,	child_container_id); \
+	MC_CMD_PARAM_OP(cmd, 1,  0,	8,	char,	type[0]);\
+	MC_CMD_PARAM_OP(cmd, 1,  8,	8,	char,	type[1]);\
+	MC_CMD_PARAM_OP(cmd, 1,  16,	8,	char,	type[2]);\
+	MC_CMD_PARAM_OP(cmd, 1,  24,	8,	char,	type[3]);\
+	MC_CMD_PARAM_OP(cmd, 1,  32,	8,	char,	type[4]);\
+	MC_CMD_PARAM_OP(cmd, 1,  40,	8,	char,	type[5]);\
+	MC_CMD_PARAM_OP(cmd, 1,  48,	8,	char,	type[6]);\
+	MC_CMD_PARAM_OP(cmd, 1,  56,	8,	char,	type[7]);\
+	MC_CMD_PARAM_OP(cmd, 2,  0,	8,	char,	type[8]);\
+	MC_CMD_PARAM_OP(cmd, 2,  8,	8,	char,	type[9]);\
+	MC_CMD_PARAM_OP(cmd, 2,  16,	8,	char,	type[10]);\
+	MC_CMD_PARAM_OP(cmd, 2,  24,	8,	char,	type[11]);\
+	MC_CMD_PARAM_OP(cmd, 2,  32,	8,	char,	type[12]);\
+	MC_CMD_PARAM_OP(cmd, 2,  40,	8,	char,	type[13]);\
+	MC_CMD_PARAM_OP(cmd, 2,  48,	8,	char,	type[14]);\
+	MC_CMD_PARAM_OP(cmd, 2,  56,	8,	char,	type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_RES_QUOTA(cmd, quota) \
+	MC_RSP_PARAM_OP(cmd, 0,	32,	16,	uint16_t,	quota)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPRC_CMD_ASSIGN(cmd, container_id, res_req) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32, int,      container_id); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	32, uint32_t, res_req->options);\
+	MC_CMD_PARAM_OP(cmd, 1,	0,	32, uint32_t, res_req->num); \
+	MC_CMD_PARAM_OP(cmd, 1,	32,	32, int,      res_req->id_base_align); \
+	MC_CMD_PARAM_OP(cmd, 2,	0,	8,  char,     res_req->type[0]);\
+	MC_CMD_PARAM_OP(cmd, 2,	8,	8,  char,     res_req->type[1]);\
+	MC_CMD_PARAM_OP(cmd, 2,	16,	8,  char,     res_req->type[2]);\
+	MC_CMD_PARAM_OP(cmd, 2,	24,	8,  char,     res_req->type[3]);\
+	MC_CMD_PARAM_OP(cmd, 2,	32,	8,  char,     res_req->type[4]);\
+	MC_CMD_PARAM_OP(cmd, 2,	40,	8,  char,     res_req->type[5]);\
+	MC_CMD_PARAM_OP(cmd, 2,	48,	8,  char,     res_req->type[6]);\
+	MC_CMD_PARAM_OP(cmd, 2,	56,	8,  char,     res_req->type[7]);\
+	MC_CMD_PARAM_OP(cmd, 3,	0,	8,  char,     res_req->type[8]);\
+	MC_CMD_PARAM_OP(cmd, 3,	8,	8,  char,     res_req->type[9]);\
+	MC_CMD_PARAM_OP(cmd, 3,	16,	8,  char,     res_req->type[10]);\
+	MC_CMD_PARAM_OP(cmd, 3,	24,	8,  char,     res_req->type[11]);\
+	MC_CMD_PARAM_OP(cmd, 3,	32,	8,  char,     res_req->type[12]);\
+	MC_CMD_PARAM_OP(cmd, 3,	40,	8,  char,     res_req->type[13]);\
+	MC_CMD_PARAM_OP(cmd, 3,	48,	8,  char,     res_req->type[14]);\
+	MC_CMD_PARAM_OP(cmd, 3,	56,	8,  char,     res_req->type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPRC_CMD_UNASSIGN(cmd, child_container_id, res_req) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32, int,     child_container_id); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	32, uint32_t, res_req->options);\
+	MC_CMD_PARAM_OP(cmd, 1,	0,	32, uint32_t, res_req->num); \
+	MC_CMD_PARAM_OP(cmd, 1,	32,	32, int,      res_req->id_base_align); \
+	MC_CMD_PARAM_OP(cmd, 2,	0,	8,  char,     res_req->type[0]);\
+	MC_CMD_PARAM_OP(cmd, 2,	8,	8,  char,     res_req->type[1]);\
+	MC_CMD_PARAM_OP(cmd, 2,	16,	8,  char,     res_req->type[2]);\
+	MC_CMD_PARAM_OP(cmd, 2,	24,	8,  char,     res_req->type[3]);\
+	MC_CMD_PARAM_OP(cmd, 2,	32,	8,  char,     res_req->type[4]);\
+	MC_CMD_PARAM_OP(cmd, 2,	40,	8,  char,     res_req->type[5]);\
+	MC_CMD_PARAM_OP(cmd, 2,	48,	8,  char,     res_req->type[6]);\
+	MC_CMD_PARAM_OP(cmd, 2,	56,	8,  char,     res_req->type[7]);\
+	MC_CMD_PARAM_OP(cmd, 3,	0,	8,  char,     res_req->type[8]);\
+	MC_CMD_PARAM_OP(cmd, 3,	8,	8,  char,     res_req->type[9]);\
+	MC_CMD_PARAM_OP(cmd, 3,	16,	8,  char,     res_req->type[10]);\
+	MC_CMD_PARAM_OP(cmd, 3,	24,	8,  char,     res_req->type[11]);\
+	MC_CMD_PARAM_OP(cmd, 3,	32,	8,  char,     res_req->type[12]);\
+	MC_CMD_PARAM_OP(cmd, 3,	40,	8,  char,     res_req->type[13]);\
+	MC_CMD_PARAM_OP(cmd, 3,	48,	8,  char,     res_req->type[14]);\
+	MC_CMD_PARAM_OP(cmd, 3,	56,	8,  char,     res_req->type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_OBJ_COUNT(cmd, obj_count) \
+	MC_RSP_PARAM_OP(cmd, 0,	32,	32,	int,	obj_count)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_OBJECT(cmd, obj_index) \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,	obj_index)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPRC_RSP_GET_OBJECT(cmd, obj_desc) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 0,	32,	32, int,      obj_desc->id); \
+	MC_RSP_PARAM_OP(cmd, 1,	0,	16, uint16_t, obj_desc->vendor); \
+	MC_RSP_PARAM_OP(cmd, 1,	16,	8,  uint8_t,  obj_desc->irq_count); \
+	MC_RSP_PARAM_OP(cmd, 1,	24,	8,  uint8_t,  obj_desc->region_count); \
+	MC_RSP_PARAM_OP(cmd, 1,	32,	32, uint32_t, obj_desc->state);\
+	MC_RSP_PARAM_OP(cmd, 2,	0,	32, uint32_t, obj_desc->ver_minor); \
+	MC_RSP_PARAM_OP(cmd, 2,	32,	32, uint32_t, obj_desc->ver_major); \
+	MC_RSP_PARAM_OP(cmd, 3,  0,	8,  char,     obj_desc->type[0]);\
+	MC_RSP_PARAM_OP(cmd, 3,  8,	8,  char,     obj_desc->type[1]);\
+	MC_RSP_PARAM_OP(cmd, 3,  16,	8,  char,     obj_desc->type[2]);\
+	MC_RSP_PARAM_OP(cmd, 3,  24,	8,  char,     obj_desc->type[3]);\
+	MC_RSP_PARAM_OP(cmd, 3,  32,	8,  char,     obj_desc->type[4]);\
+	MC_RSP_PARAM_OP(cmd, 3,  40,	8,  char,     obj_desc->type[5]);\
+	MC_RSP_PARAM_OP(cmd, 3,  48,	8,  char,     obj_desc->type[6]);\
+	MC_RSP_PARAM_OP(cmd, 3,  56,	8,  char,     obj_desc->type[7]);\
+	MC_RSP_PARAM_OP(cmd, 4,  0,	8,  char,     obj_desc->type[8]);\
+	MC_RSP_PARAM_OP(cmd, 4,  8,	8,  char,     obj_desc->type[9]);\
+	MC_RSP_PARAM_OP(cmd, 4,  16,	8,  char,     obj_desc->type[10]);\
+	MC_RSP_PARAM_OP(cmd, 4,  24,	8,  char,     obj_desc->type[11]);\
+	MC_RSP_PARAM_OP(cmd, 4,  32,	8,  char,     obj_desc->type[12]);\
+	MC_RSP_PARAM_OP(cmd, 4,  40,	8,  char,     obj_desc->type[13]);\
+	MC_RSP_PARAM_OP(cmd, 4,  48,	8,  char,     obj_desc->type[14]);\
+	MC_RSP_PARAM_OP(cmd, 4,  56,	8,  char,     obj_desc->type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_RES_COUNT(cmd, type) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 1,  0,	8,	char,		type[0]);\
+	MC_CMD_PARAM_OP(cmd, 1,  8,	8,	char,		type[1]);\
+	MC_CMD_PARAM_OP(cmd, 1,  16,	8,	char,		type[2]);\
+	MC_CMD_PARAM_OP(cmd, 1,  24,	8,	char,		type[3]);\
+	MC_CMD_PARAM_OP(cmd, 1,  32,	8,	char,		type[4]);\
+	MC_CMD_PARAM_OP(cmd, 1,  40,	8,	char,		type[5]);\
+	MC_CMD_PARAM_OP(cmd, 1,  48,	8,	char,		type[6]);\
+	MC_CMD_PARAM_OP(cmd, 1,  56,	8,	char,		type[7]);\
+	MC_CMD_PARAM_OP(cmd, 2,  0,	8,	char,		type[8]);\
+	MC_CMD_PARAM_OP(cmd, 2,  8,	8,	char,		type[9]);\
+	MC_CMD_PARAM_OP(cmd, 2,  16,	8,	char,		type[10]);\
+	MC_CMD_PARAM_OP(cmd, 2,  24,	8,	char,		type[11]);\
+	MC_CMD_PARAM_OP(cmd, 2,  32,	8,	char,		type[12]);\
+	MC_CMD_PARAM_OP(cmd, 2,  40,	8,	char,		type[13]);\
+	MC_CMD_PARAM_OP(cmd, 2,  48,	8,	char,		type[14]);\
+	MC_CMD_PARAM_OP(cmd, 2,  56,	8,	char,		type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_RES_COUNT(cmd, res_count) \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	32,	int,		res_count)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_RES_IDS(cmd, type, range_desc) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	42,	7,	enum dprc_iter_status,	\
+						      range_desc->iter_status);\
+	MC_CMD_PARAM_OP(cmd, 1,	0,	32,	int,  range_desc->base_id); \
+	MC_CMD_PARAM_OP(cmd, 1,	32,	32,	int,  range_desc->last_id);\
+	MC_CMD_PARAM_OP(cmd, 2,  0,	8,	char, type[0]);\
+	MC_CMD_PARAM_OP(cmd, 2,  8,	8,	char, type[1]);\
+	MC_CMD_PARAM_OP(cmd, 2,  16,	8,	char, type[2]);\
+	MC_CMD_PARAM_OP(cmd, 2,  24,	8,	char, type[3]);\
+	MC_CMD_PARAM_OP(cmd, 2,  32,	8,	char, type[4]);\
+	MC_CMD_PARAM_OP(cmd, 2,  40,	8,	char, type[5]);\
+	MC_CMD_PARAM_OP(cmd, 2,  48,	8,	char, type[6]);\
+	MC_CMD_PARAM_OP(cmd, 2,  56,	8,	char, type[7]);\
+	MC_CMD_PARAM_OP(cmd, 3,  0,	8,	char, type[8]);\
+	MC_CMD_PARAM_OP(cmd, 3,  8,	8,	char, type[9]);\
+	MC_CMD_PARAM_OP(cmd, 3,  16,	8,	char, type[10]);\
+	MC_CMD_PARAM_OP(cmd, 3,  24,	8,	char, type[11]);\
+	MC_CMD_PARAM_OP(cmd, 3,  32,	8,	char, type[12]);\
+	MC_CMD_PARAM_OP(cmd, 3,  40,	8,	char, type[13]);\
+	MC_CMD_PARAM_OP(cmd, 3,  48,	8,	char, type[14]);\
+	MC_CMD_PARAM_OP(cmd, 3,  56,	8,	char, type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_RES_IDS(cmd, range_desc) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 0,	42,	7,	enum dprc_iter_status,	\
+						     range_desc->iter_status);\
+	MC_RSP_PARAM_OP(cmd, 1,	0,	32,	int, range_desc->base_id); \
+	MC_RSP_PARAM_OP(cmd, 1,	32,	32,	int, range_desc->last_id);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_ATTRIBUTES(cmd, attr) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	32,	int,	  attr->container_id); \
+	MC_RSP_PARAM_OP(cmd, 0,	32,	16,	uint16_t, attr->icid); \
+	MC_RSP_PARAM_OP(cmd, 0,	48,	16,	uint16_t, attr->portal_id); \
+	MC_RSP_PARAM_OP(cmd, 1,	0,	32,	uint32_t, attr->options);\
+	MC_RSP_PARAM_OP(cmd, 2,  0,	32,	uint32_t, attr->version.major);\
+	MC_RSP_PARAM_OP(cmd, 2,  32,	32,	uint32_t, attr->version.minor);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_OBJ_REGION(cmd, obj_id, region_index, obj_type) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,		obj_id); \
+	MC_CMD_PARAM_OP(cmd, 0,	48,	8,	uint8_t,	region_index);\
+	MC_CMD_PARAM_OP(cmd, 3,  0,	8,	char,		obj_type[0]);\
+	MC_CMD_PARAM_OP(cmd, 3,  8,	8,	char,		obj_type[1]);\
+	MC_CMD_PARAM_OP(cmd, 3,  16,	8,	char,		obj_type[2]);\
+	MC_CMD_PARAM_OP(cmd, 3,  24,	8,	char,		obj_type[3]);\
+	MC_CMD_PARAM_OP(cmd, 3,  32,	8,	char,		obj_type[4]);\
+	MC_CMD_PARAM_OP(cmd, 3,  40,	8,	char,		obj_type[5]);\
+	MC_CMD_PARAM_OP(cmd, 3,  48,	8,	char,		obj_type[6]);\
+	MC_CMD_PARAM_OP(cmd, 3,  56,	8,	char,		obj_type[7]);\
+	MC_CMD_PARAM_OP(cmd, 4,  0,	8,	char,		obj_type[8]);\
+	MC_CMD_PARAM_OP(cmd, 4,  8,	8,	char,		obj_type[9]);\
+	MC_CMD_PARAM_OP(cmd, 4,  16,	8,	char,		obj_type[10]);\
+	MC_CMD_PARAM_OP(cmd, 4,  24,	8,	char,		obj_type[11]);\
+	MC_CMD_PARAM_OP(cmd, 4,  32,	8,	char,		obj_type[12]);\
+	MC_CMD_PARAM_OP(cmd, 4,  40,	8,	char,		obj_type[13]);\
+	MC_CMD_PARAM_OP(cmd, 4,  48,	8,	char,		obj_type[14]);\
+	MC_CMD_PARAM_OP(cmd, 4,  56,	8,	char,		obj_type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,		arg_name */
+#define DPRC_RSP_GET_OBJ_REGION(cmd, region_desc) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 1,	0,	64, uint64_t, region_desc->base_paddr);\
+	MC_RSP_PARAM_OP(cmd, 2,	0,	32, uint32_t, region_desc->size); \
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_SET_IRQ(cmd, irq_index, irq_val, irq_paddr, user_irq_id) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,    irq_index); \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	uint32_t,   irq_val); \
+	MC_CMD_PARAM_OP(cmd, 1,	0,	64,	uint64_t,   irq_paddr);\
+	MC_CMD_PARAM_OP(cmd, 2,  0,	32,	int,	    user_irq_id); \
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_IRQ(cmd, irq_index) \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,	irq_index)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_IRQ(cmd, irq_val, irq_paddr, user_irq_id, type) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	32,	uint32_t,   irq_val); \
+	MC_RSP_PARAM_OP(cmd, 1,	0,	64,	uint64_t,   irq_paddr);\
+	MC_RSP_PARAM_OP(cmd, 2,  0,	32,	int,	    user_irq_id); \
+	MC_RSP_PARAM_OP(cmd, 2,	32,	32,	int,	    type); \
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_SET_IRQ_ENABLE(cmd, enable_state, irq_index) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	8,	uint8_t,    enable_state); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,    irq_index);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_IRQ_ENABLE(cmd, irq_index) \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,	irq_index)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_IRQ_ENABLE(cmd, enable_state) \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	8,	uint8_t,	enable_state)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_SET_IRQ_MASK(cmd, mask, irq_index) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	uint32_t,	mask); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,	irq_index);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_IRQ_MASK(cmd, irq_index) \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,	irq_index)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_IRQ_MASK(cmd, mask) \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	32,	uint32_t,	mask)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_IRQ_STATUS(cmd, irq_index) \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,	irq_index)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_IRQ_STATUS(cmd, status) \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	32,	uint32_t,	status)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_CLEAR_IRQ_STATUS(cmd, status, irq_index) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	uint32_t,	status); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	8,	uint8_t,	irq_index);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_CONNECT(cmd, endpoint1, endpoint2) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32, int,    endpoint1->id); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	32, int,    endpoint1->interface_id); \
+	MC_CMD_PARAM_OP(cmd, 1,	0,	32, int,    endpoint2->id); \
+	MC_CMD_PARAM_OP(cmd, 1,	32,	32, int,    endpoint2->interface_id); \
+	MC_CMD_PARAM_OP(cmd, 2,	0,	8,  char,   endpoint1->type[0]); \
+	MC_CMD_PARAM_OP(cmd, 2,	8,	8,  char,   endpoint1->type[1]); \
+	MC_CMD_PARAM_OP(cmd, 2,	16,	8,  char,   endpoint1->type[2]); \
+	MC_CMD_PARAM_OP(cmd, 2,	24,	8,  char,   endpoint1->type[3]); \
+	MC_CMD_PARAM_OP(cmd, 2,	32,	8,  char,   endpoint1->type[4]); \
+	MC_CMD_PARAM_OP(cmd, 2,	40,	8,  char,   endpoint1->type[5]); \
+	MC_CMD_PARAM_OP(cmd, 2,	48,	8,  char,   endpoint1->type[6]); \
+	MC_CMD_PARAM_OP(cmd, 2,	56,	8,  char,   endpoint1->type[7]); \
+	MC_CMD_PARAM_OP(cmd, 3,	0,	8,  char,   endpoint1->type[8]); \
+	MC_CMD_PARAM_OP(cmd, 3,	8,	8,  char,   endpoint1->type[9]); \
+	MC_CMD_PARAM_OP(cmd, 3,	16,	8,  char,   endpoint1->type[10]); \
+	MC_CMD_PARAM_OP(cmd, 3,	24,	8,  char,   endpoint1->type[11]); \
+	MC_CMD_PARAM_OP(cmd, 3,	32,	8,  char,   endpoint1->type[12]); \
+	MC_CMD_PARAM_OP(cmd, 3,	40,	8,  char,   endpoint1->type[13]); \
+	MC_CMD_PARAM_OP(cmd, 3,	48,	8,  char,   endpoint1->type[14]); \
+	MC_CMD_PARAM_OP(cmd, 3,	56,	8,  char,   endpoint1->type[15]); \
+	MC_CMD_PARAM_OP(cmd, 5,	0,	8,  char,   endpoint2->type[0]); \
+	MC_CMD_PARAM_OP(cmd, 5,	8,	8,  char,   endpoint2->type[1]); \
+	MC_CMD_PARAM_OP(cmd, 5,	16,	8,  char,   endpoint2->type[2]); \
+	MC_CMD_PARAM_OP(cmd, 5,	24,	8,  char,   endpoint2->type[3]); \
+	MC_CMD_PARAM_OP(cmd, 5,	32,	8,  char,   endpoint2->type[4]); \
+	MC_CMD_PARAM_OP(cmd, 5,	40,	8,  char,   endpoint2->type[5]); \
+	MC_CMD_PARAM_OP(cmd, 5,	48,	8,  char,   endpoint2->type[6]); \
+	MC_CMD_PARAM_OP(cmd, 5,	56,	8,  char,   endpoint2->type[7]); \
+	MC_CMD_PARAM_OP(cmd, 6,	0,	8,  char,   endpoint2->type[8]); \
+	MC_CMD_PARAM_OP(cmd, 6,	8,	8,  char,   endpoint2->type[9]); \
+	MC_CMD_PARAM_OP(cmd, 6,	16,	8,  char,   endpoint2->type[10]); \
+	MC_CMD_PARAM_OP(cmd, 6,	24,	8,  char,   endpoint2->type[11]); \
+	MC_CMD_PARAM_OP(cmd, 6,	32,	8,  char,   endpoint2->type[12]); \
+	MC_CMD_PARAM_OP(cmd, 6,	40,	8,  char,   endpoint2->type[13]); \
+	MC_CMD_PARAM_OP(cmd, 6,	48,	8,  char,   endpoint2->type[14]); \
+	MC_CMD_PARAM_OP(cmd, 6,	56,	8,  char,   endpoint2->type[15]); \
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_DISCONNECT(cmd, endpoint) \
+do { \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,  endpoint->id); \
+	MC_CMD_PARAM_OP(cmd, 0,	32,	32,	int,  endpoint->interface_id); \
+	MC_CMD_PARAM_OP(cmd, 1,	0,	8,	char, endpoint->type[0]); \
+	MC_CMD_PARAM_OP(cmd, 1,	8,	8,	char, endpoint->type[1]); \
+	MC_CMD_PARAM_OP(cmd, 1,	16,	8,	char, endpoint->type[2]); \
+	MC_CMD_PARAM_OP(cmd, 1,	24,	8,	char, endpoint->type[3]); \
+	MC_CMD_PARAM_OP(cmd, 1,	32,	8,	char, endpoint->type[4]); \
+	MC_CMD_PARAM_OP(cmd, 1,	40,	8,	char, endpoint->type[5]); \
+	MC_CMD_PARAM_OP(cmd, 1,	48,	8,	char, endpoint->type[6]); \
+	MC_CMD_PARAM_OP(cmd, 1,	56,	8,	char, endpoint->type[7]); \
+	MC_CMD_PARAM_OP(cmd, 2,	0,	8,	char, endpoint->type[8]); \
+	MC_CMD_PARAM_OP(cmd, 2,	8,	8,	char, endpoint->type[9]); \
+	MC_CMD_PARAM_OP(cmd, 2,	16,	8,	char, endpoint->type[10]); \
+	MC_CMD_PARAM_OP(cmd, 2,	24,	8,	char, endpoint->type[11]); \
+	MC_CMD_PARAM_OP(cmd, 2,	32,	8,	char, endpoint->type[12]); \
+	MC_CMD_PARAM_OP(cmd, 2,	40,	8,	char, endpoint->type[13]); \
+	MC_CMD_PARAM_OP(cmd, 2,	48,	8,	char, endpoint->type[14]); \
+	MC_CMD_PARAM_OP(cmd, 2,	56,	8,	char, endpoint->type[15]); \
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_POOL(cmd, pool_index) \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,	pool_index)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_POOL(cmd, type) \
+do { \
+	MC_RSP_PARAM_OP(cmd, 1,	0,	8,	char,		type[0]);\
+	MC_RSP_PARAM_OP(cmd, 1,	8,	8,	char,		type[1]);\
+	MC_RSP_PARAM_OP(cmd, 1,	16,	8,	char,		type[2]);\
+	MC_RSP_PARAM_OP(cmd, 1,	24,	8,	char,		type[3]);\
+	MC_RSP_PARAM_OP(cmd, 1,	32,	8,	char,		type[4]);\
+	MC_RSP_PARAM_OP(cmd, 1,	40,	8,	char,		type[5]);\
+	MC_RSP_PARAM_OP(cmd, 1,	48,	8,	char,		type[6]);\
+	MC_RSP_PARAM_OP(cmd, 1,	56,	8,	char,		type[7]);\
+	MC_RSP_PARAM_OP(cmd, 2,	0,	8,	char,		type[8]);\
+	MC_RSP_PARAM_OP(cmd, 2,	8,	8,	char,		type[9]);\
+	MC_RSP_PARAM_OP(cmd, 2,	16,	8,	char,		type[10]);\
+	MC_RSP_PARAM_OP(cmd, 2,	24,	8,	char,		type[11]);\
+	MC_RSP_PARAM_OP(cmd, 2,	32,	8,	char,		type[12]);\
+	MC_RSP_PARAM_OP(cmd, 2,	40,	8,	char,		type[13]);\
+	MC_RSP_PARAM_OP(cmd, 2,	48,	8,	char,		type[14]);\
+	MC_RSP_PARAM_OP(cmd, 2,	56,	8,	char,		type[15]);\
+} while (0)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_POOL_COUNT(cmd, pool_count) \
+	MC_RSP_PARAM_OP(cmd, 0,	0,	32,	int,		pool_count)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_CMD_GET_PORTAL_PADDR(cmd, portal_id) \
+	MC_CMD_PARAM_OP(cmd, 0,	0,	32,	int,	portal_id)
+
+/*	param, offset, width,	type,			arg_name */
+#define DPRC_RSP_GET_PORTAL_PADDR(cmd, portal_addr) \
+	MC_RSP_PARAM_OP(cmd, 1,	0,	64,	uint64_t,	portal_addr)
+
+#endif /* _FSL_DPRC_CMD_H */
diff --git a/drivers/bus/fsl-mc/dprc.c b/drivers/bus/fsl-mc/dprc.c
new file mode 100644
index 0000000..77315fe
--- /dev/null
+++ b/drivers/bus/fsl-mc/dprc.c
@@ -0,0 +1,521 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/fsl/mc-sys.h>
+#include <linux/fsl/mc-cmd.h>
+#include <linux/fsl/dprc.h>
+#include "dprc-cmd.h"
+
+int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_CONT_ID,
+					  DPRC_CMDSZ_GET_CONT_ID,
+					  MC_CMD_PRI_LOW, 0);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_CONTAINER_ID(cmd, *container_id);
+	return 0;
+}
+
+int dprc_open(struct fsl_mc_io *mc_io, int container_id, uint16_t *dprc_handle)
+{
+	int err;
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(MC_DPRC_CMDID_OPEN,
+					  MC_CMD_OPEN_SIZE, MC_CMD_PRI_LOW, 0);
+
+	DPRC_CMD_OPEN(cmd, container_id);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	*dprc_handle = MC_CMD_HDR_READ_AUTHID(cmd.header);
+	return 0;
+}
+
+int dprc_close(struct fsl_mc_io *mc_io, uint16_t dprc_handle)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(MC_CMDID_CLOSE,
+					  MC_CMD_CLOSE_SIZE,
+					  MC_CMD_PRI_HIGH, dprc_handle);
+
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_create_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  struct dprc_cfg *cfg,
+			  int *child_container_id,
+			  uint64_t *child_portal_paddr)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_CREATE_CONT,
+					  DPRC_CMDSZ_CREATE_CONT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_CREATE_CONTAINER(cmd, cfg);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_CREATE_CONTAINER(cmd, *child_container_id,
+				  *child_portal_paddr);
+
+	return 0;
+}
+
+int dprc_destroy_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			   int child_container_id)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_DESTROY_CONT,
+					  DPRC_CMDSZ_DESTROY_CONT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_DESTROY_CONTAINER(cmd, child_container_id);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_reset_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			 int child_container_id)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_RESET_CONT,
+					  DPRC_CMDSZ_RESET_CONT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_RESET_CONTAINER(cmd, child_container_id);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_set_res_quota(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int child_container_id, char *type, uint16_t quota)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_SET_RES_QUOTA,
+					  DPRC_CMDSZ_SET_RES_QUOTA,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_SET_RES_QUOTA(cmd, child_container_id, type, quota);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_get_res_quota(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int child_container_id, char *type, uint16_t *quota)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_RES_QUOTA,
+					  DPRC_CMDSZ_GET_RES_QUOTA,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_RES_QUOTA(cmd, child_container_id, type);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_RES_QUOTA(cmd, *quota);
+	return 0;
+}
+
+int dprc_assign(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		int container_id, struct dprc_res_req *res_req)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_ASSIGN,
+					  DPRC_CMDSZ_ASSIGN,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_ASSIGN(cmd, container_id, res_req);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_unassign(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		  int child_container_id, struct dprc_res_req *res_req)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_UNASSIGN,
+					  DPRC_CMDSZ_UNASSIGN,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_UNASSIGN(cmd, child_container_id, res_req);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_get_obj_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int *obj_count)
+{
+	int err;
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_OBJ_COUNT,
+					  DPRC_CMDSZ_GET_OBJ_COUNT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_OBJ_COUNT(cmd, *obj_count);
+	return 0;
+}
+
+int dprc_get_obj(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 int obj_index, struct dprc_obj_desc *obj_desc)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_OBJECT,
+					  DPRC_CMDSZ_GET_OBJECT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_OBJECT(cmd, obj_index);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_OBJECT(cmd, obj_desc);
+	return 0;
+}
+
+int dprc_get_res_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       char *type, int *res_count)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	*res_count = 0;
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_RES_COUNT,
+					  DPRC_CMDSZ_GET_RES_COUNT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_RES_COUNT(cmd, type);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_RES_COUNT(cmd, *res_count);
+	return 0;
+}
+
+int dprc_get_res_ids(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		     char *type, struct dprc_res_ids_range_desc *range_desc)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_RES_IDS,
+					  DPRC_CMDSZ_GET_RES_IDS,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_RES_IDS(cmd, type, range_desc);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_RES_IDS(cmd, range_desc);
+	return 0;
+}
+
+int dprc_get_attributes(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			struct dprc_attributes *attr)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_ATTR,
+					  DPRC_CMDSZ_GET_ATTR,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_ATTRIBUTES(cmd, attr);
+	return 0;
+}
+
+int dprc_get_obj_region(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			char *obj_type,
+			int obj_id,
+			uint8_t region_index,
+			struct dprc_region_desc *region_desc)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_OBJ_REG,
+					  DPRC_CMDSZ_GET_OBJ_REG,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_OBJ_REGION(cmd, obj_id, region_index, obj_type);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_OBJ_REGION(cmd, region_desc);
+	return 0;
+}
+
+int dprc_get_irq(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 uint8_t irq_index,
+		 int *type,
+		 uint64_t *irq_paddr, uint32_t *irq_val, int *user_irq_id)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_IRQ,
+					  DPRC_CMDSZ_GET_IRQ,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_IRQ(cmd, irq_index);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_IRQ(cmd, *irq_val, *irq_paddr, *user_irq_id, *type);
+	return 0;
+}
+
+int dprc_set_irq(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 uint8_t irq_index,
+		 uint64_t irq_paddr, uint32_t irq_val, int user_irq_id)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_SET_IRQ,
+					  DPRC_CMDSZ_SET_IRQ,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_SET_IRQ(cmd, irq_index, irq_val, irq_paddr, user_irq_id);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_get_irq_enable(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint8_t *enable_state)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_IRQ_ENABLE,
+					  DPRC_CMDSZ_GET_IRQ_ENABLE,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_IRQ_ENABLE(cmd, irq_index);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_IRQ_ENABLE(cmd, *enable_state);
+	return 0;
+}
+
+int dprc_set_irq_enable(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint8_t enable_state)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_SET_IRQ_ENABLE,
+					  DPRC_CMDSZ_SET_IRQ_ENABLE,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_SET_IRQ_ENABLE(cmd, enable_state, irq_index);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_get_irq_mask(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		      uint8_t irq_index, uint32_t *mask)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_IRQ_MASK,
+					  DPRC_CMDSZ_GET_IRQ_MASK,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_IRQ_MASK(cmd, irq_index);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_IRQ_MASK(cmd, *mask);
+	return 0;
+}
+
+int dprc_set_irq_mask(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		      uint8_t irq_index, uint32_t mask)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_SET_IRQ_MASK,
+					  DPRC_CMDSZ_SET_IRQ_MASK,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_SET_IRQ_MASK(cmd, mask, irq_index);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_get_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint32_t *status)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_IRQ_STATUS,
+					  DPRC_CMDSZ_GET_IRQ_STATUS,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_IRQ_STATUS(cmd, irq_index);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_IRQ_STATUS(cmd, *status);
+	return 0;
+}
+
+int dprc_clear_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  uint8_t irq_index, uint32_t status)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_CLEAR_IRQ_STATUS,
+					  DPRC_CMDSZ_CLEAR_IRQ_STATUS,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_CLEAR_IRQ_STATUS(cmd, status, irq_index);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_get_pool_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			int *pool_count)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_POOL_COUNT,
+					  DPRC_CMDSZ_GET_POOL_COUNT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_POOL_COUNT(cmd, *pool_count);
+	return 0;
+}
+
+int dprc_get_pool(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		  int pool_index, char *type)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_POOL,
+					  DPRC_CMDSZ_GET_POOL,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_POOL(cmd, pool_index);
+
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_POOL(cmd, type);
+	return 0;
+}
+
+int dprc_get_portal_paddr(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  int portal_id, uint64_t *portal_addr)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_PORTAL_PADDR,
+					  DPRC_CMDSZ_GET_PORTAL_PADDR,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_PORTAL_PADDR(cmd, portal_id);
+	err = mc_send_command(mc_io, &cmd);
+	if (err)
+		return err;
+
+	DPRC_RSP_GET_PORTAL_PADDR(cmd, *portal_addr);
+	return 0;
+}
+
+int dprc_connect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 struct dprc_endpoint *endpoint1,
+		 struct dprc_endpoint *endpoint2)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_CONNECT,
+					  DPRC_CMDSZ_CONNECT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_CONNECT(cmd, endpoint1, endpoint2);
+	return mc_send_command(mc_io, &cmd);
+}
+
+int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		    struct dprc_endpoint *endpoint)
+{
+	struct mc_command cmd = { 0 };
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_DISCONNECT,
+					  DPRC_CMDSZ_DISCONNECT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_DISCONNECT(cmd, endpoint);
+	return mc_send_command(mc_io, &cmd);
+}
diff --git a/drivers/bus/fsl-mc/mc-sys.c b/drivers/bus/fsl-mc/mc-sys.c
new file mode 100644
index 0000000..a598bbe
--- /dev/null
+++ b/drivers/bus/fsl-mc/mc-sys.c
@@ -0,0 +1,189 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/fsl/mc-sys.h>
+#include <linux/fsl/mc-cmd.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/ioport.h>
+#include <linux/device.h>
+
+/**
+ * Timeout in jiffies to wait for the completion of an MC command
+ */
+#define MC_CMD_COMPLETION_TIMEOUT_JIFFIES   (HZ / 2)	/* 500 ms */
+
+/*
+ * usleep_range() min and max values used to throttle down polling
+ * iterations while waiting for MC command completion
+ */
+#define MC_CMD_COMPLETION_POLLING_MIN_SLEEP_USECS    10
+#define MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS    500
+
+/**
+ * Creates an MC I/O object
+ *
+ * @dev: device to be associated with the MC I/O object
+ * @mc_portal_phys_addr: physical address of the MC portal to use
+ * @mc_portal_size: size in bytes of the MC portal
+ * @flags: flags for the new MC I/O object
+ * @new_mc_io: Area to return pointer to newly created MC I/O object
+ *
+ * Returns '0' on Success; Error code otherwise.
+ */
+int __must_check fsl_create_mc_io(struct device *dev,
+				  phys_addr_t mc_portal_phys_addr,
+				  uint32_t mc_portal_size,
+				  uint32_t flags, struct fsl_mc_io **new_mc_io)
+{
+	struct fsl_mc_io *mc_io;
+	void __iomem *mc_portal_virt_addr;
+	struct resource *res;
+
+	mc_io = devm_kzalloc(dev, sizeof(*mc_io), GFP_KERNEL);
+	if (mc_io == NULL)
+		return -ENOMEM;
+
+	mc_io->dev = dev;
+	mc_io->flags = flags;
+	mc_io->portal_phys_addr = mc_portal_phys_addr;
+	mc_io->portal_size = mc_portal_size;
+	res = devm_request_mem_region(dev,
+				      mc_portal_phys_addr,
+				      mc_portal_size,
+				      "mc_portal");
+	if (res == NULL) {
+		dev_err(dev,
+			"devm_request_mem_region failed for MC portal %#llx\n",
+			mc_portal_phys_addr);
+		return -EBUSY;
+	}
+
+	mc_portal_virt_addr = devm_ioremap_nocache(dev,
+						   mc_portal_phys_addr,
+						   mc_portal_size);
+	if (mc_portal_virt_addr == NULL) {
+		dev_err(dev,
+			"devm_ioremap_nocache failed for MC portal %#llx\n",
+			mc_portal_phys_addr);
+		return -ENXIO;
+	}
+
+	mc_io->portal_virt_addr = mc_portal_virt_addr;
+	*new_mc_io = mc_io;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(fsl_create_mc_io);
+
+/**
+ * Destroys an MC I/O object
+ *
+ * @mc_io: MC I/O object to destroy
+ */
+void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
+{
+	devm_iounmap(mc_io->dev, mc_io->portal_virt_addr);
+	devm_release_mem_region(mc_io->dev,
+				mc_io->portal_phys_addr,
+				mc_io->portal_size);
+
+	mc_io->portal_virt_addr = NULL;
+	devm_kfree(mc_io->dev, mc_io);
+}
+EXPORT_SYMBOL_GPL(fsl_destroy_mc_io);
+
+static int mc_status_to_error(enum mc_cmd_status status)
+{
+	static const int mc_status_to_error_map[] = {
+		[MC_CMD_STATUS_OK] = 0,
+		[MC_CMD_STATUS_AUTH_ERR] = -EACCES,
+		[MC_CMD_STATUS_NO_PRIVILEGE] = -EPERM,
+		[MC_CMD_STATUS_DMA_ERR] = -EIO,
+		[MC_CMD_STATUS_CONFIG_ERR] = -ENXIO,
+		[MC_CMD_STATUS_TIMEOUT] = -ETIMEDOUT,
+		[MC_CMD_STATUS_NO_RESOURCE] = -ENAVAIL,
+		[MC_CMD_STATUS_NO_MEMORY] = -ENOMEM,
+		[MC_CMD_STATUS_BUSY] = -EBUSY,
+		[MC_CMD_STATUS_UNSUPPORTED_OP] = -ENOTSUPP,
+		[MC_CMD_STATUS_INVALID_STATE] = -ENODEV,
+	};
+
+	if (WARN_ON(status >= ARRAY_SIZE(mc_status_to_error_map)))
+		return -EINVAL;
+
+	return mc_status_to_error_map[status];
+}
+
+/**
+ * Sends an command to the MC device using the given MC I/O object
+ *
+ * @mc_io: MC I/O object to be used
+ * @cmd: command to be sent
+ *
+ * Returns '0' on Success; Error code otherwise.
+ *
+ * NOTE: This function cannot be invoked from from atomic contexts.
+ */
+int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
+{
+	enum mc_cmd_status status;
+	unsigned long irqsave_flags = 0;
+	unsigned long jiffies_until_timeout =
+	    jiffies + MC_CMD_COMPLETION_TIMEOUT_JIFFIES;
+
+	/*
+	 * Send command to the MC hardware:
+	 */
+	mc_write_command(mc_io->portal_virt_addr, cmd);
+
+	/*
+	 * Wait for response from the MC hardware:
+	 */
+	for (;;) {
+		status = mc_read_response(mc_io->portal_virt_addr, cmd);
+		if (status != MC_CMD_STATUS_READY)
+			break;
+
+		/*
+		 * TODO: When MC command completion interrupts are supported
+		 * call wait function here instead of usleep_range()
+		 */
+		usleep_range(MC_CMD_COMPLETION_POLLING_MIN_SLEEP_USECS,
+			     MC_CMD_COMPLETION_POLLING_MAX_SLEEP_USECS);
+
+		if (time_after_eq(jiffies, jiffies_until_timeout))
+			return -ETIMEDOUT;
+	}
+
+	return mc_status_to_error(status);
+}
+EXPORT_SYMBOL(mc_send_command);
diff --git a/include/linux/fsl/dpmng.h b/include/linux/fsl/dpmng.h
new file mode 100644
index 0000000..3b5d81b
--- /dev/null
+++ b/include/linux/fsl/dpmng.h
@@ -0,0 +1,121 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/*
+ *  dpmng.h
+ *  Management Complex General API
+ */
+
+#ifndef __FSL_DPMNG_H
+#define __FSL_DPMNG_H
+
+/*
+ * grp_dpmng	Management Complex General API
+ *
+ * Contains general API for the Management Complex firmware
+ *
+ */
+
+struct fsl_mc_io;
+
+/*
+ * Management Complex firmware version information
+ */
+#define MC_VER_MAJOR 2
+#define MC_VER_MINOR 0
+
+struct mc_version {
+	uint32_t major;
+	/*
+	 * Major version number: incremented on API compatibility changes
+	 */
+	uint32_t minor;
+	/*
+	 * Minor version number: incremented on API additions (backward
+	 * compatible); reset when major version is incremented.
+	 */
+	uint32_t revision;
+	/*
+	 * Internal revision number: incremented on implementation changes
+	 * and/or bug fixes that have no impact on API
+	 */
+};
+
+/*
+ * Retrieves the Management Complex firmware version information
+ *
+ * mc_io - Pointer to opaque I/O object
+ * mc_ver_info - Pointer to version information structure
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info);
+
+/*
+ * Resets an AIOP tile
+ *
+ * mc_io - Pointer to opaque I/O object
+ * aiop_tile_id - AIOP tile ID to reset
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpmng_reset_aiop(struct fsl_mc_io *mc_io, int aiop_tile_id);
+
+/*
+ * Loads an image to AIOP tile
+ *
+ * mc_io - Pointer to opaque I/O object
+ * aiop_tile_id - AIOP tile ID
+ * img_dma_addr - DMA address (bus address) for the AIOP ELF image in memory
+ * img_size - Size in bytes of AIOP ELF image in memory
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpmng_load_aiop(struct fsl_mc_io *mc_io,
+		    int aiop_tile_id, dma_addr_t img_dma_addr, int img_size);
+
+/*
+ * Starts AIOP tile execution
+ *
+ * mc_io - Pointer to opaque I/O object
+ * aiop_tile_id - AIOP tile ID to run
+ * cores_mask - Mask of AIOP cores to run (core 0 in msb)
+ * options - Execution options (currently none defined)
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dpmng_run_aiop(struct fsl_mc_io *mc_io,
+		   int aiop_tile_id, uint32_t cores_mask, uint64_t options);
+
+/* */
+
+#endif /* __FSL_DPMNG_H */
diff --git a/include/linux/fsl/dprc.h b/include/linux/fsl/dprc.h
new file mode 100644
index 0000000..02ad590
--- /dev/null
+++ b/include/linux/fsl/dprc.h
@@ -0,0 +1,791 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/*
+ *  dprc.h
+ *  Data Path Resource Container API
+ */
+
+#ifndef _FSL_DPRC_H
+#define _FSL_DPRC_H
+
+/*
+ * grp_dprc	Data Path Resource Container API
+ *
+ * Contains DPRC API for managing and querying LDPAA resources
+ *
+ */
+
+struct fsl_mc_io;
+
+/*
+ * Set this value as the icid value in dprc_cfg structure when creating a
+ * container, in case the ICID is not selected by the user and should be
+ * allocated by the DPRC from the pool of ICIDs.
+ */
+#define DPRC_GET_ICID_FROM_POOL			(uint16_t)(~(0))
+/*
+ * Set this value as the portal_id value in dprc_cfg structure when creating a
+ * container, in case the portal id is not specifically selected by the
+ * user and should be allocated by the DPRC from the pool of portal ids.
+ */
+#define DPRC_GET_PORTAL_ID_FROM_POOL	(int)(~(0))
+
+/*
+ * Resource request options
+ */
+#define DPRC_RES_REQ_OPT_EXPLICIT		0x00000001
+/* Explicit resource id request - The requested objects/resources
+ * are explicit and sequential (in case of resources).
+ * The base ID is given at res_req at base_align field */
+#define DPRC_RES_REQ_OPT_ALIGNED		0x00000002
+/* Aligned resources request - Relevant only for resources
+ * request (and not objects). Indicates that resources base id should be
+ * sequential and aligned to the value given at dprc_res_req base_align field*/
+#define DPRC_RES_REQ_OPT_PLUGGED		0x00000004
+/* Plugged Flag - Relevant only for object assignment request.
+ * Indicates that after all objects assigned. An interrupt will be invoked at
+ * the relevant GPP. The assigned object will be marked as plugged.
+ * plugged objects can't be assigned from their container */
+/* */
+
+/*
+ * Container general options
+ *
+ * These options may be selected at container creation by the container creator
+ * and can be retrieved using dprc_get_attributes()
+ */
+#define DPRC_CFG_OPT_SPAWN_ALLOWED		0x00000001
+/* Spawn Policy Option allowed - Indicates that the new container is allowed
+ * to spawn and have its own child containers. */
+#define DPRC_CFG_OPT_ALLOC_ALLOWED		0x00000002
+/* General Container allocation policy - Indicates that the new container is
+ * allowed to allocate requested resources from its parent container; if not
+ * set, the container is only allowed to use resources in its own pools; Note
+ * that this is a container's global policy, but the parent container may
+ * override it and set specific quota per resource type. */
+#define DPRC_CFG_OPT_OBJ_CREATE_ALLOWED	0x00000004
+/* Object initialization allowed - software context associated with this
+ * container is allowed to invoke object initialization operations. */
+#define DPRC_CFG_OPT_TOPOLOGY_CHANGES_ALLOWED	0x00000008
+/* Topology change allowed - software context associated with this
+ * container is allowed to invoke topology operations, such as attach/detach
+ * of network objects. */
+#define DPRC_CFG_OPT_IOMMU_BYPASS		0x00000010
+/*IOMMU bypass - indicates whether objects of this container are permitted
+ * to bypass the IOMMU.  */
+#define DPRC_CFG_OPT_AIOP			0x00000020
+/*AIOP -Indicates that container belongs to aiop.  */
+/* */
+
+/*
+ * Objects Attributes Flags
+ */
+#define DPRC_OBJ_STATE_OPEN		0x00000001
+/* Opened state - Indicates that an object is open by at least one owner */
+#define DPRC_OBJ_STATE_PLUGGED		0x00000002
+/* Plugged state - Indicates that the object is plugged */
+/* */
+
+/*
+ * Irq
+ */
+#define DPRC_NUM_OF_IRQS		1
+/* Number of dprc's IRQs */
+/* */
+
+/*
+ * Object irq events
+ */
+#define DPRC_IRQ_EVENT_OBJ_ASSIGNED			0x00000001
+/* Irq event - Indicates that a new object assigned to the container */
+#define DPRC_IRQ_EVENT_OBJ_UNASSIGNED		0x00000002
+/* Irq event - Indicates that an object was unassigned from the container */
+#define DPRC_IRQ_EVENT_RES_ASSIGNED			0x00000004
+/* Irq event - Indicates that resources assigned to the container */
+#define DPRC_IRQ_EVENT_RES_UNASSIGNED		0x00000008
+/* Irq event - Indicates that resources unassigned from the container */
+#define DPRC_IRQ_EVENT_CONTAINER_DESTROYED	0x00000010
+/* Irq event - Indicates that one of the descendant containers that opened by
+ * this container is destroyed */
+#define DPRC_IRQ_EVENT_OBJ_DESTROYED		0x00000011
+/* Irq event - Indicates that on one of the container's opened object is
+ destroyed */
+/* */
+
+/*
+ * Resource request descriptor, to be used in assignment or
+ *		un-assignment of resources and objects.
+ */
+struct dprc_res_req {
+	char type[16];
+	/*
+	 * Resource/object type: Represent as a NULL terminated string.
+	 * This string may received by using dprc_get_pool() to get resource
+	 * type and dprc_get_obj() to get object type.
+	 * Note: it is not possible to assign/unassign DP_OBJ_DPRC objects
+	 */
+	uint32_t num;
+	/* Number of resources */
+	uint32_t options;
+	/* Request options: combination of DPRC_RES_REQ_OPT_ options */
+	int id_base_align;
+	/*
+	 * In case of explicit assignment (DPRC_RES_REQ_OPT_EXPLICIT is set at
+	 * option), this field represents the required base ID for resource
+	 * allocation;
+	 * In case of aligned assignment (DPRC_RES_REQ_OPT_ALIGNED is set at
+	 * option), this field indicates the required alignment for the
+	 * resource ID(s) - use 0 if there is no alignment or explicit id
+	 * requirements.
+	 */
+};
+
+/*
+ * Object descriptor, returned from dprc_get_obj()
+ */
+struct dprc_obj_desc {
+	uint16_t vendor;
+	/* Object vendor identifier */
+	char type[16];
+	/* Type of object: NULL terminated string */
+	int id;
+	/* ID of logical object resource */
+	uint32_t ver_major;
+	/* Major version number */
+	uint32_t ver_minor;
+	/* Minor version number */
+	uint8_t irq_count;
+	/* Number of interrupts supported by the object */
+	uint8_t region_count;
+	/* Number of mappable regions supported by the object */
+	uint32_t state;
+	/* Object state: combination of DPRC_OBJ_STATE_ states */
+};
+
+/*
+ * Mappable region descriptor, returned by dprc_get_obj_region()
+ */
+struct dprc_region_desc {
+	uint64_t base_paddr;
+	/* Region base physical address */
+	uint32_t size;
+	/* Region size (in bytes) */
+};
+
+/*
+ * Iteration status, for use with dprc_get_res_ids() function
+ *
+ */
+enum dprc_iter_status {
+	DPRC_ITER_STATUS_FIRST = 0,
+	/* Perform first iteration */
+	DPRC_ITER_STATUS_MORE = 1,
+	/* Indicates more/next iteration is needed */
+	DPRC_ITER_STATUS_LAST = 2
+	    /* Indicates last iteration */
+};
+
+/*
+ * Resource Id range descriptor, Used at dprc_get_res_ids() and
+ *		contains one range details.
+ */
+struct dprc_res_ids_range_desc {
+	int base_id;
+	/* Base resource ID of this range */
+	int last_id;
+	/* Last resource ID of this range */
+	enum dprc_iter_status iter_status;
+	/*
+	 * Iteration status - should be set to DPRC_ITER_STATUS_FIRST at
+	 * first iteration; while the returned marker is DPRC_ITER_STATUS_MORE,
+	 * additional iterations are needed, until the returned marker is
+	 * DPRC_ITER_STATUS_LAST
+	 */
+};
+
+/*
+ * Container attributes, returned by dprc_get_attributes()
+ */
+struct dprc_attributes {
+	int container_id;
+	/* Container's ID */
+	uint16_t icid;
+	/* Container's ICID */
+	int portal_id;
+	/* Container's portal ID */
+	uint64_t options;
+	/* Container's options as set at container's creation */
+	struct {
+		uint32_t major;	/* DPRC major version */
+		uint32_t minor;	/* DPRC minor version */
+	} version;
+	/* DPRC version */
+};
+
+/*
+ * Container configuration options, used in dprc_create_container()
+ */
+struct dprc_cfg {
+	uint16_t icid;
+	/* Container's ICID; if set to DPRC_GET_ICID_FROM_POOL, a free ICID
+	 * will be allocated by the DPRC */
+	int portal_id;
+	/* portal id; if set to DPRC_GET_PORTAL_ID_FROM_POOL, a free portal id
+	 * will be allocated by the DPRC */
+	uint64_t options;
+	/* Combination of DPRC_CFG_OPT_ options */
+};
+
+/*
+ * Endpoint description for link connect/disconnect operations
+ */
+struct dprc_endpoint {
+	char type[16];
+	/* Endpoint object type: NULL terminated string */
+	int id;
+	/* Endpoint object id */
+	int interface_id;
+	/*
+	 * Interface id; should be set for endpoints with multiple interfaces
+	 * (DP_OBJ_DPSW, DP_OBJ_DPDMUX); for others, always set to 0.
+	 */
+};
+
+/*
+ * Obtains the container id associated with a given portal.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * container_id	Requested container ID
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id);
+
+/*
+ * Opens a DPRC object for use
+ *
+ * mc_io		Pointer to opaque I/O object
+ * container_id	Container ID to open
+ * dprc_handle	Handle to the DPRC object
+ *
+ * returns	'0' on Success; Error code otherwise.
+ *
+ * Required before any operation on the object.
+ */
+int dprc_open(struct fsl_mc_io *mc_io, int container_id,
+	      uint16_t *dprc_handle);
+
+/*
+ * Closes the DPRC object handle
+ *
+ * No further operations on the object are allowed after this call without
+ * re-opening the object.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_close(struct fsl_mc_io *mc_io, uint16_t dprc_handle);
+
+/*
+ * Creates a child container
+ *
+ * mc_io			Pointer to opaque I/O object
+ * dprc_handle		Handle to the DPRC object
+ * cfg			Child container configuration
+ * child_container_id	Child container ID
+ * child_portal_paddr	Base physical address of the
+ *				child portal
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_create_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  struct dprc_cfg *cfg,
+			  int *child_container_id,
+			  uint64_t *child_portal_paddr);
+
+/*
+ * Destroys a child container.
+ *
+ * This function terminates the child container, so following this call the
+ * child container ID becomes invalid.
+ *
+ * Notes:
+ * - All resources and objects of the destroyed container are returned to the
+ * parent container or destroyed if were created be the destroyed container.
+ * - This function destroy all the child containers of the specified
+ *   container prior to destroying the container itself.
+ *
+ * mc_io			Pointer to opaque I/O object
+ * dprc_handle		Handle to the DPRC object
+ * child_container_id	ID of the container to destroy
+ *
+ * returns	'0' on Success; Error code otherwise.
+ *
+ * Only the parent container is allowed to destroy a child policy
+ *		Container 0 can't be destroyed
+ */
+int dprc_destroy_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			   int child_container_id);
+
+/*
+ * Sets allocation policy for a specific resource/object type in a
+ * child container
+ *
+ * Allocation policy determines whether or not a container may allocate
+ * resources from its parent. Each container has a 'global' allocation policy
+ * that is set when the container is created.
+ *
+ * This function sets allocation policy for a specific resource type.
+ * The default policy for all resource types matches the container's 'global'
+ * allocation policy.
+ *
+ * mc_io		    Pointer to opaque I/O object
+ * dprc_handle	    Handle to the DPRC object
+ * child_container_id  ID of the child container
+ * type		    resource/object type
+ * quota		    Sets the maximum number of resources of
+ *				    the selected type that the child
+ *				    container is allowed to allocate
+ *				    from its parent;
+ *				    when quota is set to -1, the policy is
+ *				    the same as container's general policy.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ *
+ * Only the parent container is allowed to change a child policy.
+ */
+int dprc_set_res_quota(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int child_container_id, char *type, uint16_t quota);
+
+/*
+ * Gets the allocation policy of a specific resource/object type
+ *		in a child container
+ *
+ * mc_io			Pointer to opaque I/O object
+ * dprc_handle		Handle to the DPRC object
+ * child_container_id	ID of the child container
+ * type			resource/object type
+ * quota			Holds the maximum number of resources of
+ *					the selected type that the child
+ *					container is allowed to allocate from
+ *					the parent;
+ *					when quota is set to -1, the policy is
+ *					the same as container's general policy.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_res_quota(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int child_container_id, char *type, uint16_t *quota);
+
+/*
+ * Resets a child container.
+ *
+ * In case a software context crashes or becomes non-responsive, the parent
+ * may wish to reset its resources container before the software context is
+ * restarted.
+ *
+ * This routine informs all objects assigned to the child container that the
+ * container is being reset, so they may perform any cleanup operations that are
+ * needed. All objects handles that were owned by the child container shall be
+ * closed.
+ *
+ * Note that such request may be submitted even if the child software context
+ * has not crashed, but the resulting object cleanup operations will not be
+ * aware of that.
+ *
+ * mc_io			Pointer to opaque I/O object
+ * dprc_handle		Handle to the DPRC object
+ * child_container_id	ID of the container to reset
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_reset_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			 int child_container_id);
+
+/*
+ * Assigns objects or resource to a child container.
+ *
+ * Assignment is usually done by a parent (this DPRC) to one of its child
+ * containers.
+ *
+ * According to the DPRC allocation policy, the assigned resources may be taken
+ * (allocated) from the container's ancestors, if not enough resources are
+ * available in the container itself.
+ *
+ * The type of assignment depends on the dprc_res_req options, as follows:
+ * - DPRC_RES_REQ_OPT_EXPLICIT: indicates that assigned resources should have
+ *   the explicit base ID specified at the id_base_align field of res_req.
+ * - DPRC_RES_REQ_OPT_ALIGNED: indicates that the assigned resources should be
+ *   aligned to the value given at id_base_align field of res_req.
+ * - DPRC_RES_REQ_OPT_PLUGGED: Relevant only for object assignment,
+ *   and indicates that the object must be set to the plugged state.
+ *
+ * A container may use this function with its own ID in order to change a
+ * object state to plugged or unplugged.
+ *
+ * If IRQ information has been set in the child DPRC, it will signal an
+ * interrupt following every change in its object assignment.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * container_id	ID of the child container
+ * res_req		Describes the type and amount of resources to
+ *				assign to the given container.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_assign(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		int container_id, struct dprc_res_req *res_req);
+
+/*
+ * Un-assigns objects or resources from a child container
+ *		and moves them into this (parent) DPRC.
+ *
+ * Un-assignment of objects can succeed only if the object is not in the
+ * plugged or opened state.
+ *
+ * mc_io			Pointer to opaque I/O object
+ * dprc_handle		Handle to the DPRC object
+ * child_container_id	ID of the child container
+ * res_req			Describes the type and amount of
+ *					resources to un-assign from the child
+ *					container
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_unassign(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		  int child_container_id, struct dprc_res_req *res_req);
+
+/*
+ * Get the number of dprc's pools
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * pool_count	Number of resource pools in the dprc.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_get_pool_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			int *pool_count);
+
+/*
+ * Get the type (string) of a certain dprc's pool
+ *
+ * The pool types retrieved one by one by incrementing
+ * pool_index up to (not including) the value of pool_count returned
+ * from dprc_get_pool_count(). dprc_get_pool_count() must
+ * be called prior to dprc_get_pool().
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * pool_index	Index of the pool to be queried (< pool_count)
+ * type		The type of the pool.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_get_pool(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		  int pool_index, char *type);
+
+/*
+ * Obtains the number of objects in the DPRC
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * obj_count	Number of objects assigned to the DPRC
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_obj_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int *obj_count);
+
+/*
+ * Obtains general information on an object
+ *
+ * The object descriptors are retrieved one by one by incrementing
+ * obj_index up to (not including) the value of obj_count returned
+ * from dprc_get_obj_count(). dprc_get_obj_count() must
+ * be called prior to dprc_get_obj().
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * obj_index	Index of the object to be queried (< obj_count)
+ * obj_desc	Returns the requested object descriptor
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_obj(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 int obj_index, struct dprc_obj_desc *obj_desc);
+
+/*
+ * Obtains the number of free resources that are assigned
+ *		to this container, by pool type
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * type		pool type
+ * res_count	Number of free resources of the given
+ *				resource type that are assigned to this DPRC
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_res_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       char *type, int *res_count);
+
+/*
+ * Obtains IDs of free resources in the container
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * type		pool type
+ * range_desc	range descriptor
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_res_ids(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		     char *type, struct dprc_res_ids_range_desc *range_desc);
+
+/*
+ * Obtains the physical address of MC portals
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * portal_id	MC portal id
+ * portal_addr	The physical address of the MC portal id
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_portal_paddr(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  int portal_id, uint64_t *portal_addr);
+
+/*
+ * Obtains container attributes
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * attributes	Container attributes
+ *
+ * returns     '0' on Success; Error code otherwise.
+ */
+int dprc_get_attributes(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			struct dprc_attributes *attributes);
+
+/*
+ * Returns region information for a specified object.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * obj_type	Object type as returned in dprc_get_obj()
+ * obj_id		Unique object instance as returned in
+ *				dprc_get_obj()
+ * region_index	The specific region to query
+ * region_desc	Returns the requested region descriptor
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_obj_region(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			char *obj_type,
+			int obj_id,
+			uint8_t region_index,
+			struct dprc_region_desc *region_desc);
+
+/*
+ * Sets IRQ information for the DPRC to trigger an interrupt.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	Identifies the interrupt index to configure
+ *				DPRC supports only irq_index 0 - this interrupt
+ *				will be signaled on every change to
+ *				resource/object assignment in this DPRC.
+ * irq_paddr	Physical IRQ address that must be written to
+ *				signal a message-based interrupt
+ * irq_val		Value to write into irq_paddr address
+ * user_irq_id	A user defined number associated with this IRQ;
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_set_irq(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 uint8_t irq_index,
+		 uint64_t irq_paddr, uint32_t irq_val, int user_irq_id);
+
+/*
+ * Gets IRQ information from the DPRC.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	The interrupt index to configure;
+ *				DPRC supports only irq_index 0 - this interrupt
+ *				will be signaled on every change to
+ *				resource/object assignment in this DPRC.
+ * type		Interrupt type: 0 represents message interrupt
+ *				type (both irq_paddr and irq_val are valid);
+ * irq_paddr	Physical address that must be written in order
+ *				to signal the message-based interrupt
+ * irq_val		Value to write in order to signal the
+ *				message-based interrupt
+ * user_irq_id	A user defined number associated with this IRQ;
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_irq(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 uint8_t irq_index,
+		 int *type,
+		 uint64_t *irq_paddr, uint32_t *irq_val, int *user_irq_id);
+
+/*
+ * Sets overall interrupt state.
+ *
+ * Allows GPP software to control when interrupts are generated.
+ * Each interrupt can have up to 32 causes.  The enable/disable control's the
+ * overall interrupt state. if the interrupt is disabled no causes will cause an
+ * interrupt.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	The interrupt index to configure
+ * enable_state	Interrupt state - enable = 1, disable = 0.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_set_irq_enable(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint8_t enable_state);
+
+/*
+ * Gets overall interrupt state
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	The interrupt index to configure
+ * enable_state	Interrupt state - enable = 1, disable = 0.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_irq_enable(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint8_t *enable_state);
+
+/*
+ * Sets interrupt mask.
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	The interrupt index to configure
+ * mask		Event mask to trigger interrupt.
+ *				each bit:
+ *					0 = ignore event
+ *					1 = consider event for asserting irq
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_set_irq_mask(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		      uint8_t irq_index, uint32_t mask);
+
+/*
+ * Gets interrupt mask.
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	The interrupt index to configure
+ * mask		Event mask to trigger interrupt
+ *
+ * returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_irq_mask(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		      uint8_t irq_index, uint32_t *mask);
+
+/*
+ * Gets the current status of any pending interrupts.
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	The interrupt index to configure
+ * status		Interrupts status - one bit per cause
+ *					0 = no interrupt pending
+ *					1 = interrupt pending
+ *
+ * returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_get_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint32_t *status);
+
+/*
+ * Clears a pending interrupt's status
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * irq_index	The interrupt index to configure
+ * status		Bits to clear (W1C) - one bit per cause
+ *					0 = don't change
+ *					1 = clear status bit
+ *
+ * returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_clear_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  uint8_t irq_index, uint32_t status);
+
+/*
+ * Connects two endpoints to create a network link between them
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * endpoint1	Endpoint 1 configuration parameters.
+ * endpoint2	Endpoint 2 configuration parameters.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_connect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 struct dprc_endpoint *endpoint1,
+		 struct dprc_endpoint *endpoint2);
+
+/*
+ * Disconnects one endpoint to remove its network link
+ *
+ * mc_io		Pointer to opaque I/O object
+ * dprc_handle	Handle to the DPRC object
+ * endpoint	Endpoint configuration parameters.
+ *
+ * returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		    struct dprc_endpoint *endpoint);
+
+/* */
+
+#endif /* _FSL_DPRC_H */
diff --git a/include/linux/fsl/mc-cmd.h b/include/linux/fsl/mc-cmd.h
new file mode 100644
index 0000000..737e372
--- /dev/null
+++ b/include/linux/fsl/mc-cmd.h
@@ -0,0 +1,169 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __FSL_MC_CMD_H
+#define __FSL_MC_CMD_H
+
+#include <linux/fsl/mc-sys.h>
+
+/*
+ * MC clients (GPP side) encode MC command parameters and decode MC response
+ * parameters
+ */
+
+#define MC_CMD_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
+	((_cmd).params[_param] |= u64_enc((_offset), (_width), (_type)(_arg)))
+
+#define MC_RSP_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
+	((_arg) = (_type)u64_dec((_cmd).params[_param], (_offset), (_width)))
+
+#define MAKE_UMASK64(_width) \
+	((uint64_t)((_width) < 64 ? ((uint64_t)1 << (_width)) - 1 : -1))
+
+static inline uint64_t u64_enc(int lsoffset, int width, uint64_t val)
+{
+	return (uint64_t)(((uint64_t)val & MAKE_UMASK64(width)) << lsoffset);
+}
+
+static inline uint64_t u64_dec(uint64_t val, int lsoffset, int width)
+{
+	return (uint64_t)((val >> lsoffset) & MAKE_UMASK64(width));
+}
+
+#define MC_CMD_NUM_OF_PARAMS	7
+
+struct mc_command {
+	uint64_t header;
+	uint64_t params[MC_CMD_NUM_OF_PARAMS];
+};
+
+enum mc_cmd_status {
+	MC_CMD_STATUS_OK = 0x0,	/*!< Completed successfully */
+	MC_CMD_STATUS_READY = 0x1,	/*!< Ready to be processed */
+	MC_CMD_STATUS_AUTH_ERR = 0x3,	/*!< Authentication error */
+	MC_CMD_STATUS_NO_PRIVILEGE = 0x4,	/*!< No privilege */
+	MC_CMD_STATUS_DMA_ERR = 0x5,	/*!< DMA or I/O error */
+	MC_CMD_STATUS_CONFIG_ERR = 0x6,	/*!< Configuration error */
+	MC_CMD_STATUS_TIMEOUT = 0x7,	/*!< Operation timed out */
+	MC_CMD_STATUS_NO_RESOURCE = 0x8,	/*!< No resources */
+	MC_CMD_STATUS_NO_MEMORY = 0x9,	/*!< No memory available */
+	MC_CMD_STATUS_BUSY = 0xA,	/*!< Device is busy */
+	MC_CMD_STATUS_UNSUPPORTED_OP = 0xB,	/*!< Unsupported operation */
+	MC_CMD_STATUS_INVALID_STATE = 0xC	/*!< Invalid state */
+};
+
+#define MC_CMD_HDR_CMDID_O	52	/* Command ID field offset */
+#define MC_CMD_HDR_CMDID_S	12	/* Command ID field size */
+#define MC_CMD_HDR_AUTHID_O	38	/* Authentication ID field offset */
+#define MC_CMD_HDR_AUTHID_S	10	/* Authentication ID field size */
+#define MC_CMD_HDR_SIZE_O	31	/* Size field offset */
+#define MC_CMD_HDR_SIZE_S	6	/* Size field size */
+#define MC_CMD_HDR_STATUS_O	16	/* Status field offset */
+#define MC_CMD_HDR_STATUS_S	8	/* Status field size */
+#define MC_CMD_HDR_PRI_O	15	/* Priority field offset */
+#define MC_CMD_HDR_PRI_S	1	/* Priority field size */
+
+#define MC_CMD_HDR_READ_STATUS(_hdr) \
+	((enum mc_cmd_status)u64_dec((_hdr), \
+		MC_CMD_HDR_STATUS_O, MC_CMD_HDR_STATUS_S))
+
+#define MC_CMD_HDR_READ_AUTHID(_hdr) \
+	((uint16_t)u64_dec((_hdr), MC_CMD_HDR_AUTHID_O, MC_CMD_HDR_AUTHID_S))
+
+#define MC_CMD_PRI_LOW		0	/*!< Low Priority command indication */
+#define MC_CMD_PRI_HIGH		1	/*!< High Priority command indication */
+
+static inline uint64_t mc_encode_cmd_header(uint16_t cmd_id,
+					    uint8_t cmd_size,
+					    uint8_t priority, uint16_t auth_id)
+{
+	uint64_t hdr;
+
+	hdr = u64_enc(MC_CMD_HDR_CMDID_O, MC_CMD_HDR_CMDID_S, cmd_id);
+	hdr |= u64_enc(MC_CMD_HDR_AUTHID_O, MC_CMD_HDR_AUTHID_S, auth_id);
+	hdr |= u64_enc(MC_CMD_HDR_SIZE_O, MC_CMD_HDR_SIZE_S, cmd_size);
+	hdr |= u64_enc(MC_CMD_HDR_PRI_O, MC_CMD_HDR_PRI_S, priority);
+	hdr |= u64_enc(MC_CMD_HDR_STATUS_O, MC_CMD_HDR_STATUS_S,
+		       MC_CMD_STATUS_READY);
+
+	return hdr;
+}
+
+/**
+ * mc_write_command - writes a command to a Management Complex (MC) portal
+ *
+ * @portal: pointer to an MC portal
+ * @cmd: pointer to a filled command
+ */
+static inline void mc_write_command(struct mc_command __iomem *portal,
+				    struct mc_command *cmd)
+{
+	int i;
+
+	/* copy command parameters into the portal */
+	for (i = 0; i < MC_CMD_NUM_OF_PARAMS; i++)
+		writeq(cmd->params[i], &portal->params[i]);
+
+	/* submit the command by writing the header */
+	writeq(cmd->header, &portal->header);
+}
+
+/**
+ * mc_read_response - reads the response for the last MC command from a
+ * Management Complex (MC) portal
+ *
+ * @portal: pointer to an MC portal
+ * @resp: pointer to command response buffer
+ *
+ * Returns MC_CMD_STATUS_OK on Success; Error code otherwise.
+ */
+static inline enum mc_cmd_status mc_read_response(struct mc_command __iomem *
+						  portal,
+						  struct mc_command *resp)
+{
+	int i;
+	enum mc_cmd_status status;
+
+	/* Copy command response header from MC portal: */
+	resp->header = readq(&portal->header);
+	status = MC_CMD_HDR_READ_STATUS(resp->header);
+	if (status != MC_CMD_STATUS_OK)
+		return status;
+
+	/* Copy command response data from MC portal: */
+	for (i = 0; i < MC_CMD_NUM_OF_PARAMS; i++)
+		resp->params[i] = readq(&portal->params[i]);
+
+	return status;
+}
+
+#endif /* __FSL_MC_CMD_H */
diff --git a/include/linux/fsl/mc-sys.h b/include/linux/fsl/mc-sys.h
new file mode 100644
index 0000000..ee57cd6
--- /dev/null
+++ b/include/linux/fsl/mc-sys.h
@@ -0,0 +1,68 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of the above-listed copyright holders nor the
+ *       names of any contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
+ * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+ * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
+ * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
+ * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
+ * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
+ * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
+ * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _FSL_MC_SYS_H
+#define _FSL_MC_SYS_H
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/dma-mapping.h>
+
+struct mc_command;
+
+/**
+ * struct fsl_mc_io - MC I/O object to be passed-in to mc_send_command()
+ * @dev: device associated with this Mc I/O object
+ * @flags: flags for mc_send_command()
+ * @portal_size: MC command portal size in bytes
+ * @portal_phys_addr: MC command portal physical address
+ * @portal_virt_addr: MC command portal virtual address
+ */
+struct fsl_mc_io {
+	struct device *dev;
+	uint32_t flags;
+	uint32_t portal_size;
+	phys_addr_t portal_phys_addr;
+	void __iomem *portal_virt_addr;
+};
+
+int __must_check fsl_create_mc_io(struct device *dev,
+				  phys_addr_t mc_portal_phys_addr,
+				  uint32_t mc_portal_size,
+				  uint32_t flags, struct fsl_mc_io **new_mc_io);
+
+void fsl_destroy_mc_io(struct fsl_mc_io *mc_io);
+
+int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd);
+
+#endif /* _FSL_MC_SYS_H */
--
1.7.9.7

