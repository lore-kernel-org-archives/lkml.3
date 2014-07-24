Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217AbaGXMD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 08:03:58 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:34630 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaGXMDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 08:03:54 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kernel@stlinux.com, maxime.coquelin@st.com
Subject: [PATCH 2/2] serial: st-asc: Fix overflow in baudrate calculation
Date: Thu, 24 Jul 2014 14:02:56 +0200
Message-Id: <1406203376-18203-3-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406203376-18203-1-git-send-email-maxime.coquelin@st.com>
References: <1406203376-18203-1-git-send-email-maxime.coquelin@st.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-24_03:2014-07-24,2014-07-24,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the current calculation, if the required baud rate is above 262143,
we get an overflow.

This patch uses a 64bits variable to do the maths.
Also, we remove the '+1' to avoid a divide by zero if the input clock
rate is something unexpected.
Indeed, if the input clock rate is zero, it is preferable to be notified,
since the UART won't work anyway.

Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/tty/serial/st-asc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index 2369bc0..7ac9902 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -533,12 +533,12 @@ static void asc_set_termios(struct uart_port *port, struct ktermios *termios,
 		 * ASCBaudRate =   ------------------------
 		 *                          inputclock
 		 *
-		 * However to keep the maths inside 32bits we divide top and
-		 * bottom by 64. The +1 is to avoid a divide by zero if the
-		 * input clock rate is something unexpected.
+		 * To keep maths inside 64bits, we divide inputclock by 16.
 		 */
-		u32 counter = (baud * 16384) / ((port->uartclk / 64) + 1);
-		asc_out(port, ASC_BAUDRATE, counter);
+		u64 dividend = (u64)baud * (1 << 16);
+
+		do_div(dividend, port->uartclk / 16);
+		asc_out(port, ASC_BAUDRATE, dividend);
 		ctrl_val |= ASC_CTL_BAUDMODE;
 	}
 
-- 
1.9.1

