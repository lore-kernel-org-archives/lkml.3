Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbaIPPVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 11:21:18 -0400
Received: from mail-bl2on0105.outbound.protection.outlook.com ([65.55.169.105]:58804
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754512AbaIPPVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 11:21:15 -0400
X-WSS-ID: 0NC02N8-07-M3D-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <herrmann.der.user@googlemail.com>, <linux@roeck-us.net>,
        <jdelvare@suse.de>, <lm-sensors@lm-sensors.org>,
        <linux-kernel@vger.kernel.org>
CC: <boris.ostrovsky@oracle.com>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 1/2] hwmon, fam15h_power: Make actual power reporting conditional
Date: Tue, 16 Sep 2014 10:38:38 -0500
Message-ID: <1410881918-1392-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 2.0.2
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019020)(6009001)(428002)(189002)(199003)(83072002)(85852003)(44976005)(20776003)(15202345003)(99396002)(15975445006)(77096002)(50986999)(50466002)(48376002)(106466001)(31966008)(64706001)(88136002)(85306004)(81542003)(74662003)(80022003)(74502003)(77982003)(46102003)(81342003)(79102003)(76482001)(90102001)(19580395003)(83322001)(86362001)(92726001)(36756003)(62966002)(93916002)(107046002)(87936001)(101416001)(19580405001)(95666004)(92566001)(4396001)(2201001)(87286001)(21056001)(229853001)(68736004)(97736003)(105586002)(89996001)(84676001)(15395725005)(102836001)(53416004)(77156001)(47776003)(2101003)(6606295002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM2PR02MB495;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03361FCC43
Authentication-Results: spf=none (sender IP is 165.204.84.221)
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
 drivers/hwmon/fam15h_power.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/fam15h_power.c b/drivers/hwmon/fam15h_power.c
index 4a7cbfa..5ca24de 100644
--- a/drivers/hwmon/fam15h_power.c
+++ b/drivers/hwmon/fam15h_power.c
@@ -93,13 +93,30 @@ static ssize_t show_power_crit(struct device *dev,
 }
 static DEVICE_ATTR(power1_crit, S_IRUGO, show_power_crit, NULL);
 
+static umode_t fam15h_power_is_visible(struct kobject *kobj,
+				       struct attribute *attr,
+				       int index)
+{
+	/* power1_input is only reported for Fam15h, Models 00h-0fh */
+	if (!strcmp(attr->name, "power1_input") &&
+	   (boot_cpu_data.x86 != 0x15 || boot_cpu_data.x86_model > 0xf)) {
+		return 0;
+	}
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

