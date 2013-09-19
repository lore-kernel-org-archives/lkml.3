Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822Ab3ISIm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:42:26 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:44412 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903Ab3ISImZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:42:25 -0400
Message-ID: <523AB8B2.1060202@linux.vnet.ibm.com>
Date: Thu, 19 Sep 2013 14:11:22 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 8/8][v4] powerpc/perf: Export Power7 memory hierarchy
 info to user space.
References: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com> <1379119755-21025-9-git-send-email-sukadev@linux.vnet.ibm.com>
In-Reply-To: <1379119755-21025-9-git-send-email-sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091908-3568-0000-0000-000004448691
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2013 06:19 AM, Sukadev Bhattiprolu wrote:
> +static void power7_get_mem_data_src(union perf_mem_data_src *dsrc,
> +			struct pt_regs *regs)
> +{
> +	u64 idx;
> +	u64 mmcra = regs->dsisr;
> +	u64 addr;
> +	int ret;
> +	unsigned int instr;
> +
> +	if (mmcra & POWER7_MMCRA_DCACHE_MISS) {
> +		idx = mmcra & POWER7_MMCRA_DCACHE_SRC_MASK;
> +		idx >>= POWER7_MMCRA_DCACHE_SRC_SHIFT;
> +
> +		dsrc->val |= dcache_src_map[idx];
> +		return;
> +	}
> +
> +	instr = 0;
> +	addr = perf_instruction_pointer(regs);
> +
> +	if (is_kernel_addr(addr))
> +		instr = *(unsigned int *)addr;
> +	else {
> +		pagefault_disable();
> +		ret = __get_user_inatomic(instr, (unsigned int __user *)addr);
> +		pagefault_enable();
> +		if (ret)
> +			instr = 0;
> +	}
> +	if (instr && instr_is_load_store(&instr))


Wondering if there is any possibility of getting positive values for
"(mmcra & POWER7_MMCRA_DCACHE_SRC_MASK) >> POWER7_MMCRA_DCACHE_SRC_SHIFT"
when the marked instruction did not have MMCRA[POWER7_MMCRA_DCACHE_MISS]
bit set. In that case we should actually compute dsrc->val as in the previous
case. I did couple of experiments on a P7 box, but was not able to find a
instance for a marked instruction whose MMCRA[POWER7_MMCRA_DCACHE_MISS] bit
not set and have a positive value POWER7_MMCRA_DCACHE_SRC field.

