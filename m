Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918Ab3CYG3x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:29:53 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37711 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab3CYG3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:29:51 -0400
Message-ID: <514FEECD.30500@ti.com>
Date: Mon, 25 Mar 2013 11:59:33 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kevin Hilman <khilman@linaro.org>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Rajendra nayak <rnayak@ti.com>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH/Resend 2/2] arm: mach-omap2: prevent UART console idle
 on suspend while using "no_console_suspend"
References: <1363612924-349-1-git-send-email-sourav.poddar@ti.com> <87fvzsilnv.fsf@linaro.org> <5149A221.5@ti.com> <5149A63C.4000102@ti.com>
In-Reply-To: <5149A63C.4000102@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,
On Wednesday 20 March 2013 05:36 PM, Sourav Poddar wrote:
> Realised the list  to whom the patch was send got dropped. Ccing them 
> all..
> On Wednesday 20 March 2013 05:18 PM, Sourav Poddar wrote:
>> Hi Kevin,
>> On Tuesday 19 March 2013 12:24 AM, Kevin Hilman wrote:
>>> Sourav Poddar<sourav.poddar@ti.com>  writes:
>>>
>>>> With dt boot, uart wakeup after suspend is non functional on 
>>>> omap4/5 while using
>>>> "no_console_suspend" in the bootargs. With "no_console_suspend" 
>>>> used, od->flags
>>>> should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not 
>>>> allowing the console
>>>> to idle in the suspend path. For non-dt case, this was taken care 
>>>> by platform data.
>>>>
>>>> Tested on omap5430evm, omap4430sdp.
>>>>
>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>> This patch creates a dependency between omap_device (generic,
>>> device-independent code) and a specific driver (UART.)
>>>
>>> If you need to do something like this that's DT boot specific, then
>>> we probably need some late initcall in serial.c to handle this.  It 
>>> does
>>> not belong in omap_device.
>>>
>> The following function "omap_device_disable_idle_on_suspend(pdev)" 
>> should only
>> be called once the omap device has been build, which in the case of 
>> device tree is
>> done in omap_device.c file. Moreover, the above call should be 
>> executed conditionally
>> and should depend on the following two parameter.
>>
>> [1]  a. Whether "no_console_suspend" is set and
>>      b.  the device build is a console uart.
>>
>> When I look closely into the serial.c file, I realised that
>> "core_initcall(omap_serial_early_init)" gets called irrespective
>> of dt/non dt boot and will take care of most of the stuff(checking 
>> whether
>> "no_console_suspend" is used and which uart is used as a console 
>> uart) which the
>> $subject patch is proposing.
>>
>> But the problem is that we need to exchange the parsed information
>> from serial.c to the omap_device file for the condtional execution of
>> "omap_device_disable_idle_on_suspend"
>>
>> In this case,
>> from "serial.c" we need
>>     1. no_console_suspend = true
>>     2. strcpy(console_name, oh_name), where oh_name corresponds to 
>> the console uart.
>>
>> then in "omap_device.c" do
>>     if (no_console_suspend && !strcmp(oh->name, console_name))
>>                 omap_device_disable_idle_on_suspend(pdev);
>>
>> Please correct if I am understanding it incorrectly.
>>
>> If the above understanding looks good to you, is there a way we can 
>> make this
>> exchange of information happen between serial.c and omap_device.c file?
Any Input on this?

Thanks,
Sourav
>>> Kevin
>>>
>>>> ---
>>>>   arch/arm/mach-omap2/omap_device.c |   34 
>>>> +++++++++++++++++++++++++++++++++-
>>>>   1 files changed, 33 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/arch/arm/mach-omap2/omap_device.c 
>>>> b/arch/arm/mach-omap2/omap_device.c
>>>> index 381be7a..71f5a73 100644
>>>> --- a/arch/arm/mach-omap2/omap_device.c
>>>> +++ b/arch/arm/mach-omap2/omap_device.c
>>>> @@ -35,11 +35,17 @@
>>>>   #include<linux/pm_runtime.h>
>>>>   #include<linux/of.h>
>>>>   #include<linux/notifier.h>
>>>> +#include<linux/platform_data/serial-omap.h>
>>>>
>>>>   #include "soc.h"
>>>>   #include "omap_device.h"
>>>>   #include "omap_hwmod.h"
>>>>
>>>> +#define MAX_UART_HWMOD_NAME_LEN         16
>>>> +
>>>> +static u8 no_console_suspend;
>>>> +static u8 console_uart_num;
>>>> +
>>>>   /* Private functions */
>>>>
>>>>   static void _add_clkdev(struct omap_device *od, const char 
>>>> *clk_alias,
>>>> @@ -108,6 +114,12 @@ static void _add_hwmod_clocks_clkdev(struct 
>>>> omap_device *od,
>>>>           _add_clkdev(od, oh->opt_clks[i].role, oh->opt_clks[i].clk);
>>>>   }
>>>>
>>>> +static char *cmdline_find_option(char *str)
>>>> +{
>>>> +    extern char *saved_command_line;
>>>> +
>>>> +    return strstr(saved_command_line, str);
>>>> +}
>>>>
>>>>   /**
>>>>    * omap_device_build_from_dt - build an omap_device with multiple 
>>>> hwmods
>>>> @@ -129,6 +141,7 @@ static int omap_device_build_from_dt(struct 
>>>> platform_device *pdev)
>>>>       struct device_node *node = pdev->dev.of_node;
>>>>       const char *oh_name;
>>>>       int oh_cnt, i, ret = 0;
>>>> +    static u8 console_uart_id;
>>>>
>>>>       oh_cnt = of_property_count_strings(node, "ti,hwmods");
>>>>       if (!oh_cnt || IS_ERR_VALUE(oh_cnt)) {
>>>> @@ -170,7 +183,12 @@ static int omap_device_build_from_dt(struct 
>>>> platform_device *pdev)
>>>>               r->name = dev_name(&pdev->dev);
>>>>       }
>>>>
>>>> -    if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
>>>> +    if (no_console_suspend&&  !strncmp(oh->name, "uart", 4)) {
>>>> +        if (console_uart_num == console_uart_id)
>>>> +            omap_device_disable_idle_on_suspend(pdev);
>>>> +        else
>>>> +            console_uart_id++;
>>>> +    } else if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
>>>>           omap_device_disable_idle_on_suspend(pdev);
>>>>
>>>>       pdev->dev.pm_domain =&omap_device_pm_domain;
>>>> @@ -838,7 +856,21 @@ static struct notifier_block platform_nb = {
>>>>
>>>>   static int __init omap_device_init(void)
>>>>   {
>>>> +    int i;
>>>> +    char uart_name[MAX_UART_HWMOD_NAME_LEN];
>>>> +
>>>>       bus_register_notifier(&platform_bus_type,&platform_nb);
>>>> +
>>>> +    if (cmdline_find_option("no_console_suspend")) {
>>>> +        no_console_suspend = true;
>>>> +        for (i = 0; i<  OMAP_MAX_HSUART_PORTS; i++) {
>>>> +            snprintf(uart_name, MAX_UART_HWMOD_NAME_LEN,
>>>> +                "%s%d", OMAP_SERIAL_NAME, i);
>>>> +            if (cmdline_find_option(uart_name))
>>>> +                console_uart_num = i;
>>>> +        }
>>>> +    }
>>>> +
>>>>       return 0;
>>>>   }
>>>>   omap_core_initcall(omap_device_init);
>>
>

