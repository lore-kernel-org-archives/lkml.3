Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755169Ab3ARDSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 22:18:49 -0500
Received: from mail-vc0-f175.google.com ([209.85.220.175]:38456 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3ARDSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 22:18:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130118030407.GK16568@mtj.dyndns.org>
References: <20130116032502.GN2668@htj.dyndns.org> <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org> <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org> <CA+55aFzdf44QOZn4KS6tT09COFsmCg80sTah1XpeoErJxAzbRQ@mail.gmail.com>
 <20130118012503.GH16568@mtj.dyndns.org> <CA+55aFyCihvZqOo=83UwWq3AgJEfVqpNjsY2iCFOEm8o6Un-YA@mail.gmail.com>
 <20130118025936.GJ16568@mtj.dyndns.org> <20130118030407.GK16568@mtj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Jan 2013 19:18:26 -0800
X-Google-Sender-Auth: LQwVECUPInZqadVPYi4Xs5icp30
Message-ID: <CA+55aFwAwX_o6ocGhd1WwUwxfOnh+S6aKeZdEpeeHVAnBm4uVQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] workqueue, async: implement work/async_current_func()
To: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2013 at 7:04 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Another thing is that it seems like having introspection type
> interface often lead to abuses - work_pending(), work_busy() both
> ended up bringing more unnecessary dependencies and subtle bugginess
> on internal details than actual benefits.  Querying %current is much
> less likely to be harmful in itself but I'm afraid it might encourage
> its users to develop something crazy on top.  It might be a good idea
> to make it only available to async.

I'm not sure I understand what you mean? Do you mean trying to limit
work_current_func() to only be accessible to the async code? You'd
have to make some kind of private header file under kernel/ for that,
but I guess that would work fine. We already do something similar
inside filesystems etc, where they have their own local headers.

I still don't really see what other data the async code could possibly
ever want than the "is this an async thread" I guess if you want to
keep all these things private to their own C files with no leaving of
the structure definitions (even within just a private kernel/worker.h
file or something) you could make the interface be one like

 - kernel/workqueue.c:

      int current_uses_workfn(work_func_t match)
      {
         if (current->flags & PF_WQ_WORKER) {
            struct worker *worker = kthread_data(current);
            return worker && match == worker->current_func;
         }
         return 0;
      }

 - kernel/async.c:

      int current_is_async(void)
      {
         return current_uses_workfn(async_run_entry_fn);
      }

but quite frankly, we've generally tried to avoid those kinds of silly
wrappers just because it's very wasteful to do two function calls just
to hide some detail like this. The code generation is atrocious,
jumping around for no good reason just increases cache pressure etc.

Yes, yes, some globally optimizing compiler could sort it all out, but
I'd personally be inclined to just move all the structure definitions
into kernel/worker.h, and make the code be inline functions. The only
actual current *user* would also be in the kernel/ subdirectory, and
we don't know if we'd ever want to really expand it past there.

Hmm?

             Linus
