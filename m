Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab3JBPlV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab3JBPlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:41:20 -0400
Message-ID: <1380728477.14271.81.camel@ul30vt.home>
Subject: Re: [PATCH 1/1] virt/kvm/iommu.c: Add leading zeros to device's BDF
 notation in debug messages
From: Alex Williamson <alex.williamson@redhat.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Andre Richter <andre.o.richter@gmail.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 02 Oct 2013 09:41:17 -0600
In-Reply-To: <20131002103508.GG17294@redhat.com>
References: <1380709406-3528-1-git-send-email-andre.o.richter@gmail.com>
	 <20131002103508.GG17294@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-02 at 13:35 +0300, Gleb Natapov wrote:
> On Wed, Oct 02, 2013 at 12:23:26PM +0200, Andre Richter wrote:
> > When KVM (de)assigns PCI(e) devices to VMs, a debug message is printed
> > including the BDF notation of the respective device. Currently, the BDF
> > notation does not have the commonly used leading zeros. This produces
> > messages like "assign device 0:1:8.0", which look strange at first sight.
> > 
> > The patch fixes this by exchanging the printk(KERN_DEBUG ...) with dev_info()
> > and also inserts "kvm" into the debug message, so that it is obvious where
> > the message comes from. Also reduces LoC.
> Legacy assigned device is deprecated, but this looks nice enough to
> apply. Alex can you glance at it?

Seems ok to me, my only question would be why are we promoting this from
KERN_DEBUG to KERN_INFO.  We could use dev_dbg() to maintain the same
kernel log level.  A nice feature of either is that it prints out the
attached driver so we can see in dmesg whether the device is attached to
a host driver, nothing, or pci-stub.  Thanks,

Alex

> > 
> > Signed-off-by: Andre Richter <andre.o.richter@gmail.com>
> > ---
> >  virt/kvm/iommu.c | 12 ++----------
> >  1 file changed, 2 insertions(+), 10 deletions(-)
> > 
> > diff --git a/virt/kvm/iommu.c b/virt/kvm/iommu.c
> > index 72a130b..a3b1410 100644
> > --- a/virt/kvm/iommu.c
> > +++ b/virt/kvm/iommu.c
> > @@ -190,11 +190,7 @@ int kvm_assign_device(struct kvm *kvm,
> >  
> >  	pdev->dev_flags |= PCI_DEV_FLAGS_ASSIGNED;
> >  
> > -	printk(KERN_DEBUG "assign device %x:%x:%x.%x\n",
> > -		assigned_dev->host_segnr,
> > -		assigned_dev->host_busnr,
> > -		PCI_SLOT(assigned_dev->host_devfn),
> > -		PCI_FUNC(assigned_dev->host_devfn));
> > +	dev_info(&pdev->dev, "kvm assign device\n");
> >  
> >  	return 0;
> >  out_unmap:
> > @@ -220,11 +216,7 @@ int kvm_deassign_device(struct kvm *kvm,
> >  
> >  	pdev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
> >  
> > -	printk(KERN_DEBUG "deassign device %x:%x:%x.%x\n",
> > -		assigned_dev->host_segnr,
> > -		assigned_dev->host_busnr,
> > -		PCI_SLOT(assigned_dev->host_devfn),
> > -		PCI_FUNC(assigned_dev->host_devfn));
> > +	dev_info(&pdev->dev, "kvm deassign device\n");
> >  
> >  	return 0;
> >  }
> > -- 
> > 1.8.1.2
> 
> --
> 			Gleb.



