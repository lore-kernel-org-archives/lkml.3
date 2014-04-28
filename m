Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932599AbaD1PfE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:35:04 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:49251 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756694AbaD1PPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:15:36 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>
Subject: [PATCH V3 16/20] bus: omap_l3_noc: add information about the type of operation
Date: Mon, 28 Apr 2014 10:14:56 -0500
Message-ID: <1398698101-25513-17-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398698101-25513-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
 <1398698101-25513-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today we get error such as
L3 Custom Error: MASTER MPU TARGET L4PER2

But since the actual instruction triggerring the error Vs the point
at which we report error may not be aligned, it makes sense to try
and provide additional information - example the type of operation
that was attempted to being performed can help narrow the debug down
further.

This helps provide log such as:
L3 Custom Error: MASTER MPU TARGET L4PER2 (Read)

Signed-off-by: Nishanth Menon <nm@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Tested-by: Darren Etheridge <detheridge@ti.com>
---
V3: no change
 drivers/bus/omap_l3_noc.c |    9 ++++++++-
 drivers/bus/omap_l3_noc.h |   13 +++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
index 00e4fed..9d021d0 100644
--- a/drivers/bus/omap_l3_noc.c
+++ b/drivers/bus/omap_l3_noc.c
@@ -60,8 +60,10 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 {
 	int k;
 	u32 std_err_main, clear, masterid;
+	u8 op_code;
 	void __iomem *l3_targ_base;
 	void __iomem *l3_targ_stderr, *l3_targ_slvofslsb, *l3_targ_mstaddr;
+	void __iomem *l3_targ_hdr;
 	struct l3_target_data *l3_targ_inst;
 	struct l3_masters_data *master;
 	char *target_name, *master_name = "UN IDENTIFIED";
@@ -96,6 +98,7 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 			 readl_relaxed(l3_targ_slvofslsb));
 
 		l3_targ_mstaddr = l3_targ_base + L3_TARG_STDERRLOG_MSTADDR;
+		l3_targ_hdr = l3_targ_base + L3_TARG_STDERRLOG_HDR;
 		break;
 
 	case CUSTOM_ERROR:
@@ -103,6 +106,7 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 
 		l3_targ_mstaddr = l3_targ_base +
 				  L3_TARG_STDERRLOG_CINFO_MSTADDR;
+		l3_targ_hdr = l3_targ_base + L3_TARG_STDERRLOG_CINFO_OPCODE;
 		break;
 
 	default:
@@ -122,11 +126,14 @@ static int l3_handle_target(struct omap_l3 *l3, void __iomem *base,
 		}
 	}
 
+	op_code = readl_relaxed(l3_targ_hdr) & 0x7;
+
 	WARN(true,
-	     "%s:L3 %s Error: MASTER %s TARGET %s%s\n",
+	     "%s:L3 %s Error: MASTER %s TARGET %s (%s)%s\n",
 	     dev_name(l3->dev),
 	     err_description,
 	     master_name, target_name,
+	     l3_transaction_type[op_code],
 	     err_string);
 
 	/* clear the std error log*/
diff --git a/drivers/bus/omap_l3_noc.h b/drivers/bus/omap_l3_noc.h
index 4e18307..6670fd9 100644
--- a/drivers/bus/omap_l3_noc.h
+++ b/drivers/bus/omap_l3_noc.h
@@ -29,14 +29,27 @@
 
 /* L3 TARG register offsets */
 #define L3_TARG_STDERRLOG_MAIN		0x48
+#define L3_TARG_STDERRLOG_HDR		0x4c
 #define L3_TARG_STDERRLOG_MSTADDR	0x50
 #define L3_TARG_STDERRLOG_SLVOFSLSB	0x5c
 #define L3_TARG_STDERRLOG_CINFO_MSTADDR	0x68
+#define L3_TARG_STDERRLOG_CINFO_OPCODE	0x6c
 #define L3_FLAGMUX_REGERR0		0xc
 #define L3_FLAGMUX_MASK0		0x8
 
 #define L3_TARGET_NOT_SUPPORTED		NULL
 
+static const char * const l3_transaction_type[] = {
+	/* 0 0 0 */ "Idle",
+	/* 0 0 1 */ "Write",
+	/* 0 1 0 */ "Read",
+	/* 0 1 1 */ "ReadEx",
+	/* 1 0 0 */ "Read Link",
+	/* 1 0 1 */ "Write Non-Posted",
+	/* 1 1 0 */ "Write Conditional",
+	/* 1 1 1 */ "Write Broadcast",
+};
+
 /**
  * struct l3_masters_data - L3 Master information
  * @id:		ID of the L3 Master
-- 
1.7.9.5

