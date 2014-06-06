Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbaFFH3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:29:50 -0400
Received: from relay-s04-hub004.domainlocalhost.com ([74.115.207.103]:31016
	"EHLO relay-S04-HUB004.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752715AbaFFH3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:29:45 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F4406C919S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Benson Leung <bleung@google.com>, Lily Rui <lily@cypress.com>,
        "Daniel Kurtz" <djkurtz@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: [PATCH v2 14/14] input: cyapa: add function to monitor LID close
 event to off trackpad device
Thread-Topic: [PATCH v2 14/14] input: cyapa: add function to monitor LID
 close event to off trackpad device
Thread-Index: Ac+BWPLtc8FVhDQ7Qvib+W/3hPTClQ==
Date: Fri, 6 Jun 2014 07:29:43 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F4406C919@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F4406C919@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.146]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F4406C919S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Add the function to monitor lid close event to suspend and resume
trackpad device.
Because system suspend takes some time to trigger from user space,
and in that time, the lid panel of the laptop may couple with the
active trackpad. This may generate stray input events, which may
in turn cancel the suspend if the drivers use pm_wakup_event(), and
those input events may trigger something unwanted in the UI.
So this patch adds the function to do off the trackpad device quickly.
When the lid is closed, as soon as possible, the trakcpad device must
be off. And furthermore, the policy on lid close is not always to
enter suspend (lid closed with external display), and at this time,
the trackpad device must be disabled as well as again to avoid the
risk of generating stray events.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 8d37032..760a43b 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -1166,6 +1166,140 @@ static const struct attribute_group cyapa_sysfs_gro=
up =3D {
        .attrs =3D cyapa_sysfs_entries,
 };

+
+/*
+ * We rely on EV_SW and SW_LID bits to identify a LID device, and hook
+ * up our filter to listen for SW_LID events to enable/disable touchpad wh=
en
+ * LID is open/closed.
+ */
+static const struct input_device_id lid_device_ids[] =3D {
+       {
+               .flags =3D INPUT_DEVICE_ID_MATCH_EVBIT |
+                        INPUT_DEVICE_ID_MATCH_SWBIT,
+               .evbit =3D { BIT_MASK(EV_SW) },
+               .swbit =3D { BIT_MASK(SW_LID) },
+       },
+       { },
+};
+
+static int lid_device_connect(struct input_handler *handler,
+                             struct input_dev *dev,
+                             const struct input_device_id *id)
+{
+       struct input_handle *lid_handle;
+       int error;
+
+       pr_info("cyapa: LID device: '%s' connected\n", dev->name);
+       lid_handle =3D kzalloc(sizeof(struct input_handle), GFP_KERNEL);
+       if (!lid_handle)
+               return -ENOMEM;
+
+       lid_handle->dev =3D dev;
+       lid_handle->handler =3D handler;
+       lid_handle->name =3D "lid_event_handler";
+       lid_handle->private =3D handler->private;
+
+       error =3D input_register_handle(lid_handle);
+       if (error) {
+               pr_err("Failed to register lid_event_handler, error %d\n",
+                      error);
+               goto err_free;
+       }
+
+       error =3D input_open_device(lid_handle);
+       if (error) {
+               pr_err("Failed to open input device, error %d\n", error);
+               goto err_unregister;
+       }
+
+       return 0;
+err_unregister:
+       input_unregister_handle(lid_handle);
+err_free:
+       kfree(lid_handle);
+       return error;
+}
+
+static void lid_device_disconnect(struct input_handle *handle)
+{
+       input_close_device(handle);
+       input_unregister_handle(handle);
+       kfree(handle);
+}
+
+static bool lid_event_filter(struct input_handle *handle,
+                            unsigned int type, unsigned int code, int valu=
e)
+{
+       struct cyapa *cyapa =3D handle->private;
+       struct device *dev =3D &cyapa->client->dev;
+
+       if (type =3D=3D EV_SW && code =3D=3D SW_LID) {
+               pr_info("cyapa %s: %s touch device\n",
+                       dev_name(&cyapa->client->dev),
+                       (value ? "disable" : "enable"));
+               if (cyapa->suspended) {
+                       /*
+                        * If the lid event filter is called while suspende=
d,
+                        * there is no guarantee that the underlying i2cs a=
re
+                        * resumed at this point, so it is not safe to issu=
e
+                        * the command to change power modes.
+                        * Instead, rely on cyapa_resume to set us back to
+                        * PWR_MODE_FULL_ACTIVE.
+                        */
+                       pr_info("cyapa %s: skipping lid pm change in suspen=
d\n",
+                               dev_name(&cyapa->client->dev));
+                       return false;
+               }
+               if (value =3D=3D 0) {
+                       if (cyapa->ops->cyapa_set_power_mode)
+                               cyapa->ops->cyapa_set_power_mode(cyapa,
+                                               PWR_MODE_FULL_ACTIVE, 0);
+                       pm_runtime_set_active(dev);
+                       pm_runtime_enable(dev);
+               } else {
+                       pm_runtime_disable(dev);
+                       if (cyapa->ops->cyapa_set_power_mode)
+                               cyapa->ops->cyapa_set_power_mode(cyapa,
+                                               PWR_MODE_OFF, 0);
+               }
+       }
+
+       return false;
+}
+
+static void lid_event_register_handler(struct cyapa *cyapa)
+{
+       int error;
+       struct input_handler *lid_handler =3D &cyapa->lid_handler;
+
+       if (cyapa->lid_handler_registered) {
+               pr_err("lid handler is registered already\n");
+               return;
+       }
+
+       lid_handler->filter     =3D lid_event_filter;
+       lid_handler->connect    =3D lid_device_connect;
+       lid_handler->disconnect =3D lid_device_disconnect;
+       lid_handler->name       =3D "cyapa_lid_event_handler";
+       lid_handler->id_table   =3D lid_device_ids;
+       lid_handler->private    =3D cyapa;
+
+       error =3D input_register_handler(lid_handler);
+       if (error) {
+               pr_err("Failed to register lid handler(%d)\n", error);
+               return;
+       }
+       cyapa->lid_handler_registered =3D true;
+}
+
+static void lid_event_unregister_handler(struct cyapa *cyapa)
+{
+       if (cyapa->lid_handler_registered) {
+               input_unregister_handler(&cyapa->lid_handler);
+               cyapa->lid_handler_registered =3D false;
+       }
+}
+
 void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa =3D (struct cyapa *)data;
