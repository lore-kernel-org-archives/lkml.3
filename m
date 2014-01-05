Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaAESSe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 13:18:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:42905 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbaAESSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 13:18:33 -0500
Date: Sun, 5 Jan 2014 21:18:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: Hartley Sweeten <HartleyS@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        "pisa@cmp.felk.cvut.cz" <pisa@cmp.felk.cvut.cz>
Subject: Re: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
Message-ID: <20140105181831.GG30234@mwanda>
References: <1388453796-17088-1-git-send-email-lisovy@gmail.com>
 <1388453796-17088-2-git-send-email-lisovy@gmail.com>
 <DC148C5AA1CEBA4E87973D432B1C2D8817E5C72E@P3PWEX4MB008.ex4.secureserver.net>
 <1388934244.732.37.camel@lolumad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388934244.732.37.camel@lolumad>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 05, 2014 at 04:04:04PM +0100, Rostislav Lisovy wrote:
> Hello Hartley (and Dan);
> Thank you for the review. I do agree with most of the things, however I
> would like to explain/discuss a few of them...
> 
> On Thu, 2014-01-02 at 18:38 +0000, Hartley Sweeten wrote: 
> > On Monday, December 30, 2013 6:37 PM, Rostislav Lisovy wrote:
> > >
> > >  create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
> > 
> > Hello Rostislav,
> > 
> > As pointed out by Dan Carpenter, you need to add a change log and
> > Signed-off-by lines to this patch.
> 
> I agree, the missing Signed-off-by is my mistake. I always thought that
> the change log should explain the changes to previous version of the
> same patch (when resending the patch). What is the reason to have a
> change log in the first version of the patch (everything is a change)?


Right now the change log is just "create mode 100644
drivers/staging/comedi/drivers/mf6x4.c" which is not English.  Just
rephrase it into English and add the bit from the Kconfig file.  It
doesn't have to be a novel.

> > > +/* BAR2 registers */
> > > +#define MF634_GPIOC_reg					0x68
> > 
> > Please rename these CamelCase defines (i.e. s/_reg/_REG).
> 
> I would not call it CamelCase -- it is more like a suffix. The name is
> thus composed of the prefix (MF6X4), the name (same as in the
> documentation) and a suffix (saying if this is a register name or a
> field in a register or mask, etc.) -- the reason why I use lower case is
> that it helps readability.
> 

It's not really kernel style...  And especially since we're going to
make this into a function.  MF6X4_DA_reg() looks really bad to me.

> > > +	devpriv->bar0_mem = pci_ioremap_bar(pcidev, board->bar_nums[0]);
> > > +	if (!devpriv->bar0_mem) {
> > > +		dev_err(dev->class_dev, "Failed to remap Device configuration BAR\n");
> > > +		ret = -ENODEV;
> > 
> > Just return the error here and below.
> 
> The reason I did it in this way is the comment next to the 'out' label.
> For somebody not experienced with comedi drivers (like me or somebody
> else reading the code in the future) the sequence of memory allocation
> (or 'pci_ioremap_bar') followed by a 'return' statement looks quite
> scary. Either I can write the comment to each return or do it with the
> single point of exit.
> 

Doing the empty goto is annoying because you assume that a goto has a
point instead of just hopping to the bottom of the function for no
reason.

Looking at this code again, I bet Hartley meant to remove the dev_err()
and as well as the goto.  Yep.  Looking through pci_ioremap_bar() it
prints its own error messages so the dev_err() is redundant.

Comedi's cleanup routines confused me at first too.  There should
definitely be a comment on this somewhere.  I suspect that there is a
commented on this already but I wasn't able to find it.  Maybe it
belongs in skel.c with a comment next to the struct comedi_driver
definition to "see skel.c".  But We don't want these kind of "known
issue for someone after writing their first comedi driver" comments in
every .c file.

For the driver code we want it to be as little fluff as possible:

	devpriv->bar0_mem = pci_ioremap_bar(pcidev, board->bar_nums[0]);
	if (!devpriv->bar0_mem)
		return -ENODEV;

regards,
dan carpenter
