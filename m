Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831AbaAUXMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 18:12:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:49127 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969AbaAUXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 18:12:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
References: <1390335754-32202-1-git-send-email-seth.forshee@canonical.com>
Date: Tue, 21 Jan 2014 15:12:26 -0800
In-Reply-To: <1390335754-32202-1-git-send-email-seth.forshee@canonical.com>
	(Seth Forshee's message of "Tue, 21 Jan 2014 14:22:23 -0600")
Message-ID: <877g9t0w11.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+mhNUKFdx0I86dw1jxlVecp18f8Bl/tk4=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0145]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Seth Forshee <seth.forshee@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] tty: Allow stealing of controlling ttys within user namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seth Forshee <seth.forshee@canonical.com> writes:

> root is allowed to steal ttys from other sessions, but it
> requires system-wide CAP_SYS_ADMIN and therefore is not possible
> for root within a user namespace. This should be allowed so long
> as the process doing the stealing is privileged towards the
> session leader which currently owns the tty.
>
> Update the tty code to only require CAP_SYS_ADMIN in the
> namespace of the target session leader when stealing a tty. Fall
> back to using init_user_ns to preserve the existing behavior for
> system-wide root.
>
> Cc: stable@vger.kernel.org # 3.8+

This is not a regression of any form, nor is it obviously correct so
this does not count as a stable material.

> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
> ---
>  drivers/tty/tty_io.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
> index c74a00a..1c47f16 100644
> --- a/drivers/tty/tty_io.c
> +++ b/drivers/tty/tty_io.c
> @@ -2410,7 +2410,19 @@ static int tiocsctty(struct tty_struct *tty, int arg)
>  		 * This tty is already the controlling
>  		 * tty for another session group!
>  		 */
> -		if (arg == 1 && capable(CAP_SYS_ADMIN)) {
> +		struct user_namespace *ns = &init_user_ns;
> +		struct task_struct *p;
> +
> +		read_lock(&tasklist_lock);
> +		do_each_pid_task(tty->session, PIDTYPE_SID, p) {
> +			if (p->signal->leader) {
> +				ns = task_cred_xxx(p, user_ns);
> +				break;
> +			}
> +		} while_each_pid_task(tty->session, PIDTYPE_SID, p);
> +		read_unlock(&tasklist_lock);

Ugh.  That appears to be both racy (what protects the user_ns from going
away?) and a possibly allowing revoking a tty from a more privileged processes tty.

However I do see a form that can easily verify we won't revoke a tty from a
more privileged process.

		if (arg == 1) {
                	struct user_namespace *user_ns;
			read_lock(&tasklist_lock);
			do_each_pid_task(tty->session, PIDTYPE_SID, p) {
                                rcu_read_lock();
				user_ns = task_cred_xxx(p, user_ns);
				if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
                                        rcu_read_unlock();
                                        read_unlock(&task_list_lock);
                                	ret = -EPERM;
                                        goto out_unlock;
				}
                                rcu_read_unlock();
			}
                        /* Don't drop the the tasklist_lock before
                         * stealing the tasks or the set of tasks can
                         * change, and we only have permission for this set
                         * of tasks.
                         */
  			/*
  			 * Steal it away
  			 */
                         session_clear_tty(tty->session);
                         read_unlock(&task_list_lock);
		} else {
                	ret = -EPERM;
			goto out_unlock;
                }

My code above is ugly and could use some cleaning up but it should be
correct with respect to this issue.

Eric


> +		if (arg == 1 && ns_capable(user_ns, CAP_SYS_ADMIN)) {
>  			/*
>  			 * Steal it away
>  			 */
