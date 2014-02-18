Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbaBRRbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:31:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbaBRRbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:31:40 -0500
Message-ID: <1392744682.2165.27.camel@flatline.rdu.redhat.com>
Subject: Re: [PATCH v3] audit: Turn off TIF_SYSCALL_AUDIT when there are no
 rules
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>
Date: Tue, 18 Feb 2014 12:31:22 -0500
In-Reply-To: <CALCETrX0GtSaLUB9UBeKsxOoVhiVyMzWrZTYt3O5He1Wdvz+1Q@mail.gmail.com>
References: <ee359482b77f8f633014ec300bc5a4b93f8961e8.1391893528.git.luto@amacapital.net>
	 <20140210165723.GA10856@redhat.com>
	 <CALCETrX9gb_+zW4UZZv5icCQ-3HNG7BFZOaqMPYaQfzotsZpnA@mail.gmail.com>
	 <CALCETrX0GtSaLUB9UBeKsxOoVhiVyMzWrZTYt3O5He1Wdvz+1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-02-10 at 11:01 -0800, Andy Lutomirski wrote:
> On Mon, Feb 10, 2014 at 9:29 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> > On Mon, Feb 10, 2014 at 8:57 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> On 02/08, Andy Lutomirski wrote:
> >>>
> >>> +void audit_inc_n_rules()
> >>> +{
> >>> +     struct task_struct *p, *t;
> >>> +
> >>> +     read_lock(&tasklist_lock);
> >>> +     audit_n_rules++;
> >>> +     smp_wmb();
> >>> +     if (audit_n_rules == 1) {
> >>> +             /*
> >>> +              * We now have a rule; we need to hook syscall entry.
> >>> +              */
> >>> +             for_each_process_thread(p, t) {
> >>> +                     if (t->audit_context)
> >>> +                             set_tsk_thread_flag(t, TIF_SYSCALL_AUDIT);
> >>> +             }
> >>> +     }
> >>> +     read_unlock(&tasklist_lock);
> >>> +}
> >>> +
> >>> +void audit_dec_n_rules()
> >>> +{
> >>> +     read_lock(&tasklist_lock);
> >>> +     --audit_n_rules;
> >>> +     BUG_ON(audit_n_rules < 0);
> >>> +
> >>> +     /*
> >>> +      * If audit_n_rules == 0, then __audit_syscall_exit will clear
> >>> +      * TIF_SYSCALL_AUDIT.
> >>> +      */
> >>> +
> >>> +     read_unlock(&tasklist_lock);
> >>> +}
> >>
> >> To be honest, I do not understand why _dec_ takes tasklist_lock...
> >> And why _inc_ increments audit_n_rules under tasklist.
> >
> > Bah, incorrect leftover from last time.
> >
> >>
> >>> @@ -1528,6 +1562,25 @@ void __audit_syscall_exit(int success, long return_code)
> >>>               context->filterkey = NULL;
> >>>       }
> >>>       tsk->audit_context = context;
> >>> +
> >>> +     if (ACCESS_ONCE(audit_n_rules) == 0) {
> >>> +             /*
> >>> +              * Either this is the very first syscall by this process or
> >>> +              * audit_dec_n_rules recently set audit_n_rules to zero.
> >>> +              */
> >>> +             smp_rmb();
> >>
> >> rmb() looks wrong, we need mb() to serialize ACCESS_ONCE() and
> >> clear_tsk_thread_flag().
> >
> > I clearly need to review the rules.  I think you're right, though --
> > no barrier should be needed.
> >
> >>
> >> But, otoh, I think we do not need any barrier at all, we can rely on
> >> control dependency. See the recent 18c03c61444a21 "Documentation/
> >> memory-barriers.txt: Prohibit speculative writes".
> >>
> >>> +             /* audit_inc_n_rules could increment audit_n_rules here... */
> >>> +
> >>> +             clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> >>> +
> >>> +             smp_rmb();
> >>
> >> Again, I guess this should be mb() or smp_mb__after_clear_bit().
> >>
> >>
> >> And I still think this needs more changes. Once again, I do not think
> >> that, say, __audit_log_bprm_fcaps() should populate context->aux if
> >> !TIF_SYSCALL_AUDIT, this list can grow indefinitely. Or __audit_signal_info()...
> >>
> >> Perhaps __audit_syscall_exit() should also set context->dummy?
> >
> > That would work.
> >
> > I'm still torn between trying to make it possible for things like
> > __audit_log_bprm_fcaps to start a syscall audit record in the middle
> > of a syscall or to just try to tighten up the current approach to the
> > point where it will work correctly.

Personally, I'd say just hand the next syscall_entry(), don't try to get
that race closed that fast...   "The first syscall after a rule is added
will be audited"

> This is worse than I thought.  Things like signal auditing can enter
> the audit system from outside of a syscall.

Not sure what you mean here.  The only place I know of that we do
something like that is signal delivery to auditd itself, which is a
horrible nasty ugly ungodly terrible eat-your-babies hack...   We'd have
to special case that hack to not pay attention to TIF_SYSCALL_AUDIT or
audit_dummy_context(), but the rest might be fixable if we set/unset the
dummy spot...

> I don't think there's
> currently any way to tell whether you're in a syscall (when
> TIF_SYSCALL_AUDIT is clear) so getting this to work right would
> require arch help.

Don't understand why this is needed...

> I'll ask what people on the Fedora list think about just changing the
> default to -t task,never.
> 
> --Andy


