Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbaAUXiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:38:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754648AbaAUXiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:38:11 -0500
Date: Tue, 21 Jan 2014 18:37:42 -0500
From: Richard Guy Briggs <rgb@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/5] audit: store audit_pid as a struct pid pointer
Message-ID: <20140121233742.GC1981@madcap2.tricolour.ca>
References: <cover.1387834776.git.rgb@redhat.com>
 <12b8a0d4d2817557eab7a84da3558388a5e5afcf.1387834776.git.rgb@redhat.com>
 <20131230175103.GC2457@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230175103.GC2457@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/30, Oleg Nesterov wrote:
> On 12/23, Richard Guy Briggs wrote:
> >
> > - PID will be reported in the relevant querying PID namespace.
> >
> > - Refuse to change the current audit_pid if the new value does not
> >   point to an existing process.
> >
> > - Refuse to set the current audit_pid if the new value is not its own PID
> >   (unless it is being unset).
> 
> I started to read the changelog only after I failed to understand the
> patch. And it looks confusing too.
> 
> "Refuse to set the current audit_pid if the new value is not its own PID",
> OK, but if the new value is the caller's pid then it should obviously
> point to the existing process, current?

Yes, but it may be lying, which helps nobody.  The value should either
be its own pid, or zero.

> > - Convert audit_pid into the initial pid namespace for reports
> 
> I can't apply this patch (and the previous one) due to multiple rejects,
> I guess it depends on other changes?

It depends on other patches in my for-next tree, but not necessarily
functionally.

> In any case, this patch looks wrong.
> 
> > @@ -412,9 +412,11 @@ static void kauditd_send_skb(struct sk_buff *skb)
> >  		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
> >  		if (audit_pid) {
> >  			pr_err("audit: *NO* daemon at audit_pid=%d\n",
> > -				audit_pid);
> > +				pid_nr(audit_pid));
> >  			audit_log_lost("auditd disappeared\n");
> > -			audit_pid = 0;
> > +			put_pid(audit_pid);
> 
> But this can actually free this pid. Why it is safe to use it elsewhere?
> 
> > +			audit_pid = NULL;
> 
> This also means that every "if (audit_pid)" is racy.

Ok, so I really need something like:

 		if (audit_pid) {
			struct pid *temp_pid = audit_pid;
 			pr_err("*NO* daemon at audit_pid=%d\n", pid_nr(audit_pid));
 			audit_log_lost("auditd disappeared\n");
			audit_pid = NULL;
			smp_mb();
			put_pid(temp_pid);
			audit_sock = NULL;
		}

Do I actually need the memory barrier there?  Is that the right one to
use?

> > @@ -814,12 +816,26 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> >  				return err;
> >  		}
> >  		if (s.mask & AUDIT_STATUS_PID) {
> > -			int new_pid = s.pid;
> > -
> > -			if ((!new_pid) && (task_tgid_vnr(current) != audit_pid))
> > +			struct pid *new_pid = find_get_pid(s.pid);
> > +			if (s.pid && !new_pid)
> > +				return -ESRCH;
> 
> can't understand... find_get_pid(s.pid) is pointless if s.pid == 0 ?

"can't understand"?  I hope you mean "don't understand".  ;-)

> 			struct pid *new_pid = NULL;
> 
> 			if (new_pid) {

I think you mean "if (s.pid) {".

> 				new_pid = find_get_pid(s.pid);
> 				if (!new_pid)
> 					return -ESRCH;
> 			}
> 
> looks more understandable.

Agreed.

> > +			/* check that non-zero pid it is trying to set is its
> > +			 * own*/
> > +			if (s.pid && (s.pid != task_pid_vnr(current)))
> 
> again, this looks a bit confusing and suboptimal. Imho it would be better
> to add
> 
> 			if (new_pid != task_tgid(current))

It is not so obvious to me, because this code had been dealing with
pid_t rather than struct pid*, but I agree it may be more optimal.

