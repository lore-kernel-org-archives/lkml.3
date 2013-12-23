Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3LWLAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 06:00:21 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:38506 "EHLO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757285Ab3LWLAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 06:00:20 -0500
X-Greylist: delayed 506 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Dec 2013 06:00:19 EST
Message-ID: <52B815A0.1060609@fold.natur.cuni.cz>
Date: Mon, 23 Dec 2013 11:51:12 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:26.0) Gecko/20100101 Firefox/26.0 SeaMonkey/2.23
MIME-Version: 1.0
To: Peter Wu <lekensteyn@gmail.com>, Jean Delvare <khali@linux-fr.org>
CC: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i801: fix memleak on probe error
References: <20130123174204.00463f98@endymion.delvare> <1387791578-1372-1-git-send-email-lekensteyn@gmail.com> <4657870.yOE66qJqIC@al>
In-Reply-To: <4657870.yOE66qJqIC@al>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the note, was just compiling a new 3.10.24 kernel to test it.
;-)

So far just booted an old 3.9 kernel and after plugging in an external
USB3 drive I got the message, just to be sure I am still able to reproduce
the error and that I have the right .config in the running kernel.

Will wait for another fix instead.
Martin

Peter Wu wrote:
> Nevermind this patch, it does not really fix the memleak because
> i2c_set_adapdata() calls dev_set_drvdata() which allocates memory.
> (I must have ran kmemleak too early, right after boot it did not
> give any warnings, now it does).
>
> RFC: what about dropping i2c_set_adapdata() from the probe function
> and replacing i2c_get_adapdata(adapter) by
> pci_get_drvdata(adapter->pci_dev) on top of this patch? I am not
> sure what the purpose is for i2c_set_adapdata, hence this question.
>
> Regards,
> Peter
>
> On Monday 23 December 2013 10:39:38 Peter Wu wrote:
>> The driver-specific data for i801 was only set for the device on
>> success, that led to a memory leak on error paths (for instance, when
>> there is a resource conflict with ACPI). (The driver core clears the
>> driver data (if set) if the probe routine fails).
>>
>> Fix it by setting the driver data right after successful memory
>> allocation, before reaching any error paths.
>>
>> References: http://lkml.org/lkml/2013/1/23/191
>> Reported-by: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
>> Tested-by: Peter Wu <lekensteyn@gmail.com> [ACPI conflict error path]
>> Signed-off-by: Peter Wu <lekensteyn@gmail.com>
>> ---
>> Hi Jean,
>>
>> This memleak issue is still present in v3.13-rc4-256-gb7000ad.
>>  From kmemleak:
>>
>> unreferenced object 0xffff88022f501a00 (size 256):
>>    comm "systemd-udevd", pid 209, jiffies 4294896115 (age 2872.520s)
>>    hex dump (first 32 bytes):
>>      00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>>      ff ff ff ff ff ff ff ff f4 e2 53 82 ff ff ff ff  ..........S.....
>>    backtrace:
>>      [<ffffffff815d29ce>] kmemleak_alloc+0x4e/0xb0
>>      [<ffffffff8116ea5a>] kmem_cache_alloc_trace+0xfa/0x1e0
>>      [<ffffffff813efc63>] device_private_init+0x23/0x80
>>      [<ffffffff813f2b49>] dev_set_drvdata+0x39/0x50
>>      [<ffffffffa0294539>] i801_probe+0x59/0x528 [i2c_i801]
>>      [<ffffffff81332d95>] local_pci_probe+0x45/0xa0
>>      [<ffffffff81333be9>] pci_device_probe+0xd9/0x130
>>      [<ffffffff813f30e7>] driver_probe_device+0x87/0x390
>>      [<ffffffff813f34c3>] __driver_attach+0x93/0xa0
>>      [<ffffffff813f102b>] bus_for_each_dev+0x6b/0xb0
>>      [<ffffffff813f2b0e>] driver_attach+0x1e/0x20
>>      [<ffffffff813f26e8>] bus_add_driver+0x188/0x260
>>      [<ffffffff813f3b04>] driver_register+0x64/0xf0
>>      [<ffffffff81332930>] __pci_register_driver+0x60/0x70
>>      [<ffffffffa02990af>] 0xffffffffa02990af
>>      [<ffffffff81000312>] do_one_initcall+0xf2/0x1a0
>>
>> The dmesg for this laptop also contains a resource conflict message,
>> just like the reporter (Martin Mokrejs):
>>
>>      [   15.409772] ACPI Warning: 0x0000000000001840-0x000000000000185f SystemIO conflicts with Region \_SB_.PCI0.SBUS.SMBI 1 (20131115/utaddress-251)
>>      [   15.413439] ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver
>>
>> With this patch applied on top of almost 3.13-rc5 (v3.13-rc4-256-gb7000ad),
>> the memleak is gone.
>>
>> Regards,
>> Peter
>> ---
>>   drivers/i2c/busses/i2c-i801.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
>> index 737e298..a7096bf 100644
>> --- a/drivers/i2c/busses/i2c-i801.c
>> +++ b/drivers/i2c/busses/i2c-i801.c
>> @@ -1117,6 +1117,7 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
>>   	if (!priv)
>>   		return -ENOMEM;
>>
>> +	pci_set_drvdata(dev, priv);
>>   	i2c_set_adapdata(&priv->adapter, priv);
>>   	priv->adapter.owner = THIS_MODULE;
>>   	priv->adapter.class = i801_get_adapter_class(priv);
>> @@ -1236,8 +1237,6 @@ static int i801_probe(struct pci_dev *dev, const struct pci_device_id *id)
>>   	/* We ignore errors - multiplexing is optional */
>>   	i801_add_mux(priv);
>>
>> -	pci_set_drvdata(dev, priv);
>> -
>>   	return 0;
>>
>>   exit_free_irq:
>>
>
>
