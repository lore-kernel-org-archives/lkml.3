Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab3HOWVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 18:21:40 -0400
Received: from iona.labri.fr ([147.210.8.143]:37043 "EHLO iona.labri.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516Ab3HOWVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 18:21:38 -0400
Message-ID: <520D547F.2060600@labri.fr>
Date: Thu, 15 Aug 2013 18:21:51 -0400
From: Martin Peres <martin.peres@labri.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: =?UTF-8?B?UGFsaSBSb2jDoXI=?= <pali.rohar@gmail.com>
CC: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: nouveau: temperature on nv40 is unavailable since ad40d73ef533ab0ad16b4a1ab2f7870c1f8ab954
References: <1836330.fGgIDqPTNA@pali> <201308141102.47960@pali> <520C37DC.90902@labri.fr> <201308150924.49518@pali>
In-Reply-To: <201308150924.49518@pali>
Content-Type: multipart/mixed;
 boundary="------------080801000607090805030108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080801000607090805030108
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 15/08/2013 03:24, Pali Rohár wrote:
> On Thursday 15 August 2013 04:07:24 Martin Peres wrote:
>> On 14/08/2013 05:02, Pali Rohár wrote:
>>> On Tuesday 13 August 2013 15:55:28 Martin Peres wrote:
>>>> On 13/08/2013 09:53, Pali Rohár wrote:
>>>>> On utorok, 13. augusta 2013 15:32:45 CEST, Martin Peres
>>> wrote:
>>>>>> On 13/08/2013 09:23, Pali Rohár wrote:
>>>>>>> On Tuesday 13 August 2013 09:01:19 Martin Peres wrote:
>>>>>>    ...
>>>>>>
>>>>>> You can check the temperature by running nvidia-settings.
>>>>>> If you can't see the temperature in it, then nvidia
>>>>>> doesn't support it on your card and
>>>>>> I'm not sure we should :s
>>>>>>
>>>>>> Thanks for the vbios you sent me in private. For the
>>>>>> others, the reason why he doesn't have temperature
>>>>>> anymore is because his vbios lacks sensor calibration
>>>>>> values.
>>>>> In nvidia-settings tab "GPU 0 - (GeForce 6600 GT)" -->
>>>>> "Thermal Settings" is:
>>>>>
>>>>> Thermal Sensor Information:
>>>>> ID: 0
>>>>> Target: GPU
>>>>> Provider: GPU Internal
>>>>> Temperature: 70 C (now)
>>>>>
>>>>> I looked in Windows program SpeedFan. It found Nvidia PCI
>>>>> card and reported "GPU Temp" about 68-70 C. So it looks
>>>>> like both nvidia driver and windows SpeedFan program
>>>>> reading same values.
>>>> Great, I'll cook you a patch in a bit and you'll see what
>>>> the temperature is like. It won't be perfectly accurate
>>>> but there is some kind of default for nvidia cards of this
>>>> generation.
>>> Ok, send me patch and I can try it if it will work and
>>> report similar values as windows or nvidia driver.
>> Sorry for the late answer.
>>
>> Please test this patch. Be aware that temperature with nouveau
>> will be higher than with the blob.
>> I only want to see if nouveau reports a temperature.
>>
>> The only way to be sure if the values are good-enough would be
>> to use the blob and run:
>> nvapeek 0x15b0
>> Please send me the result along with the temperature reported
>> by nvidia at the time of the peek.
>>
>> Martin
>>
>> PS: This patch has only be compile-tested, I don't have access
>> to an nv4x right now.
> Hello,
>
> now after patch nouveau report temperature:
>
> $ sensors
> ...
> nouveau-pci-0500
> Adapter: PCI adapter
> temp1:        +63.0°C  (high = +95.0°C, hyst =  +3.0°C)
>                         (crit = +145.0°C, hyst =  +2.0°C)
>                         (emerg = +135.0°C, hyst =  +5.0°C)

Ok, that was expected ;)
> ...
>
> I found that nvidia binary driver has command line utility
> nvidia-smi which report same temperature as X utility nvidia-
> settings. So I will use nvidia-smi (if it is OK).
>
> And after reboot nvidia report another temperature value:
>
> $ nvidia-smi -q -d TEMPERATURE
> ...
> GPU 0000:05:00.0
>      Temperature
>          Gpu                     : 70 C
>
> Immediately I called nvapeek command:
>
> $ nvapeek 0x15b0
> 000015b0: 1000008e
>
> So value reported by nouveau is lower than value reported by
> nvidia binary driver.
As you didn't run nvapeek 15b0 when running nouveau it is hard to tell 
if it is due to
calibration values or because the temperature was lower.

