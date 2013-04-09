Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935976Ab3DIVPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 17:15:16 -0400
Received: from mail-da0-f41.google.com ([209.85.210.41]:47919 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762666Ab3DIVPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 17:15:14 -0400
Date: Tue, 9 Apr 2013 14:15:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Benjamin LaHaise <bcrl@kvack.org>, Josh Boyer <jwboyer@redhat.com>,
        Zach Brown <zab@redhat.com>
Subject: Re: [PATCH 33/33] aio: fix kioctx not being freed after cancellation
 at exit time
Message-ID: <20130409211510.GL15749@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-34-git-send-email-koverstreet@google.com>
 <20130402213550.GE5703@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402213550.GE5703@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 05:35:50PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2013 at 09:35:54AM -0700, Kent Overstreet wrote:
> > From: Benjamin LaHaise <bcrl@kvack.org>
> > 
> > The recent changes overhauling fs/aio.c introduced a bug that results in the
> > kioctx not being freed when outstanding kiocbs are cancelled at exit_aio()
> > time.  Specifically, a kiocb that is cancelled has its completion events
> > discarded by batch_complete_aio(), which then fails to wake up the process
> > stuck in free_ioctx().  Fix this by removing the event suppression in
> > batch_complete_aio() and modify the wait_event() condition in free_ioctx()
> > appropriately.
> 
> Once you remove the event suppression, then it means that every single
> cancelled AIO will result in ki_ctx->reqs_available getting double
> incremented, right? 

I'm not sure where you're seeing the double increment...

Previously, when we were supressing the events we needed to increment
reqs_available to account for the fact that we wouldn't be doing a
put_reqs_available() when reaping the io_event.

I think the commit description could've been a bit better - this patch
is changing the behaviour of cancellation, and it makes more sense in
context with some of the other cancellation patches - instead of
returning the io_event via io_cancel(), we're returning it via
io_getevents() as it would be normally.

So all removing the event supression is doing is causing the io_events
from cancelled kiocbs to be handled just like any other io_event.

> But reqs_available gets used in more places than
> just free_ioctx().  It also gets used (for example) by
> get_reqs_available(), which in turn gets used by aio_get_req() to
> decide whether or not it's safe to allocate another aio_request.
> Since reqs_available is getting double allocated, won't we end up
> allowing more AIO requests to be issued --- more than we would have
> room in the ring?
> 
> Am I missing something?

You're right about how reqs_available is used, but unless I'm missing
something the accounting is correct. Maybe we should go over it
together?
