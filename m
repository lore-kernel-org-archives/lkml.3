Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3I2P4I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 11:56:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608Ab3I2P4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 11:56:07 -0400
Message-ID: <1380470159.2674.65.camel@ul30vt.home>
Subject: Re: [RFC PATCH 3/3] kvm: Add VFIO device for handling IOMMU cache
 coherency
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: kvm@vger.kernel.org, aik@ozlabs.ru, benh@kernel.crashing.org,
        bsd@redhat.com, linux-kernel@vger.kernel.org, mst@redhat.com
Date: Sun, 29 Sep 2013 09:55:59 -0600
In-Reply-To: <20130929144409.GD2909@redhat.com>
References: <20130912211401.8542.82932.stgit@bling.home>
	 <20130912212314.8542.9692.stgit@bling.home>
	 <20130929131627.GU17294@redhat.com> <1380462748.2674.57.camel@ul30vt.home>
	 <20130929144409.GD2909@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-29 at 17:44 +0300, Gleb Natapov wrote:
> On Sun, Sep 29, 2013 at 07:52:28AM -0600, Alex Williamson wrote:
> > On Sun, 2013-09-29 at 16:16 +0300, Gleb Natapov wrote:
> > > On Thu, Sep 12, 2013 at 03:23:15PM -0600, Alex Williamson wrote:
> > > > So far we've succeeded at making KVM and VFIO mostly unaware of each
> > > > other, but there's any important point where that breaks down.  Intel
> > > > VT-d hardware may or may not support snoop control.  When snoop
> > > > control is available, intel-iommu promotes No-Snoop transactions on
> > > > PCIe to be cache coherent.  That allows KVM to handle things like the
> > > > x86 WBINVD opcode as a nop.  When the hardware does not support this,
> > > > KVM must implement a hardware visible WBINVD for the guest.
> > > > 
> > > > We could simply let userspace tell KVM how to handle WBINVD, but it's
> > > > privileged for a reason.  Allowing an arbitrary user to enable
> > > > physical WBINVD gives them a more access to the hardware.  Previously,
> > > > this has only been enabled for guests supporting legacy PCI device
> > > > assignment.  In such cases it's necessary for proper guest execution.
> > > > We therefore create a new KVM-VFIO virtual device.  The user can add
> > > > and remove VFIO groups to this device via file descriptors.  KVM
> > > > makes use of the VFIO external user interface to validate that the
> > > > user has access to physical hardware and gets the coherency state of
> > > > the IOMMU from VFIO.  This provides equivalent functionality to
> > > > legacy KVM assignment, while keeping (nearly) all the bits isolated.
> > > > 
> > > Looks good overall to me, one things though: to use legacy device
> > > assignment one needs root permission, so only root user can enable
> > > WBINVD emulation.
> > 
> > That's not entirely accurate, legacy device assignment can be used by a
> > non-root user, libvirt does this all the time.  The part that requires
> > root access is opening the pci-sysfs config file, the rest can be
> > managed via file permissions on the remaining sysfs files.
> > 
> So how libvirt manages to do that as non-root user if pci-sysfs config
> file needs root permission. I didn't mean to say that legacy code
> checks for root explicitly, what I meant is that at some point root
> permission is needed.

Yes, libvirt needs admin permission for legacy to bind to pci-stub,
change permission on sysfs files and pass an opened pci config sysfs
file descriptor.  For vfio libvirt needs admin permission to bind to
vfio-pci and change group file permission.  From that perspective the
admin requirement is similar.

> > >  Who does this permission checking here? Is only root
> > > allowed to create non coherent group with vfio?
> > 
> > With vfio the user is granted permission by giving them access to the
> > vfio group file (/dev/vfio/$GROUP) and binding all the devices in the
> > group to vfio.  That enables the user to create a container (~iommu
> > domain) with the group attached to it.  Only then will the vfio external
> > user interface provide a reference to the group and enable this wbinvd
> > support.  So, wbinvd emulation should only be available to a user that
> > "own" a vfio group and has it configured for use with this interface.
> What is the default permission of /dev/vfio/$GROUP?

It's 600.  Thanks,

Alex