> into the "if (s.pid)" above. Hmm, actually task_pid_vnr() above looks
> simply wrong, we need tgid or I am totally confused.

The use of task_tgid_vnr() in isolation in commit 34eab0a7 was an error,
I believe, and should have been task_pid_vnr() unless new_pid was then
converted to the thread group leader before being assigned to audit_pid.
I believe auditd only ever registers from the thread group leader, but I
will have to check that assumption with Steve and Eric.  If not, I may
have to change it to reference the tgid, making this code a bit more
complex since it would need to convert from pid_t to struct pid*, then
find the tgid.

I'd need to replace:
	new_pid = find_get_pid(s.pid);

with:
	rcu_read_lock();
	new_pid = get_pid(task_tgid(find_task_by_vpid(s.pid)))
	rcu_read_unlock();

or it might be nicer to define:
	struct pid *audit_find_get_tgid(pid_t vnr) {
		rcu_read_lock();
		new_pid = get_pid(task_tgid(find_task_by_vpid(vnr)));
		rcu_read_unlock();
	}

or better yet in kernel/pid.c:
	struct pid *find_get_tgid(pid_t vnr) {
		rcu_read_lock();
		new_pid = get_pid(task_tgid(find_task_by_vpid(vnr)));
		rcu_read_unlock();
	}

Do you have another reason to believe we need task_tgid_vnr()?

Part of the answer is in 582edda5, but if my assumption above is
correct, we don't need it here.

> OTOH, if we require s.pid == task_pid_vnr(current), then why do we need
> find_pid() at all?

Because userspace may be trying to set it to zero on shutdown, but I
suppose we could special-case zero.

> > +				return -EPERM;
> 
> this lacks put_pid(new_pid).

Thanks.

> > +			/* check that it isn't orphaning another process */
> > +			if ((!new_pid) &&
> > +			    (task_tgid_vnr(current) != pid_vnr(audit_pid)))
> >  				return -EACCES;
> 
> and this can go into the "else" branch.

Yup.

> And I can't understand the "it isn't orphaning another process" logic...

There was a potential race condition that if a second auditd started up
while there was still one running, when the first eventually shut down,
it would try to set the audit_pid to zero to indicate it was going away
and orphan the newer auditd from kaudit.

If we check that the pid of the auditd trying to set it to zero was the
same as the pid recorded in kaudit, we can safely assume it is the
newest and safely set audit_pid to zero.

A newer auditd can orphan a previous auditd, but this isn't really
avoidable since it may be awol and need replacing anyways.

> OK, what if s.pid == 0 and audit_pid == NULL, should we fail in this case?

It doesn't really matter since auditd isn't likely to try this
combinaiton and it won't matter if it fails.

> And I do not see how this matches "Refuse to set the current audit_pid
> if the new value is not its own PID" from the changelog.
> 
> > +
> >  			audit_pid = new_pid;
> 
> Another leak, it seems.

Oops, thanks.

> > @@ -1331,7 +1347,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
> >  		return NULL;
> >
> >  	if (gfp_mask & __GFP_WAIT) {
> > -		if (audit_pid && audit_pid == current->pid)
> > +		if (pid_nr(audit_pid) == task_pid_nr(current))
> 
> So is this audit_pid tid or tgid? Its usage looks totally confusing.

pid, as noted above, but could be changed to tgid.

> Anyway,
> 
> 		if (audit_pid == task_pid(current))
> 
> (or probably task_tgid) looks much better.

Fair enough, compare struct pid* rather than the original pid_t.

> > +		//if (pid_task(audit_pid, PIDTYPE_PID) == current)
> 
> in this case you need to update Documentation/CodingStyle ;)

Heh...  trust the SCM...  and that was comparing task_structs rather
than pid_t or struct pid*.  Still getting comfortable with struct pid*.

> Oleg.

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545