Could you please read the temperature + peek 15b0 when running nouveau?

Anyway, it is weird because I cannot find 70°C with 0x8e as an input 
temperature and with
the current default values :o
> I wait some some and started nvidia-smi and nvapeek again, here
> are results:
>
> $ nvidia-smi -q -d TEMPERATURE
> ...
> GPU 0000:05:00.0
>      Temperature
>          Gpu                     : 67 C
>
> $ nvapeek 0x15b0
> 000015b0: 1000008e
>
> So it looks like that nvapeek returning always same value and
> does not depends on temperature... It is OK?
Well, it looks like the temperature reading is very noisy!
Could you please get the temperature + peek when the card is as hot as 
possible?

There is a very effective solution to get a GPU hot, use a hair drier. 
If you could get your
GPU to at 110°C (or less, if you feel like it is too much), that could 
help me check the formula
and default values.

PS: I attached a new version of the patch that should improve the 
temperature accuracy for
nv43s. Could you test it and send me your kernel log?

--------------080801000607090805030108
Content-Type: text/x-patch;
 name="0001-drm-nv40-therm-set-default-calibration-values-if-nee.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-drm-nv40-therm-set-default-calibration-values-if-nee.pa";
 filename*1="tch"

>From 8c806fd49d87ecf57e98713537a7d23d1f7712d9 Mon Sep 17 00:00:00 2001
From: Martin Peres <martin.peres@labri.fr>
Date: Wed, 14 Aug 2013 22:00:48 -0400
Subject: [PATCH] drm/nv40/therm: set default calibration values if needed

Some vbios expose a thermal sensor but do not set default
calibration values. As they are almost always the same, let's
set some default ones.

v2:
- the nv43 requires a different offset numerator
- cosmetic changes

Signed-off-by: Martin Peres <martin.peres@labri.fr>
---
 .../drm/nouveau/core/include/subdev/bios/therm.h   |  1 +
 drivers/gpu/drm/nouveau/core/subdev/bios/therm.c   |  1 +
 drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c   | 43 +++++++++++++++++++---
 drivers/gpu/drm/nouveau/core/subdev/therm/temp.c   |  5 +--
 4 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/include/subdev/bios/therm.h b/drivers/gpu/drm/nouveau/core/include/subdev/bios/therm.h
