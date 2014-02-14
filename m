Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbaBNQF4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 11:05:56 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:53078 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbaBNQFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 11:05:54 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, criu@openvz.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Kees Cook <keescook@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Emelyanov <xemul@parallels.com>,
        Aditya Kali <adityakali@google.com>
References: <1392387209-330-1-git-send-email-avagin@openvz.org>
	<1392387209-330-2-git-send-email-avagin@openvz.org>
Date: Fri, 14 Feb 2014 08:05:42 -0800
In-Reply-To: <1392387209-330-2-git-send-email-avagin@openvz.org> (Andrey
	Vagin's message of "Fri, 14 Feb 2014 18:13:27 +0400")
Message-ID: <874n41znl5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Mqs1lqGJaXW18d9YmE0RJ5HfNQcZjZGk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3790]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  1.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Andrey Vagin <avagin@openvz.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 1/3] prctl: reduce permissions to change boundaries of data, brk and stack
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Vagin <avagin@openvz.org> writes:

> Currently this operation requires the global CAP_SYS_RESOURCE.
> It's required, because a task can exceed limits (RLIMIT_DATA,
> RLIMIT_STACK).
>
> So let's allow task to change these parameters if a proper limit is
> unlimited.
>
> When we restore a task we need to set up text, data and data heap sizes
> from userspace to the values a task had at checkpoint time.
>
> Currently we can not restore these parameters, if a task lives in
> a non-root user name space, because it has no capabilities in the
> parent namespace.

My brain hurts just looking at this patch and how you are justifying it.

For the resources you are mucking with below all you have to do is to
verify that you are below the appropriate rlimit at all times and no
CAP_SYS_RESOURCE check is needed.  You only need CAP_SYS_RESOURCE
to exceed your per process limits.

All you have to do is to fix the current code to properly enforce the
limits.  This half-assed code that forgets the permission checks if
rlimit is set to rlimit_inifinity is wrong.

Eric


> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: "Eric W. Biederman" <ebiederm@xmission.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: Aditya Kali <adityakali@google.com>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>
> ---
>  kernel/sys.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sys.c b/kernel/sys.c
> index c0a58be..939370c 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -1701,8 +1701,23 @@ static int prctl_set_mm(int opt, unsigned long addr,
>  	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
>  		return -EINVAL;
>  
> -	if (!capable(CAP_SYS_RESOURCE))
> -		return -EPERM;
> +	if (!capable(CAP_SYS_RESOURCE)) {
> +		switch (opt) {
> +		case PR_SET_MM_START_DATA:
> +		case PR_SET_MM_END_DATA:
> +		case PR_SET_MM_START_BRK:
> +		case PR_SET_MM_BRK:
> +			if (rlim < RLIM_INFINITY)
> +				return -EPERM;
> +			break;
> +		case PR_SET_MM_START_STACK:
> +			if (rlimit(RLIMIT_STACK) < RLIM_INFINITY)
> +				return -EPERM;
> +			break;
> +		default:
> +			return -EPERM;
> +		}
> +	}
>  
>  	if (opt == PR_SET_MM_EXE_FILE)
>  		return prctl_set_mm_exe_file(mm, (unsigned int)addr);
