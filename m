Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751428AbaKESMD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:12:03 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:33507 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751223AbaKESL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:11:59 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 0/5] set_ldisc notification fixes
Date: Wed,  5 Nov 2014 13:11:40 -0500
Message-Id: <1415211105-16668-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

This patch series fixes several locking and functional problems
with the .set_ldisc() notification sent by the tty core:
1) termios is used without holding termios_rwsem
2) uart port flags are changed without holding port mutex
3) several of the drivers call their enable_ms() routines directly
   without holding port lock
4) The set_ldisc notification will turn on modem status interrupts
   if the CD line is being used for N_PPS time signal, but doesn't
   turn modem status interrupts back off if N_PPS is being unset.

Note: this series depends on the 26-patch 'tty locking changes'
series and the 10-patch 'serial core fixes' series.

Regards,

Peter Hurley (5):
  tty: Allow safe access to termios for set_ldisc() handlers
  serial: core: Claim port mutex for set_ldisc()
  serial: core: Pass termios to set_ldisc() notifications
  serial: Take uart port lock for direct *_enable_ms()
  serial: Test/disable MSIs if switching from N_PPS

 drivers/tty/serial/8250/8250_core.c | 27 ++++++++++++++++++++++++---
 drivers/tty/serial/amba-pl010.c     | 24 +++++++++++++++++++++---
 drivers/tty/serial/atmel_serial.c   | 11 +++++++++--
 drivers/tty/serial/bfin_uart.c      |  5 +++--
 drivers/tty/serial/clps711x.c       |  5 +++--
 drivers/tty/serial/serial_core.c    |  7 +++++--
 drivers/tty/tty_ldisc.c             |  5 ++++-
 include/linux/serial_core.h         |  2 +-
 8 files changed, 70 insertions(+), 16 deletions(-)

-- 
2.1.3

