Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbaJQKZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 06:25:43 -0400
Received: from mail-ob0-f177.google.com ([209.85.214.177]:51897 "EHLO
	mail-ob0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaJQKZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 06:25:42 -0400
MIME-Version: 1.0
In-Reply-To: <543FBB97.9010006@hurleysoftware.com>
References: <54369F77.5000906@hurleysoftware.com>
	<1413355395-5871-1-git-send-email-ssreedharan@mvista.com>
	<543FBB97.9010006@hurleysoftware.com>
Date: Fri, 17 Oct 2014 15:55:41 +0530
Message-ID: <CAJJ77WsAi5jmnDxY45ipu3a94D6+yoHJNHgExhFsVoirV3NoyQ@mail.gmail.com>
Subject: Re: [PATCH] tty: serial: 8250_core: restore the LCR register in set_sleep
From: Sudhir Sreedharan <ssreedharan@mvista.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kevin Hilman <khilman@kernel.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Thu, Oct 16, 2014 at 6:05 PM, Peter Hurley <peter@hurleysoftware.com> wrote:
> On 10/15/2014 02:43 AM, Sudhir Sreedharan wrote:
>> In ST16650V2 based serial uarts, while initalizing the PM state,
>> LCR registers are being initialized to 0 in serial8250_set_sleep().
>> If console port is already initialized and being used, this will
>> throws garbage in the console.
>>
>> Signed-off-by: Sudhir Sreedharan <ssreedharan@mvista.com>
>> ---
>>  drivers/tty/serial/8250/8250_core.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
>> index ca5cfdc..e054482 100644
>> --- a/drivers/tty/serial/8250/8250_core.c
>> +++ b/drivers/tty/serial/8250/8250_core.c
>> @@ -595,6 +595,7 @@ static void serial8250_rpm_put_tx(struct uart_8250_port *p)
>>   */
>>  static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>>  {
>> +     unsigned char lcr, efr;
>>       /*
>>        * Exar UARTs have a SLEEP register that enables or disables
>>        * each UART to enter sleep mode separately.  On the XR17V35x the
>> @@ -611,6 +612,8 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>>
>>       if (p->capabilities & UART_CAP_SLEEP) {
>>               if (p->capabilities & UART_CAP_EFR) {
>> +                     lcr = serial_in(p, UART_LCR);
>> +                     efr = serial_in(p, UART_EFR);
>>                       serial_out(p, UART_LCR, UART_LCR_CONF_MODE_B);
>>                       serial_out(p, UART_EFR, UART_EFR_ECB);
>>                       serial_out(p, UART_LCR, 0);
>> @@ -618,8 +621,8 @@ static void serial8250_set_sleep(struct uart_8250_port *p, int sleep)
>>               serial_out(p, UART_IER, sleep ? UART_IERX_SLEEP : 0);
>>               if (p->capabilities & UART_CAP_EFR) {
>>                       serial_out(p, UART_LCR, UART_LCR_CONF_MODE_B);
>> -                     serial_out(p, UART_EFR, 0);
>> -                     serial_out(p, UART_LCR, 0);
>> +                     serial_out(p, UART_EFR, sleep ? 0 : efr);
>> +                     serial_out(p, UART_LCR, sleep ? 0 : lcr);
>
> Why is it necessary to clear EFR and LCR here? Does the UART not
> power down?
>
> UARTs with CAP_SLEEP but not CAP_EFR don't clear LCR before sleep.
>
> However, if there is some kind of intentional side-effect here,
> then a comment should note that.

Yes, we can restore the LCR and EFR with the saved values.
                     serial_out(p, UART_EFR, efr);
                     serial_out(p, UART_LCR, lcr);

I will send a new patch with the changes.

Thanks,
Sudhir

>
> Regards,
> Peter Hurley
>
>>               }
>>       }
>>  out:
>>
>
