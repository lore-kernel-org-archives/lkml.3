Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaJBSoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 14:44:37 -0400
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:43410
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751922AbaJBSoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 14:44:09 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v5 2/4] pmbus: core: add helpers for byte write and read modify write
Date: Thu, 2 Oct 2014 13:37:49 -0500
Message-ID: <1412275071-6417-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
References: <1412275071-6417-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BY2PR06CA048.namprd06.prod.outlook.com (10.141.250.166) To
 BL2PR03MB305.namprd03.prod.outlook.com (10.141.68.13)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB305;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(62966002)(77156001)(81156004)(85852003)(89996001)(120916001)(105586002)(77096002)(107046002)(76482002)(106356001)(31966008)(10300001)(88136002)(87286001)(20776003)(47776003)(99396003)(64706001)(87976001)(101416001)(33646002)(21056001)(229853001)(66066001)(104166001)(93916002)(86362001)(53416004)(102836001)(97736003)(69596002)(42186005)(50466002)(92726001)(48376002)(95666004)(46102003)(80022003)(85306004)(50226001)(92566001)(50986999)(76176999)(4396001)(86152002)(19580405001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB305;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add two helper functions:
 * pmbus_write_byte_data  = paged byte write
 * pmbus_update_byte_data = paged byte read/modify/write

Signed-off-by: Alan Tull <atull@opensource.altera.com>
---
v2: add prototypes for the two new functions
---
 drivers/hwmon/pmbus/pmbus.h      |    4 ++++
 drivers/hwmon/pmbus/pmbus_core.c |   31 +++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/drivers/hwmon/pmbus/pmbus.h b/drivers/hwmon/pmbus/pmbus.h
index fa9beb3..3ae79a7 100644
--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -375,6 +375,10 @@ int pmbus_read_word_data(struct i2c_client *client, u8 page, u8 reg);
 int pmbus_write_word_data(struct i2c_client *client, u8 page, u8 reg, u16 word);
 int pmbus_read_byte_data(struct i2c_client *client, int page, u8 reg);
 int pmbus_write_byte(struct i2c_client *client, int page, u8 value);
+int pmbus_write_byte_data(struct i2c_client *client, int page, u8 reg,
+			  u8 value);
+int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
+			   u8 mask, u8 value);
 void pmbus_clear_faults(struct i2c_client *client);
 bool pmbus_check_byte_register(struct i2c_client *client, int page, int reg);
 bool pmbus_check_word_register(struct i2c_client *client, int page, int reg);
diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 291d11f..d6c3701 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -253,6 +253,37 @@ int pmbus_read_byte_data(struct i2c_client *client, int page, u8 reg)
 }
 EXPORT_SYMBOL_GPL(pmbus_read_byte_data);
 
+int pmbus_write_byte_data(struct i2c_client *client, int page, u8 reg, u8 value)
+{
+	int rv;
+
+	rv = pmbus_set_page(client, page);
+	if (rv < 0)
+		return rv;
+
+	return i2c_smbus_write_byte_data(client, reg, value);
+}
+EXPORT_SYMBOL_GPL(pmbus_write_byte_data);
+
+int pmbus_update_byte_data(struct i2c_client *client, int page, u8 reg,
+			   u8 mask, u8 value)
+{
+	unsigned int tmp;
+	int rv;
+
+	rv = pmbus_read_byte_data(client, page, reg);
+	if (rv < 0)
+		return rv;
+
+	tmp = (rv & ~mask) | (value & mask);
+
+	if (tmp != rv)
+		rv = pmbus_write_byte_data(client, page, reg, tmp);
+
+	return rv;
+}
+EXPORT_SYMBOL_GPL(pmbus_update_byte_data);
+
 /*
  * _pmbus_read_byte_data() is similar to pmbus_read_byte_data(), but checks if
  * a device specific mapping function exists and calls it if necessary.
-- 
1.7.9.5

