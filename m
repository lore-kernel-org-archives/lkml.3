Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab3CKU2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:28:25 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:38699 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3CKU2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:28:23 -0400
Date: Mon, 11 Mar 2013 13:28:18 -0700
From: Tejun Heo <tj@kernel.org>
To: David Teigland <teigland@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 67/77] dlm: convert to idr_alloc()
Message-ID: <20130311202818.GN24522@htj.dyndns.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
 <1360179649-22465-68-git-send-email-tj@kernel.org>
 <20130311192955.GA23892@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311192955.GA23892@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, David.

On Mon, Mar 11, 2013 at 03:29:55PM -0400, David Teigland wrote:
> On Wed, Feb 06, 2013 at 11:40:39AM -0800, Tejun Heo wrote:
> >  static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
> >  {
> >  	struct dlm_lkb *lkb;
> > -	int rv, id;
> > +	int rv;
> >  
> >  	lkb = dlm_allocate_lkb(ls);
> >  	if (!lkb)
> > @@ -1199,19 +1199,13 @@ static int create_lkb(struct dlm_ls *ls, struct dlm_lkb **lkb_ret)
> >  	mutex_init(&lkb->lkb_cb_mutex);
> >  	INIT_WORK(&lkb->lkb_cb_work, dlm_callback_work);
> >  
> > - retry:
> > -	rv = idr_pre_get(&ls->ls_lkbidr, GFP_NOFS);
> > -	if (!rv)
> > -		return -ENOMEM;
> > -
> > +	idr_preload(GFP_NOFS);
> >  	spin_lock(&ls->ls_lkbidr_spin);
> > -	rv = idr_get_new_above(&ls->ls_lkbidr, lkb, 1, &id);
> > -	if (!rv)
> > -		lkb->lkb_id = id;
> > +	rv = idr_alloc(&ls->ls_lkbidr, lkb, 1, 0, GFP_NOWAIT);
> 
> Hi Tejun,
> I'm seeing a number of new failure/warning messages within this idr_alloc.
> I've not seen idr_alloc itself return an error yet.  Is this an expected
> failure where the warnings should be suppressed?

Ah, right, in preloaded section, the allocation is expected to fail
before falling back to the preload buffer and I forgot to add
__GFP_NOWARN to the first try.  Something like the following should
make it go away.  Can you please test it?

Thanks a lot!

diff --git a/lib/idr.c b/lib/idr.c
index 00739aa..e410e5d 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -106,8 +106,14 @@ static struct idr_layer *idr_layer_alloc(gfp_t gfp_mask, struct idr *layer_idr)
 	if (layer_idr)
 		return get_from_free_list(layer_idr);
 
-	/* try to allocate directly from kmem_cache */
-	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
+	/*
+	 * Try to allocate directly from kmem_cache.  We want to try this
+	 * before preload buffer; otherwise, non-preloading idr_alloc()
+	 * users will end up taking advantage of preloading ones.  As the
+	 * following is allowed to fail for preloaded cases, suppress
+	 * warning this time.
+	 */
+	new = kmem_cache_zalloc(idr_layer_cache, gfp_mask | __GFP_NOWARN);
 	if (new)
 		return new;
 
@@ -115,18 +121,24 @@ static struct idr_layer *idr_layer_alloc(gfp_t gfp_mask, struct idr *layer_idr)
 	 * Try to fetch one from the per-cpu preload buffer if in process
 	 * context.  See idr_preload() for details.
 	 */
-	if (in_interrupt())
-		return NULL;
-
-	preempt_disable();
-	new = __this_cpu_read(idr_preload_head);
-	if (new) {
-		__this_cpu_write(idr_preload_head, new->ary[0]);
-		__this_cpu_dec(idr_preload_cnt);
-		new->ary[0] = NULL;
+	if (!in_interrupt()) {
+		preempt_disable();
+		new = __this_cpu_read(idr_preload_head);
+		if (new) {
+			__this_cpu_write(idr_preload_head, new->ary[0]);
+			__this_cpu_dec(idr_preload_cnt);
+			new->ary[0] = NULL;
+		}
+		preempt_enable();
+		if (new)
+			return new;
 	}
-	preempt_enable();
-	return new;
+
+	/*
+	 * Both failed.  Try kmem_cache again w/o adding __GFP_NOWARN so
+	 * that memory allocation failure warning is printed as intended.
+	 */
+	return kmem_cache_zalloc(idr_layer_cache, gfp_mask);
 }
 
 static void idr_layer_rcu_free(struct rcu_head *head)
