Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751499AbaGGQy1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:54:27 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40126 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbaGGQyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:54:24 -0400
Message-ID: <53BAD07C.2010302@ti.com>
Date: Mon, 7 Jul 2014 12:53:16 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush ANAND <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v3 2/5] PCI: designware: refactor MSI code to work with
 v3.65 dw hardware
References: <1404164720-11066-1-git-send-email-m-karicheri2@ti.com> <1404164720-11066-3-git-send-email-m-karicheri2@ti.com> <2CC2A0A4A178534D93D5159BF3BCB661A17A3E4291@EAPEX1MAIL1.st.com>
In-Reply-To: <2CC2A0A4A178534D93D5159BF3BCB661A17A3E4291@EAPEX1MAIL1.st.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 12:17 AM, Mohit KUMAR DCG wrote:
> Hello Murali,
>
>> -----Original Message-----
>> From: Murali Karicheri [mailto:m-karicheri2@ti.com]
>> Sent: Tuesday, July 01, 2014 3:15 AM
>> To: linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org;
>> devicetree@vger.kernel.org
>> Cc: Murali Karicheri; Santosh Shilimkar; Russell King; Grant Likely; Rob Herring;
>> Mohit KUMAR DCG; Jingoo Han; Bjorn Helgaas; Pratyush ANAND; Richard
>> Zhu; Kishon Vijay Abraham I; Marek Vasut; Arnd Bergmann; Pawel Moll;
>> Mark Rutland; Ian Campbell; Kumar Gala; Randy Dunlap
>> Subject: [PATCH v3 2/5] PCI: designware: refactor MSI code to work with
>> v3.65 dw hardware
>>
>> Keystone PCI controller is based on v3.65 version of the DW PCI h/w that
>> implements MSI controller registers in application space compared to the
>> newer version. This requires updates to the DW core API to support the PCI
>> controller driver based on this old DW hardware. Add msi_irq_set()/clear()
>> API functions to allow Set/Clear MSI IRQ enable bit in the application register.
>> Also the old h/w uses MSI_IRQ register in application register space to raise
>> MSI IRQ to the RC from EP. Current code uses the standard mechanism as
>> per PCI spec. So add another API get_msi_data() to get the address of this
>> register so that common code can be re-used on old h/w.
>>
>> Signed-off-by: Murali Karicheri<m-karicheri2@ti.com>
>>
>> CC: Santosh Shilimkar<santosh.shilimkar@ti.com>
>> CC: Russell King<linux@arm.linux.org.uk>
>> CC: Grant Likely<grant.likely@linaro.org>
>> CC: Rob Herring<robh+dt@kernel.org>
>> CC: Mohit Kumar<mohit.kumar@st.com>
>> CC: Jingoo Han<jg1.han@samsung.com>
>> CC: Bjorn Helgaas<bhelgaas@google.com>
>> CC: Pratyush Anand<pratyush.anand@st.com>
>> CC: Richard Zhu<r65037@freescale.com>
>> CC: Kishon Vijay Abraham I<kishon@ti.com>
>> CC: Marek Vasut<marex@denx.de>
>> CC: Arnd Bergmann<arnd@arndb.de>
>> CC: Pawel Moll<pawel.moll@arm.com>
>> CC: Mark Rutland<mark.rutland@arm.com>
>> CC: Ian Campbell<ijc+devicetree@hellion.org.uk>
>> CC: Kumar Gala<galak@codeaurora.org>
>> CC: Randy Dunlap<rdunlap@infradead.org>
>> CC: Grant Likely<grant.likely@linaro.org>
>> ---
>>   drivers/pci/host/pcie-designware.c |   50 ++++++++++++++++++++++++++-
>> ---------
>>   drivers/pci/host/pcie-designware.h |    3 +++
>>   2 files changed, 39 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
>> designware.c
>> index d8f3af7..905941c 100644
>> --- a/drivers/pci/host/pcie-designware.c
>> +++ b/drivers/pci/host/pcie-designware.c
>> @@ -217,27 +217,47 @@ static int find_valid_pos0(struct pcie_port *pp, int
>> msgvec, int pos, int *pos0)
>>   	return 0;
>>   }
>>
>> +static void dw_pcie_msi_clear_irq(struct pcie_port *pp, int irq) {
>> +	unsigned int res, bit, val;
>> +
>> +	res = (irq / 32) * 12;
>> +	bit = irq % 32;
>> +	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4,&val);
>> +	val&= ~(1<<  bit);
>> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val); }
>> +
>>   static void clear_irq_range(struct pcie_port *pp, unsigned int irq_base,
>>   			    unsigned int nvec, unsigned int pos)  {
>> -	unsigned int i, res, bit, val;
>> +	unsigned int i;
>>
>>   	for (i = 0; i<  nvec; i++) {
>>   		irq_set_msi_desc_off(irq_base, i, NULL);
>>   		clear_bit(pos + i, pp->msi_irq_in_use);
>>   		/* Disable corresponding interrupt on MSI controller */
>> -		res = ((pos + i) / 32) * 12;
>> -		bit = (pos + i) % 32;
>> -		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
>> 4,&val);
>> -		val&= ~(1<<  bit);
>> -		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
>> 4, val);
>> +		if (pp->ops->msi_clear_irq)
>> +			pp->ops->msi_clear_irq(pp, pos + i);
>> +		else
>> +			dw_pcie_msi_clear_irq(pp, pos + i);
>>   	}
>>   }
>>
>> +static void dw_pcie_msi_set_irq(struct pcie_port *pp, int irq) {
>> +	unsigned int res, bit, val;
>> +
>> +	res = (irq / 32) * 12;
>> +	bit = irq % 32;
>> +	dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4,&val);
>> +	val |= 1<<  bit;
>> +	dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res, 4, val); }
>> +
>>   static int assign_irq(int no_irqs, struct msi_desc *desc, int *pos)  {
>> -	int res, bit, irq, pos0, pos1, i;
>> -	u32 val;
>> +	int irq, pos0, pos1, i;
>>   	struct pcie_port *pp = sys_to_pcie(desc->dev->bus->sysdata);
>>
>>   	if (!pp) {
>> @@ -281,11 +301,10 @@ static int assign_irq(int no_irqs, struct msi_desc
>> *desc, int *pos)
>>   		}
>>   		set_bit(pos0 + i, pp->msi_irq_in_use);
>>   		/*Enable corresponding interrupt in MSI interrupt controller
>> */
>> -		res = ((pos0 + i) / 32) * 12;
>> -		bit = (pos0 + i) % 32;
>> -		dw_pcie_rd_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
>> 4,&val);
>> -		val |= 1<<  bit;
>> -		dw_pcie_wr_own_conf(pp, PCIE_MSI_INTR0_ENABLE + res,
>> 4, val);
>> +		if (pp->ops->msi_set_irq)
>> +			pp->ops->msi_set_irq(pp, pos0 + i);
>> +		else
>> +			dw_pcie_msi_set_irq(pp, pos0 + i);
>>   	}
>>
>>   	*pos = pos0;
>> @@ -353,7 +372,10 @@ static int dw_msi_setup_irq(struct msi_chip *chip,
>> struct pci_dev *pdev,
>>   	 */
>>   	desc->msi_attrib.multiple = msgvec;
>>
>> -	msg.address_lo = virt_to_phys((void *)pp->msi_data);
>> +	if (pp->ops->get_msi_data)
>> +		msg.address_lo = pp->ops->get_msi_data(pp);
>> +	else
>> +		msg.address_lo = virt_to_phys((void *)pp->msi_data);
>>   	msg.address_hi = 0x0;
>>   	msg.data = pos;
>>   	write_msi_msg(irq,&msg);
>> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-
>> designware.h
>> index 8121901..387f69e 100644
>> --- a/drivers/pci/host/pcie-designware.h
>> +++ b/drivers/pci/host/pcie-designware.h
>> @@ -67,6 +67,9 @@ struct pcie_host_ops {
>>   			unsigned int devfn, int where, int size, u32 val);
>>   	int (*link_up)(struct pcie_port *pp);
>>   	void (*host_init)(struct pcie_port *pp);
>> +	void (*msi_set_irq)(struct pcie_port *pp, int irq);
>> +	void (*msi_clear_irq)(struct pcie_port *pp, int irq);
>> +	u32 (*get_msi_data)(struct pcie_port *pp);
>>   };
>>
>>   int dw_pcie_cfg_read(void __iomem *addr, int where, int size, u32 *val);
>
> - Now MSI specific dw code can be shared b/w old Synopsys controller (ver<  3.70)
> and newer controller that standardize the MSI settings inside design ware core itself.
>
> Jingoo,
>
> Pls let us know if you have any concern or comment over this.
>
> Acked-by: Mohit Kumar<mohit.kumar@st.com>
>
> Regards
> Mohit
>
>> --
>> 1.7.9.5
>
Mohit,

Thanks.

Jingoo, could you provide your response or Ack?

Thanks
