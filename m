Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030534Ab3DSOFI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 10:05:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55959 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030427Ab3DSOFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 10:05:05 -0400
Message-ID: <51714F01.2050605@ti.com>
Date: Fri, 19 Apr 2013 19:34:49 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Kevin Hilman <khilman@linaro.org>, <gregkh@linuxfoundation.org>,
        <tony@atomide.com>, <rmk+kernel@arm.linux.org.uk>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Felipe Balbi <balbi@ti.com>, Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCH 0/6] Serial Omap fixes and cleanups
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com> <87mwsv3dgk.fsf@linaro.org> <517046B8.6000900@ti.com> <51713259.7000205@ti.com>
In-Reply-To: <51713259.7000205@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grygorii,
On Friday 19 April 2013 05:32 PM, Grygorii Strashko wrote:
> On 04/18/2013 10:17 PM, Sourav Poddar wrote:
>> Hi Kevin,
>> On Thursday 18 April 2013 11:53 PM, Kevin Hilman wrote:
>>> Hi Sourav,
>>>
>>> Sourav Poddar<sourav.poddar@ti.com>  writes:
>>>
>>>> Hi,
>>>>
>>>> This patch series contains fixes and cleanups around the issue that
>>>> the console UART should not idled on suspend while using 
>>>> "no_console_suspend"
>>>> in bootargs.
>>>>
>>> The direction of the series is right, thanks for the updated approach.
>>> I had a comple minor comments on specific patches, but the ordering of
>>> the series needs a little tweaking.  It should be
>>>
>>> - core/driver changes [current 1-3/6 are ok]
>>> - remove usage from mach-omap2/serial.c (currently part of 4/6)
>>> - remove am33x DT usage (current 5/6 is ok)
>>> - remove entirely from omap_device (omap_device part of 4/6 and 6/6 
>>> should be combined)
>>>
>> Thanks a lot for your review and comments.
>> I have replied to your comments on the respective patches.
>> Will take care of the "ordering" which you mentioned above
>> in the next version.
>>
>> Thanks
>> Sourav
> Hi Sourav
>
> I'd like to clarify some points regarding this series:
>
> 1) I'm not sure that removing OMAP_DEVICE_NO_IDLE_ON_SUSPEND is fine.
> FYI - 
> review.omapzoom.org/#/q/status:open,n,zI9e21bf4432a537a4ccb217cf9c425b0e4e499ce8
> "ASoC: omap-abe: Allow no idle on suspend"
> The above "voice call" use case allows Audio playback while system is 
> in "suspend" state.
> In addition HSI and SmartReflex may need to be active after 
> suspend_noirq stage.
> By removing this flag such functionality will be broken (in case of 
> porting it
> on newest Kernel or MainLine).
> So, How it can be handled without OMAP_DEVICE_NO_IDLE_ON_SUSPEND?
>
Yes, if we have other use cases, we need to see if there is any way of 
handling it through the
respective drivers.
> 2) Runtime PM vs System suspend
> - The commit 88d26136a "PM: Prevent runtime suspend during system resume"
>   block pm_runtime_put_xx() while suspending/resuming, so if your UART 
> will became active
>   (at least one call to pm_runtime_get_xx()) while system is 
> suspending it will stay active
>   until suspend_noirq stage.
> - At suspend_noirq stage OMAP device framework will finally (brutally) 
> disable it to reach
>   system suspend state (in _od_suspend_noirq).
> - At resume_noirq stage OMAP device framework will re-enable device if 
> it was disabled in
>   _od_suspend_noirq() to keep device state and Runtime PM in sync.
> - In addition, the commit 9f6d8f6 "PM: Move disabling/enabling runtime 
> PM to late suspend/early resume"
>   will disable Runtime PM at suspend_late and enable it resume_early 
> stages.
>
> As, result:
> - serial_omap_prepare()/serial_omap_complete() not needed - usually 
> console is active.
>   Or you may call pm_runtime_get_xxx() in serial_omap_prepare() to be 
> sure (that's all)
> - removing OMAP_DEVICE_NO_IDLE_ON_SUSPEND will not help, because to 
> handle your use case
>   omap_device_idle() need to be removed from od_suspend_noirq().
>   !! Which, in turn, will kill OMAP suspend !! (see Kevin's comments)
>
Yes, I have seen kevin's comments and indeed we need to remove 
"omap_device_idle"
along with prep/complete to get my issue fixed(which indeed is not correct).

> Unfortunately, I see no way to avoid usage 
> OMAP_DEVICE_NO_IDLE_ON_SUSPEND with the current
> OMAP device framework.
>
> Regards,
> -grygorii
>>> Kevin
>>>
>>>> The approach thought of is to modify the serial core/serial driver 
>>>> to bypass
>>>> runtime PM if the UART in contention is a console and we are using 
>>>> "no_console_suspend"
>>>> in our bootargs.
>>>>
>>>> While fixing the above issue, there are other cleanups also done as 
>>>> part of
>>>> this series which are no longer required. This cleanups mainly 
>>>> include getting
>>>> rid of using "omap_device_disable_idle_on_suspend" api for both dt 
>>>> and non dt case
>>>> as the serial driver will be self sufficient to handle the 
>>>> "no_idle_on_suspend" issue.
>>>> Serial was the only one making use of 
>>>> "omap_device_disable_idle_on_suspend"
>>>>
>>>> Test info (except drivers: serial: mpc52xx_uart: Remove 
>>>> "uart_console" defintion):
>>>> Omap4430sdp:
>>>> - Tested wakeup from UART after suspend for dt and non dt case.
>>>> Omap5430evm:
>>>> - Tested wakeup from UART after suspend for dt case.
>>>>
>>>>
>>>> There were discussions about how to handle "no_idle_on_suspend" 
>>>> issue and all the
>>>> discussions are as follows:
>>>> [v3]: https://lkml.org/lkml/2013/4/5/239
>>>> [v2]: https://lkml.org/lkml/2013/4/2/350
>>>> [v1]: https://lkml.org/lkml/2013/3/18/199
>>>>        https://lkml.org/lkml/2013/3/18/295
>>>> Due to the amount of change in approach and other cleanups coming 
>>>> around it, I am posting
>>>> this as a new series.
>>>>
>>>> This patches are based on 3.9-rc3 custom tree which has
>>>> Santosh Shilimkar serial patch[1]
>>>> [1]: http://permalink.gmane.org/gmane.linux.ports.arm.omap/95828
>>>>
>>>> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
>>>> Cc: Felipe Balbi<balbi@ti.com>
>>>> Cc: Rajendra nayak<rnayak@ti.com>
>>>>
>>>> Sourav Poddar (6):
>>>>    drivers: tty: serial: Move "uart_console" def to core header file.
>>>>    drivers: serial: mpc52xx_uart: Remove "uart_console" defintion
>>>>    driver: serial: omap: add prepare/complete callback for
>>>>      "no_console_suspend" case
>>>>    arm: mach-omap2: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check
>>>>    arm: dts: am33xx: Remove "ti,no_idle_on_suspend" property.
>>>>    arm: mach-omap2: Remove "no_console_suspend"
>>>>
>>>>   arch/arm/boot/dts/am33xx.dtsi     |    1 -
>>>>   arch/arm/mach-omap2/omap_device.c |   10 +---------
>>>>   arch/arm/mach-omap2/serial.c      |    7 -------
>>>>   drivers/tty/serial/mpc52xx_uart.c |   10 ----------
>>>>   drivers/tty/serial/omap-serial.c  |   20 ++++++++++++++++++++
>>>>   drivers/tty/serial/serial_core.c  |    6 ------
>>>>   include/linux/serial_core.h       |    6 ++++++
>>>>   7 files changed, 27 insertions(+), 33 deletions(-)
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

