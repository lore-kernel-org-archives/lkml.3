Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899Ab3H1VML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:12:11 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:53830 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3H1VMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:12:08 -0400
Date: Wed, 28 Aug 2013 14:12:17 -0700
From: Kent Overstreet <kmo@daterainc.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v3 1/4] idr: Percpu ida
Message-ID: <20130828211217.GE1357@kmo-pixel>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
 <1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
 <20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
 <20130828195317.GE8032@kmo-pixel>
 <20130828132332.6d5263ee9622235ae0fcc615@linux-foundation.org>
 <20130828204454.GC1357@kmo-pixel>
 <20130828135042.9e460b27699b52bb4eb53d9e@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130828135042.9e460b27699b52bb4eb53d9e@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 01:50:42PM -0700, Andrew Morton wrote:
> On Wed, 28 Aug 2013 13:44:54 -0700 Kent Overstreet <kmo@daterainc.com> wrote:
> 
> > > > > What guarantees that this wait will terminate?
> > > > 
> > > > It seems fairly clear to me from the break statement a couple lines up;
> > > > if we were passed __GFP_WAIT we terminate iff we succesfully allocated a
> > > > tag. If we weren't passed __GFP_WAIT we never actually sleep.
> > > 
> > > OK ;)  Let me rephrase.  What guarantees that a tag will become available?
> > > 
> > > If what we have here is an open-coded __GFP_NOFAIL then that is
> > > potentially problematic.
> > 
> > It's the same semantics as a mempool, really - it'll succeed when a tag
> > gets freed.
> 
> OK, that's reasonable if the code is being used to generate IO tags -
> we expect the in-flight tags to eventually be returned.
> 
> But if a client of this code is using the allocator for something
> totally different, there is no guarantee that the act of waiting will
> result in any tags being returned.

Yeah, and I did wonder a bit whether the waiting mechanism belonged in
the percpu ida code; arguably (certainly just looking at this code, not
any of the users) if it belongs in this code it should be common to
regular ida, not specific to percpu ida.

For now I've just decided to punt on changing that for now, since all
the percpu ida users I've come across do want the waiting mechanism, but
none of the regular ida users that I've looked at want it. There's
probably a reason for that I haven't thought of yet.

> (These are core design principles/constraints which should be
> explicitly documented in a place where future readers will see them!)

*nod* I suppose it should be said explicitly that the gfp_t parameter
indicates whether or not to wait until a _tag_ is available, and not
some internal memory allocation or something.

How's this look?

diff --git a/lib/idr.c b/lib/idr.c
index 15c021c..a3f8e9a 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -1288,6 +1288,11 @@ static inline unsigned alloc_local_tag(struct percpu_ida *pool,
  * Safe to be called from interrupt context (assuming it isn't passed
  * __GFP_WAIT, of course).
  *
+ * @gfp indicates whether or not to wait until a free id is available (it's not
+ * used for internal memory allocations); thus if passed __GFP_WAIT we may sleep
+ * however long it takes until another thread frees an id (same semantics as a
+ * mempool).
+ *
  * Will not fail if passed __GFP_WAIT.
  */
 int percpu_ida_alloc(struct percpu_ida *pool, gfp_t gfp)
