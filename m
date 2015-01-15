Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbbAOTgN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 14:36:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45628 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbbAOTgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 14:36:11 -0500
Date: Thu, 15 Jan 2015 20:34:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 06/11] x86,fpu: lazily skip fpu restore with eager
	fpu mode, too
Message-ID: <20150115193455.GE27332@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-7-git-send-email-riel@redhat.com> <20150114183606.GA16024@redhat.com> <54B72AA0.5020500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54B72AA0.5020500@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14, Rik van Riel wrote:
>
> On 01/14/2015 01:36 PM, Oleg Nesterov wrote:
>
> >> @@ -466,6 +462,10 @@ static inline void switch_fpu_finish(void)
> >>
> >> __thread_fpu_begin(tsk);
> >>
> >> +	/* The FPU registers already have this task's FPU state. */ +
> >> if (fpu_lazy_restore(tsk, raw_smp_processor_id())) +		return; +
> >
> > Now that this is called before return to user-mode, I am not sure
> > this is correct. Note that __kernel_fpu_begin() doesn't clear
> > fpu_owner_task if use_eager_fpu().
>
> However, __kernel_fpu_begin() does call __thread_clear_has_fpu(),
> which clears the per-cpu fpu_owner variable, which is also
> evaluated by fpu_lazy_restore(), so I think this is actually
> correct.

Sure, but only if __thread_has_fpu().

But please ignore. My comment was confusing, sorry. What I actually
tried to say is that this patch is another reason why (I think) we
should start with kernel_fpu_begin/end.

If nothing else:

	1. interrupted_kernel_fpu_idle() should not fail if
	   use_eager_fpu() && !__thread_has_fpu(), otherwise your
	   changes will introduce the performance regression.

	   And in fact I think that it should only fail if
	   kernel_fpu_begin() is already in progress.

	2. And in this case this_cpu_write(fpu_owner_task, NULL)
	   can't depend on use_eager_fpu().

	   And in fact I think it should not depend in any case,
	   this only adds more confusion.

Please look at the initial cleanups I sent.

Oleg.

