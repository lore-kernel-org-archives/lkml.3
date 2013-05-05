Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3EEJFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 05:05:10 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:49453 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab3EEJFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 05:05:08 -0400
Date: Sun, 5 May 2013 11:05:04 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: a.p.zijlstra@chello.nl, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, ak@linux.intel.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/urgent] perf/x86/intel/lbr: Demand proper privileges
 for PERF_SAMPLE_BRANCH_KERNEL
Message-ID: <20130505090504.GB22239@gmail.com>
References: <20130503121256.230745028@chello.nl>
 <tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org>
 <20130504111907.GA3411@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504111907.GA3411@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Sat, May 04, 2013 at 01:22:57AM -0700, tip-bot for Peter Zijlstra wrote:
> > Commit-ID:  0f5c78b5f33ce940034743e5f9485fc81ad75b0f
> > Gitweb:     http://git.kernel.org/tip/0f5c78b5f33ce940034743e5f9485fc81ad75b0f
> > Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
> > AuthorDate: Fri, 3 May 2013 14:11:25 +0200
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Sat, 4 May 2013 08:37:48 +0200
> > 
> > perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
> > 
> > We should always have proper privileges when requesting kernel
> > data.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Cc: <stable@kernel.org>
> > Cc: Andi Kleen <ak@linux.intel.com>
> > Cc: eranian@google.com
> > Link: http://lkml.kernel.org/r/20130503121256.230745028@chello.nl
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
> > ---
> >  arch/x86/kernel/cpu/perf_event_intel_lbr.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > index de341d4..0e92871 100644
> > --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> > @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filter(struct perf_event *event)
> >  	if (br_type & PERF_SAMPLE_BRANCH_USER)
> >  		mask |= X86_BR_USER;
> >  
> > -	if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> > +	if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> > +		if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> > +			return -EACCES;
> 
> It is probably not too late to amend this patch and remove the "-EACCES":
> 
> arch/x86/kernel/cpu/perf_event_intel_lbr.c: In function ???intel_pmu_setup_sw_lbr_filter???:
> arch/x86/kernel/cpu/perf_event_intel_lbr.c:323:4: warning: ???return??? with a value, in function returning void [enabled by default]

Well, the better fix is to propagate that error condition down instead of 
ignoring it.

Since it was the head commit for a tree others don't typically pull and 
base development work off I amended it.

Thanks,

	Ingo