@@ -1186,6 +1320,7 @@ static void cyapa_detect_and_start(void *data, async_=
cookie_t cookie)
        cyapa_detect_async(data, cookie);

        cyapa_start_runtime(cyapa);
+       lid_event_register_handler(cyapa);
 }

 static int cyapa_probe(struct i2c_client *client,
@@ -1324,6 +1459,7 @@ static int cyapa_remove(struct i2c_client *client)
        mutex_destroy(&cyapa->debugfs_mutex);

        input_unregister_device(cyapa->input);
+       lid_event_unregister_handler(cyapa);
        if (cyapa->ops->cyapa_set_power_mode)
                cyapa->ops->cyapa_set_power_mode(cyapa, PWR_MODE_OFF, 0);
        i2c_set_clientdata(client, NULL);
@@ -1340,6 +1476,7 @@ static int cyapa_suspend(struct device *dev)
        struct cyapa *cyapa =3D dev_get_drvdata(dev);

        cyapa_disable_irq(cyapa);
+       cyapa->suspended =3D true;

        /*
         * Set trackpad device to idle mode if wakeup is allowed,
@@ -1382,6 +1519,7 @@ static int cyapa_resume(struct device *dev)
        pm_runtime_disable(dev);
        pm_runtime_set_active(dev);
        pm_runtime_enable(dev);
+       cyapa->suspended =3D false;
        return 0;
 }
 #endif /* CONFIG_PM_SLEEP */
diff --git a/drivers/input/mouse/cyapa.h b/drivers/input/mouse/cyapa.h
index 7f8c3d4..616db23 100644
--- a/drivers/input/mouse/cyapa.h
+++ b/drivers/input/mouse/cyapa.h
@@ -219,6 +219,7 @@ struct cyapa {
        u8 runtime_suspend_power_mode;
        u16 runtime_suspend_sleep_time;
 #endif /* CONFIG_PM_RUNTIME */
+       bool suspended;

        /* read from query data region. */
        char product_id[16];
@@ -259,6 +260,9 @@ struct cyapa {
        size_t tp_raw_data_size;

        const struct cyapa_dev_ops *ops;
+
+       bool lid_handler_registered;
+       struct input_handler lid_handler;
 };


This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F4406C919S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
ZQB5ACAARAB1AAAAHwAjQAEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8AbQAA
AAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAABYAAAAAAAAAIErH6S+oxAZnW4A3QEP
VAIAAACARAB1AGQAbABlAHkAIABEAHUAAABTAE0AVABQAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBz
AHMALgBjAG8AbQAAAB8ACV0BAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0A
AAAAAB8AMUABAAAAAgAAAAAAAAALAEA6AQAAAB8AMEABAAAAAgAAAAAAAAAfABoAAQAAABIAAABJ
AFAATQAuAE4AbwB0AGUAAAAAAAMA8T8ECAAACwBAOgEAAAADAP0/qAMAAAIBCzABAAAAEAAAAE1U
VA7UPUVLllcTkPFnUUMDABcAAQAAAEAAOQCAzYIVWYHPAUAACDAfvqUVWYHPAQsAKQAAAAAACwAj
AAAAAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEA
ZwBlAAAAAAABAAAAGgAAAHoAaAAtAEMATgAsACAAZQBuAC0AVQBTAAAAAAALAACACCAGAAAAAADA
AAAAAAAARgAAAAAGhQAAAAAAAB8ANwABAAAAvAAAAFsAUABBAFQAQwBIACAAdgAyACAAMQA0AC8A
MQA0AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAYQBkAGQAIABmAHUAbgBjAHQAaQBv
AG4AIAB0AG8AIABtAG8AbgBpAHQAbwByACAATABJAEQAIABjAGwAbwBzAGUAIABlAHYAZQBuAHQA
IAB0AG8AIABvAGYAZgAgAHQAcgBhAGMAawBwAGEAZAAgAGQAZQB2AGkAYwBlAAAAHwA9AAEAAAAC
AAAAAAAAAAMANgAAAAAAAgFxAAEAAAAWAAAAAc+BWPLtc8FVhDQ7Qvib+W/3hPTClQAAHwBwAAEA
AAC8AAAAWwBQAEEAVABDAEgAIAB2ADIAIAAxADQALwAxADQAXQAgAGkAbgBwAHUAdAA6ACAAYwB5
AGEAcABhADoAIABhAGQAZAAgAGYAdQBuAGMAdABpAG8AbgAgAHQAbwAgAG0AbwBuAGkAdABvAHIA
IABMAEkARAAgAGMAbABvAHMAZQAgAGUAdgBlAG4AdAAgAHQAbwAgAG8AZgBmACAAdAByAGEAYwBr
AHAAYQBkACAAZABlAHYAaQBjAGUAAAAfADUQAQAAAIQAAAA8ADcANwBCAEMANwAyADUAQwA5ADAA
NgAyADcANgA0AEYAOAA3ADQARAA3ADkARgA1ADEARQAxAEYAMQBBADgARgA0ADQAMAA2AEMAOQAx
ADkAQABTADAANAAtAE0AQgBYADAAMQAtADAAMQAuAHMAMAA0AC4AbABvAGMAYQBsAD4AAAADAN4/
n04AAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAOFAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAAAYUAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAABgQAAAAAAAAMAgBD/////BQAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAAAoEAAAAAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAHIEA
AAAAAABAAAcwF1g7FFmBzwELAAIAAQAAAAMAJgAAAAAAAgEQMAEAAABGAAAAAAAAALEfoTkwIFFG
nbSlcN7Qn9QHAHe8clyQYnZPh0159R4fGo8AAACZPBsAALqnPu7L1/dAo3bvNfxhWYkAGIP8w1MA
AAAAHwD6PwEAAAAUAAAARAB1AGQAbABlAHkAIABEAHUAAAADAAlZAQAAAAMAAIAIIAYAAAAAAMAA
AAAAAABGAAAAABCFAAAAAAAAHwAAgB+k6zOoei5Cvnt54amOVLMBAAAAOAAAAEMAbwBuAHYAZQBy
AHMAYQB0AGkAbwBuAEkAbgBkAGUAeABUAHIAYQBjAGsAaQBuAGcARQB4AAAAAQAAALoAAABJAEkA
PQAwADEAQwBGADgAMQA1ADgARgAyAEUARAA3ADMAQwAxADUANQA4ADQAMwA0ADMAQgA0ADIARgA4
ADkAQgBGADkANgBGAEYANwA4ADQARgA0AEMAMgA5ADUAOwBWAGUAcgBzAGkAbwBuAD0AVgBlAHIA
cwBpAG8AbgAgADEANAAuADMAIAAoAEIAdQBpAGwAZAAgADEANwA0AC4AMAApACwAIABTAHQAYQBn
AGUAPQBIADQAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAAABOBAAABAAAAAwAAgAMgBgAAAAAA
wAAAAAAAAEYAAAAAI4EAAP///38DAACAAyAGAAAAAADAAAAAAAAARgAAAAAQgQAAAAAAAAMAAIAD
IAYAAAAAAMAAAAAAAABGAAAAABGBAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAJIEAAAAA
AAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAsgQAAAAAAAAMAAIADIAYAAAAAAMAAAAAAAABGAAAA
ACmBAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAKoEAAAAAAAAfAACAAyAGAAAAAADAAAAA
AAAARgAAAAAngQAAAQAAAAIAAAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEoEAAAEAAAAf
AACAAyAGAAAAAADAAAAAAAAARgAAAAAhgQAAAQAAAAIAAAAAAAAACwAAgAMgBgAAAAAAwAAAAAAA
AEYAAAAAA4EAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAAAAAmgQAAAAAAAAsAAIAIIAYAAAAA
AMAAAAAAAABGAAAAAA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACA
CCAGAAAAAADAAAAAAAAARgAAAACChQAAAAAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYB
AAAAIAAAAHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYD
AgAAAAAAwAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAA
AAEAAAAeAAAAWwAxADAALgAzADAALgAxADIALgAxADQANgBdAAAAAAA7tA==

--_000_77BC725C9062764F874D79F51E1F1A8F4406C919S04MBX0101s04lo_--
