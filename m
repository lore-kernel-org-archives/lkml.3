Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbaISVLw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:11:52 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51755 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962AbaISVLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:11:51 -0400
Message-ID: <541C9C08.9070809@gmail.com>
Date: Fri, 19 Sep 2014 14:11:36 -0700
From: Florian Fainelli <f.fainelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] bus: brcmstb_gisb: register the fault code hook
References: <1411156230-24024-1-git-send-email-f.fainelli@gmail.com> <1411156230-24024-2-git-send-email-f.fainelli@gmail.com> <20140919201722.GL1193@ld-irv-0074>
In-Reply-To: <20140919201722.GL1193@ld-irv-0074>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2014 01:17 PM, Brian Norris wrote:
> On Fri, Sep 19, 2014 at 12:50:29PM -0700, Florian Fainelli wrote:
>> Commit 44127b771d9c31 ("bus: add Broadcom GISB bus arbiter timeout/error
>> handler") added everything that is required to register an ARM fault
>> handler for imprecise external aborts, except that there is nothing
>> calling this currently.
>>
>> We do not need to export that specific function and have to update
>> arch/arm/mach-bcm/brcmstb.c to call it, simply, register the fault
>> handler with an arch_initcall.
> 
> Am I missing something, or does that mean that this error handler will
> be registered for *all* kernels which include this driver? e.g., anyone
> using multi_v7_defconfig?

That's a very good point, at first I was relying on the fact that even
though we register our fault code, this is not much of a problem because
the list is empty until we get to probe the gisb-arb node, it would be
empty for non-brcmstb platforms, but that's not a good thing.

> 
> So it seems we need to gate this behind some kind of machine check;
> either called from mach-bcm/*, or better, from something that is probed
> via device tree. Is it a problem to register this in the probe()
> function, like drivers/pci/host/pci-imx6.c?

No, I do not think this is a problem, there might be a small window
during which we enable external aborts exceptions and we have no handler
for it yet, but I will check that more thoroughly.

> 
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>> Changes in v2:
>> - removed the accidental hunk that added saved_timeout since it does
>>   not belong in this patch
>>
>>  drivers/bus/brcmstb_gisb.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/bus/brcmstb_gisb.c b/drivers/bus/brcmstb_gisb.c
>> index f2cd6a2d40b4..5b608955957a 100644
>> --- a/drivers/bus/brcmstb_gisb.c
>> +++ b/drivers/bus/brcmstb_gisb.c
>> @@ -160,11 +160,13 @@ static int brcmstb_bus_error_handler(unsigned long addr, unsigned int fsr,
>>  	return ret;
>>  }
>>  
>> -void __init brcmstb_hook_fault_code(void)
>> +static int __init brcmstb_hook_fault_code(void)
>>  {
>>  	hook_fault_code(22, brcmstb_bus_error_handler, SIGBUS, 0,
>>  			"imprecise external abort");
>> +	return 0;
>>  }
>> +arch_initcall(brcmstb_hook_fault_code)
>>  
>>  static irqreturn_t brcmstb_gisb_timeout_handler(int irq, void *dev_id)
>>  {
> 
> Brian
> 

