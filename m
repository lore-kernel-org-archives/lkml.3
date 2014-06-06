Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaFFH2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:28:53 -0400
Received: from relay-s04-hub005.domainlocalhost.com ([74.115.207.216]:36795
	"EHLO relay-S04-HUB005.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263AbaFFH2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:28:50 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406B8A3S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 2/14] input: cyapa: add cyapa driver power management
 interfaces supported
Thread-Topic: [PATCH v2 2/14] input: cyapa: add cyapa driver power
 management interfaces supported
Thread-Index: Ac+BWOUcjnFa/TvaR62XjLxdeaqk1A==
Date: Fri, 6 Jun 2014 07:28:42 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406B8A3@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406B8A3@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406B8A3S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the power management
strategy of trackpad device as their requirements.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index d5adee8..1dfc16d 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -462,6 +462,10 @@ static void cyapa_detect(struct cyapa *cyapa)
 }

 /*
+ * Sysfs Interface.
+ */
+
+/*
  * cyapa_sleep_time_to_pwr_cmd and cyapa_pwr_cmd_to_sleep_time
  *
  * These are helper functions that convert to and from integer idle
@@ -495,6 +499,81 @@ u16 cyapa_pwr_cmd_to_sleep_time(u8 pwr_mode)
                                   : (encoded_time - 5) * 20;
 }

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
+static int cyapa_sleep_time_check(u16 sleep_time)
+{
+       if (sleep_time > 1000)
+               sleep_time =3D 1000;
+       return sleep_time;
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
+               cyapa->suspend_sleep_time =3D cyapa_sleep_time_check(sleep_=
time);
+               cyapa->suspend_power_mode =3D
+                       cyapa_sleep_time_to_pwr_cmd(cyapa->suspend_sleep_ti=
me);
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
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa =3D (struct cyapa *)data;
@@ -575,6 +654,12 @@ static int cyapa_probe(struct i2c_client *client,
        }
        cyapa_disable_irq(cyapa);

+#ifdef CONFIG_PM_SLEEP
+       if (device_can_wakeup(dev) &&
+           sysfs_merge_group(&client->dev.kobj, &cyapa_power_wakeup_group)=
)
+               dev_warn(dev, "error creating wakeup power entries.\n");
+#endif /* CONFIG_PM_SLEEP */
+
        async_schedule(cyapa_detect_and_start, cyapa);
        return 0;

@@ -590,6 +675,9 @@ static int cyapa_remove(struct i2c_client *client)
 {
        struct cyapa *cyapa =3D i2c_get_clientdata(client);

+#ifdef CONFIG_PM_SLEEP
+       sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
+#endif
        free_irq(cyapa->irq, cyapa);

        input_unregister_device(cyapa->input);
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406B8A3S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
AGEAZwBlAAAAAAABAAAAGgAAAHoAaAAtAEMATgAsACAAZQBuAC0AVQBTAAAAAAALAACACCAGAAAA
AADAAAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAqgAAAFsAUABBAFQAQwBIACAAdgAyACAAMgAv
ADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkAYQBwAGEAOgAgAGEAZABkACAAYwB5AGEAcABhACAA
ZAByAGkAdgBlAHIAIABwAG8AdwBlAHIAIABtAGEAbgBhAGcAZQBtAGUAbgB0ACAAaQBuAHQAZQBy
AGYAYQBjAGUAcwAgAHMAdQBwAHAAbwByAHQAZQBkAAAAAAAfAD0AAQAAAAIAAAAAAAAAAwA2AAAA
AAACAXEAAQAAABYAAAABz4FY5RyOcVr9O9pHrZeMvF15qqTUAAAfAHAAAQAAAKoAAABbAFAAQQBU
AEMASAAgAHYAMgAgADIALwAxADQAXQAgAGkAbgBwAHUAdAA6ACAAYwB5AGEAcABhADoAIABhAGQA
ZAAgAGMAeQBhAHAAYQAgAGQAcgBpAHYAZQByACAAcABvAHcAZQByACAAbQBhAG4AYQBnAGUAbQBl
AG4AdAAgAGkAbgB0AGUAcgBmAGEAYwBlAHMAIABzAHUAcABwAG8AcgB0AGUAZAAAAAAAHwA1EAEA
AACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAwADYAMgA3ADYANABGADgANwA0AEQANwA5AEYANQAx
AEUAMQBGADEAQQA4AEYANAA0ADAANgBCADgAQQAzAEAAUwAwADQALQBNAEIAWAAwADEALQAwADEA
LgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDeP59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAD
hQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIADIAYAAAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAA
AAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByBAAAAAAAAQAAHMMZyCfFYgc8BCwACAAEAAAADACYA
AAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBRRp20pXDe0J/UBwB3vHJckGJ2T4dNefUeHxqPAAAA
mTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MNHAAAAAB8A+j8BAAAAFAAAAEQAdQBkAGwAZQB5ACAA
RAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAQhQAAAAAAAB8AAIAfpOszqHou
Qr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUAcgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEA
YwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJAD0AMAAxAEMARgA4ADEANQA4AEUANQAxAEMAOABF
ADcAMQA1AEEARgBEADMAQgBEAEEANAA3AEEARAA5ADcAOABDAEIAQwA1AEQANwA5AEEAQQBBADQA
RAA0ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQByAHMAaQBvAG4AIAAxADQALgAzACAAKABCAHUAaQBs
AGQAIAAxADcANAAuADAAKQAsACAAUwB0AGEAZwBlAD0ASAA0AAAAAAADAACAAyAGAAAAAADAAAAA
AAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACOBAAD///9/AwAAgAMgBgAA
AAAAwAAAAAAAAEYAAAAAEIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAARgQAAAAAAAAsA
AIADIAYAAAAAAMAAAAAAAABGAAAAACSBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAALIEA
AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAApgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABG
AAAAACqBAAAAAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJ4EAAAEAAAACAAAAAAAAAAMAAIAD
IAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAAHwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAIYEAAAEA
AAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAAOBAAAAAAAACwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAJoEAAAAAAAALAACACCAGAAAAAADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYA
AAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAABA
AACACCAGAAAAAADAAAAAAAAARgAAAAC/hQAA0AQRKleBzwEDAA00/T8AAB8AAICGAwIAAAAAAMAA
AAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABhAHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAA
AB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIAAAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0A
aQBwAAAAAAABAAAAHgAAAFsAMQAwAC4AMwAwAC4AMQAyAC4AMQA0ADYAXQAAAAAAtjc=

--_000_77BC725C9062764F874D79F51E1F1A8F4406B8A3S04MBX0101s04lo_--
