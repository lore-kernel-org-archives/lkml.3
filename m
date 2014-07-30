Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbaG3Rma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:42:30 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:56123 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819AbaG3Rm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:42:29 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie
Cc: Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v8 00/11] Add DRM for stih4xx platforms
Date: Wed, 30 Jul 2014 19:41:56 +0200
Message-Id: <1406742127-27654-1-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches add the support of DRM/KMS drivers for STMicroelectronics
chipsets stih416 and stih407.

version 8:
	- Allow driver to be build as kernel module.
	- Use Universal Plane instead of legacy code.
	
	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v8

version 7:
	- rebased on top of drm-next (2014-07-24)

	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v7

version 6:
	- rebased on top of new component framework API.

	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v6

version 5:
	- Rework sti_drm_drv probes functions to support deferred probe.
	  This allow hdmi to delayed framebuffer creation until I2C is available.
	- Add ops functions in sti_layer structure to simpify GDP and VID code.
	- Add NOTES file to describe how the DRM concepts are mapped on hardware.

	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v5

version 4:
	- Remove depency between TVout it subdevices HDMI and HDA
	- Rework and simplify VTG and VTAC code
	- Fix numbers of typo and indentation
	- Remove debug (will be push in separate patches)
	- Fix remarks done in previous patcheset
	
	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v4

version 3:
	- Correctly split code between probe and bind funtions
	- Squash some commits
	- remove HQ-VDP device code to have a smaller patcheset,
	  we will introduce it later.

	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v3

version 2:
	- Use componentized device instead of register sub-devices in master
	driver probe function
	- Fix Makefile and Kconfig to only allow built-in compilation

	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v2
	
version 1:
	- First path submission

Hardware is split in two main blocks: Compositor and TVout. Each of them
includes specific hardware IPs and the display timing are controlled by a specific
Video Timing Generator hardware IP (VTG).

Compositor is made of the follow hardware IPs:
 - GDP (Generic Display Pipeline) which is an entry point for graphic (RGB)
   buffers
 - VDP (Video Diplay Pipeline) which is an entry point for video (YUV) buffers
 - HQVDP (High Quality Video Display Processor) that supports scaling,
   deinterlacing and some miscellaneous image quality improvements.
   It fetches the Video decoded buffers from memory, processes them and pushes
   them to the Compositor through a HW dedicated bus.
 - Mixer is responsible of mixing all the entries depending of their
   respective z-order and layout

TVout is divided in 3 parts:
 - HDMI to generate HDMI signals, depending of chipset version HDMI phy can
   change.
 - HDA to generate signals for HD analog TV
 - VIP to control/switch data path coming from Compositor

On stih416 compositor and Tvout are on different dies so a Video Trafic Advance
inter-die Communication mechanism (VTAC) is needed.

+---------------------------------------------+   +----------------------------------------+
| +-------------------------------+   +----+  |   |  +----+   +--------------------------+ |
| |                               |   |    |  |   |  |    |   |  +---------+     +----+  | |
| | +----+              +------+  |   |    |  |   |  |    |   |  | VIP     |---->|HDMI|  | |
| | |GPD +------------->|      |  |   |    |  |   |  |    |   |  |         |     +----+  | |
| | +----+              |Mixer |--|-->|    |  |   |  |    |---|->| switcher|             | |
| |                     |      |  |   |    |  |   |  |    |   |  |         |     +----+  | |
| |                     |      |  |   |    |  |   |  |    |   |  |         |---->|HDA |  | |
| |                     +------+  |   |VTAC|========>|VTAC|   |  +---------+     +----+  | |
| |                               |   |    |  |   |  |    |   |                          | |
| |         Compositor            |   |    |  |   |  |    |   |           TVout          | |
| +-------------------------------+   |    |  |   |  |    |   +--------------------------+ |
|                      ^              |    |  |   |  |    |             ^                  |
|                      |              |    |  |   |  |    |             |                  |
|               +--------------+      |    |  |   |  |    |      +-------------+           |
|               | VTG (master) |----->|    |  |   |  |    |----->| VTG (slave) |           |
|               +--------------+      +----+  |   |  +----+      +-------------+           |
|Digital die                                  |   |                              Analog Die|
+---------------------------------------------+   +----------------------------------------+

On stih407 Compositor and Tvout are on the same die

+-----------------------------------------------------------------+
| +-------------------------------+  +--------------------------+ |
| |                               |  |  +---------+     +----+  | |
| | +----+              +------+  |  |  | VIP     |---->|HDMI|  | |
| | |GPD +------------->|      |  |  |  |         |     +----+  | |
| | +----+              |Mixer |--|--|->| switcher|             | |
| | +----+   +-----+    |      |  |  |  |         |     +----+  | |
| | |VDP +-->+HQVDP+--->|      |  |  |  |         |---->|HDA |  | |
| | +----+   +-----+    +------+  |  |  +---------+     +----+  | |
| |                               |  |                          | |
| |         Compositor            |  |           TVout          | |
| +-------------------------------+  +--------------------------+ |
|                              ^        ^                         |
|                              |        |                         |
|                           +--------------+                      |
|                           |     VTG      |                      |
|                           +--------------+                      |
|Digital die                                                      |
+-----------------------------------------------------------------+

