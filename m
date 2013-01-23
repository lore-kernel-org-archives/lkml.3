Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3AWRgB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 12:36:01 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:33315 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756574Ab3AWRf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 12:35:59 -0500
Message-ID: <51001F7D.6070905@fold.natur.cuni.cz>
Date: Wed, 23 Jan 2013 18:35:57 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
CC: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-3.7.[1,4]: kmemleak in i801_probe
References: <50FFC659.1090402@fold.natur.cuni.cz> <20130123174204.00463f98@endymion.delvare>
In-Reply-To: <20130123174204.00463f98@endymion.delvare>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

Jean Delvare wrote:
> Hi Martin,
> 
> On Wed, 23 Jan 2013 12:15:37 +0100, Martin Mokrejs wrote:
>> Hi,
>>   I already reported this to lkml recently with linux-3.7.1 but this is to let you know
>> that with 3.7.4 I am still getting this kmemleak reported by the kernel.
> 
> I don't read LKML.
> 
>> unreferenced object 0xffff88040b614690 (size 256):
>>   comm "swapper/0", pid 1, jiffies 4294937573 (age 133834.550s)
>>   hex dump (first 32 bytes):
>>     00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>>     ff ff ff ff ff ff ff ff 08 7f 5d 82 ff ff ff ff  ..........].....
>>   backtrace:
>>     [<ffffffff815b4aad>] kmemleak_alloc+0x21/0x3e
>>     [<ffffffff81110352>] slab_post_alloc_hook+0x28/0x2a
>>     [<ffffffff8111288a>] __kmalloc+0xf2/0x104
>>     [<ffffffff81305165>] kzalloc.constprop.14+0xe/0x10
>>     [<ffffffff813055c6>] device_private_init+0x14/0x63
>>     [<ffffffff813076a0>] dev_set_drvdata+0x19/0x2f
>>     [<ffffffff815c4f5e>] i801_probe+0x5e/0x451
>>     [<ffffffff81280e40>] local_pci_probe+0x39/0x61
>>     [<ffffffff81281f53>] pci_device_probe+0xc6/0xf3
>>     [<ffffffff81307c5d>] driver_probe_device+0xa9/0x1c1
>>     [<ffffffff81307dcf>] __driver_attach+0x5a/0x7e
>>     [<ffffffff8130650a>] bus_for_each_dev+0x57/0x83
>>     [<ffffffff81307806>] driver_attach+0x19/0x1b
>>     [<ffffffff813073d8>] bus_add_driver+0xa8/0x1fa
>>     [<ffffffff81308241>] driver_register+0x8c/0x106
>>     [<ffffffff81281b4e>] __pci_register_driver+0x59/0x5d
> 
> I am using the i2c-i801 driver, enabled kmemleak, but I don't get this
> leak. Did you have to do anything special to get it? Didn't you get a

Based on the dmesg timestamp I think I just logged in through xdm. Eh.
Actually, xdm crashes for me, I have to do in the framebuffer VT console:

root # /etc/init.d/xdm stop
user $ startx

and happily use my X. I have a bugreport opened at https://bugs.freedesktop.org/show_bug.cgi?id=56608
but I doubt it is related to i2c_801 driver. But it is not clear
why I cannot just use xdm but can always start X11 via startx.
And actually, rarely, but without reinstalling my kernel or x11
server or drivers, I sometimes (1/20 attempts?) I can login through xdm. But
comparing Xorg.log files from successful xdm login against those unsuccessful
did not help so far. Only reordered items, probably due to autoconfig.
So, I don't think it helps you with isolating the i2c_801 driver memleak.

> similar leak with older kernels? Do you get a similar leak (with
> reference to dev_set_drvdata)?

With 3.7.1 I was getting same stacktrace:

unreferenced object 0xffff88040b1c5230 (size 256):
  comm "swapper/0", pid 1, jiffies 4294937570 (age 182492.630s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff 38 3f 5d 82 ff ff ff ff  ........8?].....
  backtrace:
    [<ffffffff815b1dbd>] kmemleak_alloc+0x21/0x3e
    [<ffffffff81110536>] slab_post_alloc_hook+0x28/0x2a
    [<ffffffff81112a6e>] __kmalloc+0xf2/0x104
    [<ffffffff81302bd5>] kzalloc.constprop.14+0xe/0x10
    [<ffffffff81303036>] device_private_init+0x14/0x63
    [<ffffffff81305110>] dev_set_drvdata+0x19/0x2f
    [<ffffffff815c1ed4>] i801_probe+0x5e/0x451
    [<ffffffff81280fb3>] local_pci_probe+0x5b/0xa2
    [<ffffffff81282074>] pci_device_probe+0xc8/0xf7
    [<ffffffff813056cd>] driver_probe_device+0xa9/0x1c1
    [<ffffffff8130583f>] __driver_attach+0x5a/0x7e
    [<ffffffff81303f7a>] bus_for_each_dev+0x57/0x83
    [<ffffffff81305276>] driver_attach+0x19/0x1b
    [<ffffffff81304e48>] bus_add_driver+0xa8/0x1fa
    [<ffffffff81305cb1>] driver_register+0x8c/0x106
    [<ffffffff81281c6d>] __pci_register_driver+0x5a/0x5e

Before 3.7.1 I did not use kmemleak detector. while searching my older emails/reports
I found only that I loaded in the past both drivers (on a 2.6.32.59 kernel):

Mar 26 11:21:55 vostro kernel: i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
Mar 26 11:21:55 vostro kernel: ACPI: If an ACPI driver is available for this device, you should use it instead of the native driver


And here the relevant line from lspci from that time:
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)

00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
        Subsystem: Dell Device 04b3
        Flags: medium devsel, IRQ 18
        Memory at f7f05000 (64-bit, non-prefetchable) [size=256]
        I/O ports at f040 [size=32]
        Kernel modules: i2c-i801


I don't think this will help you now. :(


> 
> I can see that dev_set_drvdata may allocate memory (which I didn't
> know) and I admit I don't see where it gets released, however this is
> all happening in the driver core and isn't specific to the i2c-i801
> driver, so if there really is a leak there, you should see it in all
> drivers.

I am not a kernel developer at all but maybe that little bit points out that the
kmemleak was reported when I was pulling in/out my external USB drives?

Martin
