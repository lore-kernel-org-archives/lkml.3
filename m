Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3A2BFR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:05:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:58094 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3A2BFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:05:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 1/5] e1000e: fix resuming from runtime-suspend
Date: Tue, 29 Jan 2013 02:11:23 +0100
Message-ID: <12263202.uQHxo0zU24@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo4G=hQ79KJg_6QgoO9nmG-B5xA_ooph7G6Uu-9wGkrnTQ@mail.gmail.com>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114214.6698.24975.stgit@zurg> <CAErSpo4G=hQ79KJg_6QgoO9nmG-B5xA_ooph7G6Uu-9wGkrnTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 28, 2013 04:05:33 PM Bjorn Helgaas wrote:
> [+cc Rafael, author of patch you cited]
> 
> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> <khlebnikov@openvz.org> wrote:
> > Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> > ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35
> >
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Cc: e1000-devel@lists.sourceforge.net
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Cc: Bruce Allan <bruce.w.allan@intel.com>
> > ---
> >  drivers/net/ethernet/intel/e1000e/netdev.c |   13 ++++++++-----
> >  1 file changed, 8 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> > index fbf75fd..2853c11 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -5691,14 +5691,17 @@ static int e1000_runtime_suspend(struct device *dev)
> >         struct pci_dev *pdev = to_pci_dev(dev);
> >         struct net_device *netdev = pci_get_drvdata(pdev);
> >         struct e1000_adapter *adapter = netdev_priv(netdev);
> > +       int retval;
> > +       bool wake;
> >
> > -       if (e1000e_pm_ready(adapter)) {
> > -               bool wake;
> > +       if (!e1000e_pm_ready(adapter))
> > +               return 0;
> >
> > -               __e1000_shutdown(pdev, &wake, true);
> > -       }
> > +       retval = __e1000_shutdown(pdev, &wake, true);
> > +       if (!retval)
> > +               e1000_power_off(pdev, true, wake);
> >
> > -       return 0;
> > +       return retval;
> >  }
> >
> >  static int e1000_idle(struct device *dev)
> >

I'd like the changelog to say what the bug is and how it is being fixed in
general terms.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
