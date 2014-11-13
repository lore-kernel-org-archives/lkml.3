Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbaKMBnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:43:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:47797 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753395AbaKMBnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:43:40 -0500
Date: Thu, 13 Nov 2014 02:43:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, dave.hansen@linux.intel.com, x86@kernel.org,
        paulus@samba.org, acme@kernel.org, jkenisto@us.ibm.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, ananth@in.ibm.com,
        anil.s.keshavamurthy@intel.com, davem@davemloft.net,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH] x86: remove arbitrary instruction size limit in
 instruction decoder
Message-ID: <20141113014320.GR29390@twins.programming.kicks-ass.net>
References: <20141112225352.D49917A8@viggo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112225352.D49917A8@viggo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 02:53:52PM -0800, Dave Hansen wrote:
> We shouldn't simply error out when we get short copy_from_user*()
> results from userspace (like intel_pmu_pebs_fixup_ip() does
> currently).  It is perfectly valid to be executing an instruction
> within MAX_INSN_SIZE bytes of an unreadable page. We should be
> able to gracefully handle short reads in those cases.

> diff -puN arch/x86/kernel/cpu/perf_event_intel_ds.c~x86-insn-decoder-remove-arbitrary-limit arch/x86/kernel/cpu/perf_event_intel_ds.c
> --- a/arch/x86/kernel/cpu/perf_event_intel_ds.c~x86-insn-decoder-remove-arbitrary-limit	2014-11-12 12:45:52.954753152 -0800
> +++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c	2014-11-12 12:45:52.970753874 -0800

> @@ -758,11 +759,12 @@ static int intel_pmu_pebs_fixup_ip(struc
>  		return 1;
>  	}
>  
> +	size = ip - to;
>  	if (!kernel_ip(ip)) {
> -		int size, bytes;
> +		int bytes;
>  		u8 *buf = this_cpu_read(insn_buffer);
>  
> -		size = ip - to; /* Must fit our buffer, see above */
> +		/* 'size' must fit our buffer, see above */
>  		bytes = copy_from_user_nmi(buf, (void __user *)to, size);
>  		if (bytes != 0)
>  			return 0;

Right, so we should better deal with short copies there. Should be
doable.
