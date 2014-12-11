Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965223AbaLKWAg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 17:00:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42388 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751670AbaLKWAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 17:00:34 -0500
From: NeilBrown <neilb@suse.de>
To: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>, Jiri Slaby <jslaby@suse.cz>
Date: Fri, 12 Dec 2014 08:59:43 +1100
Subject: [PATCH 0/3] Add support for 'tty-slaves' described by devicetree.
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141211214801.4127.93914.stgit@notabene.brown>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings TTY and Devicetree folks.

On my phone (GTA04) there are two devices which are each accessed via
a UART: the bluetooth module and the GPS.

I would like these to be powered on when the relevant /dev/ttyXX
is opened, and to be powered off when the tty is closed.

This patch series adds support for "tty slaves" and creates two
appropriate drivers of this type.

A "tty slave" is a platform device which is primarily attached by a
TTY (i.e. a uart).  Like other platform devices it might have other
interconnections like gpios and regulators etc.

In devicetree, any child node of a uart with a 'compatible' attribute
is treated as a 'tty slave'.  This means that it is probed like any
other platform device.  Also, when the tty is opened the device is
powered on by taking a pm_runtime reference..  Similarly when the tty is
closed the pm_runtime reference is dropped.

One of the drivers is a generic "tty-regulator" drive which simply
enables a regulator when powered on, and disables it when no longer
in use.  This suffices for my bluetooth device.

The other handles the slightly awkward details of powering on my
particular GPS as well as a regulator which powers the antenna.
It also registers an 'rfkill' which can power-off the antenna
independently of the TTY.

Comments and review most welcome.

Thanks,
NeilBrown


---

NeilBrown (3):
      TTY: add support for "tty slave" devices.
      TTY: add slave driver to power-on device via a regulator.
      TTY/slave: add driver for w2sg0004 GPS


 .../devicetree/bindings/serial/of-serial.txt       |    4 
 .../devicetree/bindings/serial/slave-reg.txt       |   18 +
 .../devicetree/bindings/serial/slave-w2sg0004.txt  |   35 ++
 drivers/tty/Kconfig                                |    2 
 drivers/tty/Makefile                               |    1 
 drivers/tty/slaves/Kconfig                         |   18 +
 drivers/tty/slaves/Makefile                        |    3 
 drivers/tty/slaves/tty-reg.c                       |  102 +++++
 drivers/tty/slaves/tty-w2sg0004.c                  |  412 ++++++++++++++++++++
 drivers/tty/tty_io.c                               |   22 +
 10 files changed, 617 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/slave-reg.txt
 create mode 100644 Documentation/devicetree/bindings/serial/slave-w2sg0004.txt
 create mode 100644 drivers/tty/slaves/Kconfig
 create mode 100644 drivers/tty/slaves/Makefile
 create mode 100644 drivers/tty/slaves/tty-reg.c
 create mode 100644 drivers/tty/slaves/tty-w2sg0004.c

--
Signature

