Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3IJR0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:26:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab3IJR0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:26:43 -0400
Date: Tue, 10 Sep 2013 19:20:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, Richard Guy Briggs <rgb@redhat.com>,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: audit looks unmaintained? [was: Re: [PATCH 11/12] pid: rewrite
	task helper functions avoiding task->pid and task->tgid]
Message-ID: <20130910172033.GA6585@redhat.com>
References: <cover.1377032086.git.rgb@redhat.com> <20130827171134.GB29147@redhat.com> <20130830190646.GA30331@madcap2.tricolour.ca> <3996102.evTQ9SbNnV@x2> <20130908155435.GC4663@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130908155435.GC4663@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08, Oleg Nesterov wrote:
>
> First of all, I do not pretend I understand this code. This was mostly
> the question, and in fact I mostly asked about audit_bprm() in 0/1.
>
> However,
>
> On 08/30, Steve Grubb wrote:
> > On Friday, August 30, 2013 03:06:46 PM Richard Guy Briggs wrote:
> > > On Tue, Aug 27, 2013 at 07:11:34PM +0200, Oleg Nesterov wrote:
> > > > Btw. audit looks unmaintained... if you are going to take care of
> > > > this code, perhaps you can look at
> > > >
> > > > 	http://marc.info/?l=linux-kernel&m=137589907108485
> > > > 	http://marc.info/?l=linux-kernel&m=137590271809664
> >
> > You don't want to clear the TIF audit flag when context == NULL. What that will
> > do is make a bunch of inauditable processes. There are times when audit is
> > disabled and then re-enabled later. If the flag gets cleared, then a task's
> > syscall will never enter the auditing framework from kernel/entry_64.S.
> >
> > That flag is 0 when auditing has never ever been enabled. If auditing is
> > enabled, it should always be a 1 unless the task filter has determined that
> > this process should not be audited ever. In practice, this is almost never
> > used. But ensuring the TIF_SYSCALL_AUDIT set to 1 on all processes is why we
> > have the boot argument. Not setting audit=1 on the boot arguments means that
> > any process running before the audit daemon enables auditing can never ever be
> > audited because the only place its set is when processes are cloned.
>
> Then why audit_alloc() doesn't set TIF_SYSCALL_AUDIT unconditionally?
>
> And I do not understand "when context == NULL" above. Say, audit_syscall_entry()
> does nothing if !audit_context, and nobody except copy_process() does
> audit_alloc(). So why do we need to trigger the audit's paths if it is NULL?
>
> > Hope this clears up the use. NAK to the patch, it'll break auditing.
>
> Not really, but thanks for your reply anyway.

So, Steve, do you still think that patch was wrong? Attached below
just in case.

Oleg.

[PATCH 1/1] audit_alloc: clear TIF_SYSCALL_AUDIT if !audit_context

If audit_filter_task() nacks the new thread it makes sense
to clear TIF_SYSCALL_AUDIT which can be copied from parent
by dup_task_struct().

A wrong TIF_SYSCALL_AUDIT is not really bad, but it triggers
the "slow" audit paths in entry.S.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/auditsc.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9845cb3..95293ab 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -943,8 +943,10 @@ int audit_alloc(struct task_struct *tsk)
 		return 0; /* Return if not auditing. */
 
 	state = audit_filter_task(tsk, &key);
-	if (state == AUDIT_DISABLED)
+	if (state == AUDIT_DISABLED) {
+		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 		return 0;
+	}
 
 	if (!(context = audit_alloc_context(state))) {
 		kfree(key);
-- 
1.5.5.1


