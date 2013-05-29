Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934494Ab3E2BLo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 21:11:44 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:39933 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab3E2BLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 21:11:41 -0400
Date: Wed, 29 May 2013 10:11:35 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 04/21] Generic percpu refcounting
Message-ID: <20130529011135.GA2874@mtj.dyndns.org>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
 <1368494338-7069-5-git-send-email-koverstreet@google.com>
 <20130514145932.GA6607@mtj.dyndns.org>
 <20130515085856.GB16164@moria.home.lan>
 <20130515173720.GA26222@htj.dyndns.org>
 <20130528234728.GB2291@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130528234728.GB2291@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

On Tue, May 28, 2013 at 04:47:28PM -0700, Kent Overstreet wrote:
> > It'd be great if that is explained clearly in more intuitive way.  The
> > only actual explanation above is "modular arithmatic is commutative"
> > which is a very compact way to put it and I really think it deserves
> > an easier explanation.
> 
> I'm not sure I know of any good way of explaining it intuitively, but
> here's this at least...
> 
>  * (More precisely: because moduler arithmatic is commutative the sum of all the
>  * pcpu_count vars will be equal to what it would have been if all the gets and
>  * puts were done to a single integer, even if some of the percpu integers
>  * overflow or underflow).

Yeah, that's much better.

> And we can't do more puts than there have been gets - because the sum
> can't be negative. So the most puts() we can do at any given time is the
> real count, or sum of the percpu ref and atomic_t.
> 
> Therefore, the amount the atomic_t can go negative is bounded by the
> maximum value of the refcount.

Ah, okay, I thought you were collecting the percpu counters directly
into the global counter.  You're staging it into a temp counter and
then adding it into the global counter after the summing is complete.
Yeap, that should be fine then.  It'd be worthwhile to document the
importance of not adding it directly to the global counter.

> > I probably should have made it clearer.  Sorry about that.  tryget()
> > is fine.  I was curious about count() as it's always a bit dangerous a
> > query interface which is racy and can return something unexpected like
> > false zero or underflowed refcnt.
> 
> Yeah, it is, it was intended just for the module code where it's only
> used for the value lsmod shows.

Let's document so then and limit the range returned.  We require the
refcnt to be alive and it'd be a good way to both protect from and
deter creative usages.

> > Let's just have percpu_ref_kill(ref, release) which puts the base ref
> > and invokes release whenever it's done.
> 
> Release has to be stored in struct percpu_ref() so it can be invoked
> after a call_rcu() (percpu_ref_kill -> call_rcu() ->
> percpu_ref_kill_rcu() -> percpu_ref_put()) so I'm passing it to
> percpu_ref_init(), but yeah.

Yeah, I'm a bit torn about where to put the release function.  For me,
as we have an API which is dedicated to killing a refcnt, it does make
sense to put it there but it's really in the realm of bikeshedding so
choose whatever you wanna choose.

Thanks!

-- 
tejun
