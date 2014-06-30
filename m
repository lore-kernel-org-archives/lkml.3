Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758AbaF3Goe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:44:34 -0400
Received: from relay-s04-hub005.domainlocalhost.com ([74.115.207.216]:23147
	"EHLO relay-S04-HUB005.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754738AbaF3Goa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:44:30 -0400
From: Dudley Du <dudl@cypress.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "patrikf@google.com" <patrikf@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 8/14] input: cyapa: add gen3 trackpad device baseline and
 calibrate functions supported
Thread-Topic: [PATCH v2 8/14] input: cyapa: add gen3 trackpad device
 baseline and calibrate functions supported
Thread-Index: Ac+ULruZ7crR3FzMRjGQKN1HXLqM+w==
Date: Mon, 30 Jun 2014 06:44:28 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4C902CAA@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.30.12.155]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s5U6ifS2009594

Add report baseline and force calibrate functions supported for gen3
trackpad device, which these functions are supplied through
cyapa core baseline and calibrate interfaces.
TEST=test on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_gen3.c
index a3e1e72..9ffdbc1 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -724,6 +724,138 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyapa,
        return 0;
 }

+static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       int tries = 20;  /* max recalibration timeout 2s. */
+       int ret;
+
+       cyapa_disable_irq(cyapa);
+
+       ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+       if (ret < 0) {
+               dev_err(dev, "Error reading dev status. err = %d\n", ret);
+               goto out;
+       }
+       if ((ret & CYAPA_DEV_NORMAL) != CYAPA_DEV_NORMAL) {
+               dev_warn(dev, "Trackpad device is busy. device state = 0x%x\n",
+                        ret);
+               ret = -EAGAIN;
+               goto out;
+       }
+
+       ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+                              OP_RECALIBRATION_MASK);
+       if (ret < 0) {
+               dev_err(dev, "Failed to send calibrate command. ret = %d\n",
+                       ret);
+               goto out;
+       }
+
+       do {
+               /*
+                * For this recalibration, the max time will not exceed 2s.
+                * The average time is approximately 500 - 700 ms, and we
+                * will check the status every 100 - 200ms.
+                */
+               usleep_range(100000, 200000);
+
+               ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+               if (ret < 0) {
+                       dev_err(dev, "Error reading dev status. err = %d\n",
+                               ret);
+                       goto out;
+               }
+               if ((ret & CYAPA_DEV_NORMAL) == CYAPA_DEV_NORMAL)
+                       break;
+       } while (--tries);
+
+       if (tries == 0) {
+               dev_err(dev, "Failed to calibrate. Timeout.\n");
+               ret = -ETIMEDOUT;
+               goto out;
+       }
+       dev_dbg(dev, "Calibration successful.\n");
+
+out:
+       cyapa_enable_irq(cyapa);
+       return ret < 0 ? ret : count;
+}
+
+static ssize_t cyapa_gen3_show_baseline(struct device *dev,
+                                  struct device_attribute *attr, char *buf)
+{
+       struct cyapa *cyapa = dev_get_drvdata(dev);
+       int max_baseline, min_baseline;
+       int tries = 3;
+       int ret;
+
+       cyapa_disable_irq(cyapa);
+
+       ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+       if (ret < 0) {
+               dev_err(dev, "Error reading dev status. err = %d\n", ret);
+               goto out;
+       }
+       if ((ret & CYAPA_DEV_NORMAL) != CYAPA_DEV_NORMAL) {
+               dev_warn(dev, "Trackpad device is busy. device state = 0x%x\n",
+                        ret);
+               ret = -EAGAIN;
+               goto out;
+       }
+
+       ret = cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+                              OP_REPORT_BASELINE_MASK);
+       if (ret < 0) {
+               dev_err(dev, "Failed to send report baseline command. %d\n",
+                       ret);
+               goto out;
+       }
+
+       do {
+               usleep_range(10000, 20000);
+
+               ret = cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+               if (ret < 0) {
+                       dev_err(dev, "Error reading dev status. err = %d\n",
+                               ret);
+                       goto out;
+               }
+               if ((ret & CYAPA_DEV_NORMAL) == CYAPA_DEV_NORMAL)
+                       break;
+       } while (--tries);
+
+       if (tries == 0) {
+               dev_err(dev, "Device timed out going to Normal state.\n");
+               ret = -ETIMEDOUT;
+               goto out;
+       }
+
+       ret = cyapa_read_byte(cyapa, CYAPA_CMD_MAX_BASELINE);
+       if (ret < 0) {
+               dev_err(dev, "Failed to read max baseline. err = %d\n", ret);
+               goto out;
+       }
+       max_baseline = ret;
+
+       ret = cyapa_read_byte(cyapa, CYAPA_CMD_MIN_BASELINE);
+       if (ret < 0) {
+               dev_err(dev, "Failed to read min baseline. err = %d\n", ret);
+               goto out;
+       }
+       min_baseline = ret;
+
+       dev_dbg(dev, "Baseline report successful. Max: %d Min: %d\n",
+               max_baseline, min_baseline);
+       ret = scnprintf(buf, PAGE_SIZE, "%d %d\n", max_baseline, min_baseline);
+
+out:
+       cyapa_enable_irq(cyapa);
+       return ret;
+}
+
 /*
  * cyapa_get_wait_time_for_pwr_cmd
  *
@@ -987,8 +1119,8 @@ const struct cyapa_dev_ops cyapa_gen3_ops = {
        NULL,
        cyapa_gen3_bl_deactivate,

-       NULL,
-       NULL,
+       cyapa_gen3_show_baseline,
+       cyapa_gen3_do_calibrate,

        NULL,
        NULL,
This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
