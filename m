Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3CUAPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 20:15:53 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:50254 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3CUAPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 20:15:52 -0400
Date: Wed, 20 Mar 2013 17:15:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>, Andrew Collins <bsderandrew@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.0.70
Message-ID: <20130321001550.GB27981@kroah.com>
References: <CAKTPYJQeCW2fGy3bb6G2uxeQN2WYgeA63_7Lwt9ytpcwZwrnQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKTPYJQeCW2fGy3bb6G2uxeQN2WYgeA63_7Lwt9ytpcwZwrnQA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 04:04:19PM -0600, Andrew Collins wrote:
> Kees Cook (1):
>       signal: always clear sa_restorer on execve
> 
> This commit seems to cause the following build breakage on MIPS in 3.0.70:
> 
> kernel/signal.c: In function 'flush_signal_handlers':
> kernel/signal.c:441:9: error: 'struct sigaction' has no member named
> 'sa_restorer'
> make[3]: *** [kernel/signal.o] Error 1
> make[2]: *** [kernel] Error 2
> make[2]: *** Waiting for unfinished jobs....
> 
> I'm testing with a variety of additional patches applied and it's a
> bit difficult to test vanilla, but this looks unrelated to my local
> patches.  Looks like MIPS defines SA_RESTORER but doesn't have a
> sa_restorer in sigaction so:
> 
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -437,6 +437,9 @@ flush_signal_handlers(struct task_struct *t, int
> force_default)
>                 if (force_default || ka->sa.sa_handler != SIG_IGN)
>                         ka->sa.sa_handler = SIG_DFL;
>                 ka->sa.sa_flags = 0;
> +#ifdef SA_RESTORER
> +               ka->sa.sa_restorer = NULL;
> +#endif
>                 sigemptyset(&ka->sa.sa_mask);
>                 ka++;
>         }
> 
> goes kaboom.

Kees, I'm getting a number of bug reports that this patch breaks MIPS on
all of the recent stable kernel releases (3.0, 3.4, 3.8).

Any hints on a fix?

thanks,

greg k-h
