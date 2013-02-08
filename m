Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947165Ab3BHVLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 16:11:51 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:53144 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947122Ab3BHVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 16:11:49 -0500
Date: Fri, 8 Feb 2013 13:11:44 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@zabbo.net>
Cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-fsdevel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: Improving AIO cancellation
Message-ID: <20130208211144.GF27179@google.com>
References: <CAOMFOmXiEUnqkoQg6bA4N3jg5ERMKoydOdmn7djkpFyfZk19cg@mail.gmail.com>
 <20130208173811.GW14246@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208173811.GW14246@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 09:38:11AM -0800, Zach Brown wrote:
> > The draft implementation will look like this. struct bio should have
> > some way to get current status of kiocb that generated bio. So we add
> > a pointer to bool flag.
> > 
> > struct bio {
> >   bool *cancelled;
> > }
> > 
> > in async DIO codepath this pointer will be initialized with bool at
> > "struct kiocb"
> >   bio->cancelled = &kiocb->cancelled;
> 
> Hmm.  I suppose.  It sure looks disgusting, but the iocb has forgotten
> all of the dio state and bios that lead up to the operation once
> submission has completed.  It's easy enough to match the lifetime rules
> of this reference with end_io's using the iocb.

That's part of it (w.r.t. the exact location of the cancelled flag), but
the idea also isn't for this to be specific to kiocbs or anything like
that.

The problem, as you alluded to, is once a bio passes
generic_make_request() the upper layer has no idea what the block layer
is doing with it. If it's a stacking block device - or even if it's just
getting bounced - the first thing that happens to the bio is it gets
cloned.

So, adding a mechanism for the upper layer to chase down those bios and
whatever other state the lower layers created would be gross. Fuck that.
And, you know my thoughts on callbacks; Ted pointed out some reasons we
are probably going to need cancellation callbacks eventually but I
personally _don't_ want this to get designed around callbacks.

But if we just add this layer of indirection, when a bio is cloned we
can copy the pointer too and cancellation magically Just Works.

For md writes and probably some other things we won't be able to just
blindly copy the pointer as that'd fuck up md's parity stuff, but md
could still check the flag itself if it was worth the trouble.



> 
> This method also lets one cancelled iocb flag many submitted bios as
> cancelled, so that's nice.
> 
> > So to cancel kiocb we do
> > kiocb->cancelled = true;
> > and all bio created from the request will not be send to device anymore.
> 
> (With lots of comments to let us know that it being racey is fine.)

Yeah. We should be really explicit about what this flag means; it
_doesn't_ mean "this bio has been cancelled", it means "please try to
cancel this bio".

We don't know if the bio was succesfully cancelled until the bio is
completed (and this doesn't change anything about how bio completion
works) - if it was cancelled, the bi_end_io callback will get
-ECANCELLED or something.

This is very different from the existing AIO cancellation; KIF_CANCEL
means "this kiocb _has been cancelled_". (sort of, I was just rereading
that code and I'm convinced it's buggy).

> > If the proposal is fine then I start implementing it.
> 
> For a teeny hack like this the best proposal is a working prototype
> patch.  Don't wait for acks just dive in.

Yeah, and I keep claiming I'm going to implement the AIO bits of this
(I keep getting distracted by other things like taking a flamethrower to
the dio code).

Note that the semantics of this doesn't really match up with
io_cancel(). That's not the end of the world, we can paper over that in
the aio code without too much grossness (or at least it'll be localized
grossness).

IMO though, io_cancel() is dumb and we want something new. It's
synchronous - and why anyone ever thought cancellation for
_asynchronous_ io should be synchronous I don't know.

Anyways, if io_cancel() is going to succeed it has to block until the io
has been cancelled and it's got a completion - the completion isn't
returned via io_getevents().

This makes _no sense_, and means an application that is making use of
this probably is going to need a thread pool just to do cancellation.

What we want is a new io_cancel_sane() syscall that doesn't return
anything, and only marks the iocb as "cancellation pending". The
completion would still get returned via io_getevents(), and userspace
would find out if it was cancelled or not then.
