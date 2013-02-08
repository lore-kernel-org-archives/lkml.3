Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab3BHOuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:50:15 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41657
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab3BHOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:50:13 -0500
Date: Fri, 8 Feb 2013 15:49:02 +0100
From: Jens Axboe <axboe@kernel.dk>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        bcrl@kvack.org, jmoyer@redhat.com, viro@zeniv.linux.org.uk,
        tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 23/32] Generic dynamic per cpu refcounting
Message-ID: <20130208144902.GQ15092@kernel.dk>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-26-git-send-email-koverstreet@google.com>
 <20130208144408.GY2875@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130208144408.GY2875@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08 2013, Tejun Heo wrote:
> (cc'ing Andrew)
> 
> On Wed, Dec 26, 2012 at 06:00:02PM -0800, Kent Overstreet wrote:
> > This implements a refcount with similar semantics to
> > atomic_get()/atomic_dec_and_test(), that starts out as just an atomic_t
> > but dynamically switches to per cpu refcounting when the rate of
> > gets/puts becomes too high.
> > 
> > It also implements two stage shutdown, as we need it to tear down the
> > percpu counts. Before dropping the initial refcount, you must call
> > percpu_ref_kill(); this puts the refcount in "shutting down mode" and
> > switches back to a single atomic refcount with the appropriate barriers
> > (synchronize_rcu()).
> > 
> > It's also legal to call percpu_ref_kill() multiple times - it only
> > returns true once, so callers don't have to reimplement shutdown
> > synchronization.
> > 
> > For the sake of simplicity/efficiency, the heuristic is pretty simple -
> > it just switches to percpu refcounting if there are more than x gets
> > in one second (completely arbitrarily, 4096).
> > 
> > It'd be more correct to count the number of cache misses or something
> > else more profile driven, but doing so would require accessing the
> > shared ref twice per get - by just counting the number of gets(), we can
> > stick that counter in the high bits of the refcount and increment both
> > with a single atomic64_add(). But I expect this'll be good enough in
> > practice.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> 
> What's the status of this series?  The percpu-refcnt part is still
> going through review and the merge window is opening up pretty soon.
> Kent, Andrew?

I'd feel a lot better deferring the whole aio/dio performance series for
one merge window. There's very little point in rushing it, and I don't
think it's been reviewed/tested enough yet.

-- 
Jens Axboe

