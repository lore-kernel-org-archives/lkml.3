Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646Ab3CZPUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:20:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61777 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933284Ab3CZPUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:20:08 -0400
Date: Tue, 26 Mar 2013 11:19:36 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing
 users
Message-ID: <20130326111936.550110bf@tlielax.poochiereds.net>
In-Reply-To: <20130321183513.GC20500@htj.dyndns.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
	<20130203170241.GA24778@fieldses.org>
	<20130204001557.GB24778@fieldses.org>
	<20130204171031.GK27963@mtj.dyndns.org>
	<20130204171128.GL27963@mtj.dyndns.org>
	<20130321140618.GD27838@fieldses.org>
	<20130321183513.GC20500@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013 11:35:13 -0700
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Mar 21, 2013 at 10:06:18AM -0400, J. Bruce Fields wrote:
> > > Ooh, BTW, the cyclic allocation is broken.  It's prone to -ENOSPC
> > > after the first wraparound.  There are several cyclic users in the
> > > kernel and I think it probably would be best to implement cyclic
> > > support in idr.
> > 
> > Are you looking at this, by the way, or do you have any suggestions?
> > 
> > Wondering if it's something I should try to fix or if I should look into
> > converting to some other data structure here.
> 
> I am not working on it at the moment but I think the logical thing to
> do would be implementing cyclic support in idr and enabling it with,
> say, a different initializer - IDR_CYCLIC_INIT() or something.  If you
> wanna fix it, please go ahead. :)
> 
> Thanks.
> 

So, here's a first (very rough, completely untested) pass at fixing
this for cyclic allocations. This looks like it'll probably fix the
ENOSPC errors when the counter wraps.

I'm not sure this is really what's needed though.

Suppose we have a situation where most of the currently allocated IDs
are clustered near the top of the range. When the counter wraps and we
call idr_alloc with a low start value, won't it prefer to allocate from
an existing layer instead of creating a new one?

If so, then means that after the counter wraps, it can skip over all of
the low values and reuse a more recently used high value. Is that OK
for the existing cyclic users? Or do we need to do something more
elaborate to make it prefer IDs at the low ranges after the counter
wraps?

-------------------[snip]--------------------

[PATCH] idr: introduce idr_alloc_cyclic

Thus spake Tejun Heo:

    Ooh, BTW, the cyclic allocation is broken.  It's prone to -ENOSPC
    after the first wraparound.  There are several cyclic users in the
    kernel and I think it probably would be best to implement cyclic
    support in idr.

This patch does that by adding new idr_alloc_cyclic function that
such users in the kernel can use. The idea here is that the caller will
keep a static counter of some sort that we can use to track where
the next "start" value should be on the next allocation.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 include/linux/idr.h |  1 +
 lib/idr.c           | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 2640c7e..c6ac330 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -75,6 +75,7 @@ struct idr {
 void *idr_find_slowpath(struct idr *idp, int id);
 void idr_preload(gfp_t gfp_mask);
 int idr_alloc(struct idr *idp, void *ptr, int start, int end, gfp_t gfp_mask);
+int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, int *cur, gfp_t gfp_mask);
 int idr_for_each(struct idr *idp,
 		 int (*fn)(int id, void *p, void *data), void *data);
 void *idr_get_next(struct idr *idp, int *nextid);
diff --git a/lib/idr.c b/lib/idr.c
index 322e281..d835dba 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -495,6 +495,33 @@ int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask)
 }
 EXPORT_SYMBOL_GPL(idr_alloc);
 
+/**
+ * idr_alloc_cyclic - allocate new idr entry in a cyclical fashion
+ * @idr: the (initialized) idr
+ * @ptr: pointer to be associated with the new id
+ * @start: the minimum id (inclusive)
+ * @end: the maximum id (exclusive, <= 0 for max)
+ * @cur: ptr to current position in the range (typically, last allocated + 1)
+ * @gfp_mask: memory allocation flags
+ *
+ * Essentially the same as idr_alloc, but prefers to allocate progressively
+ * higher ids if it can. If the "cur" counter wraps, then it will start again
+ * at the "start" end of the range and allocate one that has already been used.
+ */
+int idr_alloc_cyclic(struct idr *idr, void *ptr, int start, int end, int *cur,
+			gfp_t gfp_mask)
+{
+	int id;
+
+	id = idr_alloc(idr, ptr, *cur, end, gfp_mask);
+	if (id == -ENOSPC)
+		id = idr_alloc(idr, ptr, start, end, gfp_mask);
+
+	if (likely(id >= 0))
+		*cur = id + 1;
+	return id;
+}
+
 static void idr_remove_warning(int id)
 {
 	printk(KERN_WARNING
-- 
1.7.11.7

