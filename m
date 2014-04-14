Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198AbaDNPWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:22:09 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34276 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754502AbaDNPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:22:04 -0400
From: Philipp Zabel <p.zabel@pengutronix.de>
To: devel@driverdev.osuosl.org, Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 0/7] Reorder i.MX IPU display enable/disable sequence
Date: Mon, 14 Apr 2014 17:21:28 +0200
Message-Id: <1397488895-17930-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.9.1
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Repeatedly enabling and disabling the display currently can lead to a state
in which the IPU doesn't produce a valid signal anymore because we disable
IPU submodules before they can finish their interaction.

This series reorders the enable/disable sequence so that we first wait for the
DC/DP to finish processing the current frame, then stop the DI and IDMAC, and
only then disable clocks to the submodules. Also from now on we disable the DC
when it is not in use.

regards
Philipp

Philipp Zabel (7):
  imx-drm: ipu-common: add ipu_map_irq to request non-IDMAC interrupts
  imx-drm: ipu-common: Add helpers to check for a busy IDMAC channel and
    to busywait for an interrupt
  imx-drm: ipu-dmfc: Wait for FIFOs to run empty before disabling
  imx-drm: ipu-dc: Wait for DC_FC_1 / DP_SF_END interrupt
  imx-drm: ipu-dp: Split disabling the DP foreground channel from
    disabling the DP module
  imx-drm: imx-dp: When disabling the DP foreground channel, wait until
    the DP background channel is finished before disabling the IDMAC
    channel
  imx-drm: ipuv3-crtc: Change display enable/disable order

 drivers/staging/imx-drm/ipu-v3/imx-ipu-v3.h |  3 ++
 drivers/staging/imx-drm/ipu-v3/ipu-common.c | 41 ++++++++++++++---
 drivers/staging/imx-drm/ipu-v3/ipu-dc.c     | 71 ++++++++++++++++++++---------
 drivers/staging/imx-drm/ipu-v3/ipu-dmfc.c   | 25 +++++++++-
 drivers/staging/imx-drm/ipu-v3/ipu-dp.c     | 71 +++++++++++++++++++----------
 drivers/staging/imx-drm/ipu-v3/ipu-prv.h    |  3 ++
 drivers/staging/imx-drm/ipuv3-crtc.c        | 10 ++--
 drivers/staging/imx-drm/ipuv3-plane.c       |  4 ++
 8 files changed, 173 insertions(+), 55 deletions(-)

-- 
1.9.1

