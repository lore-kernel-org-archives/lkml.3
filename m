Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab3FMSx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 14:53:27 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:62820 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185Ab3FMSxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 14:53:25 -0400
Date: Thu, 13 Jun 2013 11:53:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Jeff Layton <jlayton@redhat.com>,
        "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH] Percpu tag allocator
Message-ID: <20130613185318.GB12075@mtj.dyndns.org>
References: <1371009804-11596-1-git-send-email-koverstreet@google.com>
 <20130612163854.91da28042ab7a943b69a5970@linux-foundation.org>
 <20130613020536.GA10979@localhost>
 <20130612200311.7f9d938a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130612200311.7f9d938a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew, Kent.

(cc'ing NFS folks for id[r|a] discussion)

On Wed, Jun 12, 2013 at 08:03:11PM -0700, Andrew Morton wrote:
> They all sound like pretty crappy reasons ;) If the idr/ida interface
> is nasty then it can be wrapped to provide the same interface as the
> percpu tag allocator.
> 
> I could understand performance being an issue, but diligence demands
> that we test that, or at least provide a convincing argument.

The thing is that id[r|a] guarantee that the lowest available slot is
allocated and this is important because it's used to name things which
are visible to userland - things like block device minor number,
device indicies and so on.  That alone pretty much ensures that
alloc/free paths can't be very scalable which usually is fine for most
id[r|a] use cases as long as lookup is fast.  I'm doubtful that it's a
good idea to push per-cpu tag allocation into id[r|a].  The use cases
are quite different.

In fact, maybe what we can do is adding some features on top of the
tag allocator and moving id[r|a] users which don't require strict
in-order allocation to it.  For example, NFS allocates an ID for each
transaction it performs and uses it to index the associate command
structure (Jeff, Bruce, please correct me if I'm getting it wrong).
The only requirement on IDs is that they shouldn't be recycled too
fast.  Currently, idr implements cyclic mode for it but it can easily
be replaced with per-cpu tag allocator like this one and it'd be a lot
more scalable.  There are a couple things to worry about tho - it
probably should use the highbits as generation number as a tag is
given out so that the actual ID doesn't get recycled quickly, and some
form dynamic tag sizing would be nice too.

Thanks.

-- 
tejun
