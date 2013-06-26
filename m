Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab3FZTDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359Ab3FZTDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:03:19 -0400
Message-ID: <1372273397.30572.569.camel@ul30vt.home>
Subject: Re: [PATCH] pci: Enable overrides for missing ACS capabilities
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Don Dutile <ddutile@redhat.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Wed, 26 Jun 2013 13:03:17 -0600
In-Reply-To: <CAErSpo7iY6qEh7v8D3R8F-sYedO6eJ-MDnzBABBQhMAsxo6DVw@mail.gmail.com>
References: <20130530183955.14686.89444.stgit@bling.home>
	 <20130618172819.GA16134@google.com>
	 <1371579648.22681.209.camel@ul30vt.home>
	 <CAErSpo5mRKhBYun_i=iFppmQ5+7ODCY7q=sehHjBXWqPRH=ZZw@mail.gmail.com>
	 <1371594159.22659.34.camel@ul30vt.home> <51C0E73F.1060708@redhat.com>
	 <CAErSpo7ambrpYm6Lw5bfb5k83ZpHgMvcZxtohVJvo2iTLOF1EQ@mail.gmail.com>
	 <51C1A78A.3090904@redhat.com>
	 <CAErSpo7iY6qEh7v8D3R8F-sYedO6eJ-MDnzBABBQhMAsxo6DVw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-24 at 11:43 -0600, Bjorn Helgaas wrote:
> On Wed, Jun 19, 2013 at 6:43 AM, Don Dutile <ddutile@redhat.com> wrote:
> > On 06/18/2013 10:52 PM, Bjorn Helgaas wrote:
> >>
> >> On Tue, Jun 18, 2013 at 5:03 PM, Don Dutile<ddutile@redhat.com>  wrote:
> >>>
> >>> On 06/18/2013 06:22 PM, Alex Williamson wrote:
> >>>>
> >>>>
> >>>> On Tue, 2013-06-18 at 15:31 -0600, Bjorn Helgaas wrote:
> >>>>>
> >>>>>
> >>>>> On Tue, Jun 18, 2013 at 12:20 PM, Alex Williamson
> >>>>> <alex.williamson@redhat.com>   wrote:
> >>>>>>
> >>>>>>
> >>>>>> On Tue, 2013-06-18 at 11:28 -0600, Bjorn Helgaas wrote:
> >>>>>>>
> >>>>>>>
> >>>>>>> On Thu, May 30, 2013 at 12:40:19PM -0600, Alex Williamson wrote:
> >>>
> >>> ...
> >>>>>>>
> >>>>>>> Who do you expect to decide whether to use this option?  I think it
> >>>>>>> requires intimate knowledge of how the device works.
> >>>>>>>
> >>>>>>> I think the benefit of using the option is that it makes assignment
> >>>>>>> of
> >>>>>>> devices to guests more flexible, which will make it attractive to
> >>>>>>> users.
> >>>>>>> But most users have no way of knowing whether it's actually *safe* to
> >>>>>>> use this.  So I worry that you're adding an easy way to pretend
> >>>>>>> isolation
> >>>>>>> exists when there's no good way of being confident that it actually
> >>>>>>> does.
> >>
> >>
> >>> ...
> >>
> >>
> >>>>> I wonder if we should taint the kernel if this option is used (but not
> >>>>> for specific devices added to pci_dev_acs_enabled[]).  It would also
> >>>>> be nice if pci_dev_specific_acs_enabled() gave some indication in
> >>>>> dmesg for the specific devices you're hoping to add to
> >>>>> pci_dev_acs_enabled[].  It's not an enumeration-time quirk right now,
> >>>>> so I'm not sure how we'd limit it to one message per device.
> >>>>
> >>>>
> >>>> Right, setup vs use and getting single prints is a lot of extra code.
> >>>> Tainting is troublesome for support, Don had some objections when I
> >>>> suggested the same to him.
> >>>>
> >>> For RH GSS (Global Support Services), a 'taint' in the kernel printk
> >>> means
> >>> RH doesn't support that system.  The 'non-support' due to 'taint' being
> >>> printed
> >>> out in this case may be incorrect -- RH may support that use, at least
> >>> until
> >>> a more sufficient patched kernel is provided.
> >>> Thus my dissension that 'taint' be output.  WARN is ok. 'driver beware',
> >>> 'unleashed dog afoot'.... sure...
> >>
> >>
> >> So ...  that's really a RH-specific support issue, and easily worked
> >> around by RH adding a patch that turns off tainting.
> >>
> > sure. what's another patch to the thousands... :-/
> >
> >> It still sounds like a good idea to me for upstream, where use of this
> >> option can very possibly lead to corruption or information leakage
> >> between devices the user claimed were isolated, but in fact were not.
> >
> > Did I miss something?  This patch provides a user-level/chosen override;
> > like all other overrides, (pci=realloc, etc.), it can lead to a failing
> > system.
> > IMO, this patch is no different.  If you want to tag this patch with taint,
> > then let's audit all the (PCI) overrides and taint them appropriately.
> > Taint should be reserved to changes to the kernel that were done outside
> > the development of the kernel, or with the explicit intent to circumvent
> > the normal operation of the kernel.  This patch provides a way to enable
> > ACS checking to succeed when the devices have not provided sufficiently
> > complete
> > ACS information.  i.e., it's a growth path for PCIe-ACS and its need for
> > proper support.
> 
> We're telling the kernel to assume something (the hardware provides
> protection) that may not be true.  If that assumption turns out to be
> false, the result is that a VM can be crashed or comprised by another
> VM.
> 
> One difference I see is that this override can lead to a crash that
> looks like random memory corruption and has no apparent connection to
> the actual cause.  Most other overrides won't cause run-time crashes
> (I think they're more likely to cause boot or device configuration
> failures), and the dmesg log will probably have good clues as to the
> reason.
> 
> But the possibility of compromise is probably even more serious,
> because there would be no crash at all, and we'd have no indication
> that VM A read or corrupted data in VM B.  I'm very concerned about
> that, enough so that it's not clear to me that an override belongs in
> the upstream kernel at all.
> 
> Yes, that would mean some hardware is not suitable for device
> assignment.  That just sounds like "if hardware manufacturers do their
> homework and support ACS properly, their hardware is more useful for
> virtualization than other hardware."  I don't see the problem with
> that.

That's easy to say for someone that doesn't get caught trying to explain
this to users over and over.  In many cases devices don't do
peer-to-peer and missing ACS is an oversight.  I imagine that quite a
few vendors also see the ACS capability as a means to allow control of
ACS and therefore see it as a much larger investment that just providing
an empty ACS structure in config space to indicate the lack of
peer-to-peer.

Even if we taint the kernel when this is enabled and add extremely
verbose warnings in kernel-parameters.txt, I think there's value to
providing an on-the-spot workaround to users.  In many cases we're not
going to get a response from vendors.  Removing the
downstream/multifunction catch-alls might be another way to raise the
bar for this kind of override.  Thanks,

Alex

