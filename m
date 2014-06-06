Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaFFH2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:28:52 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:30856
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752260AbaFFH2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:28:50 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C8B4S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 4/14] input: cyapa: add cyapa key function interfaces in
 sysfs system
Thread-Topic: [PATCH v2 4/14] input: cyapa: add cyapa key function
 interfaces in sysfs system
Thread-Index: Ac+BWOiKl9xmapDBR8WiaWKZ4leWCg==
Date: Fri, 6 Jun 2014 07:28:47 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C8B4@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C8B4@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8B4S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add key basic function interfaces in cyapa driver in sysfs system,
these interfaces are commonly used in pre- and after production, and
for trackpad device state checking, manage and firmware image updating.
These interfaces including firmware_version and product_id interfaces
for reading firmware version and trackpad device product id values,
and including update_fw interface to command firmware image update
process. Also including baseline and calibrate interfaces, so can
read and check the trackpad device states. If the baseline values are
invalid, then can use calibrate interface to recover it.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index c2b67d3..3b80de6 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -190,6 +190,17 @@ void cyapa_default_irq_handler(struct cyapa *cyapa)
 const struct cyapa_dev_ops cyapa_default_ops =3D {
        NULL,
        NULL,
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+       NULL,
+
+       NULL,
+       NULL,
+
+       NULL,
+       NULL,

        NULL,
        NULL,
@@ -470,6 +481,78 @@ static void cyapa_detect(struct cyapa *cyapa)
        }
 }

