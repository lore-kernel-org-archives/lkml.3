Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061Ab3F1O4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:56:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab3F1O4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:56:38 -0400
Date: Fri, 28 Jun 2013 16:52:05 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrey Vagin <avagin@openvz.org>, Roland McGrath <roland@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pedro Alves <palves@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.10-rc7] Fix: kernel/ptrace.c: ptrace_peek_siginfo()
	missing __put_user() validation
Message-ID: <20130628145205.GA22344@redhat.com>
References: <20130628134946.GA19422@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130628134946.GA19422@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28, Mathieu Desnoyers wrote:
>
> This __put_user() could be used by unprivileged processes to write into
> kernel memory. The issue here is that even if copy_siginfo_to_user()
> fails, the error code is not checked before __put_user() is executed.
> Luckily, ptrace_peek_siginfo() has been added within the 3.10-rc cycle,
> so it has not hit a stable release yet.

Agreed, this looks like 3.10 material.

Acked-by: Oleg Nesterov <oleg@redhat.com>

> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Andrey Vagin <avagin@openvz.org>
> CC: Roland McGrath <roland@redhat.com>
> CC: Oleg Nesterov <oleg@redhat.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: David Howells <dhowells@redhat.com>
> CC: Dave Jones <davej@redhat.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Pedro Alves <palves@redhat.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  kernel/ptrace.c |   20 +++++++++++---------
>  1 file changed, 11 insertions(+), 9 deletions(-)
> 
> Index: linux/kernel/ptrace.c
> ===================================================================
> --- linux.orig/kernel/ptrace.c
> +++ linux/kernel/ptrace.c
> @@ -665,20 +665,22 @@ static int ptrace_peek_siginfo(struct ta
>  		if (unlikely(is_compat_task())) {
>  			compat_siginfo_t __user *uinfo = compat_ptr(data);
>  
> -			ret = copy_siginfo_to_user32(uinfo, &info);
> -			ret |= __put_user(info.si_code, &uinfo->si_code);
> +			if (copy_siginfo_to_user32(uinfo, &info) ||
> +			    __put_user(info.si_code, &uinfo->si_code)) {
> +				ret = -EFAULT;
> +				break;
> +			}
> +
>  		} else
>  #endif
>  		{
>  			siginfo_t __user *uinfo = (siginfo_t __user *) data;
>  
> -			ret = copy_siginfo_to_user(uinfo, &info);
> -			ret |= __put_user(info.si_code, &uinfo->si_code);
> -		}
> -
> -		if (ret) {
> -			ret = -EFAULT;
> -			break;
> +			if (copy_siginfo_to_user(uinfo, &info) ||
> +			    __put_user(info.si_code, &uinfo->si_code)) {
> +				ret = -EFAULT;
> +				break;
> +			}
>  		}
>  
>  		data += sizeof(siginfo_t);
> 
> -- 
> Mathieu Desnoyers
> EfficiOS Inc.
> http://www.efficios.com

