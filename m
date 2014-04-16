Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862AbaDPIiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:38:15 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:39839
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751185AbaDPIiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:38:12 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C14085S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] input: cyapa: add power mode sleep and runtime power
 mode supported.
Thread-Topic: [PATCH 3/6] input: cyapa: add power mode sleep and runtime
 power mode supported.
Thread-Index: Ac9XtrhL7zpBAAKmRWqh7hzOtsXpJQBmEyvA
Date: Wed, 16 Apr 2014 08:38:04 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C14085@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C14085@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.153]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C14085S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

In order to save power when the trackpad device is not used, the sleep powe=
r mode and runtime power mode must be supported.
And the enter sleep time can be configured in the sysfs system.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 7b269d8..6820b3f 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -27,6 +27,7 @@
 #include <linux/slab.h>
 #include <linux/uaccess.h>
 #include <linux/unaligned/access_ok.h>
+#include <linux/pm_runtime.h>

 /* APA trackpad firmware generation */
 #define CYAPA_GEN_UNKNOWN   0x00   /* unknown protocol. */
@@ -505,6 +506,10 @@ struct cyapa {
        u16 suspend_sleep_time;
        u8 real_power_mode;
        u16 real_sleep_time;
+#ifdef CONFIG_PM_RUNTIME
+       u8 runtime_suspend_power_mode;
+       u16 runtime_suspend_sleep_time;
+#endif /* CONFIG_PM_RUNTIME */
        bool suspended;

        /* read from query data region. */
@@ -1873,6 +1878,13 @@ static int cyapa_gen5_bl_exit(struct cyapa *cyapa)
        return -EAGAIN;
 }

+static int cyapa_gen5_sleep_time_check(u16 sleep_time)
+{
+       if (sleep_time > 1000)
+               sleep_time =3D 1000;
+       return sleep_time;
+}
+
 static int cyapa_gen5_change_power_state(struct cyapa *cyapa, u8 power_sta=
te)
 {
        int ret;
@@ -2571,6 +2583,9 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)
        struct input_dev *input =3D cyapa->input;
        int length;

+       pm_runtime_get_sync(dev);
+       pm_runtime_mark_last_busy(dev);
+
        if (device_may_wakeup(dev))
                pm_wakeup_event(dev, 0);

@@ -2646,6 +2661,7 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)

        if (cyapa->cyapa_irq_handler)
                cyapa->cyapa_irq_handler(cyapa);
+       pm_runtime_put_sync_autosuspend(dev);

 out:
        return IRQ_HANDLED;
@@ -2945,6 +2961,152 @@ static void cyapa_detect(struct cyapa *cyapa)
                cyapa_empty_pip_output_data(cyapa, NULL, NULL, NULL);
 }

