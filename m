Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab3CKTa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab3CKTa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:30:27 -0400
Date: Mon, 11 Mar 2013 20:28:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Emese Revfy <re.emese@gmail.com>, PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH] signal: always clear sa_restorer on execve
Message-ID: <20130311192805.GA19428@redhat.com>
References: <20130311191156.GA17763@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311191156.GA17763@www.outflux.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11, Kees Cook wrote:
>
> When the new signal handlers are set up for a fork, the location of
> sa_restorer is not cleared, leaking a parent process's address space
> location to children. This allows for a potential bypass of the parent's
> ASLR by examining the sa_restorer value returned when calling sigaction().

I don't understand.

fork() should not change restorer/etc, and the child has the same address
space anyway. There is no any leak and the patch can't make any difference
in this case because flush_signal_handlers() is not called by fork().

> @@ -485,6 +485,9 @@ flush_signal_handlers(struct task_struct *t, int force_default)
>  		if (force_default || ka->sa.sa_handler != SIG_IGN)
>  			ka->sa.sa_handler = SIG_DFL;
>  		ka->sa.sa_flags = 0;
> +#ifdef __ARCH_HAS_SA_RESTORER
> +		ka->sa.sa_restorer = NULL;
> +#endif

However, exec sets SIG_DFL but keeps ->sa_restorer, so probably this
patch makes sense anyway.

Oleg.

