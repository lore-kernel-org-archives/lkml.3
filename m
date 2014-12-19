Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaLSJ4A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 04:56:00 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48810 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752242AbaLSJz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 04:55:57 -0500
From: Sanchayan Maity <maitysanchayan@gmail.com>
To: Peter.Chen@freescale.com
Cc: stefan@agner.ch, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sanchayan Maity <maitysanchayan@gmail.com>
Subject: [PATCH 2/3] usb: chipidea: Add chipidea revision information
Date: Fri, 19 Dec 2014 15:25:28 +0530
Message-Id: <1da552d2284380f8606bd16d1d3c0cf51caa60ff.1418981438.git.maitysanchayan@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1418981438.git.maitysanchayan@gmail.com>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
In-Reply-To: <cover.1418981438.git.maitysanchayan@gmail.com>
References: <cover.1418981438.git.maitysanchayan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define ci_get_revision API to know the controller revision
information according to chipidea 1.1a, 2.0a, 2.4 and 2.5a
spec. Besides, add one entry in struct ci_hdrc to indicate
revision information. This can be used for adding different
code for revisions, implementing erratas.

Signed-off-by: Sanchayan Maity <maitysanchayan@gmail.com>
---
 drivers/usb/chipidea/bits.h |   10 ++++++++++
 drivers/usb/chipidea/core.c |   23 +++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/chipidea/bits.h b/drivers/usb/chipidea/bits.h
index ca57e3d..e935ccc 100644
--- a/drivers/usb/chipidea/bits.h
+++ b/drivers/usb/chipidea/bits.h
@@ -15,6 +15,16 @@
 
 #include <linux/usb/ehci_def.h>
 
+/*
+ * ID
+ * For 1.x revision, bit24 - bit31 are reserved
+ * For 2.x revision, bit25 - bit28 are 0x2
+ */
+#define TAG			(0x1F << 16)
+#define REVISION		(0xF << 21)
+#define VERSION			(0xF << 25)
+#define CIVERSION		(0x7 << 29)
+
 /* HCCPARAMS */
 #define HCCPARAMS_LEN         BIT(17)
 
diff --git a/drivers/usb/chipidea/core.c b/drivers/usb/chipidea/core.c
index 9bdc6bd..33a8c4a 100644
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -136,6 +136,22 @@ static int hw_alloc_regmap(struct ci_hdrc *ci, bool is_lpm)
 	return 0;
 }
 
+static enum CI_REVISION ci_get_revision(struct ci_hdrc *ci)
+{
+	int ver = hw_read_id_reg(ci, ID_ID, VERSION) >> __ffs(VERSION);
+	enum CI_REVISION rev = CI_REVISION_UNKNOWN;
+
+	if (ver == 0x2) {
+		int rev_reg = hw_read_id_reg
+			(ci, ID_ID, REVISION) >> __ffs(REVISION);
+		rev = rev_reg + CI_REVISION_20;
+	} else if (ver == 0x0) {
+		rev = CI_REVISION_1X;
+	}
+
+	return rev;
+}
+
 /**
  * hw_read_intr_enable: returns interrupt enable register
  *
@@ -245,8 +261,11 @@ static int hw_device_init(struct ci_hdrc *ci, void __iomem *base)
 	/* Clear all interrupts status bits*/
 	hw_write(ci, OP_USBSTS, 0xffffffff, 0xffffffff);
 
-	dev_dbg(ci->dev, "ChipIdea HDRC found, lpm: %d; cap: %p op: %p\n",
-		ci->hw_bank.lpm, ci->hw_bank.cap, ci->hw_bank.op);
+	ci->rev = ci_get_revision(ci);
+
+	dev_dbg(ci->dev,
+		"ChipIdea HDRC found, revision: %d, lpm: %d; cap: %p op: %p\n",
+		ci->rev, ci->hw_bank.lpm, ci->hw_bank.cap, ci->hw_bank.op);
 
 	/* setup lock mode ? */
 
-- 
1.7.9.5

