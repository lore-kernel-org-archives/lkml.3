Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaHNCm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 22:42:27 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:50696 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbaHNCmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 22:42:24 -0400
Message-ID: <53EC220D.5050908@gmail.com>
Date: Wed, 13 Aug 2014 19:42:21 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: frowand.list@gmail.com
CC: Stephen Boyd <sboyd@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH to be tested] serial: msm_serial: add missing sysrq handling
References: <53E2C573.7090709@gmail.com> <53EAB01B.5030102@codeaurora.org> <53EC1FEA.5070907@gmail.com>
In-Reply-To: <53EC1FEA.5070907@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2014 7:33 PM, Frank Rowand wrote:
> On 8/12/2014 5:23 PM, Stephen Boyd wrote:
>> On 08/06/14 17:16, Frank Rowand wrote:

< snip >
 
> The patches you sent are a little hard to read since they modify further code
> that my patch modified.  So I have redone your patches, as if my patch was
> not previously applied.  Hopefully I did not make any mistakes there.  I will
> reply to this email with each of your redone patches.

Stephen's patch alternative number 2:

---
 drivers/tty/serial/msm_serial.c |   41 +++++++++++++++++++++++++++-------------
 1 file changed, 28 insertions(+), 13 deletions(-)

Index: b/drivers/tty/serial/msm_serial.c
===================================================================
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -125,25 +125,40 @@ static void handle_rx_dm(struct uart_por
 	port->icount.rx += count;
 
 	while (count > 0) {
-		unsigned int c;
+		unsigned char buf[4];
+		int sysrq, r_count, i;
 
 		sr = msm_read(port, UART_SR);
 		if ((sr & UART_SR_RX_READY) == 0) {
 			msm_port->old_snap_state -= count;
 			break;
 		}
-		c = msm_read(port, UARTDM_RF);
-		if (sr & UART_SR_RX_BREAK) {
-			port->icount.brk++;
-			if (uart_handle_break(port))
-				continue;
-		} else if (sr & UART_SR_PAR_FRAME_ERR)
-			port->icount.frame++;
-
-		/* TODO: handle sysrq */
-		tty_insert_flip_string(tport, (char *)&c,
-				       (count > 4) ? 4 : count);
-		count -= 4;
+		readsl(port->membase + UARTDM_RF, buf, 1);
+
+		r_count = min_t(int, count, sizeof(buf));
+
+		for (i = 0; i < r_count; i++) {
+			char flag = TTY_NORMAL;
+
+			if (sr & UART_SR_RX_BREAK) {
+				if (buf[i] == 0) {
+					port->icount.brk++;
+					flag = TTY_BREAK;
+					if (uart_handle_break(port))
+						continue;
+				}
+			}
+
+			if (!(port->read_status_mask & UART_SR_RX_BREAK))
+				flag = TTY_NORMAL;
+
+			spin_unlock(&port->lock);
+			sysrq = uart_handle_sysrq_char(port, buf[i]);
+			spin_lock(&port->lock);
+			if (!sysrq)
+				tty_insert_flip_char(tport, buf[i], flag);
+		}
+		count -= r_count;
 	}
 
 	spin_unlock(&port->lock);
