Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbaE1ULq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 16:11:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62452 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaE1ULp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 16:11:45 -0400
Date: Wed, 28 May 2014 13:10:18 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 01/27] mtd: nand: introduce function to fix a common bug
 in most nand-drivers not showing a device in sysfs
Message-ID: <20140528201018.GA3599@ld-irv-0074>
References: <1401142372-14148-1-git-send-email-holler@ahsoftware.de>
 <1401142372-14148-2-git-send-email-holler@ahsoftware.de>
 <20140528084344.GB4285@norris-Latitude-E6410>
 <53863056.2070405@ahsoftware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53863056.2070405@ahsoftware.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 08:52:06PM +0200, Alexander Holler wrote:
> Am 28.05.2014 10:43, schrieb Brian Norris:
> >On Tue, May 27, 2014 at 12:12:26AM +0200, Alexander Holler wrote:
> >>+{
> >>+	mtd->priv	= priv;
> >
> >I don't think you should hide this one here. It will be quite obvious if
> >a driver didn't stash its private data but tries to access it later. Are
> >there any drivers that missed this?
> 
> No, it just saves a line of source in all drivers and I think it
> fits there. I don't understand why do you think it is hidden.

The function name doesn't make it obvious what it's doing. So all code
readers will have to follow the definition to see what it's doing. But
this point is not that important, so I won't argue.

> >>+	mtd->owner	= pdev->dev.driver->owner;
> >>+	mtd->dev.parent	= &pdev->dev;
> >>+	mtd->name	= pdev->dev.driver->name;
> >
> >I think this is a little dangerous. You're potentially clobbering the
> >name that a driver already chose here. And why did you pick to use the
> >driver name? This gives non-unique names if there is more than one
> >device instantiated for a driver. That's why some drivers already use
> >the device name, not the driver name:
> >
> >	mtd->name = dev_name(&pev->dev);
> >
> >And in fact, if any drivers are missing mtd->name, perhaps it's best to
> >just modify the MTD registration to give them a default:
> >
> >	if (!mtd->name)
> >		mtd->name = dev_name(&pdev->dev);
> >
> >>+}
> 
> I don't clobber any name. The name is set as default before drivers
> might do this.

At the moment this is true, but the ordering is somewhat subtle if you
don't examine the details of mtd_setup_common_members() to see that it
is assigning a name. I can easily imagine some new driver in which
someone does:

	mtd->name = ...;
	[...]
	mtd_setup_common_members(mtd, priv, pdev);

And doesn't notice that the ordering matters.

You could make this simpler by either
(1) making mtd_setup_common_members() check for mtd->name==NULL first
(2) just move the (default) name assignment to the common MTD
    registration, like I suggested

> >>+
> >>  extern int mtd_device_parse_register(struct mtd_info *mtd,
> >>  				     const char * const *part_probe_types,
> >>  				     struct mtd_part_parser_data *parser_data,
> >
> >How about we rethink the "helper" approach, and instead just do
> >validation in the core code? This would cover most of the important
> >parts of your helper, I think:
> 
> Feel free to change all drivers. I like my approach with fixing 21
> bugs by reducing code by 44 lines.

I appreciate the bug fixes. I am just questioning the approach. Reduced
(source) code doesn't help anyone if it makes the code less
maintainable. My suggestions can probably make this more maintainable,
fix the same bugs, and reduce the source by a similar (albeit smaller)
number of lines.

> And it offers a common function where future similiarities can be
> put into too. Of course you can just add 21 lines, but that is not
> how I do such stuff.

I don't see how your common location helps much more than putting it in
mtdcore.c like I suggested, without the extra function.

> And I did the patches. If you don't like them, feel free to ignore
> them. I'm not playing remote keyboard but I do patches like I would
> do them, not like some arbitrary maintainer would do them. Sorry for
> the harsh words.

Arbitrary maintainer, eh? I'm simply suggesting that this could be
accomplished in a better way. If you don't want to take part in the
review process, then I have no obligation to engage either.

Regards,
Brian
