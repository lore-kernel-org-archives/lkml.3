Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992AbbAIIEy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 03:04:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:64640 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755745AbbAIIEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 03:04:52 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Andrew Duggan <aduggan@synaptics.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        benjamin.tissoires@redhat.com, jkosina@suse.cz
Subject: Re: NULL pointer dereference in i2c-hid
Date: Fri, 09 Jan 2015 09:04:48 +0100
Message-ID: <1940829.tOcs3CnnyV@xps13>
In-Reply-To: <54AF19BE.9010506@synaptics.com>
References: <31518562.V5Oyo0POsI@xps13> <1877487.FqOELR9dBu@xps13> <54AF19BE.9010506@synaptics.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2015 15:58:54 Andrew Duggan wrote:
> On 12/24/2014 03:53 PM, Gabriele Mazzotta wrote:
> [...snip...]
> >>>> Also, if you can get the firmware id from your touchpad that would also
> >>>> be useful.
> >>>>
> >>>> $ sudo ./rmihidtool -f /dev/hidraw0
> >>> firmware id: 1522295
> >> Thanks, I will see if I can get any additional information on this.
> >>
> >> Andrew
> > Hi,
> >
> > I think I found the source of the problem.
> >
> > $ ./rmihidtool /dev/hidraw1 -r 0x50 1
> > 0x01  #PalmDetect Interrupt Enable, right?
> Yes, 0x50 does appear to be the address of the palm detect interrupt 
> enable register.
> > $ ./rmihidtool /dev/hidraw1 -w 0x50 0  #Disable PalmDetect Interrupt
> >
> > It makes more sense now that widths greater than 12 trigger the bug.
> That is weird behavior and I haven't seen anything like that before. I 
> will file a bug to see if firmware has any idea why this is happening.

According to the RMI4 specification, gesture interrupts are cleared
only once specific flag registers, F11_2D_Data8 and F11_2D_Data9, are
read. So I tried to read those register and found that the following
command stops the events:

$ rmihidtool /dev/hidraw1 -r 0x24 1  # I was looking for F11_2D_Data8

I'm not sure I got the right address as reading any register close to
0x24 (such as 0x25, 0x26) has the same effect. I would have expected
this to happen only reading one specific register.

I also honestly don't know why palms are detected when the width is at
least 12, PalmDetectThreshold is 0 and so the palm detection should
be inhibited.

> >
> > Gabriele
> >
> Andrew

