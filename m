Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbaAWQqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:46:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39276 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbaAWQq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:46:28 -0500
Date: Thu, 23 Jan 2014 17:46:07 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v2 1/3] percpu_ida: Make percpu_ida_alloc + callers
 accept task state bitmask
Message-ID: <20140123164607.GL3694@twins.programming.kicks-ass.net>
References: <1390189486-13579-1-git-send-email-nab@linux-iscsi.org>
 <1390189486-13579-2-git-send-email-nab@linux-iscsi.org>
 <20140120113415.GE30183@twins.programming.kicks-ass.net>
 <20140121221852.GT9037@kmo>
 <20140123124753.GT30183@twins.programming.kicks-ass.net>
 <20140123132829.GE889@kmo-pixel>
 <20140123135003.GU30183@twins.programming.kicks-ass.net>
 <20140123135539.GF889@kmo-pixel>
 <20140123154312.GX30183@twins.programming.kicks-ass.net>
 <20140123162254.GK3694@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123162254.GK3694@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 05:22:54PM +0100, Peter Zijlstra wrote:
> On Thu, Jan 23, 2014 at 05:28:29AM -0800, Kent Overstreet wrote:
> > pool->lock is also going to be fairly badly contended in the worst case,
> > and that can get real bad real fast... now that I think about it we
> > probably want to avoid the __alloc_global_tag() double call just because
> > of that, pool->lock is going to be quite a bit more contended than the
> > waitlist lock just because fo the amount of work done under it.

> Now everything modifying percpu_ida_cpu state holds
> percpu_ida_cpu::lock

Almost that.

---
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -51,6 +51,15 @@ static inline void move_tags(unsigned *d
 	*dst_nr += nr;
 }
 
+static inline void double_lock(spinlock_t *l1, spinlock_t *l2)
+{
+	if (l1 > l2)
+		swap(l1, l2);
+
+	spin_lock(l1);
+	spin_lock_nested(l2, SINGLE_DEPTH_NESTING);
+}
+
 /*
  * Try to steal tags from a remote cpu's percpu freelist.
  *
@@ -87,7 +96,7 @@ static inline void steal_tags(struct per
 		if (remote == tags)
 			continue;
 
-		spin_lock(&remote->lock);
+		double_lock(&tags->lock, &remote->lock);
 
 		if (remote->nr_free) {
 			memcpy(tags->freelist,
@@ -99,6 +108,7 @@ static inline void steal_tags(struct per
 		}
 
 		spin_unlock(&remote->lock);
+		spin_unlock(&tags->lock);
 
 		if (tags->nr_free)
 			break;
