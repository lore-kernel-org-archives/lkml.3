Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaETN45 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 09:56:57 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:45639 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760AbaETN4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 09:56:55 -0400
From: Benjamin Gaignard <benjamin.gaignard@linaro.org>
To: dri-devel@lists.freedesktop.org, airlied@linux.ie,
        linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, Benjamin Gaignard <benjamin.gaignard@linaro.org>
Subject: [PATCH v3 00/16] Add DRM for stih4xx platforms
Date: Tue, 20 May 2014 15:56:10 +0200
Message-Id: <1400594186-8956-1-git-send-email-benjamin.gaignard@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series of patches add the support of DRM/KMS drivers for STMicroelectronics
chipsets stih416 and stih407.

patcheset version 3:
	- Correctly split code between probe and bind funtions
	- Squash some commits
	- remove HQ-VDP device code to have a smaller patcheset,
	  we will introduce it later.

	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v3

patcheset version 2:
	- Use componentized device instead of register sub-devices in master
	driver probe function
	- Fix Makefile and Kconfig to only allow built-in compilation

	patches could be found here: git://git.linaro.org/people/benjamin.gaignard/kernel.git
	on branch: drm_kms_for_next-v2
	
patcheset version 1:
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

Benjamin Gaignard (16):
  drm: sti: add VTG driver
  drm: sti: add VTAC drivers
  drm: sti: add HDMI driver
  drm: sti: add I2C client driver for HDMI
  drm: sti: add HDA driver
  drm: sti: add TVOut driver
  drm: sti: add sti layer interface definition
  drm: sti: add GDP layer
  drm: sti: add VID layer
  drm: sti: add Mixer
  drm: sti: add Compositor
  drm: sti: add debug to GDP
  drm: sti: add debug to VID
  drm: sti: add debug to TVout
  drm: sti: add debug to mixer
  drm: sti: Add DRM driver itself

 drivers/gpu/drm/Kconfig                    |    2 +
 drivers/gpu/drm/Makefile                   |    1 +
 drivers/gpu/drm/sti/Kconfig                |   26 +
 drivers/gpu/drm/sti/Makefile               |   22 +
 drivers/gpu/drm/sti/sti_compositor.c       |  267 +++++++
 drivers/gpu/drm/sti/sti_compositor.h       |   84 +++
 drivers/gpu/drm/sti/sti_ddc.c              |   56 ++
 drivers/gpu/drm/sti/sti_drm_connector.c    |  195 +++++
 drivers/gpu/drm/sti/sti_drm_connector.h    |   16 +
 drivers/gpu/drm/sti/sti_drm_crtc.c         |  440 ++++++++++++
 drivers/gpu/drm/sti/sti_drm_crtc.h         |   21 +
 drivers/gpu/drm/sti/sti_drm_drv.c          |  338 +++++++++
 drivers/gpu/drm/sti/sti_drm_drv.h          |   36 +
 drivers/gpu/drm/sti/sti_drm_encoder.c      |  201 ++++++
 drivers/gpu/drm/sti/sti_drm_encoder.h      |   16 +
 drivers/gpu/drm/sti/sti_drm_plane.c        |  195 +++++
 drivers/gpu/drm/sti/sti_drm_plane.h        |   16 +
 drivers/gpu/drm/sti/sti_gdp.c              |  726 +++++++++++++++++++
 drivers/gpu/drm/sti/sti_gdp.h              |   75 ++
 drivers/gpu/drm/sti/sti_hda.c              |  852 ++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hda.h              |   14 +
 drivers/gpu/drm/sti/sti_hdmi.c             | 1071 ++++++++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_hdmi.h             |  198 +++++
 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c |  398 +++++++++++
 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c |  224 ++++++
 drivers/gpu/drm/sti/sti_layer.c            |  309 ++++++++
 drivers/gpu/drm/sti/sti_layer.h            |  113 +++
 drivers/gpu/drm/sti/sti_mixer.c            |  405 +++++++++++
 drivers/gpu/drm/sti/sti_mixer.h            |   54 ++
 drivers/gpu/drm/sti/sti_tvout.c            |  904 +++++++++++++++++++++++
 drivers/gpu/drm/sti/sti_tvout.h            |  105 +++
 drivers/gpu/drm/sti/sti_vid.c              |  259 +++++++
 drivers/gpu/drm/sti/sti_vid.h              |   34 +
 drivers/gpu/drm/sti/sti_vtac_rx.c          |  169 +++++
 drivers/gpu/drm/sti/sti_vtac_tx.c          |  182 +++++
 drivers/gpu/drm/sti/sti_vtac_utils.h       |   52 ++
 drivers/gpu/drm/sti/sti_vtg.c              |  468 ++++++++++++
 drivers/gpu/drm/sti/sti_vtg.h              |   20 +
 drivers/gpu/drm/sti/sti_vtg_utils.c        |   99 +++
 drivers/gpu/drm/sti/sti_vtg_utils.h        |   29 +
 40 files changed, 8692 insertions(+)
 create mode 100644 drivers/gpu/drm/sti/Kconfig
 create mode 100644 drivers/gpu/drm/sti/Makefile
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.c
 create mode 100644 drivers/gpu/drm/sti/sti_compositor.h
 create mode 100644 drivers/gpu/drm/sti/sti_ddc.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_connector.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_connector.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_crtc.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_drv.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_encoder.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_encoder.h
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.c
 create mode 100644 drivers/gpu/drm/sti/sti_drm_plane.h
 create mode 100644 drivers/gpu/drm/sti/sti_gdp.c
 create mode 100644 drivers/gpu/drm/sti/sti_gdp.h
 create mode 100644 drivers/gpu/drm/sti/sti_hda.c
 create mode 100644 drivers/gpu/drm/sti/sti_hda.h
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi.h
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g0c55phy.c
 create mode 100644 drivers/gpu/drm/sti/sti_hdmi_tx3g4c28phy.c
 create mode 100644 drivers/gpu/drm/sti/sti_layer.c
 create mode 100644 drivers/gpu/drm/sti/sti_layer.h
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.c
 create mode 100644 drivers/gpu/drm/sti/sti_mixer.h
 create mode 100644 drivers/gpu/drm/sti/sti_tvout.c
 create mode 100644 drivers/gpu/drm/sti/sti_tvout.h
 create mode 100644 drivers/gpu/drm/sti/sti_vid.c
 create mode 100644 drivers/gpu/drm/sti/sti_vid.h
 create mode 100644 drivers/gpu/drm/sti/sti_vtac_rx.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtac_tx.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtac_utils.h
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg.h
 create mode 100644 drivers/gpu/drm/sti/sti_vtg_utils.c
 create mode 100644 drivers/gpu/drm/sti/sti_vtg_utils.h

-- 
1.9.1

