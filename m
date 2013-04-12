Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313Ab3DLTgH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 15:36:07 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:45611 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3DLTgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 15:36:05 -0400
Date: Fri, 12 Apr 2013 12:36:00 -0700
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
        Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 23/33] generic dynamic per cpu refcounting
Message-ID: <20130412193600.GA31761@localhost>
References: <1363883754-27966-1-git-send-email-koverstreet@google.com>
 <1363883754-27966-24-git-send-email-koverstreet@google.com>
 <20130402162738.GG31577@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130402162738.GG31577@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 02, 2013 at 12:27:38PM -0400, Theodore Ts'o wrote:
> Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>
> 
> > +		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
> > +					&ref->count);
> > +
> > +		if (!(v >> PCPU_COUNT_BITS) &&
> > +		    REF_STATUS(pcpu_count) == PCPU_REF_NONE && alloc)
> > +			percpu_ref_alloc(ref, pcpu_count);
> 
> This assumes that the kernel is compiled with -fno-strict-overflow.
> Which we do, and this is not the only place int the kernel where we
> depend on this, so while I was nervous before, I'm okay with it now.
> Could we at least have a comment saying that we're depending on
> -fno-strict-overflow, though?

Well, I don't think it is true that we are depending on
-fno-strict-overflow since the overflow happens in atomic_add() which is
a black box to the compiler.

It would be nice if we had unsigned atomic types... but given that we
don't and I'm pretty sure overflow in atomic types happens all over the
place that part honestly seems fine to me...

That said, I suppose a comment indicating that it is intentionally
overflowing is probably merited. Ted, Andrew, is this acceptable to you?

---
 lib/percpu-refcount.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib/percpu-refcount.c b/lib/percpu-refcount.c
index 79c6158..200088f 100644
--- a/lib/percpu-refcount.c
+++ b/lib/percpu-refcount.c
@@ -124,6 +124,13 @@ void __percpu_ref_get(struct percpu_ref *ref, bool alloc)
 		v = atomic64_add_return(1 + (1ULL << PCPU_COUNT_BITS),
 					&ref->count);
 
+		/*
+		 * The high bits of the counter count the number of gets() that
+		 * have occured; we check for overflow to call
+		 * percpu_ref_alloc() every (1 << (64 - PCPU_COUNT_BITS))
+		 * iterations.
+		 */
+
 		if (!(v >> PCPU_COUNT_BITS) &&
 		    REF_STATUS(pcpu_count) == PCPU_REF_NONE && alloc)
 			percpu_ref_alloc(ref, pcpu_count);
-- 
1.7.12.146.g16d26b1