In addition of the drivers for the IPs listed before a thin I2C driver (hdmiddc) is used
by HDMI driver to retrieve EDID for monitor.

To unify interfaces of GDP and VDP we create a "layer" interface called by
compositor to control both GPD and VDP.

Hardware have memory contraints (alignment, contiguous) so we use CMA drm helpers functions
to allocate frame buffer.

File naming convention is:
 - sti_* for IPs drivers
 - sti_drm_* for drm functions implementation.

Benjamin Gaignard (11):
  drm: sti: add bindings for DRM driver
  drm: sti: add VTG driver
  drm: sti: add VTAC drivers
  drm: sti: add HDMI driver
  drm: sti: add HDA driver
  drm: sti: add TVOut driver
  drm: sti: add GDP layer
  drm: sti: add VID layer
  drm: sti: add Mixer
  drm: sti: add Compositor
  drm: sti: Add DRM driver itself

 .../devicetree/bindings/gpu/st,stih4xx.txt         | 189 +++++
 drivers/gpu/drm/Kconfig                            |   2 +
 drivers/gpu/drm/Makefile                           |   1 +
 drivers/gpu/drm/sti/Kconfig                        |  14 +
 drivers/gpu/drm/sti/Makefile                       |  21 +
 drivers/gpu/drm/sti/NOTES                          |  58 ++
 drivers/gpu/drm/sti/sti_compositor.c               | 279 +++++++
 drivers/gpu/drm/sti/sti_compositor.h               |  90 +++
 drivers/gpu/drm/sti/sti_drm_crtc.c                 | 423 +++++++++++
 drivers/gpu/drm/sti/sti_drm_crtc.h                 |  22 +
 drivers/gpu/drm/sti/sti_drm_drv.c                  | 241 ++++++
 drivers/gpu/drm/sti/sti_drm_drv.h                  |  29 +
 drivers/gpu/drm/sti/sti_drm_plane.c                | 195 +++++
 drivers/gpu/drm/sti/sti_drm_plane.h                |  18 +
 drivers/gpu/drm/sti/sti_gdp.c                      | 549 ++++++++++++++
 drivers/gpu/drm/sti/sti_gdp.h                      |  16 +
 drivers/gpu/drm/sti/sti_hda.c                      | 794 ++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi.c                     | 810 +++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi.h                     |  88 +++
 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c         | 336 +++++++++
 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.h         |  14 +
 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c         | 211 ++++++
 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.h         |  14 +
 drivers/gpu/drm/sti/sti_layer.c                    | 197 +++++
 drivers/gpu/drm/sti/sti_layer.h                    | 123 ++++
 drivers/gpu/drm/sti/sti_mixer.c                    | 249 +++++++
 drivers/gpu/drm/sti/sti_mixer.h                    |  54 ++
 drivers/gpu/drm/sti/sti_tvout.c                    | 648 +++++++++++++++++
 drivers/gpu/drm/sti/sti_vid.c                      | 138 ++++
 drivers/gpu/drm/sti/sti_vid.h                      |  12 +
 drivers/gpu/drm/sti/sti_vtac.c                     | 215 ++++++
 drivers/gpu/drm/sti/sti_vtg.c                      | 366 ++++++++++
 drivers/gpu/drm/sti/sti_vtg.h                      |  28 +
 33 files changed, 6444 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/st,stih4xx.txt
 create mode 100644 drivers/gpu/drm/sti/Kconfig
 create mode 100644 drivers/gpu/drm/sti/Makefile
 create mode 100644 drivers/gpu/drm/sti/NOTES
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.c
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.h
 create mode 100644 drivers/gpu/drm/sti/sti_gdp.c
 create mode 100644 drivers/gpu/drm/sti/sti_gdp.h
 create mode 100644 drivers/gpu/drm/sti/sti_hda.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.h
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.h
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.h
 create mode 100644 drivers/gpu/drm/sti/sti_layer.c
 create mode 100644 drivers/gpu/drm/sti/sti_layer.h
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.c
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.h
 create mode 100644 drivers/gpu/drm/sti/sti_tvout.c
 create mode 100644 drivers/gpu/drm/sti/sti_vid.c
 create mode 100644 drivers/gpu/drm/sti/sti_vid.h
 create mode 100644 drivers/gpu/drm/sti/sti_vtac.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.h

-- 
1.9.1

