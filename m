Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756888Ab3ERCRG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:17:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:5776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756741Ab3ERCQ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:56 -0400
X-Authority-Analysis: v=2.0 cv=L+efspv8 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=RyKqO31HBm4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=GSvjnvO4tCQA:10 a=dbnN3sn1AAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=8iBnM_xsAzAA:10 a=Ku4giSwJSw0A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021647.381955222@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, <stable@kernel.org>
Subject: [ 035/136 ] i2c: xiic: must always write 16-bit words to TX_FIFO
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0035-i2c-xiic-must-always-write-16-bit-words-to-TX_FIFO.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Steven A. Falco" <sfalco@harris.com>

[ Upstream commit c39e8e4354ce4daf23336de5daa28a3b01f00aa6 ]

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
Cc: stable@kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/i2c/busses/i2c-xiic.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 641d0e5..15d20de 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -312,10 +312,8 @@ static void xiic_fill_tx_fifo(struct xiic_i2c *i2c)
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
 
-- 
1.7.10.4


