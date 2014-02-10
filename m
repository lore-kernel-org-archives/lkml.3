Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842AbaBJKHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:07:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45818 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbaBJKHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:07:16 -0500
Message-ID: <1392026834.2082.10.camel@linux-fkkt.site>
Subject: Re: [PATCH part1 v5 5/7] PCI: Add pci_dummy_ops to isolate pci
 device temporarily
From: Oliver Neukum <oneukum@suse.de>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Date: Mon, 10 Feb 2014 11:07:14 +0100
In-Reply-To: <52F886ED.7040603@huawei.com>
References: <1392005051-54508-1-git-send-email-wangyijing@huawei.com>
		 <1392005051-54508-6-git-send-email-wangyijing@huawei.com>
	 <1392015399.21271.9.camel@linux-fkkt.site> <52F886ED.7040603@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 15:59 +0800, Yijing Wang wrote:
> Hi Oliver,
>    Thanks for your review and comments!
> 
> >> +static DEFINE_SPINLOCK(pci_freeze_lock);
> > 
> > The lock is used only here.
> 
> Also be used in pci_bus_unfreeze_device();

Sorry, I meant only in this patch.

> 
> > 
> >> +/**
> >> + * pci_bus_freeze_device - freeze pci bus to access pci device
> >> + * @bus: the pci bus to freeze
> >> + *
> >> + * Replace pci bus ops by pci_dummy_ops, protect system from
> >> + * accessing pci devices.
> >> + */
> >> +void pci_bus_freeze_device(struct pci_bus *bus)
> >> +{
> >> +	struct pci_ops *ops;
> >> +	unsigned long flags;
> >> +
> >> +	spin_lock_irqsave(&pci_freeze_lock, flags);
> >> +	ops = pci_bus_set_ops(bus, &pci_dummy_ops);
> >> +	bus->save_ops = ops;
> >> +	spin_unlock_irqrestore(&pci_freeze_lock, flags);
> > 
> > Against what exactly are you locking here?
> 
> I want to use this spin lock to serialize freeze device and unfreeze device.

Yes, but against what? I am sorry I should have been more explicit.
You are using these functions only in pci_scan_single_device()


CPU A					CPU B
pci_bus_freeze_device()			wait
bus->save_ops = ops {valid}		wait
...					pci_bus_freeze_device()
wait					bus->save_ops = ops
					{pci_dummy_ops !}
pci_bus_unfreeze_device()		wait
pci_bus_set_ops(bus, bus->save_ops)

You see the problem?

If this function ever races with itself, the locking is useless.
If it doesn't race with itself, the locking is not needed.
If this function can really race with itself, you need a refcount
for freezing.

	Regards
		Oliver


