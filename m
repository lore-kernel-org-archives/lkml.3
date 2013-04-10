Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937207Ab3DJKfR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 06:35:17 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:50364 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936214Ab3DJKfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 06:35:13 -0400
Date: Wed, 10 Apr 2013 12:35:08 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: Re: [PATCH 1/7] x86: don't show trace beyond show_stack(NULL, NULL)
Message-ID: <20130410103508.GD28505@gmail.com>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <1365016497-32033-2-git-send-email-tj@kernel.org>
 <20130408160811.GA20612@gmail.com>
 <20130408175734.GH3021@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408175734.GH3021@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> Hello, Ingo.
> 
> On Mon, Apr 08, 2013 at 06:08:11PM +0200, Ingo Molnar wrote:
> > >  void show_stack(struct task_struct *task, unsigned long *sp)
> > >  {
> > > -	show_stack_log_lvl(task, NULL, sp, 0, "");
> > > +	unsigned long bp = 0;
> > > +	unsigned long stack;
> > > +
> > > +	/*
> > > +	 * Stack frames below this one aren't interesting.  Don't show them
> > > +	 * if we're printing for %current.
> > > +	 */
> > > +	if (!sp && (!task || task == current)) {
> > > +		sp = &stack;
> > > +		bp = stack_frame(current, NULL);
> > > +	}
> > > +
> > > +	show_stack_log_lvl(task, NULL, sp, bp, "");
> > 
> > Hm, show_regs() has a similar problem AFAICS.
> 
> Doesn't seem so.  show_regs() have pt_regs which gets passed to
> dump_trace() and then used to determine the frame being dumped.
> e.g. BUG() takes pt_regs from the faulting frame and thus doesn't show
> anything beyond it.

Ok - but my other observation probably holds, that the bp == 0 special case in 
dump_trace() should be changed to a [printk()-ed] warning or so? No user will pass 
in bp == 0 legitimately, AFAICS.

Thanks,

	Ingo
