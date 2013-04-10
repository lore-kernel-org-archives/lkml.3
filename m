Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936549Ab3DJV7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 17:59:20 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61169 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761894Ab3DJV7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 17:59:18 -0400
Date: Wed, 10 Apr 2013 14:59:15 -0700
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
Message-ID: <20130410215915.GB30871@google.com>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-31-git-send-email-koverstreet@google.com>
 <20130402194803.GA5703@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402194803.GA5703@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 03:48:03PM -0400, Theodore Ts'o wrote:
> On Thu, Mar 21, 2013 at 09:35:51AM -0700, Kent Overstreet wrote:
> > +		if (unlikely(req->ki_ctx != ctx)) {
> > +			kioctx_ring_unlock(ctx, tail);
> > +
> > +			ctx = req->ki_ctx;
> > +			tail = kioctx_ring_lock(ctx);
> > +		}
> 
> The only place where you're calling kioctx_ring_lock() is above, which
> is part of an unlock/lock pair.
> 
> There is also a kioctx_ring_unlock at the end of batch_complete_aio():
> 
> > +	kioctx_ring_unlock(ctx, tail);
> > +	local_irq_restore(flags);
> > +	rcu_read_unlock();
> 
> But I'm not seeing a matching kioctx_ring_lock() before the while loop
> in batch_complete_aio(), nor anywhere else in the file.  And since
> kioctx_ring_lock() is a static function....
> 
> Am I missing something?

We start out with ctx == NULL - we handle the initial kiocb the same way
we handle a kiocb with a different kioctx as the last one.
