Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965560AbaH0Xnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 19:43:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59533 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935743AbaH0Xnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 19:43:51 -0400
Date: Wed, 27 Aug 2014 16:43:50 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Felipe Balbi <balbi@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: net2280: Remove pci_class from PCI_TABLE
Message-ID: <20140827234350.GB12195@kroah.com>
References: <1409144429-23723-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140827192547.GB9620@kroah.com>
 <CAPybu_1-pgEc5cwRPggm60UHKCceQZGAiyzjGqOhDZJedbkE8w@mail.gmail.com>
 <20140827202204.GA13047@kroah.com>
 <87a96p7i8b.fsf@nemi.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a96p7i8b.fsf@nemi.mork.no>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 11:09:08PM +0200, Bjørn Mork wrote:
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> > On Wed, Aug 27, 2014 at 09:39:43PM +0200, Ricardo Ribalda Delgado wrote:
> >> 
> >> return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
> 
> That final 'x' does look like a typo, doesn't it?  We are otherwise
> consistently using upper-case hex digits for field values and lower case
> letter for field names.  But it looks like it has been like that since
> the beginning, so it might be difficult to fix...

Yes, it should be fixed, sorry, my later email said that, no one has hit
it in 9+ years, pretty impressive.

> > No, the root cause of the problem is a userspace tool looking at a hex
> > value as a string and not a number.  It doesn't matter if we print it in
> > upper or lower case, it's a digit, not a string.  Do the numeric
> > compare, not a string compare.
> 
> Now I don't really know much about the history here, but the format of
> module aliases, using wildcards, seem to suggest a string match to me.
> Do you really mean that these strings should be parsed into field names
> + values before matching?  If that was the intention then surely we
> would have exported the fields one-by-one as separate sysfs attributes?
> Ref the "one value per file" policy.

No, this is a bit field, so you can't do a string compare.  kmod should
know how do handle this, it does so for other types of "class" fields in
module device ids.

And no, we didn't export these as a set of files, it's one unique value
that you can use to match up a device to a driver.

> >> Not many drivers define the pci interface and there is no other driver
> >> that has the same vendor  and product id. Therefore I see no hurt in
> >> adding both patches, one to make the driver broader, and another to
> >> fix pci-sysfs.
> >> 
> >> Also, the change on pci-sysfs might affect more stuff and therefore
> >> take longer to be applied.
> >
> > As we have been printing the value to userspace in this way for well
> > over a decade now, and nothing has changed, I say it's a userspace bug
> > that you should fix instead.  Don't work around broken user programs in
> > the kernel by changing something that has been stable for 10+ years.
> >
> > Ok, sorry, not 10+ years, the commit was written May of 2005, so 9
> > years.
> 
> well, just looking at a few common PCI devices on my PCs I wonder if the
> reason this hasn't been a problem is because there are _very_ few PCI
> programming interfaces using anything by 0-9 digits.  One?  Looking at the
> modules built by Debian I can only find one udc module matching on any
> hex value:
> 
>  bjorn@nemi:~$  grep pci: /lib/modules/3.16-trunk-amd64/modules.alias|egrep "i[A-F]"
>  alias pci:v000010DBd00008808sv*sd*bc0Csc03iFE* pch_udc
>  alias pci:v000010DBd0000801Dsv*sd*bc0Csc03iFE* pch_udc
>  alias pci:v00008086d00008808sv*sd*bc0Csc03iFE* pch_udc
> 
> This makes me wonder if this is exclusively a problem for PCI UDCs,
> which tend to be pretty rare devices?

Yes, this is a rare thing, as the age of this line proves :)

thanks,

greg k-h
