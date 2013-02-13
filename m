Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab3BMHoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 02:44:14 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45948 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588Ab3BMHoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 02:44:11 -0500
Date: Wed, 13 Feb 2013 08:44:09 +0100
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: initramfs@vger.kernel.org, Maximilian Attems <maks@debian.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] [nailed] USB boot failure: USB: EHCI: make ehci-pci
 a separate driver
Message-ID: <20130213074409.GA16043@rhlx01.hs-esslingen.de>
References: <CA+55aFz50VvnMjoDCbg01N+rMu5vscu88kr0SV3tWLjaiL0TeA@mail.gmail.com>
 <20130210001442.GA5744@rhlx01.hs-esslingen.de>
 <20130210140554.GA5299@rhlx01.hs-esslingen.de>
 <20130212160727.GA15857@rhlx01.hs-esslingen.de>
 <20130212161617.GA3887@kroah.com>
 <20130213064436.GA22583@rhlx01.hs-esslingen.de>
 <20130213071628.GA4211@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130213071628.GA4211@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC initramfs-tools]

On Wed, Feb 13, 2013 at 08:16:28AM +0100, Andreas Mohr wrote:
> Hi,
> 
> On Wed, Feb 13, 2013 at 07:44:36AM +0100, Andreas Mohr wrote:
> > So, what to do? I'm now going to do some experimentation with git revert
> > on some revision, and I'm trying to establish the USB port dependency
> > (BIOS-owned handoff root hub invisible!?, as discussed in initial mail).
> 
> 
> After some bingo moment, seems the solution is easier than expected:
> 
> andi@andinet:~$ ls /tmp/initrd_extracted/lib/modules/3.7.0-rc5+/kernel/drivers/usb/host/
> ehci-hcd.ko  ohci-hcd.ko  uhci-hcd.ko  xhci-hcd.ko
> andi@andinet:~$ ls /lib/modules/3.7.0-rc5+/kernel/drivers/usb/host/
> ehci-hcd.ko  isp116x-hcd.ko   sl811_cs.ko   uhci-hcd.ko
> ehci-pci.ko  ohci-hcd.ko      sl811-hcd.ko  whci
> hwa-hc.ko    r8a66597-hcd.ko  u132-hcd.ko   xhci-hcd.ko
> 
> So it's probably only that the initrd simply fails to ship
> the ehci-pci.ko module (I could verify this by extending initrd content, BTW).
> Now the question would be:
> are modules listed in a static list on initramfs package/config side,
> or does the kernel fail to signal the list of required modules properly?
> (e.g. did some config-side files fail to get upgraded for this dependency??)
> 
> 
> So maybe it's not a "regression" per se, but it's at least a grave
> usability issue on kernel upgrade which should be handled as benignly as
> possible (i.e., without any disruption).

OK, initramfs-tools hook-functions file contains (even in git master):

        for arg in "$@" ; do
                case "$arg" in
                base)
                        modules="$modules ehci-hcd ohci-hcd uhci-hcd
usbhid"
                        modules="$modules xhci xhci-hcd"
                        modules="$modules hid-apple hid-cherry
hid-generic"
                        modules="$modules hid-logitech hid-logitech-dj"
                        modules="$modules hid-microsoft hid-sunplus"
                        modules="$modules btrfs ext2 ext3 ext4 ext4dev "
                        modules="$modules isofs jfs nfs reiserfs udf
xfs"
                        modules="$modules af_packet atkbd i8042
virtio_pci"
                ;;


So it seems it actually *is* the user side (initramfs-tools) which has
to maintain knowledge of all dependencies in a painfully maintained
hard-coded list, and it seems this change is now making it croak,
due to not knowing about the newly split extra ehci-pci.ko.

Questions:
- is this mechanism how one would want things to be?
  (is there a way to cleanly provide the accurately updated list
  from the kernel side? Or is there a scripted mechanism to at least extract
  all required *dependee* modules from the list of the ones that we
  already know of? That would have saved our a** here...)
- was this module change properly communicated sufficiently in advance,
  to (all/most of) some affected parties?
  If not, might want to do better next time if that's possible...
- should ehci-pci be added to the literal list now (and does this work
  properly on kernels which don't have it??), to get back to a working
  state ASAP?

Thanks,

Andreas Mohr
