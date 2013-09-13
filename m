Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3IMQ2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:28:53 -0400
Received: from briaree.onecert.fr ([134.212.190.4]:37980 "EHLO
	briaree.onecert.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab3IMQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:28:52 -0400
Message-ID: <52333BAF.1070409@onera.fr>
Date: Fri, 13 Sep 2013 18:22:07 +0200
From: Paul Chavent <Paul.Chavent@onera.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: linux-usb@vger.kernel.org, gregkh@linuxfoundation.org,
        fschaefer.oss@googlemail.com, jslaby@suse.cz, max@suse.de,
        giometti@enneenne.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] USB : serial : pl2303 wake up after dcd status check.
References: <1379086513-2434-1-git-send-email-paul.chavent@onera.fr> <1379086513-2434-4-git-send-email-paul.chavent@onera.fr> <20130913162356.GC9054@localhost>
In-Reply-To: <20130913162356.GC9054@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (briaree.onecert.fr [134.212.190.4]); Fri, 13 Sep 2013 18:28:15 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

This patch was just a suggestion. Don't bother with rebasing. I will 
wait your changes and remove this patch from the next submission.

Cheers.
Paul.


On 09/13/2013 06:23 PM, Johan Hovold wrote:
> On Fri, Sep 13, 2013 at 05:35:13PM +0200, Paul Chavent wrote:
>> Seems to be done this way in other drivers (ch341, 8250, ...).
>> And get tty reference only if dcd_change need to be called.
>
> This is fine. I have a patch here doing the same two changes as part of
> a larger clean-up of the pl2303 interrupt handling (which in turn is
> part of the MSR-refactoring I mentioned). I could rebase on top of this,
> unless you care to wait another week. :)
>
> Thanks,
> Johan
>
>> Signed-off-by: Paul Chavent <paul.chavent@onera.fr>
>> ---
>>   drivers/usb/serial/pl2303.c | 17 +++++++++--------
>>   1 file changed, 9 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
>> index e7a84f0..8b81188 100644
>> --- a/drivers/usb/serial/pl2303.c
>> +++ b/drivers/usb/serial/pl2303.c
>> @@ -854,15 +854,16 @@ static void pl2303_update_line_status(struct usb_serial_port *port,
>>   	spin_unlock_irqrestore(&priv->lock, flags);
>>   	if (priv->line_status & UART_BREAK_ERROR)
>>   		usb_serial_handle_break(port);
>> -	wake_up_interruptible(&port->port.delta_msr_wait);
>>
>> -	tty = tty_port_tty_get(&port->port);
>> -	if (!tty)
>> -		return;
>> -	if ((priv->line_status ^ prev_line_status) & UART_DCD)
>> -		usb_serial_handle_dcd_change(port, tty,
>> -				priv->line_status & UART_DCD);
>> -	tty_kref_put(tty);
>> +	if ((priv->line_status ^ prev_line_status) & UART_DCD) {
>> +		tty = tty_port_tty_get(&port->port);
>> +		if (tty)
>> +			usb_serial_handle_dcd_change(port, tty,
>> +					priv->line_status & UART_DCD);
>> +		tty_kref_put(tty);
>> +	}
>> +
>> +	wake_up_interruptible(&port->port.delta_msr_wait);
>>   }
>>
>>   static void pl2303_read_int_callback(struct urb *urb)
>> --
>> 1.7.12.1
>>
>