index 083541d..11b7993 100644
--- a/drivers/gpu/drm/nouveau/core/include/subdev/bios/therm.h
+++ b/drivers/gpu/drm/nouveau/core/include/subdev/bios/therm.h
@@ -10,6 +10,7 @@ struct nvbios_therm_threshold {
 
 struct nvbios_therm_sensor {
 	/* diode */
+	int has_sensor;
 	s16 slope_mult;
 	s16 slope_div;
 	s16 offset_num;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/therm.c b/drivers/gpu/drm/nouveau/core/subdev/bios/therm.c
index 22a2057..16b763d 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/therm.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/therm.c
@@ -95,6 +95,7 @@ nvbios_therm_sensor_parse(struct nouveau_bios *bios,
 			sensor_section++;
 			if (sensor_section == 0) {
 				offset = ((s8) nv_ro08(bios, entry + 2)) / 2;
+				sensor->has_sensor = 1;
 				sensor->offset_constant = offset;
 			}
 			break;
diff --git a/drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c b/drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c
index 002e51b..72b91d7 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/therm/nv40.c
@@ -57,11 +57,47 @@ nv40_sensor_style(struct nouveau_therm *therm)
 	}
 }
 
+static void
+nv40_therm_temp_safety_checks(struct nouveau_therm *therm)
+{
+	struct nouveau_therm_priv *priv = (void *)therm;
+	struct nvbios_therm_sensor *sensor = &priv->bios_sensor;
+	enum nv40_sensor_style style = nv40_sensor_style(therm);
+	struct nouveau_device *device = nv_device(therm);
+
+	/* if the slope or the offset is unset, do no use the sensor */
+	if (sensor->has_sensor && (!sensor->slope_div || !sensor->slope_mult ||
+	    !sensor->offset_num || !sensor->offset_den)) {
+
+		nv_info(therm, "Invalid sensor calibration values. "
+		               "Set default calibration values\n");
+
+		if (style == NEW_STYLE) {
+			sensor->slope_div = 10000;
+			sensor->slope_mult = 450;
+			sensor->offset_num = -25000;
+			sensor->offset_den = 100;
+		} else 	if (style == OLD_STYLE) {
+			sensor->slope_div = 1000;
+			sensor->slope_mult = 792;
+			if (device->chipset == 0x43)
+				sensor->offset_num = 1806;
+			else
+				sensor->offset_num = 2306;
+			sensor->offset_den = 100;
+		}
+	}
+}
+
+
 static int
 nv40_sensor_setup(struct nouveau_therm *therm)
 {
 	enum nv40_sensor_style style = nv40_sensor_style(therm);
 
+	/* set default values for the temperature if needed */
+	nv40_therm_temp_safety_checks(therm);
+
 	/* enable ADC readout and disable the ALARM threshold */
 	if (style == NEW_STYLE) {
 		nv_mask(therm, 0x15b8, 0x80000000, 0);
@@ -93,11 +129,6 @@ nv40_temp_get(struct nouveau_therm *therm)
 	} else
 		return -ENODEV;
 
-	/* if the slope or the offset is unset, do no use the sensor */
-	if (!sensor->slope_div || !sensor->slope_mult ||
-	    !sensor->offset_num || !sensor->offset_den)
-	    return -ENODEV;
-
 	core_temp = core_temp * sensor->slope_mult / sensor->slope_div;
 	core_temp = core_temp + sensor->offset_num / sensor->offset_den;
 	core_temp = core_temp + sensor->offset_constant - 8;
@@ -171,7 +202,7 @@ nv40_therm_intr(struct nouveau_subdev *subdev)
 	struct nouveau_therm *therm = nouveau_therm(subdev);
 	uint32_t stat = nv_rd32(therm, 0x1100);
 
-	/* traitement */
+	/* TODO: do something? Need more RE first */
 
 	/* ack all IRQs */
 	nv_wr32(therm, 0x1100, 0x70000);
diff --git a/drivers/gpu/drm/nouveau/core/subdev/therm/temp.c b/drivers/gpu/drm/nouveau/core/subdev/therm/temp.c
index dde746c..053034e 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/therm/temp.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/therm/temp.c
@@ -49,9 +49,8 @@ nouveau_therm_temp_set_defaults(struct nouveau_therm *therm)
 	priv->bios_sensor.thrs_shutdown.hysteresis = 5; /*not that it matters */
 }
 
-
 static void
-nouveau_therm_temp_safety_checks(struct nouveau_therm *therm)
+nouveau_therm_sensor_safety_checks(struct nouveau_therm *therm)
 {
 	struct nouveau_therm_priv *priv = (void *)therm;
 	struct nvbios_therm_sensor *s = &priv->bios_sensor;
@@ -239,7 +238,7 @@ nouveau_therm_sensor_ctor(struct nouveau_therm *therm)
 	if (nvbios_therm_sensor_parse(bios, NVBIOS_THERM_DOMAIN_CORE,
 				      &priv->bios_sensor))
 		nv_error(therm, "nvbios_therm_sensor_parse failed\n");
-	nouveau_therm_temp_safety_checks(therm);
+	nouveau_therm_sensor_safety_checks(therm);
 
 	return 0;
 }
-- 
1.8.3.4


--------------080801000607090805030108--
