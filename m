Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3JBBgk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 21:36:40 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40890 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab3JBBgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 21:36:37 -0400
Message-ID: <524B78A2.40007@amacapital.net>
Date: Tue, 01 Oct 2013 18:36:34 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Djalal Harouni <tixxdz@opendz.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Serge E. Hallyn" <serge.hallyn@ubuntu.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, tixxdz@gmail.com
Subject: Re: [PATCH v2 2/9] procfs: add proc_allow_access() to check if file's
 opener may access task
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org> <1380659178-28605-3-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-3-git-send-email-tixxdz@opendz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 01:26 PM, Djalal Harouni wrote:
> Since /proc entries varies at runtime, permission checks need to happen
> during each system call.
> 
> However even with that /proc file descriptors can be passed to a more
> privileged process (e.g. a suid-exec) which will pass the classic
> ptrace_may_access() permission check. The open() call will be issued in
> general by an unprivileged process while the disclosure of sensitive
> /proc information will happen using a more privileged process at
> read(),write()...
> 
> Therfore we need a more sophisticated check to detect if the cred of the
> process have changed, and if the cred of the original opener that are
> stored in the file->f_cred have enough permission to access the task's
> /proc entries during read(), write()...
> 
> Add the proc_allow_access() function that will receive the file->f_cred
> as an argument, and tries to check if the opener had enough permission
> to access the task's /proc entries.
> 
> This function should be used with the ptrace_may_access() check.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
> Signed-off-by: Djalal Harouni <tixxdz@opendz.org>
> ---
>  fs/proc/base.c     | 56 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/proc/internal.h |  2 ++
>  2 files changed, 58 insertions(+)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index e834946..c29eeae 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -168,6 +168,62 @@ int proc_same_open_cred(const struct cred *fcred)
>  		cap_issubset(cred->cap_permitted, fcred->cap_permitted));
>  }
>  
> +/* Returns 0 on success, -errno on denial. */
> +static int __proc_allow_access(const struct cred *cred,
> +			       struct task_struct *task, unsigned int mode)
> +{
> +	int ret = 0;
> +	const struct cred *tcred;
> +	const struct cred *fcred = cred;
> +
> +	rcu_read_lock();
> +	tcred = __task_cred(task);
> +	if (uid_eq(fcred->uid, tcred->euid) &&
> +	    uid_eq(fcred->uid, tcred->suid) &&
> +	    uid_eq(fcred->uid, tcred->uid)  &&
> +	    gid_eq(fcred->gid, tcred->egid) &&
> +	    gid_eq(fcred->gid, tcred->sgid) &&
> +	    gid_eq(fcred->gid, tcred->gid))
> +		goto out;
> +

What's this for?  Is it supposed to be an optimization?  If so, it looks
potentially exploitable, although I don't really understand what you're
trying to do.

--Andy
