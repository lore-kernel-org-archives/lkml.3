Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbaJUPHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 11:07:35 -0400
Received: from ring0.de ([5.45.105.125]:53879 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753569AbaJUPHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 11:07:33 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
From: Sebastian Reichel <sre@kernel.org>
To: Hans Verkuil <hans.verkuil@cisco.com>, linux-media@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Sebastian Reichel <sre@kernel.org>
Subject: [RFCv2 0/8] [media] si4713 DT binding
Date: Tue, 21 Oct 2014 17:06:59 +0200
Message-Id: <1413904027-16767-1-git-send-email-sre@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the RFCv2 patchset adding DT support to the si4713
radio transmitter i2c driver. The changes can be summarized
as follows:

 * Move regulator information back into the driver. The
   regulators needed are documented in the chip and have
   nothing to do with boarddata. Instead devm_regulator_get_optional
   is used and errors are handled quite loosely now. Maybe the USB
   driver should provide dummy regulators.
 * GPIO handling is updated to gpiod consumer interface, resulting
   in a driver cleanup and easy DT handling
 * The driver is updated to use managed resources wherever possible

So much about the nice stuff. But there is also

 * Instantiation of the platform device from the i2c (sub-)device. Since DT
   is not supposed to contain linuxisms the device is a simple i2c node
   resulting in the i2c probe function being called. Thus registering the main
   v4l device must happen from there.

Tested:
 * Compilation on torvalds/linux.git:master (based on 52d589a)
 * Booting in DT mode
 * Some simply driver queries using v4l2-ctl

Not tested:
 * The USB driver, since I do not own the USB dongle
 * The legacy platform code (only DT boot has been tested).
   (The legacy platform code is supposed to removed in the near future anyways)

Changes since RFCv1 (requested by Hans Verkuil):
 - splitted the patchset into more patches
 - replaced dev_info with dev_dbg for missing regulators
 - check for ENOSYS value from devm_gpiod_get (disabled GPIOLIB)

-- Sebastian

Sebastian Reichel (8):
  [media] si4713: switch to devm regulator API
  [media] si4713: switch reset gpio to devm_gpiod API
  [media] si4713: use managed memory allocation
  [media] si4713: use managed irq request
  [media] si4713: add device tree support
  [media] si4713: add DT binding documentation
  ARM: OMAP2: RX-51: update si4713 platform data
  [media] si4713: cleanup platform data

 Documentation/devicetree/bindings/media/si4713.txt |  30 ++++
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  69 ++++-----
 drivers/media/radio/si4713/radio-platform-si4713.c |  28 +---
 drivers/media/radio/si4713/si4713.c                | 167 +++++++++++++--------
 drivers/media/radio/si4713/si4713.h                |  15 +-
 include/media/radio-si4713.h                       |  30 ----
 include/media/si4713.h                             |   4 +-
 7 files changed, 186 insertions(+), 157 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/media/si4713.txt
 delete mode 100644 include/media/radio-si4713.h

-- 
2.1.1

