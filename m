Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab3AaBBK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 20:01:10 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34930 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3AaBBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 20:01:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        linux-pci@vger.kernel.org, Bruce Allan <bruce.w.allan@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 2/5] e1000e: fix pci device enable counter balance
Date: Thu, 31 Jan 2013 02:07:16 +0100
Message-ID: <1582328.fuzuCUZWBa@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo5Cfi0KbOqDr4TfnzjWFy7V-oi0bOY-vf8Y16_RPtEGdQ@mail.gmail.com>
References: <20130118113019.6698.25941.stgit@zurg> <20130118114218.6698.42484.stgit@zurg> <CAErSpo5Cfi0KbOqDr4TfnzjWFy7V-oi0bOY-vf8Y16_RPtEGdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 28, 2013 04:09:38 PM Bjorn Helgaas wrote:
> [+cc Rafael]
> 
> On Fri, Jan 18, 2013 at 4:42 AM, Konstantin Khlebnikov
> <khlebnikov@openvz.org> wrote:
> > __e1000_shutdown() calls pci_disable_device() at the end, thus __e1000_resume()
> > should call pci_enable_device_mem() to keep enable counter in balance.
> >
> > Bug was introduced in commit 23606cf5d1192c2b17912cb2ef6e62f9b11de133
> > ("e1000e / PCI / PM: Add basic runtime PM support (rev. 4)") in v2.6.35
> >
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > Cc: e1000-devel@lists.sourceforge.net
> > Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> > Cc: Bruce Allan <bruce.w.allan@intel.com>
> > ---
> >  drivers/net/ethernet/intel/e1000e/netdev.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> > index 2853c11..6bce796 100644
> > --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> > +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> > @@ -5598,6 +5598,13 @@ static int __e1000_resume(struct pci_dev *pdev)
> >         pci_restore_state(pdev);
> >         pci_save_state(pdev);
> >
> > +       err = pci_enable_device_mem(pdev);
> > +       if (err) {
> > +               dev_err(&pdev->dev,
> > +                       "Cannot re-enable PCI device after suspend.\n");
> > +               return err;
> > +       }
> 
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> Seems right to me, and the other users I looked at (igb, azx,
> virtio_pci) call pci_disable_device() in .suspend() and call
> pci_enable_device() in .resume() as you propose to do here.
> 
> I assume the e1000 folks will handle this patch (and the previous one).
> 

OK, so this one looks like a genuine fix to me.

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Thanks,
Rafael


> > +
> >         e1000e_set_interrupt_capability(adapter);
> >         if (netif_running(netdev)) {
> >                 err = e1000_request_irq(adapter);
> >
> > --
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
