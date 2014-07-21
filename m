Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaGUGGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:06:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:27135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbaGUGG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:06:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="576278993"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 02/14] ACPI/EC: Add detailed command/query debugging information.
Date: Mon, 21 Jul 2014 14:05:12 +0800
Message-Id: <f9cb0b5cce39f663082e25133261f7b9b4836622.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Developers really don't need to translate EC commands in mind. This patch
adds detailed debugging information for the EC commands.
The address can be found in the follow-up sequential EC_DATA(W) accesses,
thus this patch also removes some of the redundant address information.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 drivers/acpi/ec.c |   29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 28ce2cd..54bebbb 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -175,6 +175,27 @@ static inline void acpi_ec_write_data(struct acpi_ec *ec, u8 data)
 	outb(data, ec->data_addr);
 }
 
+#ifdef DEBUG
+static const char *acpi_ec_cmd_string(u8 cmd)
+{
+	switch (cmd) {
+	case 0x80:
+		return "RD_EC";
+	case 0x81:
+		return "WR_EC";
+	case 0x82:
+		return "BE_EC";
+	case 0x83:
+		return "BD_EC";
+	case 0x84:
+		return "QR_EC";
+	}
+	return "UNKNOWN";
+}
+#else
+#define acpi_ec_cmd_string(cmd)		"UNDEF"
+#endif
+
 static int ec_transaction_completed(struct acpi_ec *ec)
 {
 	unsigned long flags;
@@ -302,16 +323,16 @@ static int acpi_ec_transaction_unlocked(struct acpi_ec *ec,
 	}
 	/* following two actions should be kept atomic */
 	ec->curr = t;
-	pr_debug("***** transaction started (cmd=0x%02x, addr=0x%02x) *****\n",
-		 t->command, t->wdata ? t->wdata[0] : 0);
+	pr_debug("***** Command(%s) started *****\n",
+		 acpi_ec_cmd_string(t->command));
 	start_transaction(ec);
 	if (ec->curr->command == ACPI_EC_COMMAND_QUERY)
 		clear_bit(EC_FLAGS_QUERY_PENDING, &ec->flags);
 	spin_unlock_irqrestore(&ec->lock, tmp);
 	ret = ec_poll(ec);
 	spin_lock_irqsave(&ec->lock, tmp);
-	pr_debug("***** transaction stopped (cmd=0x%02x, addr=0x%02x) *****\n",
-		 t->command, t->wdata ? t->wdata[0] : 0);
+	pr_debug("***** Command(%s) stopped *****\n",
+		 acpi_ec_cmd_string(t->command));
 	ec->curr = NULL;
 unlock:
 	spin_unlock_irqrestore(&ec->lock, tmp);
-- 
1.7.10

