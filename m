Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3FMTIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:08:41 -0400
Received: from fieldses.org ([174.143.236.118]:49510 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464Ab3FMTIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:08:40 -0400
Date: Thu, 13 Jun 2013 15:08:31 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613190831.GB19218@fieldses.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613020536.GA10979@localhost>
 <20130612200311.7f9d938a.akpm@linux-foundation.org>
 <20130613185318.GB12075@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130613185318.GB12075@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 11:53:18AM -0700, Tejun Heo wrote:
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

It's not really per-transaction: it's more like an identifier for a
piece of lock state (an open, a lock, whatever), so a bit like a file
descriptor, but there's no requirement they be "small".

> The only requirement on IDs is that they shouldn't be recycled too
> fast.

Yep.--b.

> Currently, idr implements cyclic mode for it but it can easily
> be replaced with per-cpu tag allocator like this one and it'd be a lot
> more scalable.  There are a couple things to worry about tho - it
> probably should use the highbits as generation number as a tag is
> given out so that the actual ID doesn't get recycled quickly, and some
> form dynamic tag sizing would be nice too.
> 
> Thanks.
> 
> -- 
> tejun
