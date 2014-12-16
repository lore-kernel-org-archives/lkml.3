Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaLPK2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 05:28:40 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:50545 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaLPK2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 05:28:38 -0500
Message-ID: <5490094D.6090300@arm.com>
Date: Tue, 16 Dec 2014 10:28:29 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Stefan Agner <stefan@agner.ch>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "jason@lakedaemon.net" <jason@lakedaemon.net>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] irqchip: vf610-mscm: add support for MSCM interrupt
 router
References: <1418594998-2361-1-git-send-email-stefan@agner.ch> <1418594998-2361-2-git-send-email-stefan@agner.ch> <548EB0FD.3030206@arm.com> <41a603b345dbee4f2507e80ea0f8bb96@agner.ch>
In-Reply-To: <41a603b345dbee4f2507e80ea0f8bb96@agner.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/12/14 20:58, Stefan Agner wrote:
> On 2014-12-15 10:59, Marc Zyngier wrote:
>> Hi Stefan,
>>
>> On 14/12/14 22:09, Stefan Agner wrote:
>>> This adds support for Vybrid's interrupt router. On VF6xx models,
>>> almost all peripherals can be accessed from either of the two
>>> CPU's, from the Cortex-A5 or from the Cortex-M4. The interrupt
>>> router routes the peripheral interrupts to the configured CPU.
>>>
>>> The driver makes use of the irqdomain hierarchy support. The
>>> parent is either the ARM GIC or the ARM NVIC interrupt controller
>>> depending on which CPU the kernel is executed on. Currently only
>>> ARM GIC is supported because the NVIC driver lacks hierarchical
>>> irqdomain support as of now.
>>>
>>> Currently, there is no resource control mechnism implemented to
>>> avoid concurrent access of the same peripheral. The user needs
>>> to make sure to use device trees which assign the peripherals
>>> orthogonally. However, this driver warns the user in case the
>>> interrupt is already configured for the other CPU. This provides
>>> a poor man's resource controller.
>>>
>>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>>> ---
>>> Thanks for the feedback on the initial driver, I'm quite happy
>>> with the outcome using the hierarchic irqdomain support.
>>
>> Great stuff, pleased to see the stacked domain proving to be useful.
>>
>>> The driver is tested on Vybrid running on the Cortex-A5 CPU.
>>> However, to properly support Cortex-M4, some more work will be
>>> needed. Beside the hierarchic irqdomain support for NVIC, the
>>> different IRQ cell layout need to be solved: NVIC uses only
>>> one cell, whereas GIC uses three. I see two possible solutions:
>>> - Support two layouts in this driver. Maybe by using IS_ENABLED,
>>>   since it is not possible to compile a kernel for the A5 and
>>>   M4.
>>> - Define a 3 cell layout as GIC uses it for the MSCM, and pass
>>>   a syntetic one cell layout to the parent when calling
>>>   irq_domain_alloc_irqs_parent. This driver would then still
>>>   need to know what type of interrupt controller the parent is...
>>>
>>> Ideas/advice welcome...
>>
>> You shouldn't use the GIC format for the MSCM, as it doesn't mean
>> anything for it. Yes, I know that everybody did that, but that's just
>> wrong (MSCM itself shouldn't care about SPIs, except when it is actually
>> talking to a GIC). The only reason I didn't clean that up in my ongoing
>> series is to avoid having to rewrite all the DTs entirely.
>>
>> My hunch is that you should have a MSCM-specific interrupt description
>> (I guess two cells should be enough, one for the interrupt number and
>> one for the trigger if necessary), and translate this to the format that
>> the backing interrupt controller is using (only the map function should
>> be affected).
> 
> Ok, so foremost you suggest to use always the same interrupt
> specification, no matter if I use the dt for the A5 or the M4. Hm, just
> some weeks ago I extracted the interrupt properties of all peripherals
> and made a base device tree without interrupt properties, just so that I
> could create a device tree with the interrupt properties for NVIC and
> one for GIC (see vf500.dtsi vs the preliminary vf610m4.dtsi from the
> Cortex-M4 support patchset). Back then, I did not put much thought into
> MSCM etc., and just adjusted the interrupt properties to the needs of
> those two interrupt controllers. When having a common definition, I can
> merge those interrupt nodes back into the common device tree, which is
> much nicer anyway!

Indeed. The thing to realize is that from the point of view of the
device, the interrupt controller *is* MSCM. That is what the wire is
connected to. What the MSCM is connected to is its responsibility.

> Regarding format, since I have to touch all the interrupt properties
> anyway, it's not much hassle to use a new format in that process. So my
> MSCM format would be, as you suggested, two cells with interrupt number
> and the trigger specification (IRQ_TYPE... from
> ./include/dt-bindings/interrupt-controller/irq.h).
> 
> One open thing: How should I determine the backing interrupt controller?
> Maybe by just reading the interrupt-cells property of the parent
> interrupt controller, and depending on the cell count create that
> format?

The way to handle this would be to look at the interrupt-parent (you get
a pointer to it anyway), and match the compatible string. You still need
to hardcode the knowledge of the format for GIC and NVIC though.

[...]

>> Otherwise, looks pretty good to me.
>>
> 
> The same line adjustment will break the 80 character border... But I
> agree, it's ugly the way it is now. Will put them in the same line.

Never mind what checkpatch says. Readability trumps it anytime.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
