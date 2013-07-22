Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab3GVH7F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 03:59:05 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:34981 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab3GVH7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 03:59:00 -0400
MIME-Version: 1.0
In-Reply-To: <51ECDDE3.1040209@ti.com>
References: <1372656552-18824-1-git-send-email-george.cherian@ti.com>
 <20130702032712.GD6262@xanatos> <CANqatMA869UoTFDvSAO1P4OKsiVf+qyXbCrpHDOhm4+TMZ2cGA@mail.gmail.com>
 <51ECDDE3.1040209@ti.com>
From: Shuduo Sang <sangshuduo@gmail.com>
Date: Mon, 22 Jul 2013 15:58:19 +0800
Message-ID: <CANqatMDrfV9+3ONnuZLN7xsp-TOoxHG2TV4a01EH2p8Z+zefWA@mail.gmail.com>
Subject: Re: [PATCH v2] usb: host: xhci: Enable XHCI_SPURIOUS_SUCCESS for all
 controllers with xhci 1.0
To: George Cherian <george.cherian@ti.com>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-usb <linux-usb@vger.kernel.org>, balbi <balbi@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        gregkh <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 3:23 PM, George Cherian <george.cherian@ti.com> wrote:
>
> Hi Shuduo,
>
>
> On 7/22/2013 12:35 PM, Shuduo Sang wrote:
>>
>> Hi Sarah and George,
>>
>> I met this issue at my side too. Per lspci output and HCIVERSION, I
>> see the host is Lynx
>> Point xhci 1.0 host.
>>
>> I notice George's patch has not been merged in kernel 3.11-rc1.
>
>
> Just to make sure, without the patch are you getting the following error.
>
>
> "ERROR Transfer event TRB DMA ptr not part of current TD"
>

Yes, I run below script to capture picture.

#!/bin/bash
# camera_stress.sh
# Testing the camera by BinLi

for ((i=0; i<10 ; i++))
do
        fswebcam --no-banner -r 352x288 -d /dev/video0 test_$i.jpg
done

It will randomly fail at later loops. The fail rate about 20%~30%. When it fail,
I can see error messages by dmesg as below:

[ 68.171039] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA ptr
not part of current TD
[ 68.175030] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA ptr
not part of current TD
[ 68.179026] xhci_hcd 0000:00:14.0: ERROR Transfer event TRB DMA ptr
not part of current TD
[ 68.180082] usb 3-12: USB disconnect, device number 4
[ 68.450459] usb 3-12: new high-speed USB device number 5 using xhci_hcd
[ 68.477960] usb 3-12: New USB device found, idVendor=5986, idProduct=0397
[ 68.477964] usb 3-12: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[ 68.477966] usb 3-12: Product: Integrated Camera
[ 68.477968] usb 3-12: Manufacturer: Vimicro corp.
[ 68.479107] uvcvideo: Found UVC 1.00 device Integrated Camera (5986:0397)
[ 68.479821] input: Integrated Camera as
/devices/pci0000:00/0000:00:14.0/usb3/3-12/3-12:1.0/input/input15
[ 321.389721] type=1400 audit(1374214638.182:29): apparmor="DENIED"
operation="capable" parent=1 profile="/usr/sbin/cupsd" pid=1232
comm="cupsd" pid=1232 comm="cupsd" c
apability=36 capname="block_suspend"



>
>> Then I manually applied George's patch against 3.10.0 but the issue
>> still happen when I use
>> camera to capture picture.
>
>
> Can you explain what is the exact issue you face after applying the patch?
> Are you still getting
>
>
> "ERROR Transfer event TRB DMA ptr not part of current TD"
>

Yes, after I applied your patch manually, I still getting this error.
Seems fail rate is same.

>> So I doubt some corner test has not been
>> covered by patch.
>> Pls let me know what I can do if you need more information.
>>
>> Thanks,
>> Shuduo
>>
>> On Tue, Jul 2, 2013 at 11:27 AM, Sarah Sharp
>> <sarah.a.sharp@linux.intel.com> wrote:
>>>
>>> Thanks George, this looks fine.  I will munge the description a bit when
>>> I commit it, and mark it for stable as well.
>>>
>>> Unfortunately, due to the timing of the merge window, this patch will
>>> have to wait for 2-3 weeks until 3.11-rc1 is out.
>>>
>>> Sarah Sharp
>>>
>>> On Mon, Jul 01, 2013 at 10:59:12AM +0530, George Cherian wrote:
>>>>
>>>> Xhci controllers with hci_version > 0.96 gives spurious success
>>>> events on short packet completion. During webcam capture the
>>>> "ERROR Transfer event TRB DMA ptr not part of current TD" was observed.
>>>> The same application works fine with synopsis controllers hci_version
>>>> 0.96.
>>>> The same Issue is seen with Intel Pantherpoint xhci controller. So
>>>> enabling
>>>> this quirk in xhci_gen_setup if controller verion is greater than 0.96.
>>>> For xhci-pci move the quirk to much generic place xhci_gen_setup.
>>>>
>>>> Signed-off-by: George Cherian <george.cherian@ti.com>
>>>> ---
>>>>   drivers/usb/host/xhci-pci.c | 1 -
>>>>   drivers/usb/host/xhci.c     | 7 +++++++
>>>>   2 files changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
>>>> index cc24e39..f00cb20 100644
>>>> --- a/drivers/usb/host/xhci-pci.c
>>>> +++ b/drivers/usb/host/xhci-pci.c
>>>> @@ -93,7 +93,6 @@ static void xhci_pci_quirks(struct device *dev, struct
>>>> xhci_hcd *xhci)
>>>>        }
>>>>        if (pdev->vendor == PCI_VENDOR_ID_INTEL &&
>>>>                        pdev->device ==
>>>> PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI) {
>>>> -             xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
>>>>                xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
>>>>                xhci->limit_active_eps = 64;
>>>>                xhci->quirks |= XHCI_SW_BW_CHECKING;
>>>> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
>>>> index d8f640b..0f7be59 100644
>>>> --- a/drivers/usb/host/xhci.c
>>>> +++ b/drivers/usb/host/xhci.c
>>>> @@ -4697,6 +4697,13 @@ int xhci_gen_setup(struct usb_hcd *hcd,
>>>> xhci_get_quirks_t get_quirks)
>>>>
>>>>        get_quirks(dev, xhci);
>>>>
>>>> +     /* In xhci controllers which follow xhci 1.0 spec gives a spurious
>>>> +      * success event after a short transfer. This quirk will ignore
>>>> such
>>>> +      * spurious event.
>>>> +      */
>>>> +     if (xhci->hci_version > 0x96)
>>>> +             xhci->quirks |= XHCI_SPURIOUS_SUCCESS;
>>>> +
>>>>        /* Make sure the HC is halted. */
>>>>        retval = xhci_halt(xhci);
>>>>        if (retval)
>>>> --
>>>> 1.8.1.4
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>
>
> --
> -George
>
