Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936646Ab3DRV4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 17:56:45 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:33209 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936362Ab3DRV4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 17:56:42 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] driver: serial: omap: add prepare/complete callback for "no_console_suspend" case
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
	<1366198467-6757-4-git-send-email-sourav.poddar@ti.com>
	<874nf367th.fsf@linaro.org> <5170375F.2020603@ti.com>
Date: Thu, 18 Apr 2013 14:56:38 -0700
In-Reply-To: <5170375F.2020603@ti.com> (Sourav Poddar's message of "Thu, 18
	Apr 2013 23:41:43 +0530")
Message-ID: <87sj2n1p0p.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> Hi Kevin,
> On Thursday 18 April 2013 11:26 PM, Kevin Hilman wrote:
>> Sourav Poddar<sourav.poddar@ti.com>  writes:
>>
>>> The patch adapt the serial core/driver to take care of the case when "no_console_suspend"
>>> is used in the bootargs. The patch will remove dependency to set od->flags to
>>> "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" in serial.c(non dt case) and omap_device.c(dt case).
>>>
>>> Prepare and complete callbacks will ensure that clocks remain active for the console
>>> uart when "no_console_suspend" is used in the bootargs.
>>>
>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> This changelog needs a rework.  The driver itself was not aware of
>> od->flags and omap_device stuff in general, so it's not really
>> relevant.  The driver is also not directly managing clocks, int's only
>> doing runtime PM callbacks.
>>
>> What you want to say in the changelog is that the driver manages
>> "no_console_suspend" by preventing runtime PM during the suspend path,
>> which forces the console UART to stay awake.
>>
> Yes, looks to the point. Will update the changelog in the next version.
>>> ---
>>>   drivers/tty/serial/omap-serial.c |   20 ++++++++++++++++++++
>>>   1 files changed, 20 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/tty/serial/omap-serial.c b/drivers/tty/serial/omap-serial.c
>>> index 08332f3..9ef80cf 100644
>>> --- a/drivers/tty/serial/omap-serial.c
>>> +++ b/drivers/tty/serial/omap-serial.c
>>> @@ -1278,6 +1278,24 @@ static struct uart_driver serial_omap_reg = {
>>>   };
>>>
>>>   #ifdef CONFIG_PM_SLEEP
>>> +static int serial_omap_prepare(struct device *dev)
>>> +{
>>> +	struct uart_omap_port *up = dev_get_drvdata(dev);
>>> +
>>> +	if (!console_suspend_enabled&&  uart_console(&up->port))
>>> +		pm_runtime_disable(dev);
>>> +
>>> +	return 0;
>>> +}
>>> +
>>> +static void serial_omap_complete(struct device *dev)
>>> +{
>>> +	struct uart_omap_port *up = dev_get_drvdata(dev);
>>> +
>>> +	if (!console_suspend_enabled&&  uart_console(&up->port))
>>> +		pm_runtime_enable(dev);
>>> +}
>>> +
>> For compilation with !CONFIG_PM_SLEEP, you'll also need:
>>
>> #else
>> #define serial_omap_prepare NULL
>> #define serial_omap_prepare NULL
>> #endif /* CONFIG_PM_SLEEP */
>>
> Ok. Will change this.
> Though, just a query/proposal on this, will it be correct if we try to
> create a macro[1]
> in include/linux/pm.h for prepare/complete as it is done for
> suspend/resume. ?

Sure, you could do that, but personally I don't think it's as broadly
useful (otherwise, it would be there already.)

Kevin

> [1]:
> #ifdef CONFIG_PM_SLEEP
> #define SET_SYSTEM_SLEEP_PM_PREP_COMP_OPS(prepare_fn, complete_fn) \
>         .prepare = prepare_fn, \
>         .complete = complete_fn, \
> #else
> #define SET_SYSTEM_SLEEP_PM_PREP_COMP_OPS(prepare_fn, complete_fn)
> #endif
>
> ~Sourav
>>>   static int serial_omap_suspend(struct device *dev)
>>>   {
>>>   	struct uart_omap_port *up = dev_get_drvdata(dev);
>>> @@ -1632,6 +1650,8 @@ static const struct dev_pm_ops serial_omap_dev_pm_ops = {
>>>   	SET_SYSTEM_SLEEP_PM_OPS(serial_omap_suspend, serial_omap_resume)
>>>   	SET_RUNTIME_PM_OPS(serial_omap_runtime_suspend,
>>>   				serial_omap_runtime_resume, NULL)
>>> +	.prepare        = serial_omap_prepare,
>>> +	.complete       = serial_omap_complete,
>>>   };
>>>
>>>   #if defined(CONFIG_OF)
>> Kevin
