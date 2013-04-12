Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3DLW3E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:29:04 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34898 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab3DLW3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:29:02 -0400
Date: Fri, 12 Apr 2013 15:28:56 -0700
From: Kent Overstreet <koverstreet@google.com>
To: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, lsf-pc@lists.linux-foundation.org
Cc: akpm@linux-foundation.org, Zach Brown <zab@redhat.com>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: New AIO API
Message-ID: <20130412222856.GB31761@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, awhile back I posted about an extensible AIO attributes mechanism
I'd been cooking up: http://article.gmane.org/gmane.linux.kernel/1367969

Since then, more uses for the thing have been popping up, but I ran into
a roadblock - with the existing AIO api, return values for the
attributes were going to be, at best, considerably uglier than I
anticipated.

Some background: some attributes we'd like to implement need to be able
to return values with the io_event at completion time. Many of the
examples I know of are more or less tracing - returning how long the IO
took, whether it was a cache hit or miss (bcache, perhaps page cache
when buffered AIO is supported), etc.

Additionally, you probably want to be able to return whether the
attribute was supported/handled at all (because of differing kernel
versions, or because it was driver specific) and we need attribute
returns to be able to sanely handle that.

So my opinion is that the only really sane way to implement attribute
return values is to pass them back to userspace via the ringbuffer,
along with the struct io_event.

(For those not intimately familiar with the AIO implementation, on
completion the generated io_event is copied into a ringbuffer which
happens to be mapped into userspace, even though normally userspace will
get the io_event with io_getevents(). This ringbuffer constrains the
design quite a bit, though).

Trouble is, we (probably, there is some debate) can't really just change
the existing ringbuffer format - there's a version field in the existing
ringbuffer, but userspace can't check that until after the ringbuffer is
setup and mapped into userspace. There's no existing mechanism for
userspace to specify flags or options or versioning when setting up the
io context.

So, to do this requires new syscalls, and more or less forking most of
the existing AIO implementation. Also, returning variable length entries
via the ringbuffer turns out to require redesigning a substantial
fraction of the existing AIO implementation - so we might as well fix
everything else that needs fixing at the same time.

Where I'm at now - I've got a new syscall interface that changes enough
to support extensible AIO attributes prototyped; it looks almost
complete but I haven't started testing yet. Enough is there to see how
it all fits together, though - IMO the important bits are how we deal
with different types of kioctxs (I think it works out fairly nicely).

Code is available at http://evilpiepirate.org/git/linux-bcache.git/ aio-new-abi
(Definitely broken, don't even think about trying to run it yet).

We plan on rolling this out at Google in the near term with the minimal
set of changes (because we've got stuff blocked on this), but there's
more changes I'd like to make before this (hopefully) goes upstream.

So, what changes?

 * Currently, we strictly limit outstanding kiocbs so as to avoid
   overflowing the ringbuffer; this means that the size of the
   ringubffer we allocate is determined by the nr_events userspace
   passes to io_setup().

   This approach doesn't work when ringbuffer entries are variable
   length - we can still use a ringbuffer (and I think we want to), but
   we need to have an overflow mechanism for when it fills up.

   This is actually one of the backwards compatibility issues;
   currently, it is possible for userspace to reap io_events without
   ever calling into the kernel. But if we've got an overflow mechanism,
   that's no longer possible - userspace has to call io_getevents() when
   the ringbuffer's empty, or it'll never see events that might've been
   on the overflow list - that or we need to put a flag in the
   ringbuffer header.

   Adding the overflow mechanism is an overall reduction in complexity
   though, we can toss out a bunch of code elsewhere and ringbuffer size
   isn't so important anymore.

 * With the way the head/tail pointers are defined in the current
   ringbuffer implentation, we can't do lockless reaping without being
   subject to ABA. I've fixed this in my prototype - the head/tail
   values use the full range of 32 bit integers, we only mod them by the
   ringbuffer size when calculating the current position.

 * The head/tail pointers, and also io_submit()/io_getevents() all work
   in units of struct iocb/struct io_event. With attributes those
   structs are now variable length, so it makes more sense to switch
   all the units to bytes.

   With these changes, the ringbuffer implementation is looking less and
   less AIO specific. I've been wondering a bit whether it could be made
   generic and merged with other ringbuffers (I'm not sure what else
   there is offhand, besides tracing - tracing has substantially
   different needs, but I'd be surprised if there aren't other similar
   ringbuffers somewhere).

 * The eventfd field should've never been added to struct iocb, imo -
   it should've been added to the kioctx (You don't want to know when a
   specific iocb is done, there isn't any way to check for that directly
   - you want to know when there's events to reap). I'm fixing that.

 * Adding a version parameter to io_setup2()

Those are the main changes (besides adding attributes, of course) that
I've made so far. 

 * Get rid of the parallel syscall interface 

   AIO really shouldn't be implementing its own slightly different
   syscalls; it should be a mechanism for doing syscalls asynchronously.

   If we don't have asynchronous implementations of most of our syscalls
   right now, so what? Tying the interface to the implementation is
   still stupid. And if we're lucky, someday we'll have a generic thread
   pool implementation for all the syscalls that aren't worth special
   casing (perhaps building off the work Ben LaHaise has been doing to
   implement buffered AIO).

   This is particularly important now with attributes - almost none of
   the attributes we want to implement are actually AIO specific; we'd
   like to be able to use them with arbitrary syscalls.

   Well, if we turn AIO into a mechanism for doing arbitrary syscalls
   asynchronously - it'll be really easy to add one syscall to issue an
   iocb synchronously; at that point it'll just be an "issue this
   syscall with attributes" syscall.
