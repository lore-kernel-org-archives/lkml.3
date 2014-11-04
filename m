Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556AbaKDCLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 21:11:46 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:59143 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaKDCLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 21:11:43 -0500
Message-ID: <1415067074.24825.27.camel@debian>
Subject: Re: [PATCH 2/2] x86, mce: support memory error recovery for both
 UCNA and Deferred error in machine_check_poll
From: Chen Yucong <slaoub@gmail.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "bp@alien8.de" <bp@alien8.de>, "ak@linux.intel.com" <ak@linux.intel.com>,
        "aravind.gopalakrishnan@amd.com" <aravind.gopalakrishnan@amd.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 04 Nov 2014 10:11:14 +0800
In-Reply-To: <1414548964.20336.17.camel@debian>
References: <1414371382-15491-1-git-send-email-slaoub@gmail.com>
	 <1414371382-15491-3-git-send-email-slaoub@gmail.com>
	 <3908561D78D1C84285E8C5FCA982C28F32917841@ORSMSX114.amr.corp.intel.com>
	 <1414548964.20336.17.camel@debian>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 10:16 +0800, Chen Yucong wrote:
> On Mon, 2014-10-27 at 23:10 +0000, Luck, Tony wrote:
> > +	m->mcgstatus |= (MCG_STATUS_MCIP|MCG_STATUS_RIPV);
> > +	severity = mce_severity(m, mca_cfg.tolerant, NULL);
> > 
> > This seems a big hack to make mce_severity() work when called from
> > CMCI context (when MCG_STATUS register is not set).  It would also
> > be confusing as the subsequent logged entries would show MCIP and RIPV
> > bits set in the mcg_status.
> > 
> > If someone can think of a less hacky way to do this, that would be good. Otherwise
> > the code needs a comment, and should reset m->mcg_status to avoid making logs
> > that have incorrect data.
> > 
> Hi all,
> 
> At the suggestion of Tony, this patch add a comment, and restore m->mcgstatus to avoid
> making logs that have incorrect data.
> 

Hi Tony,

Do you have any more comments for the two patches?

thx!
cyc
> 
> From: Chen Yucong <slaoub@gmail.com>
> 
> Signed-off-by: Chen Yucong <slaoub@gmail.com>
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |   64 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 62 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> index fdc422e..d285d26 100644
> --- a/arch/x86/kernel/cpu/mcheck/mce.c
> +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -575,6 +575,56 @@ static void mce_read_aux(struct mce *m, int i)
>  	}
>  }
>  
> +static bool mem_deferred_error(struct mce *m)
> +{
> +	int severity;
> +	u8 mcgs = m->mcgstatus & 0xff;
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +
> +	/*
> +	 * mce_severity is specific to machine check exception, and it will
> +	 * check MCIP/EIPV/RIPV bits. In order to get pass the check, we need
> +	 * to set MCIP and RIPV.
> +	 */
> +	m->mcgstatus |= (MCG_STATUS_MCIP|MCG_STATUS_RIPV);
> +	severity = mce_severity(m, mca_cfg.tolerant, NULL);
> +
> +	/* restore the original value of m->mcgstatus */
> +	m->mcgstatus = (m->mcgstatus & ~0xff) | mcgs;
> +
> +	if (c->x86_vendor == X86_VENDOR_AMD) {
> +		/*
> +		 * AMD BKDGs - Machine Check Error Codes
> +		 *
> +		 * Bit 8 of ErrCode[15:0] of MCi_STATUS is used for indicating
> +		 * a memory-specific error. Note that this field encodes info-
> +		 * rmation about memory-hierarchy level involved in the error.
> +		 */
> +		if (severity == MCE_DEFERRED_SEVERITY)
> +			return  (m->status & 0xff00) == BIT(8);
> +	} else if (c->x86_vendor == X86_VENDOR_INTEL) {
> +		/*
> +		 * Intel SDM Volume 3B - 15.9.2 Compound Error Codes
> +		 *
> +		 * Bit 7 of the MCACOD field of IA32_MCi_STATUS is used for
> +		 * indicating a memory error. Bit 8 is used for indicating a
> +		 * cache hierarchy error. The combination of bit 2 and bit 3
> +		 * is used for indicating a `generic' cache hierarchy error
> +		 * But we can't just blindly check the above bits, because if
> +		 * bit 11 is set, then it is a bus/interconnect error - and
> +		 * either way the above bits just gives more detail on what
> +		 * bus/interconnect error happened. Note that bit 12 can be
> +		 * ignored, as it's the "filter" bit.
> +		 */
> +		if (severity == MCE_UCNA_SEVERITY)
> +			return (m->status & 0xef80) == BIT(7) ||
> +			       (m->status & 0xef00) == BIT(8) ||
> +			       (m->status & 0xeffc) == 0xc;
> +	}
> +
> +	return false;
> +}
> +
>  DEFINE_PER_CPU(unsigned, mce_poll_count);
>  
>  /*
> @@ -630,6 +680,16 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
>  
>  		if (!(flags & MCP_TIMESTAMP))
>  			m.tsc = 0;
> +
> +		/*
> +		 * In the cases where we don't have a valid address after all,
> +		 * do not add it into the ring buffer.
> +		 */
> +		if (mem_deferred_error(&m) && (m.status & MCI_STATUS_ADDRV)) {
> +			mce_ring_add(m.addr >> PAGE_SHIFT);
> +			mce_schedule_work();
> +		}
> +
>  		/*
>  		 * Don't get the IP here because it's unlikely to
>  		 * have anything to do with the actual error location.
> @@ -1098,8 +1158,8 @@ void do_machine_check(struct pt_regs *regs, long error_code)
>  		severity = mce_severity(&m, cfg->tolerant, NULL);
>  
>  		/*
> -		 * When machine check was for corrected handler don't touch,
> -		 * unless we're panicing.
> +		 * When machine check was for corrected/deferred handler don't
> +		 * touch, unless we're panicing.
>  		 */
>  		if ((severity == MCE_KEEP_SEVERITY ||
>  		     severity == MCE_UCNA_SEVERITY) && !no_way_out)


