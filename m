Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbbAVTQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:16:42 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:36163 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbbAVTQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:16:40 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, Jonathan Corbet <corbet@lwn.net>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v3 0/7] platform/chrome: Add user-space dev inferface support
Date: Thu, 22 Jan 2015 20:16:19 +0100
Message-Id: <1421954186-29764-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The mainline ChromeOS Embedded Controller (EC) driver is still missing some
features that are present in the downstream ChromiumOS tree. These are:

  - Low Pin Count (LPC) interface
  - User-space device interface
  - Access to vboot context stored on a block device
  - Access to vboot context stored on EC's nvram
  - Power Delivery Device
  - Support for multiple EC in a system

This is a third version of a series that adds support for the first two of
the missing features: the EC LPC and EC character device interfaces that
are used by user-space to access the ChromeOS EC. The support patches were
taken from the downstream ChromiumOS 3.14 tree with the fixes and cleanups
squashed to have a minimal patch-set.

The version of the ChromeOS EC chardev driver in this series still does not
reflect the latest one that is in the downstream ChromiumOS 3.14 kernel but
makes the delta shorter. Following patches will add the remaining missing
features until both trees are in sync. I preferred to first add the initial
support and then adding the other features to both maintain the original
patch history in the downstream kernel and so preserve the patch authorship
and also make the diff to have a working cros user-space interface smaller.

Previous version of these series were [0] and [1]. This version solves the
issues pointed out by Lee Jones on the earlier revisions.

A big difference between this series and the downstream ChromiumOS kernel is
that the ioctl API is modified to make it 64-bit safe and compatible with both
64 and 32 bit user-space binaries. The data structures passed as arguments in
the ChromiumOS ioctl interface commands has pointers fields and since these
have different byte boundaries alignment requirement, the ChromiumOS driver
has a compat ioctl interface. The feedback was that this had to be avoided
since this was a new ioctl API so the pointers fields were replaced with a set
of fixed-size arrays to be used instead. This has the drawback that more data
could be used and copied between user and kernel space so feedback is welcomed
if there is a better approach to solve this kind of issues.

The patches were tested on an Exynos5420 Peach Pit Chromebook and (thanks to
Bill Richardson) on an x86 Pixel Chromebook using a modified ectool [2] to use
the new ioctl API. The LPC interface driver and the lightbar sysfs driver were
also tested on the Pixel Chromebook.

The series is composed of the following patches:

Bill Richardson (4):
  misc: Add cros_ec_lpc driver for x86 devices
  platform/chrome: Add Chrome OS EC userspace device interface
  platform/chrome: Create sysfs attributes for the ChromeOS EC.
  platform/chrome: Expose Chrome OS Lightbar to users

Javier Martinez Canillas (3):
  mfd: cros_ec: Use fixed size arrays to transfer data with the EC
  mfd: cros_ec: Add char dev and virtual dev pointers
  mfd: cros_ec: Instantiate ChromeOS EC character device

 Documentation/ioctl/ioctl-number.txt       |   1 +
 drivers/i2c/busses/i2c-cros-ec-tunnel.c    |  51 +---
 drivers/input/keyboard/cros_ec_keyb.c      |  13 +-
 drivers/mfd/cros_ec.c                      |  19 +-
 drivers/misc/Kconfig                       |  10 +
 drivers/misc/Makefile                      |   1 +
 drivers/misc/cros_ec_lpc.c                 | 308 ++++++++++++++++++++++++
 drivers/platform/chrome/Kconfig            |  14 +-
 drivers/platform/chrome/Makefile           |   2 +
 drivers/platform/chrome/cros_ec_dev.c      | 274 +++++++++++++++++++++
 drivers/platform/chrome/cros_ec_dev.h      |  53 +++++
 drivers/platform/chrome/cros_ec_lightbar.c | 367 +++++++++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_sysfs.c    | 271 +++++++++++++++++++++
 include/linux/mfd/cros_ec.h                |  23 +-
 14 files changed, 1345 insertions(+), 62 deletions(-)
 create mode 100644 drivers/misc/cros_ec_lpc.c
 create mode 100644 drivers/platform/chrome/cros_ec_dev.c
 create mode 100644 drivers/platform/chrome/cros_ec_dev.h
 create mode 100644 drivers/platform/chrome/cros_ec_lightbar.c
 create mode 100644 drivers/platform/chrome/cros_ec_sysfs.c

Patch #1 modified the struct cros_ec_command structure so it can be used
as an ioctl argument and be 64 and 32 bit safe and patch #2 adds fields
to the struct cros_ec_device that will be needed by the EC chardev driver.

Patch #3 adds support for the EC LPC interface used on x86 Chromebooks.

Patch #4 adds the ChromeOS chardev driver and patch #5 instantiates it
from the mfd cros_ec driver.

Patch #6 exposes sysfs attributes that can be used by user space programs
to get information and control the ChromeOS EC.

Patch #7 exposes sysfs attributes that are used to control the lightbar
RGB LEDs found on the Pixel Chromebook.

The patches must be applied together and in that order due dependencies.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/11/17/429
[1]: https://lkml.org/lkml/2015/1/2/77
[2]: git://git.collabora.co.uk/git/user/javier/ec.git mainline-ioctl
