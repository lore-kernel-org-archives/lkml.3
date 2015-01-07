Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754686AbbAGRW2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 12:22:28 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:2261 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbbAGRWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:22:23 -0500
From: Ezequiel Garcia <ezequiel.garcia@imgtec.com>
To: Andrew Bresticker <abrestic@chromium.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        James Hartley <james.hartley@imgtec.com>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pwm@vger.kernel.org>,
        Ezequiel Garcia <ezequiel.garcia@imgtec.com>
Subject: [PATCH v7 0/4] Imagination Technologies PWM and PDM DACs support
Date: Wed, 7 Jan 2015 14:20:11 -0300
Message-ID: <1420651215-3836-1-git-send-email-ezequiel.garcia@imgtec.com>
X-Mailer: git-send-email 2.2.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.100.200.91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is the seventh round for the IMG PWM and PDM DAC drivers.

The PWM driver is a typical PWM, and I don't think there's anything
controversial there.

The PDM driver -on the other side- is a bit ackward. At first, we tried
to support it as a PWM, but after some lengthy discussions, we came to the
conclusion the controller couldn't be configured with duty and period,
so it was agreed [1] to write a misc driver for it.

Given there won't be any framework (the controller is too rare to justify
a new framework), an internal API is needed. We've tried to keep this API
as simple as possible. Also, we've tried to follow a devicetree binding
similar to the PWM one.

Users of the PDM can call a couple functions to request a channel and
release the resource:

  struct img_pdm_channel *img_pdm_channel_get(struct device *dev);
  void img_pdm_channel_put(struct device *dev);

After requesting a PDM channel, users can enable or configure it:

  int img_pdm_channel_enable(struct img_pdm_channel *chan, bool state);
  int img_pdm_channel_config(struct img_pdm_channel *chan, unsigned int val);

Where 'val' is a hardware-specific quantity, namely, a 12-bit value
that is added to the PDM counter:

  counter [12:0] = counter [11:0] + value [11:0]
  PDM output = counter [12]

Hence, by changing the 'value' it's possible to control the pulse density
(lower values, correspond to lower densities).

Given this looks like very platform-specific, I feel the misc driver is a good
solution, but I'm open to discussion about it.

The reason why these two drivers are being sent together is because of the
peripheral register that is used to enable an output, and mux it as PWM or PDM.
Because this register is not part of the pin controller block, but rather
PWM/PDM specific, and because the register is also used to set the PDM value,
it is simpler to use a regmap-based syscon to deal with it.

The series is based on v3.19-rc3. My goal is to merge at least the PWM driver
for v3.20, if we fail to agree on the PDM driver.

[1] http://www.spinics.net/lists/linux-pwm/msg01990.html

Naidu Tellapati (4):
  pwm: Imagination Technologies PWM DAC driver
  DT: pwm: Add binding document for IMG PWM DAC
  pdm: Imagination Technologies PDM DAC driver
  DT: pdm: Add binding document for IMG PDM DAC

 Documentation/devicetree/bindings/misc/img-pdm.txt |  54 ++
 Documentation/devicetree/bindings/pwm/img-pwm.txt  |  24 +
 drivers/misc/Kconfig                               |  13 +
 drivers/misc/Makefile                              |   1 +
 drivers/misc/img-pdm.c                             | 608 +++++++++++++++++++++
 drivers/pwm/Kconfig                                |  13 +
 drivers/pwm/Makefile                               |   1 +
 drivers/pwm/pwm-img.c                              | 250 +++++++++
 include/linux/img_pdm.h                            |  27 +
 9 files changed, 991 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/misc/img-pdm.txt
 create mode 100644 Documentation/devicetree/bindings/pwm/img-pwm.txt
 create mode 100644 drivers/misc/img-pdm.c
 create mode 100644 drivers/pwm/pwm-img.c
 create mode 100644 include/linux/img_pdm.h

-- 
2.2.1

