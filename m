Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636Ab3IXWad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 18:30:33 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:55364 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754071Ab3IXWab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 18:30:31 -0400
Date: Tue, 24 Sep 2013 15:30:18 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Anshuman Khandual <khandual@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 8/8][v4] powerpc/perf: Export Power7 memory hierarchy
 info to user space.
Message-ID: <20130924223018.GA21644@us.ibm.com>
References: <1379119755-21025-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1379119755-21025-9-git-send-email-sukadev@linux.vnet.ibm.com>
 <523AB8B2.1060202@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523AB8B2.1060202@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092422-7182-0000-0000-000008834B84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anshuman Khandual [khandual@linux.vnet.ibm.com] wrote:
| On 09/14/2013 06:19 AM, Sukadev Bhattiprolu wrote:
| > +static void power7_get_mem_data_src(union perf_mem_data_src *dsrc,
| > +			struct pt_regs *regs)
| > +{
| > +	u64 idx;
| > +	u64 mmcra = regs->dsisr;
| > +	u64 addr;
| > +	int ret;
| > +	unsigned int instr;
| > +
| > +	if (mmcra & POWER7_MMCRA_DCACHE_MISS) {
| > +		idx = mmcra & POWER7_MMCRA_DCACHE_SRC_MASK;
| > +		idx >>= POWER7_MMCRA_DCACHE_SRC_SHIFT;
| > +
| > +		dsrc->val |= dcache_src_map[idx];
| > +		return;
| > +	}
| > +
| > +	instr = 0;
| > +	addr = perf_instruction_pointer(regs);
| > +
| > +	if (is_kernel_addr(addr))
| > +		instr = *(unsigned int *)addr;
| > +	else {
| > +		pagefault_disable();
| > +		ret = __get_user_inatomic(instr, (unsigned int __user *)addr);
| > +		pagefault_enable();
| > +		if (ret)
| > +			instr = 0;
| > +	}
| > +	if (instr && instr_is_load_store(&instr))
| 
| 
| Wondering if there is any possibility of getting positive values for
| "(mmcra & POWER7_MMCRA_DCACHE_SRC_MASK) >> POWER7_MMCRA_DCACHE_SRC_SHIFT"
| when the marked instruction did not have MMCRA[POWER7_MMCRA_DCACHE_MISS]
| bit set. In that case we should actually compute dsrc->val as in the previous
| case. I did couple of experiments on a P7 box, but was not able to find a
| instance for a marked instruction whose MMCRA[POWER7_MMCRA_DCACHE_MISS] bit
| not set and have a positive value POWER7_MMCRA_DCACHE_SRC field.

Confirmed again with the hardware team that if there was no DCACHE_MISS,
the DCACHE_SRC field will be clear.

Thanks,

Sukadev

