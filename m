Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579AbaLQWhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 17:37:11 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44494 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaLQWhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 17:37:10 -0500
Message-ID: <54920597.6090305@ti.com>
Date: Wed, 17 Dec 2014 17:37:11 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Christopher Li <sparse@chrisli.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to fix CHECK warning: testing a 'safe expression' ?
References: <54907884.2040502@ti.com> <5491ACE6.4070108@ti.com> <CAErSpo4hwMPOYBDZTu_fgKaUDYZ4h+jVpz5EigpErOgo6xO8mQ@mail.gmail.com> <54920529.4080007@ti.com>
In-Reply-To: <54920529.4080007@ti.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2014 05:35 PM, Murali Karicheri wrote:
> On 12/17/2014 01:49 PM, Bjorn Helgaas wrote:
>> [+cc Christopher, linux-kernel (this doesn't sound like a PCI-specific
>> question)]
>>
>> On Wed, Dec 17, 2014 at 9:18 AM, Murali Karicheri<m-karicheri2@ti.com>
>> wrote:
>>> I am trying to address CHECK warnings in my driver and wondering how to
>>> resolve 'warning: testing a 'safe expression' which appears when using
>>> IS_ERR_OR_NULL(foo)
>>>
>>> where foo is defined as
>>>
>>> struct foo_type *foo;
>>>
>>> The foo get assigned only NULL or ERR_PTR(error code). So I believe the
>>> usage is correct. But then how do I make the CHECK happy of its usage?
>>>
>>> I have tried a grep to check on the current usage of IS_ERR_OR_NULL()
>>> and
>>> found 276 of them causes this warning in the v3.18 version of the kernel
>>> that I am using
>>>
>>> $ grep -r "warning: testing a 'safe expression" * | wc -l
>>> 276
>>>
>>> Can someone help me undestand what this means and how to fix the same?
>>>
>>> I run folling for CHECK
>>>
>>> make C=2 CF="-D__CHECK_ENDIAN__" CHECK=sparse
>>
>> If you can share your actual code or point to it in the tree, you
>> might get more specific help.
>>
>> Bjorn
>
> For example I get
>
> CHECK drivers/pci/host/pci-keystone.c
> include/linux/err.h:40:16: warning: testing a 'safe expression'
>
> Actually it is for IS_ERR_OR_NULL() call in the file which is the only
> one call in the file.
>
Here is the code snippet for your convenience

	struct device *dev = &pdev->dev;
	struct keystone_pcie *ks_pcie;
	struct pcie_port *pp;
	struct resource *res;
	void __iomem *reg_p;
	struct phy *phy;
	int ret = 0;

	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
				GFP_KERNEL);
	if (!ks_pcie) {
		dev_err(dev, "no memory for keystone pcie\n");
		return -ENOMEM;
	}
	pp = &ks_pcie->pp;

	/* initialize SerDes Phy if present */
	phy = devm_phy_get(dev, "pcie-phy");
===>    if (!IS_ERR_OR_NULL(phy)) {
		ret = phy_init(phy);
		if (ret < 0)
			return ret;
	}



-- 
Murali Karicheri
Linux Kernel, Texas Instruments
