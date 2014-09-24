Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaIXNLn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:11:43 -0400
Received: from filter1.ibarracuda.nl ([83.247.7.10]:37339 "EHLO
	filter1.ibarracuda.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaIXNLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:11:39 -0400
X-ASG-Debug-ID: 1411564296-0759e70b7385860002-xx1T2L
X-Barracuda-Envelope-From: Frans.Klaver@xsens.com
X-Barracuda-AUTH-User: xsenscom
X-Barracuda-Apparent-Source-IP: 87.249.116.215
From: Frans Klaver <frans.klaver@xsens.com>
To: <linux-kernel@vger.kernel.org>
CC: Frans Klaver <frans.klaver@xsens.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: [RFC PATCH 1/2] sbs-battery: add forced instantiation from device tree
Date: Wed, 24 Sep 2014 15:11:17 +0200
X-ASG-Orig-Subj: [RFC PATCH 1/2] sbs-battery: add forced instantiation from device tree
Message-ID: <1411564278-17207-2-git-send-email-frans.klaver@xsens.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411564278-17207-1-git-send-email-frans.klaver@xsens.com>
References: <1411564278-17207-1-git-send-email-frans.klaver@xsens.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.11.160]
X-Barracuda-Connect: rev-215.116.249.87.virtu.nl[87.249.116.215]
X-Barracuda-Start-Time: 1411564296
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://filter1.ibarracuda.nl:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=5.0 tests=BSF_SC0_MISMATCH_TO
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.9824
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.00 BSF_SC0_MISMATCH_TO    Envelope rcpt doesn't match header
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases you want to instantiate a battery even before it is
attached; it is perfectly reasonable for a device to start up on
wall-power and be connected to a battery later. The current advice is to
instantiate a device explicitly in the kernel, or probe for the device
from userspace. The downside of these approaches is that the user needs
to keep the information related to the i2c battery in different places,
which is inconvenient.

Add the "sbs,always-present" option to the device tree. If set, the
battery is instantiated without sanity checking the connection.

Signed-off-by: Frans Klaver <frans.klaver@xsens.com>
---
 drivers/power/sbs-battery.c       | 11 +++++++++--
 include/linux/power/sbs-battery.h |  3 +++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index b5f2a76..5d327b5 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -651,6 +651,9 @@ static struct sbs_platform_data *sbs_of_populate_pdata(
 	if (!rc)
 		pdata->poll_retry_count = prop;
 
+	pdata->always_present = of_property_read_bool(of_node,
+						      "sbs,always-present");
+
 	if (!of_get_property(of_node, "sbs,battery-detect-gpios", NULL)) {
 		pdata->battery_detect = -1;
 		goto of_out;
@@ -761,10 +764,14 @@ static int sbs_probe(struct i2c_client *client,
 
 skip_gpio:
 	/*
-	 * Before we register, we need to make sure we can actually talk
+	 * Before we register, we might need to make sure we can actually talk
 	 * to the battery.
 	 */
-	rc = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
+	if (!pdata->always_present)
+		rc = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
+	else
+		rc = 0;
+
 	if (rc < 0) {
 		dev_err(&client->dev, "%s: Failed to get device status\n",
 			__func__);
diff --git a/include/linux/power/sbs-battery.h b/include/linux/power/sbs-battery.h
index 2b0a9d9..724bd9b 100644
--- a/include/linux/power/sbs-battery.h
+++ b/include/linux/power/sbs-battery.h
@@ -31,12 +31,15 @@
  * @i2c_retry_count:		# of times to retry on i2c IO failure
  * @poll_retry_count:		# of times to retry looking for new status after
  *				external change notification
+ * @always_present:		the device is instantiated even if the battery
+ *				is not physically present
  */
 struct sbs_platform_data {
 	int battery_detect;
 	int battery_detect_present;
 	int i2c_retry_count;
 	int poll_retry_count;
+	bool always_present;
 };
 
 #endif
-- 
2.1.0

