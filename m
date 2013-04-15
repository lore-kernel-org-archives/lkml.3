Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376Ab3DOWbR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 18:31:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47398 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab3DOWbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 18:31:15 -0400
Date: Mon, 15 Apr 2013 15:31:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, lsf-pc@lists.linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Benjamin LaHaise <bcrl@kvack.org>,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: New AIO API
Message-Id: <20130415153113.e91625d754cb60c73e60abff@linux-foundation.org>
In-Reply-To: <20130412222856.GB31761@localhost>
References: <20130412222856.GB31761@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013 15:28:56 -0700 Kent Overstreet <koverstreet@google.com> wrote:

> So, awhile back I posted about an extensible AIO attributes mechanism
> I'd been cooking up: http://article.gmane.org/gmane.linux.kernel/1367969
> 
> Since then, more uses for the thing have been popping up, but I ran into
> a roadblock - with the existing AIO api, return values for the
> attributes were going to be, at best, considerably uglier than I
> anticipated.
> 
> Some background: some attributes we'd like to implement need to be able
> to return values with the io_event at completion time. Many of the
> examples I know of are more or less tracing - returning how long the IO
> took, whether it was a cache hit or miss (bcache, perhaps page cache
> when buffered AIO is supported), etc.
> 
> Additionally, you probably want to be able to return whether the
> attribute was supported/handled at all (because of differing kernel
> versions, or because it was driver specific) and we need attribute
> returns to be able to sanely handle that.
> 
> So my opinion is that the only really sane way to implement attribute
> return values is to pass them back to userspace via the ringbuffer,
> along with the struct io_event.
> 
> (For those not intimately familiar with the AIO implementation, on
> completion the generated io_event is copied into a ringbuffer which
> happens to be mapped into userspace, even though normally userspace will
> get the io_event with io_getevents(). This ringbuffer constrains the
> design quite a bit, though).
> 
> Trouble is, we (probably, there is some debate) can't really just change
> the existing ringbuffer format - there's a version field in the existing
> ringbuffer, but userspace can't check that until after the ringbuffer is
> setup and mapped into userspace. There's no existing mechanism for
> userspace to specify flags or options or versioning when setting up the
> io context.
> 
> So, to do this requires new syscalls, and more or less forking most of
> the existing AIO implementation. Also, returning variable length entries
> via the ringbuffer turns out to require redesigning a substantial
> fraction of the existing AIO implementation - so we might as well fix
> everything else that needs fixing at the same time.

This all sounds like a lot of work, risk, disruption, bloat, etc, etc. 
That's not a problem per-se, but it should only be undertaken if the
payback makes it worthwhile.

Unfortunately your email contains only a terse description of this most
important factor: if we add all this stuff to Linux, what do we get in
return?  "More or less tracing".  Is that useful enough to justify the
changes?  Please let's pay a lot more attention to this question before
getting further into implementation stuff!  Sell it to us.

> Those are the main changes (besides adding attributes, of course) that
> I've made so far. 
> 
>  * Get rid of the parallel syscall interface 
> 
>    AIO really shouldn't be implementing its own slightly different
>    syscalls; it should be a mechanism for doing syscalls asynchronously.

Yes.  We got about a twelfth of the way there many years ago
(google("syslets")) but it died.  A shame.

