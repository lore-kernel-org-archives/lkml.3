Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaIOR6N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 13:58:13 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:49206 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598AbaIOR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 13:58:11 -0400
Date: Mon, 15 Sep 2014 10:58:06 -0700
From: Matt Wilson <msw@linux.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Anthony Liguori <aliguori@amazon.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] virtio-pci: also bind to Amazon PCI vendor ID
Message-ID: <20140915175805.GA28557@u109add4315675089e695.ant.amazon.com>
References: <1410751773-10519-1-git-send-email-anthony@codemonkey.ws>
 <20140915082015.GB6480@redhat.com>
 <CA+aC4kvj8B3vsxfq8FSSc9AzQc=4+4poY=Ro2tbH7Yt2FFGFQw@mail.gmail.com>
 <20140915162308.GC11644@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140915162308.GC11644@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 07:23:08PM +0300, Michael S. Tsirkin wrote:
> On Mon, Sep 15, 2014 at 07:24:33AM -0700, Anthony Liguori wrote:
> > Hi Michael,
> > 
> > On Mon, Sep 15, 2014 at 1:20 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
> > > On Sun, Sep 14, 2014 at 08:29:33PM -0700, Anthony Liguori wrote:
> > >> From: Anthony Liguori <aliguori@amazon.com>
> > >>
> > >> See https://issues.oasis-open.org/browse/VIRTIO-16 although it
> > >> was prematurely closed.
> > >
> > > The reason it was closed is described in the comments. and I quote:
> > > " I think anyone can use a different subsystem vendor id and whql the
> > > driver. virtio-102 will make this even easier, by making the subsystem
> > > id flexible. Let's close this and re-open if someone tries to do this
> > > and runs into a problem. "
> > >
> > > Look here for example:
> > > https://github.com/YanVugenfirer/kvm-guest-drivers-windows/blob/master/NetKVM/NDIS5/wxp/netkvm.inf
> > > Replace SUBSYS_00011AF4 with SUBSYS_00011D0F, and you will get
> > > a virtio-net driver that (I think) you should be able to WHQL.
> > 
> > The string you are referencing is the device description which is part
> > of what forms the device instance id.  You can read more at
> > http://msdn.microsoft.com/en-us/library/windows/hardware/ff541327%28v=vs.85%29.aspx.
> > Including a SUBSYS entry is mandatory in modern Windows drivers.
> 
> Good. So there won't be conflicts as long as you don't
> try to use the same SUBSYS as someone else.
> 
> > But this is independent of WHQL certification.  My understanding is
> > that Microsoft will only allow the owner of the PCI Vendor ID to WHQL
> > drivers.  As best as I know, this is not a publicly documented
> > process.
> 
> WHQL process seems to be documented:
> http://download.microsoft.com/download/4/D/D/4DD894CD-62C8-488F-944D-4E5F8BA40114/hardware-certification-policies-processes-hck2-1.docx
> > Do you have any examples of anyone else successfuling WHQL'ing drivers
> > by just changing the subsystem ID?
> 
> I don't have such examples to hand, sorry.
> I do think it's worth trying as I don't see any problems
> this could cause anyone.
> 
> 
> In particular maybe this applies (from link above):
> 
> 	If a reseller wants to control distribution for its product, take the
> 	following steps:
> 	1. Revise the PnP ID of the product to include the subvendor ID.
> 	2. Submit a Driver Update Submission that revises the information (.inf)
> 	file to reflect the new PnP ID.
> 	If a reseller wants to change the driver binary for a device, a new
> 	initial device submission must be made (with full testing).
> 	All reseller submissions are subject to audit.
> 
> Seems to say you can do this.

This is part of the Reseller Submission Policy, and only applies if
there is a "parent submission" that has gone through the WHQL process.

> >  Microsoft has specific rules about
> > the usage of the subsystem ID.  See
> > http://msdn.microsoft.com/en-us/library/windows/hardware/dn653567%28v=vs.85%29.aspx.
> > I don't think it is intended to enable a totally different
> > implementation of the driver based on subsystem ID.
> > Certainly, this is not expected with typical PCI devices.
> 
> Why not? Changing device ID doesn't seem to be very different.
> It's not uncommon for devices with specific subsystem ID
> to have different bugs, or be supported by different driver versions,
> or just be tested only with a specific driver.
> 
> One of these from the list above might fit the bill:
> 
> -	Driver packages submitted by an OEM for logo (must be tested on
> 	the OEM hardware and must not contain a VID/DID entry)
> -	Driver packages submitted by an independent hardware vendor providing
> 	customizations for an OEM (must be tested on the OEM hardware and must
> 	not contain a VID/DID entry)
> -	Driver packages with a bug fix for a specific implementation
> 		for example, you can rip out all kid of
> 		compatibility code for old hosts.

I think that the best technical solution would be to use a different
subsystem vendor ID, so long as both the WHQL process and Windows
Update supports this approach.

