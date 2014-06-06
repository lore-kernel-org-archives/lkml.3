Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730AbaFFH3o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:44 -0400
Received: from relay-s04-hub001.domainlocalhost.com ([74.115.207.100]:16052
	"EHLO relay-S04-HUB001.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbaFFH3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:41 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C911S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 3/14] input: cyapa: add cyapa driver runtime power
 management interfaces supported
Thread-Topic: [PATCH v2 3/14] input: cyapa: add cyapa driver runtime power
 management interfaces supported
Thread-Index: Ac+BWOa5RLZdPgJIS4KK84JVKZSI2A==
Date: Fri, 6 Jun 2014 07:29:38 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C911@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C911@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C911S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add runtime_suspend_scanrate_ms power management interfaces in device's
power group, so users or applications can control the runtime power
management strategy of trackpad device as their requirements.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 1dfc16d..c2b67d3 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -346,9 +346,16 @@ static int cyapa_check_is_operational(struct cyapa *cy=
apa)
 static irqreturn_t cyapa_irq(int irq, void *dev_id)
 {
        struct cyapa *cyapa =3D dev_id;
+       struct device *dev =3D &cyapa->client->dev;
        struct input_dev *input =3D cyapa->input;
        bool cont;

+       pm_runtime_get_sync(dev);
+       pm_runtime_mark_last_busy(dev);
+
+       if (device_may_wakeup(dev))
+               pm_wakeup_event(dev, 0);
+
        /* interrupt event maybe cuased by host command to trackpad device.=
 */
        cont =3D true;
        if (cyapa->ops->cyapa_irq_cmd_handler)
@@ -373,6 +380,8 @@ static irqreturn_t cyapa_irq(int irq, void *dev_id)

                cyapa_state_sync_exit(cyapa);
        }
+
+       pm_runtime_put_sync_autosuspend(dev);
 out:
        return IRQ_HANDLED;
 }
@@ -574,6 +583,79 @@ static const struct attribute_group cyapa_power_wakeup=
_group =3D {
 };
 #endif /* CONFIG_PM_SLEEP */

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
+       cyapa->runtime_suspend_sleep_time =3D cyapa_sleep_time_check(time);
+       cyapa->runtime_suspend_power_mode =3D
+               cyapa_sleep_time_to_pwr_cmd(cyapa->runtime_suspend_sleep_ti=
me);
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
+       cyapa->runtime_suspend_sleep_time =3D
+               cyapa_pwr_cmd_to_sleep_time(cyapa->runtime_suspend_power_mo=
de);
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
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa =3D (struct cyapa *)data;
@@ -589,7 +671,11 @@ void cyapa_detect_async(void *data, async_cookie_t coo=
kie)

 static void cyapa_detect_and_start(void *data, async_cookie_t cookie)
 {
+       struct cyapa *cyapa =3D data;
+
        cyapa_detect_async(data, cookie);
+
+       cyapa_start_runtime(cyapa);
 }

 static int cyapa_probe(struct i2c_client *client,
@@ -675,9 +761,15 @@ static int cyapa_remove(struct i2c_client *client)
 {
        struct cyapa *cyapa =3D i2c_get_clientdata(client);

+       pm_runtime_disable(&client->dev);
+
 #ifdef CONFIG_PM_SLEEP
        sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_wakeup_group);
 #endif
+
+#ifdef CONFIG_PM_RUNTIME
+       sysfs_unmerge_group(&client->dev.kobj, &cyapa_power_runtime_group);
+#endif
        free_irq(cyapa->irq, cyapa);

        input_unregister_device(cyapa->input);
@@ -735,12 +827,54 @@ static int cyapa_resume(struct device *dev)

        async_schedule(cyapa_detect_async, cyapa);

+       /* runtime set active to reflect active state. */
+       pm_runtime_disable(dev);
+       pm_runtime_set_active(dev);
+       pm_runtime_enable(dev);
        return 0;
 }
 #endif /* CONFIG_PM_SLEEP */

