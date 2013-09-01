Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab3IATkf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 15:40:35 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:57487 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752139Ab3IATkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 15:40:32 -0400
From: =?UTF-8?q?Jon=20Arne=20J=C3=B8rgensen?= <jonarne@jonarne.no>
To: linux-media@vger.kernel.org
Cc: m.chehab@samsung.com, rdunlap@infradead.org, hans.verkuil@cisco.com,
        mkrufky@linuxtv.org, lkundrak@v3.sk, linux-kernel@vger.kernel.org
Subject: [RFC v3] Add a driver for the somagic smi2021 chip
Date: Sun,  1 Sep 2013 21:42:50 +0200
Message-Id: <1378064571-10537-1-git-send-email-jonarne@jonarne.no>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch will add a driver for the smi2021 chip.

This chip is found in a series of usb video capture devices branded as Easycap.

On first insertion, the device will identify as 0x1c88:0x0007.
This is just a bootloader stage. After uploading the firmware, the
device will reconnect with usb product id 0x003c, 0x003d, 0x003e or 0x003f
depending on the firmware.

The device uses the gm7113c chip for video ADC, this is a clone of the
saa7113 chip. This chip is controlled over i2c-bus from the bridge
chip by a proprietary usb control transfer.

The device also has a CirrusLogic CS5340 chip for audio ADC.

This is the third version of this patch.
The first version was posted on 14th of Mars 2013, and can be found here:
http://www.spinics.net/lists/kernel/msg1499018.html

The second version was posted on 25th of April 2014, and can be found here:
http://www.spinics.net/lists/linux-media/msg63049.html

Between the 2nd version and this version,
most of my time was spent on implementing i2c platform_data
for the saa7113 driver and having it accepted.
I've also done a major rework on the code of this driver,
rewriting almost all of it.

This patch should be applied to the current media-master
from linuxtv as it requires these patches:
https://patchwork.linuxtv.org/patch/19535
https://patchwork.linuxtv.org/patch/19536
https://patchwork.linuxtv.org/patch/19537

Output from v4l2-compliance:

Driver Info:
	Driver name   : smi2021
	Card type     : smi2021
	Bus info      : usb-0000:00:1d.0-1.1
	Driver version: 3.11.0
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

Jon Arne Jørgensen (1):
  media: Add a driver for the Somagic smi2021 chip

 drivers/media/usb/Kconfig                      |   1 +
 drivers/media/usb/Makefile                     |   1 +
 drivers/media/usb/smi2021/Kconfig              |  11 +
 drivers/media/usb/smi2021/Makefile             |   9 +
 drivers/media/usb/smi2021/smi2021.h            | 193 +++++
 drivers/media/usb/smi2021/smi2021_audio.c      | 401 +++++++++++
 drivers/media/usb/smi2021/smi2021_bootloader.c | 256 +++++++
 drivers/media/usb/smi2021/smi2021_main.c       | 952 +++++++++++++++++++++++++
 drivers/media/usb/smi2021/smi2021_v4l2.c       | 277 +++++++
 9 files changed, 2101 insertions(+)
 create mode 100644 drivers/media/usb/smi2021/Kconfig
 create mode 100644 drivers/media/usb/smi2021/Makefile
 create mode 100644 drivers/media/usb/smi2021/smi2021.h
 create mode 100644 drivers/media/usb/smi2021/smi2021_audio.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_bootloader.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_main.c
 create mode 100644 drivers/media/usb/smi2021/smi2021_v4l2.c

-- 
1.8.3.4

