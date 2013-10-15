Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759921Ab3JOUzh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:55:37 -0400
Received: from p3plex2out01.prod.phx3.secureserver.net ([184.168.131.12]:33325
	"EHLO p3plex2out01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759788Ab3JOUze convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:55:34 -0400
From: Hartley Sweeten <HartleyS@visionengravers.com>
To: Olof Johansson <olof@lixom.net>
CC: Ryan Mallon <rmallon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        ARM Kernel <linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] usb: ohci: remove ep93xx bus glue platform driver
Thread-Topic: [PATCH] usb: ohci: remove ep93xx bus glue platform driver
Thread-Index: AQHOyb44UXk4taU1KkyO9IKo4BrMiJn2PJZQ
Date: Tue, 15 Oct 2013 20:55:32 +0000
Message-ID: <DC148C5AA1CEBA4E87973D432B1C2D8817DADDF6@P3PWEX4MB008.ex4.secureserver.net>
References: <201310141435.31147.hartleys@visionengravers.com>
 <CAOesGMgDW6scSq7s__Cyu-V=o2xFAbR2zKgO4FF8Jd29CyWy_w@mail.gmail.com>
In-Reply-To: <CAOesGMgDW6scSq7s__Cyu-V=o2xFAbR2zKgO4FF8Jd29CyWy_w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [184.183.19.121]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 15, 2013 8:50 AM, Olof Johansson wrote:
> On Mon, Oct 14, 2013 at 2:35 PM, H Hartley Sweeten <hartleys@visionengravers.com> wrote:
>> Convert ep93xx to use the OHCI platform driver and remove the
>> ohci-ep93xx bus glue driver.
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>> ---
>>  arch/arm/mach-ep93xx/clock.c   |   2 +-
>>  arch/arm/mach-ep93xx/core.c    |  45 +++++++++-
>>  drivers/usb/host/Kconfig       |   2 +-
>>  drivers/usb/host/ohci-ep93xx.c | 184 -----------------------------------------
>>  drivers/usb/host/ohci-hcd.c    |  18 ----
>>  5 files changed, 43 insertions(+), 208 deletions(-)
>>  delete mode 100644 drivers/usb/host/ohci-ep93xx.c
>>
>> diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
>> index c95dbce..39ef3b6 100644
>> --- a/arch/arm/mach-ep93xx/clock.c
>> +++ b/arch/arm/mach-ep93xx/clock.c
>> @@ -212,7 +212,7 @@ static struct clk_lookup clocks[] = {
>>         INIT_CK(NULL,                   "hclk",         &clk_h),
>>         INIT_CK(NULL,                   "apb_pclk",     &clk_p),
>>         INIT_CK(NULL,                   "pll2",         &clk_pll2),
>> -       INIT_CK("ep93xx-ohci",          NULL,           &clk_usb_host),
>> +       INIT_CK("ohci-platform",        NULL,           &clk_usb_host),
>>         INIT_CK("ep93xx-keypad",        NULL,           &clk_keypad),
>>         INIT_CK("ep93xx-fb",            NULL,           &clk_video),
>>         INIT_CK("ep93xx-spi.0",         NULL,           &clk_spi),
>> diff --git a/arch/arm/mach-ep93xx/core.c b/arch/arm/mach-ep93xx/core.c
>> index 3f12b88..5489824 100644
>> --- a/arch/arm/mach-ep93xx/core.c
>> +++ b/arch/arm/mach-ep93xx/core.c
>> @@ -36,6 +36,7 @@
>>  #include <linux/export.h>
>>  #include <linux/irqchip/arm-vic.h>
>>  #include <linux/reboot.h>
>> +#include <linux/usb/ohci_pdriver.h>
>>
>>  #include <mach/hardware.h>
>>  #include <linux/platform_data/video-ep93xx.h>
>> @@ -297,22 +298,58 @@ static struct platform_device ep93xx_rtc_device = {
>>         .resource       = ep93xx_rtc_resource,
>>  };
>>
>> +/*************************************************************************
>> + * EP93xx OHCI USB Host
>> + *************************************************************************/
>> +
>> +static struct clk *ep93xx_ohci_host_clock;
>> +
>> +static int ep93xx_ohci_power_on(struct platform_device *pdev)
>> +{
>> +       if (!ep93xx_ohci_host_clock) {
>> +               ep93xx_ohci_host_clock = devm_clk_get(&pdev->dev, NULL);
>> +               if (IS_ERR(ep93xx_ohci_host_clock))
>> +                       return PTR_ERR(ep93xx_ohci_host_clock);
>> +       }
>> +
>> +       clk_enable(ep93xx_ohci_host_clock);
>> +
>> +       return 0;
>> +}
>> +
>> +static void ep93xx_ohci_power_off(struct platform_device *pdev)
>> +{
>> +       clk_disable(ep93xx_ohci_host_clock);
>> +}
>> +
>> +static void ep93xx_ohci_power_suspend(struct platform_device *pdev)
>> +{
>> +       ep93xx_ohci_power_off(pdev);
>> +}
>> +
>> +static struct usb_ohci_pdata ep93xx_ohci_pdata = {
>> +       .power_on       = ep93xx_ohci_power_on,
>> +       .power_off      = ep93xx_ohci_power_off,
>> +       .power_suspend  = ep93xx_ohci_power_suspend,
>> +};
>
> This is definitely not a show-stopper in any way, but since this is
> just standard clock management, could you even move these clock ops
> into the driver? Are any other platforms already doing similar things
> so you could remove code from their platform that way as well, per
> chance?

It does not appear any of the other users of the ohci-platform driver do
anything similar.

The clock ops could be moved into the driver but I will need to add a
flag or something to the usb_ohci_pdata so that the platform can
indicated that a clock is required and  the clock ops should be done.

Regards,
Hartley

