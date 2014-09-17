Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaIQI4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 04:56:32 -0400
Received: from mailapp01.imgtec.com ([195.59.15.196]:62353 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753910AbaIQI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 04:56:29 -0400
Message-ID: <54194CB9.4010200@imgtec.com>
Date: Wed, 17 Sep 2014 09:56:25 +0100
From: Qais Yousef <qais.yousef@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andrew Bresticker <abrestic@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>
CC: Jeffrey Deans <jeffrey.deans@imgtec.com>,
        Markos Chandras <markos.chandras@imgtec.com>,
        Paul Burton <paul.burton@imgtec.com>,
        "Jonas Gorski" <jogo@openwrt.org>, John Crispin <blogic@openwrt.org>,
        David Daney <ddaney.cavm@gmail.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/24] MIPS: Provide a generic plat_irq_dispatch
References: <1410825087-5497-1-git-send-email-abrestic@chromium.org> <1410825087-5497-4-git-send-email-abrestic@chromium.org>
In-Reply-To: <1410825087-5497-4-git-send-email-abrestic@chromium.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 09/16/2014 12:51 AM, Andrew Bresticker wrote:
> For platforms which boot with device-tree or have correctly chained
> all external interrupt controllers, a generic plat_irq_dispatch() can
> be used.  Implement a plat_irq_dispatch() which simply handles all the
> pending interrupts as reported by C0_Cause.
>
> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
> ---
>   arch/mips/kernel/irq_cpu.c | 15 +++++++++++++++
>   1 file changed, 15 insertions(+)
>
> diff --git a/arch/mips/kernel/irq_cpu.c b/arch/mips/kernel/irq_cpu.c
> index ca98a9f..f17bd08 100644
> --- a/arch/mips/kernel/irq_cpu.c
> +++ b/arch/mips/kernel/irq_cpu.c
> @@ -94,6 +94,21 @@ static struct irq_chip mips_mt_cpu_irq_controller = {
>   	.irq_eoi	= unmask_mips_irq,
>   };
>   
> +asmlinkage void __weak plat_irq_dispatch(void)
> +{
> +	unsigned long pending = read_c0_cause() & read_c0_status() & ST0_IM;
> +	int irq;
> +
> +	if (!pending) {
> +		spurious_interrupt();
> +		return;
> +	}
> +
> +	pending >>= CAUSEB_IP;
> +	for_each_set_bit(irq, &pending, 8)
> +		do_IRQ(MIPS_CPU_IRQ_BASE + irq);
> +}
> +

If I read the for_each_set_bit() macro correctly it'll iterate through 
the bits from least to most significant ones which is the reversed 
priority expected. Some platforms set timer interrupt to bit 7 which is 
should be the highest priority interrupt. Also when cpu_has_vint is set 
the hardware prioritirise from most significant to least significant 
bits so if plat_irq_dispatch() is used with set_vi_handler() it'll cause 
interrupts to be serviced in the wrong order.

Qais

>   static int mips_cpu_intc_map(struct irq_domain *d, unsigned int irq,
>   			     irq_hw_number_t hw)
>   {

