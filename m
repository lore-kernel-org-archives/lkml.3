Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaFKUWE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 16:22:04 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:63207 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaFKUWC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 16:22:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAF6AEGs2Y1G-8R5tDcgXKOh43nP3_-0SyebLugcF6QEUtkQNBQ@mail.gmail.com>
References: <1401345427-5299-1-git-send-email-benjamin.gaignard@linaro.org>
	<CAF6AEGs2Y1G-8R5tDcgXKOh43nP3_-0SyebLugcF6QEUtkQNBQ@mail.gmail.com>
Date: Wed, 11 Jun 2014 16:22:00 -0400
Message-ID: <CAF6AEGtgvjGkhBuOHuC1Mi1BPSsyte-vO7Wh1T=83cKfRfs0yQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/11] Add DRM for stih4xx platforms
From: Rob Clark <robdclark@gmail.com>
To: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Cc: "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Lee Jones <lee.jones@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 2:37 PM, Rob Clark <robdclark@gmail.com> wrote:
> On Thu, May 29, 2014 at 2:36 AM, Benjamin Gaignard
> <benjamin.gaignard@linaro.org> wrote:
>> This series of patches add the support of DRM/KMS drivers for STMicroelectronics
>> chipsets stih416 and stih407.
>>
>> version 4:
>>         - Remove depency between TVout it subdevices HDMI and HDA
>>         - Rework and simplify VTG and VTAC code
>>         - Fix numbers of typo and indentation
>>         - Remove debug (will be push in separate patches)
>>         - Fix remarks done in previous patcheset
>>
>>         patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
>>         on branch: drm_kms_for_next-v4
>>
>> version 3:
>>         - Correctly split code between probe and bind funtions
>>         - Squash some commits
>>         - remove HQ-VDP device code to have a smaller patcheset,
>>           we will introduce it later.
>>
>>         patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
>>         on branch: drm_kms_for_next-v3
>>
>> version 2:
>>         - Use componentized device instead of register sub-devices in master
>>         driver probe function
>>         - Fix Makefile and Kconfig to only allow built-in compilation
>>
>>         patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
>>         on branch: drm_kms_for_next-v2
>>
>> version 1:
>>         - First path submission
>>
>> Hardware is split in two main blocks: Compositor and TVout. Each of them
>> includes specific hardware IPs and the display timing are controlled by a specific
>> Video Timing Generator hardware IP (VTG).
>>
>> Compositor is made of the follow hardware IPs:
>>  - GDP (Generic Display Pipeline) which is an entry point for graphic (RGB)
>>    buffers
>>  - VDP (Video Diplay Pipeline) which is an entry point for video (YUV) buffers
>>  - HQVDP (High Quality Video Display Processor) that supports scaling,
>>    deinterlacing and some miscellaneous image quality improvements.
>>    It fetches the Video decoded buffers from memory, processes them and pushes
>>    them to the Compositor through a HW dedicated bus.
>>  - Mixer is responsible of mixing all the entries depending of their
>>    respective z-order and layout
>>
>> TVout is divided in 3 parts:
>>  - HDMI to generate HDMI signals, depending of chipset version HDMI phy can
>>    change.
>>  - HDA to generate signals for HD analog TV
>>  - VIP to control/switch data path coming from Compositor
>>
>> On stih416 compositor and Tvout are on different dies so a Video Trafic Advance
>> inter-die Communication mechanism (VTAC) is needed.
>>
>> +---------------------------------------------+   +----------------------------------------+
>> | +-------------------------------+   +----+  |   |  +----+   +--------------------------+ |
>> | |                               |   |    |  |   |  |    |   |  +---------+     +----+  | |
>> | | +----+              +------+  |   |    |  |   |  |    |   |  | VIP     |---->|HDMI|  | |
>> | | |GPD +------------->|      |  |   |    |  |   |  |    |   |  |         |     +----+  | |
>> | | +----+              |Mixer |--|-->|    |  |   |  |    |---|->| switcher|             | |
>> | |                     |      |  |   |    |  |   |  |    |   |  |         |     +----+  | |
>> | |                     |      |  |   |    |  |   |  |    |   |  |         |---->|HDA |  | |
>> | |                     +------+  |   |VTAC|========>|VTAC|   |  +---------+     +----+  | |
>> | |                               |   |    |  |   |  |    |   |                          | |
>> | |         Compositor            |   |    |  |   |  |    |   |           TVout          | |
>> | +-------------------------------+   |    |  |   |  |    |   +--------------------------+ |
>> |                      ^              |    |  |   |  |    |             ^                  |
>> |                      |              |    |  |   |  |    |             |                  |
>> |               +--------------+      |    |  |   |  |    |      +-------------+           |
>> |               | VTG (master) |----->|    |  |   |  |    |----->| VTG (slave) |           |
>> |               +--------------+      +----+  |   |  +----+      +-------------+           |
>> |Digital die                                  |   |                              Analog Die|
>> +---------------------------------------------+   +----------------------------------------+
>>
>> On stih407 Compositor and Tvout are on the same die
>>
>> +-----------------------------------------------------------------+
>> | +-------------------------------+  +--------------------------+ |
>> | |                               |  |  +---------+     +----+  | |
>> | | +----+              +------+  |  |  | VIP     |---->|HDMI|  | |
>> | | |GPD +------------->|      |  |  |  |         |     +----+  | |
>> | | +----+              |Mixer |--|--|->| switcher|             | |
>> | | +----+   +-----+    |      |  |  |  |         |     +----+  | |
>> | | |VDP +-->+HQVDP+--->|      |  |  |  |         |---->|HDA |  | |
>> | | +----+   +-----+    +------+  |  |  +---------+     +----+  | |
>> | |                               |  |                          | |
>> | |         Compositor            |  |           TVout          | |
>> | +-------------------------------+  +--------------------------+ |
>> |                              ^        ^                         |
>> |                              |        |                         |
>> |                           +--------------+                      |
>> |                           |     VTG      |                      |
>> |                           +--------------+                      |
>> |Digital die                                                      |
>> +-----------------------------------------------------------------+
>>
>> In addition of the drivers for the IPs listed before a thin I2C driver (hdmiddc) is used
>> by HDMI driver to retrieve EDID for monitor.
>>
>> To unify interfaces of GDP and VDP we create a "layer" interface called by
>> compositor to control both GPD and VDP.
>
> I think it would be helpful to describe how you map the hardware to
> kms constructs (planes/crtcs/etc).
>
> Also, I kinda like sticking this sort of info (along w/ block diagrams
> above, etc), in a notes/readme file.  Although I seem to be in the
> minority about that.  But plenty of times when diving into other
> drivers I've wished they had done the same :-)
>
> For msm I think I more or less copy/paste the cover-letter and drm/msm/NOTES..

