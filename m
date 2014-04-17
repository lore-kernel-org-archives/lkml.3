Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaDQUwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 16:52:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:40726 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaDQUu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 16:50:28 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>
CC: Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH V2 16/19] bus: omap_l3_noc: Add information about the context of operation
Date: Thu, 17 Apr 2014 15:49:32 -0500
Message-ID: <1397767775-10965-17-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397767775-10965-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1397767775-10965-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

L3 error may be triggered using Debug interface (example JTAG) or
due to other errors, for example an opcode fetch (due to function
pointer or stack corruption) or a data access (due to some other
failure). NOC registers contain additional information to help aid
debug information.

With this, we can enhance the error information to more detailed form:
"
L3 Custom Error: MASTER MPU TARGET L4PER2 (Read): Data Access in User mode
during Functional access
"

Signed-off-by: Nishanth Menon <nm@ti.com>
---
New Patch

 drivers/bus/omap_l3_noc.c |   18 ++++++++++++++----
 drivers/bus/omap_l3_noc.h |    2 ++
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 0beefb3..9e68d6b 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -60,15 +60,16 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 {
 	int k;
 	u32 std_err_main, clear, masterid;
-	u8 op_code;
+	u8 op_code, m_req_info;
 	void __iomem *l3_targ_base;
 	void __iomem *l3_targ_stderr, *l3_targ_slvofslsb, *l3_targ_mstaddr;
-	void __iomem *l3_targ_hdr;
+	void __iomem *l3_targ_hdr, *l3_targ_info;
 	struct l3_target_data *l3_targ_inst;
 	struct l3_masters_data *master;
 	char *target_name, *master_name = "UN IDENTIFIED";
 	char *err_description;
 	char err_string[30] = { 0 };
+	char info_string[60] = { 0 };
 
 	/* We DONOT expect err_src to go out of bounds */
 	BUG_ON(err_src > MAX_CLKDM_TARGETS);
@@ -99,6 +100,7 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 
 		l3_targ_mstaddr = l3_targ_base + L3_TARG_STDERRLOG_MSTADDR;
 		l3_targ_hdr = l3_targ_base + L3_TARG_STDERRLOG_HDR;
+		l3_targ_info = l3_targ_base + L3_TARG_STDERRLOG_INFO;
 		break;
 
 	case CUSTOM_ERROR:
@@ -107,6 +109,7 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 		l3_targ_mstaddr = l3_targ_base +
 				  L3_TARG_STDERRLOG_CINFO_MSTADDR;
 		l3_targ_hdr = l3_targ_base + L3_TARG_STDERRLOG_CINFO_OPCODE;
+		l3_targ_info = l3_targ_base + L3_TARG_STDERRLOG_CINFO_INFO;
 		break;
 
 	default:
@@ -132,13 +135,20 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 
 	op_code = readl_relaxed(l3_targ_hdr) & 0x7;
 
+	m_req_info = readl_relaxed(l3_targ_info) & 0xF;
+	snprintf(info_string, sizeof(info_string),
+		 ": %s in %s mode during %s access",
+		 (m_req_info & BIT(0)) ? "Opcode Fetch" : "Data Access",
+		 (m_req_info & BIT(1)) ? "Supervisor" : "User",
+		 (m_req_info & BIT(3)) ? "Debug" : "Functional");
+
 	WARN(true,
-	     "%s:L3 %s Error: MASTER %s TARGET %s (%s)%s\n",
+	     "%s:L3 %s Error: MASTER %s TARGET %s (%s)%s%s\n",
 	     dev_name(l3->dev),
 	     err_description,
 	     master_name, target_name,
 	     l3_transaction_type[op_code],
-	     err_string);
+	     err_string, info_string);
 
 	/* clear the std error log*/
 	clear = std_err_main | CLEAR_STDERR_LOG;
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index 8efde7f..49258bb 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -31,7 +31,9 @@
 #define L3_TARG_STDERRLOG_MAIN		0x48
 #define L3_TARG_STDERRLOG_HDR		0x4c
 #define L3_TARG_STDERRLOG_MSTADDR	0x50
+#define L3_TARG_STDERRLOG_INFO		0x58
 #define L3_TARG_STDERRLOG_SLVOFSLSB	0x5c
+#define L3_TARG_STDERRLOG_CINFO_INFO	0x64
 #define L3_TARG_STDERRLOG_CINFO_MSTADDR	0x68
 #define L3_TARG_STDERRLOG_CINFO_OPCODE	0x6c
 #define L3_FLAGMUX_REGERR0		0xc
-- 
1.7.9.5

