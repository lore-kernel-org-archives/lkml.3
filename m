Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964933AbaD3OgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:36:11 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37061 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933466AbaD3OgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:36:08 -0400
Message-ID: <53610936.6020902@traphandler.com>
Date: Wed, 30 Apr 2014 16:31:18 +0200
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Reply-To: jjhiblot@traphandler.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tim Niemeyer <tim.niemeyer@corscience.de>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
CC: Robert Nelson <robertcnelson@gmail.com>, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        airlied@linux.ie, robdclark@gmail.com, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/3] DRM driver for the ATMEL High end LCD controller
References: <1397814309-32160-1-git-send-email-jjhiblot@traphandler.com>	 <1398267396.4295.59.camel@herbert.er.corscience.de>	 <5359000C.50005@free-electrons.com> <1398343612.4295.66.camel@herbert.er.corscience.de>
In-Reply-To: <1398343612.4295.66.camel@herbert.er.corscience.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tim,

On 04/24/2014 02:46 PM, Tim Niemeyer wrote:
> 
> Hi Boris
> 
> Am Donnerstag, den 24.04.2014, 14:14 +0200 schrieb Boris BREZILLON:
>> Hi Tim,
>>
>> On 23/04/2014 17:36, Tim Niemeyer wrote:
>>> Hi Jean-Jacques,
>>>
>>> Am Freitag, den 18.04.2014, 11:45 +0200 schrieb Jean-Jacques Hiblot:
>>>> Hi,
>>>>
>>>> this patch serie implements a simple DRM driver for the ATMEL High end LCD
>>>> controller found in the SAMA5 familly. It's based on the tilcdc driver.
>>>> It uses the cma_helper for memory and fbdev stuff.
>>>> Your comments are welcome !
>>> I applied your and Robert's patches on a 3.15-rc2 kernel and tried the
>>> framebuffer device on the sama5d31-ek. Seems to work.
>>>
>>>> Supported features:
>>>> * the base layer (the main framebuffer)
>>> Tested to show a little tux png, but it's appearing only after 
>>> 'echo 0 > /sys/devices/ahb.1/apb.2/f0030000.hlcdc/graphics/fb0/rotate'
>>> is there missing some initializing?
>>
>> Could you try to apply this http://code.bulix.org/f01kvh-86117 ?
> I can't see any difference with that.
> 
> I used fbv to display the tux. With CONFIG_FRAMEBUFFER_CONSOLE=n the
> display stays with a small atmel logo and u-Boot version information. If
> i set CONFIG_FRAMEBUFFER_CONSOLE=y, the display is black after kernel
> start and fbv just works as expected.
> 
I've been able to reproduce the problem. After some digging, I found
that trigerring a hotplug event with drm_kms_helper_hotplug_event() to
trigger a detection of the connectors at the end of atmel_hlcdc_load()
solves the issue. I don't know if this is a proper way to fix it though.


> Best Regards,
> Tim
> 
>> Best Regards,
>>
>> Boris
>>
>>>
>>>> * a simple panel
>>>> * a backlight driver
>>> Tested to set brightness to 0, 20 and 255. Works.
>>>
>>> Thanks for your work.
>>>
>>> Best Regards
>>> Tim
>>>
>>>> * structure to 'easily' add other connectors (it comes from the tilcdc)
>>>>
>>>> On the todo list:
>>>> * support overlays as drm_planes
>>>> * support for the hardware cursor
>>>> * support for the SiI9022 HDMI connector (present on sama5d36ek)
>>>>
>>>>
>>>> Jean-Jacques Hiblot (3):
>>>>   atmel: drm: added drm driver for the atmel hlcd controller
>>>>   atmel: drm: dt: Added DT entry for the atmel hlcdc found in the sama5
>>>>   atmel: dt: Add supports for the lcdc support on the sama5d36ek
>>>>
>>>>  arch/arm/boot/dts/sama5d36ek.dts                   |  27 +-
>>>>  arch/arm/boot/dts/sama5d3_lcd.dtsi                 |  11 +
>>>>  drivers/gpu/drm/Kconfig                            |   2 +
>>>>  drivers/gpu/drm/Makefile                           |   1 +
>>>>  drivers/gpu/drm/atmel_hlcdc/Kconfig                |  13 +
>>>>  drivers/gpu/drm/atmel_hlcdc/Makefile               |  12 +
>>>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h          | 771 +++++++++++++++++++++
>>>>  .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c    |  92 +++
>>>>  .../gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h    |  25 +
>>>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c     | 702 +++++++++++++++++++
>>>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c      | 586 ++++++++++++++++
>>>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h      | 124 ++++
>>>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h      | 190 +++++
>>>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c    | 459 ++++++++++++
>>>>  drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h    |  28 +
>>>>  15 files changed, 3042 insertions(+), 1 deletion(-)
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/Kconfig
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/Makefile
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc.h
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.c
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_backlight.h
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_crtc.c
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.c
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_drv.h
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_ovl.h
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.c
>>>>  create mode 100644 drivers/gpu/drm/atmel_hlcdc/atmel_hlcdc_panel.h
>>>>
>>>> --
>>>> 1.9.1
>>>>
>>>>
>>>> _______________________________________________
>>>> linux-arm-kernel mailing list
>>>> linux-arm-kernel@lists.infradead.org
>>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>>
>>
> 
> 
