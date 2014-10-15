Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaJOTBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:01:54 -0400
Received: from mail-bl2on0057.outbound.protection.outlook.com ([65.55.169.57]:38336
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751890AbaJOTBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:01:51 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v6 2/4] pmbus: core: add helpers for byte write and read modify write
Date: Wed, 15 Oct 2014 13:55:08 -0500
Message-ID: <1413399310-19277-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
References: <1413399310-19277-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BLUPR08CA0047.namprd08.prod.outlook.com (10.141.200.27) To
 BY2PR03MB315.namprd03.prod.outlook.com (10.141.139.25)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BY2PR03MB315;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(199003)(189002)(86362001)(77156001)(104166001)(76176999)(31966008)(21056001)(85852003)(89996001)(86152002)(101416001)(19580395003)(48376002)(19580405001)(87286001)(50466002)(92726001)(69596002)(92566001)(50986999)(62966002)(33646002)(87976001)(95666004)(99396003)(20776003)(64706001)(105586002)(120916001)(77096002)(102836001)(50226001)(229853001)(122386002)(107046002)(4396001)(106356001)(80022003)(53416004)(66066001)(97736003)(85306004)(46102003)(42186005)(81156004)(76482002)(40100003);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB315;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;A:0;MX:1;LANG:en;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Tull <atull@opensource.altera.com>

Add two helper functions:
 * pmbus_write_byte_data  = paged byte write
 * pmbus_update_byte_data = paged byte read/modify/write

Signed-off-by: Alan Tull <atull@opensource.altera.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Mark Brown <broonie@kernel.org>
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

