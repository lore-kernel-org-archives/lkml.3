Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaFFH3P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:15 -0400
Received: from relay-s04-hub003.domainlocalhost.com ([74.115.207.102]:28999
	"EHLO relay-S04-HUB003.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaFFH3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:11 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8DBS04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 8/14] input: cyapa: add gen3 trackpad device baseline and
 calibrate functions supported
Thread-Topic: [PATCH v2 8/14] input: cyapa: add gen3 trackpad device
 baseline and calibrate functions supported
Thread-Index: Ac+BWOv8u4A19Hp9RxKG808iazHMFA==
Date: Fri, 6 Jun 2014 07:29:08 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8DB@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8DB@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8DBS04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add report baseline and force calibrate functions supported for gen3
trackpad device, which these functions are supplied through
cyapa core baseline and calibrate interfaces.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa_gen3.c b/drivers/input/mouse/cyapa_g=
en3.c
index a3e1e72..9ffdbc1 100644
--- a/drivers/input/mouse/cyapa_gen3.c
+++ b/drivers/input/mouse/cyapa_gen3.c
@@ -724,6 +724,138 @@ static int cyapa_gen3_do_fw_update(struct cyapa *cyap=
a,
        return 0;
 }

+static ssize_t cyapa_gen3_do_calibrate(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int tries =3D 20;  /* max recalibration timeout 2s. */
+       int ret;
+
+       cyapa_disable_irq(cyapa);
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+       if (ret < 0) {
+               dev_err(dev, "Error reading dev status. err =3D %d\n", ret)=
;
+               goto out;
+       }
+       if ((ret & CYAPA_DEV_NORMAL) !=3D CYAPA_DEV_NORMAL) {
+               dev_warn(dev, "Trackpad device is busy. device state =3D 0x=
%x\n",
+                        ret);
+               ret =3D -EAGAIN;
+               goto out;
+       }
+
+       ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+                              OP_RECALIBRATION_MASK);
+       if (ret < 0) {
+               dev_err(dev, "Failed to send calibrate command. ret =3D %d\=
n",
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
+               ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+               if (ret < 0) {
+                       dev_err(dev, "Error reading dev status. err =3D %d\=
n",
+                               ret);
+                       goto out;
+               }
+               if ((ret & CYAPA_DEV_NORMAL) =3D=3D CYAPA_DEV_NORMAL)
+                       break;
+       } while (--tries);
+
+       if (tries =3D=3D 0) {
+               dev_err(dev, "Failed to calibrate. Timeout.\n");
+               ret =3D -ETIMEDOUT;
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
+                                  struct device_attribute *attr, char *buf=
)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int max_baseline, min_baseline;
+       int tries =3D 3;
+       int ret;
+
+       cyapa_disable_irq(cyapa);
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+       if (ret < 0) {
+               dev_err(dev, "Error reading dev status. err =3D %d\n", ret)=
;
+               goto out;
+       }
+       if ((ret & CYAPA_DEV_NORMAL) !=3D CYAPA_DEV_NORMAL) {
+               dev_warn(dev, "Trackpad device is busy. device state =3D 0x=
%x\n",
+                        ret);
+               ret =3D -EAGAIN;
+               goto out;
+       }
+
+       ret =3D cyapa_write_byte(cyapa, CYAPA_CMD_SOFT_RESET,
+                              OP_REPORT_BASELINE_MASK);
+       if (ret < 0) {
+               dev_err(dev, "Failed to send report baseline command. %d\n"=
,
+                       ret);
+               goto out;
+       }
+
+       do {
+               usleep_range(10000, 20000);
+
+               ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_DEV_STATUS);
+               if (ret < 0) {
+                       dev_err(dev, "Error reading dev status. err =3D %d\=
n",
+                               ret);
+                       goto out;
+               }
+               if ((ret & CYAPA_DEV_NORMAL) =3D=3D CYAPA_DEV_NORMAL)
+                       break;
+       } while (--tries);
+
+       if (tries =3D=3D 0) {
+               dev_err(dev, "Device timed out going to Normal state.\n");
+               ret =3D -ETIMEDOUT;
+               goto out;
+       }
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_MAX_BASELINE);
+       if (ret < 0) {
+               dev_err(dev, "Failed to read max baseline. err =3D %d\n", r=
et);
+               goto out;
+       }
+       max_baseline =3D ret;
+
+       ret =3D cyapa_read_byte(cyapa, CYAPA_CMD_MIN_BASELINE);
+       if (ret < 0) {
+               dev_err(dev, "Failed to read min baseline. err =3D %d\n", r=
et);
+               goto out;
+       }
+       min_baseline =3D ret;
+
+       dev_dbg(dev, "Baseline report successful. Max: %d Min: %d\n",
+               max_baseline, min_baseline);
+       ret =3D scnprintf(buf, PAGE_SIZE, "%d %d\n", max_baseline, min_base=
line);
+
+out:
+       cyapa_enable_irq(cyapa);
+       return ret;
+}
+
 /*
  * cyapa_get_wait_time_for_pwr_cmd
  *
@@ -987,8 +1119,8 @@ const struct cyapa_dev_ops cyapa_gen3_ops =3D {
        NULL,
        cyapa_gen3_bl_deactivate,

-       NULL,
-       NULL,
+       cyapa_gen3_show_baseline,
+       cyapa_gen3_do_calibrate,

        NULL,
        NULL,
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8DBS04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
QAA5AAA6pgBZgc8BQAAIMHLiKgFZgc8BCwApAAAAAAALACMAAAAAAB8AAICGAwIAAAAAAMAAAAAA
AABGAQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAaAAAAegBoAC0A
QwBOACwAIABlAG4ALQBVAFMAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3
AAEAAADEAAAAWwBQAEEAVABDAEgAIAB2ADIAIAA4AC8AMQA0AF0AIABpAG4AcAB1AHQAOgAgAGMA
eQBhAHAAYQA6ACAAYQBkAGQAIABnAGUAbgAzACAAdAByAGEAYwBrAHAAYQBkACAAZABlAHYAaQBj
AGUAIABiAGEAcwBlAGwAaQBuAGUAIABhAG4AZAAgAGMAYQBsAGkAYgByAGEAdABlACAAZgB1AG4A
YwB0AGkAbwBuAHMAIABzAHUAcABwAG8AcgB0AGUAZAAAAB8APQABAAAAAgAAAAAAAAADADYAAAAA
AAIBcQABAAAAFgAAAAHPgVjr/LuANfR6fUcShvNPImsxzBQAAB8AcAABAAAAxAAAAFsAUABBAFQA
QwBIACAAdgAyACAAOAAvADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABk
ACAAZwBlAG4AMwAgAHQAcgBhAGMAawBwAGEAZAAgAGQAZQB2AGkAYwBlACAAYgBhAHMAZQBsAGkA
bgBlACAAYQBuAGQAIABjAGEAbABpAGIAcgBhAHQAZQAgAGYAdQBuAGMAdABpAG8AbgBzACAAcwB1
AHAAcABvAHIAdABlAGQAAAAfADUQAQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5ADAANgAyADcA
NgA0AEYAOAA3ADQARAA3ADkARgA1ADEARQAxAEYAMQBBADgARgA0ADQAMAA2AEMAOABEAEIAQABT
ADAANAAtAE0AQgBYADAAMQAtADAAMQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAADAN4/n04AAAsA
AIAIIAYAAAAAAMAAAAAAAABGAAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUA
AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAAoEAAAAAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABA
AAcwmb4g/1iBzwELAAIAAQAAAAMAJgAAAAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Q
n9QHAHe8clyQYnZPh0159R4fGo8AAACZPBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8w00AAAAAHwD6
PwEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABG
AAAAABCFAAAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0
AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAALoAAABJAEkAPQAwADEA
QwBGADgAMQA1ADgARQBCAEYAQwBCAEIAOAAwADMANQBGADQANwBBADcARAA0ADcAMQAyADgANgBG
ADMANABGADIAMgA2AEIAMwAxAEMAQwAxADQAOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8A
bgAgADEANAAuADMAIAAoAEIAdQBpAGwAZAAgADEANwA0AC4AMAApACwAIABTAHQAYQBnAGUAPQBI
ADQAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABOBAAABAAAAAwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAI4EAAP///38DAACAAyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIADIAYAAAAA
AMAAAAAAAABGAAAAABGBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAAAAALAACA
AyAGAAAAAADAAAAAAAAARgAAAAAsgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACmBAAAA
AAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKoEAAAAAAAAfAACAAyAGAAAAAADAAAAAAAAARgAA
AAAngQAAAQAAAAIAAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAfAACAAyAG
AAAAAADAAAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAA
A4EAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAmgQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAA
AABGAAAAAA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAA
AADAAAAAAAAARgAAAACChQAAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAA
AHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAe
AAAAWwAxADAALgAzADAALgAxADIALgAxADQANgBdAAAAAAAeeA==

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8DBS04MBX0101s04lo_--
