Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936Ab3J3PeO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:34:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305Ab3J3PeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:34:12 -0400
Date: Wed, 30 Oct 2013 17:33:38 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, aik@ozlabs.ru, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] kvm: Destroy & free KVM devices on release
Message-ID: <20131030153338.GI4651@redhat.com>
References: <20131029160019.22578.16409.stgit@bling.home>
 <20131029161322.22578.18997.stgit@bling.home>
 <20131030104029.GE4651@redhat.com>
 <1383143422.4097.170.camel@ul30vt.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383143422.4097.170.camel@ul30vt.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 08:30:22AM -0600, Alex Williamson wrote:
> On Wed, 2013-10-30 at 12:40 +0200, Gleb Natapov wrote:
> > On Tue, Oct 29, 2013 at 10:13:22AM -0600, Alex Williamson wrote:
> > > The KVM device interface allocates a struct kvm_device and calls
> > > kvm_device_ops.create on it from KVM VM ioctl KVM_CREATE_DEVICE.
> > > This returns a file descriptor to the user for them to set/get/check
> > > further attributes.  On closing the file descriptor, one would assume
> > > that kvm_device_ops.destroy is called and all traces of the device
> > > would go away.  One would be wrong, it actually does nothing more
> > > than release the struct kvm reference, waiting until the VM is
> > > destroyed before doing more.  This leaves devices that only want a
> > > single instance of themselves per VM in a tough spot.
> > > 
> > This is by design. Otherwise locking will be needed on each device access
> > and for interrupt controllers this is unnecessary serialization and
> > overhead. Device API is not designed for devices that can go away while
> > machine is running anyway, so after creation device is only destroyed
> > during VM destruction.
> 
> Hmm, ok.  In that case I can drop this patch and I think the rest just
> boils down to userspace use of the device.  I had been close()'ing the
> kvm device fd when all QEMU vfio devices are detached, but I can just as
> easily leave it open in case a new device is added later.  I'll send out
> a new series after doing some more review and testing.  Do you have any
> comments on the rest of the series?  Thanks,
> 
If I understand 4/4 correctly if there is VFIO device connected we
assume non coherent domain. How hard it would be to do proper checking
in this path series?

--
			Gleb.
