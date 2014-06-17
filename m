Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784AbaFQXCY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 19:02:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57968 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbaFQXCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 19:02:22 -0400
Date: Tue, 17 Jun 2014 16:06:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Bin Wang <binw@marvell.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Norbert Ciosek <norbertciosek@gmail.com>
Subject: Re: [GIT PULL] char/misc driver patches for 3.16-rc1
Message-ID: <20140617230618.GA22780@kroah.com>
References: <20140603054434.GB2921@kroah.com>
 <CA+55aFyQ=iSMnLAywumYpGBOBiqxL2qO9u9OsTF=RFfYBnz10g@mail.gmail.com>
 <20140603170244.GA22867@kroah.com>
 <CA+55aFwMEigYZGeF4sFTSpmnvb8YQ3hOndjNrd9ObL2EdOptgQ@mail.gmail.com>
 <20140603182555.GA28541@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603182555.GA28541@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 11:25:55AM -0700, Greg KH wrote:
> On Tue, Jun 03, 2014 at 10:14:41AM -0700, Linus Torvalds wrote:
> > On Tue, Jun 3, 2014 at 10:02 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> > > Hm, I got two different bug reports, and this same patch from two
> > > different people insisting that we broke their drivers with the above
> > > patches, and asked for this patch to be applied.
> > 
> > So I do think that we might be able to apply this patch, but I think
> > it needs a *lot* more thought than was obviously spent on it so far.
> > 
> > For example, right now it's actively insecure. Do we care? Maybe we
> > don't. The user-space uio side presumably is root-owned, and hopefully
> > trusted.
> 
> It better be trusted, as userspace has access to the "raw" hardware
> here, and is getting notified about every irq that happens to the
> device.
> 
> > And what about the unaligned mmio case? Are people somehow
> > guaranteeing that the regions is page-aligned, even if it isn't
> > page-sized?
> > 
> > What is the actual hardware in question?
> 
> Here are two email threads that I had about this, first from Bin that
> is the patch I applied:
> 	https://lkml.org/lkml/2014/3/25/11
> 
> And this one with Nobuhiro that goes into details a bit more:
> 	https://lkml.org/lkml/2014/3/11/707
> 
> Showing how a small memory window of the device is now broken without
> this change.
> 
> And this one that didn't get an answer from anyone from Norbert:
> 	https://lkml.org/lkml/2014/4/18/47
> showing how the changes you referred to broke his hardware access as
> well for the same reasons.
> 
> Bin, Nobuhiro, Norbert, anything else you want to bring up about this as
> your hardware is affected?
> 
> Norbert, it is commit ddb09754e6c7239e302c7b675df9bbd415f8de5d now in
> Linus's tree.
> 
> > Basically, it's an obvious security issue, and we shouldn't just say
> > "whatever". But maybe - with lots of commentary about why the security
> > implications aren't actually bad in _practice_, and why things are
> > always page-aligned even if they aren't page-sized, we can say "ok,
> > it's wrong, but we can still do it because xyz".
> 
> I think that if the size of the io range is smaller than a page, we
> still want to give access to the hardware.  I guess we can require that
> userspace ask for the whole page size, but even if we do that, it's
> still accessing data "off the end" of the device and that is unknown
> what's going to happen as we are mmaping physical memory here, not
> virtual.

Ok, given that NO ONE has responded to this thread that had previously
wanted this patch to be accepted (including the original author), I'm
going to revert it now and push that change to Linus soon.  If someone
wants to justify this change is needed, feel free to send another patch
sometime in the future with a whole bunch of explanation...

thanks,

greg k-h
