Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3K0DYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 22:24:24 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:59515 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3K0DYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 22:24:22 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk,
        luto@amacapital.net, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <2547094.3YTvOEEdct@daeseok-laptop>
Date: Tue, 26 Nov 2013 19:24:11 -0800
In-Reply-To: <2547094.3YTvOEEdct@daeseok-laptop> (Daeseok Youn's message of
	"Wed, 27 Nov 2013 12:12:13 +0900")
Message-ID: <87y54attlw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18GmLQdpSKxh3asL6viFDCyBLvopqlCoUg=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0094]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daeseok Youn <daeseok.youn@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] kernel/fork.c : remove local 'oldmm' and retval
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daeseok Youn <daeseok.youn@gmail.com> writes:

> From cec2f201f0dc99a33a58d9d1e0452140bb0993a1 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@lge.com>
> Date: Wed, 27 Nov 2013 09:54:41 +0900
> Subject: [PATCH] kernel/fork.c : remove local 'oldmm' and retval
>
>  Local oldmm is used only for increaing mm_users field
>  in current->mm. When clone_flags have a CLONE_VM flag,
>  current->mm is assigning to local 'mm'.
>  Local retval is used only for returning -ENOMEM value.
>  When dup_mm() is failed, just return -ENOMEM.

You are making the generated code worse, and the source less
comprehensible.

You are adding additional exit points making it harder to analyze the
function.

You are introducing races and expense by not caching current->mm in
oldmm.

This looks like code churn for no good reason, and that will result in
worse code.

ick.

Eric

>  Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>  kernel/fork.c |   16 +++++-----------
>  1 file changed, 5 insertions(+), 11 deletions(-)
>
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 728d5be..022a0af 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -857,8 +857,7 @@ fail_nocontext:
>  
>  static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
>  {
> -	struct mm_struct *mm, *oldmm;
> -	int retval;
> +	struct mm_struct *mm;
>  
>  	tsk->min_flt = tsk->maj_flt = 0;
>  	tsk->nvcsw = tsk->nivcsw = 0;
> @@ -874,28 +873,23 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
>  	 *
>  	 * We need to steal a active VM for that..
>  	 */
> -	oldmm = current->mm;
> -	if (!oldmm)
> +	if (!current->mm)
>  		return 0;
>  
>  	if (clone_flags & CLONE_VM) {
> -		atomic_inc(&oldmm->mm_users);
> -		mm = oldmm;
> +		mm = current->mm;
> +		atomic_inc(&mm->mm_users);
>  		goto good_mm;
>  	}
>  
> -	retval = -ENOMEM;
>  	mm = dup_mm(tsk);
>  	if (!mm)
> -		goto fail_nomem;
> +		return -ENOMEM;
>  
>  good_mm:
>  	tsk->mm = mm;
>  	tsk->active_mm = mm;
>  	return 0;
> -
> -fail_nomem:
> -	return retval;
>  }
>  
>  static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
