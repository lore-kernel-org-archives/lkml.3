Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaAXXbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 18:31:25 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:44838 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbaAXXbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 18:31:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
References: <1390402431-6371-1-git-send-email-seth.forshee@canonical.com>
Date: Fri, 24 Jan 2014 15:31:15 -0800
In-Reply-To: <1390402431-6371-1-git-send-email-seth.forshee@canonical.com>
	(Seth Forshee's message of "Wed, 22 Jan 2014 08:53:51 -0600")
Message-ID: <8738kdq7ng.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18s2VmX8em8cQ6kKr39Xg6k0Bll2UI3nS4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1232]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seth Forshee <seth.forshee@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v2] tty: Allow stealing of controlling ttys within user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> root is allowed to steal ttys from other sessions, but it
> requires system-wide CAP_SYS_ADMIN and therefore is not possible
> for root within a user namespace. This should be allowed so long
> as the process doing the stealing is privileged towards the
> session which currently owns the tty.
>
> Update this code to only require CAP_SYS_ADMIN in the user
> namespaces of the target session's tasks, allowing the tty to be
> stolen from sessions whose tasks are in the same or lesser
> privileged user namespaces.

This code looks essentially correct.  I would like to look at it a bit
more before we merge it, just to ensure something silly hasn't been
missed, but the only thing that concerns me at this point is are we
checking the proper per task bits.

The case I am currently worrying about is a task that does something
privileged drops perms sets dumpable and then calls setns() on the
userns.

So I think we may have to solve the dumpable problem at the same time as
we solve this issue.

Now I don't know if it makes sense to take this through the tty tree or
my userns tree.  I am inclined to take it through the userns tree simply
because I am reviewing it and I have seen the several failed attempts at
this but if Greg wants it in the tty tree I won't object.

What I do want to do is be especially careful with a patch like this so
we don't accidentally introduce a DAC policy hole, and cause security
problems for people.  Bugs like that don't do anyone any good.

> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/tty/tty_io.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index c74a00a..558e6dc 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -2410,17 +2410,32 @@ static int tiocsctty(struct tty_struct *tty, int arg)
>  		 * This tty is already the controlling
>  		 * tty for another session group!
>  		 */
> -		if (arg == 1 && capable(CAP_SYS_ADMIN)) {
> -			/*
> -			 * Steal it away
> -			 */
> -			read_lock(&tasklist_lock);
> -			session_clear_tty(tty->session);
> -			read_unlock(&tasklist_lock);
> -		} else {
> +		struct user_namespace *user_ns;
> +		struct task_struct *p;
> +
> +		if (arg != 1) {
>  			ret = -EPERM;
>  			goto unlock;
>  		}
> +
> +		read_lock(&tasklist_lock);
> +		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
> +			rcu_read_lock();
> +			user_ns = task_cred_xxx(p, user_ns);
> +			if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
> +				rcu_read_unlock();
> +				read_unlock(&tasklist_lock);
> +				ret = -EPERM;
> +				goto unlock;
> +			}
> +			rcu_read_unlock();
> +		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
> +
> +		/*
> +		 * Steal it away
> +		 */
> +		session_clear_tty(tty->session);
> +		read_unlock(&tasklist_lock);
>  	}
>  	proc_set_tty(current, tty);
>  unlock:
