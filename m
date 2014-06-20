Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966755AbaFTVS3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 17:18:29 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49513 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757159AbaFTVS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 17:18:27 -0400
Message-ID: <53A4A4D3.1000908@ti.com>
Date: Fri, 20 Jun 2014 17:17:07 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 0/8] Add Keystone PCIe controller driver
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com> <2CC2A0A4A178534D93D5159BF3BCB6619C5F8169D1@EAPEX1MAIL1.st.com>
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB6619C5F8169D1@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry, my previous response was in html and not sure it has made to the 
list. I did
get an error as well. So resending my response.

On 6/18/2014 6:14 AM, Mohit KUMAR DCG wrote:
> Hello Murali,
>
>> -----Original Message-----
>> From: Murali Karicheri [mailto:m-karicheri2@ti.com]
>> Sent: Wednesday, June 11, 2014 12:21 AM
>> To:linux-arm-kernel@lists.infradead.org;linux-kernel@vger.kernel.org;
>> linux-pci@vger.kernel.org;devicetree@vger.kernel.org; linux-
>> doc@vger.kernel.org
>> Cc: Murali Karicheri; Santosh Shilimkar; Russell King; Grant Likely; Rob Herring;
>> Mohit KUMAR DCG; Jingoo Han; Bjorn Helgaas; Pratyush ANAND; Richard
>> Zhu; Kishon Vijay Abraham I; Marek Vasut; Arnd Bergmann; Pawel Moll;
>> Mark Rutland; Ian Campbell; Kumar Gala; Randy Dunlap
>> Subject: [PATCH v2 0/8] Add Keystone PCIe controller driver
>>
>> This patch adds a PCIe controller driver for Keystone SoCs. This is based on v1
>> of the series posted to the mailing list.
>>
> 1. I think your first patch is OK which handles platform specific ATU implementation.
>
> 2. For MSI part, I think you just need to add two new callbacks with pp-ops, something similar to:
> pp->ops->msi_set
>
> pp->ops->msi_clear
>
> With these two platform specific callbacks you should be able to manage MSI handling.
> So idea is that dw_msi code uses pp->ops->msi_set/clear if platform define these,
> otherwise use dw_msi_set/clear (which you need to refactor from existing code)
>
> So other than your keystone changes we expect 3 patches:
> --  1st same as you sent 1/8: for ATU handeling
> -- 2nd to refactor dw_msi_set/clear: refactor from existing code
Mohit,

Thanks for your comments.

Just want to be on the same page

1. In my original patch [PATCH v2 3/8] PCI: designware: update pcie core 
driver to work with dw hw version 3.65.
  I had following changes:-

diff --git a/drivers/pci/host/pcie-designware.c 
b/drivers/pci/host/pcie-designware.c

index e4bd19a..f985811 100644

--- a/drivers/pci/host/pcie-designware.c

+++ b/drivers/pci/host/pcie-designware.c

@@ -277,11 +277,15 @@ static int assign_irq(int no_irqs, struct msi_desc 
*desc, int *pos)

}

set_bit(pos0 + i, pp->msi_irq_in_use);

/*Enable corresponding interrupt in MSI interrupt controller */

-res = ((pos0 + i) / 32) * 12;

-bit = (pos0 + i) % 32;

-dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, &val);

-val |= 1 << bit;

-dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val);

+if (!(pp->version & DW_V3_65)) {

+res = ((pos0 + i) / 32) * 12;

+bit = (pos0 + i) % 32;

+dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,

+4, &val);

+val |= 1 << bit;

+dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,

+4, val);

+}

}


I assume you are referring to the above code for msi_set().  I missed to 
add similar code change to clear_irq().

So in assign_irq()

             if (pp->ops->msi_set)
                        pp->ops->msi_set()

Similarly in clear_irq()

             if (pp->ops->msi_clear)
                         pp->ops->msi_clear()


*pos = pos0;

@@ -349,7 +353,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip, 
struct pci_dev *pdev,

*/

desc->msi_attrib.multiple = msgvec;

-msg.address_lo = virt_to_phys((void *)pp->msi_data);

+if (pp->ops->get_msi_data)

+msg.address_lo = pp->ops->get_msi_data(pp);

+else

+msg.address_lo = virt_to_phys((void *)pp->msi_data);

msg.address_hi = 0x0;

msg.data = pos;


What about this code? This requires get_msi_data() as well

> -- 3rd to use pp->ops->msi_set/clear if defined.
Why not API enhancement and refactor the code in a single patch?

Murali
> Pls let us know for any issue or have different opinion.
>
> Regards
> Mohit
>
>
>
>   
>> --
>> 1.7.9.5


