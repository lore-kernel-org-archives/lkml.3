Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244Ab3INQLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 12:11:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29749 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab3INQLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 12:11:30 -0400
Date: Sat, 14 Sep 2013 18:05:15 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Make kthread_create() killable.
Message-ID: <20130914160515.GA8627@redhat.com>
References: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201309132318.HEC05218.OtVOFOFMLJHFQS@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lkml.

On 09/13, Tetsuo Handa wrote:
>
> This patch makes kthread_create() killable,

Probably makes sense...

> @@ -255,36 +266,59 @@ struct task_struct *kthread_create_on_node(int (*threadfn)(void *data),
>  					   const char namefmt[],
>  					   ...)
>  {
> -	struct kthread_create_info create;
> -
> -	create.threadfn = threadfn;
> -	create.data = data;
> -	create.node = node;
> -	init_completion(&create.done);
> +	struct task_struct *task;
> +	struct kthread_create_info *create = kmalloc(sizeof(*create),
> +						     GFP_KERNEL);
> +
> +	if (!create)
> +		return ERR_PTR(-ENOMEM);
> +	create->threadfn = threadfn;
> +	create->data = data;
> +	create->node = node;
> +	create->owner = (void *) 1;
> +	init_completion(&create->done);
>  
>  	spin_lock(&kthread_create_lock);
> -	list_add_tail(&create.list, &kthread_create_list);
> +	list_add_tail(&create->list, &kthread_create_list);
>  	spin_unlock(&kthread_create_lock);
>  
>  	wake_up_process(kthreadd_task);
> -	wait_for_completion(&create.done);
> -
> -	if (!IS_ERR(create.result)) {
> +	/*
> +	 * Wait for completion in killable state, for I might be chosen by
> +	 * the OOM killer while kthreadd is trying to allocate memory for
> +	 * new kernel thread.
> +	 */
> +	if (unlikely(wait_for_completion_killable(&create->done))) {
> +		/*
> +		 * If I was SIGKILLed before kthreadd (or new kernel thread)
> +		 * calls complete(), leave the cleanup of this structure to
> +		 * that thread.
> +		 */
> +		if (xchg(&create->owner, NULL))
> +			return ERR_PTR(-ENOMEM);

I am wondering if this can be simplified...

At least you can move create->done from kthread_create_info to the
stack, and turn create->owner into the pointer to that completion.

Oleg.

