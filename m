Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaGGDKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 23:10:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:29915 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752958AbaGGDKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 23:10:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,615,1400050800"; 
   d="scan'208";a="453851856"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [UPDATE PATCH v2 6/6] ACPI/EC: Add detailed fields debugging support of EC_SC(R).
Date: Mon,  7 Jul 2014 11:10:35 +0800
Message-Id: <905b534e43bc72c2f15a699fd93d8e64144680ab.1404700569.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404700569.git.lv.zheng@intel.com>
References: <cover.1402792240.git.lv.zheng@intel.com> <cover.1404700569.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Developers really don't need to translate EC_SC(R) in mind as long as the
field details are decoded in the debugging message.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
Tested-by: Gareth Williams <gareth@garethwilliams.me.uk>
Tested-by: Hans de Goede <jwrdegoede@fedoraproject.org>
Tested-by: Steffen Weber <steffen.weber@gmail.com>
Tested-by: Arthur Chen <axchen@nvidia.com>
---
 drivers/acpi/ec.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 051ac47..c3299f6 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -55,6 +55,7 @@
 /* EC status register */
 #define ACPI_EC_FLAG_OBF	0x01	/* Output buffer full */
 #define ACPI_EC_FLAG_IBF	0x02	/* Input buffer full */
+#define ACPI_EC_FLAG_CMD	0x08	/* Input buffer contains a command */
 #define ACPI_EC_FLAG_BURST	0x10	/* burst mode */
 #define ACPI_EC_FLAG_SCI	0x20	/* EC-SCI occurred */
 
@@ -133,26 +134,33 @@ static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 static inline u8 acpi_ec_read_status(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->command_addr);
-	pr_debug("---> status = 0x%2.2x\n", x);
+	pr_debug("EC_SC(R) = 0x%2.2x "
+		 "SCI_EVT=%d BURST=%d CMD=%d IBF=%d OBF=%d\n",
+		 x,
+		 !!(x & ACPI_EC_FLAG_SCI),
+		 !!(x & ACPI_EC_FLAG_BURST),
+		 !!(x & ACPI_EC_FLAG_CMD),
+		 !!(x & ACPI_EC_FLAG_IBF),
+		 !!(x & ACPI_EC_FLAG_OBF));
 	return x;
 }
 
 static inline u8 acpi_ec_read_data(struct acpi_ec *ec)
 {
 	u8 x = inb(ec->data_addr);
-	pr_debug("---> data = 0x%2.2x\n", x);
+	pr_debug("EC_DATA(R) = 0x%2.2x\n", x);
 	return x;
 }
 
 static inline void acpi_ec_write_cmd(struct acpi_ec *ec, u8 command)
 {
-	pr_debug("<--- command = 0x%2.2x\n", command);
+	pr_debug("EC_SC(W) = 0x%2.2x\n", command);
 	outb(command, ec->command_addr);
 }
 
 static inline void acpi_ec_write_data(struct acpi_ec *ec, u8 data)
 {
-	pr_debug("<--- data = 0x%2.2x\n", data);
+	pr_debug("EC_DATA(W) = 0x%2.2x\n", data);
 	outb(data, ec->data_addr);
 }
 
-- 
1.7.10

