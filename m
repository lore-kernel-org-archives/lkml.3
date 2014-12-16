Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262AbaLPJnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:43:25 -0500
Received: from ns.mm-sol.com ([37.157.136.199]:48003 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLPJnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:43:21 -0500
Message-ID: <548FFEB0.9080604@mm-sol.com>
Date: Tue, 16 Dec 2014 11:43:12 +0200
From: Stanimir Varbanov <svarbanov@mm-sol.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/5] PCI: qcom: Add Qualcomm PCIe controller driver
References: <1418404441-5518-1-git-send-email-svarbanov@mm-sol.com> <1418404441-5518-5-git-send-email-svarbanov@mm-sol.com> <2577563.x0mEZJNVDQ@wuerfel>
In-Reply-To: <2577563.x0mEZJNVDQ@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for the comments!

On 12/12/2014 07:30 PM, Arnd Bergmann wrote:
> On Friday 12 December 2014 19:14:00 Stanimir Varbanov wrote:
>> The PCIe driver reuse the Designware common code for host
>> and MSI initialization, and also program the Qualcomm
>> application specific registers.
>>
>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> 
> Looks nice!
> 
>> +static int
>> +qcom_pcie_rd_own_conf(struct pcie_port *pp, int where, int size, u32 *val)
>> +{
>> +	if (where == PCI_CLASS_REVISION && size == 4) {
>> +		*val = readl(pp->dbi_base + PCI_CLASS_REVISION);
>> +		*val &= ~(0xffff << 16);
>> +		*val |= PCI_CLASS_BRIDGE_PCI << 16;
>> +		return PCIBIOS_SUCCESSFUL;
>> +	}
>> +
>> +	return dw_pcie_cfg_read(pp->dbi_base + (where & ~0x3), where,
>> +				size, val);
>> +}
> 
> Could you add a comment here to explain what this is for?

Sure I will add a comment. The issue is that the pci device class is not
reported correctly from the register.

> 
>> +static int __init qcom_pcie_probe(struct platform_device *pdev)
>> +{
> 
> I think it's a bug to mark this function as __init. It breaks
> deferred probing and detaching/reattaching the device trough sysfs.
> 

My bad, I have tried to avoid mismatch section warnings came up from
dw_pcie_host_init() which is annotated as __init. Do you think we need
to remove __init from dw_pcie_host_init() declaration and fix the
drivers accordingly?

> After you fix that, you can remove the __refdata below.
> 
>> +static struct platform_driver __refdata qcom_pcie_driver = {
>> +	.probe = qcom_pcie_probe,
>> +	.remove = qcom_pcie_remove,
>> +	.driver = {
>> +		.name = "qcom-pcie",
>> +		.of_match_table = qcom_pcie_match,
>> +	},
>> +};
> 
> 	Arnd
> 

regards,
Stan
