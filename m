Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbbAHRCG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:02:06 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:58052 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbbAHRCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:02:01 -0500
Date: Thu, 8 Jan 2015 17:01:52 +0000
From: Will Deacon <will.deacon@arm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pratyush Anand <panand@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "tixy@linaro.org" <tixy@linaro.org>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "sandeepa.prabhu@linaro.org" <sandeepa.prabhu@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "anil.s.keshavamurthy@intel.com" <anil.s.keshavamurthy@intel.com>,
        "masami.hiramatsu.pt@hitachi.com" <masami.hiramatsu.pt@hitachi.com>,
        "wcohen@redhat.com" <wcohen@redhat.com>
Subject: Re: [RFC 6/8] ARM64: Handle TRAP_HWBRKPT for user mode as well
Message-ID: <20150108170152.GS11583@arm.com>
References: <cover.1420038188.git.panand@redhat.com>
 <1e0a9e778669bb2a2e40bf101eff8ae85110ce54.1420038188.git.panand@redhat.com>
 <20150102180523.GC6761@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150102180523.GC6761@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 06:05:23PM +0000, Oleg Nesterov wrote:
> Let me repeat once again that I know absolutely nothing about arm* ;)
> 
> On 12/31, Pratyush Anand wrote:
> >
> > uprobe registers a handler at step_hook. So, single_step_handler now
> > checks for user mode as well if there is a valid hook.
> >
> > Signed-off-by: Pratyush Anand <panand@redhat.com>
> > ---
> >  arch/arm64/kernel/debug-monitors.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
> > index b056369fd47d..2676b8655241 100644
> > --- a/arch/arm64/kernel/debug-monitors.c
> > +++ b/arch/arm64/kernel/debug-monitors.c
> > @@ -236,6 +236,9 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
> >  	if (!reinstall_suspended_bps(regs))
> >  		return 0;
> >
> > +	if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
> > +		return 0;
> > +
> >  	if (user_mode(regs)) {
> >  		info.si_signo = SIGTRAP;
> >  		info.si_errno = 0;
> > @@ -251,9 +254,6 @@ static int single_step_handler(unsigned long addr, unsigned int esr,
> >  		 */
> >  		user_rewind_single_step(current);
> >  	} else {
> > -		if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
> > -			return 0;
> > -
> 
> Agreed, we need something like this change...
> 
> But did you verify that it can't break other users of register_step_hook() ?
> The current handlers do not check user_mode() == F, they assume that they
> can't be called otherwise.
> 
> If this all is correct, please explain why in the changelog.

I think you're right, and kgdb will need fixing with this change.

Will
