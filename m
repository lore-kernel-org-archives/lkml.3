Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327AbaIBVkG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:40:06 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:54609 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751278AbaIBVkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:40:03 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 00/26] tty/serial flow control fixes
Date: Tue,  2 Sep 2014 17:39:09 -0400
Message-Id: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch series reworks the internals of tty and serial flow control to
fix multiple races in both START/STOP flow control and RTS/CTS flow control.

The main changes in this series are:
Patch 1
   Backs out the UPF_HARD_FLOW kludge for 8250. This revert should be
   for mainline and -next

Patches 3-7
   Fixes to x_char handling (ie., sending START/STOP) both in the serial
   core and to several UART drivers

Patches 10-15
   Rename and move ASYNC_CTS_FLOW and ASYNC_CHECK_CD statuses into
   a private field for the serial core, and add helper functions to test
   those statuses for UART drivers.

   This is a necessary step toward making tty port->flags SMP-safe, without
   introducing a new lock.

Patches 14, 17 and 21
   Make CTS flow control state SMP-safe, by moving hw_stopped into a private
   field of the serial core.

Patches 22-24
   Make tty flow control changes mutually exclusive.

   Protecting tty->stopped and tty->flow_stopped with a new spin lock (instead
   of the ->ctrl_lock) is required to fix multiple races with controlling
   terminal changes, coming in a follow-on patch series.

Patches 25 and 26
   Cleanup tcflow(TCIxxx)

Regards,

Peter Hurley (26):
  Revert "serial: uart: add hw flow control support configuration"
  serial: Style fix
  serial: imx: Fix x_char handling and tx flow control
  serial: core: Fix x_char race
  serial: core: Remove unsafe x_char optimization
  serial: Fix send_xchar() handlers
  serial: mpc52xx: Use default serial core x_char handler
  serial: sunsab: Don't enable tx if tx stopped
  serial: blackfin: Fix missing gpio.h
  serial: core: Document lock requirement for UPF_* flags updates
  serial: 8250: Document serial8250_modem_status() locking
  serial: core: Unwrap tertiary assignment in uart_handle_dcd_change()
  locking: Add non-fatal spin lock assert
  serial: core: Document and assert lock requirements for irq helpers
  serial: core: Privatize modem status enable flags
  isdn: i4l: Remove ASYNC_CTS_FLOW
  serial: core: Privatize tty->hw_stopped
  usb: serial: Remove unused tty->hw_stopped
  serial: bfin-uart: Fix auto CTS
  serial: core: Use spin_lock_irq() in uart_set_termios()
  tty: Convert tty_struct bitfield to bools
  tty: Serialize tty flow control changes with flow_lock
  tty: Move packet mode flow control notifications to pty driver
  tty: Serialize tcflow() with other tty flow control changes
  tty: Move and rename send_prio_char() as tty_send_xchar()
  tty: Hold termios_rwsem for tcflow(TCIxxx)

 .../devicetree/bindings/serial/of-serial.txt       |   1 -
 Documentation/serial/driver                        |   2 +
 drivers/isdn/i4l/isdn_tty.c                        |   5 -
 drivers/tty/pty.c                                  |  41 ++++++++
 drivers/tty/serial/8250/8250_core.c                |   7 +-
 drivers/tty/serial/bfin_sport_uart.c               |   1 +
 drivers/tty/serial/bfin_uart.c                     |  15 +--
 drivers/tty/serial/imx.c                           |  39 +++-----
 drivers/tty/serial/mpc52xx_uart.c                  |  17 ----
 drivers/tty/serial/mxs-auart.c                     |   2 +-
 drivers/tty/serial/of_serial.c                     |   4 -
 drivers/tty/serial/serial_core.c                   | 109 +++++++++++----------
 drivers/tty/serial/sunhv.c                         |   3 +
 drivers/tty/serial/sunsab.c                        |   5 +-
 drivers/tty/tty_io.c                               |  93 +++++++++++-------
 drivers/tty/tty_ioctl.c                            |  47 +++------
 drivers/usb/serial/digi_acceleport.c               |   7 +-
 drivers/usb/serial/io_ti.c                         |   7 +-
 drivers/usb/serial/ti_usb_3410_5052.c              |   7 +-
 include/linux/serial_core.h                        |  16 ++-
 include/linux/spinlock.h                           |   1 +
 include/linux/spinlock_api_smp.h                   |   1 +
 include/linux/spinlock_api_up.h                    |   1 +
 include/linux/tty.h                                |  11 ++-
 include/linux/tty_driver.h                         |   4 +
 25 files changed, 238 insertions(+), 208 deletions(-)

-- 
2.1.0

