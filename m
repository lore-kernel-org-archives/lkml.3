Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaJEJyX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 05:54:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaJEJyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 05:54:20 -0400
Message-ID: <54311549.4070808@redhat.com>
Date: Sun, 05 Oct 2014 11:54:17 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@web.de>, linux-usb <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: uas: module not loaded automatically
References: <54303DF6.4050203@web.de> <54310A74.3090404@redhat.com> <54310C04.5060008@web.de> <54310DF9.8070904@redhat.com> <54310FFF.10504@web.de> <543112A6.8070503@redhat.com> <543113FF.7050900@web.de>
In-Reply-To: <543113FF.7050900@web.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/05/2014 11:48 AM, Jan Kiszka wrote:
> On 2014-10-05 11:43, Hans de Goede wrote:
>> Hi,
>>
>> On 10/05/2014 11:31 AM, Jan Kiszka wrote:
>>> On 2014-10-05 11:23, Hans de Goede wrote:
>>>> Hi,
>>>>
>>>> On 10/05/2014 11:14 AM, Jan Kiszka wrote:
>>>>> On 2014-10-05 11:08, Hans de Goede wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 10/04/2014 08:35 PM, Jan Kiszka wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> my Delock external USB drive stopped working after updating from a
>>>>>>> UAS-disabled distro kernel to latest 3.17-rc7 with UAS on. That UAS was
>>>>>>> key became clear to me only after looking at storage_probe(): the device
>>>>>>> is ignored by usb-storage if it is UAS-capable. However, nothing causes
>>>>>>> uas.ko to be loaded when the drive is plugged here. How is this supposed
>>>>>>> to work in the normal case?
>>>>>>
>>>>>> Is the uas.ko module installed, and was depmod run after installing it ?
>>>>>
>>>>> Definitely. Just retried after another depmod -a, and only modprobe uas
>>>>> made it work.
>>>>>
>>>>>>
>>>>>> uas.c has the following:
>>>>>>
>>>>>>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_BULK) },
>>>>>>         { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, USB_SC_SCSI, USB_PR_UAS) },
>>>>>>
>>>>>> Which should make it load automatically on your device.
>>>>>
>>>>> Should this match with what lsusb -v reports for the device? 
>>>>
>>>> Yes, and it does, for both alt settings of your device:
>>>>
>>>>       bInterfaceClass         8 Mass Storage
>>>>       bInterfaceSubClass      6 SCSI
>>>>       bInterfaceProtocol     80 Bulk-Only
>>>>
>>>>       bInterfaceClass         8 Mass Storage
>>>>       bInterfaceSubClass      6 SCSI
>>>>       bInterfaceProtocol     98
>>>>
>>>> Where 98 == USB_PR_UAS, seems you have an quite old lsusb if it does not
>>>
>>> It says "007".
>>>
>>>> know that though. Could it be the rest of your userspace is old too, and is
>>>> not smart enough to load all matching drivers, instead only loading the first matching
>>>> driver (which happens to be usb-storage) ?
>>>
>>> OpenSUSE 13.1, all updates installed. Which components are involved?
>>> udev - Version 208? Below is the udevadm monitor output.
>>
>> Hmm, that is not all that old, I would expect that to work.
>>
>> Here is how things "work" on my system:
>>
>> [hans@shalem ~]$ lsmod | grep uas
>> uas                    22414  0
>> usb_storage            65065  1 uas
>> [hans@shalem ~]$ sudo rmmod uas
>> [hans@shalem ~]$ lsmod | grep uas
>> [hans@shalem ~]$ sudo modprobe usb:v174Cp5136d0100dc00dsc00dp00ic08isc06ip50in00
>> [hans@shalem ~]$ lsmod | grep uas
>> uas                    22414  0
>> usb_storage            65065  1 uas
>>
>> So as you can see the modalias taken from your udev debug output causes
>> uas to get loaded, can you try the above ?
> 
> That command sequence doesn't cause uas to be reloaded. Anything I need
> to customize for my setup?

Not that I know of, so this seems to be a modprobe issue, and this should
probably be taken to the relevant list for modprobe. Please put me in the CC
when you send a mail there, and you likely will want to include the output
of the above commands + the modinfo output for both uas and usb-storage.

> 
>>
>> Also what does "modinfo uas" say? For me it says:
>>
>> [hans@shalem ~]$ modinfo uas
>> filename:       /lib/modules/3.17.0-rc6+/kernel/drivers/usb/storage/uas.ko
>> author:         Hans de Goede <hdegoede@redhat.com>, Matthew Wilcox and Sarah Sharp
>> license:        GPL
>> alias:          usb:v*p*d*dc*dsc*dp*ic08isc06ip62in*
>> alias:          usb:v*p*d*dc*dsc*dp*ic08isc06ip50in*
>> alias:          usb:v174Cp5106d*dc*dsc*dp*ic*isc*ip*in*
>> alias:          usb:v152Dp0567d*dc*dsc*dp*ic*isc*ip*in*
>> alias:          usb:v0BC2pAB20d*dc*dsc*dp*ic*isc*ip*in*
>> alias:          usb:v0BC2p3312d*dc*dsc*dp*ic*isc*ip*in*
>> alias:          usb:v0BC2p2312d*dc*dsc*dp*ic*isc*ip*in*
>> depends:        usb-storage
>> vermagic:       3.17.0-rc6+ SMP mod_unload
>> signer:         Magrathea: Glacier signing key
>> sig_key:        9B:56:00:B2:C4:97:8D:4A:A9:B3:0B:54:32:F7:B7:B2:2F:3E:FB:D8
>> sig_hashalgo:   sha256
>>
>> Note the alias-es with vendor and product ids are from quirks, and your version
>> will likely not have these. But the first 2 generic ones should be there, and
>> match the modalias from the udev output.
> 
> filename:       /lib/modules/3.17.0-rc7-homebrewed+/kernel/drivers/usb/storage/uas.ko
> author:         Hans de Goede <hdegoede@redhat.com>, Matthew Wilcox and Sarah Sharp
> license:        GPL
> srcversion:     597B27EF314ADC559827CBD
> alias:          usb:v*p*d*dc*dsc*dp*ic08isc06ipAAin*
> alias:          usb:v*p*d*dc*dsc*dp*ic08isc06ip62in*
> alias:          usb:v*p*d*dc*dsc*dp*ic08isc06ip50in*
> depends:        usb-storage
> intree:         Y
> vermagic:       3.17.0-rc7-homebrewed+ SMP preempt mod_unload modversions 

That looks good, so no idea why modprobe is not loading it.

Regards,

Hans


