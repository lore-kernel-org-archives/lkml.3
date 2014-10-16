Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaJPWBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 18:01:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPWBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 18:01:44 -0400
Date: Thu, 16 Oct 2014 23:58:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel/kmod: fix use-after-free of the
	sub_infostructure
Message-ID: <20141016215834.GA28864@redhat.com>
References: <20141016160042.7f898871@mschwide> <201410170157.AFH86961.FQtFHJVLOFSOOM@I-love.SAKURA.ne.jp> <20141016174209.GB18318@redhat.com> <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201410170630.EBH48400.FSOHVQJOFMLtFO@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Tetsuo Handa wrote:
>
> Ah, I see. Here is a draft of an updated patch.

Do you mean this part

	>  	sub_info->retval = retval;
	> +	/* wait_for_helper() will call umh_complete() if UMH_WAIT_PROC. */
	> +	if (wait != UMH_WAIT_PROC)
	> +		umh_complete(sub_info);
	> +	if (!retval)
	> +		return 0;
	>  	do_exit(0);
	>  }

?

Personally I agree, this looks a bit better to me. But this is cosmetic
and subjective, I leave this to Martin ;)

I also agree that the changelog could mention exec_mmap. Plus a comment
about UMH_NO_WAIT && sub_info->complete == NULL. So yes, perhaps v2 makes
sense if Martin agrees.

> By the way, it seems to me that nothing prevents
>
>         if (info->cleanup)
>                 (*info->cleanup)(info);
>
> from crashing when info->cleanup points to a function in a loadable kernel
> module and the loadable kernel module got unloaded before the worker thread
> calls call_usermodehelper_freeinfo().

Just don't do this? I mean, in this case the caller of call_usermodehelper()
is obviously buggy? Or I missed your point?

Oleg.

