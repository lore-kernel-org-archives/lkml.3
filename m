Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3AYXM5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:12:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164Ab3AYXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:12:53 -0500
Date: Fri, 25 Jan 2013 15:12:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Kent Overstreet <koverstreet@google.com>, Valdis.Kletnieks@vt.edu,
        bcrl@kvack.org, zab@zabbo.net, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] aio-use-cancellation-list-lazily-fix
Message-Id: <20130125151251.0c90bf4b.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBAhW7GXUYhem=j2OJtLA9Ru98rLvbU9bJ9iQJm2=CCwog@mail.gmail.com>
References: <20130124211850.GH26407@google.com>
	<1359063833-17174-1-git-send-email-koverstreet@google.com>
	<1359063833-17174-3-git-send-email-koverstreet@google.com>
	<CAJd=RBAhW7GXUYhem=j2OJtLA9Ru98rLvbU9bJ9iQJm2=CCwog@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 21:30:32 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Fri, Jan 25, 2013 at 5:43 AM, Kent Overstreet <koverstreet@google.com> wrote:
> > The cancellation changes were fubar - we can't cancel a kiocb if it
> > doesn't actually have a cancellation callback.
> >
> > The use of xchg() in aio_complete() was right - there we're marking the
> > kiocb as completed - but we need to use cmpxchg() in kiocb_cancel() - a
> > lock isn't sufficient since we're synchronizing with aio_complete()
> > which isn't taking any locks.
> >
> >  static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
> >                         struct io_event *res)
> >  {
> > -       kiocb_cancel_fn *cancel;
> > +       kiocb_cancel_fn *old, *cancel;
> >         int ret = -EINVAL;
> >
> > -       cancel = xchg(&kiocb->ki_cancel, KIOCB_CANCELLED);
> > -       if (!cancel || cancel == KIOCB_CANCELLED)
> > -               return ret;
> > +       /*
> > +        * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
> > +        * actually has a cancel function, hence the cmpxchg()
> > +        */
> > +
> > +       cancel = ACCESS_ONCE(kiocb->ki_cancel);
> > +       do {
> > +               if (!cancel || cancel == KIOCB_CANCELLED)
> > +                       return ret;
> > +
> > +               BUG();
> 
> Hmm, what is trapped?
> 
> > +               old = cancel;
> > +               cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
> > +       } while (cancel != old);

erk, I missed that.  What earthly sense is there in putting a BUG() in
that place.

I think I'll delete it and pretend I never saw it :(


