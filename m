Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934898Ab3DJWJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:09:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61064 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab3DJWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:09:30 -0400
Date: Wed, 10 Apr 2013 15:09:26 -0700
From: Kent Overstreet <koverstreet@google.com>
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 30/33] block, aio: batch completion for bios/kiocbs
Message-ID: <20130410220926.GC30871@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-31-git-send-email-koverstreet@google.com>
 <20130402195303.GB5703@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402195303.GB5703@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 03:53:03PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2013 at 09:35:51AM -0700, Kent Overstreet wrote:
> > +		if (unlikely(req->ki_eventfd != eventfd)) {
> > +			if (eventfd) {
> > +				/* Make event visible */
> > +				kioctx_ring_unlock(ctx, tail);
> > +				ctx = NULL;
> > +
> > +				eventfd_signal(eventfd, 1);
> > +				eventfd_ctx_put(eventfd);
> > +			}
> 
> I just noticed something else.  There's a ring unlock here().... but
> there isn't a matching ring_lock(), or an exit from the function.
> Since you've set the ctx to be NULL, then subsequently, aren't we
> going to crash at the subseqent kioctx_ring_unlock() below....

No, kioctx_ring_unlock() checks for ctx == NULL - it would be more
readable I suppose to have the check outside of kioctx_ring_unlock() but
that's how it ended up... the check is needed multiple places.

> 
> > +
> > +			eventfd = req->ki_eventfd;
> > +			req->ki_eventfd = NULL;
> > +		}
> > +
> > +		if (unlikely(req->ki_ctx != ctx)) {
> > +			kioctx_ring_unlock(ctx, tail);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> (Or the kioctx_ring_unlock() at the end of this function after the
> while loop terminates.)
> 
> 						- Ted
> 