+#ifdef CONFIG_PM_RUNTIME
+static int cyapa_runtime_suspend(struct device *dev)
+{
+       int ret;
+       struct cyapa *cyapa =3D dev_get_drvdata(dev);
+
+       if (cyapa->ops->cyapa_set_power_mode) {
+               /* set trackpad device to idle mode */
+               ret =3D cyapa->ops->cyapa_set_power_mode(cyapa,
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
+       if (cyapa->ops->cyapa_set_power_mode) {
+               /* resume to full active mode */
+               ret =3D cyapa->ops->cyapa_set_power_mode(cyapa,
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
 static const struct dev_pm_ops cyapa_pm_ops =3D {
        SET_SYSTEM_SLEEP_PM_OPS(cyapa_suspend, cyapa_resume)
+       SET_RUNTIME_PM_OPS(cyapa_runtime_suspend, cyapa_runtime_resume, NUL=
L)
 };

 static const struct i2c_device_id cyapa_id_table[] =3D {
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 1780d82..91fb84a 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -199,6 +199,10 @@ struct cyapa {
        /* power mode settings */
        u8 suspend_power_mode;
        u16 suspend_sleep_time;
+#ifdef CONFIG_PM_RUNTIME
+       u8 runtime_suspend_power_mode;
+       u16 runtime_suspend_sleep_time;
+#endif /* CONFIG_PM_RUNTIME */

        /* read from query data region. */
        char product_id[16];
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C911S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+Ih0jAQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAAEQ2QTkwNkI3
MzYwOEIxNEE4ODUxNTAzMUU0RDU2NDAwAOcGAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBgAGAAcA
HQAmAAUAQAEBIIADAA4AAADeBwYABgAHAB0AJgAFAEABAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAF0AAABbUEFUQ0ggdjIgMy8xNF0gaW5wdXQ6IGN5YXBhOiBhZGQgY3lh
cGEgZHJpdmVyIHJ1bnRpbWUgcG93ZXIgbWFuYWdlbWVudCBpbnRlcmZhY2VzIHN1cHBvcnRlZADk
IAEDkAYANBkAAEsAAAACAX8AAQAAAEIAAAA8NzdCQzcyNUM5MDYyNzY0Rjg3NEQ3OUY1MUUxRjFB
OEY0NDA2QzkxMUBTMDQtTUJYMDEtMDEuczA0LmxvY2FsPgAAAAsAHw4BAAAAAgEJEAEAAAClDAAA
oQwAACwkAABMWkZ11O7AX2EACmZiaWQEAABjY8BwZzEyNTIA/gND8HRleHQB9wKkA+MCAARjaArA
c2V0MCDvB20CgwBQEU0yCoAGtAKAln0KgAjIOwliMTkOwL8JwxZyCjIWcQKAFWIqCbBzCfAEkGF0
BbIOUANgc6JvAYAgRXgRwW4YMF0GUnYEkBe2AhByAMB0fQhQbhoxECAFwAWgG2RkmiADUiAQIhey
XHYIkOR3awuAZDUdUwTwB0ANF3AwCnEX8mJrbWsGcwGQACAgQk1fQuBFR0lOfQr8AfEL8cggQWQc
YHJ1AjAHcaBfc3VzcAnwZCJQLR5QbhhxIkBtBCBwb3Z3G7EDgWEYMAeAAjAguwuAG6FmANAHkQuA
IAEAqx1gJSAnDgBsC4BlCoBHI6QJwAhgcCwgGSAgzyJwBJAEIAWxYXALUA5QvRiAaQIgBCAi8RvS
dANg+QMgdGgZ4CHlI5QmFSQJ0x9gIyJneSfQZhzAGHD8Y2sKsBxgJZQoAAQgKaFmaQXACXBxdS3w
JFNzgi4mFVRFU1Q9ECCnH2An0AOgQ2gDcGUG4I5vH1Au5iYVU2lnGFAEZC0ZMGYtYnk62CBEdScw
MrBkHnAsQIQ8ZDMBQGN5cAlwpQQQLgWgbT4mFS008JcmFQ3gASAgNPBnaQVAmGEvZAUQGjFzLwuA
sHB1dC8EYCeBLzPA5SgQYTQwIGI2XzdpJhUjHbEQMCAxZBGwMTYEZC40MDJiNjdkxjM6sB6gNjQ0
NIg2P3s5LyZRKz8gOB897yZRQAJANdAzNDYsOSD2K0HiOwAgQaEfYSIQOAA3JLEb0DeyXxHABZBr
X3kEAF9vIpAYcSiRB0AoSSvRdWNDhSAqN6MpUyYVQudycQlwdAhwbnZfQ4ZHgShDYkeBJzB2Xm8N
0EYQJZFEUGRGh1zfAABGpUtVRV9F8T0lgkoBvxYgPsVLbC0lScJNASY3o/gtPmMmICRxUEAlkU2W
60tdQANfT4IqQANNAU/1f0ADUR4wgQMgKSJNlk2tcBxtXyHmGDBSwHN5bnRjKCWRKU2eV3kAwHKn
REALYB9gX2IicHlYrDtNrQaQIFiiJcFakXlf8Hdha2UnEFijRoZOFvdLVldxXkRfJaAkcViiJzDm
MFvPS1YvKiSkIeAFMZNhEyPxeWIZ4GN1LZD7HFEycCAwQC/RNEEDgRxg6xiQLI4uRhAvUS0pIk0B
vUvhZVEeXVJP9USQc1BBu0hWQ/BtIsAZoTMRckaGMUGjNzMsQqBCQDgw/Cw4QrpHn0ivSb5RLWg3
30OzQvIiQVhxYQB4NhBqlPtY50tWXCBAW/9XLlKidEN+YTcQGRAidFirJ9A3EDoDUS1vFCBJUlFf
SMBBTkRMRURRF3ZHkUGiNTc0baI1OG2Q/jdCIELIG+Ev0UvVGIApUP5pW0AjQSbjQ5Ujo2CWgUTv
TRBKyHZAURcjIqFdUWNhAENPTkZJR19QZR/QU3zARVBnmD62IwcGkAEBhTlSVU5USZxNRT62QvUE
EGl6IkD1Q4ZzMEB3V5BYQSJ9RUb9TwksXw+Ob49/Tn15AIC2/0YQgKKNX5OPlJ9oghHRRhD9W0Bm
XvdKx04dTE9J8FgiaT+AdmQYgGFYr0tSdfluIHB3gkBsAVOIIe6CBHcEYlvfaf8+GDFNAE0QQwBZ
QVBBX0dFTn4zXv97bATwQBAFEAIwZj4olkEnMKFgoZCF0ElaEkUnMCIlDHBcbiLfko9yn4HDm/Rv
cG+LEB5wdmVg8CISKJvlXuBNnmX+bBIApe+i/6QPpR+rr3Lt/5zfqNlh2XZfiV9DwicQmiH/IkCK
/4wPjR+6D7sfkC+RP/+ST79fwG9y+H/jlecnMYnl/whgAjCWf5ePmJ+Zr5q/QpEfIhKen1zplkGg
8k5VTPBMIHx8w4Sg8hIwzCF/H1EAIAhgOwCt1B6QJzAmfbMjKUq4X35J0mPBYWQi/QuAdgdAcPEp
5iJlrTEjBPcj8COBCsBhB4Aboa8SyB+Je10tRSAgVkFMTZ7ftA9OFmNg1I5jcFcpsAOg3ymi0l8E
AJXSGcFkJzBXfPtmUjPxdQeA2Y8oACORECD7IgEHQGwsQCJlHFEllCcw/7Z0ZlMpsRhQB+Cb5d6P
KAD/ZjLasnfcZlLbNiSx4ikjtP8EcS7m2fhntndfWA/ErLFf77JuU4ao2UP0KLMs7C+dL/+eNE0A
1I9zK+9IqLGb5WqW/+0Pst/pj3hfeW/E6HvVw5ODs3+0j0RFVklDrmDgQVRUUij3byL4JzCEU198
QFVHT3wCwfBXVVNSvp/0n4q/IwT/A78EzrZ/Itdh37UXgE1GFZ+B9QD2JHE/kCUwW12DKn1OFiZJ
0oCi6jcBfyNwLv++X0tRy9IHR4P4C45/34Dv9w39gt9OFi4kIO6DggQZ0/5fG3IHThMDKMDutg4P
DxL/FJ8Vr3DEc4cJwRFVRU9GWf/Eb06PT59Qrcou9v/yr00QwFBXUl9NTwAwAtD/fLHwnyrP7b8H
X6d/qI8uz8+dnvxPyyJbYHNmRHDT0DZy3LAYJCgQsihga2/8YmrOQR5/GaZe78/6XkDX/ZDQ5dCx
b+eQY94g/+H93KAgXkTRxw7l5/DUP+ns/6tAWyBmsBGAYSD8D+ndEeD/vYH7b0L/QWtE2FLRWvBb
c0HhgEFVVE9TA4BQiaGgRF8AMExBWUW/890J5kBhYu4QW43+t4Sg/6s5Ie8i/yQPzsNNSYTPiFb/
6PlyFk8ZJ6C+EAzARLDrAx9w1ceh4YBWs5wQb29r/yigw2NYUjsWg0nFH8YqUJ3OKceSyCZ+Ezg5
fvBtwMA2NzEsMTFuMlWf/1avV79YzHIWTq9f1wHCT9L/YK9hv1kvxP/GDV05VQdzG/9f62ZUZ6Up
P3MeT/l07f6nL2NNrZEeZoLgYrgHaTJ/ZvEokyShKJMHRn4SXpA1oix/ECs3Nl6xNX8p/3P43iCe
UEJhdP92BmgPWj//xgx6QurCKITHk3sFhBZKX3vqN1Lgc0wTKAAomG6/IOWHX1MtoEVQfB43kxFg
+zfrKIkuOQ+cAD50OqVx5/9StG7ehI9T9Wi+hu+H/4kPbzo8yCeLewfmZt4gEbBp/HJxNBaVkW4x
cZtr3Wvw9/rCEWDeIGfcQNPxSGEnQk+Vx5hySjdd4jczd2AxAjJecDgyNyw1NP94H3kk3kK4H0WR
lw8H42a0s9uw5uBkdUwxbM9jln/f2I7RyN3BQiTd5GbuEAzC/6Wk/8Ln4Oj/gW9MPqg/Qd/vqi9L
b6yJ1X0wce+LVlMc/4WTp4iMX41vC7t4yRFsng//nxgln3Pj/VHILn0Pxp/Hr8c2X1wQKBVvcHMo
YQV0/75hNZlojwfnUyGlUh4QrAD+a9OQ4Qbd4mRQ7hDno6eP/9VqHkbBb/MINBQHT8xfLm//NN/z
U8tf0O/Nfy9/+L/RW//A0v1ROx87rzywPYE9FaTXseYVZmFp7hDc0SXjIP8/8eGA1kLUj/zsu4/X
YP6v//zdsIf+n7Zft2idr7kvwz//u0+8X71vvn/e/8CfyY/Cv6/Dz6Sx5BPGImahUGylhv/Gv8fP
yN/t/8r/94/4Wiz3lkYUYQCQQ1QgVkUCoP4w24/Vj/sP16/Yv/DW2l//22/cf+d/3p/fr+C/Uo9T
n/9UrRZfJvQsEKsg9PEeZgy0Ixo5/cZTRVSFgFlTjFRFhXWFUk9QU6GF/9NVorXj9fzeDxIJhRAc
0t33EWfjm2aQTvoBe2ggxwqv/wu5ekInJJWAZGZkUDCAglKcW10N2ghx7NAtLZkAjaaRL+qArDFy
cy+YYxYv8kBEgS+Rwy5oID5iHd8e6WvVa/AnoHggIDE3ODBkm/AuLkA5MWZiODQkkDFgMDA2NDRr
1R1gLX8dvyCvVNImoB+fJW9dtTH6OV5ANl5wKWIjUJxUXFn/Dg8IsfXj8jSrwT4iDPDylzn9xnU4
2cb12a8edTH/KaDTXzAXtG+N3y53zk8vn/81BzEx0t8x/wg/CU+ff/CVg8WRlUBvbSBxdSdAfnlq
86YhmQALoKd5bEdov2WwqJCQMKFAYCFkUFsxMPJdsJZUaIIw8jAAQIJA/36gZqDaIWVQPxDqwBlA
oRD/AHA4sELxSKALghlAa/A7UO55dJBDIVwQbyzAHZAM8Gk5EGJzZFBpZbB/AHP77wALkWZkUH8R
RvDxsGvw3mZGIETQGWA/wkns0B2R/0EgDPB0wLhApiHlIKwx2jDvRWH/EUYgZpBwxoBgUENx9mTl
AEtxdKEgpUEh8SzA30OS//AAcEbhp1BsPxFNgJdk8UwBQugua9V9fWwgAU+wAAAAHwBCAAEAAAAU
AAAARAB1AGQAbABlAHkAIABEAHUAAAAfAGUAAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMA
cwAuAGMAbwBtAAAAAAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAFgAAAAAAAAAgSsf
pL6jEBmdbgDdAQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAA
YwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAHwACXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBz
AHMALgBjAG8AbQAAAAAAHwDlXwEAAAAqAAAAcwBpAHAAOgBkAHUAZABsAEAAYwB5AHAAcgBlAHMA
cwAuAGMAbwBtAAAAAAAfABoMAQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AHwwBAAAAIgAA
AGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAA
AAAAAAIBGQwBAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1
AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAFdAQAAACIA
AABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAPg/AQAAABQAAABEAHUAZABs
AGUAeQAgAEQAdQAAAB8AI0ABAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0A
AAAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0B
D1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUA
cwBzAC4AYwBvAG0AAAAfAAldAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBt
AAAAAAAfADFAAQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAA
SQBQAE0ALgBOAG8AdABlAAAAAAADAPE/BAgAAAsAQDoBAAAAAwD9P6gDAAACAQswAQAAABAAAADW
qQa3NgixSohRUDHk1WQAAwAXAAEAAABAADkAAN2HElmBzwFAAAgwXhYWE1mBzwELACkAAAAAAAsA
IwAAAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBh
AGcAZQAAAAAAAQAAABoAAAB6AGgALQBDAE4ALAAgAGUAbgAtAFUAUwAAAAAACwAAgAggBgAAAAAA
wAAAAAAAAEYAAAAABoUAAAAAAAAfADcAAQAAALoAAABbAFAAQQBUAEMASAAgAHYAMgAgADMALwAx
ADQAXQAgAGkAbgBwAHUAdAA6ACAAYwB5AGEAcABhADoAIABhAGQAZAAgAGMAeQBhAHAAYQAgAGQA
cgBpAHYAZQByACAAcgB1AG4AdABpAG0AZQAgAHAAbwB3AGUAcgAgAG0AYQBuAGEAZwBlAG0AZQBu
AHQAIABpAG4AdABlAHIAZgBhAGMAZQBzACAAcwB1AHAAcABvAHIAdABlAGQAAAAAAB8APQABAAAA
AgAAAAAAAAADADYAAAAAAAIBcQABAAAAFgAAAAHPgVjmuUS2XT4CSEuCivOCVSmUiNgAAB8AcAAB
AAAAugAAAFsAUABBAFQAQwBIACAAdgAyACAAMwAvADEANABdACAAaQBuAHAAdQB0ADoAIABjAHkA
YQBwAGEAOgAgAGEAZABkACAAYwB5AGEAcABhACAAZAByAGkAdgBlAHIAIAByAHUAbgB0AGkAbQBl
ACAAcABvAHcAZQByACAAbQBhAG4AYQBnAGUAbQBlAG4AdAAgAGkAbgB0AGUAcgBmAGEAYwBlAHMA
IABzAHUAcABwAG8AcgB0AGUAZAAAAAAAHwA1EAEAAACEAAAAPAA3ADcAQgBDADcAMgA1AEMAOQAw
ADYAMgA3ADYANABGADgANwA0AEQANwA5AEYANQAxAEUAMQBGADEAQQA4AEYANAA0ADAANgBDADkA
MQAxAEAAUwAwADQALQBNAEIAWAAwADEALQAwADEALgBzADAANAAuAGwAbwBjAGEAbAA+AAAAAwDe
P59OAAALAACACCAGAAAAAADAAAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABG
AAAAAAGFAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAYEAAAAAAAADAIAQ/////wUAAIAD
IAYAAAAAAMAAAAAAAABGAAAAAAKBAAAAAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAAByB
AAAAAAAAQAAHMPtNqRFZgc8BCwACAAEAAAADACYAAAAAAAIBEDABAAAARgAAAAAAAACxH6E5MCBR
Rp20pXDe0J/UBwB3vHJckGJ2T4dNefUeHxqPAAAAmTwbAAC6pz7uy9f3QKN27zX8YVmJABiD/MNI
AAAAAB8A+j8BAAAAFAAAAEQAdQBkAGwAZQB5ACAARAB1AAAAAwAJWQEAAAADAACACCAGAAAAAADA
AAAAAAAARgAAAAAQhQAAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2AGUA
cgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAC6AAAASQBJ
AD0AMAAxAEMARgA4ADEANQA4AEUANgBCADkANAA0AEIANgA1AEQAMwBFADAAMgA0ADgANABCADgA
MgA4AEEARgAzADgAMgA1ADUAMgA5ADkANAA4ADgARAA4ADsAVgBlAHIAcwBpAG8AbgA9AFYAZQBy
AHMAaQBvAG4AIAAxADQALgAzACAAKABCAHUAaQBsAGQAIAAxADcANAAuADAAKQAsACAAUwB0AGEA
ZwBlAD0ASAA0AAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAATgQAAAQAAAAMAAIADIAYAAAAA
AMAAAAAAAABGAAAAACOBAAD///9/AwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEIEAAAAAAAADAACA
AyAGAAAAAADAAAAAAAAARgAAAAARgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACSBAAAA
AAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAALIEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAA
AAApgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAACqBAAAAAAAAHwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAJ4EAAAEAAAACAAAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABKBAAABAAAA
HwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAIYEAAAEAAAACAAAAAAAAAAsAAIADIAYAAAAAAMAAAAAA
AABGAAAAAAOBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJoEAAAAAAAALAACACCAGAAAA
AADAAAAAAAAARgAAAAAOhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAABiFAAAAAAAACwAA
gAggBgAAAAAAwAAAAAAAAEYAAAAAgoUAAAAAAABAAACACCAGAAAAAADAAAAAAAAARgAAAAC/hQAA
EIMWKleBzwEDAA00/T8AAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACAAAAB4AC0AbQBzAC0AaABh
AHMALQBhAHQAdABhAGMAaAAAAAEAAAACAAAAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAACIA
AAB4AC0AbwByAGkAZwBpAG4AYQB0AGkAbgBnAC0AaQBwAAAAAAABAAAAHgAAAFsAMQAwAC4AMwAw
AC4AMQAyAC4AMQA0ADYAXQAAAAAAMRI=

--_000_77BC725C9062764F874D79F51E1F1A8F4406C911S04MBX0101s04lo_--
