Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3AORhU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:37:20 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:38238 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855Ab3AORhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:37:18 -0500
MIME-Version: 1.0
In-Reply-To: <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com> <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jan 2013 09:36:57 -0800
X-Google-Sender-Auth: VM1i1V8-e6wuo-76j3o9FX9CI1o
Message-ID: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
Subject: Re: USB device cannot be reconnected and khubd "blocked for more than
 120 seconds"
To: Ming Lei <ming.lei@canonical.com>, Tejun Heo <tj@kernel.org>
Cc: Alex Riesen <raa.lkml@gmail.com>, Alan Stern <stern@rowland.harvard.edu>,
        Jens Axboe <axboe@kernel.dk>, USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Added Tejun to the discussion, since he's the async go-to-guy ]

On Mon, Jan 14, 2013 at 10:23 PM, Ming Lei <ming.lei@canonical.com> wrote:
>
> But I have another idea to address the problem, and let module code call
> async_synchronize_full() only if the module requires that explicitly, so how
> about the below draft patch?

No way.

This kind of "let's just let drivers tell us when they used async
helpers" is basically *asking* for buggy code. In fact, just to prove
how bad it is, YOU SCREWED IT UP YOURSELF.

Because it's not just sd.c that uses async_schedule(), and would need
the async synchronize. It's floppy.c, it's generic scsi scanning (so
scsi tapes etc), and it's libata-core.c.

This kind of "let's randomly encourage people to write subtly buggy
code that has magical timing dependencies, so that the developer won't
likely even see it because he has fast disks etc" code is totally
unacceptable. And this code was *designed* to be that kind of buggy.

No, if we set a flag like this, then it needs to be set
*automatically*, so that a module cannot screw this up by mistake.

It could be as simple as having a per-thread flag that gets set by the
__async_schedule() function, and gets cleared by fork. Then the module
code could do something like

   /* before calling the module ->init function */
   current->used_async = 0;
   ...
   if (current->used_async)
      async_synchronize_full();

or whatever.

Tejun, comments? You can see the whole thread on lkml, but the basic
problem is that the module loading doing the unconditional
async_synchronize_full() has caused problems, because we have

 - load module A
   - module A does per-controller async discovery of its devices (eg
scsi or ata probing)
   - in the async thread, it initializes somethign that needs another
module B (in this case the default IO scheduler module)
      - modprobe for B loads the IO scheduler module successfully
          at the end of the module load, it does
async_synchronize_full() to make sure load_module won't return before
the module is ready
          *DEADLOCK*, because the async_synchronize_full() thing
actually waits for not the module B async code (it didn't have any),
but for the module *A* async code, which is waiting for module B to
finish.

Now, I'll happily argue that we shouldn't have this kind of "load
modules from random context" behavior in the kernel, and I think the
block layer is to blame for doing the IO scheduler load at an insane
time. So "don't do that then" would be the best solution. Sadly, we
don't even have a good way to notice that we're doing it, so "hacky
workaround that at least doesn't require driver authors to care" is
likely the second-best workaround.

But the "hacky workaround" absolutely needs to be *automatic*. Because
the "driver writers need to get this subtle untestable thing right" is
*not* acceptable. That's the patch that Ming Lei did, and I refuse to
have that kind of fragile crap in the kernel.

                          Linus
