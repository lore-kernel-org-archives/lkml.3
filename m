Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298AbaAOG2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 01:28:23 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:53281 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaAOG2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 01:28:21 -0500
Date: Wed, 15 Jan 2014 07:28:17 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, aravind.gopalakrishnan@amd.com,
        tglx@linutronix.de, bp@suse.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, cpu, amd: Add workaround for family 16h,
 erratum 793
Message-ID: <20140115062817.GA11869@gmail.com>
References: <20140114230711.GS29865@pd.tnic>
 <tip-3b56496865f9f7d9bcb2f93b44c63f274f08e3b6@git.kernel.org>
 <52D5DC51.9010606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52D5DC51.9010606@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 01/14/2014 04:45 PM, tip-bot for Borislav Petkov wrote:
> > +		rdmsrl(MSR_AMD64_LS_CFG, val);
> > +		if (!(val & BIT(15)))
> > +			wrmsrl(MSR_AMD64_LS_CFG, val | BIT(15));
> 
> Incidentally, I'm wondering if we shouldn't have a
> set_in_msr()/clear_in_msr() set of functions which would incorporate the
> above construct:
> 
> void set_in_msr(u32 msr, u64 mask)
> {
> 	u64 old, new;
> 
> 	old = rdmsrl(msr);
> 	new = old | mask;
> 	if (old != new)
> 		wrmsrl(msr, new);
> }
> 
> ... and the obvious equivalent for clear_in_msr().
> 
> The perhaps only question is if it should be "set/clear_bit_in_msr()"
> rather than having to haul a full 64-bit mask in the common case.

I'd suggest the introduction of a standard set of methods operating on 
MSRs:

	msr_read()
	msr_write()
	msr_set_bit()
	msr_clear_bit()
	msr_set_mask()
	msr_clear_mask()

etc.

msr_read() would essentially map to rdmsr_safe(). Each method has a 
return value that can be checked for failure.

Note that the naming of 'msr_set_bit()' and 'msr_clear_bit()' mirrors 
that of bitops, and set_mask/clear_mask is named along a similar 
pattern, so that it's more immediately obvious what's going on.

With such methods in place we could use them in most new code, and 
would use 'raw, unsafe' rdmsr()/wrmsr() only in very specific, 
justified cases.

Thanks,

	Ingo
