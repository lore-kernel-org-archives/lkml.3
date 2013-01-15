Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab3AOSTL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:19:11 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45081 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab3AOSTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:19:09 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
References: <CALxABCaE3=XpGmgNJs1pre11aJ8T0pntVzf_mA6_OYNzis9nvQ@mail.gmail.com>
 <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com> <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 15 Jan 2013 10:18:45 -0800
X-Google-Sender-Auth: LwFjJ-F-RDh6VkBXxl7QtSDVW9Y
Message-ID: <CA+55aFy_7mng3fgKdYM_h3c1=etKhX5JqEvFVE23X8kNYJQkpw@mail.gmail.com>
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

On Tue, Jan 15, 2013 at 9:36 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> This kind of "let's randomly encourage people to write subtly buggy
> code that has magical timing dependencies, so that the developer won't
> likely even see it because he has fast disks etc" code is totally
> unacceptable. And this code was *designed* to be that kind of buggy.

Btw, we could *possibly* do this the other way around. Wait for all
async work by default, but then have a really hacky way to turn that
off for modules that explicitly don't want it, because they know they
can be loaded in async context, and they don't do any async work
themselves. Then we could make the IO schedulers set that flag ("I
know I'm loaded from async space, and I know I'm not myself doing any
async init")

Quite frankly, I'd still much rather prefer the automated approach -
or even better, just avoiding the "load modules in async context"
entirely. But at least the "I can put a huge comment about why I don't
want to be waited on" would be much more acceptable than the "I need
to explicitly tell the world that it needs to wait on me".

So Ming Lei's patch was "easily subtly buggy by mistake" (showing that
by the fact that it was indeed buggy), while the opposite model where
you have to explicitly ask people not to wait for you could still be
very buggy, but at least now it needs to explicitly do extra work in
order to be buggy.

So if an interface is fragile, it should aim to be fragile in the
right way - making the fragility explicit, so that people can grep for
it, and people can add comments to the particular code that marks it
fragile. The default behavior should be the robust one.

And if would be lovely to add a warning to the "people loaded a module
from async context" case, so that we'd *see* this.

Tejun, is there a good way for code to see "I'm running in async
context"? Then we could do something like

    WARN_ON_ONCE(wait && system_state == SYSTEM_RUNNING && in_async_thread());

in kernel/kmod.c (__request_module()). That should at least warn about
this whole issue happening.

                    Linus
