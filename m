Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932714Ab3DYTQO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 15:16:14 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:48460 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755735Ab3DYTP0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 15:15:26 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: jonjon.arnearne@gmail.com, linux-kernel@vger.kernel.org,
        hverkuil@xs4all.nl, elezegarcia@gmail.com, mkrufky@linuxtv.org,
        mchehab@redhat.com, bjorn@mork.no
Subject: [RFC V2 0/3] Add a driver for Somagic smi2021 
Date: Thu, 25 Apr 2013 21:10:17 +0200
Message-Id: <1366917020-18217-1-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 2nd version of a RFC for a driver for the Somagic SMI2021.
The first version was sendt on 14th of Mars 2013, and can be found here:
http://www.spinics.net/lists/kernel/msg1499018.html

The smi2021 is the usb controller for a range of video capture devices
branded as EasyCap.

The device consists of three major components.
* smi2021 is the usb controller.
* gm7113c is a saa7113 clone for video A/D conversion.
* cs5340 is an audio A/D converter.

The smi2021 chip is in most configurations dependent of some firmware to work.
The biggest change from the last version of this RFC is that I've included
the bootloader module that was responsible for the firmware upload into
the main driver module.

I've also made some changes to the saa7115 module to handle the gm7113c chip.

V4L2-Compliance:

Driver Info:
	Driver name   : smi2021
	Card type     : smi2021
	Bus info      : usb-0000:00:1d.0-1.1
	Driver version: 3.9.0
	Capabilities  : 0x85000001
		Video Capture
		Read/Write
		Streaming
		Device Capabilities
	Device Caps   : 0x05000001
		Video Capture
		Read/Write
		Streaming

Compliance test for device /dev/video1 (not using libv4l2):

Required ioctls:
	test VIDIOC_QUERYCAP: OK

Allow for multiple opens:
	test second video open: OK
	test VIDIOC_QUERYCAP: OK
	test VIDIOC_G/S_PRIORITY: OK

Debug ioctls:
	test VIDIOC_DBG_G/S_REGISTER: OK (Not Supported)
	test VIDIOC_LOG_STATUS: OK

Input ioctls:
	test VIDIOC_G/S_TUNER: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
	test VIDIOC_S_HW_FREQ_SEEK: OK (Not Supported)
	test VIDIOC_ENUMAUDIO: OK (Not Supported)
	test VIDIOC_G/S/ENUMINPUT: OK
	test VIDIOC_G/S_AUDIO: OK (Not Supported)
	Inputs: 2 Audio Inputs: 0 Tuners: 0

Output ioctls:
	test VIDIOC_G/S_MODULATOR: OK (Not Supported)
	test VIDIOC_G/S_FREQUENCY: OK (Not Supported)
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
	Standard Controls: 7 Private Controls: 0

Input/Output configuration ioctls:
	test VIDIOC_ENUM/G/S/QUERY_STD: OK
	test VIDIOC_ENUM/G/S/QUERY_DV_TIMINGS: OK (Not Supported)
	test VIDIOC_DV_TIMINGS_CAP: OK (Not Supported)

Format ioctls:
	test VIDIOC_ENUM_FMT/FRAMESIZES/FRAMEINTERVALS: OK
	test VIDIOC_G/S_PARM: OK
	test VIDIOC_G_FBUF: OK (Not Supported)
	test VIDIOC_G_FMT: OK
	test VIDIOC_TRY_FMT: OK
	test VIDIOC_S_FMT: OK
	test VIDIOC_G_SLICED_VBI_CAP: OK (Not Supported)

Codec ioctls:
	test VIDIOC_(TRY_)ENCODER_CMD: OK (Not Supported)
	test VIDIOC_G_ENC_INDEX: OK (Not Supported)
	test VIDIOC_(TRY_)DECODER_CMD: OK (Not Supported)

Buffer ioctls:
	test VIDIOC_REQBUFS/CREATE_BUFS/QUERYBUF: OK

Total: 36, Succeeded: 36, Failed: 0, Warnings: 0

 [smi2021] Add gm7113c chip to the saa7115 driver
 [smi2021] This is the smi2021 driver
 [smi2021] Add smi2021 driver to buildsystem

 drivers/media/i2c/saa7115.c                    |  61 ++-
 drivers/media/usb/Kconfig                      |   1 +
 drivers/media/usb/Makefile                     |   1 +
 drivers/media/usb/smi2021/Kconfig              |  11 +
 drivers/media/usb/smi2021/Makefile             |  10 +
 drivers/media/usb/smi2021/smi2021.h            | 278 +++++++++++++
 drivers/media/usb/smi2021/smi2021_audio.c      | 380 +++++++++++++++++
 drivers/media/usb/smi2021/smi2021_bootloader.c | 261 ++++++++++++
 drivers/media/usb/smi2021/smi2021_i2c.c        | 137 +++++++
 drivers/media/usb/smi2021/smi2021_main.c       | 431 ++++++++++++++++++++
 drivers/media/usb/smi2021/smi2021_v4l2.c       | 542 ++++++++++++++++++++++++
 drivers/media/usb/smi2021/smi2021_video.c      | 544 +++++++++++++++++++++++++
 include/media/v4l2-chip-ident.h                |   3 +
 13 files changed, 2650 insertions(+), 10 deletions(-)
 create mode 100644 drivers/media/usb/smi2021/Kconfig
 create mode 100644 drivers/media/usb/smi2021/Makefile
 create mode 100644 drivers/media/usb/smi2021/smi2021.h
 create mode 100644 drivers/media/usb/smi2021/smi2021_audio.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_bootloader.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_i2c.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_main.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_v4l2.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_video.c

Comments are welcome.

Best regards,
Jon Arne Jørgensen


