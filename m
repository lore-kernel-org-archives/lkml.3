Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab3GUUsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 16:48:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50302 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab3GUUsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 16:48:13 -0400
Message-ID: <51EC4908.4040504@gmail.com>
Date: Sun, 21 Jul 2013 15:48:08 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        George Cherian <george.cherian@ti.com>,
        linux-samsung-soc@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, linux-omap@vger.kernel.org,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        Roger Quadros <rogerq@ti.com>
Subject: Re: [PATCH] of: provide of_platform_unpopulate()
References: <1374257691-31981-1-git-send-email-bigeasy@linutronix.de> <51EBF33A.4050207@gmail.com>
In-Reply-To: <51EBF33A.4050207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2013 09:42 AM, Rob Herring wrote:
> On 07/19/2013 01:14 PM, Sebastian Andrzej Siewior wrote:
>> So I called of_platform_populate() on a device to get each child device
>> probed and on rmmod and I need to reverse its doing. After a quick grep
>> I did what others did as well and rmmod ended in:
>>
>> | Unable to handle kernel NULL pointer dereference at virtual address 00000018
>> | PC is at release_resource+0x18/0x80
>> | Process rmmod (pid: 2005, stack limit = 0xedc30238)
>> | [<c003add0>] (release_resource+0x18/0x80) from [<c0300e08>] (platform_device_del+0x78/0xac)
>> | [<c0300e08>] (platform_device_del+0x78/0xac) from [<c0301358>] (platform_device_unregister+0xc/0x18)
>>
>> The problem is that platform_device_del() "releases" each ressource in its
>> tree. This does not work on platform_devices created by OF becuase they
>> were never added via insert_resource(). As a consequence old->parent in
>> __release_resource() is NULL and we explode while accessing ->child.
>> So I either I do something completly wrong _or_ nobody here tested the
>> rmmod path of their driver.
> 
> Wouldn't the correct fix be to call insert_resource somehow? The problem
> I have is that while of_platform_populate is all about parsing the DT
> and creating devices, the removal side has nothing to do with DT. So
> this should not be in the DT code. I think the core device code should
> be able to handle removal if the device creation side is done correctly.
> 
> It looks to me like of_device_add either needs to call
> platform_device_add rather than device_add. I think the device name
> setting in platform_device_add should be a nop. If not, a check that the
> name is already set could be added.
> 

BTW, it looks like Grant has attempted this already:

commit 02bbde7849e68e193cefaa1885fe0df0f03c9fcd
Author: Grant Likely <grant.likely@secretlab.ca>
Date:   Sun Feb 17 20:03:27 2013 +0000

    Revert "of: use platform_device_add"

    This reverts commit aac73f34542bc7ae4317928d2eabfeb21d247323. That
    commit causes two kinds of breakage; it breaks registration of AMBA
    devices when one of the parent nodes already contains overlapping
    resource regions, and it breaks calls to request_region() by device
    drivers in certain conditions where there are overlapping memory
    regions. Both of these problems can probably be fixed, but it is better
    to back out the commit and get a proper fix designed before trying
again.

    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>


Rob

