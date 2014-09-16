Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaIPTza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:55:30 -0400
Received: from mail-bl2on0132.outbound.protection.outlook.com ([65.55.169.132]:19104
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750720AbaIPTz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:55:28 -0400
X-WSS-ID: 0NC0ENF-08-IZ2-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <linux@roeck-us.net>,
        <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: <boris.ostrovsky@oracle.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH V2 1/2] hwmon, fam15h_power: Make actual power reporting conditional
Date: Tue, 16 Sep 2014 14:58:04 -0500
Message-ID: <1410897484-2526-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.222;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(199003)(43544003)(189002)(86362001)(89996001)(19580395003)(77096002)(93916002)(50986999)(88136002)(99396002)(31966008)(47776003)(36756003)(83322001)(102836001)(92726001)(48376002)(105586002)(85852003)(229853001)(15395725005)(21056001)(50226001)(83072002)(4396001)(104166001)(106466001)(107046002)(84676001)(90102001)(2201001)(87286001)(64706001)(50466002)(92566001)(15975445006)(53416004)(77156001)(15202345003)(20776003)(85306004)(87936001)(62966002)(77982003)(80022003)(44976005)(81342003)(74502003)(76482001)(74662003)(101416001)(19580405001)(79102003)(81542003)(46102003)(97736003)(68736004)(95666004)(2101003)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:BL2PR02MB483;H:atltwp02.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.222)
 smtp.mailfrom=Aravind.Gopalakrishnan@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

power1_input should only be reported for Fam15h, Models 00h-0fh
So, introduce a is_visible function to take care of this.

As suggested by Guenter here:
http://marc.info/?l=linux-kernel&m=141038145616437&w=2

Suggested-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
---
 drivers/hwmon/fam15h_power.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 4a7cbfa..4ee0126 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -93,13 +93,29 @@ static ssize_t show_power_crit(struct device *dev,
 }
 static DEVICE_ATTR(power1_crit, S_IRUGO, show_power_crit, NULL);
 
+static umode_t fam15h_power_is_visible(struct kobject *kobj,
+				       struct attribute *attr,
+				       int index)
+{
+	/* power1_input is only reported for Fam15h, Models 00h-0fh */
+	if (attr == &dev_attr_power1_input.attr &&
+	   (boot_cpu_data.x86 != 0x15 || boot_cpu_data.x86_model > 0xf))
+		return 0;
+
+	return attr->mode;
+}
+
 static struct attribute *fam15h_power_attrs[] = {
 	&dev_attr_power1_input.attr,
 	&dev_attr_power1_crit.attr,
 	NULL
 };
 
-ATTRIBUTE_GROUPS(fam15h_power);
+static const struct attribute_group fam15h_power_group = {
+	.attrs = fam15h_power_attrs,
+	.is_visible = fam15h_power_is_visible,
+};
+__ATTRIBUTE_GROUPS(fam15h_power);
 
 static bool fam15h_power_is_internal_node0(struct pci_dev *f4)
 {
-- 
2.0.2