+
+/*
+ * Sysfs Interface.
+ */
+
+#ifdef CONFIG_PM_SLEEP
+static ssize_t cyapa_show_suspend_scanrate(struct device *dev,
+                                          struct device_attribute *attr,
+                                          char *buf)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       u8 pwr_cmd =3D cyapa->suspend_power_mode;
+       u16 sleep_time;
+       int len;
+
+       if (pwr_cmd =3D=3D PWR_MODE_BTN_ONLY)
+               len =3D scnprintf(buf, PAGE_SIZE, "%s\n", BTN_ONLY_MODE_NAM=
E);
+       else if (pwr_cmd =3D=3D PWR_MODE_OFF)
+               len =3D scnprintf(buf, PAGE_SIZE, "%s\n", OFF_MODE_NAME);
+       else {
+               if (cyapa->gen =3D=3D CYAPA_GEN3)
+                       sleep_time =3D cyapa_pwr_cmd_to_sleep_time(pwr_cmd)=
;
+               else
+                       sleep_time =3D cyapa->suspend_sleep_time;
+               len =3D scnprintf(buf, PAGE_SIZE, "%u\n", sleep_time);
+       }
+
+       return len;
+}
+
+static ssize_t cyapa_update_suspend_scanrate(struct device *dev,
+                                            struct device_attribute *attr,
+                                            const char *buf, size_t count)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       u16 sleep_time;
+
+       if (buf =3D=3D NULL || count =3D=3D 0)
+               goto invalidparam;
+
+       if (sysfs_streq(buf, BTN_ONLY_MODE_NAME))
+               cyapa->suspend_power_mode =3D PWR_MODE_BTN_ONLY;
+       else if (sysfs_streq(buf, OFF_MODE_NAME))
+               cyapa->suspend_power_mode =3D PWR_MODE_OFF;
+       else if (!kstrtou16(buf, 10, &sleep_time)) {
+               cyapa->suspend_power_mode =3D
+                               cyapa_sleep_time_to_pwr_cmd(sleep_time);
+               if (cyapa->gen > CYAPA_GEN3)
+                       cyapa->suspend_sleep_time =3D
+                               cyapa_gen5_sleep_time_check(sleep_time);
+       } else
+               goto invalidparam;
+
+       return count;
+
+invalidparam:
+       dev_err(dev, "invalid suspend scanrate ms parameters\n");
+       return -EINVAL;
+}
+
+static DEVICE_ATTR(suspend_scanrate_ms, S_IRUGO|S_IWUSR,
+                  cyapa_show_suspend_scanrate,
+                  cyapa_update_suspend_scanrate);
+
+static struct attribute *cyapa_power_wakeup_entries[] =3D {
+       &dev_attr_suspend_scanrate_ms.attr,
+       NULL,
+};
+
+static const struct attribute_group cyapa_power_wakeup_group =3D {
+       .name =3D power_group_name,
+       .attrs =3D cyapa_power_wakeup_entries,
+};
+#endif /* CONFIG_PM_SLEEP */
+
+#ifdef CONFIG_PM_RUNTIME
+static ssize_t cyapa_show_rt_suspend_scanrate(struct device *dev,
+                                             struct device_attribute *attr=
,
+                                             char *buf)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       u8 pwr_cmd =3D cyapa->runtime_suspend_power_mode;
+
+       if (cyapa->gen =3D=3D CYAPA_GEN3)
+               return scnprintf(buf, PAGE_SIZE, "%u\n",
+                       cyapa_pwr_cmd_to_sleep_time(pwr_cmd));
+       else
+               return scnprintf(buf, PAGE_SIZE, "%u\n",
+                       cyapa->runtime_suspend_sleep_time);
+}
+
+static ssize_t cyapa_update_rt_suspend_scanrate(struct device *dev,
+                                               struct device_attribute *at=
tr,
+                                               const char *buf, size_t cou=
nt)
+{
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+       u16 time;
+
+       if (buf =3D=3D NULL || count =3D=3D 0 || kstrtou16(buf, 10, &time))=
 {
+               dev_err(dev, "invalid runtime suspend scanrate ms parameter=
\n");
+               return -EINVAL;
+       }
+
+       /*
+        * When the suspend scanrate is changed, pm_runtime_get to resume
+        * a potentially suspended device, update to the new pwr_cmd
+        * and then pm_runtime_put to suspend into the new power mode.
+        */
+       pm_runtime_get_sync(dev);
+       cyapa->runtime_suspend_power_mode =3D cyapa_sleep_time_to_pwr_cmd(t=
ime);
+       if (cyapa->gen > CYAPA_GEN3)
+               cyapa->runtime_suspend_sleep_time =3D time;
+       pm_runtime_put_sync_autosuspend(dev);
+       return count;
+}
+
+static DEVICE_ATTR(runtime_suspend_scanrate_ms, S_IRUGO|S_IWUSR,
+                  cyapa_show_rt_suspend_scanrate,
+                  cyapa_update_rt_suspend_scanrate);
+
+static struct attribute *cyapa_power_runtime_entries[] =3D {
+       &dev_attr_runtime_suspend_scanrate_ms.attr,
+       NULL,
+};
+
+static const struct attribute_group cyapa_power_runtime_group =3D {
+       .name =3D power_group_name,
+       .attrs =3D cyapa_power_runtime_entries,
+};
+
+static void cyapa_start_runtime(struct cyapa *cyapa)
+{
+       struct device *dev =3D &cyapa->client->dev;
+
+       cyapa->runtime_suspend_power_mode =3D PWR_MODE_IDLE;
+       if (sysfs_merge_group(&dev->kobj, &cyapa_power_runtime_group))
+               dev_warn(dev, "error creating wakeup runtime entries.\n");
+       pm_runtime_set_active(dev);
+       pm_runtime_use_autosuspend(dev);
+       pm_runtime_set_autosuspend_delay(dev, AUTOSUSPEND_DELAY);
+       pm_runtime_enable(dev);
+}
+#else
+static void cyapa_start_runtime(struct cyapa *cyapa) {}
+#endif /* CONFIG_PM_RUNTIME */
+
 static void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa =3D (struct cyapa *)data;
@@ -2957,6 +3119,15 @@ static void cyapa_detect_async(void *data, async_coo=
kie_t cookie)
        atomic_dec(&cyapa->in_detecting);
 }