+static int cyapa_firmware(struct cyapa *cyapa, const char *fw_name)
+{
+       struct device *dev =3D &cyapa->client->dev;
+       int ret;
+       const struct firmware *fw;
+
+       ret =3D request_firmware(&fw, fw_name, dev);
+       if (ret) {
+               dev_err(dev, "Could not load firmware from %s, %d\n",
+                       fw_name, ret);
+               return ret;
+       }
+
+       if (cyapa->ops->cyapa_check_fw) {
+               ret =3D cyapa->ops->cyapa_check_fw(cyapa, fw);
+               if (ret) {
+                       dev_err(dev, "Invalid CYAPA firmware image: %s\n",
+                                       fw_name);
+                       goto done;
+               }
+       } else {
+               dev_err(dev, "Unknown status, operation forbidden, gen=3D%d=
\n",
+                       cyapa->gen);
+               ret =3D -EPERM;
+               goto done;
+       }
+
+       /*
+        * Resume the potentially suspended device because doing FW
+        * update on a device not in the FULL mode has a chance to
+        * fail.
+        */
+       pm_runtime_get_sync(dev);
+
+       if (cyapa->ops->cyapa_bl_enter) {
+               ret =3D cyapa->ops->cyapa_bl_enter(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_bl_activate) {
+               ret =3D cyapa->ops->cyapa_bl_activate(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_bl_initiate) {
+               ret =3D cyapa->ops->cyapa_bl_initiate(cyapa, fw);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_update_fw) {
+               ret =3D cyapa->ops->cyapa_update_fw(cyapa, fw);
+               if (ret)
+                       goto err_detect;
+       }
+
+       if (cyapa->ops->cyapa_bl_verify_app_integrity) {
+               ret =3D cyapa->ops->cyapa_bl_verify_app_integrity(cyapa);
+               if (ret)
+                       goto err_detect;
+       }
+
+err_detect:
+       pm_runtime_put_noidle(dev);
+
+done:
+       release_firmware(fw);
+       return ret;
+}
+
 /*
  * Sysfs Interface.
  */
@@ -656,6 +739,127 @@ static void cyapa_start_runtime(struct cyapa *cyapa)
 static void cyapa_start_runtime(struct cyapa *cyapa) {}
 #endif /* CONFIG_PM_RUNTIME */

+static ssize_t cyapa_show_fm_ver(struct device *dev,
+                                struct device_attribute *attr, char *buf)
+{
+       int ret;
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       ret =3D scnprintf(buf, PAGE_SIZE, "%d.%d\n", cyapa->fw_maj_ver,
+                        cyapa->fw_min_ver);
+       cyapa_state_sync_exit(cyapa);
+       return ret;
+}
+
+static ssize_t cyapa_show_product_id(struct device *dev,
+                                    struct device_attribute *attr, char *b=
uf)
+{
+       int ret;
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       ret =3D scnprintf(buf, PAGE_SIZE, "%s\n", cyapa->product_id);
+       cyapa_state_sync_exit(cyapa);
+       return ret;
+}
+
+static ssize_t cyapa_update_fw_store(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       const char *fw_name;
+       int ret;
+
+       /* Do not allow paths that step out of /lib/firmware  */
+       if (strstr(buf, "../") !=3D NULL)
+               return -EINVAL;
+
+       fw_name =3D !strncmp(buf, "1", count) ||
+                 !strncmp(buf, "1\n", count) ? CYAPA_FW_NAME : buf;
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       ret =3D cyapa_firmware(cyapa, fw_name);
+       if (ret)
+               dev_err(dev, "firmware update failed, %d\n", ret);
+       else
+               dev_dbg(dev, "firmware update succeeded\n");
+
+       cyapa_state_sync_exit(cyapa);
+
+       /* redetect trackpad device states. */
+       cyapa_detect_async(cyapa, 0);
+
+       return ret ? ret : count;
+}
+
+static ssize_t cyapa_calibrate_store(struct device *dev,
+                                    struct device_attribute *attr,
+                                    const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       int ret;
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       if (!cyapa->ops->cyapa_calibrate_store) {
+               cyapa_state_sync_exit(cyapa);
+               dev_err(dev, "Calibrate operation not permitted.\n");
+               return -EPERM;
+       }
+       ret =3D cyapa->ops->cyapa_calibrate_store(dev, attr, buf, count);
+
+       cyapa_state_sync_exit(cyapa);
+       return ret < 0 ? ret : count;
+}
+
+static ssize_t cyapa_show_baseline(struct device *dev,
+                                  struct device_attribute *attr, char *buf=
)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       ssize_t ret;
+
+       if (!cyapa_state_sync_enter(cyapa))
+               return -EBUSY;
+
+       if (!cyapa->ops->cyapa_show_baseline) {
+               cyapa_state_sync_exit(cyapa);
+               dev_err(dev, "Calibrate operation not permitted.\n");
+               return -EPERM;
+       }
+       ret =3D cyapa->ops->cyapa_show_baseline(dev, attr, buf);
+
+       cyapa_state_sync_exit(cyapa);
+       return ret;
+}
+
+static DEVICE_ATTR(firmware_version, S_IRUGO, cyapa_show_fm_ver, NULL);
+static DEVICE_ATTR(product_id, S_IRUGO, cyapa_show_product_id, NULL);
+static DEVICE_ATTR(update_fw, S_IWUSR, NULL, cyapa_update_fw_store);
+static DEVICE_ATTR(baseline, S_IRUGO, cyapa_show_baseline, NULL);
+static DEVICE_ATTR(calibrate, S_IWUSR, NULL, cyapa_calibrate_store);
+
+static struct attribute *cyapa_sysfs_entries[] =3D {
+       &dev_attr_firmware_version.attr,
+       &dev_attr_product_id.attr,
+       &dev_attr_update_fw.attr,
+       &dev_attr_baseline.attr,
+       &dev_attr_calibrate.attr,
+       NULL,
+};
+
+static const struct attribute_group cyapa_sysfs_group =3D {
+       .attrs =3D cyapa_sysfs_entries,
+};
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa =3D (struct cyapa *)data;
@@ -740,6 +944,9 @@ static int cyapa_probe(struct i2c_client *client,
        }
        cyapa_disable_irq(cyapa);

+       if (sysfs_create_group(&client->dev.kobj, &cyapa_sysfs_group))
+               dev_warn(dev, "error creating sysfs entries.\n");
+
 #ifdef CONFIG_PM_SLEEP
        if (device_can_wakeup(dev) &&
            sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group)=
)
@@ -762,6 +969,7 @@ static int cyapa_remove(struct i2c_client *client)
        struct cyapa *cyapa =3D i2c_get_clientdata(client);

        pm_runtime_disable(&client->dev);
