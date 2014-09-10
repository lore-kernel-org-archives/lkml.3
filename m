Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaIJBqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 21:46:49 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:64930 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbaIJBqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 21:46:45 -0400
Message-ID: <540FAD13.9030502@huawei.com>
Date: Wed, 10 Sep 2014 09:44:51 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Liviu Dudau <Liviu.Dudau@arm.com>
CC: Rob Herring <robherring2@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Rob Herring <robh+dt@kernel.org>,
        "Jason Gunthorpe" <jgunthorpe@obsidianresearch.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Will Deacon" <Will.Deacon@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-pci <linux-pci@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tanmay Inamdar <tinamdar@apm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Sinan Kaya <okaya@codeaurora.org>, Jingoo Han <jg1.han@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "Suravee Suthikulanit" <suravee.suthikulpanit@amd.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Device Tree ML" <devicetree@vger.kernel.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v10 07/10] OF: Introduce helper function for getting PCI
 domain_nr
References: <1410184472-17630-1-git-send-email-Liviu.Dudau@arm.com> <1410184472-17630-8-git-send-email-Liviu.Dudau@arm.com> <CAL_JsqJi8k1Goc3UmXhuxf9v7=4gJrYG_Di7v574PxS8TsJaXw@mail.gmail.com> <20140908145459.GO27864@e106497-lin.cambridge.arm.com> <CAL_JsqJdGKDVwJOpPp19OkVPGzR7Zqv3nh+ONHHaYnPLYTYoYg@mail.gmail.com> <20140908155931.GP27864@e106497-lin.cambridge.arm.com> <540E960D.7080408@huawei.com> <20140909084621.GS27864@e106497-lin.cambridge.arm.com> <540EC8CB.7010106@huawei.com> <20140909141122.GY27864@e106497-lin.cambridge.arm.com>
In-Reply-To: <20140909141122.GY27864@e106497-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.27.212]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.540FAD25.0079,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2011-05-27 18:58:46
X-Mirapoint-Loop-Id: 00588597c07062a49489c0bbfbc5ea0e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> OK. Sorry, I have one last question, because domain will be used to calculate the address used to
>> access PCI hardware config registers. So if DTS file doesn't report the domain, how do we know
>> we would access the right registers when we use the auto increment domain vaule ?
> 
> That's a good question and sides with Arnd's suggestion to try to mandate the presence of the PCI
> domain in the DTS. However, by grepping through the source code, it looks like the architectures
> that use the domain number for reading config registers (x86-based) are non-DT architectures,
> while DT-aware arches seem to ignore the domain number except when printing out messages. Is that
> another confirmation that most DT-aware architectures have only run with domain_nr = 0?
> 

Arnd's suggestion is make sense to me, thanks for Bjorn's detailed explanation, now I know domain_nr
is purely internal to kernel in DT-aware platform, it's not needed when access PCI config space.

Thanks!
Yijing.

> 
>> Has there a mechanism to make sure system can access the correct registers by the domain ?
> 
> Not as such if you look with x86 glasses. With the exception of powerpc all other architecures
> seem to happily assume domain_nr = 0 and ignore it in the computation of configuration registers
> offsets.
> 
> Best regards,
> Liviu
> 
>>
>> Thanks!
>> Yijing.
>>
>>>
>>> Best regards,
>>> Liviu
>>>
>>>>
>>>> PCI get domain by ACPI "_SEG" in IA64(drivers/acpi/pci_root.c)
>>>> ......
>>>> 	status = acpi_evaluate_integer(handle, METHOD_NAME__SEG, NULL,
>>>> 				       &segment);
>>>> 	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
>>>> 		dev_err(&device->dev,  "can't evaluate _SEG\n");
>>>> 		result = -ENODEV;
>>>> 		goto end;
>>>> 	}
>>>> .......
>>>>
>>>> Thanks!
>>>> Yijing.
>>>>
>>>>>
>>>>>> This function
>>>>>> is just a weird mixture of data retrieval and allocation. I think you
>>>>>> need to separate it into 2 functions.
>>>>>
>>>>> It is meant to do allocation with the retrieval being a short-cut (or fine
>>>>> control if you want).
>>>>>
>>>>> I need to think a bit more for a better solution.
>>>>>
>>>>> Best regards,
>>>>> Liviu
>>>>>
>>>>>>
>>>>>> Rob
>>>>>>
>>>>>
>>>>
>>>>
>>>> -- 
>>>> Thanks!
>>>> Yijing
>>>>
>>>>
>>>
>>
>>
>> -- 
>> Thanks!
>> Yijing
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> 


-- 
Thanks!
Yijing

