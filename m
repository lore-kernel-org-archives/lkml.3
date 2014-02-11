Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaBKSW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:22:29 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38192 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBKSW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:22:27 -0500
Message-ID: <52FA6A62.5010000@infradead.org>
Date: Tue, 11 Feb 2014 10:22:26 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gene Heskett <gheskett@wdtv.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: make oldfonfig broken.
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402101521.04113.gheskett@wdtv.com> <52F958D2.1070003@infradead.org> <201402101913.04969.gheskett@wdtv.com>
In-Reply-To: <201402101913.04969.gheskett@wdtv.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 04:13 PM, Gene Heskett wrote:
> On Monday 10 February 2014, Randy Dunlap wrote:
>> On 02/10/2014 12:21 PM, Gene Heskett wrote:
>>> On Monday 10 February 2014, Randy Dunlap wrote:
>>>> On 02/09/2014 08:32 PM, Gene Heskett wrote:
>>>> AUTOSELECT driver feature Better!  ugh.
>>>
>>> Spit.  I presume geneology discussions are off topic. :)
>>>
>>>> Good luck. Let me know if you need more guidance.
>>>
>>> Hat in hand, I figured I had better get the first one that fails,
>>> 3.2.40, to work before I carried that fwd to a more current kernel,
>>> but 5 or 6 builds & boot failure later I am stumped.
>>>
>>> The boot gets to top_init, reports the / drive is unavailable and it
>>> cannot load /lib/modules/3.2.40/modules.dep, which does exist.
>>>
>>> Stops, times out in about a minute and falls thru to the busybox shell,
>>> and of course my keyboard and mouse are wireless to usb, so neither
>>> work, reset button tap time.
>>>
>>> The only reason I can deduce is that because the drive isn't mounted,
>>> something is still missing, either in the vmlinuz file or in the initrd
>>> file.
>>>
>>> This most working 3.12.9 bootup shows:
>>>
>>> gene@coyote:~/src/linux-3.2.40$ lsmod |grep sata
>>> sata_nv                16890  12
>>> libata                146855  2 pata_amd,sata_nv
>>>
>>> And I'm pretty sure all that is in the initrd.
>>>
>>> Except according to grep, none of that is in
>>> /lib/modules/3.2.40/modules.dep
>>>
>>> And I cannot find anyplace in a make xconfig that mentions libata.
>>> So obviously my .config is still fubared. It does grep in the other
>>> modules.dep files for several other versions.
>>>
>>> In fact, no .config I have mentions it. At my age the hair is thinning
>>> quickly enough.
>>>
>>> So, Next please?  libata is missing, and so is sata_nv in spite of that
>>
>>> being enabled:
>> It's missing as a loadable module, but that's OK since it's builtin.
>>
>>> gene@coyote:~/src/linux-3.2.40$ grep SATA_NV .config
>>> CONFIG_SATA_NV=y
>>>
>>> But I see thats builtin, but it didn't help.
>>
>> Your .config has (I believe)
>> CONFIG_ATA=y
>> and that is what builds libata.
>>
>> Any other clues?
> 
> Not that I see in the build trace. grepping:
> gene@coyote:~/src/linux-3.2.40$ grep CONFIG_ATA .config
> CONFIG_ATALK=m
> # CONFIG_ATA_OVER_ETH is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> CONFIG_ATA_VERBOSE_ERROR=y
> CONFIG_ATA_ACPI=y
> CONFIG_ATA_SFF=y
> CONFIG_ATA_BMDMA=y
> # CONFIG_ATA_PIIX is not set
> CONFIG_ATA_GENERIC=m
> 
> And it seems to be building libata:
> gene@coyote:~/src/linux-3.2.40/drivers/ata$ ls -l|grep libata|grep .o
> -rw-r--r-- 1 root root  10236 2014-02-10 18:19 libata-acpi.o
> -rw-rw-r-- 1 gene gene 175870 2013-03-05 22:24 libata-core.c
> -rw-r--r-- 1 root root  89616 2014-02-10 18:19 libata-core.o
> -rw-r--r-- 1 root root  35904 2014-02-10 18:19 libata-eh.o
> -rw-r--r-- 1 root root 222732 2014-02-10 18:19 libata.o
> -rw-r--r-- 1 root root  12072 2014-02-10 18:19 libata-pmp.o
> -rw-r--r-- 1 root root  37156 2014-02-10 18:19 libata-scsi.o
> -rw-r--r-- 1 root root  40996 2014-02-10 18:19 libata-sff.o
> -rw-rw-r-- 1 gene gene  19559 2013-03-05 22:24 libata-transport.c
> -rw-rw-r-- 1 gene gene    536 2013-03-05 22:24 libata-transport.h
> -rw-r--r-- 1 root root  11772 2014-02-10 18:19 libata-transport.o
> 
> But libata.ko is not making it into the initrd, nor the modules.dep for 
> 3.2.40.
> 
> I been playing 20 monkeys changing one ata related thing at a time & doing 
> a sudo time -p ./makeit to check, not much use rebooting to check until I 
> see it.
> 
> I'll go gedit .config & change CONFIG_ATA to = m & try one more time.
> 
> Got it, test reboot time.  Made it 2 lines farther, "switching to clock 
> source TSC" then fell through to the busybox prompt with all inputs dead.
> 
> Sigh.
> 
> .config attached if you've got time.

You have ext[234] filesystems builtin. I suppose the rootfs is one of those?

Your .config file also has the ATA drivers as =m (loadable modules), but
I guess that you also tested with those drivers =y (builtin).

I don't see what the problem is.
You may need to try taking a photo of the failed boot and sending it to
the mailing list (and me) again, even though that has not worked for you
some time in the past.


-- 
~Randy
