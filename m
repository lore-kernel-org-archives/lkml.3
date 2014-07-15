Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaGOPVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 11:21:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48926 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaGOPVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 11:21:20 -0400
Date: Tue, 15 Jul 2014 11:21:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>, stefano.stabellini@eu.citrix.com
Cc: xen-devel@lists.xenproject.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 4/4] xen/pvhvm: Make MSI IRQs work after kexec
Message-ID: <20140715152105.GP3403@laptop.dumpdata.com>
References: <1405431640-649-1-git-send-email-vkuznets@redhat.com>
 <1405431640-649-5-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405431640-649-5-git-send-email-vkuznets@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 03:40:40PM +0200, Vitaly Kuznetsov wrote:
> When kexec was peformed MSI IRQs for passthrough-ed devices were already
> mapped and we see non-zero pirq extracted from MSI msg. xen_irq_from_pirq()
> fails as we have no IRQ mapping information for that. Requesting for new
> mapping with __write_msi_msg() does not result in MSI IRQ being remapped so
> we don't recieve these IRQs.

receive

How come '__write_msi_msg' does not result in new MSI IRQs?

Is it fair to state that your code ends up reading the MSI IRQ (PIRQ)
from the device and updating the internal PIRQ<->IRQ code to match
with the reality?

> 
> RFC: I wasn't able to understand why commit af42b8d1 which introduced
> xen_irq_from_pirq() check in xen_hvm_setup_msi_irqs() is checking that instead
> of checking pirq > 0 as if the mapping was already done (and we have pirq>0 here)
> we don't need to request for a new pirq. We're loosing existing PIRQ and I'm also
> not sure when __write_msi_msg() with new PIRQ will result in new mapping.

We don't request a new pirq. We end up returning before we call xen_allocate_pirq_msi.
At least that is how the commit you mentioned worked.

In regards to why using 'xen_irq_from_pirq' instead of just checking the PIRQ - is
that we might be called twice by a buggy driver. As such we want to check
our PIRQ<->IRQ to figure this out.

> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/pci/xen.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 905956f..685e8f1 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -231,8 +231,7 @@ static int xen_hvm_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  		__read_msi_msg(msidesc, &msg);
>  		pirq = MSI_ADDR_EXT_DEST_ID(msg.address_hi) |
>  			((msg.address_lo >> MSI_ADDR_DEST_ID_SHIFT) & 0xff);
> -		if (msg.data != XEN_PIRQ_MSI_DATA ||
> -		    xen_irq_from_pirq(pirq) < 0) {
> +		if (msg.data != XEN_PIRQ_MSI_DATA || pirq <= 0) {
>  			pirq = xen_allocate_pirq_msi(dev, msidesc);
>  			if (pirq < 0) {
>  				irq = -ENODEV;
> -- 
> 1.9.3
> 
