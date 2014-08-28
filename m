Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaH1Ofx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 10:35:53 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:58116 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaH1Ofv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 10:35:51 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, kernel@stlinux.com, wsa@the-dreams.de,
        grant.likely@linaro.org, linux-i2c@vger.kernel.org,
        devicetree@vger.kernel.org, linus.walleij@linaro.org
Subject: [PATCH RESEND 0/8] i2c: Relax mandatory I2C ID table passing
Date: Thu, 28 Aug 2014 15:35:30 +0100
Message-Id: <1409236538-21274-1-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Placing this firmly back on your plate.  I truly hope we don't miss
another merge-window.  This patch-set has the support of some pretty
senior kernel maintainers, so I hope acceptance shouldn't be too
difficult.

As previously discussed I believe it should be okay for an I2C device
driver _not_ supply an I2C ID table to match to.  The I2C subsystem
should be able to match via other means, such as via OF tables.  The
blocking factor during our previous conversation was to keep
registering via sysfs up and running.  This set does that.

After thinking more deeply about the problem, it occurred to me that
any I2C device driver which uses the sysfs method and issues an
of_match_device() would also fail their probe().  Bolted on to this
set is a new, more generic way for these devices to match against
either of the I2C/OF tables.

I hope this ticks all of your boxes.

v3:
  - Insist on passing 'struct i2c_client' instead of 'struct device'
  - Remove hook from of_match_device()

v2:
  - Removal of ACPI support (this is really an OF issue).
  - Add a new .probe2( with will seamlessly replace
  - Supply a warning on devices matching via OF without a suitable compatible
  - Remove unified match_device() - bad idea as it subverts type-safe behaviour
  - Provide examples of the kind of clean-up possible after this set.
    - I already have the full support from the maintainer of these drivers =;-)

Kind regards,
Lee

Lee Jones (8):
  i2c: Add pointer dereference protection to i2c_match_id()
  i2c: Add the ability to match device to compatible string without an
    of_node
  i2c: Match using traditional OF methods, then by vendor-less
    compatible strings
  i2c: Make I2C ID tables non-mandatory for DT'ed devices
  i2c: Export i2c_match_id() for direct use by device drivers
  i2c: Provide a temporary .probe2() call-back type
  mfd: 88pm860x: Move over to new I2C device .probe() call
  mfd: as3722: Rid driver of superfluous I2C device ID structure

 drivers/i2c/i2c-core.c      | 72 +++++++++++++++++++++++++++++++++++++++------
 drivers/mfd/88pm860x-core.c |  5 ++--
 drivers/mfd/as3722.c        | 12 ++------
 include/linux/i2c.h         | 22 +++++++++++++-
 4 files changed, 88 insertions(+), 23 deletions(-)

-- 
1.9.1

