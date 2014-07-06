Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611AbaGFPaN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 11:30:13 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:38714 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751067AbaGFPaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 11:30:10 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Seth Bollinger <sethb@digi.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Sam Ravnborg <sam@ravnborg.org>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 0/2] fixes for empty tx buffer breakage
Date: Sun,  6 Jul 2014 11:29:51 -0400
Message-Id: <1404660593-12172-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140609205917.GA913@drone.musicnaut.iki.fi>
References: <20140609205917.GA913@drone.musicnaut.iki.fi>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Seth Bollinger <sethb@digi.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

Greg,

I completed the audit of serial drivers after reports that
several Sun serial drivers were broken by
commit 717f3bbab3c7628736ef738fdbf3d9a28578c26c,
'serial_core: Fix conditional start_tx on ring buffer not empty'.

I apologize for not submitting this sooner. The delay was due to
an ongoing analysis of serial flow control prompted by Sam Ravnborg's
question:

On 06/10/2014 03:24 PM, Sam Ravnborg wrote:
> I also noticed the typical pattern is:
> 
>      if (uart_circ_empty(xmit) || uart_tx_stopped(port))
> 
> Should you use this pattern also in sunsab.c?

Unfortunately, that analysis revealed that tx flow control is
largely SMP-unsafe, and it's fairly easy to corrupt the hardware
state wrt. the tty flow control state.

I'm still working on the solutions to that; they're too
extensive to submit for 3.16 anyway.

Regards,

Peter Hurley (2):
  serial: Test for no tx data on tx restart
  serial: arc_uart: Use uart_circ_empty() for open-coded comparison

 drivers/tty/serial/arc_uart.c   | 2 +-
 drivers/tty/serial/imx.c        | 3 +++
 drivers/tty/serial/ip22zilog.c  | 2 ++
 drivers/tty/serial/m32r_sio.c   | 8 +++++---
 drivers/tty/serial/pmac_zilog.c | 3 +++
 drivers/tty/serial/sunsab.c     | 3 +++
 drivers/tty/serial/sunzilog.c   | 2 ++
 7 files changed, 19 insertions(+), 4 deletions(-)

-- 
2.0.0

