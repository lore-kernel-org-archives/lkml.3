Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763196Ab3IDRYn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:24:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:10173 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755638Ab3IDRYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:24:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1022,1367996400"; 
   d="scan'208";a="391064511"
From: "Keller, Jacob E" <jacob.e.keller@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yijing Wang <wangyijing@huawei.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Gavin Shan <shangw@linux.vnet.ibm.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH 5/7] ixgbe: use pcie_capability_read_word() to simplify
 code
Thread-Topic: [PATCH 5/7] ixgbe: use pcie_capability_read_word() to simplify
 code
Thread-Index: AQHOqHieROjV5T8ge0ep4iCOoL6z/5m2ObYAgAAR84A=
Date: Wed, 4 Sep 2013 17:24:37 +0000
Message-ID: <1378315477.8626.9.camel@jekeller-desk1.amr.corp.intel.com>
References: <1378193715-25328-1-git-send-email-wangyijing@huawei.com>
	 <1378193715-25328-5-git-send-email-wangyijing@huawei.com>
	 <20130904162022.GE24733@google.com>
In-Reply-To: <20130904162022.GE24733@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [134.134.173.156]
Content-Type: text/plain; charset="utf-8"
Content-ID: <55CE56081959964385C745B0FB3C7AF3@intel.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r84HOnYP024485

On Wed, 2013-09-04 at 10:20 -0600, Bjorn Helgaas wrote:
> [+cc Jacob, Jeff]
> 
> On Tue, Sep 03, 2013 at 03:35:13PM +0800, Yijing Wang wrote:
> > use pcie_capability_read_word() to simplify code.
> > 
> > Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> > Cc: e1000-devel@lists.sourceforge.net
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |    6 ++----
> >  1 files changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > index bad8f14..bfa0b06 100644
> > --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> > @@ -152,7 +152,6 @@ MODULE_VERSION(DRV_VERSION);
> >  static int ixgbe_read_pci_cfg_word_parent(struct ixgbe_adapter *adapter,
> >  					  u32 reg, u16 *value)
> >  {
> > -	int pos = 0;
> >  	struct pci_dev *parent_dev;
> >  	struct pci_bus *parent_bus;
> >  
> > @@ -164,11 +163,10 @@ static int ixgbe_read_pci_cfg_word_parent(struct ixgbe_adapter *adapter,
> >  	if (!parent_dev)
> >  		return -1;
> >  
> > -	pos = pci_find_capability(parent_dev, PCI_CAP_ID_EXP);
> > -	if (!pos)
> > +	if (!pci_is_pcie(parent_dev))
> >  		return -1;
> >  
> > -	pci_read_config_word(parent_dev, pos + reg, value);
> > +	pcie_capability_read_word(parent_dev, reg, value);
> >  	return 0;
> >  }
> >  
> 
> Here's the caller of ixgbe_read_pci_cfg_word_parent():
> 
>     /* Get the negotiated link width and speed from PCI config space of the
>      * parent, as this device is behind a switch
>      */
>     err = ixgbe_read_pci_cfg_word_parent(adapter, 18, &link_status);
> 
> This should be using PCI_EXP_LNKSTA instead of "18".

Absolutely.. Not sure why I didn't do this originally.....

> 
> But it would be even better if we could drop ixgbe_get_parent_bus_info()
> completely.  It seems redundant after merging Jacob's new
> pcie_get_minimum_link() stuff [1].

I don't know if we can fully drop it. We need this in order to read the
parent device on some quad port Ethernet adapters which have an internal
PCIe switch to link two parts together. There are a few places we read
the parent cfg word. At least one for sure.. but maybe others.. Can't
recall. The parent bus info is still used to print out the slot width
and speed. I don't know if it would be better to just print the response
from get_minimum_link or still print the actual slot.

> 
> ixgbe_disable_pcie_master() looks like it should be using
> pcie_capability_read_word() with PCI_EXP_DEVSTA instead of using
> IXGBE_PCI_DEVICE_STATUS.  If fact, it looks like it could use the
> new pci_wait_for_pending_transaction() interface [2].
> 

I can look at doing this. I know it was done this way for historic
reasons, (and likely for code share with non Linux drivers.. but that's
not really an excuse)

> It looks like all the #defines in the "PCI Bus Info" block
> (IXGBE_PCI_DEVICE_STATUS, IXGBE_PCI_DEVICE_STATUS_TRANSACTION_PENDING,
> IXGBE_PCI_LINK_STATUS, etc.) [3] are really for PCIe-generic things.  If
> so, the IXGBE-specific ones should be dropped in favor of the generic
> ones.

Agreed.

Thanks,
Jake


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
