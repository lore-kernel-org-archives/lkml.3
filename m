Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934453Ab3IDLaa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 07:30:30 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:14241 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab3IDLa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 07:30:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Sep 2013 04:30:24 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>
CC: <gnurou@gmail.com>, <linux-gpio@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC 0/5] New descriptor-based GPIO interface
Date: Wed, 4 Sep 2013 20:29:24 +0900
Message-ID: <1378294169-22661-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.4
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a first RFC for the new GPIO interface. It's terribly overdue, and in
order to avoid delaying it further I decided to send it as-is instead of being
even more perfectionist. The main issue I have with it is that it highlights
some points that could be simplified in gpiolib, some of which require a
refactoring of gpiolib's clients. I wasn't sure which, of the cleanup or new
interface, should come first and stayed in this state of confusion for several
months ; but in the end I believe it's more appropriate to clearly lay the
interfaces we want to use first, and then refactor the lib accordingly. So
please be mindful that another round of cleanup, both of gpiolib itself and its
consumers, should come once a later version of these patches is validated (and
hopefully merged) and that this series should be considered just another step
towards gpiolib's sanitization (although I also secretly hope the new interface
will be deemed useful by itself).

Another point that definitely needs more attention is the documentation. I am
not sure whether the new interface should be described as a couple of sections
in the existing GPIO documentation (the current approach) or as a new
documentation file of its own.

The new gpiod public interface is just an export of how gpiolib now works
internally. By representing GPIOs as opaque descriptors intead of integers, it
aims at making GPIO usage safer and more coherent with respect to other
subsystems by using a proper get/put mechanism and ensuring all GPIOs in use at
a given time are valid. It also makes GPIO acquisition easier for consumers, by
offering a standard way to bind GPIOs to devices. Finally, it tries to fix some
of the inconsistencies gpiolib acquired over time, like the incoherent handling
of active low GPIOs which was only valid when using the sysfs interface.

The old GPIO interface is still accessible and works the same way as before ; I
do not expect any existing code to break as a result of applying this series
(which is not extensively tested yet BTW).

TODO (preferably once this batch is validated):
- Change gpio_get()'s behavior to allow it to return specifiers other than the
first one for DT-declared GPIOs?
- Update as many users of the legacy interface as possible to use the new
interface
- Simplify gpiolib by removing redundant code and corner-cases (gpio_request
must die)
- Try to implement the GPIO fast-path method with gpiod, maybe using the LSB of
GPIO descriptors as a marker to forge fake descriptors?
- If possible, completely deprecate and remove the old gpio interface

Alexandre Courbot (5):
  gpiolib: factorize gpiod_get/set functions
  gpiolib: export descriptor-based GPIO interface
  gpiolib: port of_ functions to use gpiod
  gpiolib: add gpiod_get() and gpiod_put() functions
  gpiolib: update documentation

 Documentation/gpio.txt        | 119 ++++++++++
 drivers/gpio/gpiolib-of.c     |  28 ++-
 drivers/gpio/gpiolib.c        | 525 ++++++++++++++++++++++++++----------------
 include/asm-generic/gpio.h    | 227 ++++++------------
 include/linux/gpio.h          |  11 +-
 include/linux/gpio/consumer.h | 201 ++++++++++++++++
 include/linux/gpio/driver.h   | 163 +++++++++++++
 include/linux/of_gpio.h       |  29 ++-
 8 files changed, 920 insertions(+), 383 deletions(-)
 create mode 100644 include/linux/gpio/consumer.h
 create mode 100644 include/linux/gpio/driver.h

-- 
1.8.4

