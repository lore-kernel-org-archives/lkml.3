Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3JKFxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 01:53:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:58460 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752086Ab3JKFxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 01:53:19 -0400
Message-ID: <1381470596.5630.61.camel@pasglop>
Subject: Re: [PATCH v2 3/6] powerpc/pci: use pci_is_pcie() to simplify code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yijing Wang <wangyijing@huawei.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Gavin Shan <shangw@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org
Date: Fri, 11 Oct 2013 16:49:56 +1100
In-Reply-To: <20130906203035.GA27940@google.com>
References: <1378367730-25996-1-git-send-email-wangyijing@huawei.com>
	 <1378367730-25996-3-git-send-email-wangyijing@huawei.com>
	 <20130906203035.GA27940@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-06 at 14:30 -0600, Bjorn Helgaas wrote:
> On Thu, Sep 05, 2013 at 03:55:27PM +0800, Yijing Wang wrote:
> > Use pci_is_pcie() to simplify code.
> > 
> > Acked-by: Kumar Gala <galak@kernel.crashing.org>
> > Reviewed-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> > Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> > Cc: Gavin Shan <shangw@linux.vnet.ibm.com>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: linuxppc-dev@lists.ozlabs.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  arch/powerpc/kernel/eeh.c     |    3 +--
> >  arch/powerpc/sysdev/fsl_pci.c |    2 +-
> >  2 files changed, 2 insertions(+), 3 deletions(-)
> 
> Ben, Paul, this has no dependencies on anything new to PCI or any
> other patches in this series, so you can take it through the POWERPC
> tree.  If you don't want to do that, let me know and I can take it.
> 
> If you want it:
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

It's also quite broken :-)

See below:

> > diff --git a/arch/powerpc/kernel/eeh.c b/arch/powerpc/kernel/eeh.c
> > index 55593ee..6ebbe54 100644
> > --- a/arch/powerpc/kernel/eeh.c
> > +++ b/arch/powerpc/kernel/eeh.c
> > @@ -189,8 +189,7 @@ static size_t eeh_gather_pci_data(struct eeh_dev *edev, char * buf, size_t len)
> >  	}
> >  
> >  	/* If PCI-E capable, dump PCI-E cap 10, and the AER */
> > -	cap = pci_find_capability(dev, PCI_CAP_ID_EXP);
> > -	if (cap) {
> > +	if (pci_is_pcie(dev)) {
> >  		n += scnprintf(buf+n, len-n, "pci-e cap10:\n");
> >  		printk(KERN_WARNING
> >  		       "EEH: PCI-E capabilities and status follow:\n");

So we remove reading of "cap", but slightly further down the code does:

		for (i=0; i<=8; i++) {
			eeh_ops->read_config(dn, cap+4*i, 4, &cfg);
			n += scnprintf(buf+n, len-n, "%02x:%x\n", 4*i, cfg);
			printk(KERN_WARNING "EEH: PCI-E %02x: %08x\n", i, cfg);
		}

Which actually *uses* the value of "cap" ... oops :-)

> > diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
> > index 46ac1dd..5402a1d 100644
> > --- a/arch/powerpc/sysdev/fsl_pci.c
> > +++ b/arch/powerpc/sysdev/fsl_pci.c
> > @@ -41,7 +41,7 @@ static void quirk_fsl_pcie_header(struct pci_dev *dev)
> >  	u8 hdr_type;
> >  
> >  	/* if we aren't a PCIe don't bother */
> > -	if (!pci_find_capability(dev, PCI_CAP_ID_EXP))
> > +	if (!pci_is_pcie(dev))
> >  		return;
> >  
> >  	/* if we aren't in host mode don't bother */
> > -- 
> > 1.7.1
> > 
> > 


