Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3EFXNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:13:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760407Ab3EFXNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:13:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [ 044/104] i2c: xiic: must always write 16-bit words to TX_FIFO
Date: Mon,  6 May 2013 16:12:03 -0700
Message-Id: <20130506230048.139088480@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-xiic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -312,10 +312,8 @@ static void xiic_fill_tx_fifo(struct xii
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
 


