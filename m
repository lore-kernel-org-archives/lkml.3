Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaDPIjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 04:39:40 -0400
Received: from relay-s04-hub006.domainlocalhost.com ([74.115.207.217]:41341
	"EHLO relay-S04-HUB006.domainlocalhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbaDPIjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 04:39:37 -0400
Content-Type: multipart/mixed;
	boundary="_000_77BC725C9062764F874D79F51E1F1A8F40C14099S04MBX0101s04lo_"
From: Dudley Du <dudl@cypress.com>
To: "Dmitry Torokhov (dmitry.torokhov@gmail.com)" 
	<dmitry.torokhov@gmail.com>
CC: Benson Leung <bleung@google.com>, Daniel Kurtz <djkurtz@google.com>,
        "David Solda" <dso@cypress.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/6] input: cyapa: enable/disable trackpad device based on
 LID state
Thread-Topic: [PATCH 4/6] input: cyapa: enable/disable trackpad device based
 on LID state
Thread-Index: Ac9Xtrung2rcRTzSQqSjaCWaMF8SMwBmHYhA
Date: Wed, 16 Apr 2014 08:39:34 +0000
Message-ID: <77BC725C9062764F874D79F51E1F1A8F40C14099@S04-MBX01-01.s04.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: <77BC725C9062764F874D79F51E1F1A8F40C14099@S04-MBX01-01.s04.local>
x-originating-ip: [10.30.12.153]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_000_77BC725C9062764F874D79F51E1F1A8F40C14099S04MBX0101s04lo_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Rely on EV_SW and SW_LID bits to identify a LID device, and hook
up our filter to listen for SW_LID events to enable/disable touchpad when
LID is open/closed.
TEST=3Dtest on Chomebooks.

