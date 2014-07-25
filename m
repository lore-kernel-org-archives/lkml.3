Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbaGYMAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 08:00:17 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:59025 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbaGYMAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 08:00:16 -0400
From: Jisheng Zhang <jszhang@marvell.com>
To: <wsa@the-dreams.de>, <laurent.pinchart@ideasonboard.com>,
        <khali@linux-fr.org>, <paul.gortmaker@windriver.com>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Jisheng Zhang <jszhang@marvell.com>
Subject: [PATCH v2] i2c: pca954x: put the mux to disconnected state after resume
Date: Fri, 25 Jul 2014 19:57:46 +0800
Message-ID: <1406289466-936-1-git-send-email-jszhang@marvell.com>
X-Mailer: git-send-email 2.0.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-25_04:2014-07-25,2014-07-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1407250139
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pca954x may be power lost during suspend, so after resume we also suffer
the issue fixed by commit cd823db8b1161ef0d756514d280715a576d65cc3,

 "pca954x power-on default is channel 0 connected. If multiple pca954x
 muxes are connected to the same physical I2C bus, the parent bus will
 see channel 0 devices behind both muxes by default."

What's more, when resume bootloader may also operate the mux, so the
the channel connected after that may not be the one driver thought.

We fix this problem by putting the mux to disconnected state and
clearing last_chan in the resume hook.

Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
---
 drivers/i2c/muxes/i2c-mux-pca954x.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/i2c/muxes/i2c-mux-pca954x.c b/drivers/i2c/muxes/i2c-mux-pca954x.c
index 9bd4212..ec11b40 100644
--- a/drivers/i2c/muxes/i2c-mux-pca954x.c
+++ b/drivers/i2c/muxes/i2c-mux-pca954x.c
@@ -41,6 +41,7 @@
 #include <linux/i2c-mux.h>
 #include <linux/i2c/pca954x.h>
 #include <linux/module.h>
+#include <linux/pm.h>
 #include <linux/slab.h>
 
 #define PCA954X_MAX_NCHANS 8
@@ -273,9 +274,23 @@ static int pca954x_remove(struct i2c_client *client)
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
+static int pca954x_resume(struct device *dev)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct pca954x *data = i2c_get_clientdata(client);
+
+	data->last_chan = 0;
+	return i2c_smbus_write_byte(client, 0);
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(pca954x_pm, NULL, pca954x_resume);
+
 static struct i2c_driver pca954x_driver = {
 	.driver		= {
 		.name	= "pca954x",
+		.pm	= &pca954x_pm,
 		.owner	= THIS_MODULE,
 	},
 	.probe		= pca954x_probe,
-- 
2.0.1