+static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
+{
+       struct cyapa *cyapa =3D data;
+
+       cyapa_detect_async(data, cookie);
+
+       cyapa_start_runtime(cyapa);
+}
+
 static int cyapa_probe(struct i2c_client *client,
                       const struct i2c_device_id *dev_id)
 {
@@ -3017,7 +3188,13 @@ static int cyapa_probe(struct i2c_client *client,
        }
        cyapa_disable_irq(cyapa);

-       async_schedule(cyapa_detect_async, cyapa);
+#ifdef CONFIG_PM_SLEEP
+       if (device_can_wakeup(dev) &&
+           sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group)=
)
+               dev_warn(dev, "error creating wakeup power entries.\n");
+#endif /* CONFIG_PM_SLEEP */
+
+       async_schedule(cyapa_detect_and_start, cyapa);
        return 0;

 err_unregister_device:
@@ -3032,6 +3209,16 @@ static int cyapa_remove(struct i2c_client *client)
 {
        struct cyapa *cyapa =3D i2c_get_clientdata(client);

+       pm_runtime_disable(&client->dev);
+
+#ifdef CONFIG_PM_SLEEP
+       sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
+#endif
+
+#ifdef CONFIG_PM_RUNTIME
+       sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
+#endif
+
        free_irq(cyapa->irq, cyapa);
        input_unregister_device(cyapa->input);

@@ -3090,12 +3277,56 @@ static int cyapa_resume(struct device *dev)

        async_schedule(cyapa_detect_async, cyapa);

+       /* runtime set active to reflect active state. */
+       pm_runtime_disable(dev);
+       pm_runtime_set_active(dev);
+       pm_runtime_enable(dev);
        cyapa->suspended =3D false;
        return 0;
 }
 #endif /* CONFIG_PM_SLEEP */

