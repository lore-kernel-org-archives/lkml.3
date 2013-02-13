Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758329Ab3BMEdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 23:33:00 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:50256 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752035Ab3BMEc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 23:32:59 -0500
MIME-Version: 1.0
In-Reply-To: <1661570408.42886.1360700013207.JavaMail.mail@webmail03>
References: <587312497.6453.1360650312498.JavaMail.mail@webmail01>
 <CA+55aFyscOeZUPaYj_-QYgjADPD59+=c5aMvtpPEnd1tmpUGiA@mail.gmail.com>
 <1362466310.40337.1360693775935.JavaMail.mail@webmail03> <CA+55aFyK1zhNerWHkd=FMMeTH_sfiL4sBFq00y4n5eAJ88Z_cA@mail.gmail.com>
 <1661570408.42886.1360700013207.JavaMail.mail@webmail03>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Feb 2013 21:26:44 -0700
Message-ID: <CAErSpo7qj2SNR7BfuBsfF-saZXvgcqqLtgoP5Hyb5u99qR4Ncg@mail.gmail.com>
Subject: Re: Abysmal HDD/USB write speed after sleep on a UEFI system
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc linux-pci, Rafael, Alan]

[https://bugzilla.kernel.org/show_bug.cgi?id=53551]

On Tue, Feb 12, 2013 at 1:13 PM, Artem S. Tashkinov <t.artem@lycos.com> wrote:
> Feb 13, 2013 01:32:53 AM, Linus Torvalds wrote:
> On Tue, Feb 12, 2013 at 10:29 AM, Artem S. Tashkinov wrote:
>>> Feb 12, 2013 11:30:20 PM, Linus Torvalds wrote:
>>>>
>>>>A few things to try to pinpoint:
>>>>
>>>> (a) Is it *only* write performance that suffers, or is it other
>>>>performance too? Networking (DMA? Perhaps only writing *to* the
>>>>network?)? CPU?
>>>
>>> I  've tested hdpard -tT --direct and the output on boot and after suspend
>>> is quite similar.
>>>
>>> I  've also checked my network read/write speed, and it  's the same
>>> ~ 100MBit/sec (I have no 1Gbit computers on my network
>>> unfortunately).
>>
>>Ok. So it really sounds like just USB and HD writes. Which is quite
>>odd, since they have basically nothing in common I can think of
>>(except the obvious block layer issues).
>>
>>>> (b) the fact that it apparently happens with both SATA and USB
>>>>implies that it    's neither, and is more likely something core like
>>>>memory speed (mtrr, caching) or PCI (DMA, burst sizes, whatever).
>>>
>>> I  've no idea, please, check my bug report where I  've just added lots of
>>> information including a diff between on boot and after suspend.
>>
>>I  'm not seeing anything particularly interesting there.
>>
>>Except why/how did the MSI address/data change for the SATA
>>controller? The irq itself hasn  't changed.. There  's probably some sane
>>reason for that too (it  's an odd encoding, maybe they code for the
>>same thing), and there  's nothing like that for USB, so...
>>
>>And if it was irq problems, I  'd expect you to see it more for reads
>>than for writes anyway. Along with a few messages about missed irqs
>>and whatever.
>>
>>I'm stumped, and have no ideas. I can  't even begin to guess how this
>>would happen. One thing to try is if it happens for all USB ports (you
>>have multiple controllers) and I assume performance doesn  't come back
>>if you unplug and replug the USB disk..
>
> I've just plugged and unplugged my USB stick into all available hubs
> (including a USB3 one, that is xhci_hcd) and I've got the same write speed
> on all of them - around 930KB/sec (quite a weird number - as if I'm on USB
> 1.1) - lsusb says I'm happily running ehci_hcd/2p, 480M and xhci_hcd/2p,
> 5000M.
>
> The only pattern that I see here is that write speed to real devices degrades,
> tmpfs write speed stays the same:
>
> $ dd if=/dev/zero of=test bs=32M count=32
> 32+0 records indegrade
> 32+0 records out
> 1073741824 bytes (1.1 GB) copied, 0.296323 s, 3.6 GB/s

I'm sort of stumped here, too.  For the SATA controller, the only
PCI-related difference I see is the change in the MSI address, which
should just change the target CPU, which doesn't seem like it should
make this much difference.  But could you try this after the resume:

    $ sudo setpci -s00:1f.2 0x84.L=0xfee0400c

to set the MSI address back to the original value to see if it makes a
difference?

The XHCI controllers both have Unsupported Request errors logged.  I
assume these are related to the suspend/resume, and it seems like we
ought to either avoid them or clean them up somehow, but I don't know
enough about AER, and I don't know whether they would cause the
performance issue you're seeing.

There should be more AER logging than is decoded by lspci, so can you
also collect the output of "lspci -vvv -xxxx"?  That will include the
raw logging registers that lspci doesn't decode.

Bjorn
