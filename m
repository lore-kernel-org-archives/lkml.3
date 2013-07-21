Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3GUVjB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jul 2013 17:39:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36115 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751413Ab3GUVi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jul 2013 17:38:59 -0400
Date: Sun, 21 Jul 2013 22:37:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jed Davis <jld@mozilla.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Robert Richter <rric@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>
Subject: Re: [PATCH] ARM: Fix r7/r11 confusion when CONFIG_THUMB2_KERNEL=y
Message-ID: <20130721213753.GA29879@mudshark.cambridge.arm.com>
References: <1373685501-1620-1-git-send-email-jld@mozilla.com>
 <20130715135420.GG10000@mudshark.cambridge.arm.com>
 <20130720044655.GC9433@mozilla.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130720044655.GC9433@mozilla.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jed,

Thanks for the reply.

On Sat, Jul 20, 2013 at 05:46:55AM +0100, Jed Davis wrote:
> On Mon, Jul 15, 2013 at 02:54:20PM +0100, Will Deacon wrote:
> > On Sat, Jul 13, 2013 at 04:18:20AM +0100, Jed Davis wrote:
> [...]
> > > Effects of this are probably limited to failure of EHABI unwinding when
> > > starting from a function that uses r7 to restore its stack pointer, but
> > > the possibility for further breakage (which would be invisible on
> > > non-Thumb kernels) is worrying.
> [...]
> > I'm struggling to understand exactly the problem that this patch is trying
> > to address. If it's just a code consistency issue, I don't think it's worth
> > it (I actually find it less confusing the way we currently have things) but
> > if there is a real bug, perhaps you could provide a testcase?
> 
> There is a real bug here, but my commit message wasn't very clear.  This
> was breaking PERF_COUNT_SW_CONTEXT_SWITCHES with CONFIG_THUMB2_KERNEL=y
> (with my other recently posted patch applied), because kernel/sched.c is
> built with -fno-omit-frame-pointer (which is wrong, but that's a problem
> for another patch) and so __schedule's EHABI entry uses 0x97 (mov sp, r7),
> and somewhere along the line the unwinder gets the r11 value instead.
> This would also apply to any function with a variable-length array, but
> __schedule happens to have the perf hook I was trying to use.

Ok, I think I'm with you now. I also think that a better solution would be
to try and limit the r7/fp confusion to one place, perhaps behind something
like:

void arm_get_current_stackframe(struct pt_regs *regs, struct stackframe *frame);

then that function can act as the bridge between pt_regs (where we leave
everything as it is) and stackframe (where we assign either r7 or fp into
the fp member). Then we just fix up the call sites to pass the regs they're
interested in to our new function.

What do you think?

Will