Signed-off-by: Du, Dudley <dudl@cypress.com>
---
diff --git a/drivers/input/mouse/cyapa.c b/drivers/input/mouse/cyapa.c
index 6820b3f..da03427 100644
--- a/drivers/input/mouse/cyapa.c
+++ b/drivers/input/mouse/cyapa.c
@@ -523,6 +523,9 @@ struct cyapa {
        int physical_size_x;
        int physical_size_y;

+       bool lid_handler_registered;
+       struct input_handler lid_handler;
+
        /* used in ttsp and truetouch based trackpad devices. */
        u8 x_origin;  /* X Axis Origin: 0 =3D left side; 1 =3D rigth side. =
*/
        u8 y_origin;  /* Y Axis Origin: 0 =3D top; 1 =3D bottom. */
@@ -3107,6 +3110,125 @@ static void cyapa_start_runtime(struct cyapa *cyapa=
)
 static void cyapa_start_runtime(struct cyapa *cyapa) {}
 #endif /* CONFIG_PM_RUNTIME */

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
+       if (error)
+               goto err_free;
+
+       error =3D input_open_device(lid_handle);
+       if (error)
+               goto err_unregister;
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
+                       return false;
+               }
+               if (value =3D=3D 0) {
+                       if (cyapa->cyapa_set_power_mode)
+                               cyapa->cyapa_set_power_mode(cyapa,
+                                               PWR_MODE_FULL_ACTIVE, 0);
+                       pm_runtime_set_active(dev);
+                       pm_runtime_enable(dev);
+               } else {
+                       pm_runtime_disable(dev);
+                       if (cyapa->cyapa_set_power_mode)
+                               cyapa->cyapa_set_power_mode(cyapa,
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
+       if (cyapa->lid_handler_registered)
+               return;
+
+       lid_handler->filter     =3D lid_event_filter;
+       lid_handler->connect    =3D lid_device_connect;
+       lid_handler->disconnect =3D lid_device_disconnect;
+       lid_handler->name       =3D "cyapa_lid_event_handler";
+       lid_handler->id_table   =3D lid_device_ids;
+       lid_handler->private    =3D cyapa;
+
+       error =3D input_register_handler(lid_handler);
+       if (error)
+               return;
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
 static void cyapa_detect_async(void *data, async_cookie_t cookie)
 {
        struct cyapa *cyapa =3D (struct cyapa *)data;
@@ -3126,6 +3248,7 @@ static void cyapa_detect_and_start(void *data, async_=
cookie_t cookie)
        cyapa_detect_async(data, cookie);

        cyapa_start_runtime(cyapa);
+       lid_event_register_handler(cyapa);
 }

 static int cyapa_probe(struct i2c_client *client,
@@ -3221,7 +3344,7 @@ static int cyapa_remove(struct i2c_client *client)

        free_irq(cyapa->irq, cyapa);
        input_unregister_device(cyapa->input);
-
+       lid_event_unregister_handler(cyapa);
        if (cyapa->cyapa_set_power_mode)
                cyapa->cyapa_set_power_mode(cyapa, PWR_MODE_OFF, 0);
        i2c_set_clientdata(client, NULL);
This message and any attachments may contain Cypress (or its subsidiaries) =
confidential information. If it has been received in error, please advise t=
he sender and immediately delete this message.

--_000_77BC725C9062764F874D79F51E1F1A8F40C14099S04MBX0101s04lo_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

eJ8+IoA2AQaQCAAEAAAAAAABAAEAAQeQBgAIAAAA5AQAAAAAAADoAAEJgAEAIQAAADczMTgxQTNC
QURERDU1NEZBODNBMEQ1MjdBOUZBQTQ0AFQHAQ2ABAACAAAAAgACAAEFgAMADgAAAN4HBAAQAAgA
JwAiAAMATQEBIIADAA4AAADeBwQAEAAIACcAIgADAE0BAQiABwAYAAAASVBNLk1pY3Jvc29mdCBN
YWlsLk5vdGUAMQgBBIABAEwAAABbUEFUQ0ggNC82XSBpbnB1dDogY3lhcGE6IGVuYWJsZS9kaXNh
YmxlIHRyYWNrcGFkIGRldmljZSBiYXNlZCBvbiBMSUQgc3RhdGUArRkBA5AGAHwWAABOAAAAAgF/
AAEAAABCAAAAPDc3QkM3MjVDOTA2Mjc2NEY4NzRENzlGNTFFMUYxQThGNDBDMTQwOTlAUzA0LU1C
WDAxLTAxLnMwNC5sb2NhbD4AAAALAB8OAQAAAAIBCRABAAAABAoAAAAKAABJHAAATFpGdYwvGkxh
AApmYmlkBAAAY2PAcGcxMjUyAP4DQ/B0ZXh0AfcCpAPjAgAEY2gKwHNldDAg7wdtAoMAUBFNMgqA
BrQCgJZ9CoAIyDsJYjE5DsC/CcMWcgoyFnECgBViKgmwcwnwBJBhdAWyDlADYHOibwGAIEV4EcFu
GDBdBlJ2BJAXtgIQcgDAdH0IUG4aMRAgBcAFoBtkZJogA1IgECIXslx2CJDkd2sLgGQ1HVME8AdA
DRdwMApxF/Jia21rBnMBkAAgIEJNX0LgRUdJTn0K/AHxC/FhB/BlbHkgAiAZYFZwX1NXIABwHGAi
UF/QTElEIA3AdAQgGJA2IA3QCfB0BpAh0GEgRyLyAQAdYGNlLCJzaKBvb2tcbAuAZQqA/HVwIeAI
cBxwAxAboiOB/yWwH2AJ8BxwBbEixSSwI9HvI2MJ8AGgHnAvDeEpAiNxznURwAqwHGB3aAnwJaWX
IvIEACHgcAnwL2MJAAkSAGQuJaVURVNU7j0QIB9gIeJDJWAHgAbgjSWAcyw2JaVTaWcYUARkLRkw
Zi1ieTrYIER1JQAwAGQecCHQhDxkMFFAY3lwCXClBBAuBaBtPiWlLTJA1yWlDeABICAyQGcjQCJw
JylABRAaMXMvC4BwdTR0LwRgdRIAK8B5Yf8KsDGAIyAzrzS5JaUdsRAwCCA2OAHQYjNmLgAuZGEw
MzQyN+IgHpE2NDQx2DOPNn89JeErPHA1bzs/JeFAQIMzIA6wMyw2ICs/Muw5ID7xH2ByKfAFQDTz
dwMwAAAltCBBlQuABUBwLGh5DkEHQF8AkHpl3F94FiBBP0JNeUNGPAbPQ8Ut0QMgJbBkXxmhMGH8
cl8JcDNQJ0EJcUNGRmY/QDU9U0dmRypIl0NdLyr+IDSxHGALgBzAI1AmICKC70BBEhAp4iMgYU1S
QEAA0I5rKiIkpC4QICovQ13gdTggeF8FsC8gC4BCO0zzWCBBeCtRT/dR4y/gEjA9JxABcUAgI7Ht
UjAxU5FR4XRO0FQSUF+1UWN5UctZUq8jcXBUVF8G4AJAA3BVWT7yMx6QN/c/YlqgHpAsDpE/9BiA
DlD4IHZvDdBAlELQH3JH4FZ1I+EHgChAOyo08ynvQ1Zb71z/Xg8pQPIgQENlDiMJ8DLhTQJDT05G
EElHX1Af0FJVTrBUSU1FVWhLrStNEPtF900gVxngCXAhzyLfI+//JP9ngyYfJy8oPylPKlpnku8r
HywnZ5FVhitfpRvhLSE7SZtrBF9gMUcydfdzWz5dU5FBB0Zmd89Dxi5mHQtgZwQgU6AgIFBVVIRf
RGiASUNFX2lggF9NQVRDSF9ogOBCSVQgfHj/eX16//d8A2iwfHEsfM96BWsQaZGPd5MfsHyAe+FT
Syhog71i0X2Af3n2A+CCLyhpJP+Dn3iihz+CgYhJYxBLnnRGf0RCdpkb4RhQQHBhlkoMKv9HdYPf
kC9JX2sBVWBrAY8v75PfQ8J0z3XaKg3QXxZMEPd33o1fcEEqRzhInkRCBJCfA2BLj0ZmRzhTkWt6
B0B9CQBjYZBC8RkwjU8wYSkBa2BHRlBfS0VSME5FTCmazzMQKCFvRziXN3l9CXB0CHADoC1oRU5P
ZUBNnF+dby3+PpJSU6BrAUiep3pKZlOgv0suqV+oEG+QB4BTkSJHMvtu40dmIqufp4kxMDzwGID/
nmJHdbCXpf9DxZwDU5FKBPtH9kdlKKL5oa+isZwDo5/dQ8VnWWBvYZwQXwNQCeD/sl+zb0oicmJ1
5bWvtr+3z7+430fQYTBH9rpPpKwwSJf9wXw6mt9KIsG4tT+9+bnG/cXOa7oCyD/DL5v+YyaK7v9g
E3aZDeGM35lqoz2Xz0oE/yvTvObLr8Zvx3vWL8qq2R7/zm90RkbnrhRtJNGf0qmS39/hj1FSAIEv
MkQzdDEga1H/4tsFoAEAa2BEQrDgCkHTX/+YTl5aqvexz5hdawSSg1OR/iY086gQK9AIkAIwqBPC
X5+iOeOiU5BToGiEJibkw9/vMoaneO+iOewVczSwcnH/AQCXIPD/9O9nCfavQ8RNIP5JMxBU4Bng
RzFu1G0WcjH/HlEecCpCAxAZ4PNH4I/3L5f4YglwciJuafBndQrA/wBwECBwURHQ44H4gWEwBIHL
aCALgGdqADJjBCAKwO5l+2/8fzFBdQeAHGD/A/1yMXBgIBCga2AZIGoASeHz/fJT8WFmcFJyIfNA
AJ//Aa/4YzGRExFOMWnwGZUDwP53G7E0kA9ALhcGT/eplVH+ZSowa2BoBmBkAsRp0hIBP00xTuFP
gGnRCh8LL1BXClJ74E97UF9GVUyQTF9BQ2UgVkUKD+8QL3PHE4+ku2ZCsDTA6b6/FZbb6PGvosDl
c+8yMPPfrxxf8opgZU6AXwlTXwmy/7+vIH+U1R3fHufyxPtfJQ//Jh8mcxFPElFrYBtAF28p/Xxw
bWEWHoNPcGpQPQAo/5JRKP8qDysYb4QsXxgsbtD/FzEbbzL/Kwlv9S+/Nj8dX/8inx9/On8hnyKv
I78+vz/P4ybve6BPRkYozxg/h5v/7U8WT7o5RS/Pjq4Ux03et/9eX+Yfm4/p/42vmiiq4uwG/1FJ
7T83H1KatKfzsUKfpLr/U1+vj7Gx+VVAcq2g3c6u//9aWtElW4iMbFzvWlrQ+F9c/9D4YK9aWq1T
QHStoQ1Erd//ru9aS3ah3RBwMl9Nd0Foz/9aWrC2W5MNQ1jPu1+0f0tC/1FJQn+/H1dvWHw7jFWP
VpP/rZFLkUdfSG9Jftf/S29Mf/9zn3ffVisx/zb416995VIv/3M/O1+B33lWFx9E3Xq+6qE/z6gN
RP+QsQDq8Cvgc3n+bp8Az/OSkP8APfAAYI/i+WAhb2vsoGqwlSGRcnT234NIQHZ+X+hzfk0pkJKH
tgRAQKVwMzEyNiwANiArMzI0OCz8NyCXAY5Pj1fzkDiA3RD+ctGAkD+RT5L9jw+QEJr0/5Hlh7ac
vzyDmkIrJj2kh6//Sd99uKJcQ/iNzeSTDVOwsPxvYstAT+YAMNVB7KLoIcfskz4GlwMyMjGYAZew
+DM0NJgLp9jaoAmwLDE/qN+p5nT2kv3akmwAcnH/8saxEZ8RpXyEf8dlvPWxVvvVAqKnLaLPfK+k
z7KON5//OK+TKjt/u089lkF/uX+uQZ+7guyEmvI9oKoUIE4oId2ip1QDgg3gBZBhCSEIcv/+gAzw
/wDdEAjgDeA0YMTBnmEM8NEh3RCH4CBD7wB7DaEAUChw4QRgAFDzQGLv5CA0wP5g7KBzgzDRIflQ
7/+QNGH6AONRZnTQCGA0cP3RMC74MgRh/vAOkf6wzWC/2qBgACwh5HJwpOUQcGrw+4/QxUFk60Ax
0fhyi2D/gv/FUzSAAwHIwOmQDOH/kGrwz25hA3PE5RKGfX2IENGAHwBCAAEAAAAUAAAARAB1AGQA
bABlAHkAIABEAHUAAAAfAGUAAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBt
AAAAAAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAFgAAAAAAAAAgSsfpL6jEBmdbgDd
AQ9UAgAAAIBEAHUAZABsAGUAeQAgAEQAdQAAAFMATQBUAFAAAABkAHUAZABsAEAAYwB5AHAAcgBl
AHMAcwAuAGMAbwBtAAAAHwACXQEAAAAiAAAAZAB1AGQAbABAAGMAeQBwAHIAZQBzAHMALgBjAG8A
bQAAAAAAHwDlXwEAAAAqAAAAcwBpAHAAOgBkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBt
AAAAAAAfABoMAQAAABQAAABEAHUAZABsAGUAeQAgAEQAdQAAAB8AHwwBAAAAIgAAAGQAdQBkAGwA
QABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AHgwBAAAACgAAAFMATQBUAFAAAAAAAAIBGQwB
AAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBkAGwAZQB5ACAARAB1AAAAUwBNAFQA
UAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAfAAFdAQAAACIAAABkAHUAZABs
AEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfAPg/AQAAABQAAABEAHUAZABsAGUAeQAgAEQA
dQAAAB8AI0ABAAAAIgAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBvAG0AAAAAAB8AIkAB
AAAACgAAAFMATQBUAFAAAAAAAAIB+T8BAAAAWAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQA
dQBkAGwAZQB5ACAARAB1AAAAUwBNAFQAUAAAAGQAdQBkAGwAQABjAHkAcAByAGUAcwBzAC4AYwBv
AG0AAAAfAAldAQAAACIAAABkAHUAZABsAEAAYwB5AHAAcgBlAHMAcwAuAGMAbwBtAAAAAAAfADFA
AQAAAAIAAAAAAAAACwBAOgEAAAAfADBAAQAAAAIAAAAAAAAAHwAaAAEAAAASAAAASQBQAE0ALgBO
AG8AdABlAAAAAAADAPE/BAgAAAsAQDoBAAAAAwD9P6gDAAACAQswAQAAABAAAABzGBo7rd1VT6g6
DVJ6n6pEAwAXAAEAAABAADkAAGd5ZE9ZzwFAAAgwIR4PZU9ZzwELACkAAAAAAAsAIwAAAAAAHwAA
gIYDAgAAAAAAwAAAAAAAAEYBAAAAHgAAAGEAYwBjAGUAcAB0AGwAYQBuAGcAdQBhAGcAZQAAAAAA
AQAAABoAAAB6AGgALQBDAE4ALAAgAGUAbgAtAFUAUwAAAAAACwAAgAggBgAAAAAAwAAAAAAAAEYA
AAAABoUAAAAAAAAfADcAAQAAAJgAAABbAFAAQQBUAEMASAAgADQALwA2AF0AIABpAG4AcAB1AHQA
OgAgAGMAeQBhAHAAYQA6ACAAZQBuAGEAYgBsAGUALwBkAGkAcwBhAGIAbABlACAAdAByAGEAYwBr
AHAAYQBkACAAZABlAHYAaQBjAGUAIABiAGEAcwBlAGQAIABvAG4AIABMAEkARAAgAHMAdABhAHQA
ZQAAAB8APQABAAAAAgAAAAAAAAADADYAAAAAAAMALgAAAAAAHwBCEAEAAAACAAAAAAAAAAIBcQAB
AAAAGwAAAAHPV7a7p4Nq3EU80kKko2glmjBfEjMAZh2IQAAfAHAAAQAAAJgAAABbAFAAQQBUAEMA
SAAgADQALwA2AF0AIABpAG4AcAB1AHQAOgAgAGMAeQBhAHAAYQA6ACAAZQBuAGEAYgBsAGUALwBk
AGkAcwBhAGIAbABlACAAdAByAGEAYwBrAHAAYQBkACAAZABlAHYAaQBjAGUAIABiAGEAcwBlAGQA
IABvAG4AIABMAEkARAAgAHMAdABhAHQAZQAAAB8ANRABAAAAhAAAADwANwA3AEIAQwA3ADIANQBD
ADkAMAA2ADIANwA2ADQARgA4ADcANABEADcAOQBGADUAMQBFADEARgAxAEEAOABGADQAMABDADEA
NAAwADkAOQBAAFMAMAA0AC0ATQBCAFgAMAAxAC0AMAAxAC4AcwAwADQALgBsAG8AYwBhAGwAPgAA
AB8AORABAAAAAgAAAAAAAAADAN4/n04AAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAOFAAAAAAAA
AwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAAYUAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAB
gQAAAAAAAAMAgBD/////BQAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAAoEAAAAAAAAAAAAACwAAgAMg
BgAAAAAAwAAAAAAAAEYAAAAAHIEAAAAAAABAAAcwAWJQZE9ZzwELAAIAAQAAAAMAJgAAAAAACwAr
AAAAAAACARAwAQAAAEYAAAAAAAAAsR+hOTAgUUadtKVw3tCf1AcAd7xyXJBidk+HTXn1Hh8ajwAA
AJk8GwAAuqc+7svX90Cjdu81/GFZiQAYg/zDLwAAAAAfAPo/AQAAABQAAABEAHUAZABsAGUAeQAg
AEQAdQAAAAMACVkBAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAEIUAAAAAAAAfAACAH6TrM6h6
LkK+e3nhqY5UswEAAAA4AAAAQwBvAG4AdgBlAHIAcwBhAHQAaQBvAG4ASQBuAGQAZQB4AFQAcgBh
AGMAawBpAG4AZwBFAHgAAAABAAAA3gAAAEkASQA9ADAAMQBDAEYANQA3AEIANgBCAEIAQQA3ADgA
MwA2AEEARABDADQANQAzAEMARAAyADQAMgBBADQAQQAzADYAOAAyADUAOQBBADMAMAA1AEYAMQAy
ADMAMwAwADAANgA2ADEARAA4ADgANAAwADsAUwBCAEMASQBEAD0AMwA7AFYAZQByAHMAaQBvAG4A
PQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAgACgAQgB1AGkAbABkACAAMQA3ADQALgAwACkALAAg
AFMAdABhAGcAZQA9AEgANAAAAAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAE4EAAAEAAAADAACA
AyAGAAAAAADAAAAAAAAARgAAAAAjgQAA////fwMAAIADIAYAAAAAAMAAAAAAAABGAAAAABCBAAAA
AAAAAwAAgAMgBgAAAAAAwAAAAAAAAEYAAAAAEYEAAAAAAAALAACAAyAGAAAAAADAAAAAAAAARgAA
AAAkgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACyBAAAAAAAAAwAAgAMgBgAAAAAAwAAA
AAAAAEYAAAAAKYEAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAqgQAAAAAAAB8AAIADIAYA
AAAAAMAAAAAAAABGAAAAACeBAAABAAAAAgAAAAAAAAADAACAAyAGAAAAAADAAAAAAAAARgAAAAAS
gQAAAQAAAB8AAIADIAYAAAAAAMAAAAAAAABGAAAAACGBAAABAAAAAgAAAAAAAAALAACAAyAGAAAA
AADAAAAAAAAARgAAAAADgQAAAAAAAAsAAIADIAYAAAAAAMAAAAAAAABGAAAAACaBAAAAAAAACwAA
gAggBgAAAAAAwAAAAAAAAEYAAAAADoUAAAAAAAADAACACCAGAAAAAADAAAAAAAAARgAAAAAYhQAA
AAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAIKFAAAAAAAAAwANNP0/AAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAA
AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAt
AGkAcAAAAAAAAQAAAB4AAABbADEAMAAuADMAMAAuADEAMgAuADEANQAzAF0AAAAAAEDd

--_000_77BC725C9062764F874D79F51E1F1A8F40C14099S04MBX0101s04lo_--
