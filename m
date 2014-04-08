Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbaDHTyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:54:51 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:37680 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbaDHTys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:54:48 -0400
Message-ID: <53445407.1010108@codeaurora.org>
Date: Tue, 08 Apr 2014 12:54:47 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        Stepan Moskovchenko <stepanm@codeaurora.org>
Subject: Re: [PATCH v6 4/5] edac: Add support for Krait CPU cache error detection
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org> <1396641450-12854-5-git-send-email-sboyd@codeaurora.org> <20140408173541.GO30077@pd.tnic>
In-Reply-To: <20140408173541.GO30077@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/14 10:35, Borislav Petkov wrote:
> On Fri, Apr 04, 2014 at 12:57:29PM -0700, Stephen Boyd wrote:
>> +
>> +struct krait_edac_error {
>> +	const char * const msg;
>> +	void (*func)(struct edac_device_ctl_info *edac_dev,
>> +			int inst_nr, int block_nr, const char *msg);
> arg alignment (please start new line at the opening brace).

Done.


>> +	int print_regs = cesr & CESR_PRINT_MASK;
>> +	int i;
>> +	static const struct krait_edac_error errors[] = {
>> +		{ "D-cache tag parity error", edac_device_handle_ue },
>> +		{ "D-cache data parity error", edac_device_handle_ue },
>> +		{ "I-cache tag parity error", edac_device_handle_ce },
>> +		{ "I-cache data parity error", edac_device_handle_ce },
>> +		{ "D-cache tag timing error", edac_device_handle_ue },
>> +		{ "D-cache data timing error", edac_device_handle_ue },
>> +		{ "I-cache tag timing error", edac_device_handle_ce },
>> +		{ "I-cache data timing error", edac_device_handle_ce }
>> +	};
>> +
>> +	if (print_regs) {
> This variable is used only once here, you can simply do the binary and
> test then and drop it:
>
> 	if (cesr & CESR_PRINT_MASK)

Done.

>
>> +		pr_alert("L1 / TLB Error detected on CPU %d!\n", cpu);
>> +		pr_alert("CESR      = 0x%08x\n", cesr);
> You can use the edac_*_printk with KERN_ALERT as level which adds proper
> prefixes.

Done.

>
>
>> +
>> +	if (cesr & CESR_TLBMH) {
>> +		asm ("mcr p15, 0, r0, c8, c7, 0");
>> +		edac_device_handle_ce(edac, cpu, 0, "TLB Multi-Hit error");
>> +	}
>> +
>> +	if (cesr & (CESR_ICTPE | CESR_ICDPE | CESR_ICTE)) {
>> +		i_cesynr = read_cesynr();
>> +		pr_alert("I-side CESYNR = 0x%08x\n", i_cesynr);
> edac_printk
>
> and also, this message looks a bit cryptic for issuing it at ALERT
> level. I'm ssuming people won't come to you and ask you what it
> means...? :)

Ok. I can lower it to error level?

>
>> +		write_cesr(CESR_I_MASK);
>> +
>> +		/*
>> +		 * Clear the I-side bits from the captured CESR value so that we
>> +		 * don't accidentally clear any new I-side errors when we do
>> +		 * the CESR write-clear operation.
>> +		 */
>> +		cesr &= ~CESR_I_MASK;
>> +	}
>> +
>> +	if (cesr & (CESR_DCTPE | CESR_DCDPE | CESR_DCTE)) {
>> +		d_cesynr = read_cesynr();
>> +		pr_alert("D-side CESYNR = 0x%08x\n", d_cesynr);
> Ditto.
>
>> +	}
>> +
>> +	/* Clear the interrupt bits we processed */
>> +	write_cesr(cesr);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static irqreturn_t krait_l2_irq(int irq, void *dev_id)
>> +{
>> +	struct edac_device_ctl_info *edac = dev_id;
>> +	unsigned int l2esr;
>> +	unsigned int l2esynr0;
>> +	unsigned int l2esynr1;
>> +	unsigned int l2ear0;
>> +	unsigned int l2ear1;
>> +	unsigned long cpu;
>> +	int i;
>> +	static const struct krait_edac_error errors[] = {
>> +		{ "master port decode error", edac_device_handle_ce },
>> +		{ "master port slave error", edac_device_handle_ce },
>> +		{ "tag soft error, single-bit", edac_device_handle_ce },
>> +		{ "tag soft error, double-bit", edac_device_handle_ue },
>> +		{ "data soft error, single-bit", edac_device_handle_ce },
>> +		{ "data soft error, double-bit", edac_device_handle_ue },
>> +		{ "modified soft error", edac_device_handle_ce },
>> +		{ "slave port exclusive monitor not available",
>> +			edac_device_handle_ue},
>> +		{ "master port LDREX received Normal OK response",
>> +			edac_device_handle_ce },
>> +	};
>> +
>> +	l2esr = krait_get_l2_indirect_reg(L2ESR);
>> +	pr_alert("Error detected!\n");
> Why print this not very telling message here if errors[i].func() will
> get the proper .msg later?

Sure I can drop it.

>
>> +	pr_alert("L2ESR    = 0x%08x\n", l2esr);
>> +
>> +	if (l2esr & (L2ESR_TSESB | L2ESR_TSEDB | L2ESR_MSE | L2ESR_SP)) {
>> +		l2esynr0 = krait_get_l2_indirect_reg(L2ESYNR0);
>> +		l2esynr1 = krait_get_l2_indirect_reg(L2ESYNR1);
>> +		l2ear0 = krait_get_l2_indirect_reg(L2EAR0);
>> +		l2ear1 = krait_get_l2_indirect_reg(L2EAR1);
>> +
>> +		pr_alert("L2ESYNR0 = 0x%08x\n", l2esynr0);
>> +		pr_alert("L2ESYNR1 = 0x%08x\n", l2esynr1);
>> +		pr_alert("L2EAR0   = 0x%08x\n", l2ear0);
>> +		pr_alert("L2EAR1   = 0x%08x\n", l2ear1);
> Also, please use edac_printk and consider making those messages
> human-readable, otherwise it only confuses users.

Ok.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

