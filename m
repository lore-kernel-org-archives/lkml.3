Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaDNIBj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:01:39 -0400
Received: from relay-s04-hub002.domainlocalhost.com ([74.115.207.101]:30138
	"EHLO relay-S04-HUB002.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbaDNH7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:59:41 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C11442S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/6] input: cyapa: add power mode sleep and runtime power
 mode supported.
Thread-Topic: [PATCH 3/6] input: cyapa: add power mode sleep and runtime
 power mode supported.
Thread-Index: Ac9XtrhL7zpBAAKmRWqh7hzOtsXpJQ==
Date: Mon, 14 Apr 2014 07:54:12 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C11442@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C11442@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.148]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C11442S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

In order to save power when the trackpad device is not used, the sleep powe=
r
mode and runtime power mode must be supported. And the enter sleep time can
be configured in the sysfs system.
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

--_000_77BC725C9062764F874D79F51E1F1A8F40C11442S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0A
AAAfAAJdAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAOVfAQAA
ACoAAABzAGkAcAA6AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AGgwBAAAA
FAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAfDAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBz
AHMALgBjAG8AbQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABYAAAAAAAAAIEr
H6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABA
AGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8AAV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUA
cwBzAC4AYwBvAG0AAAAAAB8A+D8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAHwAjQAEAAAAi
AAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQA
UAAAAAAAAgH5PwEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEPVAIAAACARAB1AGQAbABlAHkAIABE
AHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAAAB8ACV0BAAAA
IgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AMUABAAAAAgAAAAAAAAAL
AEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoAAQAAABIAAABJAFAATQAuAE4AbwB0AGUAAAAAAAMA
8T8ECAAACwBAOgEAAAADAP0/qAMAAAIBCzABAAAAEAAAAMvKIIZXF4ZPjv/Odxhq2f4DABcAAQAA
AEAAOQAAqjW5tlfPAUAACDBd3KC5tlfPAQsAKQAAAAAACwAjAAAAAAAfAACAhgMCAAAAAADAAAAA
AAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAAGgAAAHoAaAAt
AEMATgAsACAAZQBuAC0AVQBTAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAGhQAAAAAAAB8A
NwABAAAAogAAAFsAUABBAFQAQwBIACAAMwAvADYAXQAgAGkAbgBwAHUAdAA6ACAAYwB5AGEAcABh
ADoAIABhAGQAZAAgAHAAbwB3AGUAcgAgAG0AbwBkAGUAIABzAGwAZQBlAHAAIABhAG4AZAAgAHIA
dQBuAHQAaQBtAGUAIABwAG8AdwBlAHIAIABtAG8AZABlACAAcwB1AHAAcABvAHIAdABlAGQALgAA
AAAAHwA9AAEAAAACAAAAAAAAAAMANgAAAAAAAgFxAAEAAAAWAAAAAc9XtrhL7zpBAAKmRWqh7hzO
tsXpJQAAHwBwAAEAAACiAAAAWwBQAEEAVABDAEgAIAAzAC8ANgBdACAAaQBuAHAAdQB0ADoAIABj
AHkAYQBwAGEAOgAgAGEAZABkACAAcABvAHcAZQByACAAbQBvAGQAZQAgAHMAbABlAGUAcAAgAGEA
bgBkACAAcgB1AG4AdABpAG0AZQAgAHAAbwB3AGUAcgAgAG0AbwBkAGUAIABzAHUAcABwAG8AcgB0
AGUAZAAuAAAAAAAfADUQAQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5ADAANgAyADcANgA0AEYA
OAA3ADQARAA3ADkARgA1ADEARQAxAEYAMQBBADgARgA0ADAAQwAxADEANAA0ADIAQABTADAANAAt
AE0AQgBYADAAMQAtADAAMQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAADAN4/n04AAAsAAIAIIAYA
AAAAAMAAAAAAAABGAAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUAAAAAAAAD
AACAAyAGAAAAAADAAAAAAAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAAoEAAAAAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABAAAcwezTW
uLZXzwELAAIAAQAAAAMAJgAAAAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFGnbSlcN7Qn9QHAHe8
clyQYnZPh0159R4fGo8AAACZPBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8wycAAAAAHwD6PwEAAAAU
AAAARAB1AGQAbABlAHkAIABEAHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABCF
AAAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQByAHMAYQB0AGkAbwBu
AEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAALoAAABJAEkAPQAwADEAQwBGADUA
NwBCADYAQgA4ADQAQgBFAEYAMwBBADQAMQAwADAAMAAyAEEANgA0ADUANgBBAEEAMQBFAEUAMQBD
AEMARQBCADYAQwA1AEUAOQAyADUAOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIAcwBpAG8AbgAgADEA
NAAuADMAIAAoAEIAdQBpAGwAZAAgADEANwA0AC4AMAApACwAIABTAHQAYQBnAGUAPQBIADQAAAAA
AAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABOBAAABAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAA
I4EAAP///38DAACAAyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAA
AABGAAAAABGBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAAAAALAACAAyAGAAAA
AADAAAAAAAAARgAAAAAsgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACmBAAAAAAAAAwAA
gAMgBgAAAAAAwAAAAAAAAEYAAAAAKoEAAAAAAAAfAACAAyAGAAAAAADAAAAAAAAARgAAAAAngQAA
AQAAAAIAAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAfAACAAyAGAAAAAADA
AAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAA4EAAAAA
AAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAmgQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAA
AAAARgAAAACChQAAAAAAAEAAAIAIIAYAAAAAAMAAAAAAAABGAAAAAL+FAABAeXHTtVfPAQMADTT9
PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEA
YwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBn
AGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAeAAAAWwAxADAALgAzADAALgAxADIALgAxADQA
OABdAAAAAAD9qA==

--_000_77BC725C9062764F874D79F51E1F1A8F40C11442S04MBX0101s04lo_--
