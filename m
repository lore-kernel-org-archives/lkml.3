Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab3DZSk1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:40:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34153 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987Ab3DZSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:40:24 -0400
Message-ID: <517AC9FF.1030504@ti.com>
Date: Sat, 27 Apr 2013 00:09:59 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCHv4 2/5] driver: serial: omap: prevent runtime PM for "no_console_suspend"
References: <1366980168-30566-1-git-send-email-sourav.poddar@ti.com>	<1366980168-30566-3-git-send-email-sourav.poddar@ti.com> <87mwslw3h1.fsf@linaro.org>
In-Reply-To: <87mwslw3h1.fsf@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Friday 26 April 2013 11:58 PM, Kevin Hilman wrote:
> Sourav Poddar<sourav.poddar@ti.com>  writes:
>
>> The driver manages "no_console_suspend" by preventing runtime PM
>> during the suspend path, which forces the console UART to stay awake.
>>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> Reviewed-by: Felipe Balbi<balbi@ti.com>
>> ---
>>   drivers/tty/serial/omap-serial.c |   28 +++++++++++++++++++++++++++-
>>   1 files changed, 27 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>> index 30d4f7a..eddff3c 100644
>> --- a/drivers/tty/serial/omap-serial.c
>> +++ b/drivers/tty/serial/omap-serial.c
>> @@ -161,6 +161,7 @@ struct uart_omap_port {
>>   	u32			calc_latency;
>>   	struct work_struct	qos_work;
>>   	struct pinctrl		*pins;
>> +	bool			is_suspending;
>>   };
>>
>>   #define to_uart_omap_port(p)	((container_of((p), struct uart_omap_port, port)))
>> @@ -1312,6 +1313,22 @@ static struct uart_driver serial_omap_reg = {
>>   };
>>
>>   #ifdef CONFIG_PM_SLEEP
>> +static int serial_omap_prepare(struct device *dev)
>> +{
>> +	struct uart_omap_port *up = dev_get_drvdata(dev);
>> +
>> +	up->is_suspending = true;
>> +
>> +	return 0;
>> +}
>> +
>> +static void serial_omap_complete(struct device *dev)
>> +{
>> +	struct uart_omap_port *up = dev_get_drvdata(dev);
>> +
>> +	up->is_suspending = false;
>> +}
>> +
>>   static int serial_omap_suspend(struct device *dev)
>>   {
>>   	struct uart_omap_port *up = dev_get_drvdata(dev);
>> @@ -1330,7 +1347,10 @@ static int serial_omap_resume(struct device *dev)
>>
>>   	return 0;
>>   }
>> -#endif
>> +#else
>> +#define serial_omap_prepare NULL
>> +#define serial_omap_prepare NULL
>> +#endif /* CONFIG_PM_SLEEP */
>>
>>   static void omap_serial_fill_features_erratas(struct uart_omap_port *up)
>>   {
>> @@ -1616,6 +1636,10 @@ static int serial_omap_runtime_suspend(struct device *dev)
>>   	struct uart_omap_port *up = dev_get_drvdata(dev);
>>   	struct omap_uart_port_info *pdata = dev->platform_data;
>>
> I'd like to see a comment here about why we return error.  It's written
> in the changelog, but it deserves a comment here as well.  Something like:
>
> When using 'no_console_suspend', the console UART must not be suspended.
> Since driver suspend is managed by runtime suspend, preventing runtime
> suspend (by returning error) will keep device active during suspend.
>
>
Ok. Will add this.
>> +	if (up->is_suspending&&  !console_suspend_enabled
>> +			&&  uart_console(&up->port))
> nit: can you put the '&&' at the end of the first line, and have the
> 2nd line line up with the start of the first line?
>
Ok. Will modify this part.
> See other examples of similiar multi-line checks elsewhere in the
> driver.
>
> Other than those minor things, this patch is good.
>
> Then, can you repost and break this into 2 series since they can go
> independently.
>
> Patches 1-2 need to go through the serial tree (Greg), and I will queue
> up the OMAP specific changes once Greg has queued the serial core changes.
>
Yes, sounds good. Will break it in the next version into two series.
> Kevin

