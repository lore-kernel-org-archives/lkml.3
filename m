Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab3H0OcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:32:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:52335 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab3H0OcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAGa+x866vUhX-uctWfZpw42hW7bRTG92Qz=4j=gWL-vgpdryDg@mail.gmail.com>
References: <1373277884-3006-1-git-send-email-oleksandr.savchenko@ti.com>
	<CAGa+x866vUhX-uctWfZpw42hW7bRTG92Qz=4j=gWL-vgpdryDg@mail.gmail.com>
Date: Tue, 27 Aug 2013 07:32:17 -0700
Message-ID: <CAGa+x841NUxPYgixzGgU0Y87BJCDDSAZC+-WAQ46T8_hDT385A@mail.gmail.com>
Subject: Re: [PATCH] OMAP: UART: Keep the TX fifo full when possible
From: Kevin Hilman <khilman@linaro.org>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, matts@commtech-fastcom.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        David Howells <dhowells@redhat.com>, linux-serial@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

On Tue, Aug 20, 2013 at 8:57 AM, Kevin Hilman <khilman@linaro.org> wrote:
> + Felipe
>
> On Mon, Jul 8, 2013 at 3:04 AM, Alexander Savchenko
> <oleksandr.savchenko@ti.com> wrote:
>> From: Dmitry Fink <finik@ti.com>
>>
>> Current logic results in interrupt storm since the fifo
>> is constantly below the threshold level. Change the logic
>> to fill all the available spaces in the fifo as long as
>> we have data to minimize the possibilty of underflow and
>> elimiate excessive interrupts.
>>
>> Signed-off-by: Dmitry Fink <finik@ti.com>
>> Signed-off-by: Alexander Savchenko <oleksandr.savchenko@ti.com>
>
> Hmm, another OMAP serial patch that wasn't Cc'd to linux-omap where
> OMAP users might have seen it. :(
>
> I just bisected a strange problem in linux-next on OMAP3 down to this
> patch.  Reverting it fixes the problem.
>
> On OMAP3530 Beagle and Overo, after boot, doing a 'cat /proc/cpuinfo'
> was not returning to a prompt, suggesting something strange with the
> FIFO.  Hitting return gets me back to a prompt.
>
> Greg, this one should also be dropped from tty-next until it can be
> further investgated and the problem solved.

Can this one be dropped from tty-next too until it can be
investigated.  The author's ti.com addresses are bouncing, and this
has introduced a regression in -next.

Kevin

>> ---
>>  drivers/tty/serial/omap-serial.c |    3 ++-
>>  include/uapi/linux/serial_reg.h  |    1 +
>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index b6d1728..5c9b074 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -310,7 +310,8 @@ static void transmit_chars(struct uart_omap_port *up, unsigned int lsr)
>>                 serial_omap_stop_tx(&up->port);
>>                 return;
>>         }
>> -       count = up->port.fifosize / 4;
>> +       count = up->port.fifosize -
>> +               (serial_in(up, UART_OMAP_TXFIFO_LVL) & 0xFF);
>>         do {
>>                 serial_out(up, UART_TX, xmit->buf[xmit->tail]);
>>                 xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
>> diff --git a/include/uapi/linux/serial_reg.h b/include/uapi/linux/serial_reg.h
>> index e632260..97c26be 100644
>> --- a/include/uapi/linux/serial_reg.h
>> +++ b/include/uapi/linux/serial_reg.h
>> @@ -366,6 +366,7 @@
>>  #define UART_OMAP_MDR1_FIR_MODE                0x05    /* FIR mode */
>>  #define UART_OMAP_MDR1_CIR_MODE                0x06    /* CIR mode */
>>  #define UART_OMAP_MDR1_DISABLE         0x07    /* Disable (default state) */
>> +#define UART_OMAP_TXFIFO_LVL           0x1A    /* TX FIFO fullness */
>>
>>  /*
>>   * These are definitions for the Exar XR17V35X and XR17(C|D)15X
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
