Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793Ab3IDC7q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:59:46 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54368 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754319Ab3IDC7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:59:44 -0400
Date: Tue, 3 Sep 2013 20:59:40 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Hanjun Guo <guohanjun@huawei.com>
Subject: Re: [PATCH 4/7] x86/pci: use pcie_cap to simplify code
Message-ID: <20130904025940.GD24733@google.com>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com>
 <1378193715-25328-4-git-send-email-wangyijing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378193715-25328-4-git-send-email-wangyijing@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 03:35:12PM +0800, Yijing Wang wrote:
> PCI core saves PCIe Cap offset in pcie_cap,
> use pcie_cap to simplify code.
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> ---
>  arch/x86/pci/fixup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
> index f5809fa..ee8330d 100644
> --- a/arch/x86/pci/fixup.c
> +++ b/arch/x86/pci/fixup.c
> @@ -288,7 +288,7 @@ static void pcie_rootport_aspm_quirk(struct pci_dev *pdev)
>  		 */
>  		list_for_each_entry(dev, &pbus->devices, bus_list) {
>  			/* There are 0 to 8 devices attached to this bus */
> -			cap_base = pci_find_capability(dev, PCI_CAP_ID_EXP);
> +			cap_base = dev->pcie_cap;
>  			quirk_aspm_offset[GET_INDEX(pdev->device, dev->devfn)] = cap_base + 0x10;

This should use PCI_EXP_LNKCTL instead of "0x10".

>  		}
>  		pbus->ops = &quirk_pcie_aspm_ops;

This quirk replaces the config accessors with ones that silently ignore
writes to ASPM control bits.  That really warrants at least a dev_info()
note here, and we should be using pci_bus_set_ops().

Even that is a little bit dubious because I don't think this is really
safe -- what happens if this quirk replaces the ops, then somebody
else replaces the ops again?  aer_inject.c at least keeps track of
the old ops and seems to fall back to them, but it seems fragile to
depend on every caller of pci_bus_set_ops() to do the right thing
there.

But this is beyond the scope of your patch, so if you just
add a dev_info() note and use pci_bus_set_ops(), that should be
enough for now.
