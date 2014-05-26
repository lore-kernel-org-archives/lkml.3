Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaEZR0v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 13:26:51 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:51215 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbaEZRZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 13:25:26 -0400
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
        Xiao Jin <jin.xiao@intel.com>, linux-usb@vger.kernel.org,
        Johan Hovold <jhovold@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Peter Hurley <peter@hurleysoftware.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        david.a.cohen@linux.intel.com, yanmin.zhang@intel.com
Subject: [PATCH 00/63] USB: (mostly runtime PM) patches for v3.16-rc
Date: Mon, 26 May 2014 19:22:49 +0200
Message-Id: <1401125032-28490-1-git-send-email-jhovold@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <20140524204235.GA24047@localhost>
References: <20140524204235.GA24047@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out that the three current implementations of aggressive runtime
power management in USB-TTY drivers were quite badly broken (and has so
been since first merged in v2.6.27 and v2.6.32).

These patches fix this runtime PM mess, but also do some clean up and
fix a few other issues.

Note that all patches but the cdc-acm ones (and the single wusbcore one)
are usb-serial, but I decided to include them all in one series as
several bugs were reproduced in both cdc-acm and usb-serial.

For reference, I'm responding to the thread with Xiao Jin's initial bug
report, but the full thread is posted to linux-usb only.

Johan


Johan Hovold (61):
  USB: sierra: fix AA deadlock in open error path
  USB: sierra: fix use after free at suspend/resume
  USB: sierra: fix urb and memory leak in resume error path
  USB: sierra: fix urb and memory leak on disconnect
  USB: sierra: fix remote wakeup
  USB: sierra: fix characters being dropped at close
  USB: sierra: fix urbs not being killed on shutdown
  USB: sierra: fix resume error reporting
  USB: sierra: fix line-control pipe direction
  USB: sierra: remove bogus endpoint test
  USB: sierra: remove unused variable
  USB: sierra: remove unimplemented set_termios
  USB: sierra: remove disconnected test from close
  USB: sierra: do not resume I/O on closed ports
  USB: sierra: remove redundant modem-control requests
  USB: sierra: use interface-data accessors
  USB: sierra: clean up suspend
  USB: sierra: refactor delayed-urb submission
  USB: sierra: minimise no-suspend window during close
  USB: sierra: do not resume I/O on closing ports
  USB: option: fix runtime PM handling
  USB: option: fix line-control pipe direction
  USB: option: add missing usb_mark_last_busy
  USB: usb_wwan: fix write and suspend race
  USB: usb_wwan: fix urb leak at shutdown
  USB: usb_wwan: fix potential NULL-deref at resume
  USB: usb_wwan: fix potential blocked I/O after resume
  USB: usb_wwan: fix discarded writes on resume errors
  USB: usb_wwan: fix remote wakeup
  USB: usb_wwan: remove redundant modem-control request
  USB: usb_wwan: remove unimplemented set_termios
  USB: usb_wwan: remove redundant urb kill from port remove
  USB: usb_wwan: kill interrupt urb explicitly at suspend
  USB: usb_wwan: make resume error messages uniform
  USB: usb_wwan: use interface-data accessors
  USB: usb_wwan: clean up delayed-urb submission
  USB: usb_wwan: remove comment from close
  USB: usb_wwan: remove some superfluous comments
  USB: usb_wwan: remove bogus function prototype
  USB: usb_wwan: report failed submissions as errors
  USB: usb_wwan: do not resume I/O on closing ports
  USB: serial: fix potential runtime pm imbalance at device remove
  USB: serial: remove overly defensive port tests
  USB: kobil_sct: fix control requests without data stage
  USB: cdc-acm: fix write and suspend race
  USB: cdc-acm: fix write and resume race
  USB: cdc-acm: fix broken runtime suspend
  USB: cdc-acm: fix runtime PM for control messages
  USB: cdc-acm: fix shutdown and suspend race
  USB: cdc-acm: fix potential urb leak and PM imbalance in write
  USB: cdc-acm: fix open and suspend race
  USB: cdc-acm: fix failed open not being detected
  USB: cdc-acm: fix I/O after failed open
  USB: cdc-acm: fix runtime PM imbalance at shutdown
  USB: cdc-acm: simplify runtime PM locking
  USB: cdc-acm: remove redundant disconnected test from shutdown
  USB: cdc-acm: minimise no-suspend window during shutdown
  USB: cdc-acm: do not update PM busy on read errors
  USB: cdc-acm: remove redundant usb_mark_last_busy
  USB: cdc-acm: use tty-port dtr_rts
  USB: wusbcore: fix control-pipe directions

xiao jin (2):
  USB: usb_wwan: fix urb leak in write error path
  USB: usb_wwan: fix race between write and resume

 drivers/usb/class/cdc-acm.c     | 177 +++++++++++++++++-------------
 drivers/usb/class/cdc-acm.h     |   2 +-
 drivers/usb/serial/bus.c        |  14 ++-
 drivers/usb/serial/kobil_sct.c  |  22 ++--
 drivers/usb/serial/option.c     |  13 ++-
 drivers/usb/serial/sierra.c     | 198 ++++++++++++++++++++--------------
 drivers/usb/serial/usb-serial.c |  38 +++----
 drivers/usb/serial/usb-wwan.h   |   6 +-
 drivers/usb/serial/usb_wwan.c   | 234 ++++++++++++++++++++--------------------
 drivers/usb/wusbcore/wa-rpipe.c |   4 +-
 10 files changed, 390 insertions(+), 318 deletions(-)

-- 
1.8.5.5

