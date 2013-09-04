Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761693Ab3IDDDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 23:03:45 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:47732 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3IDDDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 23:03:43 -0400
MIME-Version: 1.0
In-Reply-To: <5220FB48.7080607@wwwdotorg.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org>
	<1377150793-27864-6-git-send-email-mturquette@linaro.org>
	<CAD6h2NRBq8hD8J5+P4NBZJZsPo4QAebgGaxmAn5TL0c2Cc5ULQ@mail.gmail.com>
	<5220FB48.7080607@wwwdotorg.org>
Date: Wed, 4 Sep 2013 11:03:42 +0800
Message-ID: <CAD6h2NSr0cM_SWqniC30pYm0mCeziBOzVg-46-814qPMxUwDCQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/5] clk: dt: binding for basic gate clock
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mike Turquette <mturquette@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 August 2013 04:06, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/29/2013 07:45 PM, Haojian Zhuang wrote:
>> On 22 August 2013 13:53, Mike Turquette <mturquette@linaro.org> wrote:
>>> Device Tree binding for the basic clock gate, plus the setup function to
>>> register the clock.  Based on the existing fixed-clock binding.
>>>
>>> A different approach to this was proposed in 2012[1] and a similar
>>> binding was proposed more recently[2] if anyone wants some extra
>>> reading.
>
>>> diff --git a/Documentation/devicetree/bindings/clock/gate-clock.txt b/Documentation/devicetree/bindings/clock/gate-clock.txt
>
>>> +Binding for simple gate clock.
> ...
>>> +       clock_foo: clock_foo@4a008100 {
>>> +               compatible = "gate-clock";
>>> +               #clock-cells = <0>;
>>> +               clocks = <&clock_bar>;
>>> +               reg = <0x4a008100 0x4>
>>> +               bit-shift = <3>
>>
>> There's some argument on my clock binding patch set of Hi3620.
>>
>> I defined each clock as one clock node and some of them are sharing one
>> register. Stephen attacked on this since it means multiple clock node sharing
>> one register.
>
> s/attacked/disagreed with/ I think:-)
>
>> Now the same thing also exists in Mike's patch. Mike's patch could also
>> support this behavior. And it's very common that one register is sharing among
>> multiple clocks in every SoC. Which one should I follow?
>
> I believe it's a matter of how the HW is structured.
>
> If the HW truly has segregated register regions for each individual
> clock, and is documented in a way that implies each individual clock is
> a separate HW module, then it makes sense to describe each clock as a
> separate DT node.
>
> However, if the HW simply has a "clock module" that provides many
> clocks, with inter-mingled registers all over the place, and is
> documented as a single module that generates lots of clocks, then it
> makes sense to describe that one module as a single DT node.
>
> In other words, the DT representation should match the HW design and
> documentation.
>
> This is exactly why we have the #clock-cells property in DT; so that a
> clock provider can provide multiple clocks if that's the way the HW is
> designed.
>
>>> diff --git a/drivers/clk/clk-gate.c b/drivers/clk/clk-gate.c
>
>>> +void of_gate_clk_setup(struct device_node *node)
>>> +{
>>> +       struct clk *clk;
>>> +       const char *clk_name = node->name;
>>> +       void __iomem *reg;
>>> +       const char *parent_name;
>>> +       u8 clk_gate_flags = 0;
>>> +       u32 bit_idx = 0;
>>> +
>>> +       of_property_read_string(node, "clock-output-names", &clk_name);
>>> +
>>> +       parent_name = of_clk_get_parent_name(node, 0);
>>> +
>>> +       reg = of_iomap(node, 0);
>>
>> I suggest not using of_iomap for each clock node.
>>
>> If each clock is one node, it means hundreds of clock node existing in
>> device tree. Hundreds of mapping page only cost unnecessary mapping.
>
> The page table entries will get re-used. I'm not familiar with the mm
> code, but multiple of_iomap() for the exact same range probably just map
> down to incrementing a refcount on some kernel data structure, so
> actually has zero overhead?

I think it's not right. Let check the implemenation in ioremap().

__arm_ioremap_pfn_caller():

    /* try to reuse one of the static mapping whenever possible. */
    svm = find_static_vm_paddr();
    if (svm) {
         addr = svm->vm.addr;
         addr += paddr - svm->vm.phys_addr;
         return (void __iomem *)(offset + addr);
    }
    ...

    area = get_vm_area_caller(size, VM_IOREMAP, caller);
    addr = area->addr;
    ioremap_page_range(addr, addr+size, paddr, ..);

We can see that it'll try to find static mapping. What's the static mapping?
If we define iotable in machine driver, we have the static mapping, just like
debug_ll. If we parse everything from DTS file, it'll always get a new virtual
address from vm area. So it always create a new page mapping even for one
register.

>
>
>> Maybe we can resolve it by this way.
>>
>> DTS file:
>>         clock register bank {
>
> You need a compatible value here, in order to instantiate the top-level
> driver for the "clock generator" HW block.
>
>>                 reg = <{start} {size}>;
>>                 #address-cells = <1>;
>>                 #size-cells = <0>;             /* each clock only
>> exists in one register */
>
> You would need a ranges property here, to map the child reg properties
> into the parent node's address space.
>
>>                 clock node {
>>                         compatible = "xxx";
>>                         #clock-cells = <0>;
>>                         clock-output-names = yyy";
>>                         reg = <{offset}>;
>>                         ... other properties ...
>>                 };
>>          };
>
> That could be a reasonable solution; the existence of a single "clock
> generator" HW block is clearly called out by the existing of the
> top-level DT node, yet the internals of that node are free to be
> whatever you want, since this is purely defined by the binding
> definition for that top-level "clock generator" node.
>
> That all said, I see almost zero value in having all these child nodes,
> since the top-level compatible value implies every single detail about
> the HW, so the list of clocks and their parameters could just as easily
> be a table in the driver for the HW, in order to avoid having to parse
> that data every boot just to end up with the same table...
>
> The only exception would be if the SoC designer truly had composed the
> top-level "clock generator" HW block out of many completely independent
> re-usable clock IP blocks, and many SoCs existed that used those
> individual clock blocks completely unchanged, without any SoC-specific
> differences such as additional SoC-specific clock block types, so that
> one could get greater re-use by parametrizing everything in DT. In my
> (perhaps limited) experience of SoCS, this seems like an /extremely/
> unlikely situation.
>
