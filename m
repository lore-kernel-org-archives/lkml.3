Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817AbaLKSre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 13:47:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbaLKSrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 13:47:33 -0500
Date: Thu, 11 Dec 2014 13:47:30 -0500
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB driver fixes for 3.18-rc7
Message-ID: <20141211184730.GA12817@kroah.com>
References: <20141128224028.GA29538@kroah.com>
 <CA+55aFyJunLbQPBgUf4rhZN0vbaj7hpK3Jwqwqf-S7A2-LLhFA@mail.gmail.com>
 <20141202181810.GB15869@kroah.com>
 <547F3400.6030400@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547F3400.6030400@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 06:02:08PM +0200, Mathias Nyman wrote:
> On 02.12.2014 20:18, Greg KH wrote:
> > On Sun, Nov 30, 2014 at 11:47:20AM -0800, Linus Torvalds wrote:
> >> Hmm, Greg.
> >>
> >> I seem to get this problem possibly more commonly at boot these days:
> >>
> >>   usb 1-6: new full-speed USB device number 2 using xhci_hcd
> >>   usb 1-6: device descriptor read/64, error -71
> >>   xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1.
> >>   usb 1-6: hub failed to enable device, error -22
> >>   usb 1-6: new full-speed USB device number 3 using xhci_hcd
> >>   usb 1-6: device descriptor read/64, error -71
> >>   usb 1-6: hub failed to enable device, error -22
> >>   usb 1-6: new full-speed USB device number 4 using xhci_hcd
> >>   usb 1-6: Device not responding to setup address.
> >>   usb 1-6: Device not responding to setup address.
> >>   usb 1-6: device not accepting address 4, error -71
> >>   usb 1-6: new full-speed USB device number 5 using xhci_hcd
> >>   usb 1-6: Device not responding to setup address.
> >>   usb 1-6: Device not responding to setup address.
> >>   usb 1-6: device not accepting address 5, error -71
> >>  usb usb1-port6: unable to enumerate USB device
> >>
> >> and my keyboard doesn't work. I then unplug and re-plug it, and get
> >>
> >>   usb 1-6: new full-speed USB device number 9 using xhci_hcd
> >>   usb 1-6: New USB device found, idVendor=2516, idProduct=0020
> >>   usb 1-6: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> >>   usb 1-6: Product: Quickfire Rapid i
> >>   usb 1-6: Manufacturer: CM Storm
> >>
> >> Any ideas? Some setup delay that isn't long enough at boot time for a
> >> slightly finicky device? It has happened before, but now I've gotten
> >> it twice within a couple of days:
> >>
> >>   Nov 02 12:18:56 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
> >>   Nov 28 16:54:06 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
> >>   Nov 30 11:26:35 i7.lan kernel: usb 1-6: device descriptor read/64, error -71
> >>
> >> (I've had this keyboard since mid-September, and looking at the logs
> >> this machine has been rebooted 41 times since, with those three
> >> failures..)
> > 
> > I've been seeing this occasionally recently as well, but was blaming a
> > "bad" USB 3 hub I have here that I use, and the problem goes away with a
> > replug.
> > 
> > Mathias, any ideas what is going on here?
> > 
> 
> Looks like when xhci changed to use "new scheme" device enumeration for non
> SuperSpeed devices, we broke the device descriptor read retry for xhci.
> 
> Normally we try to read the descriptor again, and if it still fails then fall back
> to old scheme. In this failing xhci case the slot is left in a default state after
> first failed descriptor read, and we then try to enable the slot again in retry, 
> which is an invalid xhci context state change, and prints the error message:
> 
> xhci_hcd 0000:00:14.0: Setup ERROR: setup context command for slot 1

I see this all the time on my MinnowboardMax.  For slot 2 that is.

And on this machine, it does not boot from USB properly, I have to,
after the kernel comes up (which was read off of USB by UEFI just fine),
unplug and plug the storage device back in so that the boot process
continues.

Works that way for 2 different USB 3.0 storage devices.

> After this It might be hard to get the device addressed. 
> 
> I don't know why it fail the first device descriptor read, but fixing the xhci part
> should allow more real reties. I'll work on it.
> 
> The change to use xhci "new scheme" enumeration was done in 3.14 to support known
> legacy devices requiring it. commit 48fc7dbd52c0559647291f33a10ccdc6cdbe4c72

How can that break "non-legacy" devices?

thanks,

greg k-h
