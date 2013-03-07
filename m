Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932511Ab3CGKPG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:15:06 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:32768 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755527Ab3CGKPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:15:04 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1362649361.14735.5.camel@beeld>
Date: Thu, 07 Mar 2013 02:14:56 -0800
In-Reply-To: <1362649361.14735.5.camel@beeld> (Rakib Mullick's message of
	"Thu, 07 Mar 2013 15:42:41 +0600")
Message-ID: <87r4jrv7mn.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+7jSrj/Wn9Onlkv6e/chvxp161tgAgmTc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rakib Mullick <rakib.mullick@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] nsproxy: Fix ->nsproxy counting problem in copy_namespace.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks applied.

This is an unpleasant accidental memory leak.

Eric


Rakib Mullick <rakib.mullick@gmail.com> writes:

> From cd41495e25cf2641ffe9e01a40d3d221a46b08be Mon Sep 17 00:00:00 2001
> From: Rakib Mullick <rakib.mullick@gmail.com>
> Date: Thu, 7 Mar 2013 14:52:20 +0600
> Subject: [PATCH] nsproxy: Fix ->nsproxy counting problem in copy_namespace.
>
> In copy_namespace(), get_nsproxy() (which increments nsproxy->count) is called before checking namespace related flags.
> Therefore, task's nsproxy->count could have improper value, which could lead to calling free_nsproxy unnecessarily. Also,
> incrementing nsproxy->count is an atomic operation (which is expensive than normal increment operation), so before
> doing it - it's better we make sure namespace related flags are set.
>
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> ---
>  kernel/nsproxy.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index afc0456..de36209 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -130,12 +130,12 @@ int copy_namespaces(unsigned long flags, struct task_struct *tsk)
>  	if (!old_ns)
>  		return 0;
>  
> -	get_nsproxy(old_ns);
> -
>  	if (!(flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC |
>  				CLONE_NEWPID | CLONE_NEWNET)))
>  		return 0;
>  
> +	get_nsproxy(old_ns);
> +
>  	if (!ns_capable(user_ns, CAP_SYS_ADMIN)) {
>  		err = -EPERM;
>  		goto out;
