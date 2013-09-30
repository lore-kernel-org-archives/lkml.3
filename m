Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3I3NXi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 09:23:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755224Ab3I3NXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 09:23:33 -0400
Date: Mon, 30 Sep 2013 16:23:02 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, aik@ozlabs.ru, benh@kernel.crashing.org,
        bsd@redhat.com, linux-kernel@vger.kernel.org, mst@redhat.com
Subject: Re: [RFC PATCH 3/3] kvm: Add VFIO device for handling IOMMU cache
 coherency
Message-ID: <20130930132302.GC11993@redhat.com>
References: <20130912211401.8542.82932.stgit@bling.home>
 <20130912212314.8542.9692.stgit@bling.home>
 <20130929131627.GU17294@redhat.com>
 <1380462748.2674.57.camel@ul30vt.home>
 <20130929144409.GD2909@redhat.com>
 <1380470159.2674.65.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380470159.2674.65.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 09:55:59AM -0600, Alex Williamson wrote:
> On Sun, 2013-09-29 at 17:44 +0300, Gleb Natapov wrote:
> > On Sun, Sep 29, 2013 at 07:52:28AM -0600, Alex Williamson wrote:
> > > On Sun, 2013-09-29 at 16:16 +0300, Gleb Natapov wrote:
> > > > On Thu, Sep 12, 2013 at 03:23:15PM -0600, Alex Williamson wrote:
> > > > > So far we've succeeded at making KVM and VFIO mostly unaware of each
> > > > > other, but there's any important point where that breaks down.  Intel
> > > > > VT-d hardware may or may not support snoop control.  When snoop
> > > > > control is available, intel-iommu promotes No-Snoop transactions on
> > > > > PCIe to be cache coherent.  That allows KVM to handle things like the
> > > > > x86 WBINVD opcode as a nop.  When the hardware does not support this,
> > > > > KVM must implement a hardware visible WBINVD for the guest.
> > > > > 
> > > > > We could simply let userspace tell KVM how to handle WBINVD, but it's
> > > > > privileged for a reason.  Allowing an arbitrary user to enable
> > > > > physical WBINVD gives them a more access to the hardware.  Previously,
> > > > > this has only been enabled for guests supporting legacy PCI device
> > > > > assignment.  In such cases it's necessary for proper guest execution.
> > > > > We therefore create a new KVM-VFIO virtual device.  The user can add
> > > > > and remove VFIO groups to this device via file descriptors.  KVM
> > > > > makes use of the VFIO external user interface to validate that the
> > > > > user has access to physical hardware and gets the coherency state of
> > > > > the IOMMU from VFIO.  This provides equivalent functionality to
> > > > > legacy KVM assignment, while keeping (nearly) all the bits isolated.
> > > > > 
> > > > Looks good overall to me, one things though: to use legacy device
> > > > assignment one needs root permission, so only root user can enable
> > > > WBINVD emulation.
> > > 
> > > That's not entirely accurate, legacy device assignment can be used by a
> > > non-root user, libvirt does this all the time.  The part that requires
> > > root access is opening the pci-sysfs config file, the rest can be
> > > managed via file permissions on the remaining sysfs files.
> > > 
> > So how libvirt manages to do that as non-root user if pci-sysfs config
> > file needs root permission. I didn't mean to say that legacy code
> > checks for root explicitly, what I meant is that at some point root
> > permission is needed.
> 
> Yes, libvirt needs admin permission for legacy to bind to pci-stub,
> change permission on sysfs files and pass an opened pci config sysfs
> file descriptor.  For vfio libvirt needs admin permission to bind to
> vfio-pci and change group file permission.  From that perspective the
> admin requirement is similar.
> 
Yes, certainly appears so. Thanks.

--
			Gleb.
