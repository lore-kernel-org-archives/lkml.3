Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaJATMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:12:34 -0400
Received: from mail-bn1bon0099.outbound.protection.outlook.com ([157.56.111.99]:28352
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751142AbaJATMH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:12:07 -0400
From: <atull@opensource.altera.com>
To: <linux@roeck-us.net>, <jdelvare@suse.de>
CC: <lm-sensors@lm-sensors.org>, <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <robh+dt@kernel.org>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <ijc+devicetree@hellion.org.uk>, <galak@codeaurora.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <delicious.quinoa@gmail.com>, <dinguyen@opensource.altera.com>,
        <yvanderv@opensource.altera.com>,
        Alan Tull <atull@opensource.altera.com>
Subject: [PATCH v4 2/4] pmbus: core: add helpers for byte write and read modify write
Date: Wed, 1 Oct 2014 14:05:48 -0500
Message-ID: <1412190349-16343-3-git-send-email-atull@opensource.altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
References: <1412190349-16343-1-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: BN1PR02CA0022.namprd02.prod.outlook.com (10.141.56.22) To
 DM2PR03MB318.namprd03.prod.outlook.com (10.141.54.17)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:DM2PR03MB318;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(189002)(199003)(4396001)(20776003)(64706001)(47776003)(88136002)(80022003)(85852003)(50466002)(50226001)(48376002)(77156001)(33646002)(229853001)(107046002)(66066001)(87976001)(87286001)(76482002)(89996001)(42186005)(105586002)(81156004)(69596002)(106356001)(102836001)(53416004)(99396003)(86362001)(120916001)(85306004)(86152002)(62966002)(92726001)(92566001)(10300001)(21056001)(93916002)(101416001)(97736003)(77096002)(50986999)(46102003)(19580405001)(95666004)(31966008)(76176999)(104166001)(19580395003);DIR:OUT;SFP:1101;SCL:1;SRVR:DM2PR03MB318;H:atx-linux-37.altera.com;FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
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

