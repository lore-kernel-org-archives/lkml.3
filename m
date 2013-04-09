Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936522Ab3DILju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:39:50 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:36717 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab3DILjs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:39:48 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCH arm: initial TI-Nspire support]
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <CACRpkdbuAvRzVdzKL51k5d7vVpGNUHh_f_ZAxP4m3zFdBOV=xw@mail.gmail.com>
Date: Tue, 9 Apr 2013 21:39:39 +1000
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        fabian@ritter-vogt.de, Lionel Debroux <lionel_debroux@yahoo.fr>
Content-Transfer-Encoding: 7BIT
Message-Id: <EE94A8F2-2BC2-446E-B0B2-1E1803E240F2@gmail.com>
References: <6FE4B33E-A503-4A75-AEED-831CB2C06D83@gmail.com> <CACRpkdbuAvRzVdzKL51k5d7vVpGNUHh_f_ZAxP4m3zFdBOV=xw@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your comments! They're much appreciated. 

Just to bring you up to speed, we decided to begin reimplementing the machine from scratch and slowly pull things in from the original patch. Arnd pointed out a lot of fundamental issues with our patch so we thought it'd be better to just start over instead of patch things up.

The latest copy of our patch is somewhere in this thread (http://archive.arm.linux.org.uk/lurker/message/20130408.113343.585af217.en.html) which will have already addressed some of the problems you've pointed out (using the device tree being a major one). We would also appreciate it if you could take a look at that one too.

On 09/04/2013, at 9:14 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> 
>> +union reg_clk_speed {
>> +       unsigned long raw;
>> +       struct {
>> +               unsigned long __padding0:1;
>> +               unsigned long base_cpu_ratio:7;
>> +               unsigned long is_base_27mhz:1;
>> +               unsigned long __padding1:3;
>> +               unsigned long cpu_ahb_ratio:3;
>> +               unsigned long __padding2:1;
>> +               unsigned long base_val:5;
>> +       } val;
>> +};
> Usually to try to fit a struct over a register range is not such a good
> idea in Linux.
> 
> Instead define abstract representations of what you want to do
> (remove everything named "padding" above, use proper data types instead
> of these unsigned longs and that complex union) then use offsets to
> registers and remap the base offset in memory.
> 
> It makes for simpler debugging and ability to properly use read|write[lwb]
> macros.

The structure is actually a bitfield. We'd readl() the raw unsigned long into the 'raw' field and then access the data via the 'val' structure. 

Should we be using bitmasks and bitshifting to get at those values instead?

> 
>> +static unsigned long classic_clocks_to_io(struct nspire_clk_speeds *clks)
>> +{
>> +       union reg_clk_speed reg;
>> +
>> +       BUG_ON(clks->div.base_cpu < 2);
>> +       BUG_ON(clks->div.cpu_ahb < 1);
>> +
>> +       reg.raw = 0;
>> +       reg.val.base_cpu_ratio = clks->div.base_cpu / 2;
>> +       reg.val.cpu_ahb_ratio = clks->div.cpu_ahb - 1;
>> +       reg.val.is_base_27mhz = (clks->base <= 27000000);
>> +       reg.val.base_val = (300 - (clks->base / 1000000)) / 6;
>> +
>> +       return reg.raw;
>> +}
> 
> And that avoid having to create special helper functions like this.
> 

Fair enough.

> 
>> +               int irqnr = readl(base + 0x24);
>> +               unsigned prev_priority;
>> +               handle_IRQ(irqnr, regs);
>> +
>> +               /* Reset priorities */
>> +               prev_priority = readl(IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x28));
>> +               writel(prev_priority, IOMEM(NSPIRE_INTERRUPT_VIRT_BASE + 0x2c));
>> +               return 1;
>> +       }
>> +       return 0;
>> +}
> 
> I don't understand this, put in  some explanation of what this function
> does please.

Yep gotcha. In future patches, we'll also put the magic numbers into proper defines.

> 
>> +asmlinkage void __exception_irq_entry
>> +       nspire_classic_handle_irq(struct pt_regs *regs)
>> +{
>> +       int serviced;
>> +
>> +       do {
>> +               void __iomem *reg_base = IOMEM(NSPIRE_INTERRUPT_VIRT_BASE);
> 
> Instead of casting this in every IRQ entry define a static local
> in the irq driver file to point to the base.
> 
> Avoids time in the IRQ handler, so it obviously the right thing to do.
> 
> Please also use a dynamic remapping ioremap* insteaf of
> this static IOMEM() thing.
> 
>> +               serviced = 0;
>> +
>> +               /* IRQ */
>> +               serviced += check_interrupt(reg_base, regs);
>> +               /* FIQ */
>> +               serviced += check_interrupt(reg_base + 0x100, regs);
> 
> Should you now handle FIQs first at all times?

Ah yes, that would make sense.

> 
> Hm, looks like you just forgot to select GENERIC_CLOCKEVENTS?
> 
> Strange if it works anyway :-/
> 
> We are comtemplating putting these things into drivers/timer,
> nothing decided yet.

That's fine, we'll deal with it when we pull this file into the 'good' patch.

> 
> Not only should this be done from devicetree, but exactly which
> synaptics driver are you using with this?
> 
> I don't think there is one in the kernel tree yet.
> 

It's this one here http://lxr.free-electrons.com/source/drivers/input/mouse/synaptics_i2c.c
> 
> 
> And with device tree it goes irrelevant.

Yep, this has been addressed in our updated patch.

> 
> Yours,
> Linus Walleij


Also, how would you like us to submit updates? Should we continue posting updated patches as replies to this thread?

Cheers,
tangrs