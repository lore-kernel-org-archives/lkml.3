Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3L3Run (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 12:50:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755634Ab3L3Rum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 12:50:42 -0500
Date: Mon, 30 Dec 2013 18:51:03 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 3/5] audit: store audit_pid as a struct pid pointer
Message-ID: <20131230175103.GC2457@redhat.com>
References: <cover.1387834776.git.rgb@redhat.com> <12b8a0d4d2817557eab7a84da3558388a5e5afcf.1387834776.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12b8a0d4d2817557eab7a84da3558388a5e5afcf.1387834776.git.rgb@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23, Richard Guy Briggs wrote:
>
> - PID will be reported in the relevant querying PID namespace.
>
> - Refuse to change the current audit_pid if the new value does not
>   point to an existing process.
>
> - Refuse to set the current audit_pid if the new value is not its own PID
>   (unless it is being unset).

I started to read the changelog only after I failed to understand the
patch. And it looks confusing too.

"Refuse to set the current audit_pid if the new value is not its own PID",
OK, but if the new value is the caller's pid then it should obviously
point to the existing process, current?

> - Convert audit_pid into the initial pid namespace for reports

I can't apply this patch (and the previous one) due to multiple rejects,
I guess it depends on other changes?

In any case, this patch looks wrong.

> @@ -412,9 +412,11 @@ static void kauditd_send_skb(struct sk_buff *skb)
>  		BUG_ON(err != -ECONNREFUSED); /* Shouldn't happen */
>  		if (audit_pid) {
>  			pr_err("audit: *NO* daemon at audit_pid=%d\n",
> -				audit_pid);
> +				pid_nr(audit_pid));
>  			audit_log_lost("auditd disappeared\n");
> -			audit_pid = 0;
> +			put_pid(audit_pid);

But this can actually free this pid. Why it is safe to use it elsewhere?

> +			audit_pid = NULL;

This also means that every "if (audit_pid)" is racy.

> @@ -814,12 +816,26 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
>  				return err;
>  		}
>  		if (s.mask & AUDIT_STATUS_PID) {
> -			int new_pid = s.pid;
> -
> -			if ((!new_pid) && (task_tgid_vnr(current) != audit_pid))
> +			struct pid *new_pid = find_get_pid(s.pid);
> +			if (s.pid && !new_pid)
> +				return -ESRCH;

can't understand... find_get_pid(s.pid) is pointless if s.pid == 0 ?

			struct pid *new_pid = NULL;

			if (new_pid) {
				new_pid = find_get_pid(s.pid);
				if (!new_pid)
					return -ESRCH;
			}

looks more understandable.

> +			/* check that non-zero pid it is trying to set is its
> +			 * own*/
> +			if (s.pid && (s.pid != task_pid_vnr(current)))


again, this looks a bit confusing and suboptimal. Imho it would be better
to add

			if (new_pid != task_tgid(current))

into the "if (s.pid)" above. Hmm, actually task_pid_vnr() above looks
simply wrong, we need tgid or I am totally confused.

OTOH, if we require s.pid == task_pid_vnr(current), then why do we need
find_pid() at all?

> +				return -EPERM;

this lacks put_pid(new_pid).

> +			/* check that it isn't orphaning another process */
> +			if ((!new_pid) &&
> +			    (task_tgid_vnr(current) != pid_vnr(audit_pid)))
>  				return -EACCES;

and this can go into the "else" branch.

And I can't understand the "it isn't orphaning another process" logic...

OK, what if s.pid == 0 and audit_pid == NULL, should we fail in this case?

And I do not see how this matches "Refuse to set the current audit_pid
if the new value is not its own PID" from the changelog.

> +
>  			audit_pid = new_pid;

Another leak, it seems.

> @@ -1331,7 +1347,8 @@ struct audit_buffer *audit_log_start(struct audit_context *ctx, gfp_t gfp_mask,
>  		return NULL;
>
>  	if (gfp_mask & __GFP_WAIT) {
> -		if (audit_pid && audit_pid == current->pid)
> +		if (pid_nr(audit_pid) == task_pid_nr(current))

So is this audit_pid tid or tgid? Its usage looks totally confusing.

Anyway,

		if (audit_pid == task_pid(current))

(or probably task_tgid) looks much better.

> +		//if (pid_task(audit_pid, PIDTYPE_PID) == current)

in this case you need to update Documentation/CodingStyle ;)

Oleg.

