Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaLIL60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 06:58:26 -0500
Received: from bhuna.collabora.co.uk ([93.93.135.160]:58025 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbaLIL6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 06:58:23 -0500
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
To: Lee Jones <lee.jones@linaro.org>, Olof Johansson <olof@lixom.net>
Cc: Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: [PATCH v2 0/6] platform/chrome: Add user-space dev inferface support
Date: Tue,  9 Dec 2014 12:57:42 +0100
Message-Id: <1418126268-12532-1-git-send-email-javier.martinez@collabora.co.uk>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The mainline ChromeOS Embedded Controller (EC) driver is still missing some
features that are present in the downstream ChromiumOS tree. These are:

  - User-space device interface
  - Low Pin Count (LPC) interface
  - Access to vboot context stored on a block device
  - Access to vboot context stored on EC's nvram
  - Power Delivery Device
  - Support for multiple EC in a system

This is a second version of a series that adds support for the first of
these missing features: the ChromeOS EC character device driver that provides
the interface used by user-space to access the EC. The support patches were
taken from the downstream ChromiumOS 3.14 kernel tree with fixes and cleanups
squashed to have a minimal patch-set.

The version of the ChromeOS EC chardev driver in this series still does not
reflect the latest one that is in the downstream ChromiumOS 3.14 kernel but
makes the delta shorter. Following patches will add the remaining missing
features until both trees are in sync. I preferred to first add the initial
support and then adding the other features to both maintain the original
patch history in the downstream kernel and so preserve the patch authorship
and also make the diff to have a working cros user-space interface smaller.

Version 1 of this series was [0] and added the Chrome EC chardev driver
and the sysfs interface to drivers/mfd since that is what is done in the
downstream ChromiumOS kernel but Lee Jones asked to find a better place
since those are not really multi-function device drivers. So this version
places them under drivers/platform/chrome since MAINTAINERS says that this
sub-directory is "CHROME HARDWARE PLATFORM SUPPORT" which seems a good fit.

A big change in this version is that the ioctl API is modified to make it
64-bit safe and compatible with both 64 and 32 bit user-space binaries.
The data structures passed as arguments to ioctl commands had pointers fields
and these have different byte boundaries alignment requirement so the previous
version had a compat ioctl interface. The feedback was that this had to be
avoided since this was a new ioctl API so the pointers fields were replaced
with a set of fixed-size arrays to be used instead. This has the drawback that
more data could be used and copied between user and kernel space so feedback
is welcomed if there is a better approach to solve this kind of issues.

The patches were tested on an Exynos5420 Peach Pit Chromebook usig a modified
ectool [1] adapted to use the new ioctl API. I don't have access to a Pixel
Chromebook so testing of the sysfs lightbar interface is highly appreciated.

The series is composed of the following patches:

Bill Richardson (3):
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
 drivers/platform/chrome/Kconfig            |  14 +-
 drivers/platform/chrome/Makefile           |   2 +
 drivers/platform/chrome/cros_ec_dev.c      | 274 ++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_dev.h      |  53 +++++
 drivers/platform/chrome/cros_ec_lightbar.c | 363 +++++++++++++++++++++++++++++
 drivers/platform/chrome/cros_ec_sysfs.c    | 271 +++++++++++++++++++++
 include/linux/mfd/cros_ec.h                |  23 +-
 11 files changed, 1022 insertions(+), 62 deletions(-)
 create mode 100644 drivers/platform/chrome/cros_ec_dev.c
 create mode 100644 drivers/platform/chrome/cros_ec_dev.h
 create mode 100644 drivers/platform/chrome/cros_ec_lightbar.c
 create mode 100644 drivers/platform/chrome/cros_ec_sysfs.c

Patch #1 modified the struct cros_ec_command structure so it can be used
as an ioctl argument and be 64 and 32 bit safe and patch #2 adds fields
to the struct cros_ec_device that will be needed by the EC chardev driver.

Patch #3 adds the ChromeOS chardev driver and patch #4 instantiates it
from the mfd cros_ec driver.

Patch #5 and Patch #6 exposes sysfs attributes that can be used by user
space programs to get information and control the ChromeOS EC.

The patches must be applied together and in that order due dependencies.

Best regards,
Javier

[0]: https://lkml.org/lkml/2014/11/17/429
[1]: git://git.collabora.co.uk/git/user/javier/ec.git mainline-ioctl