-static SIMPLE_DEV_PM_OPS(cyapa_pm_ops, cyapa_suspend, cyapa_resume);
+#ifdef CONFIG_PM_RUNTIME
+static int cyapa_runtime_suspend(struct device *dev)
+{
+       int ret;
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+
+       if (cyapa->cyapa_set_power_mode) {
+               /* set trackpad device to idle mode */
+               ret =3D cyapa->cyapa_set_power_mode(cyapa,
+                               cyapa->runtime_suspend_power_mode,
+                               cyapa->runtime_suspend_sleep_time);
+               if (ret)
+                       dev_err(dev, "runtime suspend failed, %d\n", ret);
+               return ret;
+       }
+
+       return 0;
+}
+
+static int cyapa_runtime_resume(struct device *dev)
+{
+       int ret;
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+
+       if (cyapa->cyapa_set_power_mode) {
+               /* resume to full active mode */
+               ret =3D cyapa->cyapa_set_power_mode(cyapa,
+                               PWR_MODE_FULL_ACTIVE, 0);
+               if (ret)
+                       dev_err(dev, "runtime resume failed, %d\n", ret);
+               return ret;
+       }
+
+       return 0;
+}
+#endif /* CONFIG_PM_RUNTIME */
+
+static const struct dev_pm_ops cyapa_pm_ops =3D {
+       SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+       SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume, NUL=
L)
+};

 static const struct i2c_device_id cyapa_id_table[] =3D {
        { "cyapa", 0 },
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F40C14085S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8A
Al0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8A5V8BAAAAKgAA
AHMAaQBwADoAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAaDAEAAAAUAAAA
RAB1AGQAbABlAHkAIABEAHUAAAAfAB8MAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAu
AGMAbwBtAAAAAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAACARkMAQAAAFgAAAAAAAAAgSsfpL6j
EBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAAYwB5
AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwABXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMA
LgBjAG8AbQAAAAAAHwD4PwEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAAfACNAAQAAACIAAABk
AHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfACJAAQAAAAoAAABTAE0AVABQAAAA
AAACAfk/AQAAAFgAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAA
AFMATQBUAFAAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwAJXQEAAAAiAAAA
ZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoB
AAAAHwAwQAEAAAACAAAAAAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwQI
AAALAEA6AQAAAAMA/T+oAwAAAgELMAEAAAAQAAAAOqXK3M9SLESXOZ1xz/2A7AMAFwABAAAAQAA5
AAB+1C5PWc8BQAAIMJ1dUi9PWc8BCwApAAAAAAALACMAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABG
AQAAAB4AAABhAGMAYwBlAHAAdABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAaAAAAegBoAC0AQwBO
ACwAIABlAG4ALQBVAFMAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEA
AACiAAAAWwBQAEEAVABDAEgAIAAzAC8ANgBdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAg
AGEAZABkACAAcABvAHcAZQByACAAbQBvAGQAZQAgAHMAbABlAGUAcAAgAGEAbgBkACAAcgB1AG4A
dABpAG0AZQAgAHAAbwB3AGUAcgAgAG0AbwBkAGUAIABzAHUAcABwAG8AcgB0AGUAZAAuAAAAAAAf
AD0AAQAAAAIAAAAAAAAAAwA2AAAAAAADAC4AAAAAAB8AQhABAAAAAgAAAAAAAAACAXEAAQAAABsA
AAABz1e2uEvvOkEAAqZFaqHuHM62xeklAGYTK8AAHwBwAAEAAACiAAAAWwBQAEEAVABDAEgAIAAz
AC8ANgBdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABkACAAcABvAHcAZQByACAA
bQBvAGQAZQAgAHMAbABlAGUAcAAgAGEAbgBkACAAcgB1AG4AdABpAG0AZQAgAHAAbwB3AGUAcgAg
AG0AbwBkAGUAIABzAHUAcABwAG8AcgB0AGUAZAAuAAAAAAAfADUQAQAAAIQAAAA8ADcANwBCAEMA
NwAyADUAQwA5ADAANgAyADcANgA0AEYAOAA3ADQARAA3ADkARgA1ADEARQAxAEYAMQBBADgARgA0
ADAAQwAxADQAMAA4ADUAQABTADAANAAtAE0AQgBYADAAMQAtADAAMQAuAHMAMAA0AC4AbABvAGMA
YQBsAD4AAAAfADkQAQAAAAIAAAAAAAAAAwDeP59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAD
hQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYAAAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAA
AAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAAAAAAQAAHMBUYii5PWc8BCwACAAEAAAADACYA
AAAAAAsAKwAAAAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Qn9QHAHe8clyQYnZPh015
9R4fGo8AAACZPBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8wy4AAAAAHwD6PwEAAAAUAAAARAB1AGQA
bABlAHkAIABEAHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCFAAAAAAAAHwAA
gB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBuAEkAbgBkAGUA
eABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAAOAAAABJAEkAPQAwADEAQwBGADUANwBCADYAQgA4
ADQAQgBFAEYAMwBBADQAMQAwADAAMAAyAEEANgA0ADUANgBBAEEAMQBFAEUAMQBDAEMARQBCADYA
QwA1AEUAOQAyADUAMAAwADYANgAxADMAMgBCAEMAMAA7AFMAQgBDAEkARAA9ADEANAA7AFYAZQBy
AHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAgACgAQgB1AGkAbABkACAAMQA3ADQA
LgAwACkALAAgAFMAdABhAGcAZQA9AEgANAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABOBAAAB
AAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAI4EAAP///38DAACAAyAGAAAAAADAAAAAAAAARgAA
AAAQgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABGBAAAAAAAACwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAJIEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAsgQAAAAAAAAMAAIADIAYA
AAAAAMAAAAAAAABGAAAAACmBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKoEAAAAAAAAf
AACAAyAGAAAAAADAAAAAAAAARgAAAAAngQAAAQAAAAIAAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAEoEAAAEAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAACwAA
gAMgBgAAAAAAwAAAAAAAAEYAAAAAA4EAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAmgQAA
AAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAAMADTT9PwAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAA
AAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQA
aQBuAGcALQBpAHAAAAAAAAEAAAAeAAAAWwAxADAALgAzADAALgAxADIALgAxADUAMwBdAAAAAADC
yA==

--_000_77BC725C9062764F874D79F51E1F1A8F40C14085S04MBX0101s04lo_--
