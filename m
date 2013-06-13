Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab3FMTJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751454Ab3FMTJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:09:25 -0400
Date: Thu, 13 Jun 2013 15:09:00 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613150900.4c56f2f0@tlielax.poochiereds.net>
In-Reply-To: <20130613185318.GB12075@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
	<20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
	<20130613020536.GA10979@localhost>
	<20130612200311.7f9d938a.akpm@linux-foundation.org>
	<20130613185318.GB12075@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Jun 2013 11:53:18 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew, Kent.
> 
> (cc'ing NFS folks for id[r|a] discussion)
> 
> On Wed, Jun 12, 2013 at 08:03:11PM -0700, Andrew Morton wrote:
> > They all sound like pretty crappy reasons ;) If the idr/ida interface
> > is nasty then it can be wrapped to provide the same interface as the
> > percpu tag allocator.
> > 
> > I could understand performance being an issue, but diligence demands
> > that we test that, or at least provide a convincing argument.
> 
> The thing is that id[r|a] guarantee that the lowest available slot is
> allocated and this is important because it's used to name things which
> are visible to userland - things like block device minor number,
> device indicies and so on.  That alone pretty much ensures that
> alloc/free paths can't be very scalable which usually is fine for most
> id[r|a] use cases as long as lookup is fast.  I'm doubtful that it's a
> good idea to push per-cpu tag allocation into id[r|a].  The use cases
> are quite different.
> 
> In fact, maybe what we can do is adding some features on top of the
> tag allocator and moving id[r|a] users which don't require strict
> in-order allocation to it.  For example, NFS allocates an ID for each
> transaction it performs and uses it to index the associate command
> structure (Jeff, Bruce, please correct me if I'm getting it wrong).

> The only requirement on IDs is that they shouldn't be recycled too
> fast.  Currently, idr implements cyclic mode for it but it can easily
> be replaced with per-cpu tag allocator like this one and it'd be a lot
> more scalable.  There are a couple things to worry about tho - it
> probably should use the highbits as generation number as a tag is
> given out so that the actual ID doesn't get recycled quickly, and some
> form dynamic tag sizing would be nice too.
> 
> Thanks.
> 

Actually, nfsd just uses idr to allocate stateids, which sort of
correspond to an open or locked file state. This is not a terribly
high-performance codepath -- we allocate one of these roughly on the
frequency of one (or sometimes two) per open() or fcntl() call on the
client.

Anyway...you have the important piece right. The main constraint is
that we don't recycle these too quickly. We'd be fine with totally
random IDs as long as we can be ensured that we don't reuse any until
we've used all 2^31 possible values once.

-- 
Jeff Layton <jlayton@redhat.com>
