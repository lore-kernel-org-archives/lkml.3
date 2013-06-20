Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965299Ab3FTKUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:20:46 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:42976 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964966Ab3FTKUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:20:43 -0400
Message-ID: <51C2D773.7010402@atmel.com>
Date: Thu, 20 Jun 2013 12:20:35 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: boris brezillon <b.brezillon@overkiz.com>
CC: Ludovic Desroches <ludovic.desroches@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 4/8] tty: atmel_serial: prepare clk before calling enable
References: <1371640263-9268-1-git-send-email-b.brezillon@overkiz.com> <1371640650-9625-1-git-send-email-b.brezillon@overkiz.com> <51C2B3D1.9060601@atmel.com> <51C2B814.4050308@overkiz.com>
In-Reply-To: <51C2B814.4050308@overkiz.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/06/2013 10:06, boris brezillon :
> On 20/06/2013 09:48, Nicolas Ferre wrote:
>> On 19/06/2013 13:17, Boris BREZILLON :
>>> Replace clk_enable/disable with clk_prepare_enable/disable_unprepare to
>>> avoid common clk framework warnings.
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>
>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>
>> (one comment though)
>>
>>> ---
>>>   drivers/tty/serial/atmel_serial.c |   41
>>> ++++++++++++++++++++++++++++---------
>>>   1 file changed, 31 insertions(+), 10 deletions(-)
>>>
>>> diff --git a/drivers/tty/serial/atmel_serial.c
>>> b/drivers/tty/serial/atmel_serial.c
>>> index 3467462..691265f 100644
>>> --- a/drivers/tty/serial/atmel_serial.c
>>> +++ b/drivers/tty/serial/atmel_serial.c
>>> @@ -1100,7 +1100,7 @@ static void atmel_serial_pm(struct uart_port
>>> *port, unsigned int state,
>>>            * Enable the peripheral clock for this serial port.
>>>            * This is called on uart_open() or a resume event.
>>>            */
>>> -        clk_enable(atmel_port->clk);
>>> +        clk_prepare_enable(atmel_port->clk);
>>
>> Do we need to check return code here?
> We could, but the pm function will not reflect the failure (void return).
> In addition, the clk_prepare_enable should not fail because it already
> succeed in the probe
> function (no memory allocation, simple bit masking in clk-peripheral
> implem).
>
> I can add it add this check (and avoid the interrrupt activation if it
> fails) if you want.

No, it seems okay like that. Thanks for the precision.

Bye,

>
>>
>>>
>>>           /* re-enable interrupts if we disabled some on suspend */
>>>           UART_PUT_IER(port, atmel_port->backup_imr);
>>> @@ -1114,7 +1114,7 @@ static void atmel_serial_pm(struct uart_port
>>> *port, unsigned int state,
>>>            * Disable the peripheral clock for this serial port.
>>>            * This is called on uart_close() or a suspend event.
>>>            */
>>> -        clk_disable(atmel_port->clk);
>>> +        clk_disable_unprepare(atmel_port->clk);
>>>           break;
>>>       default:
>>>           printk(KERN_ERR "atmel_serial: unknown pm %d\n", state);
>>> @@ -1458,9 +1458,10 @@ static void atmel_of_init_port(struct
>>> atmel_uart_port *atmel_port,
>>>   /*
>>>    * Configure the port from the platform device resource info.
>>>    */
>>> -static void atmel_init_port(struct atmel_uart_port *atmel_port,
>>> +static int atmel_init_port(struct atmel_uart_port *atmel_port,
>>>                         struct platform_device *pdev)
>>>   {
>>> +    int ret;
>>>       struct uart_port *port = &atmel_port->uart;
>>>       struct atmel_uart_data *pdata = pdev->dev.platform_data;
>>>
>>> @@ -1496,9 +1497,19 @@ static void atmel_init_port(struct
>>> atmel_uart_port *atmel_port,
>>>       /* for console, the clock could already be configured */
>>>       if (!atmel_port->clk) {
>>>           atmel_port->clk = clk_get(&pdev->dev, "usart");
>>> -        clk_enable(atmel_port->clk);
>>> +        if (IS_ERR(atmel_port->clk)) {
>>> +            ret = PTR_ERR(atmel_port->clk);
>>> +            atmel_port->clk = NULL;
>>> +            return ret;
>>> +        }
>>> +        ret = clk_prepare_enable(atmel_port->clk);
>>> +        if (ret) {
>>> +            clk_put(atmel_port->clk);
>>> +            atmel_port->clk = NULL;
>>> +            return ret;
>>> +        }
>>>           port->uartclk = clk_get_rate(atmel_port->clk);
>>> -        clk_disable(atmel_port->clk);
>>> +        clk_disable_unprepare(atmel_port->clk);
>>>           /* only enable clock when USART is in use */
>>>       }
>>>
>>> @@ -1511,6 +1522,8 @@ static void atmel_init_port(struct
>>> atmel_uart_port *atmel_port,
>>>       } else {
>>>           atmel_port->tx_done_mask = ATMEL_US_TXRDY;
>>>       }
>>> +
>>> +    return 0;
>>>   }
>>>
>>>   struct platform_device *atmel_default_console_device;    /* the
>>> serial console device */
>>> @@ -1601,6 +1614,7 @@ static void __init
>>> atmel_console_get_options(struct uart_port *port, int *baud,
>>>
>>>   static int __init atmel_console_setup(struct console *co, char
>>> *options)
>>>   {
>>> +    int ret;
>>>       struct uart_port *port = &atmel_ports[co->index].uart;
>>>       int baud = 115200;
>>>       int bits = 8;
>>> @@ -1612,7 +1626,9 @@ static int __init atmel_console_setup(struct
>>> console *co, char *options)
>>>           return -ENODEV;
>>>       }
>>>
>>> -    clk_enable(atmel_ports[co->index].clk);
>>> +    ret = clk_prepare_enable(atmel_ports[co->index].clk);
>>> +    if (ret)
>>> +        return ret;
>>>
>>>       UART_PUT_IDR(port, -1);
>>>       UART_PUT_CR(port, ATMEL_US_RSTSTA | ATMEL_US_RSTRX);
>>> @@ -1645,6 +1661,7 @@ static struct console atmel_console = {
>>>    */
>>>   static int __init atmel_console_init(void)
>>>   {
>>> +    int ret;
>>>       if (atmel_default_console_device) {
>>>           struct atmel_uart_data *pdata =
>>> atmel_default_console_device->dev.platform_data;
>>> @@ -1655,7 +1672,9 @@ static int __init atmel_console_init(void)
>>>           port->uart.line = id;
>>>
>>>           add_preferred_console(ATMEL_DEVICENAME, id, NULL);
>>> -        atmel_init_port(port, atmel_default_console_device);
>>> +        ret = atmel_init_port(port, atmel_default_console_device);
>>> +        if (ret)
>>> +            return ret;
>>>           register_console(&atmel_console);
>>>       }
>>>
>>> @@ -1786,7 +1805,9 @@ static int atmel_serial_probe(struct
>>> platform_device *pdev)
>>>       port->backup_imr = 0;
>>>       port->uart.line = ret;
>>>
>>> -    atmel_init_port(port, pdev);
>>> +    ret = atmel_init_port(port, pdev);
>>> +    if (ret)
>>> +        goto err;
>>>
>>>       pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
>>>       if (IS_ERR(pinctrl)) {
>>> @@ -1812,9 +1833,9 @@ static int atmel_serial_probe(struct
>>> platform_device *pdev)
>>>               && ATMEL_CONSOLE_DEVICE->flags & CON_ENABLED) {
>>>           /*
>>>            * The serial core enabled the clock for us, so undo
>>> -         * the clk_enable() in atmel_console_setup()
>>> +         * the clk_prepare_enable() in atmel_console_setup()
>>>            */
>>> -        clk_disable(port->clk);
>>> +        clk_disable_unprepare(port->clk);
>>>       }
>>>   #endif
>>>
>>>
>>
>>
>
>
>


-- 
Nicolas Ferre
