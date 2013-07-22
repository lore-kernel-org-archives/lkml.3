Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab3GVVQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 17:16:20 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:45968 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932517Ab3GVVQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 17:16:18 -0400
Message-ID: <51EDA117.10605@gmail.com>
Date: Mon, 22 Jul 2013 16:16:07 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        George Cherian <george.cherian@ti.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH] of: provide of_platform_unpopulate()
References: <1374257691-31981-1-git-send-email-bigeasy@linutronix.de> <51EBF33A.4050207@gmail.com> <51EC4908.4040504@gmail.com> <CACxGe6sqv2Wsp26MWqqs9W_eWO3tjs-+2z3z8fC=2fe-BjJvkA@mail.gmail.com>
In-Reply-To: <CACxGe6sqv2Wsp26MWqqs9W_eWO3tjs-+2z3z8fC=2fe-BjJvkA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 06:44 PM, Grant Likely wrote:
> On Sun, Jul 21, 2013 at 9:48 PM, Rob Herring <robherring2@gmail.com> wrote:
>> On 07/21/2013 09:42 AM, Rob Herring wrote:
>>> On 07/19/2013 01:14 PM, Sebastian Andrzej Siewior wrote:
>>>> So I called of_platform_populate() on a device to get each child device
>>>> probed and on rmmod and I need to reverse its doing. After a quick grep
>>>> I did what others did as well and rmmod ended in:
>>>>
>>>> | Unable to handle kernel NULL pointer dereference at virtual address 00000018
>>>> | PC is at release_resource+0x18/0x80
>>>> | Process rmmod (pid: 2005, stack limit = 0xedc30238)
>>>> | [<c003add0>] (release_resource+0x18/0x80) from [<c0300e08>] (platform_device_del+0x78/0xac)
>>>> | [<c0300e08>] (platform_device_del+0x78/0xac) from [<c0301358>] (platform_device_unregister+0xc/0x18)
>>>>
>>>> The problem is that platform_device_del() "releases" each ressource in its
>>>> tree. This does not work on platform_devices created by OF becuase they
>>>> were never added via insert_resource(). As a consequence old->parent in
>>>> __release_resource() is NULL and we explode while accessing ->child.
>>>> So I either I do something completly wrong _or_ nobody here tested the
>>>> rmmod path of their driver.
>>>
>>> Wouldn't the correct fix be to call insert_resource somehow? The problem
>>> I have is that while of_platform_populate is all about parsing the DT
>>> and creating devices, the removal side has nothing to do with DT. So
>>> this should not be in the DT code. I think the core device code should
>>> be able to handle removal if the device creation side is done correctly.
>>>
>>> It looks to me like of_device_add either needs to call
>>> platform_device_add rather than device_add. I think the device name
>>> setting in platform_device_add should be a nop. If not, a check that the
>>> name is already set could be added.
>>>
>>
>> BTW, it looks like Grant has attempted this already:
> 
> Yup, things broke badly. Unfortunately the of_platform_device and
> platform_device history doesn't treat resources in the same way. I
> would like to merge the code, but I haven't been able to figure out a
> clean way to do it. Looks like we do need the unpopulate function.

Was there more breakage than imx6 and amba devices? Your first version
had a fallback case for powerpc. Couldn't we do just allow that for more
than just powerpc? I'd much rather see some work-around within the core
DT code with a warning to prevent more proliferation than putting this
into drivers.

Rob

