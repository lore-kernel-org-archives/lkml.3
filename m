Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751124Ab3FJEHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 00:07:43 -0400
Received: from out04.mta.xmission.com ([166.70.13.234]:48039 "EHLO
	out04.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3FJEHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 00:07:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Pavel Emelyanov <xemul@parallels.com>,
        Sergey Dyasly <dserrg@gmail.com>, linux-kernel@vger.kernel.org
References: <20130609170023.GA5233@redhat.com>
Date: Sun, 09 Jun 2013 21:07:13 -0700
In-Reply-To: <20130609170023.GA5233@redhat.com> (Oleg Nesterov's message of
	"Sun, 9 Jun 2013 19:00:23 +0200")
Message-ID: <87obbevcb2.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/jm6UH8N6vEIU1p2iJJIz44gPwBDssI4I=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0136]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/4] de_thread: use change_pid() rather than detach_pid/attach_pid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> de_thread() can use change_pid() instead of detach + attach.
> This looks better and this ensures that, say, next_thread()
> can never see a task with ->pid == NULL.

I want to say that there I though there was a good reason something
to do with the exit logic.

However I just read through attach_pid, detach_pid, and change_pid.
And the sequence detach_pid(...); attach_pid(...)  is equiavalent
to change_pid(...);

Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  fs/exec.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 6430195..00eaba7 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -945,9 +945,8 @@ static int de_thread(struct task_struct *tsk)
>  		 * Note: The old leader also uses this pid until release_task
>  		 *       is called.  Odd but simple and correct.
>  		 */
> -		detach_pid(tsk, PIDTYPE_PID);
>  		tsk->pid = leader->pid;
> -		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));
> +		change_pid(tsk, PIDTYPE_PID, task_pid(leader));
>  		transfer_pid(leader, tsk, PIDTYPE_PGID);
>  		transfer_pid(leader, tsk, PIDTYPE_SID);
