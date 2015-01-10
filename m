Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbbAJBSm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 20:18:42 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36652 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAJBSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 20:18:40 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        benjamin.tissoires@redhat.com, jkosina@suse.cz
Subject: Re: NULL pointer dereference in i2c-hid
Date: Sat, 10 Jan 2015 02:18:36 +0100
Message-ID: <2350742.rjWRas2JQA@xps13>
In-Reply-To: <54B07250.5030803@synaptics.com>
References: <31518562.V5Oyo0POsI@xps13> <1940829.tOcs3CnnyV@xps13> <54B07250.5030803@synaptics.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 January 2015 16:29:04 Andrew Duggan wrote:
> On 01/09/2015 12:04 AM, Gabriele Mazzotta wrote:
> > On Thursday 08 January 2015 15:58:54 Andrew Duggan wrote:
> >> On 12/24/2014 03:53 PM, Gabriele Mazzotta wrote:
> >> [...snip...]
> >>>>>> Also, if you can get the firmware id from your touchpad that would also
> >>>>>> be useful.
> >>>>>>
> >>>>>> $ sudo ./rmihidtool -f /dev/hidraw0
> >>>>> firmware id: 1522295
> >>>> Thanks, I will see if I can get any additional information on this.
> >>>>
> >>>> Andrew
> >>> Hi,
> >>>
> >>> I think I found the source of the problem.
> >>>
> >>> $ ./rmihidtool /dev/hidraw1 -r 0x50 1
> >>> 0x01  #PalmDetect Interrupt Enable, right?
> >> Yes, 0x50 does appear to be the address of the palm detect interrupt
> >> enable register.
> >>> $ ./rmihidtool /dev/hidraw1 -w 0x50 0  #Disable PalmDetect Interrupt
> >>>
> >>> It makes more sense now that widths greater than 12 trigger the bug.
> >> That is weird behavior and I haven't seen anything like that before. I
> >> will file a bug to see if firmware has any idea why this is happening.
> > According to the RMI4 specification, gesture interrupts are cleared
> > only once specific flag registers, F11_2D_Data8 and F11_2D_Data9, are
> > read. So I tried to read those register and found that the following
> > command stops the events:
> 
> It is unusual to see firmware gestures enabled for HID/I2C touchpads. In 
> fact none of the touchpads I have have that functionality enabled, which 
> is why I haven't been able to test. On HID touchpads there is a layer in 
> the firmware which reads the RMI registers and packs them into the HID 
> attention report. My guess is that the HID layer is not reading 
> F11_2D_Data8 or 9 causing it to assert indefinitely. Since this isn't a 
> common firmware configuration that is probably why this hasn't been 
> observed before.
> 
> > $ rmihidtool /dev/hidraw1 -r 0x24 1  # I was looking for F11_2D_Data8
> >
> > I'm not sure I got the right address as reading any register close to
> > 0x24 (such as 0x25, 0x26) has the same effect. I would have expected
> > this to happen only reading one specific register.
> 
> With this firmware, F11_2D_Data8 should be at 0x3A. It's 2 bytes for 
> finger state + 5 bytes per finger * 5 fingers for abs data  + 2 bytes 
> per finger * 5 fingers for rel data. I'm not sure why reading 0x24 would 
> stop the reports though.

Yes, this seems to be the right one, I can see the things I was
expecting to see. That's why I kind of knew that 0x24 wasn't right,
but I was surprised to see the problem disappear by reading that
register, so I didn't bother do the math. Thanks for doing it for me.

Anyway, I can see PalmDetect set to 1 in register 0x3B and the
interrupts stop as soon as I read it.

> >
> > I also honestly don't know why palms are detected when the width is at
> > least 12, PalmDetectThreshold is 0 and so the palm detection should
> > be inhibited.
> >
> 
> This seems to be set in the firmware config. It looks like 
> PalmDetectThreshold is only used when the reporting mode is 001. The 
> default reporting mode looks like it is 000.

For some reason, mode 001 is not working. I tried it time ago as an
attempt to reduce the power consumption, but as soon as switched to it,
the touchpad stopped working as intended. In that mode, nothing happens
until I click and when I do that, I can see something going on while
I move the finger. But this has nothing to do with the problem here
discussed. The interesting thing is that whichever mode I set, as soon
as the width of the finger reaches 12, everything starts working as
if the reporting mode was 000. This means that as long as the palm
detect interrupt is enabled, palms are detected regardless of the mode.

Gabriele
