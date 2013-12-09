Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab3LICu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 21:50:57 -0500
Received: from mail-by2lp0238.outbound.protection.outlook.com ([207.46.163.238]:10361
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760308Ab3LICuz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 21:50:55 -0500
X-Greylist: delayed 869 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Dec 2013 21:50:55 EST
From: "yibin.gong@freescale.com" <yibin.gong@freescale.com>
To: Jingoo Han <jg1.han@samsung.com>, "'Mark Brown'" <broonie@kernel.org>
CC: "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yibin.gong@freescale.com" <yibin.gong@freescale.com>,
        "'Axel Lin'" <axel.lin@ingics.com>,
        "'Tim Harvey'" <tharvey@gateworks.com>
Subject: RE: [PATCH 5/6] regulator: pfuze100: use devm_regulator_register()
Thread-Topic: [PATCH 5/6] regulator: pfuze100: use devm_regulator_register()
Thread-Index: Ac7yUb+lAqO9MkXdRJaD6VTAoDhw9gAAId0AAI02HrA=
Date: Mon, 9 Dec 2013 02:36:22 +0000
Message-ID: <fdaa8cf7f6404ef3a7199907a09f0bee@BLUPR03MB036.namprd03.prod.outlook.com>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
 <000e01cef252$7423b3e0$5c6b1ba0$%han@samsung.com>
In-Reply-To: <000e01cef252$7423b3e0$5c6b1ba0$%han@samsung.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [192.88.158.216]
x-forefront-prvs: 00550ABE1F
x-forefront-antispam-report: SFV:NSPM;SFS:(13464003)(199002)(189002)(377454003)(83322001)(19580395003)(81542001)(76786001)(33646001)(76796001)(77096001)(74316001)(81342001)(81816001)(85852002)(56816005)(80976001)(76576001)(87266001)(2656002)(19580405001)(87936001)(90146001)(74366001)(69226001)(49866001)(47736001)(4396001)(79102001)(46102001)(74706001)(80022001)(66066001)(74876001)(65816001)(83072001)(76482001)(54356001)(56776001)(53806001)(47976001)(50986001)(59766001)(54316002)(31966008)(74662001)(85306002)(81686001)(74502001)(47446002)(77982001)(51856001)(63696002)(24736002);DIR:OUT;SFP:;SCL:1;SRVR:BLUPR03MB034;H:BLUPR03MB036.namprd03.prod.outlook.com;CLIP:192.88.158.216;FPR:;RD:InfoNoRecords;A:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Robin Gong <b38343@freescale.com>
	
-----Original Message-----
From: Jingoo Han [mailto:jg1.han@samsung.com] 
Sent: Friday, December 06, 2013 3:12 PM
To: 'Mark Brown'
Cc: 'Liam Girdwood'; linux-kernel@vger.kernel.org; 'Jingoo Han'; Gong Yibin-B38343; 'Axel Lin'; 'Tim Harvey'
Subject: [PATCH 5/6] regulator: pfuze100: use devm_regulator_register()

Use devm_regulator_register() to make cleanup paths simpler, and remove unnecessary remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/pfuze100-regulator.c |   20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index 032df37..50c1bf8 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -408,31 +408,18 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		config.driver_data = pfuze_chip;
 		config.of_node = match_of_node(i);
 
-		pfuze_chip->regulators[i] = regulator_register(desc, &config);
+		pfuze_chip->regulators[i] =
+			devm_regulator_register(&client->dev, desc, &config);
 		if (IS_ERR(pfuze_chip->regulators[i])) {
 			dev_err(&client->dev, "register regulator%s failed\n",
 				pfuze100_regulators[i].desc.name);
-			ret = PTR_ERR(pfuze_chip->regulators[i]);
-			while (--i >= 0)
-				regulator_unregister(pfuze_chip->regulators[i]);
-			return ret;
+			return PTR_ERR(pfuze_chip->regulators[i]);
 		}
 	}
 
 	return 0;
 }
 
-static int pfuze100_regulator_remove(struct i2c_client *client) -{
-	int i;
-	struct pfuze_chip *pfuze_chip = i2c_get_clientdata(client);
-
-	for (i = 0; i < PFUZE100_MAX_REGULATOR; i++)
-		regulator_unregister(pfuze_chip->regulators[i]);
-
-	return 0;
-}
-
 static struct i2c_driver pfuze_driver = {
 	.id_table = pfuze_device_id,
 	.driver = {
@@ -441,7 +428,6 @@ static struct i2c_driver pfuze_driver = {
 		.of_match_table = pfuze_dt_ids,
 	},
 	.probe = pfuze100_regulator_probe,
-	.remove = pfuze100_regulator_remove,
 };
 module_i2c_driver(pfuze_driver);
 
--
1.7.10.4



