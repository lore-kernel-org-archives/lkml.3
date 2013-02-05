Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186Ab3BEPim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:38:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45817 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab3BEPij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:38:39 -0500
Message-ID: <5111277B.5020607@canonical.com>
Date: Tue, 05 Feb 2013 16:38:35 +0100
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>
CC: Michal Marek <mmarek@suse.cz>
Subject: [PATCH v2] drm/nouveau: always select ACPI_VIDEO if ACPI is enabled.
References: <20130204152344.GG13909@pd.tnic> <510FD6A2.80101@canonical.com> <20130205145232.GI4827@pd.tnic>
In-Reply-To: <20130205145232.GI4827@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 05-02-13 15:52, Borislav Petkov schreef:
> On Mon, Feb 04, 2013 at 04:41:22PM +0100, Maarten Lankhorst wrote:
>> Hey,
>>
>> Op 04-02-13 16:23, Borislav Petkov schreef:
>>> Hi,
>>>
>>> I'm guessing someone has already triggered this on latest Linus' tree
>>> and has a fix?
>>>
>>> drivers/built-in.o: In function `nouveau_acpi_edid':
>>> /w/kernel/linux/drivers/gpu/drm/nouveau/nouveau_acpi.c:420: undefined reference to `acpi_video_get_edid'
>>> make: *** [vmlinux] Error 1
>>>
>>> Btw, I got CONFIG_ACPI_VIDEO=m while CONFIG_DRM_NOUVEAU=y and this is
>>> probably the reason for the vmlinux link error.
>>>
>>> Thanks.
>>>
>> Does this fix things?
>>
>> -->8
>> Having nouveau builtin would still allow ACPI_VIDEO to be used as external module if some of the deps for acpi_video
>> have not been met, which would result in a linking failure. Solve this by only requiring ACPI && X86 to select ACPI_VIDEO.
>>
>> Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>>
>> ---
>> diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
>> index 8a55bee..f08b9b6 100644
>> --- a/drivers/gpu/drm/nouveau/Kconfig
>> +++ b/drivers/gpu/drm/nouveau/Kconfig
>> @@ -10,7 +10,7 @@ config DRM_NOUVEAU
>>  	select FB
>>  	select FRAMEBUFFER_CONSOLE if !EXPERT
>>  	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
>> -	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
>> +	select ACPI_VIDEO if ACPI && X86
>>  	select ACPI_WMI if ACPI
>>  	select MXM_WMI if ACPI
>>  	select POWER_SUPPLY
> Not really.
>
> drivers/built-in.o: In function `acpi_video_bus_put_one_device':
> /root/kernel/linux/drivers/acpi/video.c:1407: undefined reference to `thermal_cooling_device_unregister'
> drivers/built-in.o: In function `acpi_video_device_find_cap':
> /root/kernel/linux/drivers/acpi/video.c:842: undefined reference to `thermal_cooling_device_register'
> make: *** [vmlinux] Error 1
>
> It is CONFIG_THERMAL=m this time.
>
> Thanks.
>
Argh, next attempt, based on i915's Kconfig.

It seems that not only I have to select ACPI_VIDEO, I also have to select all the dependencies.
Is this a Kconfig bug or working as intended? i915 seems to have a workaround, so I copied it from
there. Except it's currently missing select THERMAL, so I guess it didn't get updated when that got
added.

---->8
Having nouveau builtin would still allow ACPI_VIDEO to be used as external module
if some of the deps for acpi_video have not been met, which would result in a linking
failure. Solve this by selecting all dependencies as well.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>

---
diff --git a/drivers/gpu/drm/nouveau/Kconfig b/drivers/gpu/drm/nouveau/Kconfig
index 8a55bee..e84763a 100644
--- a/drivers/gpu/drm/nouveau/Kconfig
+++ b/drivers/gpu/drm/nouveau/Kconfig
@@ -10,10 +10,16 @@ config DRM_NOUVEAU
 	select FB
 	select FRAMEBUFFER_CONSOLE if !EXPERT
 	select FB_BACKLIGHT if DRM_NOUVEAU_BACKLIGHT
-	select ACPI_VIDEO if ACPI && X86 && BACKLIGHT_CLASS_DEVICE && VIDEO_OUTPUT_CONTROL && INPUT
 	select ACPI_WMI if ACPI
 	select MXM_WMI if ACPI
 	select POWER_SUPPLY
+	# Similar to i915, we need to select ACPI_VIDEO and it's dependencies
+	select BACKLIGHT_LCD_SUPPORT if ACPI && X86
+	select BACKLIGHT_CLASS_DEVICE if ACPI && X86
+	select VIDEO_OUTPUT_CONTROL if ACPI && X86
+	select INPUT if ACPI && X86
+	select THERMAL if ACPI && X86
+	select ACPI_VIDEO if ACPI && X86
 	help
 	  Choose this option for open-source nVidia support.
 

