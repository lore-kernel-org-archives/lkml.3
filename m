Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754458AbaBLXOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 18:14:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:32874 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaBLXOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 18:14:19 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Robin Holt <holt@sgi.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Chen Gang <gang.chen@asianux.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>, security@kernel.org
References: <1392219611-13260-1-git-send-email-avagin@openvz.org>
Date: Wed, 12 Feb 2014 15:14:07 -0800
In-Reply-To: <1392219611-13260-1-git-send-email-avagin@openvz.org> (Andrey
	Vagin's message of "Wed, 12 Feb 2014 19:40:11 +0400")
Message-ID: <87ob2b6i0w.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19o6BR0BDXznRuiAdsnWE2NyeHssfpoLfk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 KHOP_BIG_TO_CC Sent to 10+ recipients instaed of Bcc or a list
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4944]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;Andrey Vagin <avagin@openvz.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernel: reduce required permission for prctl_set_mm
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Vagin <avagin@openvz.org> writes:

> Currently prctl_set_mm requires the global CAP_SYS_RESOURCE,
> this patch reduce requiremence to CAP_SYS_RESOURCE in the current
> namespace.
>
> When we restore a task we need to set up text, data and data heap sizes
> from userspace to the values a task had at checkpoint time.
>
> Currently we can not restore these parameters, if a task lives in
> a non-root user name space, because it has no capabilities in the
> parent namespace.
>
> prctl_set_mm() changes parameters of the current task and doesn't affect
> other tasks.
>
> This patch affects the RLIMIT_DATA limit, because a consumtiuon is
> calculated relatively to mm->end_data, mm->start_data, mm->start_brk.
>
> rlim = rlimit(RLIMIT_DATA);
> if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
> 		(mm->end_data - mm->start_data) > rlim)
> 	goto out;
>
> This limit affects calls to brk() and sbrk(), but it doesn't affect
> mmap. So I think requirement of CAP_SYS_RESOURCE in the current
> namespace is enough for this limit.

Ick.  No.

You do not have an argument for reducing the capable call here to
ns_capable.  ns_capable(current_user_ns(), CAP_SYS_RESOURCE) does not
currently allow anything.  If ns_capable(current_user_ns(),
CAP_SYS_RESOURCE) were to allow things there would still need to be a
check for a root setable maximum which is not present in this patch.

Either you have an argument for completely removing the capability check
or your reasoning is broken.

Reading through the code and reading through brk I an fairly confident
that your reasoning is broken.

The rlimit test needs to be when any of start_brk, end_data, or
start_data are changed, and that test is most definitely not performed.

Checks for enforcing the stack_size are completely missing.

It does look like with care we can remove or make much more precise the
capable checks from in prctl_set_mm but this patch definitely does not
take that needed care.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Robin Holt <holt@sgi.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Chen Gang <gang.chen@asianux.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Aditya Kali <adityakali@google.com>
> Cc: security@kernel.org
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  kernel/sys.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index c0a58be..6f36fb3 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1701,7 +1701,7 @@ static int prctl_set_mm(int opt, unsigned long addr,
>  	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
>  		return -EINVAL;
>  
> -	if (!capable(CAP_SYS_RESOURCE))
> +	if (!ns_capable(current_user_ns(), CAP_SYS_RESOURCE))
>  		return -EPERM;
>  
>  	if (opt == PR_SET_MM_EXE_FILE)
