Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428Ab3DPNdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 09:33:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063Ab3DPNdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 09:33:11 -0400
Date: Tue, 16 Apr 2013 15:30:17 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Maneesh Soni <maneesh@linux.vnet.ibm.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ptrace/x86: dont delay perf_event_disable() till
	second pass in ptrace_write_dr7()
Message-ID: <20130416133017.GB9189@redhat.com>
References: <20130414191205.GA28791@redhat.com> <20130414191232.GA28816@redhat.com> <20130416004452.GG17561@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416004452.GG17561@somewhere.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16, Frederic Weisbecker wrote:
>
> On Sun, Apr 14, 2013 at 09:12:32PM +0200, Oleg Nesterov wrote:
> > ptrace_write_dr7() skips ptrace_modify_breakpoint(disabled => true)
> > unless second_pass, this buys nothing but complicates the code and
> > means that we always do the main loop twice even if "disabled" was
> > never true.
> >
> > The comment says:
> >
> > 	Don't unregister the breakpoints right-away,
> > 	unless all register_user_hw_breakpoint()
> > 	requests have succeeded.
> >
> > I think this logic was always wrong, hw_breakpoint_del() does not
> > free the slot so perf_event_disable() can't hurt.
>
> For the record, I think it was necessary before
> 44234adcdce38f83c56e05f808ce656175b4beeb
> ("hw-breakpoints: Modify breakpoints without unregistering them") because
> modifying a breakpoint implied that the old bp was released and a new one
> was created, opening a little race window in between against concurrent
> breakpoint users.

Aah, thank, I'll update the changelog.

> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks!

> >  	old_dr7 = ptrace_get_dr7(thread->ptrace_bps);
> > @@ -651,35 +643,31 @@ restore:
> >  		bool disabled = !decode_dr7(data, i, &len, &type);
> >  		struct perf_event *bp = thread->ptrace_bps[i];
> >
> > -		if (disabled) {
> > +		if (!bp) {
> > +			if (disabled)
> > +				continue;
> >  			/*
> > -			 * Don't unregister the breakpoints right-away, unless
> > -			 * all register_user_hw_breakpoint() requests have
> > -			 * succeeded. This prevents any window of opportunity
> > -			 * for debug register grabbing by other users.
> > +			 * We should have at least an inactive breakpoint at
> > +			 * this slot. It means the user is writing dr7 without
> > +			 * having written the address register first.
> >  			 */
> > -			if (!bp || !second_pass)
> > -				continue;
> > +			rc = -EINVAL;
> > +			break;
> >  		}
> >
> >  		rc = ptrace_modify_breakpoint(bp, len, type, tsk, disabled);
> >  		if (rc)
> >  			break;
>
> It would be nice to warn here:
>
>    WARN_ON_ONCE(rc && second_pass);

Well, I disagree.

To clarify, I agree with WARN_ON_ONCE(), but afaics it has nothing to
do with "second_pass",

> And these are indeed supposed
> to.

Indeed, but this is because ptrace_modify_breakpoint() should not fail.

So, what do you think if I change the main loop above

		rc = ptrace_modify_breakpoint(...)
	-	if (rc)
	+	if (WARN_ON_ONCE(rc))
			break;

instead?

Oleg.

