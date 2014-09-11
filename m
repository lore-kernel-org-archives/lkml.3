Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaIKRuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 13:50:21 -0400
Received: from mail-by2on0135.outbound.protection.outlook.com ([207.46.100.135]:43961
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751053AbaIKRuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 13:50:18 -0400
From: "J. German Rivera" <German.Rivera@freescale.com>
To: <gregkh@linuxfoundation.org>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>
CC: <stuart.yoder@freescale.com>, <Kim.Phillips@freescale.com>,
        <scottwood@freescale.com>, <agraf@suse.de>,
        <linuxppc-release@linux.freescale.net>,
        "J. German Rivera" <German.Rivera@freescale.com>
Subject: [PATCH 1/4] drivers/bus: Added Freescale Management Complex APIs
Date: Thu, 11 Sep 2014 12:34:21 -0500
Message-ID: <1410456864-27890-2-git-send-email-German.Rivera@freescale.com>
X-Mailer: git-send-email 1.7.9.7
In-Reply-To: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
References: <1410456864-27890-1-git-send-email-German.Rivera@freescale.com>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(199003)(189002)(45074003)(31966008)(92726001)(93916002)(86362001)(74502001)(90102001)(74662001)(92566001)(2201001)(62966002)(95666004)(85852003)(106466001)(83072002)(21056001)(105606002)(36756003)(107046002)(89996001)(50466002)(88136002)(77982001)(229853001)(104016003)(87936001)(19580405001)(50226001)(50986999)(79102001)(77156001)(87286001)(4396001)(6806004)(47776003)(19580395003)(44976005)(81342001)(64706001)(46102001)(85306004)(81542001)(97736003)(83322001)(84676001)(102836001)(80022001)(26826002)(99396002)(48376002)(20776003)(76176999)(76482001)(68736004)(104166001)(2004002)(559001)(569005);DIR:OUT;SFP:1102;SCL:1;SRVR:CY1PR0301MB0732;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03319F6FEF
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
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
 drivers/bus/fsl-mc/dpmng.c         |   93 +++++
 drivers/bus/fsl-mc/dprc.c          |  504 +++++++++++++++++++++++
 drivers/bus/fsl-mc/fsl_dpmng_cmd.h |   83 ++++
 drivers/bus/fsl-mc/fsl_dprc_cmd.h  |  545 +++++++++++++++++++++++++
 drivers/bus/fsl-mc/fsl_mc_sys.c    |  237 +++++++++++
 include/linux/fsl_dpmng.h          |  120 ++++++
 include/linux/fsl_dprc.h           |  790 ++++++++++++++++++++++++++++++++++++
 include/linux/fsl_mc_cmd.h         |  182 +++++++++
 include/linux/fsl_mc_sys.h         |   81 ++++
 9 files changed, 2635 insertions(+)
 create mode 100644 drivers/bus/fsl-mc/dpmng.c
 create mode 100644 drivers/bus/fsl-mc/dprc.c
 create mode 100644 drivers/bus/fsl-mc/fsl_dpmng_cmd.h
 create mode 100644 drivers/bus/fsl-mc/fsl_dprc_cmd.h
 create mode 100644 drivers/bus/fsl-mc/fsl_mc_sys.c
 create mode 100644 include/linux/fsl_dpmng.h
 create mode 100644 include/linux/fsl_dprc.h
 create mode 100644 include/linux/fsl_mc_cmd.h
 create mode 100644 include/linux/fsl_mc_sys.h

diff --git a/drivers/bus/fsl-mc/dpmng.c b/drivers/bus/fsl-mc/dpmng.c
new file mode 100644
index 0000000..c6ed27c
--- /dev/null
+++ b/drivers/bus/fsl-mc/dpmng.c
@@ -0,0 +1,93 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/fsl_mc_sys.h>
+#include <linux/fsl_mc_cmd.h>
+#include <linux/fsl_dpmng.h>
+#include "fsl_dpmng_cmd.h"
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
+	if (!err)
+		DPMNG_RSP_GET_VERSION(cmd, mc_ver_info);
+
+	return err;
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
+		    int aiop_tile_id, uint8_t *img_addr, int img_size)
+{
+	struct mc_command cmd = { 0 };
+	uint64_t img_paddr = virt_to_phys(img_addr);
+
+	cmd.header = mc_encode_cmd_header(DPMNG_CMDID_LOAD_AIOP,
+					  DPMNG_CMDSZ_LOAD_AIOP,
+					  MC_CMD_PRI_LOW, 0);
+
+	DPMNG_CMD_LOAD_AIOP(cmd, aiop_tile_id, img_size, img_paddr);
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
diff --git a/drivers/bus/fsl-mc/dprc.c b/drivers/bus/fsl-mc/dprc.c
new file mode 100644
index 0000000..5c80bab
--- /dev/null
+++ b/drivers/bus/fsl-mc/dprc.c
@@ -0,0 +1,504 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#include <linux/fsl_mc_sys.h>
+#include <linux/fsl_mc_cmd.h>
+#include <linux/fsl_dprc.h>
+#include "fsl_dprc_cmd.h"
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
+	if (!err)
+		DPRC_RSP_GET_CONTAINER_ID(cmd, *container_id);
+
+	return err;
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
+	if (!err)
+		*dprc_handle = MC_CMD_HDR_READ_AUTHID(cmd.header);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_CREATE_CONTAINER(cmd, *child_container_id,
+					  *child_portal_paddr);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_RES_QUOTA(cmd, *quota);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_OBJ_COUNT(cmd, *obj_count);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_OBJECT(cmd, obj_desc);
+
+	return err;
+}
+
+int dprc_get_res_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       char *type, int *res_count)
+{
+	struct mc_command cmd = { 0 };
+	int err;
+
+	*res_count = 0;
+
+	cmd.header = mc_encode_cmd_header(DPRC_CMDID_GET_RES_COUNT,
+					  DPRC_CMDSZ_GET_RES_COUNT,
+					  MC_CMD_PRI_LOW, dprc_handle);
+
+	DPRC_CMD_GET_RES_COUNT(cmd, type);
+	err = mc_send_command(mc_io, &cmd);
+	if (!err)
+		DPRC_RSP_GET_RES_COUNT(cmd, *res_count);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_RES_IDS(cmd, range_desc);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_ATTRIBUTES(cmd, attr);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_OBJ_REGION(cmd, region_desc);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_IRQ(cmd, *irq_val, *irq_paddr, *user_irq_id,
+				 *type);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_IRQ_ENABLE(cmd, *enable_state);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_IRQ_MASK(cmd, *mask);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_IRQ_STATUS(cmd, *status);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_POOL_COUNT(cmd, *pool_count);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_POOL(cmd, type);
+
+	return err;
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
+	if (!err)
+		DPRC_RSP_GET_PORTAL_PADDR(cmd, *portal_addr);
+
+	return err;
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
diff --git a/drivers/bus/fsl-mc/fsl_dpmng_cmd.h b/drivers/bus/fsl-mc/fsl_dpmng_cmd.h
new file mode 100644
index 0000000..5445455
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_dpmng_cmd.h
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
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/**************************************************************************//*
+ @File          fsl_dpmng_cmd.h
+
+ @Description   defines portal commands
+
+ @Cautions      None.
+ *//***************************************************************************/
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
diff --git a/drivers/bus/fsl-mc/fsl_dprc_cmd.h b/drivers/bus/fsl-mc/fsl_dprc_cmd.h
new file mode 100644
index 0000000..e4d1fdc
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_dprc_cmd.h
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
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/**************************************************************************//*
+ @File          fsl_dprc_cmd.h
+
+ @Description   defines dprc portal commands
+
+ @Cautions      None.
+ *//***************************************************************************/
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
diff --git a/drivers/bus/fsl-mc/fsl_mc_sys.c b/drivers/bus/fsl-mc/fsl_mc_sys.c
new file mode 100644
index 0000000..2a7adef
--- /dev/null
+++ b/drivers/bus/fsl-mc/fsl_mc_sys.c
@@ -0,0 +1,237 @@
+/* Copyright 2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+#include <linux/fsl_mc_sys.h>
+#include <linux/fsl_mc_cmd.h>
+#include <linux/delay.h>
+#include <linux/slab.h>
+#include <linux/ioport.h>
+
+/**
+ * Timeout in jiffies to wait for the completion of an MC command
+ */
+#define MC_CMD_COMPLETION_TIMEOUT   100
+
+/**
+ * Delay in microseconds between polling iterations while
+ * waiting for MC command completion
+ */
+#define MC_CMD_COMPLETION_POLLING_INTERVAL  500
+
+/**
+ * Map an MC portal in the kernel virtual address space
+ */
+static int map_mc_portal(phys_addr_t mc_portal_phys_addr,
+			 uint32_t mc_portal_size,
+			 void __iomem **new_mc_portal_virt_addr)
+{
+	void __iomem *mc_portal_virt_addr = NULL;
+	struct resource *res = NULL;
+	int error = -EINVAL;
+
+	res =
+	    request_mem_region(mc_portal_phys_addr, mc_portal_size,
+			       "mc_portal");
+	if (res == NULL) {
+		pr_err("request_mem_region() failed for MC portal %#llx\n",
+		       mc_portal_phys_addr);
+		error = -EBUSY;
+		goto error;
+	}
+
+	mc_portal_virt_addr = ioremap_nocache(mc_portal_phys_addr,
+					      mc_portal_size);
+	if (mc_portal_virt_addr == NULL) {
+		pr_err("ioremap_nocache() failed for MC portal %#llx\n",
+		       mc_portal_phys_addr);
+		error = -EFAULT;
+		goto error;
+	}
+
+	*new_mc_portal_virt_addr = mc_portal_virt_addr;
+	return 0;
+error:
+	if (mc_portal_virt_addr != NULL)
+		iounmap(mc_portal_virt_addr);
+
+	if (res != NULL)
+		release_mem_region(mc_portal_phys_addr, mc_portal_size);
+
+	return error;
+}
+
+/**
+ * Unmap an MC portal from the kernel virtual address space
+ */
+static void unmap_mc_portal(phys_addr_t mc_portal_phys_addr,
+			    uint16_t mc_portal_size,
+			    void __iomem *mc_portal_virt_addr)
+{
+	if (WARN_ON(mc_portal_virt_addr == NULL))
+		return;
+
+	iounmap(mc_portal_virt_addr);
+	release_mem_region(mc_portal_phys_addr, mc_portal_size);
+}
+
+int __must_check fsl_create_mc_io(phys_addr_t mc_portal_phys_addr,
+				  uint32_t mc_portal_size,
+				  uint32_t flags, struct fsl_mc_io **new_mc_io)
+{
+	int error = -EINVAL;
+	struct fsl_mc_io *mc_io = NULL;
+
+	mc_io = kzalloc(sizeof(*mc_io), GFP_KERNEL);
+	if (mc_io == NULL) {
+		error = -ENOMEM;
+		pr_err("No memory to allocate mc_io\n");
+		goto error;
+	}
+
+	mc_io->magic = FSL_MC_IO_MAGIC;
+	mc_io->flags = flags;
+	mc_io->portal_phys_addr = mc_portal_phys_addr;
+	mc_io->portal_size = mc_portal_size;
+	spin_lock_init(&mc_io->spinlock);
+	error = map_mc_portal(mc_portal_phys_addr,
+			      mc_portal_size, &mc_io->portal_virt_addr);
+	if (error < 0)
+		goto error;
+
+	*new_mc_io = mc_io;
+	return 0;
+error:
+	if (mc_io != NULL) {
+		if (mc_io->portal_virt_addr != NULL) {
+			unmap_mc_portal(mc_portal_phys_addr,
+					mc_portal_size,
+					mc_io->portal_virt_addr);
+		}
+
+		kfree(mc_io);
+	}
+
+	return error;
+}
+EXPORT_SYMBOL_GPL(fsl_create_mc_io);
+
+void fsl_destroy_mc_io(struct fsl_mc_io *mc_io)
+{
+	if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
+		return;
+
+	if (mc_io->portal_virt_addr != NULL) {
+		unmap_mc_portal(mc_io->portal_phys_addr,
+				mc_io->portal_size, mc_io->portal_virt_addr);
+
+		mc_io->portal_virt_addr = NULL;
+	}
+
+	mc_io->magic = 0x0;
+	kfree(mc_io);
+}
+EXPORT_SYMBOL_GPL(fsl_destroy_mc_io);
+
+static int mc_status_to_error(enum mc_cmd_status status)
+{
+	switch (status) {
+	case MC_CMD_STATUS_OK:
+		return 0;
+	case MC_CMD_STATUS_AUTH_ERR:
+		return -EACCES;
+	case MC_CMD_STATUS_NO_PRIVILEGE:
+		return -EPERM;
+	case MC_CMD_STATUS_DMA_ERR:
+		return -EIO;
+	case MC_CMD_STATUS_CONFIG_ERR:
+		return -EINVAL;
+	case MC_CMD_STATUS_TIMEOUT:
+		return -ETIMEDOUT;
+	case MC_CMD_STATUS_NO_RESOURCE:
+		return -ENAVAIL;
+	case MC_CMD_STATUS_NO_MEMORY:
+		return -ENOMEM;
+	case MC_CMD_STATUS_BUSY:
+		return -EBUSY;
+	case MC_CMD_STATUS_UNSUPPORTED_OP:
+		return -ENOTSUP;
+	case MC_CMD_STATUS_INVALID_STATE:
+		return -ENODEV;
+	default:
+		break;
+	}
+
+	/* Not expected to reach here */
+	return -EINVAL;
+}
+
+int mc_send_command(struct fsl_mc_io *mc_io, struct mc_command *cmd)
+{
+	enum mc_cmd_status status;
+	unsigned long irqsave_flags = 0;
+	int error = -EINVAL;
+	bool lock_acquired = false;
+	unsigned long jiffies_until_timeout =
+	    jiffies + MC_CMD_COMPLETION_TIMEOUT;
+
+	if (WARN_ON(mc_io->magic != FSL_MC_IO_MAGIC))
+		goto out;
+
+	if (mc_io->flags & FSL_MC_IO_PORTAL_SHARED) {
+		spin_lock_irqsave(&mc_io->spinlock, irqsave_flags);
+		lock_acquired = true;
+	}
+
+	mc_write_command(mc_io->portal_virt_addr, cmd);
+
+	for (;;) {
+		status = mc_read_response(mc_io->portal_virt_addr, cmd);
+		if (status != MC_CMD_STATUS_READY)
+			break;
+
+		/*
+		 * TODO: When MC command completion interrupts are supported
+		 * call wait function here instead of udelay()
+		 */
+		udelay(MC_CMD_COMPLETION_POLLING_INTERVAL);
+		if (time_after_eq(jiffies, jiffies_until_timeout)) {
+			error = -ETIMEDOUT;
+			goto out;
+		}
+	}
+
+	error = mc_status_to_error(status);
+out:
+	if (lock_acquired)
+		spin_unlock_irqrestore(&mc_io->spinlock, irqsave_flags);
+
+	return error;
+}
+EXPORT_SYMBOL(mc_send_command);
diff --git a/include/linux/fsl_dpmng.h b/include/linux/fsl_dpmng.h
new file mode 100644
index 0000000..68af9de
--- /dev/null
+++ b/include/linux/fsl_dpmng.h
@@ -0,0 +1,120 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/*!
+ *  @file    fsl_dpmng.h
+ *  @brief   Management Complex General API
+ */
+
+#ifndef __FSL_DPMNG_H
+#define __FSL_DPMNG_H
+
+/*!
+ * @Group grp_dpmng	Management Complex General API
+ *
+ * @brief	Contains general API for the Management Complex firmware
+ * @{
+ */
+
+struct fsl_mc_io;
+
+/**
+ * @brief	Management Complex firmware version information
+ */
+#define MC_VER_MAJOR 2
+#define MC_VER_MINOR 0
+
+struct mc_version {
+	uint32_t major;
+	/*!<
+	 * Major version number: incremented on API compatibility changes
+	 */
+	uint32_t minor;
+	/*!<
+	 * Minor version number: incremented on API additions (backward
+	 * compatible); reset when major version is incremented.
+	 */
+	uint32_t revision;
+	/*!<
+	 * Internal revision number: incremented on implementation changes
+	 * and/or bug fixes that have no impact on API
+	 */
+};
+
+/**
+ * @brief	Retrieves the Management Complex firmware version information
+ *
+ * @param[in]   mc_io - Pointer to opaque I/O object
+ * @param[out]	mc_ver_info - Pointer to version information structure
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int mc_get_version(struct fsl_mc_io *mc_io, struct mc_version *mc_ver_info);
+
+/**
+ * @brief	Resets an AIOP tile
+ *
+ * @param[in]   mc_io - Pointer to opaque I/O object
+ * @param[in]	aiop_tile_id - AIOP tile ID to reset
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dpmng_reset_aiop(struct fsl_mc_io *mc_io, int aiop_tile_id);
+
+/**
+ * @brief	Loads an image to AIOP tile
+ *
+ * @param[in]   mc_io - Pointer to opaque I/O object
+ * @param[in]	aiop_tile_id - AIOP tile ID
+ * @param[in]	img_addr - Pointer to AIOP ELF image in memory
+ * @param[in]	img_size - Size in bytes of AIOP ELF image in memory
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dpmng_load_aiop(struct fsl_mc_io *mc_io,
+		    int aiop_tile_id, uint8_t *img_addr, int img_size);
+
+/**
+ * @brief	Starts AIOP tile execution
+ *
+ * @param[in]   mc_io - Pointer to opaque I/O object
+ * @param[in]	aiop_tile_id - AIOP tile ID to run
+ * @param[in]	cores_mask - Mask of AIOP cores to run (core 0 in msb)
+ * @param[in]	options - Execution options (currently none defined)
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dpmng_run_aiop(struct fsl_mc_io *mc_io,
+		   int aiop_tile_id, uint32_t cores_mask, uint64_t options);
+
+/** @} */
+
+#endif /* __FSL_DPMNG_H */
diff --git a/include/linux/fsl_dprc.h b/include/linux/fsl_dprc.h
new file mode 100644
index 0000000..8bd753e
--- /dev/null
+++ b/include/linux/fsl_dprc.h
@@ -0,0 +1,790 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+/*!
+ *  @file    fsl_dprc.h
+ *  @brief   Data Path Resource Container API
+ */
+
+#ifndef _FSL_DPRC_H
+#define _FSL_DPRC_H
+
+/*!
+ * @Group grp_dprc	Data Path Resource Container API
+ *
+ * @brief	Contains DPRC API for managing and querying LDPAA resources
+ * @{
+ */
+
+struct fsl_mc_io;
+
+/*!
+ * Set this value as the icid value in dprc_cfg structure when creating a
+ * container, in case the ICID is not selected by the user and should be
+ * allocated by the DPRC from the pool of ICIDs.
+ */
+#define DPRC_GET_ICID_FROM_POOL			(uint16_t)(~(0))
+/*!
+ * Set this value as the portal_id value in dprc_cfg structure when creating a
+ * container, in case the portal id is not specifically selected by the
+ * user and should be allocated by the DPRC from the pool of portal ids.
+ */
+#define DPRC_GET_PORTAL_ID_FROM_POOL	(int)(~(0))
+
+/*!
+ * @name Resource request options
+ */
+#define DPRC_RES_REQ_OPT_EXPLICIT		0x00000001
+/*!< Explicit resource id request - The requested objects/resources
+ * are explicit and sequential (in case of resources).
+ * The base ID is given at res_req at base_align field */
+#define DPRC_RES_REQ_OPT_ALIGNED		0x00000002
+/*!< Aligned resources request - Relevant only for resources
+ * request (and not objects). Indicates that resources base id should be
+ * sequential and aligned to the value given at dprc_res_req base_align field*/
+#define DPRC_RES_REQ_OPT_PLUGGED		0x00000004
+/*!< Plugged Flag - Relevant only for object assignment request.
+ * Indicates that after all objects assigned. An interrupt will be invoked at
+ * the relevant GPP. The assigned object will be marked as plugged.
+ * plugged objects can't be assigned from their container */
+/* @} */
+
+/*!
+ * @name Container general options
+ *
+ * These options may be selected at container creation by the container creator
+ * and can be retrieved using dprc_get_attributes()
+ */
+#define DPRC_CFG_OPT_SPAWN_ALLOWED		0x00000001
+/*!< Spawn Policy Option allowed - Indicates that the new container is allowed
+ * to spawn and have its own child containers. */
+#define DPRC_CFG_OPT_ALLOC_ALLOWED		0x00000002
+/*!< General Container allocation policy - Indicates that the new container is
+ * allowed to allocate requested resources from its parent container; if not
+ * set, the container is only allowed to use resources in its own pools; Note
+ * that this is a container's global policy, but the parent container may
+ * override it and set specific quota per resource type. */
+#define DPRC_CFG_OPT_OBJ_CREATE_ALLOWED	0x00000004
+/*!< Object initialization allowed - software context associated with this
+ * container is allowed to invoke object initialization operations. */
+#define DPRC_CFG_OPT_TOPOLOGY_CHANGES_ALLOWED	0x00000008
+/*!< Topology change allowed - software context associated with this
+ * container is allowed to invoke topology operations, such as attach/detach
+ * of network objects. */
+#define DPRC_CFG_OPT_IOMMU_BYPASS		0x00000010
+/*!<IOMMU bypass - indicates whether objects of this container are permitted
+ * to bypass the IOMMU.  */
+#define DPRC_CFG_OPT_AIOP			0x00000020
+/*!<AIOP -Indicates that container belongs to aiop.  */
+/* @} */
+
+/*!
+ * @name Objects Attributes Flags
+ */
+#define DPRC_OBJ_STATE_OPEN		0x00000001
+/*!< Opened state - Indicates that an object is open by at least one owner */
+#define DPRC_OBJ_STATE_PLUGGED		0x00000002
+/*!< Plugged state - Indicates that the object is plugged */
+/* @} */
+
+/*!
+ * @name Irq
+ */
+#define DPRC_NUM_OF_IRQS		1
+/*!< Number of dprc's IRQs */
+/* @} */
+
+/*!
+ * @name Object irq events
+ */
+#define DPRC_IRQ_EVENT_OBJ_ASSIGNED			0x00000001
+/*!< Irq event - Indicates that a new object assigned to the container */
+#define DPRC_IRQ_EVENT_OBJ_UNASSIGNED		0x00000002
+/*!< Irq event - Indicates that an object was unassigned from the container */
+#define DPRC_IRQ_EVENT_RES_ASSIGNED			0x00000004
+/*!< Irq event - Indicates that resources assigned to the container */
+#define DPRC_IRQ_EVENT_RES_UNASSIGNED		0x00000008
+/*!< Irq event - Indicates that resources unassigned from the container */
+#define DPRC_IRQ_EVENT_CONTAINER_DESTROYED	0x00000010
+/*!< Irq event - Indicates that one of the descendant containers that opened by
+ * this container is destroyed */
+#define DPRC_IRQ_EVENT_OBJ_DESTROYED		0x00000011
+/*!< Irq event - Indicates that on one of the container's opened object is
+ destroyed */
+/* @} */
+
+/**
+ * @brief	Resource request descriptor, to be used in assignment or
+ *		un-assignment of resources and objects.
+ */
+struct dprc_res_req {
+	char type[16];
+	/*!<
+	 * Resource/object type: Represent as a NULL terminated string.
+	 * This string may received by using dprc_get_pool() to get resource
+	 * type and dprc_get_obj() to get object type.
+	 * Note: it is not possible to assign/unassign DP_OBJ_DPRC objects
+	 */
+	uint32_t num;
+	/*!< Number of resources */
+	uint32_t options;
+	/*!< Request options: combination of DPRC_RES_REQ_OPT_ options */
+	int id_base_align;
+	/*!<
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
+/**
+ * @brief	Object descriptor, returned from dprc_get_obj()
+ */
+struct dprc_obj_desc {
+	uint16_t vendor;
+	/*!< Object vendor identifier */
+	char type[16];
+	/*!< Type of object: NULL terminated string */
+	int id;
+	/*!< ID of logical object resource */
+	uint32_t ver_major;
+	/*!< Major version number */
+	uint32_t ver_minor;
+	/*!< Minor version number */
+	uint8_t irq_count;
+	/*!< Number of interrupts supported by the object */
+	uint8_t region_count;
+	/*!< Number of mappable regions supported by the object */
+	uint32_t state;
+	/*!< Object state: combination of DPRC_OBJ_STATE_ states */
+};
+
+/**
+ * @brief	Mappable region descriptor, returned by dprc_get_obj_region()
+ */
+struct dprc_region_desc {
+	uint64_t base_paddr;
+	/*!< Region base physical address */
+	uint32_t size;
+	/*!< Region size (in bytes) */
+};
+
+/**
+ * @brief	Iteration status, for use with dprc_get_res_ids() function
+ *
+ */
+enum dprc_iter_status {
+	DPRC_ITER_STATUS_FIRST = 0,
+	/*!< Perform first iteration */
+	DPRC_ITER_STATUS_MORE = 1,
+	/*!< Indicates more/next iteration is needed */
+	DPRC_ITER_STATUS_LAST = 2
+	    /*!< Indicates last iteration */
+};
+
+/**
+ * @brief	Resource Id range descriptor, Used at dprc_get_res_ids() and
+ *		contains one range details.
+ */
+struct dprc_res_ids_range_desc {
+	int base_id;
+	/*!< Base resource ID of this range */
+	int last_id;
+	/*!< Last resource ID of this range */
+	enum dprc_iter_status iter_status;
+	/*!<
+	 * Iteration status - should be set to DPRC_ITER_STATUS_FIRST at
+	 * first iteration; while the returned marker is DPRC_ITER_STATUS_MORE,
+	 * additional iterations are needed, until the returned marker is
+	 * DPRC_ITER_STATUS_LAST
+	 */
+};
+
+/**
+ * @brief	Container attributes, returned by dprc_get_attributes()
+ */
+struct dprc_attributes {
+	int container_id;
+	/*!< Container's ID */
+	uint16_t icid;
+	/*!< Container's ICID */
+	int portal_id;
+	/*!< Container's portal ID */
+	uint64_t options;
+	/*!< Container's options as set at container's creation */
+	struct {
+		uint32_t major;	/*!< DPRC major version */
+		uint32_t minor;	/*!< DPRC minor version */
+	} version;
+	/*!< DPRC version */
+};
+
+/**
+ * @brief	Container configuration options, used in dprc_create_container()
+ */
+struct dprc_cfg {
+	uint16_t icid;
+	/*!< Container's ICID; if set to DPRC_GET_ICID_FROM_POOL, a free ICID
+	 * will be allocated by the DPRC */
+	int portal_id;
+	/*!< portal id; if set to DPRC_GET_PORTAL_ID_FROM_POOL, a free portal id
+	 * will be allocated by the DPRC */
+	uint64_t options;
+	/*!< Combination of DPRC_CFG_OPT_ options */
+};
+
+/**
+ * @brief	Endpoint description for link connect/disconnect operations
+ */
+struct dprc_endpoint {
+	char type[16];
+	/*!< Endpoint object type: NULL terminated string */
+	int id;
+	/*!< Endpoint object id */
+	int interface_id;
+	/*!<
+	 * Interface id; should be set for endpoints with multiple interfaces
+	 * (DP_OBJ_DPSW, DP_OBJ_DPDMUX); for others, always set to 0.
+	 */
+};
+
+/**
+ * @brief	Obtains the container id associated with a given portal.
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[out]	container_id	Requested container ID
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_container_id(struct fsl_mc_io *mc_io, int *container_id);
+
+/**
+ * @brief	Opens a DPRC object for use
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	container_id	Container ID to open
+ * @param[out]	dprc_handle	Handle to the DPRC object
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ *
+ * @warning	Required before any operation on the object.
+ */
+int dprc_open(struct fsl_mc_io *mc_io, int container_id,
+	      uint16_t *dprc_handle);
+
+/**
+ * @brief	Closes the DPRC object handle
+ *
+ * No further operations on the object are allowed after this call without
+ * re-opening the object.
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_close(struct fsl_mc_io *mc_io, uint16_t dprc_handle);
+
+/**
+ * @brief	Creates a child container
+ *
+ * @param[in]   mc_io			Pointer to opaque I/O object
+ * @param[in]	dprc_handle		Handle to the DPRC object
+ * @param[in]	cfg			Child container configuration
+ * @param[out]	child_container_id	Child container ID
+ * @param[out]	child_portal_paddr	Base physical address of the
+ *				child portal
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_create_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  struct dprc_cfg *cfg,
+			  int *child_container_id,
+			  uint64_t *child_portal_paddr);
+
+/**
+ * @brief	Destroys a child container.
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
+ * @param[in]   mc_io			Pointer to opaque I/O object
+ * @param[in]	dprc_handle		Handle to the DPRC object
+ * @param[in]	child_container_id	ID of the container to destroy
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ *
+ * @warning	Only the parent container is allowed to destroy a child policy
+ *		Container 0 can't be destroyed
+ */
+int dprc_destroy_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			   int child_container_id);
+
+/**
+ * @brief	Sets allocation policy for a specific resource/object type in a
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
+ * @param[in]   mc_io		    Pointer to opaque I/O object
+ * @param[in]	dprc_handle	    Handle to the DPRC object
+ * @param[in]	child_container_id  ID of the child container
+ * @param[in]	type		    resource/object type
+ * @param[in]	quota		    Sets the maximum number of resources of
+ *				    the selected type that the child
+ *				    container is allowed to allocate
+ *				    from its parent;
+ *				    when quota is set to -1, the policy is
+ *				    the same as container's general policy.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ *
+ * @warning	Only the parent container is allowed to change a child policy.
+ */
+int dprc_set_res_quota(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int child_container_id, char *type, uint16_t quota);
+
+/**
+ * @brief	Gets the allocation policy of a specific resource/object type
+ *		in a child container
+ *
+ * @param[in]   mc_io			Pointer to opaque I/O object
+ * @param[in]	dprc_handle		Handle to the DPRC object
+ * @param[in]	child_container_id	ID of the child container
+ * @param[in]	type			resource/object type
+ * @param[out]	quota			Holds the maximum number of resources of
+ *					the selected type that the child
+ *					container is allowed to allocate from
+ *					the parent;
+ *					when quota is set to -1, the policy is
+ *					the same as container's general policy.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_res_quota(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int child_container_id, char *type, uint16_t *quota);
+
+/**
+ * @brief	Resets a child container.
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
+ * @param[in]   mc_io			Pointer to opaque I/O object
+ * @param[in]	dprc_handle		Handle to the DPRC object
+ * @param[in]	child_container_id	ID of the container to reset
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_reset_container(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			 int child_container_id);
+
+/**
+ * @brief	Assigns objects or resource to a child container.
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
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]	container_id	ID of the child container
+ * @param[in]	res_req		Describes the type and amount of resources to
+ *				assign to the given container.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_assign(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		int container_id, struct dprc_res_req *res_req);
+
+/**
+ * @brief	Un-assigns objects or resources from a child container
+ *		and moves them into this (parent) DPRC.
+ *
+ * Un-assignment of objects can succeed only if the object is not in the
+ * plugged or opened state.
+ *
+ * @param[in]   mc_io			Pointer to opaque I/O object
+ * @param[in]	dprc_handle		Handle to the DPRC object
+ * @param[in]	child_container_id	ID of the child container
+ * @param[in]	res_req			Describes the type and amount of
+ *					resources to un-assign from the child
+ *					container
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_unassign(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		  int child_container_id, struct dprc_res_req *res_req);
+
+/**
+ * @brief	Get the number of dprc's pools
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[out]  pool_count	Number of resource pools in the dprc.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_get_pool_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			int *pool_count);
+
+/**
+ * @brief	Get the type (string) of a certain dprc's pool
+ *
+ * The pool types retrieved one by one by incrementing
+ * pool_index up to (not including) the value of pool_count returned
+ * from dprc_get_pool_count(). dprc_get_pool_count() must
+ * be called prior to dprc_get_pool().
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   pool_index	Index of the pool to be queried (< pool_count)
+ * @param[out]  type		The type of the pool.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_get_pool(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		  int pool_index, char *type);
+
+/**
+ * @brief	Obtains the number of objects in the DPRC
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[out]	obj_count	Number of objects assigned to the DPRC
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_obj_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       int *obj_count);
+
+/**
+ * @brief	Obtains general information on an object
+ *
+ * The object descriptors are retrieved one by one by incrementing
+ * obj_index up to (not including) the value of obj_count returned
+ * from dprc_get_obj_count(). dprc_get_obj_count() must
+ * be called prior to dprc_get_obj().
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]	obj_index	Index of the object to be queried (< obj_count)
+ * @param[out]	obj_desc	Returns the requested object descriptor
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_obj(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 int obj_index, struct dprc_obj_desc *obj_desc);
+
+/**
+ * @brief	Obtains the number of free resources that are assigned
+ *		to this container, by pool type
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]	type		pool type
+ * @param[out]	res_count	Number of free resources of the given
+ *				resource type that are assigned to this DPRC
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_res_count(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		       char *type, int *res_count);
+
+/**
+ * @brief	Obtains IDs of free resources in the container
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]	type		pool type
+ * @param[in,out] range_desc	range descriptor
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_res_ids(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		     char *type, struct dprc_res_ids_range_desc *range_desc);
+
+/**
+ * @brief	Obtains the physical address of MC portals
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]	portal_id	MC portal id
+ * @param[out]  portal_addr	The physical address of the MC portal id
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_portal_paddr(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  int portal_id, uint64_t *portal_addr);
+
+/**
+ * @brief	Obtains container attributes
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[out]	attributes	Container attributes
+ *
+ * @returns     '0' on Success; Error code otherwise.
+ */
+int dprc_get_attributes(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			struct dprc_attributes *attributes);
+
+/**
+ * @brief	Returns region information for a specified object.
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]	obj_type	Object type as returned in dprc_get_obj()
+ * @param[in]	obj_id		Unique object instance as returned in
+ *				dprc_get_obj()
+ * @param[in]	region_index	The specific region to query
+ * @param[out]	region_desc	Returns the requested region descriptor
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_obj_region(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			char *obj_type,
+			int obj_id,
+			uint8_t region_index,
+			struct dprc_region_desc *region_desc);
+
+/**
+ * @brief	Sets IRQ information for the DPRC to trigger an interrupt.
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]	irq_index	Identifies the interrupt index to configure
+ *				DPRC supports only irq_index 0 - this interrupt
+ *				will be signaled on every change to
+ *				resource/object assignment in this DPRC.
+ * @param[in]	irq_paddr	Physical IRQ address that must be written to
+ *				signal a message-based interrupt
+ * @param[in]	irq_val		Value to write into irq_paddr address
+ * @param[in]	user_irq_id	A user defined number associated with this IRQ;
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_set_irq(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 uint8_t irq_index,
+		 uint64_t irq_paddr, uint32_t irq_val, int user_irq_id);
+
+/**
+ * @brief	Gets IRQ information from the DPRC.
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   irq_index	The interrupt index to configure;
+ *				DPRC supports only irq_index 0 - this interrupt
+ *				will be signaled on every change to
+ *				resource/object assignment in this DPRC.
+ * @param[out]  type		Interrupt type: 0 represents message interrupt
+ *				type (both irq_paddr and irq_val are valid);
+ * @param[out]	irq_paddr	Physical address that must be written in order
+ *				to signal the message-based interrupt
+ * @param[out]	irq_val		Value to write in order to signal the
+ *				message-based interrupt
+ * @param[out]	user_irq_id	A user defined number associated with this IRQ;
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_irq(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 uint8_t irq_index,
+		 int *type,
+		 uint64_t *irq_paddr, uint32_t *irq_val, int *user_irq_id);
+
+/**
+ * @brief	Sets overall interrupt state.
+ *
+ * Allows GPP software to control when interrupts are generated.
+ * Each interrupt can have up to 32 causes.  The enable/disable control's the
+ * overall interrupt state. if the interrupt is disabled no causes will cause an
+ * interrupt.
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   irq_index	The interrupt index to configure
+ * @param[in]	enable_state	Interrupt state - enable = 1, disable = 0.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_set_irq_enable(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint8_t enable_state);
+
+/**
+ * @brief	Gets overall interrupt state
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   irq_index	The interrupt index to configure
+ * @param[out]	enable_state	Interrupt state - enable = 1, disable = 0.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_irq_enable(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint8_t *enable_state);
+
+/**
+ * @brief	Sets interrupt mask.
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   irq_index	The interrupt index to configure
+ * @param[in]	mask		Event mask to trigger interrupt.
+ *				each bit:
+ *					0 = ignore event
+ *					1 = consider event for asserting irq
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_set_irq_mask(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		      uint8_t irq_index, uint32_t mask);
+
+/**
+ * @brief	Gets interrupt mask.
+ *
+ * Every interrupt can have up to 32 causes and the interrupt model supports
+ * masking/unmasking each cause independently
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   irq_index	The interrupt index to configure
+ * @param[out]	mask		Event mask to trigger interrupt
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ */
+int dprc_get_irq_mask(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		      uint8_t irq_index, uint32_t *mask);
+
+/**
+ * @brief	Gets the current status of any pending interrupts.
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   irq_index	The interrupt index to configure
+ * @param[out]	 status		Interrupts status - one bit per cause
+ *					0 = no interrupt pending
+ *					1 = interrupt pending
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_get_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			uint8_t irq_index, uint32_t *status);
+
+/**
+ * @brief	Clears a pending interrupt's status
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   irq_index	The interrupt index to configure
+ * @param[out]	status		Bits to clear (W1C) - one bit per cause
+ *					0 = don't change
+ *					1 = clear status bit
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_clear_irq_status(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+			  uint8_t irq_index, uint32_t status);
+
+/**
+ * @brief	Connects two endpoints to create a network link between them
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   endpoint1	Endpoint 1 configuration parameters.
+ * @param[in]	endpoint2	Endpoint 2 configuration parameters.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_connect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		 struct dprc_endpoint *endpoint1,
+		 struct dprc_endpoint *endpoint2);
+
+/**
+ * @brief	Disconnects one endpoint to remove its network link
+ *
+ * @param[in]   mc_io		Pointer to opaque I/O object
+ * @param[in]	dprc_handle	Handle to the DPRC object
+ * @param[in]   endpoint	Endpoint configuration parameters.
+ *
+ * @returns	'0' on Success; Error code otherwise.
+ * */
+int dprc_disconnect(struct fsl_mc_io *mc_io, uint16_t dprc_handle,
+		    struct dprc_endpoint *endpoint);
+
+/*! @} */
+
+#endif /* _FSL_DPRC_H */
diff --git a/include/linux/fsl_mc_cmd.h b/include/linux/fsl_mc_cmd.h
new file mode 100644
index 0000000..945c5a1
--- /dev/null
+++ b/include/linux/fsl_mc_cmd.h
@@ -0,0 +1,182 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef __FSL_MC_CMD_H
+#define __FSL_MC_CMD_H
+
+#include <linux/fsl_mc_sys.h>
+
+#ifdef FSL_MC_FIRMWARE
+/*
+ * MC firmware decodes MC command parameters and encodes MC response parameters
+ */
+
+#define MC_CMD_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
+	((_arg) = (_type)u64_dec((_cmd).params[_param], (_offset), (_width)))
+
+#define MC_RSP_PARAM_OP(_cmd, _param, _offset, _width, _type, _arg) \
+	((_cmd).params[_param] |= u64_enc((_offset), (_width), (_type)(_arg)))
+
+#else
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
+#endif /* FSL_MC_FIRMWARE */
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
+		iowrite64(cmd->params[i], &portal->params[i]);
+
+	/* submit the command by writing the header */
+	iowrite64(cmd->header, &portal->header);
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
+	resp->header = ioread64(&portal->header);
+	status = MC_CMD_HDR_READ_STATUS(resp->header);
+	if (status != MC_CMD_STATUS_OK)
+		return status;
+
+	/* Copy command response data from MC portal: */
+	for (i = 0; i < MC_CMD_NUM_OF_PARAMS; i++)
+		resp->params[i] = ioread64(&portal->params[i]);
+
+	return status;
+}
+
+#endif /* __FSL_MC_CMD_H */
diff --git a/include/linux/fsl_mc_sys.h b/include/linux/fsl_mc_sys.h
new file mode 100644
index 0000000..3233fdb
--- /dev/null
+++ b/include/linux/fsl_mc_sys.h
@@ -0,0 +1,81 @@
+/* Copyright 2013-2014 Freescale Semiconductor Inc.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *     * Redistributions of source code must retain the above copyright
+ *       notice, this list of conditions and the following disclaimer.
+ *     * Redistributions in binary form must reproduce the above copyright
+ *       notice, this list of conditions and the following disclaimer in the
+ *       documentation and/or other materials provided with the distribution.
+ *     * Neither the name of Freescale Semiconductor nor the
+ *       names of its contributors may be used to endorse or promote products
+ *       derived from this software without specific prior written permission.
+ *
+ *
+ * ALTERNATIVELY, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") as published by the Free Software
+ * Foundation, either version 2 of that License or (at your option) any
+ * later version.
+ *
+ * THIS SOFTWARE IS PROVIDED BY Freescale Semiconductor ``AS IS'' AND ANY
+ * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
+ * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
+ * DISCLAIMED. IN NO EVENT SHALL Freescale Semiconductor BE LIABLE FOR ANY
+ * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
+ * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
+ * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
+ * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ */
+
+#ifndef _FSL_MC_SYS_H
+#define _FSL_MC_SYS_H
+
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/io.h>
+#include <linux/spinlock_types.h>
+
+#ifndef ENOTSUP
+#define ENOTSUP		95
+#endif
+
+#define ioread64(_p)	    readq(_p)
+#define iowrite64(_v, _p)   writeq(_v, _p)
+
+/**
+ * Bit masks for a MC I/O object (struct fsl_mc_io) flags
+ */
+#define FSL_MC_IO_PORTAL_SHARED	0x0001
+
+struct mc_command;
+
+/**
+ * struct fsl_mc_io - MC I/O object to be passed-in to mc_send_command()
+ * @magic: marker to verify identity of this structure
+ * @flags: flags for mc_send_command()
+ * @portal_size: MC command portal size in bytes
+ * @portal_phys_addr: MC command portal physical address
+ * @portal_virt_addr: MC command portal virtual address
+ * @spinlock: spin lock to serialize access to the MC command portal
+ */
+struct fsl_mc_io {
+#	define FSL_MC_IO_MAGIC	0x434d4f49
+	uint32_t magic;
+	uint32_t flags;
+	uint32_t portal_size;
+	phys_addr_t portal_phys_addr;
+	void __iomem *portal_virt_addr;
+	spinlock_t spinlock;	/* serializes commands on the same MC portal */
+};
+
+int __must_check fsl_create_mc_io(phys_addr_t mc_portal_phys_addr,
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