+       sysfs_remove_group(&client->dev.kobj, &cyapa_sysfs_group);

 #ifdef CONFIG_PM_SLEEP
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 91fb84a..3e72fca 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -160,6 +160,19 @@ struct cyapa;
 typedef bool (*cb_sort)(struct cyapa *, u8 *, int);

 struct cyapa_dev_ops {
+       int (*cyapa_check_fw)(struct cyapa *, const struct firmware *);
+       int (*cyapa_bl_enter)(struct cyapa *);
+       int (*cyapa_bl_activate)(struct cyapa *);
+       int (*cyapa_bl_initiate)(struct cyapa *, const struct firmware *);
+       int (*cyapa_update_fw)(struct cyapa *, const struct firmware *);
+       int (*cyapa_bl_verify_app_integrity)(struct cyapa *);
+       int (*cyapa_bl_deactivate)(struct cyapa *);
+
+       ssize_t (*cyapa_show_baseline)(struct device *,
+                       struct device_attribute *, char *);
+       ssize_t (*cyapa_calibrate_store)(struct device *,
+                       struct device_attribute *, const char *, size_t);
+
        size_t (*cyapa_get_private_size)(void);
        int (*cyapa_private_init)(struct cyapa *cyapa, void *private_mem);

This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8B4S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
eRDQioJi7VbwbAJA/SBiGGC/4KnA81rdNpB1OKIiz8GJT35af7expuDncU+vz7OgsTbEaP238Gsu
IaFPTJytd1uwzs//pnljgAN0p66qP6tNtPAvgH52NXGsj62fq1zPwBzwaf+v36iPqZ+xfy18s4+0
n7Wvr7a/q+MkkWXQeVVQcHgA7c/BZU4QHPB5sA+7H6tc/1Twr4++3/8P8sSmpgmM9F7/9Y/3T/hf
+WT6Br9PxH7ZHv/GX8dvyH/Jj8qWTLP6JDaQ//K0wu/Q98Sc/fJe4MGTGGD/8sG4cFRCy2dxF6Z5
1yazAr+4fvzDNpBVxNcmg0BtZF60VGhjUCCDQPKgYf3wt1ZwlhDfEXnpYsFgaINA++pQ3oFh34BM
ofJAosCKsH+f8Bbw8qACQGxBHPBREHP8dWLysGNAIlA7sQpQTKHfIgBU8IMRzYCisWbOMOBg8RES
LiBJiqCRsfowURD/XxADgO/B9RCbQVRw4PFsE902kHBjkBjRVnBk9PDnAf50pzBM8AOAVPD6UN8i
gzD3g0DicTWAbN+AVPBjkPmBz+eg3ngSMM+UfX3P0OtAAAAfAEIAAQAAABQAAABEAHUAZABsAGUA
eQAgAEQAdQAAAB8AZQABAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAA
AB8AZAABAAAACgAAAFMATQBUAFAAAAAAAAIBQQABAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QC
AAAAgEQAdQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBz
AC4AYwBvAG0AAAAfAAJdAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAA
AAAfAOVfAQAAACoAAABzAGkAcAA6AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAA
AB8AGgwBAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAfDAEAAAAiAAAAZAB1AGQAbABAAGMA
eQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABY
AAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAA
ZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8AAV0BAAAAIgAAAGQAdQBkAGwAQABj
AHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8A+D8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAA
HwAjQAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAiQAEAAAAK
AAAAUwBNAFQAUAAAAAAAAgH5PwEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQA
bABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAA
AB8ACV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AMUABAAAA
AgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0
AGUAAAAAAAMA8T8ECAAACwBAOgEAAAADAP0/qAMAAAIBCzABAAAAEAAAAJjU85P6MUtPgmitYTIf
V04DABcAAQAAAEAAOQCA4SH0WIHPAUAACDAeDrD0WIHPAQsAKQAAAAAACwAjAAAAAAAfAACAhgMC
AAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAA
GgAAAHoAaAAtAEMATgAsACAAZQBuAC0AVQBTAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAG
hQAAAAAAAB8ANwABAAAAoAAAAFsAUABBAFQAQwBIACAAdgAyACAANAAvADEANABdACAAaQBuAHAA
dQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABkACAAYwB5AGEAcABhACAAawBlAHkAIABmAHUAbgBj
AHQAaQBvAG4AIABpAG4AdABlAHIAZgBhAGMAZQBzACAAaQBuACAAcwB5AHMAZgBzACAAcwB5AHMA
dABlAG0AAAAfAD0AAQAAAAIAAAAAAAAAAwA2AAAAAAACAXEAAQAAABYAAAABz4FY6IqX3GZqkMFH
xaJpYpniV5YKAAAfAHAAAQAAAKAAAABbAFAAQQBUAEMASAAgAHYAMgAgADQALwAxADQAXQAgAGkA
bgBwAHUAdAA6ACAAYwB5AGEAcABhADoAIABhAGQAZAAgAGMAeQBhAHAAYQAgAGsAZQB5ACAAZgB1
AG4AYwB0AGkAbwBuACAAaQBuAHQAZQByAGYAYQBjAGUAcwAgAGkAbgAgAHMAeQBzAGYAcwAgAHMA
eQBzAHQAZQBtAAAAHwA1EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAwADYAMgA3ADYANABG
ADgANwA0AEQANwA5AEYANQAxAEUAMQBGADEAQQA4AEYANAA0ADAANgBDADgAQgA0AEAAUwAwADQA
LQBNAEIAWAAwADEALQAwADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDeP59OAAALAACACCAG
AAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAAAAAA
AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYAAAAAAMAAAAAA
AABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAAAAAAQAAHMEXq
pfJYgc8BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBRRp20pXDe0J/UBwB3
vHJckGJ2T4dNefUeHxqPAAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MNJAAAAAB8A+j8BAAAA
FAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAQ
hQAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEAdABpAG8A
bgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJAD0AMAAxAEMARgA4
ADEANQA4AEUAOAA4AEEAOQA3AEQAQwA2ADYANgBBADkAMABDADEANAA3AEMANQBBADIANgA5ADYA
MgA5ADkARQAyADUANwA5ADYAMABBADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBvAG4AIAAx
ADQALgAzACAAKABCAHUAaQBsAGQAIAAxADcANAAuADAAKQAsACAAUwB0AGEAZwBlAD0ASAA0AAAA
AAADAACAAyAGAAAAAADAAAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAA
ACOBAAD///9/AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEIEAAAAAAAADAACAAyAGAAAAAADAAAAA
AAAARgAAAAARgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACSBAAAAAAAACwAAgAMgBgAA
AAAAwAAAAAAAAEYAAAAALIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAApgQAAAAAAAAMA
AIADIAYAAAAAAMAAAAAAAABGAAAAACqBAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJ4EA
AAEAAAACAAAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAAHwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAIYEAAAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAAOBAAAA
AAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAA
AAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAAgoUAAAAAAAADAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0A
bQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAA
AABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAHgAAAFsA
MQAwAC4AMwAwAC4AMQAyAC4AMQA0ADYAXQAAAAAAJR8=

--_000_77BC725C9062764F874D79F51E1F1A8F4406C8B4S04MBX0101s04lo_--
