Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3BDAQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 19:16:04 -0500
Received: from fieldses.org ([174.143.236.118]:36440 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885Ab3BDAQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 19:16:02 -0500
Date: Sun, 3 Feb 2013 19:15:58 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk
Subject: Re: [PATCHSET] idr: implement idr_alloc() and convert existing users
Message-ID: <20130204001557.GB24778@fieldses.org>
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <20130203170241.GA24778@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130203170241.GA24778@fieldses.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 12:02:41PM -0500, J. Bruce Fields wrote:
> On Sat, Feb 02, 2013 at 05:20:01PM -0800, Tejun Heo wrote:
> > * Bruce, I couldn't convert nfsd.  Can you please help?  More on it
> >   later.
> ...
> > I converted all in-kernel users except nfsd and staging drivers.  nfsd
> > splits preloading and actual id allocation in a way that per-cpu
> > preloading can't be used.  I couldn't follow the control flow to
> > verify whether the current code is correct either.  I think the best
> > way would be allocating ID upfront without installing the handle and
> > then later using idr_replace() to install the pointer when the ID
> > actually gets used.  Bruce, would something like that be possible?
> 
> Actually, I'm not even sure if that's necessary, we can probably just
> do it all at the start.
> 
> I'll try to have a patch doing that tomorrow.

So, something like this.

--b.

commit 9847160469b40345e1d78a7cbf9536761bb47d91
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Sun Feb 3 12:23:01 2013 -0500

    nfsd4: simplify idr allocation
    
    We don't really need to preallocate at all; just allocate and initialize
    everything at once, but leave the sc_type field initially 0 to prevent
    finding the stateid till it's fully initialized.
    
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 4db46aa..485b1f7 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -261,33 +261,46 @@ static inline int get_new_stid(struct nfs4_stid *stid)
 	return new_stid;
 }
 
-static void init_stid(struct nfs4_stid *stid, struct nfs4_client *cl, unsigned char type)
+static struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl, struct
+kmem_cache *slab)
 {
-	stateid_t *s = &stid->sc_stateid;
+	struct idr *stateids = &cl->cl_stateids;
+	static int min_stateid = 0;
+	struct nfs4_stid *stid;
 	int new_id;
 
-	stid->sc_type = type;
+	stid = kmem_cache_alloc(slab, GFP_KERNEL);
+	if (!stid)
+		return NULL;
+
+	if (!idr_pre_get(stateids, GFP_KERNEL))
+		goto out_free;
+	if (idr_get_new_above(stateids, stid, min_stateid, &new_id))
+		goto out_free;
 	stid->sc_client = cl;
-	s->si_opaque.so_clid = cl->cl_clientid;
-	new_id = get_new_stid(stid);
-	s->si_opaque.so_id = (u32)new_id;
+	stid->sc_type = 0;
+	stid->sc_stateid.si_opaque.so_id = new_id;
+	stid->sc_stateid.si_opaque.so_clid = cl->cl_clientid;
 	/* Will be incremented before return to client: */
-	s->si_generation = 0;
-}
+	stid->sc_stateid.si_generation = 0;
 
-static struct nfs4_stid *nfs4_alloc_stid(struct nfs4_client *cl, struct kmem_cache *slab)
-{
-	struct idr *stateids = &cl->cl_stateids;
-
-	if (!idr_pre_get(stateids, GFP_KERNEL))
-		return NULL;
 	/*
-	 * Note: if we fail here (or any time between now and the time
-	 * we actually get the new idr), we won't need to undo the idr
-	 * preallocation, since the idr code caps the number of
-	 * preallocated entries.
+	 * It shouldn't be a problem to reuse an opaque stateid value.
+	 * I don't think it is for 4.1.  But with 4.0 I worry that, for
+	 * example, a stray write retransmission could be accepted by
+	 * the server when it should have been rejected.  Therefore,
+	 * adopt a trick from the sctp code to attempt to maximize the
+	 * amount of time until an id is reused, by ensuring they always
+	 * "increase" (mod INT_MAX):
 	 */
-	return kmem_cache_alloc(slab, GFP_KERNEL);
+
+	min_stateid = new_id+1;
+	if (min_stateid == INT_MAX)
+		min_stateid = 0;
+	return stid;
+out_free:
+	kfree(stid);
+	return NULL;
 }
 
 static struct nfs4_ol_stateid * nfs4_alloc_stateid(struct nfs4_client *clp)
