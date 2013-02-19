Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229Ab3BSD75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 22:59:57 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:53493 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3BSD7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 22:59:55 -0500
From: Andrey Smirnov <andrew.smirnov@gmail.com>
To: andrew.smirnov@gmail.com
Cc: hverkuil@xs4all.nl, broonie@opensource.wolfsonmicro.com,
        mchehab@redhat.com, sameo@linux.intel.com, perex@perex.cz,
        tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/7] Driver for Si476x series of chips
Date: Mon, 18 Feb 2013 19:59:28 -0800
Message-Id: <1361246375-8848-1-git-send-email-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a fourth version of the patchset originaly posted here:
https://lkml.org/lkml/2012/9/13/590

Second version of the patch was posted here:
https://lkml.org/lkml/2012/10/5/598

Third version of the patch was posted here:
https://lkml.org/lkml/2012/10/23/510

To save everyone's time I'll repost the original description of it:

This patchset contains a driver for a Silicon Laboratories 476x series
of radio tuners. The driver itself is implemented as an MFD devices
comprised of three parts: 
 1. Core device that provides all the other devices with basic
functionality and locking scheme.
 2. Radio device that translates between V4L2 subsystem requests into
Core device commands.
 3. Codec device that does similar to the earlier described task, but
for ALSA SoC subsystem.

v4 of this driver has following changes:
 - All of the adjustable timeouts(expose via sysfs) are gone
 - Names of the controls are changes as was requested
 - Added documentation for exposed debugfs files 
 - Minor fix in si476x_radio_fops_poll
 - DBG_BUFFER is removed
 - Tested for compilation w/o debugfs enabled

This version still has all the radio controls being private. The
reason for that is because I am not sure how that should be handled.

Hans, do you want me to move all the controls to be standard, that is
exted V4L's with the needed controls? Should I pick up the parts of
http://lists-archives.com/linux-kernel/27641304-radio-fixes-and-new-features-for-fm.html and take relevants bits and pieces of it?

How do you want that to be handled?



Here is v4l2-compliance output for one of the tuners:
sudo v4l2-compliance -r /dev/radio0
is radio
Driver Info:
	Driver name   : si476x-radio0
	Card type     : SI476x AM/FM Receiver
	Bus info      : platform:si476x-radio0
	Driver version: 3.1.0
	Capabilities  : 0x81050500
		RDS Capture
		Tuner
		Radio
		Read/Write
		Device Capabilities
	Device Caps   : 0x01050500
		RDS Capture
		Tuner
		Radio
		Read/Write

Compliance test for device /dev/radio0 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second radio open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G_CHIP_IDENT: OK
	test VIDIOC_DBG_G/S_REGISTER: OK
	test VIDIOC_LOG_STATUS: OK (Not Supported)

Input ioctls:
	test VIDIOC_G/S_TUNER: OK
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_S_HW_FREQ_SEEK: OK
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 0 Audio Inputs: 0 Tuners: 1

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK
	test VIDIOC_ENUMAUDOUT: OK (Not Supported)
	test VIDIOC_G/S/ENUMOUTPUT: OK (Not Supported)
	test VIDIOC_G/S_AUDOUT: OK (Not Supported)
	Outputs: 0 Audio Outputs: 0 Modulators: 0

Control ioctls:
	test VIDIOC_QUERYCTRL/MENU: OK
	test VIDIOC_G/S_CTRL: OK
	test VIDIOC_G/S/TRY_EXT_CTRLS: OK
	test VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT: OK
	test VIDIOC_G/S_JPEGCOMP: OK (Not Supported)
	Standard Controls: 2 Private Controls: 8

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: OK (Not Supported)
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK (Not Supported)
	test VIDIOC_G/S_PARM: OK (Not Supported)
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK (Not Supported)
	test VIDIOC_TRY_FMT: OK (Not Supported)
	test VIDIOC_S_FMT: OK (Not Supported)
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK (Not Supported)

Total: 38, Succeeded: 38, Failed: 0, Warnings: 0

Andrey Smirnov (7):
  mfd: Add header files and Kbuild plumbing for SI476x MFD core
  mfd: Add commands abstraction layer for SI476X MFD
  mfd: Add the main bulk of core driver for SI476x code
  mfd: Add chip properties handling code for SI476X MFD
  v4l2: Add a V4L2 driver for SI476X MFD
  sound/soc/codecs: Convert SI476X codec to use regmap
  sound/soc/codecs: Cosmetic changes to SI476X codec driver

 Documentation/video4linux/si476x.txt |  187 ++++
 drivers/media/radio/Kconfig          |   17 +
 drivers/media/radio/Makefile         |    1 +
 drivers/media/radio/radio-si476x.c   | 1557 ++++++++++++++++++++++++++++++++++
 drivers/mfd/Kconfig                  |   13 +
 drivers/mfd/Makefile                 |    4 +
 drivers/mfd/si476x-cmd.c             | 1553 +++++++++++++++++++++++++++++++++
 drivers/mfd/si476x-i2c.c             |  878 +++++++++++++++++++
 drivers/mfd/si476x-prop.c            |  234 +++++
 include/linux/mfd/si476x-core.h      |  525 ++++++++++++
 include/media/si476x.h               |  428 ++++++++++
 sound/soc/codecs/si476x.c            |   47 +-
 12 files changed, 5438 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/video4linux/si476x.txt
 create mode 100644 drivers/media/radio/radio-si476x.c
 create mode 100644 drivers/mfd/si476x-cmd.c
 create mode 100644 drivers/mfd/si476x-i2c.c
 create mode 100644 drivers/mfd/si476x-prop.c
 create mode 100644 include/linux/mfd/si476x-core.h
 create mode 100644 include/media/si476x.h

-- 
1.7.10.4

