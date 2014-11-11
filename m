Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604AbaKKP1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 10:27:47 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:47400 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaKKP1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 10:27:43 -0500
Message-ID: <54622AED.9060205@kernel.dk>
Date: Tue, 11 Nov 2014 08:27:41 -0700
From: Jens Axboe <axboe@kernel.dk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the block tree
References: <20141111131216.3742d156@canb.auug.org.au> <318149421.176770.1415704819915.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <318149421.176770.1415704819915.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-11-11 04:20, Fabian Frederick wrote:
>
>
>> On 11 November 2014 at 03:12 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>>
>> Hi Jens,
>>
>> After merging the block tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> drivers/built-in.o: In function `cdrom_sysctl_handler':
>> cdrom_sysctl.c:(.text+0x156d92): undefined reference to `cdrom_mutex'
>> cdrom_sysctl.c:(.text+0x156da0): undefined reference to `cdrom_autoclose'
>> cdrom_sysctl.c:(.text+0x156dae): undefined reference to `cdrom_autoeject'
>> cdrom_sysctl.c:(.text+0x156dbc): undefined reference to `cdrom_debug'
>> cdrom_sysctl.c:(.text+0x156dca): undefined reference to `cdrom_lockdoor'
>> cdrom_sysctl.c:(.text+0x156dd8): undefined reference to
>> `cdrom_check_media_type'
>> cdrom_sysctl.c:(.text+0x156e0b): undefined reference to `cdrom_list'
>> cdrom_sysctl.c:(.text+0x156e37): undefined reference to `cdrom_autoclose'
>> cdrom_sysctl.c:(.text+0x156e57): undefined reference to `cdrom_autoeject'
>> cdrom_sysctl.c:(.text+0x156e77): undefined reference to
>> `cdrom_check_media_type'
>> cdrom_sysctl.c:(.text+0x156ea4): undefined reference to `cdrom_lockdoor'
>> cdrom_sysctl.c:(.text+0x156eb5): undefined reference to `cdrom_list'
>> cdrom_sysctl.c:(.text+0x15702e): undefined reference to `cdrom_mutex'
>> drivers/built-in.o: In function `cdrom_print_info.constprop.0':
>> cdrom_sysctl.c:(.text+0x1570f3): undefined reference to `cdrom_list'
>> cdrom_sysctl.c:(.text+0x157189): undefined reference to `cdrom_list'
>> drivers/built-in.o: In function `cdrom_sysctl_info':
>> cdrom_sysctl.c:(.text+0x1572c3): undefined reference to `cdrom_mutex'
>> cdrom_sysctl.c:(.text+0x1576dc): undefined reference to `cdrom_mutex'
>> drivers/built-in.o: In function `cdrom_sysctl_register':
>> (.text+0x157765): undefined reference to `cdrom_autoclose'
>> drivers/built-in.o: In function `cdrom_sysctl_register':
>> (.text+0x157781): undefined reference to `cdrom_autoeject'
>> drivers/built-in.o: In function `cdrom_sysctl_register':
>> (.text+0x15778e): undefined reference to `cdrom_debug'
>> drivers/built-in.o: In function `cdrom_sysctl_register':
>> (.text+0x15779b): undefined reference to `cdrom_lockdoor'
>> drivers/built-in.o: In function `cdrom_sysctl_register':
>> (.text+0x1577a8): undefined reference to `cdrom_check_media_type'
>>
>> Probably caused by commit d01681d1457c ("cdrom: export sysctl code").
>> This build has CONFIG_SYSCTL=y, CONFIG_BLK_DEV_IDECD=m,
>> CONFIG_BLK_DEV_SR=m, CONFIG_PARIDE_PCD=m, CONFIG_CDROM_PKTCDVD=m,
>> CONFIG_GDROM=n.
>>
>> I have used the block tree from next-20141110 for today.
>> --
>> Cheers,
>> Stephen Rothwell                    sfr@canb.auug.org.au
>
> Hi Stephen,
>
> Problem is in Makefile:
>
> obj-$(CONFIG_BLK_DEV_SR) += cdrom.o
> obj-$(CONFIG_PARIDE_PCD) += cdrom.o
> obj-$(CONFIG_CDROM_PKTCDVD) += cdrom.o
> +obj-$(CONFIG_SYSCTL) += cdrom_sysctl.o
>
> I tried cdrom-$(CONFIG_SYSCTL)  += cdrom_sysctl.o
> to add sysctl only when cdrom.o is created
>
> but now
>
> drivers/scsi/sr_mod.ko
> drivers/ide/ide-cd_mod.ko
> drivers/ide/ide-cd_mod.ko
>
> can't find cdrom.c functions ...
>
> Is there another way to do it ?

The problem is, now you can have cdrom/sr modular, but cdrom_sysctl.o is 
linked in. That's just not going to work. Instead of jumping through 
hoops to make this work, leave the section in cdrom.c and hid it behind a

#if defined(CONFIG_SYSCTL)
...
#endif

at the bottom or something.

-- 
Jens Axboe

