Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215AbaE1JAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 05:00:45 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58920 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752013AbaE1JAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 05:00:39 -0400
Message-ID: <5385B10D.3020207@ti.com>
Date: Wed, 28 May 2014 12:49:01 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rob Herring <robh@kernel.org>, Kevin Hilman <khilman@linaro.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, LKML <linux-kernel@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH v1] of/irq: do irq resolution in platform_get_irq_byname()
References: <1400582523-22684-1-git-send-email-grygorii.strashko@ti.com>	<20140523080333.66720C4176E@trevor.secretlab.ca>	<CAGa+x85mOHtNAj-UHgK2_z8zWAF=qwFcRcUgHTR-byNiX7heHA@mail.gmail.com> <CAL_JsqLm3wfVS+au+JUbhBhxz=LuVpepH6GxabCQhPowhbw77g@mail.gmail.com>
In-Reply-To: <CAL_JsqLm3wfVS+au+JUbhBhxz=LuVpepH6GxabCQhPowhbw77g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

On 05/28/2014 03:37 AM, Rob Herring wrote:
> On Tue, May 27, 2014 at 3:23 PM, Kevin Hilman <khilman@linaro.org> wrote:
>> On Fri, May 23, 2014 at 1:03 AM, Grant Likely <grant.likely@linaro.org> wrote:
>>> On Tue, 20 May 2014 13:42:02 +0300, Grygorii Strashko <grygorii.strashko@ti.com> wrote:
>>>> The commit 9ec36cafe43bf835f8f29273597a5b0cbc8267ef
>>>> "of/irq: do irq resolution in platform_get_irq" from Rob Herring -
>>>> moves resolving of the interrupt resources in platform_get_irq().
>>>> But this solution isn't complete because platform_get_irq_byname()
>>>> need to be modified the same way.
>>>>
>>>> Hence, fix it by adding interrupt resolution code at the
>>>> platform_get_irq_byname() function too.
>>>>
>>>> Cc: Russell King <linux@arm.linux.org.uk>
>>>> Cc: Rob Herring <robh@kernel.org>
>>>> Cc: Tony Lindgren <tony@atomide.com>
>>>> Cc: Grant Likely <grant.likely@linaro.org>
>>>> Cc: Thierry Reding <thierry.reding@gmail.com>
>>>>
>>>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>>>
>>> Applied, Thanks.
>>
>> As of next-20150526, the ST u8500 Snowball board has been failing boot
>> in linux-next, and was bisected down to this patch (commit
>> ad69674e73a1 in -next).   Full boot failure attached.
>>
>> I have not dug any deeper, but can confirm that next-20140526 with
>> this patch reverted boots again on the snowball board.
> 
> There's a patch on the list which fixes it. The problem is stmmac
> driver was expecting only one error code.
> 

Seems root cause of problem is hidden inside MFD ab8500-core.c :(
And it's related to simulations supporting of DT and non-DT devices.

For example:
----- Log file contains lines
[    0.919677] ab8500-debug ab8500-debug.0: First irq not found, err -22
[    0.926147] ab8500-debug: probe of ab8500-debug.0 failed with error -22

DT definition of ab8500-debug is specified as following (ste-dbx5x0.dtsi):
	ab8500-debugfs {
		compatible = "stericsson,ab8500-debug";
	};

In code ab8500-debug is created using mfd_add_devices() API which fills
device's resources manually, but, in same time, It links ab8500-debug device
to DT node because MFD cell has of_compatible property set to:
 		.of_compatible = "stericsson,ab8500-debug",


Problem: both new versions of APIs platform_get_irq_byname() and
platform_get_irq() will fail to get IRQ.


Another problem is:
[    1.038909] abx5x0-usb ab8500-usb.0: Link status irq not found
- looking on it now - it should work


Best regards,
-grygorii






