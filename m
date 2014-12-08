Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521AbaLHHOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:14:08 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:65533 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754457AbaLHHOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:14:03 -0500
Message-ID: <54854FB2.8080206@linaro.org>
Date: Mon, 08 Dec 2014 08:13:54 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>
CC: linux-arm-kernel@lists.infradead.org, Myron Stowe <myron.stowe@gmail.com>,
        rjw@rjwysocki.net, lorenzo.pieralisi@arm.com,
        linaro-acpi@lists.linaro.org, linux-pci <linux-pci@vger.kernel.org>,
        catalin.marinas@arm.com, x86 <x86@kernel.org>, will.deacon@arm.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, hanjun.guo@linaro.org,
        "H. Peter Anvin" <hpa@zytor.com>, wangyijing@huawei.com,
        Liviu.Dudau@arm.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] pci, acpi: Share ACPI PCI config space accessors.
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org> <3957412.IooRKpIXjW@wuerfel> <20141121180825.GD6578@google.com> <2178540.dTppAIY2rE@wuerfel>
In-Reply-To: <2178540.dTppAIY2rE@wuerfel>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 24.11.2014 o 11:41, Arnd Bergmann pisze:
> On Friday 21 November 2014 11:08:25 Bjorn Helgaas wrote:
>> On Fri, Nov 21, 2014 at 01:24:52PM +0100, Arnd Bergmann wrote:
>>> On Thursday 20 November 2014 21:00:17 Myron Stowe wrote:
>>>> On Thu, Nov 20, 2014 at 3:26 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>
>>>>> That's interesting.  I would have said exactly the opposite -- I think the
>>>>> extra Kconfiggery is harder to follow than weak/strong functions
>>>>>
>>>>> But consistency is better than my personal opinion.  Is there a consensus
>>>>> that we should use the Kconfig strategy instead of __weak?
>>>>
>>>> I too find weak/strong functions easier to follow than "Kconfiggery" (nice term
>>>> invention there).
>>>
>>> I don't think there is a universal consensus, but the majority of
>>> maintainers seems to avoid them for the same reasons that I think
>>> __weak is problematic.
>>>
>>> We have some uses of __weak in the core kernel, but there is
>>> basically none in drivers outside of PCI, and the most common
>>> uses are all providing an empty __weak function that can be
>>> overridden with a function that actually does something, unlike
>>> the code above.
>>
>> One thing I like better about __weak (when used correctly) is that you have
>> exactly one declaration, and the role of each definition (weak default
>> implementation or strong override) is obvious from looking at it.
>
> Right.
>
>> In your #ifdef example, the extern declaration and the inline definition
>> are never compiled together, so you have to repeat the signature and the
>> compiler doesn't enforce that they match.  So you end up with the extern
>> and the inline in one file, a #define in an arch header file or Kconfig,
>> and an arch definition in a third file.
>>
>> But it's certainly true that everybody knows how #ifdef works, and the fact
>> that __weak on a declaration affects all in-scope definitions is definitely
>> a land mine (multiple weak definitions with no strong one is a disaster).
>>
>>> My pragmatic approach so far has been to advocate __weak for
>>> drivers/pci patches but discourage it elsewhere when I review
>>> patches, in order to maintain consistency. I also think it
>>> would be nice to change the way that PCI handles architecture
>>> specific overrides in the process of unifying the host bridge
>>> handling.
>>>
>>> I wouldn't use Kconfig symbols in most cases though. My preferred
>>> choice would be to turn a lot of the __weak symbols into function
>>> pointers within a per-hostbridge structure. As an example, we could
>>> replace pcibios_add_device() with a pointer in pci_host_bridge->ops
>>> that gets set by all the architectures and host drivers that currently
>>> override it, and replace the one caller with
>>>
>>> 	if (pci_host_bridge->ops->add_device)
>>> 		pci_host_bridge->ops->add_device(dev);
>>
>> I definitely agree with this part, but I think it's orthogonal to the
>> __weak question.  In this case, we'd like to support multiple host bridges,
>> each with a different flavor of add_device().  We can't do that at all with
>> either __weak or #ifdef.
>
> What we currently have though is a a __weak definition of add_device,
> which some architectures override, and some of them (ARM in particular)
> by implementing their own abstraction. I suspect for the majority of
> what we currently define as __weak functions, we could use a similar
> approach and kill off the global symbols entirely.

What would be next steps regarding this patch set? I am not sure we have 
reached a consensus on weak vs #ifdef choice.

Regards,
Tomasz

