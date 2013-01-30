Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3A3DCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:02:41 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:13578 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab3A3DCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:02:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Tue, 29 Jan 2013 19:00:45 -0800
From: Alexandre Courbot <acourbot@nvidia.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Stephen Warren <swarren@wwwdotorg.org>, Mark Zhang <markz@nvidia.com>
CC: <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-tegra@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 0/4] Use the Common Display Framework in tegra-drm
Date: Wed, 30 Jan 2013 12:02:15 +0900
Message-ID: <1359514939-15653-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series leverages the (still work-in-progress) Common Display Framework to
add panel support to the tegra-drm driver. It also adds a driver for the
CLAA101WA01A panel used on the Ventana board.

The CDF is a moving target but Tegra needs some sort of display framework and
even in its current state the CDF seems to be the best candidate. Besides, by
using the CDF from now on we hope to provide useful feedback to Laurent and the
other CDF designers.

The changes to tegra-drm are rather minimal. Panels are referenced from Tegra DC
output nodes through the "nvidia,panel" property. This property is looked up
when a display connect notification is received in order to see if it points to
the connected display entity. If it does, the entity is then used for output.

The DPMS states are then propagated to the output entity, which is then supposed
to call back into the set_stream() hook in order to enable/disable the output
stream as needed.

Although the overall design seems to work ok, a few specific issues need to be
addressed:

1) The CDF has a get_modes() hook, but this is already implemented by
tegra_connector_get_modes(). Ideally everything should be moved to the CDF hook,
but Tegra's implementation uses DRM functions to retrieve the EDID and CDF
should, AFAIK, remain DRM-agnostic.

2) There is currently no panel/backlight interaction, e.g. backlight status is
controlled through FB events, independantly from the panel state. It could make
sense to have the panel DT node reference the backlight and control it as part
of its own power on/off sequence. Right now however, a backlight device cannot
ignore FB events.

3) Probably related to 2), now the backlight's power controls are part of the
panel driver, because the pwm-backlight driver cannot control the power
regulator and enable GPIO. This means that the backlight power is not turned off
when its brightness is set to 0 through sysfs. Once again this speaks in favor
of having stronger panel/backlight interaction: for instance, the panel driver
could reference the backlight and hijack its update_status() op to replace it by
one that does the correct power sequencing before calling the original function.
This would require some extra infrastructure though. Another possibility would
be to have a dedicated backlight driver for each panel, with its own
"compatible" string.

The code is based on 3.8rc5 + Steffen's videomode patches and the CDF v2.

Alexandre Courbot (4):
  video: panel: add CLAA101WA01A panel support
  tegra: ventana: add display and backlight DT nodes
  drm: tegra: use the Common Display Framework
  tegra: enable CDF and claa101 panel

 .../bindings/gpu/nvidia,tegra20-host1x.txt         |   2 +
 .../video/display/chunghwa,claa101wa01a.txt        |   8 +
 arch/arm/boot/dts/tegra20-ventana.dts              |  34 +++-
 arch/arm/configs/tegra_defconfig                   |   2 +
 drivers/gpu/drm/tegra/drm.h                        |  16 ++
 drivers/gpu/drm/tegra/output.c                     | 118 +++++++++++-
 drivers/video/display/Kconfig                      |   8 +
 drivers/video/display/Makefile                     |   1 +
 drivers/video/display/panel-claa101wa01a.c         | 209 +++++++++++++++++++++
 9 files changed, 393 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/video/display/chunghwa,claa101wa01a.txt
 create mode 100644 drivers/video/display/panel-claa101wa01a.c

-- 
1.8.1.1

