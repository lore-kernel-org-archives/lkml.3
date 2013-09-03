Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab3ICQRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:17:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab3ICQRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:17:14 -0400
Date: Tue, 3 Sep 2013 18:19:06 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        linux-ide@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 3/4] AHCI: Conserve interrupts with
 pci_enable_msi_block_part() interface
Message-ID: <20130903161906.GC14221@dhcp-26-207.brq.redhat.com>
References: <cover.1378111919.git.agordeev@redhat.com>
 <3bb1b4375655ecfde5017cc70973d078f2434d5d.1378111919.git.agordeev@redhat.com>
 <20130903141824.GD10522@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903141824.GD10522@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 10:18:24AM -0400, Tejun Heo wrote:
> On Mon, Sep 02, 2013 at 11:00:28AM +0200, Alexander Gordeev wrote:
> > +	if (hpriv->flags & AHCI_HFLAG_NO_MSI)
> > +		goto intx;
> > +
> > +	rc = pci_enable_msi_block_part(pdev, n_ports, AHCI_MAX_PORTS);

We start with maximum possible number of ports AHCI_MAX_PORTS

> > +	if (!rc)
> > +		return AHCI_MAX_PORTS;

If we succeeded the device is indeed supports all AHCI_MAX_PORTS
and we report it.

> > +	if (rc < 0)
> > +		goto intx;

If pci_enable_msi_block_part() failed we should not make further
attempts and fallback to simple IRQ.

> > +	maxvec = rc;

The device supports a lesser of AHCI_MAX_PORTS, because the previous
pci_enable_msi_block_part() has not succeeded nor failed. Thus, rc
contains number of supported MSIs. In case of ICH this will be 16
rather than 32.

Actually, while I was writing this I realized this could be a number
of MSIs that could have been enabled this device, not the maximum
number of supported MSIs - these two may differ. I think MRSM should
be checked. But I will continue as if it always the same.

> > +	rc = pci_enable_msi_block_part(pdev, n_ports, maxvec);

Try pci_enable_msi_block_part() with the maximum number of supported MSIs.

> > +	if (!rc)
> > +		return maxvec;

If we succeeded report the number of enabled MSIs.

> > +	if (rc < 0)
> > +		goto intx;

If pci_enable_msi_block_part() failed we should not make further
attempts and fallback to simple IRQ.

> Why is the above fallback necessary?  The only other number which
> makes sense is roundup_pow_of_two(n_ports), right?  What does the
> above fallback logic buy us?

We must enable maximum possible number of MSIs - the one reported in
Multiple Message Capable register. Otherwise ICH device will fallback
to MRSM. IOW, if the result of roundup_pow_of_two(n_ports) is not what
in Multiple Message Capable register (i.e. as roundup_pow_of_two(6) vs 16)
ICH will enforce MRSM mode.

> Thanks.
> 
> -- 
> tejun

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
