Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbaAVNoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 08:44:22 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40128 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604AbaAVNoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 08:44:21 -0500
Date: Wed, 22 Jan 2014 07:44:18 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: Allow stealing of controlling ttys within user
 namespaces
Message-ID: <20140122134418.GA26725@thinkpad-t410>
Mail-Followup-To: "Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Serge Hallyn <serge.hallyn@canonical.com>,
	linux-kernel@vger.kernel.org
References: <1390335754-32202-1-git-send-email-seth.forshee@canonical.com>
 <877g9t0w11.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877g9t0w11.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 03:12:26PM -0800, Eric W. Biederman wrote:
> Seth Forshee <seth.forshee@canonical.com> writes:
> 
> > root is allowed to steal ttys from other sessions, but it
> > requires system-wide CAP_SYS_ADMIN and therefore is not possible
> > for root within a user namespace. This should be allowed so long
> > as the process doing the stealing is privileged towards the
> > session leader which currently owns the tty.
> >
> > Update the tty code to only require CAP_SYS_ADMIN in the
> > namespace of the target session leader when stealing a tty. Fall
> > back to using init_user_ns to preserve the existing behavior for
> > system-wide root.
> >
> > Cc: stable@vger.kernel.org # 3.8+
> 
> This is not a regression of any form, nor is it obviously correct so
> this does not count as a stable material.
> 
> > Cc: Serge Hallyn <serge.hallyn@canonical.com>
> > Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> > Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> > ---
> >  drivers/tty/tty_io.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> > index c74a00a..1c47f16 100644
> > --- a/drivers/tty/tty_io.c
> > +++ b/drivers/tty/tty_io.c
> > @@ -2410,7 +2410,19 @@ static int tiocsctty(struct tty_struct *tty, int arg)
> >  		 * This tty is already the controlling
> >  		 * tty for another session group!
> >  		 */
> > -		if (arg == 1 && capable(CAP_SYS_ADMIN)) {
> > +		struct user_namespace *ns = &init_user_ns;
> > +		struct task_struct *p;
> > +
> > +		read_lock(&tasklist_lock);
> > +		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
> > +			if (p->signal->leader) {
> > +				ns = task_cred_xxx(p, user_ns);
> > +				break;
> > +			}
> > +		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
> > +		read_unlock(&tasklist_lock);
> 
> Ugh.  That appears to be both racy (what protects the user_ns from going
> away?) and a possibly allowing revoking a tty from a more privileged processes tty.
> 
> However I do see a form that can easily verify we won't revoke a tty from a
> more privileged process.
> 
> 		if (arg == 1) {
>                 	struct user_namespace *user_ns;
> 			read_lock(&tasklist_lock);
> 			do_each_pid_task(tty->session, PIDTYPE_SID, p) {
>                                 rcu_read_lock();
> 				user_ns = task_cred_xxx(p, user_ns);
> 				if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
>                                         rcu_read_unlock();
>                                         read_unlock(&task_list_lock);
>                                 	ret = -EPERM;
>                                         goto out_unlock;
> 				}
>                                 rcu_read_unlock();
> 			}
>                         /* Don't drop the the tasklist_lock before
>                          * stealing the tasks or the set of tasks can
>                          * change, and we only have permission for this set
>                          * of tasks.
>                          */
>   			/*
>   			 * Steal it away
>   			 */
>                          session_clear_tty(tty->session);
>                          read_unlock(&task_list_lock);
> 		} else {
>                 	ret = -EPERM;
> 			goto out_unlock;
>                 }
> 
> My code above is ugly and could use some cleaning up but it should be
> correct with respect to this issue.

Thanks for the review. I'm not sure about the correctness of checking
all processes in the session versus just the session leader, since the
leader is the only task that really owns the tty in the sense of being
able to set and clear it for the session. But most of the time all the
tasks will be in the same namespace anyway.

I'm about to start testing a modified version of the above, and I'll
send and updated patch once I've finished.

Thanks,
Seth

