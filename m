Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbaCRRyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:54:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756805AbaCRRyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:54:46 -0400
Date: Tue, 18 Mar 2014 13:54:41 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: get comm using lock to avoid race in string
 printing
Message-ID: <20140318175441.GB21578@madcap2.tricolour.ca>
References: <20140315232846.GE27244@madcap2.tricolour.ca>
 <14ba8faef484ac199ca33fe78fdf943a8d9755fb.1394925657.git.rgb@redhat.com>
 <53288477.9060808@tycho.nsa.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53288477.9060808@tycho.nsa.gov>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/18, Stephen Smalley wrote:
> On 03/15/2014 07:29 PM, Richard Guy Briggs wrote:
> > ---
> >  kernel/audit.c   |    5 ++---
> >  kernel/auditsc.c |    9 +++++----
> >  2 files changed, 7 insertions(+), 7 deletions(-)
> 
> Doesn't this also need to be fixed (twice) in security/lsm_audit.c?

Yes.  Tetsuo had sent a tentative patch to James Morris who pushed back
pending review.

I also just found one in security/integrity/integrity_audit.c

> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 9239e5e..5b600c8 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -1883,7 +1883,7 @@ EXPORT_SYMBOL(audit_log_task_context);
> >  void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
> >  {
> >  	const struct cred *cred;
> > -	char name[sizeof(tsk->comm)];
> > +	char comm[sizeof(tsk->comm)];
> >  	struct mm_struct *mm = tsk->mm;
> >  	char *tty;
> >  
> > @@ -1917,9 +1917,8 @@ void audit_log_task_info(struct audit_buffer *ab, struct task_struct *tsk)
> >  			 from_kgid(&init_user_ns, cred->fsgid),
> >  			 tty, audit_get_sessionid(tsk));
> >  
> > -	get_task_comm(name, tsk);
> >  	audit_log_format(ab, " comm=");
> > -	audit_log_untrustedstring(ab, name);
> > +	audit_log_untrustedstring(ab, get_task_comm(name, tsk));
> >  
> >  	if (mm) {
> >  		down_read(&mm->mmap_sem);
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 8fffca8..b789e0c 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2289,7 +2289,7 @@ void __audit_ptrace(struct task_struct *t)
> >  	context->target_uid = task_uid(t);
> >  	context->target_sessionid = audit_get_sessionid(t);
> >  	security_task_getsecid(t, &context->target_sid);
> > -	memcpy(context->target_comm, t->comm, TASK_COMM_LEN);
> > +	get_task_comm(context->target_comm, t);
> >  }
> >  
> >  /**
> > @@ -2328,7 +2328,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
> >  		ctx->target_uid = t_uid;
> >  		ctx->target_sessionid = audit_get_sessionid(t);
> >  		security_task_getsecid(t, &ctx->target_sid);
> > -		memcpy(ctx->target_comm, t->comm, TASK_COMM_LEN);
> > +		get_task_comm(ctx->target_comm, t);
> >  		return 0;
> >  	}
> >  
> > @@ -2349,7 +2349,7 @@ int __audit_signal_info(int sig, struct task_struct *t)
> >  	axp->target_uid[axp->pid_count] = t_uid;
> >  	axp->target_sessionid[axp->pid_count] = audit_get_sessionid(t);
> >  	security_task_getsecid(t, &axp->target_sid[axp->pid_count]);
> > -	memcpy(axp->target_comm[axp->pid_count], t->comm, TASK_COMM_LEN);
> > +	get_task_comm(axp->target_comm[axp->pid_count], t);
> >  	axp->pid_count++;
> >  
> >  	return 0;
> > @@ -2435,6 +2435,7 @@ static void audit_log_task(struct audit_buffer *ab)
> >  	kgid_t gid;
> >  	unsigned int sessionid;
> >  	struct mm_struct *mm = current->mm;
> > +	char comm[sizeof(current->comm)];
> >  
> >  	auid = audit_get_loginuid(current);
> >  	sessionid = audit_get_sessionid(current);
> > @@ -2447,7 +2448,7 @@ static void audit_log_task(struct audit_buffer *ab)
> >  			 sessionid);
> >  	audit_log_task_context(ab);
> >  	audit_log_format(ab, " pid=%d comm=", task_pid_nr(current));
> > -	audit_log_untrustedstring(ab, current->comm);
> > +	audit_log_untrustedstring(ab, get_task_comm(comm, current);
> >  	if (mm) {
> >  		down_read(&mm->mmap_sem);
> >  		if (mm->exe_file)
> > 
> 

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
