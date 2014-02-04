Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbaBDTLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:11:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932130AbaBDTLh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:11:37 -0500
Date: Tue, 4 Feb 2014 20:11:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-audit@redhat.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, Steve Grubb <sgrubb@redhat.com>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH v2.1] audit: Only use the syscall slowpath when syscall
	audit rules exist
Message-ID: <20140204191129.GB8996@redhat.com>
References: <377a1c5ce05e25b068cf7576d094885c1396c6bc.1391454589.git.luto@amacapital.net> <20140204165015.GA3011@redhat.com> <CALCETrXuBL3__bYWJ-wSQdbTx=n1jGiD71D4wN-Sm5bDU2=JSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXuBL3__bYWJ-wSQdbTx=n1jGiD71D4wN-Sm5bDU2=JSw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/04, Andy Lutomirski wrote:
>
> On Tue, Feb 4, 2014 at 8:50 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 02/03, Andy Lutomirski wrote:
> >>
> >> +void audit_inc_n_rules()
> >> +{
> >> +     struct task_struct *p, *g;
> >> +     unsigned long flags;
> >> +
> >> +     read_lock_irqsave(&tasklist_lock, flags);
> >
> > Confused... read_lock(tasklist) doesn't need to disable irqs.
> >
> > (ftrace does this for no reason too, perhaps I should resend the patch)
>
> Is this because there are no interrupt handlers that write_lock(tasklist)?

Yes.

> >
> >> +     if (audit_n_rules++ == 0) {
> >
> > probably this can be done outside of read_lock?
>
> I don't think so.  I'm cheating and using the tasklist_lock to prevent
> audit_sync_flags

Ah, yes, you are right.

> >> +             do_each_thread(g, p) {
> >
> > for_each_process_thread ;) do_each_thread will die, I hope.
> >
>
> Sorry, forgot to mention: where is this mythical
> for_each_process_thread?

In Linus's tree, please see 0c740d0afc3bff.

> or you
> just hate do_each_thread so much that you imagined up an alternative
> :)

sort of ;)

> I think I'll wait for Eric to chime in.  I suspect that the real
> solution is to simplify all this stuff by relying on the fact that the
> syscall nr and args are saved by the (fast path and slow path) entry
> code, so the audit entry hook may be entirely unnecessary.

Perhaps... but even in this case we need to do something with, say,
__audit_log_bprm_fcaps().

At least this list should not grow indefinitely if the task skips
__audit_syscall_exit(). Although at first glance this can be probably
cleanuped too.

Oleg.

