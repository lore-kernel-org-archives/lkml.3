Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab3BBQ1a (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 11:27:30 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:55957 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3BBQ1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 11:27:25 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 0/9] gpiolib: remove gpio_desc[] static array
Date: Sun,  3 Feb 2013 01:29:23 +0900
Message-Id: <1359822572-26009-2-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
References: <1359822572-26009-1-git-send-email-acourbot@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since Linus kindly merged the gpiochip_reserve() removal patches, here comes the
main course.

This series removes the ARCH_NR_GPIOS sized static array of GPIO descriptors
that stood in gpiolib and replaces it with a more flexible mechanism that
dynamically allocates GPIO descriptors as chips are added.

ARCH_NR_GPIOS is still here, but now only controls the upper limit of the GPIO
integer space, i.e. which GPIO numbers are valid and where GPIO chips without a
base GPIO are placed in the GPIO space. Technically it would be possible to get
rid of it completely - but this might change GPIO numbers on some architectures
and make people unhappy. At least it can now be arbitrarily high without
consuming more memory.

As a result of this series, gpiolib has a slightly lower memory footprint (~-9KB
on my Tegra2 board which has a GPIO space of 1024 but only uses 232 of them), is
very slightly slower (because of the gpio to descriptor conversion which is
linear instead of being constant), and (most importantly) is prepared to receive
the new descriptor-based public GPIO interface.

The linear-time conversion between GPIO numbers and descriptors might make some
teeth grind, but please consider the following. First, even though the
conversion is O(n), this is a very small n (the number of GPIO chips), and I
doubt the overhead would be even perceptible. Second, the gpio descriptor
interface that will follow this series will not require this conversion since it
works with descriptors directly. Finally, the GPIO framework allow platforms
that are concerned about performance to implement gpio_get_value() and
gpio_set_value() with a fast path shortcutting gpiolib for those GPIO numbers
for which performance matters, and this is not affected at all by this series.

The patches are split as much as possible to make the switch as easy to follow
as possible - they may actually be oversplit, if this is the case please let me
know and I will resubmit the series.

This has been tested on a Tegra 2 Ventana board. I made sure that debugfs and
sysfs were working as before, and that GPIOs had the expected value. Being a
rather deep change, it should certainly undergo some more testing.

Alexandre Courbot (9):
  gpiolib: link all gpio_chips using a list
  gpiolib: use gpio_chips list in gpiolib_sysfs_init
  gpiolib: use gpio_chips list in gpiochip_find
  gpiolib: use gpio_chips list in sysfs ops
  gpiolib: use gpio_chips list in gpiochip_find_base
  gpiolib: use descriptors internally
  gpiolib: let gpio_chip reference its descriptors
  gpiolib: use gpio_chips list in gpio_to_desc
  gpiolib: dynamically allocate descriptors array

 drivers/gpio/gpiolib.c     | 694 ++++++++++++++++++++++++++++-----------------
 include/asm-generic/gpio.h |   5 +
 2 files changed, 440 insertions(+), 259 deletions(-)

-- 
1.8.1.1

