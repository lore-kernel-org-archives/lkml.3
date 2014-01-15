Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaAODTm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 22:19:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbaAODTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 22:19:39 -0500
Message-ID: <1389755971.8705.5.camel@bling.home>
Subject: Re: [PATCH] vfio-pci: Use pci "try" reset interface
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Tue, 14 Jan 2014 20:19:31 -0700
In-Reply-To: <CAErSpo74iO-cD71+q-Bz52r4Eg1p9KpGQQXLnQ3zUxzs54YSuw@mail.gmail.com>
References: <20131216221615.3539.78656.stgit@bling.home>
	 <CAErSpo74iO-cD71+q-Bz52r4Eg1p9KpGQQXLnQ3zUxzs54YSuw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-14 at 16:48 -0700, Bjorn Helgaas wrote:
> On Mon, Dec 16, 2013 at 3:16 PM, Alex Williamson
> <alex.williamson@redhat.com> wrote:
> > PCI resets will attempt to take the device_lock for any device to be
> > reset.  This is a problem if that lock is already held, for instance
> > in the device remove path.  It's not sufficient to simply kill the
> > user process or skip the reset if called after .remove as a race could
> > result in the same deadlock.  Instead, we handle all resets as "best
> > effort" using the PCI "try" reset interfaces.  This prevents the user
> > from being able to induce a deadlock by triggering a reset.
> >
> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >
> > This depends on the proposed pci "try" function/slot/bus reset patch.
> >
> >  drivers/vfio/pci/vfio_pci.c |   29 +++++++++--------------------
> >  1 file changed, 9 insertions(+), 20 deletions(-)
> >
> > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > index 6ab71b9..576e34e 100644
> > --- a/drivers/vfio/pci/vfio_pci.c
> > +++ b/drivers/vfio/pci/vfio_pci.c
> > @@ -139,25 +139,14 @@ static void vfio_pci_disable(struct vfio_pci_device *vdev)
> >         pci_write_config_word(pdev, PCI_COMMAND, PCI_COMMAND_INTX_DISABLE);
> >
> >         /*
> > -        * Careful, device_lock may already be held.  This is the case if
> > -        * a driver unbind is blocked.  Try to get the locks ourselves to
> > -        * prevent a deadlock.
> > +        * Try to reset the device.  The success of this is dependent on
> > +        * being able to lock the device, which is not always possible.
> >          */
> >         if (vdev->reset_works) {
> > -               bool reset_done = false;
> > -
> > -               if (pci_cfg_access_trylock(pdev)) {
> > -                       if (device_trylock(&pdev->dev)) {
> > -                               __pci_reset_function_locked(pdev);
> > -                               reset_done = true;
> > -                               device_unlock(&pdev->dev);
> > -                       }
> > -                       pci_cfg_access_unlock(pdev);
> > -               }
> > -
> > -               if (!reset_done)
> > -                       pr_warn("%s: Unable to acquire locks for reset of %s\n",
> > -                               __func__, dev_name(&pdev->dev));
> > +               int ret = pci_try_reset_function(pdev);
> > +               if (ret)
> > +                       pr_debug("%s: reset of device %s = %d\n",
> > +                               __func__, dev_name(&pdev->dev), ret);
> 
> Why is this a pr_debug() instead of dev_dbg()?  I see vfio_pci.c seems
> to always use pr_*() instead of dev_*(), so you probably have a
> reason.

Inertia and lack of anyone suggesting it are probably the biggest
reasons.  As you note, I've been using pr_foo throughout the file, so
I'd probably prefer consistency and fix them in a separate patch.

> The text of the message ("vfio_pci_disable: reset of device
> 0000:00:00.1 = -35") doesn't seem terribly clear; as a user, I'd have
> to go look up the code to know whether I should be concerned about it.
>  Maybe it should be explicit that the device was not reset?

Sure, I'll tweak the message to make it more clear that it failed and
include the return value as extra info.  Thanks,

Alex

> >         }
> >
> >         pci_restore_state(pdev);
> > @@ -514,7 +503,7 @@ static long vfio_pci_ioctl(void *device_data,
> >
> >         } else if (cmd == VFIO_DEVICE_RESET) {
> >                 return vdev->reset_works ?
> > -                       pci_reset_function(vdev->pdev) : -EINVAL;
> > +                       pci_try_reset_function(vdev->pdev) : -EINVAL;
> >
> >         } else if (cmd == VFIO_DEVICE_GET_PCI_HOT_RESET_INFO) {
> >                 struct vfio_pci_hot_reset_info hdr;
> > @@ -684,8 +673,8 @@ reset_info_exit:
> >                                                     &info, slot);
> >                 if (!ret)
> >                         /* User has access, do the reset */
> > -                       ret = slot ? pci_reset_slot(vdev->pdev->slot) :
> > -                                    pci_reset_bus(vdev->pdev->bus);
> > +                       ret = slot ? pci_try_reset_slot(vdev->pdev->slot) :
> > +                                    pci_try_reset_bus(vdev->pdev->bus);
> >
> >  hot_reset_release:
> >                 for (i--; i >= 0; i--)
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