> > > On the host side, you will need a QEMU patch to allow libvirt control of
> > > the subsystem vendor ID.
> > >
> > > All this while all Linux guests will keep working without changes,
> > > which seems like a better approach.
> > >
> > > Looking on the web, I found:
> > > http://download.microsoft.com/download/1/6/1/161ba512-40e2-4cc9-843a-923143f3456c/pciidspec-11.doc
> > > "Test will read and properly concatenate PCI IDs and verify uniqueness"
> > > this is likely what you are running into: IDs must be unique,
> > > so if you want to put your driver in Microsoft's database,
> > > it must match a different set of IDs.
> > > But you should not need to change the vendor ID to make them unique,
> > > changing subsystem vendor ID will do.
> > >
> > > Did you try this?
> > 
> > You cannot submit a modified kvm-guest-drivers.git for WHQL
> > certification
> 
> Sorry about being unclear, that github link was just an example to give
> you the idea.  The point is to change the subsystem ID *of the device*.
> 
> > as the licensing is constructed in such a way as to
> > prevent that.
> >
> > >> Red Hat has non-redistributable Windows drivers and Microsoft
> > >> will not allow anyone else to WHQL certify drivers using that
> > >> vendor ID.
> > >
> > > Don't see what Red Hat's windows drivers have to do with Linux really.
> > > Amazon.com can do whatever it wants with its vendor ID, and if there is a
> > > hypervisor with a different vendor ID that can use the virtio drivers, this
> > > patch is required.
> > > The following would be a reasonable commit log in that case:
> > >
> > > "Amazon.com uses PV devices with vendor ID 0x1d0f that are otherwise
> > >  compatible with Linux virtio drivers. Add 0x1d0f ID to the list
> > >  to make Linux work with these devices."
> > > Feel free to use :)
> > >
> > >
> > > But I'd like to note that by doing this on the hypervisor side,
> > > you lose the ability to run older Linux guests,
> > > and create work for all distros who now need to update their
> > > kernels to work with your ID, apparently for no good reason.
> > >
> > > So if this isn't out in the field yet, I would suggest examining
> > > the alternative listed above.
> > 
> > I am very happy to use any alternative mechanism that allows for
> > virtio to be used with a wide variety of guests.
> 
> I hope my idea above can work - it would be best for everyone.  I would
> try to explore it before giving up and changing the vendor ID.
> As I said this is just friendly advice, and not a nak to the patch,
> if your hypervisor has devices with your own ID, go ahead and
> add the ID to driver.
> 
> > Many other companies
> > have also struggled with this and AFAIK no one has had much success.
> 
> Question remains what the problem is.
> Until we have an explicit report saying "we tried XYZ and
> it failed" we are just shooting in the dark, aren't we?
> 
> 
> > > OTOH if it *is* decided this is going to be out there in the field, please add
> > > the new devices to the PCI IDs list.
> > > http://pci-ids.ucw.cz/
> > > Otherwise there's no way to be sure someone won't try to
> > > use these IDs for something else.
> > 
> > PCI-SIG assigns vendor IDs and 0x1d0f is assigned to Amazon.  See
> > https://www.pcisig.com/membership/vid_search/
> > 
> > Vendors self-manage device IDs and we have allocated 0x1000-0x103f to
> > virtio devices.
> > 
> > >> That makes it impossible to use virtio drivers with
> > >> a Windows guest without changing the vendor ID.
> > >
> > > Hardly impossible: virtio drivers are available from a
> > > variety of sources.
> > 
> > Examples?
> > 
> > Regards,
> > 
> > Anthony Liguori
> 
> Fedora has drivers.
> Most other linux distros have drivers.
> Maybe not as good as RHEL ones but they are there, and
> their existance is the most likely reason no one bothered
> re-writing drivers.

Why not BSD license the drivers and get them into Windows Update?
Citrix donated their drivers to the Xen Project and licensed them
under the BSD license. It makes this process a lot easier...

See win-* prefixed projects in https://github.com/xenserver, now
moved to pvdrivers/win repositories in http://xenbits.xen.org/gitweb 

--msw

> Which does not mean you shouldn't do it. Be my guest.
> 
> My only point is commit log should not say "impossible to use".
> 
> 
> > >
> > > But this is IMO beside the point.
> > >
> > >> Cc: Matt Wilson <msw@amazon.com>
> > >> Cc: Rusty Russell <rusty@rustcorp.com.au>
> > >> Cc: Michael Tsirkin <mst@redhat.com>
> > >> Signed-off-by: Anthony Liguori <aliguori@amazon.com>
> > >
> > > I'd like to see the response/confirmation of the above, and/or the
> > > commit log replaced before this patch is applied.
> > >
> > > Thanks!
> > >
> > >> ---
> > >>  drivers/virtio/virtio_pci.c |    2 ++
> > >>  1 file changed, 2 insertions(+)
> > >>
> > >> diff --git a/drivers/virtio/virtio_pci.c b/drivers/virtio/virtio_pci.c
> > >> index 101db3f..9cbac33 100644
> > >> --- a/drivers/virtio/virtio_pci.c
> > >> +++ b/drivers/virtio/virtio_pci.c
> > >> @@ -93,6 +93,8 @@ struct virtio_pci_vq_info
> > >>  /* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
> > >>  static DEFINE_PCI_DEVICE_TABLE(virtio_pci_id_table) = {
> > >>       { PCI_DEVICE(0x1af4, PCI_ANY_ID) },
> > >> +     /* Amazon.com vendor ID */
> > >> +     { PCI_DEVICE(0x1d0f, PCI_ANY_ID) },
> > >>       { 0 }
> > >>  };
> > >>