btw, Daniel started converting i915 over to docbook.. I probably
should look at converting some/all of my NOTES over to docbook one of
these days..

Anyway, I think I mostly managed to cover the parts that Thierry did
not get to yet.  Although you did seem to squash/drop/rearrange some
parts, so hopefully I didn't miss something as a result.

BR,
-R

>
> BR,
> -R
>
>
>> Hardware have memory contraints (alignment, contiguous) so we use CMA drm helpers functions
>> to allocate frame buffer.
>>
>> File naming convention is:
>>  - sti_* for IPs drivers
>>  - sti_drm_* for drm functions implementation.
>>
>> Benjamin Gaignard (11):
>>   drm: sti: add bindings for DRM driver
>>   drm: sti: add VTG driver
>>   drm: sti: add VTAC drivers
>>   drm: sti: add HDMI driver
>>   drm: sti: add HDA driver
>>   drm: sti: add TVOut driver
>>   drm: sti: add GDP layer
>>   drm: sti: add VID layer
>>   drm: sti: add Mixer
>>   drm: sti: add Compositor
>>   drm: sti: Add DRM driver itself
>>
>>  .../devicetree/bindings/gpu/st,stih4xx.txt         | 189 ++++++
>>  drivers/gpu/drm/Kconfig                            |   2 +
>>  drivers/gpu/drm/Makefile                           |   1 +
>>  drivers/gpu/drm/sti/Kconfig                        |  14 +
>>  drivers/gpu/drm/sti/Makefile                       |  19 +
>>  drivers/gpu/drm/sti/sti_compositor.c               | 265 ++++++++
>>  drivers/gpu/drm/sti/sti_compositor.h               |  90 +++
>>  drivers/gpu/drm/sti/sti_drm_connector.c            | 114 ++++
>>  drivers/gpu/drm/sti/sti_drm_connector.h            |  55 ++
>>  drivers/gpu/drm/sti/sti_drm_crtc.c                 | 436 ++++++++++++
>>  drivers/gpu/drm/sti/sti_drm_crtc.h                 |  21 +
>>  drivers/gpu/drm/sti/sti_drm_drv.c                  | 229 +++++++
>>  drivers/gpu/drm/sti/sti_drm_drv.h                  |  35 +
>>  drivers/gpu/drm/sti/sti_drm_encoder.c              | 108 +++
>>  drivers/gpu/drm/sti/sti_drm_encoder.h              |  17 +
>>  drivers/gpu/drm/sti/sti_drm_plane.c                | 192 ++++++
>>  drivers/gpu/drm/sti/sti_drm_plane.h                |  17 +
>>  drivers/gpu/drm/sti/sti_gdp.c                      | 512 ++++++++++++++
>>  drivers/gpu/drm/sti/sti_gdp.h                      |  73 ++
>>  drivers/gpu/drm/sti/sti_hda.c                      | 727 ++++++++++++++++++++
>>  drivers/gpu/drm/sti/sti_hdmi.c                     | 748 +++++++++++++++++++++
>>  drivers/gpu/drm/sti/sti_hdmi.h                     |  88 +++
>>  drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c         | 336 +++++++++
>>  drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.h         |  14 +
>>  drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c         | 211 ++++++
>>  drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.h         |  14 +
>>  drivers/gpu/drm/sti/sti_layer.c                    | 312 +++++++++
>>  drivers/gpu/drm/sti/sti_layer.h                    | 114 ++++
>>  drivers/gpu/drm/sti/sti_mixer.c                    | 249 +++++++
>>  drivers/gpu/drm/sti/sti_mixer.h                    |  52 ++
>>  drivers/gpu/drm/sti/sti_tvout.c                    | 687 +++++++++++++++++++
>>  drivers/gpu/drm/sti/sti_tvout.h                    |  18 +
>>  drivers/gpu/drm/sti/sti_vid.c                      | 145 ++++
>>  drivers/gpu/drm/sti/sti_vid.h                      |  33 +
>>  drivers/gpu/drm/sti/sti_vtac.c                     | 211 ++++++
>>  drivers/gpu/drm/sti/sti_vtg.c                      | 356 ++++++++++
>>  drivers/gpu/drm/sti/sti_vtg.h                      |  28 +
>>  37 files changed, 6732 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/gpu/st,stih4xx.txt
>>  create mode 100644 drivers/gpu/drm/sti/Kconfig
>>  create mode 100644 drivers/gpu/drm/sti/Makefile
>>  create mode 100644 drivers/gpu/drm/sti/sti_compositor.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_compositor.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_connector.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_connector.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_encoder.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_encoder.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_gdp.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_gdp.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_hda.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_hdmi.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_hdmi.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_layer.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_layer.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_mixer.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_mixer.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_tvout.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_tvout.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_vid.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_vid.h
>>  create mode 100644 drivers/gpu/drm/sti/sti_vtac.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_vtg.c
>>  create mode 100644 drivers/gpu/drm/sti/sti_vtg.h
>>
>> --
>> 1.9.1
>>
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> http://lists.freedesktop.org/mailman/listinfo/dri-devel
