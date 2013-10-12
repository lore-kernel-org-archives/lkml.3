Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752244Ab3JLGwx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 02:52:53 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:49975 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab3JLGww convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 02:52:52 -0400
MIME-Version: 1.0
In-Reply-To: <20131011153544.GA14715@kroah.com>
References: <1381460298-1097-1-git-send-email-ethan.kernel@gmail.com>
	<20131011153544.GA14715@kroah.com>
Date: Sat, 12 Oct 2013 14:52:51 +0800
Message-ID: <CABawtvP+BqpwGYJpvBVbEUyqptSWoF0YEGqbT6o+aTP2326+7A@mail.gmail.com>
Subject: Re: [PATCH] drivers/base/core.c: always output device renaming messages.
From: Ethan Zhao <ethan.kernel@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 11:35 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Fri, Oct 11, 2013 at 10:58:18AM +0800, ethan.zhao wrote:
>> From: "ethan.zhao" <ethan.kernel@gmail.com>
>>
>> While loading ixgbevf driver,every vf detected will be output as the
>> same name 'eth4':
>>
>>  ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver -
>>  version 2.8.7
>>  Copyright (c) 2009-2012 Intel Corporation.
>>  ixgbevf 0000:20:10.0: enabling device (0000 -> 0002)
>>  ixgbe 0000:20:00.0 eth0: VF Reset msg received from vf 0
>>  ixgbevf 0000:20:10.0: irq 199 for MSI/MSI-X
>>  ixgbevf 0000:20:10.0: irq 200 for MSI/MSI-X
>>  ixgbevf: eth%d: ixgbevf_init_interrupt_scheme: Multiqueue Disabled: Rx Queue
>>  count = 1, Tx Queue count = 1
>
> What is that message?  That's not good, "eth%d"?
>
This message came from ixgbevf version 2.8.7, not from kernel 3.11.4,
output netdev name before registration.

>>  ixgbevf: eth4: ixgbevf_probe: Intel(R) X540 Virtual Function
>>  aa:bb:cc:dd:ee:f1
>>  ixgbevf: eth4: ixgbevf_probe: LRO is disabled
>>  ixgbevf: eth4: ixgbevf_probe: GRO is enabled
>>  ixgbevf: eth4: ixgbevf_probe: Intel(R) 10 Gigabit PCI Express Virtual
>>  Function Network Driver
>>  ixgbevf 0000:20:10.2: enabling device (0000 -> 0002)
>>  ixgbe 0000:20:00.0 eth0: VF Reset msg received from vf 1
>>  ixgbevf 0000:20:10.2: irq 201 for MSI/MSI-X
>>  ixgbevf 0000:20:10.2: irq 202 for MSI/MSI-X
>>  ixgbevf: eth%d: ixgbevf_init_interrupt_scheme: Multiqueue Disabled: Rx Queue
>>  count = 1, Tx Queue count = 1
>>  ixgbevf: eth4: ixgbevf_probe: Intel(R) X540 Virtual Function
>>  aa:bb:cc:dd:ee:f2
>>  ixgbevf: eth4: ixgbevf_probe: LRO is disabled
>>  ixgbevf: eth4: ixgbevf_probe: GRO is enabled
>>  ixgbevf: eth4: ixgbevf_probe: Intel(R) 10 Gigabit PCI Express Virtual
>>
>> But if we view the NICs with ifconfig, found no NIC named 'eth4', the cause is
>> udev has renamed the 'eth4' to 'eth10', 'eth10' one by one. because no renaming
>> messages output, that is confusing.
>> So we need always output renaming messages in device_name() instead of pr_debug().
>> After applied this patch, it is much clearer:
>
> How is journald tracking this today, without this extra message sent to
> the kernel log?  It knows what devices are renamed to what somehow.
>
> I really don't want to clutter up the syslog for things that aren't
> needed, and as userspace was the one that told the kernel to rename the
> device, why does the kernel have to spit it back out again to userspace?
> That seems redundant, don't you think?
Yes, agree somehow , perfect system should run without any noise and
rubbish in log.
But if something wrong happened, no message shown will make us helpless.
As an user space daemon, udev, also has the reason to refuse any
message  output(
you have udev tracking tools).

'redundant', yes, sometime waste and not perfect, but sometime the
backup help us more.
>
>>  ixgbevf: Intel(R) 10 Gigabit PCI Express Virtual Function Network Driver -
>>  version 2.8.7
>>  Copyright (c) 2009-2012 Intel Corporation.
>>  ixgbevf 0000:20:10.0: enabling device (0000 -> 0002)
>>  ixgbe 0000:20:00.0 eth0: VF Reset msg received from vf 0
>>  ixgbevf 0000:20:10.0: Multiqueue Disabled: Rx Queue count = 1, Tx Queue count
>>  = 1
>>  ixgbevf: eth4: ixgbevf_probe: Intel(R) X540 Virtual Function
>>  net eth4: 'eth4' renaming to 'eth8'
>
> A bit redundant, "eth4" shows up twice.
You hate 'redundant' , got it.
>
>>  aa:bb:cc:dd:ee:11
>>  ixgbevf: eth8: ixgbevf_probe: LRO is disabled
>>  ixgbevf: eth8: ixgbevf_probe: GRO is enabled
>>  ixgbevf: eth8: ixgbevf_probe: Intel(R) 10 Gigabit PCI Express Virtual
>>  Function Network Driver
>>  ixgbevf 0000:20:10.2: enabling device (0000 -> 0002)
>>  ixgbe 0000:20:00.0 eth0: VF Reset msg received from vf 1
>>  ixgbevf 0000:20:10.2: Multiqueue Disabled: Rx Queue count = 1, Tx Queue count
>>  = 1
>>  ixgbevf: eth4: ixgbevf_probe: Intel(R) X540 Virtual Function
>>  net eth4: 'eth4' renaming to 'eth9'
>>  aa:bb:cc:dd:ee:12
>>  ixgbevf: eth9: ixgbevf_probe: LRO is disabled
>>  ixgbevf: eth9: ixgbevf_probe: GRO is enabled
>>  ixgbevf: eth9: ixgbevf_probe: Intel(R) 10 Gigabit PCI Express Virtual
>>  Function Network Driver
>>
>> Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
>> ---
>>  drivers/base/core.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/base/core.c b/drivers/base/core.c
>> index 2d1c6ba..9a98794 100644
>> --- a/drivers/base/core.c
>> +++ b/drivers/base/core.c
>> @@ -1904,8 +1904,7 @@ int device_rename(struct device *dev, const char *new_name)
>>       if (!dev)
>>               return -EINVAL;
>>
>> -     pr_debug("device: '%s': %s: renaming to '%s'\n", dev_name(dev),
>> -              __func__, new_name);
>> +     dev_info(dev, "'%s' renaming to '%s'\n", dev_name(dev), new_name);
>
> How about:
>         dev_dbg(dev, "renaming to '%s'\n", new_name);

If something confusing or wrong, need to take a look.
For pr_debug(), We have to build and load a debug kernel…
For dev_dbg(),  We have to rebuild a kernel with CONFIG_DYNAMIC_DEBUG
set to 'y', that is default 'n'.
So, do you mean

dev_printk(KERN_DEBUG, dev, "renaming to '%s'\n", new_name);  ?

>
> should be all that is needed, right?  Good call on pointing out that we
> don't need to use pr_debug() here, don't know why I never noticed
> that...
>
> That way, if you really want to know this information, you can
> dynamically turn on that line to be printed out, no need to clutter up
> everyone else's logs.
>
> Care to redo this?
>
> thanks,
>
> greg k-h
