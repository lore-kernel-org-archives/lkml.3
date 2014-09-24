Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628AbaIXSVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 14:21:12 -0400
Received: from mail-bn1bon0066.outbound.protection.outlook.com ([157.56.111.66]:7344
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752897AbaIXSVK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 14:21:10 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <linux-kernel@vger.kernel.org>, <delicious.quinoa@gmail.com>,
        <dinguyen@opensource.altera.com>, <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v3 1/3] pmbus: core: add helpers for byte write and read modify write
Date: Wed, 24 Sep 2014 12:57:54 -0500
Message-ID: <1411581476-12222-2-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
References: <1411581476-12222-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0046.namprd02.prod.outlook.com (10.141.56.46) To
 BLUPR03MB312.namprd03.prod.outlook.com (10.141.48.28)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BLUPR03MB312;
X-Forefront-PRVS: 03449D5DD1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(4396001)(50226001)(19580405001)(83322001)(19580395003)(87976001)(69596002)(50466002)(77156001)(102836001)(42186005)(48376002)(10300001)(50986999)(104166001)(62966002)(85306004)(105586002)(76176999)(97736003)(106356001)(88136002)(81542003)(47776003)(20776003)(87286001)(101416001)(77096002)(76482002)(120916001)(93916002)(86362001)(85852003)(86152002)(79102003)(90102001)(107046002)(92566001)(53416004)(66066001)(74662003)(31966008)(77982003)(33646002)(89996001)(81156004)(81342003)(21056001)(92726001)(64706001)(80022003)(229853001)(95666004)(99396003)(46102003)(74502003)(83072002);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR03MB312;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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
 drivers/hwmon/pmbus/pmbus_core.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

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

