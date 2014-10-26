Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaJZAUV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 20:20:21 -0400
Received: from mail-yh0-f52.google.com ([209.85.213.52]:45865 "EHLO
	mail-yh0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621AbaJZAUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 20:20:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1410252047570.5308@nanos>
References: <1414092159-17697-1-git-send-email-bsilver16384@gmail.com> <alpine.DEB.2.11.1410252047570.5308@nanos>
From: Brian Silverman <bsilver16384@gmail.com>
Date: Sat, 25 Oct 2014 20:19:48 -0400
Message-ID: <CAP01z6LmQfacDzrHmbW=hBGjn35qhMcNTTp8XhdM3DDnhoX9Xw@mail.gmail.com>
Subject: Re: [PATCH] futex: fix a race condition between REQUEUE_PI and task death
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Austin Schuh <austin.linux@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Darren Hart <darren@dvhart.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2014, Thomas Gleixner wrote:

> > pi_state_free and exit_pi_state_list both clean up futex_pi_state's.
> > exit_pi_state_list takes the hb lock first, and most callers of
> > pi_state_free do too. requeue_pi didn't, which causes lots of problems.
>
> "causes lots of problems" is not really a good explanation of the root
> cause. That wants a proper description of the race, i.e.
>
> CPU 0              CPU 1
> ...                ....
>
> I'm surely someone who is familiar with that code, but it took me
> quite some time to understand whats going on. The casual reader will
> just go into brain spiral mode and give up.

Thinking about it again, I'm no longer so sure that exit_pi_state_list is the
only place that it can race against. However, I did catch that one with a
particularly lucky crashdump, so I know it _can_ happen there. Is just
giving an example for that good?

> >  static void free_pi_state(struct futex_pi_state *pi_state)
>
> > @@ -1558,6 +1552,14 @@ retry_private:
> >               ret = get_futex_value_locked(&curval, uaddr1);
> >
> >               if (unlikely(ret)) {
> > +                     if (flags & FLAGS_SHARED && pi_state != NULL) {
>
> Why is this dependend on "flags & FLAGS_SHARED"? The shared/private
> property has nothing to do with that at all, but I might be missing
> something.

Nothing... Good catch. It was a bad rebase.

Thanks,

Brian
