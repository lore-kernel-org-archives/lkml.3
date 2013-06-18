Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab3FRMBs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:01:48 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:60773 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932298Ab3FRMBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 08:01:45 -0400
Message-ID: <51C04C23.4090807@gmail.com>
Date: Tue, 18 Jun 2013 14:01:39 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Lior Amsalem <alior@marvell.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] pinctrl: mvebu: dove pinctrl driver
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347550912-18021-1-git-send-email-sebastian.hesselbarth@gmail.com> <1347550912-18021-3-git-send-email-sebastian.hesselbarth@gmail.com> <20130618113606.GA26763@n2100.arm.linux.org.uk>
In-Reply-To: <20130618113606.GA26763@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/13 13:36, Russell King - ARM Linux wrote:
> On Thu, Sep 13, 2012 at 05:41:44PM +0200, Sebastian Hesselbarth wrote:
>> +#define DOVE_GLOBAL_CONFIG_1		(DOVE_SB_REGS_VIRT_BASE | 0xe802C)
>> +#define  DOVE_TWSI_ENABLE_OPTION1	BIT(7)
>> +#define DOVE_GLOBAL_CONFIG_2		(DOVE_SB_REGS_VIRT_BASE | 0xe8030)
>> +#define  DOVE_TWSI_ENABLE_OPTION2	BIT(20)
>> +#define  DOVE_TWSI_ENABLE_OPTION3	BIT(21)
>> +#define  DOVE_TWSI_OPTION3_GPIO		BIT(22)
> ...

Russell,

the above absolute addresses already made me think of cleaning up dove
pinctrl a while ago. I also had in mind that below function exclusively
request ownership of global config registers.

>> +static int dove_twsi_ctrl_set(struct mvebu_mpp_ctrl *ctrl,
>> +				unsigned long config)
>> +{
>> +	unsigned long gcfg1 = readl(DOVE_GLOBAL_CONFIG_1);
>> +	unsigned long gcfg2 = readl(DOVE_GLOBAL_CONFIG_2);
>> +
>> +	gcfg1 &= ~DOVE_TWSI_ENABLE_OPTION1;
>> +	gcfg2 &= ~(DOVE_TWSI_ENABLE_OPTION2 | DOVE_TWSI_ENABLE_OPTION2);
>> +
>> +	switch (config) {
>> +	case 1:
>> +		gcfg1 |= DOVE_TWSI_ENABLE_OPTION1;
>> +		break;
>> +	case 2:
>> +		gcfg2 |= DOVE_TWSI_ENABLE_OPTION2;
>> +		break;
>> +	case 3:
>> +		gcfg2 |= DOVE_TWSI_ENABLE_OPTION3;
>> +		break;
>> +	}
>> +
>> +	writel(gcfg1, DOVE_GLOBAL_CONFIG_1);
>> +	writel(gcfg2, DOVE_GLOBAL_CONFIG_2);
>> +
>> +	return 0;
>> +}
>
> So, I've just been thinking about the LCD clocking on the Armada 510,
> and found that there's dividers for the internal LCD clocks in the
> global config 1/2 registers.  So I grepped the kernel source for
> references to these, expecting to find something in drivers/clk, but
> found the above.

We have no peripheral clock handling for Dove, yet. Just core clocks and
clock gates are implemented. And I guess they are DT only anyway.

> However, todays kernel is sometimes SMP, commonly with kernel preemption
> enabled, maybe even RT.  This makes things like the above sequence a
> problem where a multifunction register is read, modified and then
> written back.
>
> Consider two threads doing this, and a preemption event happening in the
> middle of this sequence to another thread also doing a read-modify-write
> of the same register.  Which one wins depends on the preemption sequence,
> but ultimately one loses out.

Yeah, sure. We have the same issue with watchdog driver messing with
timer registers. There I exported a function to _clrset TIMER_CTRL
register safely. Just went into irqchip (tip for-next).

> Any access to such registers needs careful thought, and protection in some
> manner.
>
> Maybe what we need is something like this:
>
> static DEFINE_SPINLOCK(io_lock);
> static void modifyl(u32 new, u32 mask, void __iomem *reg)
> {
> 	unsigned long flags;
> 	u32 val;
>
> 	spin_lock_irqsave(&io_lock, flags);
> 	val = readl(reg) & ~mask;
> 	val |= new | mask;
> 	writel(val, reg);
> 	spin_unlock_irqrestore(&io_lock, flags);
> }
>
> in order to provide arbitrated access to these kinds of multifunction
> registers in a safe, platform agnostic way.

I am fine with a generic modify function with a single lock. Most cases
should be fine with a single lock even for non-related register
accesses, e.g. watchdog will access TIMER_CTRL only once to enable
itself. If you think you need a special lock because you have a lot of
writes to shared registers, you can still have your own modify lock.

Sebastian
