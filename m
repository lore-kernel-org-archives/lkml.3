Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbaBSU3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 15:29:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581AbaBSU3N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 15:29:13 -0500
Date: Wed, 19 Feb 2014 15:28:41 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        linux-audit@redhat.com, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 4/5] audit: anchor all pid references in the initial pid
 namespace
Message-ID: <20140219202841.GC17952@madcap2.tricolour.ca>
References: <cover.1387834776.git.rgb@redhat.com>
 <fec6d7e2e6d122393eab994c848f9e37639352c2.1387834776.git.rgb@redhat.com>
 <20131230180600.GD2457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230180600.GD2457@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/30, Oleg Nesterov wrote:
> On 12/23, Richard Guy Briggs wrote:
> >
> > Store and log all PIDs with reference to the initial PID namespace and
> > use the access functions task_pid_nr() and task_tgid_nr() for task->pid
> > and task->tgid rather than access them directly.
> 
> At first glance this patch looks like a good cleanup, but...
> 
> > @@ -429,6 +429,19 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
> >  			f->val = 0;
> >  		}
> >
> > +		if ((f->type == AUDIT_PID) || (f->type == AUDIT_PPID)) {
> > +			struct pid *pid;
> > +			rcu_read_lock();
> > +			pid = find_vpid(f->val);
> > +			if (!pid) {
> > +				rcu_read_unlock();
> > +				err = -ESRCH;
> > +				goto exit_free;
> > +			}
> > +			f->val = pid_nr(pid);
> > +			rcu_read_unlock();
> > +		}
> 
> I do not really understand this change, but this doesn't matter, I do
> not understand audit.

Is this pid_t handed down from userspace a valid pid_t in its
namespace?  If not, generate an error.  If it is, store its global
pid_t for future comparisons.  It might be better to store a struct
task_struct * or a struct pid *, but then the comparison functions would
have to change too, along with the rule reporting functions, which still
report pid_t to userspace.

> However, I think this deserves a separate patch with the changelog.

All *that* would need a seperate patch...

> > @@ -278,9 +278,12 @@ static void dump_common_audit_data(struct audit_buffer *ab,
> >  	}
> >  	case LSM_AUDIT_DATA_TASK:
> >  		tsk = a->u.tsk;
> > -		if (tsk && tsk->pid) {
> > -			audit_log_format(ab, " pid=%d comm=", tsk->pid);
> > -			audit_log_untrustedstring(ab, tsk->comm);
> > +		if (tsk) {
> > +			pid_t pid = task_pid_nr(tsk);
> > +			if (pid) {
> > +				audit_log_format(ab, " pid=%d comm=", pid);
> > +				audit_log_untrustedstring(ab, tsk->comm);
> 
> Just curious, is it really possible that a->u.tsk is an idle thread?

No.  It is possible a->u.tsk isn't filled in.

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
