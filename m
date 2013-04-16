Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116Ab3DPRxo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:53:44 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34471 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935536Ab3DPRxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:53:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Benenati, Chris J" <chris.j.benenati@intel.com>,
        Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
Subject: Re: [PATCH] PCI / PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
Date: Tue, 16 Apr 2013 20:01:33 +0200
Message-ID: <2880576.TkeK8oBDas@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo7vUWSoav+rJgGK15xA7f0W+a0_16tZLFGCz5HO-HVZ2g@mail.gmail.com>
References: <48795235.crcTAaJqPb@vostro.rjw.lan> <CAE9FiQVEWy2MVfVmv4oL9D24OcF83dQv+OcFd5K6v8ZHeGumJA@mail.gmail.com> <CAErSpo7vUWSoav+rJgGK15xA7f0W+a0_16tZLFGCz5HO-HVZ2g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 15, 2013 02:18:18 PM Bjorn Helgaas wrote:
> On Fri, Apr 12, 2013 at 11:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Fri, Apr 12, 2013 at 4:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >>
> >> Commit b51306c (PCI: Set device power state to PCI_D0 for device
> >> without native PM support) modified pci_platform_power_transition()
> >> by adding code causing dev->current_state for devices that don't
> >> support native PCI PM but are power-manageable by the platform to be
> >> changed to PCI_D0 regardless of the value returned by the preceding
> >> platform_pci_set_power_state().  In particular, that also is done
> >> if the platform_pci_set_power_state() has been successful, which
> >> causes the correct power state of the device set by
> >> pci_update_current_state() in that case to be overwritten by PCI_D0.
> >>
> >> Fix that mistake by making the fallback to PCI_D0 only happen if
> >> the platform_pci_set_power_state() has returned an error.
> >>
> >> Reported-by: Chris J. Benenati <chris.j.benenati@intel.com>
> >> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >> Cc: <stable@vger.kernel.org>
> 
> I folded in Yinghai's simplification and added a URL to Chris's report
> and applied to my pci/rafael-pm branch:
> http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/rafael-pm
> 
> If it still looks good to you, Rafael, I'll merge it to next for v3.10.

Well, the simplification adds an extra check for error into both code paths,
so I'm not sure if it's really worth it (that's why I didn't do it originally
in the first place), but I suppose that's not a big deal.  It looks good as far
as the correctness is concerned anyway.

> I don't know what the user-visible effect of this is, and it's been
> around for a long time, but if you think this should go in v3.9
> instead, let me know.

I think v3.9+stable should be sufficient.

Thanks,
Rafael


> >> ---
> >>  drivers/pci/pci.c |    3 +--
> >>  1 file changed, 1 insertion(+), 2 deletions(-)
> >>
> >> Index: linux-pm/drivers/pci/pci.c
> >> ===================================================================
> >> --- linux-pm.orig/drivers/pci/pci.c
> >> +++ linux-pm/drivers/pci/pci.c
> >> @@ -646,8 +646,7 @@ static int pci_platform_power_transition
> >>                 error = platform_pci_set_power_state(dev, state);
> >>                 if (!error)
> >>                         pci_update_current_state(dev, state);
> >> -               /* Fall back to PCI_D0 if native PM is not supported */
> >> -               if (!dev->pm_cap)
> >> +               else if (!dev->pm_cap) /* Fall back to PCI_D0 */
> >>                         dev->current_state = PCI_D0;
> >>         } else {
> >>                 error = -ENODEV;
> >>
> >
> > Acked-by: Yinghai Lu <yinghai@kernel.org>
> >
> > also could simplify it further.
> >
> > ---
> >  drivers/pci/pci.c |   12 ++++--------
> >  1 file changed, 4 insertions(+), 8 deletions(-)
> >
> > Index: linux-2.6/drivers/pci/pci.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/pci/pci.c
> > +++ linux-2.6/drivers/pci/pci.c
> > @@ -646,15 +646,11 @@ static int pci_platform_power_transition
> >          error = platform_pci_set_power_state(dev, state);
> >          if (!error)
> >              pci_update_current_state(dev, state);
> > -        /* Fall back to PCI_D0 if native PM is not supported */
> > -        if (!dev->pm_cap)
> > -            dev->current_state = PCI_D0;
> > -    } else {
> > +    } else
> >          error = -ENODEV;
> > -        /* Fall back to PCI_D0 if native PM is not supported */
> > -        if (!dev->pm_cap)
> > -            dev->current_state = PCI_D0;
> > -    }
> > +
> > +    if (error && !dev->pm_cap) /* Fall back to PCI_D0 */
> > +        dev->current_state = PCI_D0;
> >
> >      return error;
> >  }
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
