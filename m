Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007AbaGVPlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 11:41:37 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:33823 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351AbaGVPlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 11:41:35 -0400
MIME-Version: 1.0
In-Reply-To: <53CD424B.1090806@ti.com>
References: <1405696469-7172-1-git-send-email-m-karicheri2@ti.com>
 <1405696469-7172-5-git-send-email-m-karicheri2@ti.com> <CAL_JsqKheoWrSGtxPO=AE8g9iOAqfwRa=81Ku=Cfx8_gpDysOg@mail.gmail.com>
 <53C9839C.5090604@ti.com> <006001cfa485$4f4fcff0$edef6fd0$%han@samsung.com> <53CD424B.1090806@ti.com>
From: Rob Herring <robherring2@gmail.com>
Date: Tue, 22 Jul 2014 10:41:12 -0500
Message-ID: <CAL_JsqJXb28RHhZG9=-NACwAr1ooGhfMOPjtsTGO2s3Dx7ayxQ@mail.gmail.com>
Subject: Re: [PATCH v6 4/5] PCI: add PCI controller for keystone PCIe h/w
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Jingoo Han <jg1.han@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Pratyush Anand <pratyush.anand@st.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 11:39 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
> On 07/20/2014 09:44 PM, Jingoo Han wrote:
>>
>> On Saturday, July 19, 2014 5:29 AM, Murali Karicheri wrote:
>>>
>>> On 07/18/2014 03:31 PM, Rob Herring wrote:
>>>>
>>>> On Fri, Jul 18, 2014 at 10:14 AM, Murali Karicheri<m-karicheri2@ti.com>
>>>> wrote:
>>>
>>> --- Cut ---
>>>>>
>>>>> +
>>>>> +Optional properties:-
>>>>> +       phys: phandle to Generic Keystone SerDes phy for PCI
>>>>> +       phy-names: name of the Generic Keystine SerDes phy for PCI
>>>>> +         - If boot loader already does PCI link establishment, then
>>>>> phys and
>>>>> +           phy-names shouldn't be present.
>>>>> +       ti,enable-linktrain - Enable Link training.
>>>>> +         - If boot loader already does PCI link establishment, then
>>>>> this
>>>>> +           shouldn't be present.
>>>>
>>>>
>>>> Can't you read from the h/w if the link is trained?
>>
>>
>> I agree with Rob Herring's suggestion.
>>
>>>
>>> Yes.
>>>
>>> There are customers who use this driver with PCI Link setup done in the
>>> boot loader. This property tells the driver to bypass Link setup
>>> procedure in that case. Is this undesirable and if so. how other
>>> platforms handle it? Check first if link is trained or start the link
>>> setup procedure? Let me know. If this is fine, please provide your Ack.
>>
>>
>> Please, check the following code of Exynos PCIe diver.
>>
>> ./drivers/pci/host/pci-exynos.c
>>
>> static int exynos_pcie_establish_link(struct pcie_port *pp)
>> {
>>         struct exynos_pcie *exynos_pcie = to_exynos_pcie(pp);
>>         void __iomem *elbi_base = exynos_pcie->elbi_base;
>>         void __iomem *pmu_base = exynos_pcie->pmu_base;
>>
>>         if (dw_pcie_link_up(pp)) {
>>                 dev_err(pp->dev, "Link already up\n");
>>                 return 0;
>>         }
>>         .....
>>
>> In the case of Exynos PCIe, the Exynos PCIe driver checks the
>> h/w bit such as PCIE_ELBI_LTSSM_ENABLE bit of PCIE_ELBI_RDLH_LINKUP
>> offset register.
>>
>> If the link is already set up by the boot loader or other reasons,
>> the driver will skip some initialization codes.
>>
>> The first step is that you find such h/w bit for checking link up.
>> If so, please add the code for skipping, when the link is already
>> set up.
>>
> Rob, Jingoo,
>
> We have similar bit to check for Link status and I have removed the DT
> property and skip Link retrain if PCIe Link is already Up. I will be
> resending the series with Patch 4/5 updated.

For both keystone and exynos, is this status bit in the phy? If so,
sounds like this should be a standard phy function op.

Rob
