Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaEVR5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:57:16 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36144 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaEVR5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:57:15 -0400
Date: Thu, 22 May 2014 10:57:00 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Francesco Ruggeri <fruggeri@arista.com>
Cc: Greg Kroah-Hartmann <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: pci: kernel crash in bus_find_device
Message-ID: <20140522175700.GA14814@roeck-us.net>
References: <20140520195041.GA28913@roeck-us.net>
 <CA+HUmGg4mE5RDxShNCK78yLi9gdX_FnHtWPKfGD4LaEqrCdj2Q@mail.gmail.com>
 <20140520233812.GA15640@roeck-us.net>
 <CA+HUmGge7AEpAnwAG_VJD2CKTtRBoC2bCGVU_t4qm-x6+OCr-g@mail.gmail.com>
 <20140521193010.GA1721@roeck-us.net>
 <CA+HUmGhm1VLTvMKW1TUUPqStUhD11M5u0VyTZyXyWz_ZS8uSVw@mail.gmail.com>
 <20140521225958.GB2467@roeck-us.net>
 <20140522071427.GA21230@kroah.com>
 <537DA5C0.2070609@roeck-us.net>
 <CA+HUmGhVhLoehT68=2fErGeYSjAC87Ria=5pXUNSpYLwdpXc2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+HUmGhVhLoehT68=2fErGeYSjAC87Ria=5pXUNSpYLwdpXc2w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:19:40AM -0700, Francesco Ruggeri wrote:
> Aborting a search does not sound like a correct solution.
> How does a higher level user (eg for_each_pci_dev) know that a search
> was aborted and decide whether it should try again, assuming it would
> be ok repeating the action on the devices visited the first time?
> 
Agreed, it is less than desirable.

I would consider this to be a secondary problem, though, the immediate
problem being the crash. One possible solution might be to have the various
functions return error codes (ERR_PTR), but that would be quite invasive as
well. I really think we need input from Greg and, if the solution touches
the PCI subsystem, from Bjorn Helgaas to find an acceptable solution
to that problem.

Guenter

> Francesco
> 
> 
> On Thu, May 22, 2014 at 12:22 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 05/22/2014 12:14 AM, Greg Kroah-Hartmann wrote:
> >>
> >> On Wed, May 21, 2014 at 03:59:58PM -0700, Guenter Roeck wrote:
> >>>
> >>> On Wed, May 21, 2014 at 01:04:04PM -0700, Francesco Ruggeri wrote:
> >>>>
> >>>> I have been using an x86 platform.
> >>>> When I started working on it I got early crashes until I added the
> >>>> check for p not NULL in
> >>>>
> >>>> +void bus_release_device(struct device *dev)
> >>>> +{
> >>>> + struct device_private *p = dev->p;
> >>>> +
> >>>> + if (p && klist_node_attached(&p->knode_bus))
> >>>> + klist_put_last(&p->knode_bus);
> >>>> +}
> >>>> +
> >>>>
> >>>> Maybe on powerpc *p is overriden between device_del and device_release?
> >>>>
> >>>> Or maybe some of the BUG_ONs in the patch? The ones on knode_dead are
> >>>> treated as WARN_ONs in the current klist code.
> >>>> The one in BUG_ON(!klist_dec_and_del(n)); is new, and in my tests I
> >>>> ran into it without the second patch (but only when I ran my module
> >>>> and tests).
> >>>>
> >>> Hi Francesco,
> >>>
> >>> I replaced the BUG_ON with WARN_ON; still crashes.
> >>>
> >>> Anyway, the problem seems to be known. I found two related exchanges.
> >>>
> >>> [1] describes pretty much the same problem. I don't see if/where it was
> >>> ever fixed, though.
> >>>
> >>> [2] is a patch to fix the problem. It did not apply cleanly to 3.14,
> >>> so I had to make some adjustments in klist_iter_init_node. Resulting
> >>> patch is below. With this patch, the problem is gone. It is not perfect,
> >>> as it aborts the loop if it encounters a deleted kobject, but it is
> >>> better
> >>> than nothing. Unfortunately, the patch never made it upstream; no idea
> >>> why.
> >>> Copying the author and Greg to get additional feedback.
> >>>
> >>> Guenter
> >>>
> >>> [1] https://lkml.org/lkml/2008/10/26/79
> >>> [2] https://lkml.org/lkml/2012/4/16/218
> >>
> >>
> >> 2 years ago?  I have no idea what was up with that, sorry...
> >>
> >
> > Ok, but do you have comments on the patch itself in its current version ?
> >
> > Guenter
> >
> 
