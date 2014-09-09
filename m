Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbaIILrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:47:53 -0400
Received: from v032797.home.net.pl ([89.161.177.31]:50162 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753244AbaIILrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:47:52 -0400
Message-ID: <540EE8F0.3020500@elproma.com.pl>
Date: Tue, 09 Sep 2014 13:48:00 +0200
From: =?UTF-8?B?SmFudXN6IFXFvHlja2k=?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Markus Pargmann <mpa@pengutronix.de>, Lisovy Rostislav <lisovy@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Michal Vokac <michal.vokac@comap.cz>,
        Wim Van Sebroeck <wim@iguana.be>
Subject: Re: Watchdog start during boot
References: <1410258569.15354.3.camel@lp-lvrv.comap.cz> <20140909110043.GG24081@pengutronix.de>
In-Reply-To: <20140909110043.GG24081@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

http://www.spinics.net/lists/linux-watchdog/msg04055.html
The patch is little similar to mine.

I see the proposal http://www.spinics.net/lists/linux-watchdog/msg05004.html
need our common forward evaluation. We all have similar needs.

I propose to add to my initial patch rootfs's warm-up time
or similar name of parameter.
If this time is not zero after the time timer stops pinging.
The param is time when userland is ready to maintain
a watchdog alone if it supports wachdog at all.
Some userlands open /dev/watchdog only in critical moments
and after they use magic close. Therefore my patch continue
watchdog's pinging in kernel space.

Information that watchdog is not stopable could be added to DT.
However it seems to direct depends on the watchdog, ie. its driver
or if bootloader enabled/disabled the watchdog.

As Guenter Roeck wrote
watchdog_dev could be extended to support not only
always active watchdogs but also longer timeout values
to not implement it in each watchdog driver separately like now.

Also suspend could be unified in my opinion by some helper functions.

best regards
Janusz

W dniu 2014-09-09 13:00, Markus Pargmann pisze:
> Hi,
>
> On Tue, Sep 09, 2014 at 12:29:29PM +0200, Lisovy Rostislav wrote:
>> Hello;
>> If my understanding is correct, the purpose of the "watchdog subsystem"
>> is to provide an unified interface from user-space to watchdog devices
>> (via /dev). The issue I am trying to solve is how to start the watchdog
>> during boot (it would be sufficient just not to disable it since the
>> bootloader enables it) to be controlled later on with the user-space
>> tool -- i.e. when the user-space will not boot properly, I would like
>> the device to be rebooted.
>>
>> My "quick and dirty" device-specific solution is:
>>
>> diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
>> index 3691b15..1e44b03f 100644
>> --- a/drivers/watchdog/omap_wdt.c
>> +++ b/drivers/watchdog/omap_wdt.c
>> @@ -53,6 +53,10 @@ static unsigned timer_margin;
>>   module_param(timer_margin, uint, 0);
>>   MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
>>   
>> +static bool start_on_boot = false;
>> +module_param(start_on_boot, bool, 0);
>> +MODULE_PARM_DESC(start_on_boot, "Start the watchdog during boot");
>> +
>>   struct omap_wdt_dev {
>>          void __iomem    *base;          /* physical */
>>          struct device   *dev;
>> @@ -269,6 +273,9 @@ static int omap_wdt_probe(struct platform_device *pdev)
>>   
>>          pm_runtime_put_sync(wdev->dev);
>>   
>> +       if (start_on_boot)
>> +               omap_wdt_start(omap_wdt);
>> +
>>          return 0;
>>   }
>>
>> however I think it would be much beneficial to do this in a generic way.
>> Maybe to create a device tree property, that would store some flag to
>> start the watchdog during boot?
> The devicetree should be a hardware description, so it may not be the
> right way to pass such information.
>
> Some time ago I proposed something similar where the first watchdog
> driver that is registered can be activated by a kernel commandline
> parameter. Here is some discussion about the topic:
> 	Mail-id 1393604183-8755-1-git-send-email-mpa@pengutronix.de
> 	http://www.spinics.net/lists/linux-watchdog/msg04055.html
>
> Best regards,
>
> Markus
>

