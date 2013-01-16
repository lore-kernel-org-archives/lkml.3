Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364Ab3APEYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 23:24:50 -0500
Received: from ozlabs.org ([203.10.76.45]:45874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757347Ab3APEYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 23:24:48 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] module, async: async_synchronize_full() on module init iff async is used
In-Reply-To: <20130116025251.GM2668@htj.dyndns.org>
References: <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com> <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com> <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com> <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com> <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com> <20130115183204.GE2668@htj.dyndns.org> <CA+55aFzZ1NJz34r99N7+mU4CN5Ju4QpHrDoWv5Kbd5-Z4QzgaA@mail.gmail.com> <20130115235043.GJ2668@htj.dyndns.org> <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com> <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com> <20130116025251.GM2668@htj.dyndns.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 16 Jan 2013 14:54:11 +1030
Message-ID: <87vcaxycus.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3058,8 +3064,25 @@ static int do_init_module(struct module
>  	blocking_notifier_call_chain(&module_notify_list,
>  				     MODULE_STATE_LIVE, mod);
>  
> -	/* We need to finish all async code before the module init sequence is done */
> -	async_synchronize_full();

Linus put async_synchronize_full() here as a fix but beware: you can
start using the module before this call.  Normally the potential caller
is the one requesting the module load so it works, but if we get more
async stuff we may land in that hole.

Changing every caller of any async-initializing service is not going to
be pretty, but maybe put an async_cookie_t in struct module for
module_init to use, and sync it in try_module_get()?  Which would now
need a can_sleep flag... but the result would be more async.

Cheers,
Rusty.
