Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbaJPRkp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 13:40:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbaJPRko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 13:40:44 -0400
Date: Thu, 16 Oct 2014 19:37:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the sub_info
	structure
Message-ID: <20141016173733.GA18318@redhat.com>
References: <20141016160042.7f898871@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141016160042.7f898871@mschwide>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Martin Schwidefsky wrote:
>
> There is a use-after-free bug on the subprocess_info structure allocated
> by the user mode helper. In case do_execve() returns with an error
> ____call_usermodehelper() stores the error code to sub_info->retval,
> but sub_info can already have been freed.

Hmm, yes... do_execve() can fail after mm_release(). CLONE_VFORK doesn't
help in this case.

> @@ -242,13 +263,14 @@ static int ____call_usermodehelper(void *data)
>  	retval = do_execve(getname_kernel(sub_info->path),
>  			   (const char __user *const __user *)sub_info->argv,
>  			   (const char __user *const __user *)sub_info->envp);
> -	if (!retval)
> -		return 0;
> -
> -	/* Exec failed? */
> -fail:
> +out:
>  	sub_info->retval = retval;
> -	do_exit(0);
> +	if (wait != UMH_WAIT_PROC)
> +		/* For UMH_WAIT_PROC wait_for_helper calls umh_complete */
> +		umh_complete(sub_info);
> +	if (retval)
> +		do_exit(0);
> +	return 0;
>  }

OK... I am wondering if __call_usermodehelper() still needs CLONE_VFORK
with this patch.

> @@ -588,7 +580,7 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
>  		goto out;
>  	}
>  
> -	sub_info->complete = &done;
> +	sub_info->complete = (wait == UMH_NO_WAIT) ? NULL : &done;

This probably needs a comment, and the comment in umh_complete() should
be updated,

	- we own sub_info, the UMH_KILLABLE caller has gone away.
	+ we own sub_info, the UMH_KILLABLE caller has gone away
	+ or the caller used UMH_NO_WAIT.

The patch looks correct at first glance. I'll try to re-read it later
once again.

Thanks!

Oleg.

