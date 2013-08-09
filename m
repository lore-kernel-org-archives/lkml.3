Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3HIRRj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 13:17:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab3HIRRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 13:17:38 -0400
Date: Fri, 9 Aug 2013 19:12:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
Message-ID: <20130809171200.GA8901@redhat.com>
References: <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130806154314.GA398@redhat.com> <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com> <CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com> <20130807192734.GA8395@redhat.com> <CA+55aFw7P7LYNFQzy6nrn9DDn5a0UdYYQNx_7sibShvZPLEcmg@mail.gmail.com> <20130808154107.GA28971@redhat.com> <20130808165427.GC32049@somewhere> <20130808181521.GA11138@redhat.com> <20130809164548.GD13339@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130809164548.GD13339@somewhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Frederic Weisbecker wrote:
>
> On Thu, Aug 08, 2013 at 08:15:21PM +0200, Oleg Nesterov wrote:
> > But probably we should move "attr.bp_len == HW_BREAKPOINT_LEN_1" check
> > from arch_build_bp_info() to its caller, arch_validate_hwbkpt_settings().
> >
> > Because:
> >
> > > But this bp_len
> > > should rather be used for range breakpoints on archs that support it.
> >
> > Yes, exactly, and we already have the patches for amd, so bp->len can
> > be actually != 1 but currently we can't support because it is checked
> > in arch_build_bp_info().
>
> Hmm, but how moving that to arch_validate_hwbkpt_seetings() would solve
> the issue?

Of course, this itself won't solve the issue, sorry for confusion.

I meant that arch_build_bp_info(X86_BREAKPOINT_EXECUTE) should not fail
if ->bp_len is wrong, just because (unless we add more complications) it
can't know if it is correct or not (if the hardware supports the range
EXECUTE bps).

arch_validate_hwbkpt_settings() does the additional checks anyway, and
more importantly it checks cpu_has_bpext/mask. So I think it should also
have the additional check for X86_BREAKPOINT_EXECUTE case.

> > @@ -265,15 +262,11 @@ static int arch_build_bp_info(struct per
> >  		break;
> >  	case HW_BREAKPOINT_X:
> >  		info->type = X86_BREAKPOINT_EXECUTE;
> > -		/*
> > -		 * x86 inst breakpoints need to have a specific undefined len.
> > -		 * But we still need to check userspace is not trying to setup
> > -		 * an unsupported length, to get a range breakpoint for example.
> > -		 */
> > -		if (bp->attr.bp_len == sizeof(long)) {
> > -			info->len = X86_BREAKPOINT_LEN_X;
> > -			return 0;
> > -		}
> > +		/* until we change tools/perf */
> > +		if (bp->attr.bp_len == sizeof(long))
> > +			bp->attr.bp_len = HW_BREAKPOINT_LEN_1;
>
> Too bad we need to keep that compatibility around.

Yes, agreed... Do you see a better approach?

And just in case, it is not that I think that this hack is much better
than "ignore bp_len" as you suggested before. It's up to you.

> Do you think this could be
> a problem for AMD range breakpoints?

Yes, this doesn't look exactly right if ->bp_len == 8 actually tries to
denote a range. But this is the temporary hack, and at least currently
info->mask is only used if len > LEN_8, so I hope this should be fine.

> We can also fix the tools, then may be we'll be able to remove the kernel hack
> compatibility in a few years.

Or perhaps even earlier ;) And, perhaps after we change the tools we
can add pr_warn() for this case.

> Oh I need to check other archs as well.

Yes, and I'm afraid that tools/perf needs some arch-dependant define for
HW_BREAKPOINT_X's attr.bp_len. Or perhaps attr.bp_len == 0 could mean
"choose the right length" ?

Oleg.

