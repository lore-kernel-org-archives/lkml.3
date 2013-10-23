Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3JWWuO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 18:50:14 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:52882 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab3JWWuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 18:50:12 -0400
From: Philippe Proulx <philippe.proulx@savoirfairelinux.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Mark Jackson <mpfj-list@newflow.co.uk>, linux-kernel@vger.kernel.org,
        kernel@savoirfairelinux.com
Subject: [PATCH 0/2] serial: omap: improve performance for RS-485
Date: Wed, 23 Oct 2013 18:49:57 -0400
Message-Id: <cover.1382567103.git.philippe.proulx@savoirfairelinux.com>
X-Mailer: git-send-email 1.8.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current RS-485 implementation for the OMAP serial driver is to not
disable THR interrupts when the driver ring buffer becomes empty until
it makes sure the TX shift register is empty, which means the UART is
not transmitting anymore and only then can the driver toggle the GPIO
output pin for RS-485 data direction.

Since the UART TX FIFO trigger level is set to 32 characters (the
comment said 16, but it's really 32), this means there's a burst of IRQs
for the transmission time of 33 characters (which means at least 34 ms
at 9600 bauds, for example) since the TX FIFO is always below its
trigger level and the THR interrupts are not disabled. The driver is
essentially polling the status bit using interrupts during this time.

This patchset makes use of the TXEMPTYCTLIT bit of the SCR register
instead, which makes it possible to get a THR interrupt only when both
the TX FIFO and the TX shift register are empty. We only use this mode
if RS-485 is enabled.

This patchset also fixes a few minor coding style warnings from
checkpatch.pl.

The patches apply to tty/tty-next.

Philippe Proulx (2):
  serial: omap: improve RS-485 performance
  serial: omap: fix a few checkpatch warnings

 drivers/tty/serial/omap-serial.c | 67 +++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 21 deletions(-)

-- 
1.8.4.1

