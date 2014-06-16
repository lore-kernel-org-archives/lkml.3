Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbaFPNRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 09:17:46 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:40622 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751679AbaFPNRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 09:17:44 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH tty-next 00/22] tty/serial fixes for 3.17
Date: Mon, 16 Jun 2014 09:16:57 -0400
Message-Id: <1402924639-5164-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These patches are the accumulation of fixes resulting from audits
of the tty and serial cores; mostly cleanups of open() and close().
Most of the changes remove condition testing and handling which
cannot occur because the tty lock is held for the tty driver open()
call.

The exceptions are the last 3 patches which address API design and
locking issues for uart drivers.

At least 4 known bugs remain:
1. Several drivers mishandle the start_tx() method; I hope to finish
   an audit of these soon for fixing in 3.16.
2. uart_open() mismanages the port count if an error occurs,
   because uart_close() is always called even if open() returns
   an error
3. Most of the port->flags usage is SMP-unsafe; atomics are mixed
   with spinlock-protected updates.
4. uart_remove_one_port() is unsafe, as there is no provision for
   preventing in-use port removal.

Regards,

Peter Hurley (22):
  tty: Document locking for tty driver methods
  tty: Document locking for tty_port_close{,start,end}()
  tty: Document locking for tty_port_open()
  tty: Document locking for tty_port_block_til_ready()
  tty: Document locking for tty_port_hangup()
  tty: Move tty->closing from port lock critical section
  tty: ipwireless: Remove tty->closing abort from ipw_open()
  serial: Use UPF_* constants with struct uart_port flags
  tty: Remove tty_hung_up_p() tests from tty drivers' open()
  char: synclink: Remove WARN_ON for bad port count
  tty: Call hangup method in modern style
  tty: serial: Fix termios/port flags mismatch
  serial: blackfin: Fix CTS flow control
  tty: Remove tty_wait_until_sent_from_close()
  isdn: tty: Use private flag for ASYNC_CLOSING
  tty: mxser: Use tty->closing for ASYNC_CLOSING
  tty: Remove ASYNC_CLOSING
  tty: Move tty hung up check from port->lock critical section
  serial: Style fix
  serial: Refactor uart_flush_buffer() from uart_close()
  serial: core: Remove superfluous ldisc flush from uart_close()
  serial: Fix locking for uart driver set_termios() method

 Documentation/serial/driver          |  6 ++--
 drivers/char/pcmcia/synclink_cs.c    | 11 -------
 drivers/isdn/i4l/isdn_tty.c          | 16 +++++-----
 drivers/s390/char/con3215.c          |  3 +-
 drivers/staging/dgrp/dgrp_tty.c      | 10 -------
 drivers/tty/cyclades.c               |  9 ------
 drivers/tty/hvc/hvc_console.c        |  2 +-
 drivers/tty/hvc/hvcs.c               |  2 +-
 drivers/tty/ipwireless/tty.c         |  5 ----
 drivers/tty/mxser.c                  |  6 ++--
 drivers/tty/rocket.c                 | 14 +--------
 drivers/tty/serial/68328serial.c     |  2 --
 drivers/tty/serial/amba-pl011.c      |  1 +
 drivers/tty/serial/atmel_serial.c    |  2 ++
 drivers/tty/serial/bfin_sport_uart.c | 11 +++++--
 drivers/tty/serial/bfin_uart.c       | 13 ++++----
 drivers/tty/serial/crisv10.c         | 47 ++++-------------------------
 drivers/tty/serial/lantiq.c          |  2 +-
 drivers/tty/serial/mcf.c             |  4 +--
 drivers/tty/serial/serial-tegra.c    |  2 ++
 drivers/tty/serial/serial_core.c     | 31 ++++++++-----------
 drivers/tty/serial/timbuart.c        |  2 ++
 drivers/tty/synclink.c               | 26 ++++------------
 drivers/tty/synclink_gt.c            | 22 +++-----------
 drivers/tty/synclinkmp.c             | 23 +++-----------
 drivers/tty/tty_io.c                 |  2 +-
 drivers/tty/tty_port.c               | 58 ++++++++++++++++++++----------------
 include/linux/isdn.h                 |  1 +
 include/linux/tty.h                  | 18 -----------
 include/linux/tty_driver.h           |  8 +++--
 include/uapi/linux/tty_flags.h       |  2 --
 net/irda/ircomm/ircomm_tty.c         | 39 ++----------------------
 32 files changed, 117 insertions(+), 283 deletions(-)

-- 
2.0.0

