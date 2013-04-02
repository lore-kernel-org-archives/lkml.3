Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761474Ab3DBKG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 06:06:58 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:55918 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073Ab3DBKG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 06:06:56 -0400
Message-ID: <515AADB7.3080906@amarulasolutions.com>
Date: Tue, 02 Apr 2013 12:06:47 +0200
From: Michael Trimarchi <michael@amarulasolutions.com>
Organization: Amarula Solutions
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sourav Poddar <sourav.poddar@ti.com>
CC: Kevin Hilman <khilman@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>,
        tony@atomide.com, rmk+kernel@arm.linux.org.uk,
        linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH/Resend 2/2] arm: mach-omap2: prevent UART console idle
 on suspend while using "no_console_suspend"
References: <1363612924-349-1-git-send-email-sourav.poddar@ti.com> <87fvzsilnv.fsf@linaro.org> <5149A221.5@ti.com> <5149A63C.4000102@ti.com> <515AA9CD.5000004@ti.com>
In-Reply-To: <515AA9CD.5000004@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi 

On 02/04/13 11:50, Sourav Poddar wrote:
> Hi Kevin,
> On Wednesday 20 March 2013 05:36 PM, Sourav Poddar wrote:
>> Realised the list  to whom the patch was send got dropped. Ccing them all..
>> On Wednesday 20 March 2013 05:18 PM, Sourav Poddar wrote:
>>> Hi Kevin,
>>> On Tuesday 19 March 2013 12:24 AM, Kevin Hilman wrote:
>>>> Sourav Poddar<sourav.poddar@ti.com>  writes:
>>>>
>>>>> With dt boot, uart wakeup after suspend is non functional on omap4/5 while using
>>>>> "no_console_suspend" in the bootargs. With "no_console_suspend" used, od->flags
>>>>> should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not allowing the console
>>>>> to idle in the suspend path. For non-dt case, this was taken care by platform data.
>>>>>
>>>>> Tested on omap5430evm, omap4430sdp.
>>>>>
>>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>>>> This patch creates a dependency between omap_device (generic,
>>>> device-independent code) and a specific driver (UART.)
>>>>
>>>> If you need to do something like this that's DT boot specific, then
>>>> we probably need some late initcall in serial.c to handle this.  It does
>>>> not belong in omap_device.
>>>>
>>> The following function "omap_device_disable_idle_on_suspend(pdev)" should only
>>> be called once the omap device has been build, which in the case of device tree is
>>> done in omap_device.c file. Moreover, the above call should be executed conditionally
>>> and should depend on the following two parameter.
>>>
>>> [1]  a. Whether "no_console_suspend" is set and
>>>      b.  the device build is a console uart.
>>>
>>> When I look closely into the serial.c file, I realised that
>>> "core_initcall(omap_serial_early_init)" gets called irrespective
>>> of dt/non dt boot and will take care of most of the stuff(checking whether
>>> "no_console_suspend" is used and which uart is used as a console uart) which the
>>> $subject patch is proposing.
>>>
>>> But the problem is that we need to exchange the parsed information
>>> from serial.c to the omap_device file for the condtional execution of
>>> "omap_device_disable_idle_on_suspend"
>>>
>>> In this case,
>>> from "serial.c" we need
>>>     1. no_console_suspend = true
>>>     2. strcpy(console_name, oh_name), where oh_name corresponds to the console uart.
>>>
>>> then in "omap_device.c" do
>>>     if (no_console_suspend && !strcmp(oh->name, console_name))
>>>                 omap_device_disable_idle_on_suspend(pdev);
>>>
>>> Please correct if I am understanding it incorrectly.
>>>
>>> If the above understanding looks good to you, is there a way we can make this
>>> exchange of information happen between serial.c and omap_device.c file?
> Any input on this?
> As I explained earlier, that there is a need to parse information in serial.c and use that in
> omap_device.c only after the device is build.
> 
> Below is the patch (inlined) which further explains my point. The patch is "just for the
> idea" I am trying to express.
> I have used extern variables to exchange information between serial.c and omap_device.c.
> Is there is a better way, we can do this "information exchange" without using extern variables?
> 
> 
> -----
> From: Sourav Poddar <sourav.poddar@ti.com>
> Date: Wed, 13 Mar 2013 20:32:36 +0530
> Subject: [RFC/PATCH] arm: mach-omap2: prevent UART console idle on suspend while using "no_console_suspend"
> 
> With dt boot on omap5, uart wakeup after suspend is non functional while using
> "no_console_suspend" in the bootargs. With "no_console_suspend" used, od->flags
> should be ORed with "OMAP_DEVICE_NO_IDLE_ON_SUSPEND", thereby not allowing the console
> to idle in the suspend path. For non-dt case, this was taken care by platform data.
> 
> Tested on omap5430evm, omap4430sdp.
> 
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>
> ---
> The problem is I need to use couple of "extern variables" which
> can be used in the omap_device file, after the device is built from dt.
> 
>  arch/arm/mach-omap2/omap_device.c |    7 ++++++-
>  arch/arm/mach-omap2/serial.c      |    4 +++-
>  2 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> index e065daa..f4ebf9f 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -96,6 +96,9 @@
>  #define USE_WAKEUP_LAT            0
>  #define IGNORE_WAKEUP_LAT        1
> 
> +extern u8 no_console_suspend;
> +extern char console_uart_name[];
> +
>  static int omap_early_device_register(struct platform_device *pdev);
> 
>  static struct omap_device_pm_latency omap_default_latency[] = {
> @@ -372,7 +375,9 @@ static int omap_device_build_from_dt(struct platform_device *pdev)
>              r->name = dev_name(&pdev->dev);
>      }
> 
> -    if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
> +    if (no_console_suspend && !strcmp(oh->name, console_uart_name))
> +        omap_device_disable_idle_on_suspend(pdev);
> +    else if (of_get_property(node, "ti,no_idle_on_suspend", NULL))
>          omap_device_disable_idle_on_suspend(pdev);

Why do not use some flags instead of external variable?


> 
>      pdev->dev.pm_domain = &omap_device_pm_domain;
> diff --git a/arch/arm/mach-omap2/serial.c b/arch/arm/mach-omap2/serial.c
> index 037e691..f841ab5 100644
> --- a/arch/arm/mach-omap2/serial.c
> +++ b/arch/arm/mach-omap2/serial.c
> @@ -63,8 +63,9 @@ struct omap_uart_state {
>  static LIST_HEAD(uart_list);
>  static u8 num_uarts;
>  static u8 console_uart_id = -1;
> -static u8 no_console_suspend;
>  static u8 uart_debug;
> +u8 no_console_suspend;
> +char console_uart_name[MAX_UART_HWMOD_NAME_LEN];
> 
>  #define DEFAULT_RXDMA_POLLRATE        1    /* RX DMA polling rate (us) */
>  #define DEFAULT_RXDMA_BUFSIZE        4096    /* RX DMA buffer size */
> @@ -199,6 +200,7 @@ static int __init omap_serial_early_init(void)
>                  "%s%d", OMAP_SERIAL_NAME, uart->num);
> 
>          if (cmdline_find_option(uart_name)) {
> +            strcpy(console_uart_name, oh_name);
>              console_uart_id = uart->num;
> 
>              if (console_loglevel >= 10) {

Michael
