Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbaIKOfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:35:52 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43982 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753143AbaIKOfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:35:50 -0400
Message-ID: <5411B33F.10405@hurleysoftware.com>
Date: Thu, 11 Sep 2014 10:35:43 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, balbi@ti.com, gregkh@linuxfoundation.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 09/16] tty: serial: 8250_dma: Add a TX trigger workaround
 for AM33xx
References: <1410377411-26656-1-git-send-email-bigeasy@linutronix.de> <1410377411-26656-10-git-send-email-bigeasy@linutronix.de> <20140911111721.GB17476@xps8300> <54118AAB.2010205@linutronix.de> <5411967A.6090406@hurleysoftware.com> <54119AAA.9080907@linutronix.de>
In-Reply-To: <54119AAA.9080907@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 08:50 AM, Sebastian Andrzej Siewior wrote:
> On 09/11/2014 02:32 PM, Peter Hurley wrote:
>> On 09/11/2014 07:42 AM, Sebastian Andrzej Siewior wrote:
>>> I also need a watchdog timer for TX since it seems that on omap3 the
>>> DMA engine suddenly forgets to continue with DMA…
>>
>> One difference I noticed between the omap driver and the 8250 driver is
>> the way modem status interrupts are handled.
>>
>> The omap driver only checks modem status for the UART_IIR_MSI interrupt type.
>> The 8250 driver checks modem status at every interrupt (other than NO_INT).
>>
>> I think the UART_MSR_DCTS bit always reflects that the CTS input has changed
>> between reads of the MSR _even if auto CTS is on_. So perhaps the hardware
>> is being stopped by uart_handle_cts_change() when auto CTS is on?
> 
> I doubt that. What I see from a timer debug is that the TX-FIFO level
> is at 0, the DMA transfer for say 1024 bytes start.
> The FIFO is filled to 64bytes and refilled so it doesn't drop below 50.
> At the time of the stall I see that the DMA engine has outstanding
> bytes which it should transfer and the TX FIFO is empty. If hardware
> flow control stops the transfer, I would expect that the DMA engine
> still fills the TX-FIFO until 64 and then waits. But it doesn't.
> Writing bytes into the FIFO leads to bytes beeing sent (and I see them
> on the other side) but the DMA transfer is still on hold. Canceling the
> DMA transfer and re-programming the remaining bytes transfers the
> remaining bytes.
> 
> The odd thing is that I only triggered it with "less file". It doesn't
> happen on regular console interaction or "cat large-file". And it only
> triggers on beagle board xm (omap34xx) and I wasn't able to reproduce
> it on am335x or dra7. The latter shares the same DMA engine as beagle
> board xm.
> 
> I remember also that I disabled the HW/SW float control just to make
> sure it is not it.

Ok.

I do need to find out if omap hardware sets UART_MSR_DCTS when auto CTS
is on. Would you mind running the debug patch below with HW flow control on?

Regards,
Peter Hurley

--- >% ---
Subject: [DEBUG] serial: does OMAP set UART_LSR_DCTS while autoCTS is on?

** debug patch only **

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/serial_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 5a78f69..1579a20 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -2783,6 +2783,9 @@ void uart_handle_cts_change(struct uart_port *uport, unsigned int status)
 	uport->icount.cts++;
 
 	if (tty_port_cts_enabled(port)) {
+
+		WARN_ON_ONCE(uport->flags & UPF_HARD_FLOW);
+
 		if (tty->hw_stopped) {
 			if (status) {
 				tty->hw_stopped = 0;
-- 
2.1.0

