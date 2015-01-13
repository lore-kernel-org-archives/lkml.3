Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbbAMQUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:20:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55781 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197AbbAMQUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:20:37 -0500
Date: Tue, 13 Jan 2015 17:19:38 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 05/11] x86,fpu: ensure FPU state is reloaded from
	memory if task is traced
Message-ID: <20150113161938.GA24447@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-6-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-6-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, riel@redhat.com wrote:
>
> @@ -412,8 +412,14 @@ static inline void switch_fpu_prepare(struct task_struct *old, struct task_struc
>  	bool preload = tsk_used_math(new) && (use_eager_fpu() ||
>  					     new->thread.fpu_counter > 5);
>  	if (__thread_has_fpu(old)) {
> -		if (!__save_init_fpu(old))
> +		/*
> +		 * Make sure the FPU state is restored from memory next time,
> +		 * if the task has an FPU exception pending, or the task's in
> +		 * memory FPU state could be changed by a debugger.
> +		 */
> +		if (!__save_init_fpu(old) || task_is_stopped_or_traced(old))
>  			cpu = ~0;

Well, if debugger wants to change FPU state, it should call init_fpu()
which resets .last_cpu ?

Plus "is_stopped" is not needed, ptracer no longer can do STOPPED -> TRACED
transition.

Oleg.

