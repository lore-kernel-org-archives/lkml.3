Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581Ab3A1Rhj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 12:37:39 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:63382 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756937Ab3A1Rhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 12:37:37 -0500
Date: Mon, 28 Jan 2013 09:37:33 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hillf Danton <dhillf@gmail.com>, Valdis.Kletnieks@vt.edu, bcrl@kvack.org,
        zab@zabbo.net, linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/3] aio-use-cancellation-list-lazily-fix
Message-ID: <20130128173733.GV26407@google.com>
References: <20130124211850.GH26407@google.com>
 <1359063833-17174-1-git-send-email-koverstreet@google.com>
 <1359063833-17174-3-git-send-email-koverstreet@google.com>
 <CAJd=RBAhW7GXUYhem=j2OJtLA9Ru98rLvbU9bJ9iQJm2=CCwog@mail.gmail.com>
 <20130125151251.0c90bf4b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130125151251.0c90bf4b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 25, 2013 at 03:12:51PM -0800, Andrew Morton wrote:
> On Fri, 25 Jan 2013 21:30:32 +0800
> Hillf Danton <dhillf@gmail.com> wrote:
> 
> > On Fri, Jan 25, 2013 at 5:43 AM, Kent Overstreet <koverstreet@google.com> wrote:
> > > The cancellation changes were fubar - we can't cancel a kiocb if it
> > > doesn't actually have a cancellation callback.
> > >
> > > The use of xchg() in aio_complete() was right - there we're marking the
> > > kiocb as completed - but we need to use cmpxchg() in kiocb_cancel() - a
> > > lock isn't sufficient since we're synchronizing with aio_complete()
> > > which isn't taking any locks.
> > >
> > >  static int kiocb_cancel(struct kioctx *ctx, struct kiocb *kiocb,
> > >                         struct io_event *res)
> > >  {
> > > -       kiocb_cancel_fn *cancel;
> > > +       kiocb_cancel_fn *old, *cancel;
> > >         int ret = -EINVAL;
> > >
> > > -       cancel = xchg(&kiocb->ki_cancel, KIOCB_CANCELLED);
> > > -       if (!cancel || cancel == KIOCB_CANCELLED)
> > > -               return ret;
> > > +       /*
> > > +        * Don't want to set kiocb->ki_cancel = KIOCB_CANCELLED unless it
> > > +        * actually has a cancel function, hence the cmpxchg()
> > > +        */
> > > +
> > > +       cancel = ACCESS_ONCE(kiocb->ki_cancel);
> > > +       do {
> > > +               if (!cancel || cancel == KIOCB_CANCELLED)
> > > +                       return ret;
> > > +
> > > +               BUG();
> > 
> > Hmm, what is trapped?
> > 
> > > +               old = cancel;
> > > +               cancel = cmpxchg(&kiocb->ki_cancel, old, KIOCB_CANCELLED);
> > > +       } while (cancel != old);
> 
> erk, I missed that.  What earthly sense is there in putting a BUG() in
> that place.
> 
> I think I'll delete it and pretend I never saw it :(

Argh. Yeah, sorry about that. Put that in there when I was trying to
track down the other bugs :(
