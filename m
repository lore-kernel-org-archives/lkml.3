Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754177Ab3K0Gfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:35:32 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:17540 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831Ab3K0Gf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:35:28 -0500
X-IronPort-AV: E=Sophos;i="4.93,780,1378850400"; 
   d="scan'208";a="45632615"
Date: Wed, 27 Nov 2013 07:35:06 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Daeseok Youn <daeseok.youn@gmail.com>, akpm@linux-foundation.org,
        oleg@redhat.com, viro@zeniv.linux.org.uk, luto@amacapital.net,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] kernel/fork.c : remove local 'oldmm' and retval
In-Reply-To: <87y54attlw.fsf@xmission.com>
Message-ID: <alpine.DEB.2.02.1311270730080.2026@localhost6.localdomain6>
References: <2547094.3YTvOEEdct@daeseok-laptop> <87y54attlw.fsf@xmission.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013, Eric W. Biederman wrote:

> Daeseok Youn <daeseok.youn@gmail.com> writes:
> 
> > From cec2f201f0dc99a33a58d9d1e0452140bb0993a1 Mon Sep 17 00:00:00 2001
> > From: Daeseok Youn <daeseok.youn@lge.com>
> > Date: Wed, 27 Nov 2013 09:54:41 +0900
> > Subject: [PATCH] kernel/fork.c : remove local 'oldmm' and retval
> >
> >  Local oldmm is used only for increaing mm_users field
> >  in current->mm. When clone_flags have a CLONE_VM flag,
> >  current->mm is assigning to local 'mm'.
> >  Local retval is used only for returning -ENOMEM value.
> >  When dup_mm() is failed, just return -ENOMEM.
> 
> You are making the generated code worse, and the source less
> comprehensible.
> 
> You are adding additional exit points making it harder to analyze the
> function.

There is neverthless a lot of code that just does return XXX; if there is 
nothng else to do in the error-handling code.

Here I find at least the retval = -ENOMEM; at top level confusing.  
Already, the previous if+goto that is not error handling code is a little 
bit of a surprise, but the retval = -ENOMEM; in the main flow of execution 
suggests that for some reason the error handling code is being put after 
the if, for some reason, which does sometimes happen too.  But then it 
turns out that this is not error handling code.  It may still succeed or 
fail.  So it could be clearer to put the retval = -ENOMEM; inside the if 
just before the goto, if the goto is what is wanted.

On the other hand for kernel code maybe it is better not to touch what 
work, so it is more of a general esthetic comment.

julia


> You are introducing races and expense by not caching current->mm in
> oldmm.
> 
> This looks like code churn for no good reason, and that will result in
> worse code.
> 
> ick.
> 
> Eric
> 
> >  Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> > ---
> >  kernel/fork.c |   16 +++++-----------
> >  1 file changed, 5 insertions(+), 11 deletions(-)
> >
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 728d5be..022a0af 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -857,8 +857,7 @@ fail_nocontext:
> >  
> >  static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
> >  {
> > -	struct mm_struct *mm, *oldmm;
> > -	int retval;
> > +	struct mm_struct *mm;
> >  
> >  	tsk->min_flt = tsk->maj_flt = 0;
> >  	tsk->nvcsw = tsk->nivcsw = 0;
> > @@ -874,28 +873,23 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
> >  	 *
> >  	 * We need to steal a active VM for that..
> >  	 */
> > -	oldmm = current->mm;
> > -	if (!oldmm)
> > +	if (!current->mm)
> >  		return 0;
> >  
> >  	if (clone_flags & CLONE_VM) {
> > -		atomic_inc(&oldmm->mm_users);
> > -		mm = oldmm;
> > +		mm = current->mm;
> > +		atomic_inc(&mm->mm_users);
> >  		goto good_mm;
> >  	}
> >  
> > -	retval = -ENOMEM;
> >  	mm = dup_mm(tsk);
> >  	if (!mm)
> > -		goto fail_nomem;
> > +		return -ENOMEM;
> >  
> >  good_mm:
> >  	tsk->mm = mm;
> >  	tsk->active_mm = mm;
> >  	return 0;
> > -
> > -fail_nomem:
> > -	return retval;
> >  }
> >  
> >  static int copy_fs(unsigned long clone_flags, struct task_struct *tsk)
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
