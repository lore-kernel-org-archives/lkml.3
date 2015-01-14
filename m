Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbbANOnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 09:43:33 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:48659 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbbANOnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 09:43:31 -0500
Message-ID: <54B68091.7080109@atmel.com>
Date: Wed, 14 Jan 2015 15:43:29 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 1/5] irqchip: add dumb demultiplexer implementation
References: <1421174781-4340-1-git-send-email-boris.brezillon@free-electrons.com>	<1421174781-4340-2-git-send-email-boris.brezillon@free-electrons.com>	<54B670EA.1010800@atmel.com> <20150114150332.09fecbea@bbrezillon>
In-Reply-To: <20150114150332.09fecbea@bbrezillon>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/01/2015 15:03, Boris Brezillon a écrit :
> On Wed, 14 Jan 2015 14:36:42 +0100
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
>> Le 13/01/2015 19:46, Boris Brezillon a écrit :
>>> Some interrupt controllers are multiplexing several peripheral IRQs on
>>> a single interrupt line.
>>> While this is not a problem for most IRQs (as long as all peripherals
>>> request the interrupt with IRQF_SHARED flag set), multiplexing timers and
>>> other type of peripherals will generate a WARNING (mixing IRQF_NO_SUSPEND
>>> and !IRQF_NO_SUSPEND is prohibited).
>>>
>>> Create a dumb irq demultiplexer which simply forwards interrupts to all
>>> peripherals (exactly what's happening with IRQ_SHARED) but keep a unique
>>> irq number for each peripheral, thus preventing the IRQF_NO_SUSPEND
>>> and !IRQF_NO_SUSPEND mix on a given interrupt.
>>>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>> ---
>>>  drivers/irqchip/Kconfig          |   4 ++
>>>  drivers/irqchip/Makefile         |   1 +
>>>  drivers/irqchip/irq-dumb-demux.c |  70 ++++++++++++++++++++
>>>  include/linux/irq.h              |  49 ++++++++++++++
>>>  include/linux/irqdomain.h        |   1 +
>>>  kernel/irq/Kconfig               |   5 ++
>>>  kernel/irq/Makefile              |   1 +
>>>  kernel/irq/chip.c                |  41 ++++++++++++
>>>  kernel/irq/dumb-demux-chip.c     | 140 +++++++++++++++++++++++++++++++++++++++
>>>  kernel/irq/handle.c              |  31 ++++++++-
>>>  kernel/irq/internals.h           |   3 +
>>>  11 files changed, 344 insertions(+), 2 deletions(-)
>>>  create mode 100644 drivers/irqchip/irq-dumb-demux.c
>>>  create mode 100644 kernel/irq/dumb-demux-chip.c

[..]

>>> +static void irq_dumb_demux_mask(struct irq_data *d)
>>> +{
>>> +	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
>>> +
>>> +	clear_bit(d->hwirq, &demux->unmasked);
>>> +
>>> +	if (!demux->unmasked)
>>> +		disable_irq_nosync(demux->src_irq);
>>> +}
>>> +
>>> +static void irq_dumb_demux_unmask(struct irq_data *d)
>>> +{
>>> +	struct irq_chip_dumb_demux *demux = irq_data_get_irq_chip_data(d);
>>> +	bool enable_src_irq = !demux->unmasked;
>>
>> Why this additional "bool" unlike the other function above?
> 
> Because set_bit will modify the unmasked status and we must check if it
> is equal to 0 (in other terms, all irqs are masked) before modifying it
> in order to know whether we should enable the src irq or not.

pfffff! ok, sorry for the noise then ;-)


>>> +
>>> +	set_bit(d->hwirq, &demux->unmasked);
>>> +
>>> +	if (enable_src_irq)
>>> +		enable_irq(demux->src_irq);
>>> +}
>>> +

[...]

Bye,
-- 
Nicolas Ferre
