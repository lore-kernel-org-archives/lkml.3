Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab3I2It3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 04:49:29 -0400
Received: from smtp-out-220.synserver.de ([212.40.185.220]:1401 "EHLO
	smtp-out-220.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3I2It1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 04:49:27 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 1782
From: Lars-Peter Clausen <lars@metafoo.de>
To: Wolfram Sang <wsa@the-dreams.de>, David Airlie <airlied@linux.ie>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
        alsa-devel@alsa-project.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 0/8] i2c: Remove redundant driver field from the i2c_client struct
Date: Sun, 29 Sep 2013 10:50:58 +0200
Message-Id: <1380444666-12019-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series removes the redundant driver field from the i2c_client struct. The
field is redundant since the same pointer can be accessed through
to_i2c_driver(client->dev.driver). The commit log suggests that the field has
been around since forever (since before v2.6.12-rc2) and it looks as if it was
simply forgotten to remove it during the conversion of the i2c framework to the
generic device driver model.

Nevertheless there are a still a few users of the field around. This series
first updates all users to use an alternative method of accessing the same data
and then the last patch removes the driver field from the i2c_client struct.

Note that due to this changes on most architectures neither the code size nor
the type of generated instructions will change. This is due to the fact that we
aren't really interested in the pointer value itself, but rather want to
dereference it to access one of the fields of the struct. offset_of() (and hence
to_i2c_driver) works by subtracting a offset from the pointer, so the compiler
can internally create the sum of these two offsets and use that to access the
field.

E.g. on ARM the expression client->driver->command(...) generates

		...
		ldr     r3, [r0, #28]
		ldr     r3, [r3, #32]
		blx     r3
		...

and the expression to_i2c_driver(client->dev.driver)->command(...) generates

		...
		ldr     r3, [r0, #160]
    	ldr     r3, [r3, #-4]
    	blx     r3
		...

Other architectures will generate similar code.

The most common pattern is to use the i2c_driver to get to the device_driver
struct embedded in it. The same struct can easily be accessed through the device
struct embedded in the i2c_client struct.  E.g. client->driver->driver.field can
be replaced by client->dev.driver->field. Here again the generated code is
almost identical and only the offsets differ.

E.g. on ARM the expression 'client->driver->driver.owner' generates

		ldr     r3, [r0, #28]
		ldr     r0, [r3, #44]

and 'client->dev.driver->owner' generates

		ldr     r3, [r0, #160]
		ldr     r0, [r3, #8]

The kernel overall code size is slightly reduced since the code that manages the
driver field is removed and of course also the runtime memory footprint of the
i2c_client struct is reduced.

- Lars

Lars-Peter Clausen (8):
  [media] s5c73m3: Don't use i2c_client->driver
  [media] exynos4-is: Don't use i2c_client->driver
  [media] core: Don't use i2c_client->driver
  drm: encoder_slave: Don't use i2c_client->driver
  drm: nouveau: Don't use i2c_client->driver
  ALSA: ppc: keywest: Don't use i2c_client->driver
  ASoC: imx-wm8962: Don't use i2c_client->driver
  i2c: Remove redundant 'driver' field from the i2c_client struct

 drivers/gpu/drm/drm_encoder_slave.c            |  8 ++++----
 drivers/gpu/drm/nouveau/core/subdev/therm/ic.c |  3 ++-
 drivers/i2c/i2c-core.c                         | 21 ++++++++++++---------
 drivers/i2c/i2c-smbus.c                        | 10 ++++++----
 drivers/media/i2c/s5c73m3/s5c73m3-core.c       |  2 +-
 drivers/media/platform/exynos4-is/media-dev.c  |  6 +++---
 drivers/media/v4l2-core/tuner-core.c           |  6 +++---
 drivers/media/v4l2-core/v4l2-common.c          | 10 +++++-----
 include/linux/i2c.h                            |  2 --
 include/media/v4l2-common.h                    |  2 +-
 sound/ppc/keywest.c                            |  4 ++--
 sound/soc/fsl/imx-wm8962.c                     |  2 +-
 12 files changed, 40 insertions(+), 36 deletions(-)

-- 
1.8.0

