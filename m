Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaDXUr0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 16:47:26 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:49265 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbaDXUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 16:47:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140424184207.GC27443@ulmo>
References: <1398293861-7682-1-git-send-email-robherring2@gmail.com>
 <1398293861-7682-3-git-send-email-robherring2@gmail.com> <20140424184207.GC27443@ulmo>
From: Grant Likely <grant.likely@linaro.org>
Date: Thu, 24 Apr 2014 21:47:02 +0100
X-Google-Sender-Auth: KlzhvzAv4bE9WynBKwy8j53sd_c
Message-ID: <CACxGe6uni+=7JS-Sn-WViPMnVSXg-L35=S9pvz95Gm4kgDqLhg@mail.gmail.com>
Subject: Re: [PATCH 2/2] of/irq: do irq resolution in platform_get_irq
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Rob Herring <robherring2@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Rob Herring <robh@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 7:42 PM, Thierry Reding
<thierry.reding@gmail.com> wrote:
> On Wed, Apr 23, 2014 at 05:57:41PM -0500, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> Currently we get the following kind of errors if we try to use interrupt
>> phandles to irqchips that have not yet initialized:
>>
>> irq: no irq domain found for /ocp/pinmux@48002030 !
>> ------------[ cut here ]------------
>> WARNING: CPU: 0 PID: 1 at drivers/of/platform.c:171 of_device_alloc+0x144/0x184()
>> Modules linked in:
>> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.12.0-00038-g42a9708 #1012
>> (show_stack+0x14/0x1c)
>> (dump_stack+0x6c/0xa0)
>> (warn_slowpath_common+0x64/0x84)
>> (warn_slowpath_null+0x1c/0x24)
>> (of_device_alloc+0x144/0x184)
>> (of_platform_device_create_pdata+0x44/0x9c)
>> (of_platform_bus_create+0xd0/0x170)
>> (of_platform_bus_create+0x12c/0x170)
>> (of_platform_populate+0x60/0x98)
>>
>> This is because we're wrongly trying to populate resources that are not
>> yet available. It's perfectly valid to create irqchips dynamically, so
>> let's fix up the issue by resolving the interrupt resources when
>> platform_get_irq is called.
>>
>> And then we also need to accept the fact that some irqdomains do not
>> exist that early on, and only get initialized later on. So we can
>> make the current WARN_ON into just into a pr_debug().
>>
>> We still attempt to populate irq resources when we create the devices.
>> This allows current drivers which don't use platform_get_irq to continue
>> to function. Once all drivers are fixed, this code can be removed.
>>
>> Suggested-by: Russell King <linux@arm.linux.org.uk>
>> Signed-off-by: Rob Herring <robh@kernel.org>
>> Signed-off-by: Tony Lindgren <tony@atomide.com>
>> ---
>>  drivers/base/platform.c |  7 ++++++-
>>  drivers/of/irq.c        | 26 ++++++++++++++++++++++++++
>>  drivers/of/platform.c   |  4 +++-
>>  include/linux/of_irq.h  |  7 ++++++-
>>  4 files changed, 41 insertions(+), 3 deletions(-)
>
> Hehe... that's largely what we already had back in January[0]. Glad to
> see that people could finally agree on what to do about this.
>
> Thierry
>
> [0]: https://lkml.org/lkml/2014/1/8/240

Sometimes it takes prodding around with the other options to figure
out an earlier approach was on the right track. I'm very happy to
finally have a solution here that appears to be working.

I've pushed it out to my tree so it gets into linux-next. Please test
before I ask Linus to pull.

git://git.secretlab.ca/git/linux devicetree/merge

g.
