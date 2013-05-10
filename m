Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3EJOVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:21:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57230 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755601Ab3EJOVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:40 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Wolfram Sang" <wsa@the-dreams.de>,
        "Steven A. Falco" <sfalco@harris.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.950067516@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [050/118] i2c: xiic: must always write 16-bit words to TX_FIFO
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven A. Falco" <sfalco@harris.com>

commit c39e8e4354ce4daf23336de5daa28a3b01f00aa6 upstream.

The TX_FIFO register is 10 bits wide.  The lower 8 bits are the data to be
written, while the upper two bits are flags to indicate stop/start.

The driver apparently attempted to optimize write access, by only writing a
byte in those cases where the stop/start bits are zero.  However, we have
seen cases where the lower byte is duplicated onto the upper byte by the
hardware, which causes inadvertent stop/starts.

This patch changes the write access to the transmit FIFO to always be 16 bits
wide.

Signed off by: Steven A. Falco <sfalco@harris.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/i2c/busses/i2c-xiic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -311,10 +311,8 @@ static void xiic_fill_tx_fifo(struct xii
 			/* last message in transfer -> STOP */
 			data |= XIIC_TX_DYN_STOP_MASK;
 			dev_dbg(i2c->adap.dev.parent, "%s TX STOP\n", __func__);
-
-			xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
-		} else
-			xiic_setreg8(i2c, XIIC_DTR_REG_OFFSET, data);
+		}
+		xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
 	}
 }
 

