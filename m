Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953AbbAJAbH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 19:31:07 -0500
Received: from us-mx2.synaptics.com ([192.147.44.131]:44565 "EHLO
	us-mx1.synaptics.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751381AbbAJAbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 19:31:06 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Fri, 09 Jan 2015 16:58:40 -0800
Message-ID: <54B07250.5030803@synaptics.com>
Date: Fri, 9 Jan 2015 16:29:04 -0800
From: Andrew Duggan <aduggan@synaptics.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
CC: Mika Westerberg <mika.westerberg@linux.intel.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <benjamin.tissoires@redhat.com>, <jkosina@suse.cz>
Subject: Re: NULL pointer dereference in i2c-hid
References: <31518562.V5Oyo0POsI@xps13> <1877487.FqOELR9dBu@xps13> <54AF19BE.9010506@synaptics.com> <1940829.tOcs3CnnyV@xps13>
In-Reply-To: <1940829.tOcs3CnnyV@xps13>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.4.10.98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 12:04 AM, Gabriele Mazzotta wrote:
> On Thursday 08 January 2015 15:58:54 Andrew Duggan wrote:
>> On 12/24/2014 03:53 PM, Gabriele Mazzotta wrote:
>> [...snip...]
>>>>>> Also, if you can get the firmware id from your touchpad that would also
>>>>>> be useful.
>>>>>>
>>>>>> $ sudo ./rmihidtool -f /dev/hidraw0
>>>>> firmware id: 1522295
>>>> Thanks, I will see if I can get any additional information on this.
>>>>
>>>> Andrew
>>> Hi,
>>>
>>> I think I found the source of the problem.
>>>
>>> $ ./rmihidtool /dev/hidraw1 -r 0x50 1
>>> 0x01  #PalmDetect Interrupt Enable, right?
>> Yes, 0x50 does appear to be the address of the palm detect interrupt
>> enable register.
>>> $ ./rmihidtool /dev/hidraw1 -w 0x50 0  #Disable PalmDetect Interrupt
>>>
>>> It makes more sense now that widths greater than 12 trigger the bug.
>> That is weird behavior and I haven't seen anything like that before. I
>> will file a bug to see if firmware has any idea why this is happening.
> According to the RMI4 specification, gesture interrupts are cleared
> only once specific flag registers, F11_2D_Data8 and F11_2D_Data9, are
> read. So I tried to read those register and found that the following
> command stops the events:

It is unusual to see firmware gestures enabled for HID/I2C touchpads. In 
fact none of the touchpads I have have that functionality enabled, which 
is why I haven't been able to test. On HID touchpads there is a layer in 
the firmware which reads the RMI registers and packs them into the HID 
attention report. My guess is that the HID layer is not reading 
F11_2D_Data8 or 9 causing it to assert indefinitely. Since this isn't a 
common firmware configuration that is probably why this hasn't been 
observed before.

> $ rmihidtool /dev/hidraw1 -r 0x24 1  # I was looking for F11_2D_Data8
>
> I'm not sure I got the right address as reading any register close to
> 0x24 (such as 0x25, 0x26) has the same effect. I would have expected
> this to happen only reading one specific register.

With this firmware, F11_2D_Data8 should be at 0x3A. It's 2 bytes for 
finger state + 5 bytes per finger * 5 fingers for abs data  + 2 bytes 
per finger * 5 fingers for rel data. I'm not sure why reading 0x24 would 
stop the reports though.

>
> I also honestly don't know why palms are detected when the width is at
> least 12, PalmDetectThreshold is 0 and so the palm detection should
> be inhibited.
>

This seems to be set in the firmware config. It looks like 
PalmDetectThreshold is only used when the reporting mode is 001. The 
default reporting mode looks like it is 000.

>>> Gabriele
>>>
>> Andrew
Thanks for provide all of this detail.

Andrew