@@ -316,7 +329,7 @@ alloc_init_deleg(struct nfs4_client *clp, struct nfs4_ol_stateid *stp, struct sv
 	dp = delegstateid(nfs4_alloc_stid(clp, deleg_slab));
 	if (dp == NULL)
 		return dp;
-	init_stid(&dp->dl_stid, clp, NFS4_DELEG_STID);
+	dp->dl_stid.sc_type = NFS4_DELEG_STID;
 	/*
 	 * delegation seqid's are never incremented.  The 4.1 special
 	 * meaning of seqid 0 isn't meaningful, really, but let's avoid
@@ -337,13 +350,21 @@ alloc_init_deleg(struct nfs4_client *clp, struct nfs4_ol_stateid *stp, struct sv
 	return dp;
 }
 
+void free_stid(struct nfs4_stid *s, struct kmem_cache *slab)
+{
+	struct idr *stateids = &s->sc_client->cl_stateids;
+
+	idr_remove(stateids, s->sc_stateid.si_opaque.so_id);
+	kmem_cache_free(slab, s);
+}
+
 void
 nfs4_put_delegation(struct nfs4_delegation *dp)
 {
 	if (atomic_dec_and_test(&dp->dl_count)) {
 		dprintk("NFSD: freeing dp %p\n",dp);
 		put_nfs4_file(dp->dl_file);
-		kmem_cache_free(deleg_slab, dp);
+		free_stid(&dp->dl_stid, deleg_slab);
 		num_delegations--;
 	}
 }
@@ -360,9 +381,7 @@ static void nfs4_put_deleg_lease(struct nfs4_file *fp)
 
 static void unhash_stid(struct nfs4_stid *s)
 {
-	struct idr *stateids = &s->sc_client->cl_stateids;
-
-	idr_remove(stateids, s->sc_stateid.si_opaque.so_id);
+	s->sc_type = 0;
 }
 
 /* Called under the state lock. */
@@ -519,7 +538,7 @@ static void close_generic_stateid(struct nfs4_ol_stateid *stp)
 
 static void free_generic_stateid(struct nfs4_ol_stateid *stp)
 {
-	kmem_cache_free(stateid_slab, stp);
+	free_stid(&stp->st_stid, stateid_slab);
 }
 
 static void release_lock_stateid(struct nfs4_ol_stateid *stp)
@@ -1258,7 +1277,12 @@ static void gen_confirm(struct nfs4_client *clp)
 
 static struct nfs4_stid *find_stateid(struct nfs4_client *cl, stateid_t *t)
 {
-	return idr_find(&cl->cl_stateids, t->si_opaque.so_id);
+	struct nfs4_stid *ret;
+
+	ret = idr_find(&cl->cl_stateids, t->si_opaque.so_id);
+	if (!ret || !ret->sc_type)
+		return NULL;
+	return ret;
 }
 
 static struct nfs4_stid *find_stateid_by_type(struct nfs4_client *cl, stateid_t *t, char typemask)
@@ -2444,9 +2468,8 @@ alloc_init_open_stateowner(unsigned int strhashval, struct nfs4_client *clp, str
 
 static void init_open_stateid(struct nfs4_ol_stateid *stp, struct nfs4_file *fp, struct nfsd4_open *open) {
 	struct nfs4_openowner *oo = open->op_openowner;
-	struct nfs4_client *clp = oo->oo_owner.so_client;
 
-	init_stid(&stp->st_stid, clp, NFS4_OPEN_STID);
+	stp->st_stid.sc_type = NFS4_OPEN_STID;
 	INIT_LIST_HEAD(&stp->st_lockowners);
 	list_add(&stp->st_perstateowner, &oo->oo_owner.so_stateids);
 	list_add(&stp->st_perfile, &fp->fi_stateids);
@@ -4032,7 +4055,7 @@ alloc_init_lock_stateid(struct nfs4_lockowner *lo, struct nfs4_file *fp, struct
 	stp = nfs4_alloc_stateid(clp);
 	if (stp == NULL)
 		return NULL;
-	init_stid(&stp->st_stid, clp, NFS4_LOCK_STID);
+	stp->st_stid.sc_type = NFS4_LOCK_STID;
 	list_add(&stp->st_perfile, &fp->fi_stateids);
 	list_add(&stp->st_perstateowner, &lo->lo_owner.so_stateids);
 	stp->st_stateowner = &lo->lo_owner;
