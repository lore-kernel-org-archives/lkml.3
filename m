Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3DWPYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:24:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289Ab3DWPYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:24:38 -0400
Date: Tue, 23 Apr 2013 17:21:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get/set signal-blocked mask (v2)
Message-ID: <20130423152143.GA30125@redhat.com>
References: <1366729843-24148-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366729843-24148-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Andrey Vagin wrote:
>
> @@ -841,6 +841,48 @@ int ptrace_request(struct task_struct *child, long request,
>  			ret = ptrace_setsiginfo(child, &siginfo);
>  		break;
>  
> +	case PTRACE_GETSIGMASK:
> +		if (addr != sizeof(sigset_t)) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		if (copy_to_user(datavp, &child->blocked, sizeof(sigset_t)))
> +			ret = -EFAULT;

Yes, we can do this lockless. Only the task itself (or the debugger with
this patch) can change ->blocked, and the tracee can't run.

> +	case PTRACE_SETSIGMASK:
> +	{
> +		sigset_t new_set;
> +
> +		if (addr != sizeof(sigset_t)) {
> +			ret = -EINVAL;
> +			break;
> +		}
> +
> +		if (copy_from_user(&new_set, datavp, sizeof(sigset_t))) {
> +			ret = -EFAULT;
> +			break;
> +		}
> +
> +		sigdelsetmask(&new_set, sigmask(SIGKILL)|sigmask(SIGSTOP));
> +
> +		/*
> +		 * Every thread does recalc_sigpending() after resume, so
> +		 * retarget_shared_pending() and recalc_sigpending() are not
> +		 * called here.
> +		 */
> +		spin_lock_irq(&child->sighand->siglock);
> +		child->blocked = new_set;
> +		spin_unlock_irq(&child->sighand->siglock);
> +
> +		ret = 0;
> +		break;
> +	}

And this looks fine too.

Personally I am not sure we need to check addr == sizeof(), debugger
should know what it does... But I won't argue.

Oleg.

