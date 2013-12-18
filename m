Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab3LRTnu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 14:43:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870Ab3LRTns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 14:43:48 -0500
Date: Wed, 18 Dec 2013 14:43:38 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: John Johansen <john.johansen@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org
Message-ID: <20131218194338.GB23692@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bcc: rgb@redhat.com
Subject: Re: [PATCH] apparmor: remove the "task" arg from
 may_change_ptraced_domain()
Reply-To: 
In-Reply-To: <20130926132519.GY13968@madcap2.tricolour.ca>

On 13/09/26, Richard Guy Briggs wrote:
> On Tue, Sep 24, 2013 at 06:44:42PM +0200, Oleg Nesterov wrote:
> > On 09/23, Richard Guy Briggs wrote:
> > >
> > > On Mon, Sep 16, 2013 at 04:20:35PM +0200, Oleg Nesterov wrote:
> > > > Unless task == current ptrace_parent(task) is not safe even under
> > > > rcu_read_lock() and most of the current users are not right.
> > >
> > > Could you point to an explanation of this?
> > 
> > If this task exits before rcu_read_lock() ->parent can point to the
> > already freed/reused memory.
> 
> Ok, understood.  So even though the task may have exited, the task
> struct pointer is still valid, but not the contents of the task struct
> to which it points.

[The thread also relates to the patch
	"pid: get ppid pid_t of task in init_pid_ns safely"
in which sys_getppid() (which appears safe) is replaced with something that
references the init_pid_ns rather than current's pid_ns.]

So, in the general case, that call is not safe, and we should at least
remove the task_struct argument.

Analysing the calling tree, I see that most callers just call with
"current" anyways.  (Read this tree as "is called by" with the provided
"struct task_struct *".)

audit_log_task_info(?)
        audit_log_link_denied(current)
        audit_log_exit(?)
		__audit_free(?)
			audit_free(?)
                		do_exit(current)
        		        copy_process(?)
					[see below]
        ima_audit_measurement(current)
audit_filter_rules(?)
        audit_filter_task(?)
                audit_alloc(?)
			copy_process(?)
				p->real_parent is copy of current->real_parent
        audit_filter_syscall(?)
                audit_get_context(?)
                __audit_syscall_entry(current)
        audit_filter_inode_name(?)
                audit_filter_inodes(?)
                        audit_update_watch(current)
                        audit_get_context(?)
                                __audit_free(?)
                                        audit_free(?)
                                                do_exit(current)
                                                copy_process(?)
							[see below]
                                __audit_syscall_exit(current)

So looking further at copy_process()... 

	copy_flags() looks weird.  The clone_flags parameter is not used.  The
	existing flags (copied from the parent in dup_task_struct()) are
	massaged, removing PF_SUPERPRIV and PF_WQ_WORKER and adding
	PF_FORKNOEXEC.

	copy_process() passes an identical copy of "current" to audit_alloc()
	(as far as task_struct::real_parent is concerned).

	copy_process() passes an identical copy of "current" to audit_free()
	(as far as task_struct::real_parent is concerned) in all cases
	*except* if the original process has a signal_pending() and
	copy_process() was called without CLONE_PARENT or CLONE_THREAD, in
	which case tsk->real_parent is actually current.

	In fact, the actions listed in the true clause of:
		"if (clone_flags & (CLONE_PARENT|CLONE_THREAD))"
	look redundant.

So, can audit_log_task_info() and audit_filter_rules() be fixed to be called
without the task_struct pointer and just use current->real_parent directly?
How do we check for the case where there was a signal pending it and
tsk->real_parent now equals "current"?

> > (in the long term we should probably clear
> >  ->parent/real_parent/group_leader/more in __unhash_process(), but
> >  lets not discuss this right now ;)
> 
> ...so that the contents are valid in a task struct of a task that has
> exited.

The assumptions made above include that sys_getppid() was safe all along.

> Thanks for the (more obvious to me now) explanation.
> 
> > Oleg.
> 
> - RGB

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
