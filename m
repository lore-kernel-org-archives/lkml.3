Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757860AbaAJPuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 10:50:16 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36039 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaAJPuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 10:50:13 -0500
Date: Fri, 10 Jan 2014 08:50:09 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pci: Add "try" reset interfaces
Message-ID: <20140110155009.GA25635@google.com>
References: <20131216221229.3393.6171.stgit@bling.home>
 <CAErSpo7ZYsES6kZXjcwr-gwKaXm7DzHBvUGz+cpZBBH7stAAAQ@mail.gmail.com>
 <1389138319.3209.142.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389138319.3209.142.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 04:45:19PM -0700, Alex Williamson wrote:
> On Tue, 2014-01-07 at 16:15 -0700, Bjorn Helgaas wrote:
> > Hi Alex,
> > 
> > Sorry for the delay in looking at this.
> > 
> > On Mon, Dec 16, 2013 at 3:14 PM, Alex Williamson
> > <alex.williamson@redhat.com> wrote:
> > > When doing a function/slot/bus reset PCI grabs the device_lock for
> > > each device to block things like suspend and driver probes, which is
> > > all well and good, but call paths exist where this lock may already be
> > > held.  This creates an opportunity for deadlock.  For instance, vfio
> > > allows userspace to issue resets so long as it owns the device(s).
> > > If a driver unbind .remove callback races with userspace issuing a
> > > reset, we have a deadlock as userspace gets stuck waiting on
> > > device_lock while another thread has device_lock and waits for .remove
> > > to complete.
> > 
> > Are you talking about vfio_pci_remove() (the vfio_pci_driver .remove()
> > method) racing with vfio_pci_ioctl()?
> 
> Yes, for instance if the admin does something like attempt to unbind the
> device from vfio-pci while it's in use.  This can also happen indirectly
> if the device is going away, such as a PF driver attempting to remove
> its VFs.
> 
> > Or maybe it's vfio_pci_release (the vfio_pci_ops .release() method),
> > since it looks like you want to use pci_try_reset_function() there and
> > in vfio_pci_ioctl()?
> 
> That one too.  If any reset races with pci_driver.remove, whether it be
> from ioctl or my own release callback, we'll hit a deadlock.
> 
> > Either way, aren't there at least potentially more locking issues than
> > just the reset problem?  Seems like any ioctl that might take the
> > device_lock could have the same problem.
> 
> I don't know of any others, but our QE folks hit this one pretty
> regularly.  It can all be explained away as user error, but a user
> should not be able to cause a kernel deadlock, which is why the user
> exposed interfaces are converted to use this try-lock interface.
> 
> >   How do you make sure there's
> > no userspace owner of the device before you release the device or
> > remove the driver?
> 
> Userspace has a file descriptor for the device, so we know through
> reference counting when the device becomes unused.  When our
> pci_driver.remove() callback happens we block until the user releases
> the device, so perhaps it more accurate to describe it as a nested lock
> problem than a race, but the paths are asynchronous so even if we tested
> the lock in advance there's a potential race.

If I understand correctly, the deadlock happens when A (userspace) has a file
descriptor for the device, and B waits in this path:

  driver_detach
    device_lock                     # take device_lock
    __device_release_driver
      pci_device_remove             # pci_bus_type.remove
	vfio_pci_remove             # pci_driver .remove
	  vfio_del_group_dev
	    wait_event(vfio.release_q, !vfio_dev_present)   # wait (holding device_lock)

Now B is stuck until A gives up the file descriptor.  I haven't traced that
path, but I assume giving up the file descriptor involves the
vfio_device_put() ...  vfio_device_release() path to wake up B.

If A tries to acquire device_lock for any reason, we deadlock because A
is waiting for B to release the lock, and B is waiting for A to release the
file descriptor.

You're fixing the case where A does a VFIO_DEVICE_RESET ioctl that calls
pci_reset_function().  It looks like a VFIO_DEVICE_SET_IRQS ioctl will have
the same problem because it can acquire device_lock in
vfio_pci_set_err_trigger().

It makes me uneasy that B (in the kernel) waits indefinitely for A
(userspace) to do something.  If A is malicious and simply does nothing, it
will cause all other paths that acquire device_lock to hang, e.g., suspend
and hibernate, AER reporting (e.g., report_error_detected()), and various
USB events.

Bjorn
