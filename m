Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaK1WXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 17:23:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaK1WX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 17:23:29 -0500
Date: Fri, 28 Nov 2014 14:22:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: =?iso-8859-1?Q?Lo=EFc?= Pefferkorn <loic@loicp.eu>
Cc: oleg.drokin@intel.com, andreas.dilger@intel.com, gdonald@gmail.com,
        keith.mannthey@intel.com, john.hammond@intel.com,
        devel@driverdev.osuosl.org, HPDD-discuss@ml01.01.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: fix sparse warnings related to lock
 context imbalance
Message-ID: <20141128222207.GC27558@kroah.com>
References: <02a457cec587341d0f1665491f6360323694b008.1417017302.git.loic@loicp.eu>
 <20141126205443.GB10615@kroah.com>
 <20141127183410.GA4582@iron>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141127183410.GA4582@iron>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 07:34:10PM +0100, Loïc Pefferkorn wrote:
> Hello Greg,
> 
> After some investigation, I think that removing these wrappers is not going to improve the code readability:
> 
> On Wed, Nov 26, 2014 at 12:54:43PM -0800, Greg KH wrote:
> > On Wed, Nov 26, 2014 at 05:15:48PM +0100, Loic Pefferkorn wrote:
> > > Add __acquires() and __releases() function annotations, to fix sparse warnings related to lock context imbalance.
> > > 
> > > This fixes the following warnings:
> > > 
> > > drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c:153:5: warning: context imbalance in 'cfs_trace_lock_tcd' - wrong count at exit
> > > drivers/staging/lustre/lustre/libcfs/hash.c:128:1: warning: context imbalance in 'cfs_hash_spin_lock' - wrong count at exit
> > > drivers/staging/lustre/lustre/libcfs/hash.c:142:9: warning: context imbalance in 'cfs_hash_rw_lock' - wrong count at exit
> > > drivers/staging/lustre/lustre/ptlrpc/../../lustre/ldlm/l_lock.c:57:17: warning: context imbalance in 'lock_res_and_lock' - wrong count at exit
> > > drivers/staging/lustre/lustre/libcfs/libcfs_lock.c:93:1: warning: context imbalance in 'cfs_percpt_lock' - wrong count at exit
> > > 
> > > Signed-off-by: Loic Pefferkorn <loic@loicp.eu>
> > > ---
> > >  drivers/staging/lustre/lustre/libcfs/hash.c                  | 4 ++++
> > >  drivers/staging/lustre/lustre/libcfs/libcfs_lock.c           | 2 ++
> > >  drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c | 2 ++
> > >  drivers/staging/lustre/lustre/obdclass/cl_object.c           | 2 ++
> > >  4 files changed, 10 insertions(+)
> > > 
> > > diff --git a/drivers/staging/lustre/lustre/libcfs/hash.c b/drivers/staging/lustre/lustre/libcfs/hash.c
> > > index 32da783..7c6e2a3 100644
> > > --- a/drivers/staging/lustre/lustre/libcfs/hash.c
> > > +++ b/drivers/staging/lustre/lustre/libcfs/hash.c
> > > @@ -126,18 +126,21 @@ cfs_hash_nl_unlock(union cfs_hash_lock *lock, int exclusive) {}
> > >  
> > >  static inline void
> > >  cfs_hash_spin_lock(union cfs_hash_lock *lock, int exclusive)
> > > +	__acquires(&lock->spin)
> > >  {
> > >  	spin_lock(&lock->spin);
> > >  }
> > >  
> > >  static inline void
> > >  cfs_hash_spin_unlock(union cfs_hash_lock *lock, int exclusive)
> > > +	__releases(&lock->spin)
> > >  {
> > >  	spin_unlock(&lock->spin);
> > >  }
> > 
> > Ugh, how horrid, please just delete these functions and push down the
> > spin_lock/unlock calls down into the places these are called.
> 
> cfs_hash_spin_lock() and cfs_hash_spin_unlock() are referenced by function pointers later in the same file:
> 
> 165 /** no bucket lock, one spinlock to protect everything */
> 166 static cfs_hash_lock_ops_t cfs_hash_nbl_lops = {
> 167     .hs_lock        = cfs_hash_spin_lock,
> 168     .hs_unlock      = cfs_hash_spin_unlock,
> 169     .hs_bkt_lock    = cfs_hash_nl_lock,
> 170     .hs_bkt_unlock  = cfs_hash_nl_unlock,
> 171 };
> 172 
> 173 /** spin bucket lock, rehash is enabled */
> 174 static cfs_hash_lock_ops_t cfs_hash_bkt_spin_lops = {
> 175     .hs_lock        = cfs_hash_rw_lock,
> 176     .hs_unlock      = cfs_hash_rw_unlock,
> 177     .hs_bkt_lock    = cfs_hash_spin_lock,
> 178     .hs_bkt_unlock  = cfs_hash_spin_unlock,
> 179 };

That's even worse than I imagined.  Putting sparse markings on these
function calls is just papering over nonsense.  Please work on unwinding
the mess so that you don't need callbacks for locks, that is an
abstraction that isn't needed.

> > >  static inline void
> > >  cfs_hash_rw_lock(union cfs_hash_lock *lock, int exclusive)
> > > +	__acquires(&lock->rw)
> > >  {
> > >  	if (!exclusive)
> > >  		read_lock(&lock->rw);
> > > @@ -147,6 +150,7 @@ cfs_hash_rw_lock(union cfs_hash_lock *lock, int exclusive)
> > >  
> > >  static inline void
> > >  cfs_hash_rw_unlock(union cfs_hash_lock *lock, int exclusive)
> > > +	__releases(&lock->rw)
> > >  {
> > >  	if (!exclusive)
> > >  		read_unlock(&lock->rw);
> > 
> > 
> > Same for these.
> 
> Likewise for cfs_hash_rw_lock() and cfs_hash_rw_unlock():
> 
> 173 /** spin bucket lock, rehash is enabled */
> 174 static cfs_hash_lock_ops_t cfs_hash_bkt_spin_lops = {
> 175         .hs_lock        = cfs_hash_rw_lock,
> 176         .hs_unlock      = cfs_hash_rw_unlock,
> 177         .hs_bkt_lock    = cfs_hash_spin_lock,
> 178         .hs_bkt_unlock  = cfs_hash_spin_unlock,
> 179 };
> 180 
> 181 /** rw bucket lock, rehash is enabled */
> 182 static cfs_hash_lock_ops_t cfs_hash_bkt_rw_lops = {
> 183         .hs_lock        = cfs_hash_rw_lock,
> 184         .hs_unlock      = cfs_hash_rw_unlock,
> 185         .hs_bkt_lock    = cfs_hash_rw_lock,
> 186         .hs_bkt_unlock  = cfs_hash_rw_unlock,
> 187 };

Same here, ick ick ick.

> > > diff --git a/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c b/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
> > > index 2c199c7..1e529fc 100644
> > > --- a/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
> > > +++ b/drivers/staging/lustre/lustre/libcfs/libcfs_lock.c
> > > @@ -91,6 +91,7 @@ EXPORT_SYMBOL(cfs_percpt_lock_alloc);
> > >   */
> > >  void
> > >  cfs_percpt_lock(struct cfs_percpt_lock *pcl, int index)
> > > +	__acquires(pcl->pcl_locks[index])
> > >  {
> > >  	int	ncpt = cfs_cpt_number(pcl->pcl_cptab);
> > >  	int	i;
> > > @@ -125,6 +126,7 @@ EXPORT_SYMBOL(cfs_percpt_lock);
> > >  /** unlock a CPU partition */
> > >  void
> > >  cfs_percpt_unlock(struct cfs_percpt_lock *pcl, int index)
> > > +	__releases(pcl->pcl_locks[index])
> > >  {
> > >  	int	ncpt = cfs_cpt_number(pcl->pcl_cptab);
> > >  	int	i;
> > > diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
> > > index 976c61e..257669b 100644
> > > --- a/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
> > > +++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-tracefile.c
> > > @@ -151,6 +151,7 @@ cfs_trace_buf_type_t cfs_trace_buf_idx_get(void)
> > >   * for details.
> > >   */
> > >  int cfs_trace_lock_tcd(struct cfs_trace_cpu_data *tcd, int walking)
> > > +	__acquires(&tcd->tc_lock)
> > >  {
> > >  	__LASSERT(tcd->tcd_type < CFS_TCD_TYPE_MAX);
> > >  	if (tcd->tcd_type == CFS_TCD_TYPE_IRQ)
> > > @@ -165,6 +166,7 @@ int cfs_trace_lock_tcd(struct cfs_trace_cpu_data *tcd, int walking)
> > >  }
> > >  
> > >  void cfs_trace_unlock_tcd(struct cfs_trace_cpu_data *tcd, int walking)
> > > +	__releases(&tcd->tcd_lock)
> > >  {
> > >  	__LASSERT(tcd->tcd_type < CFS_TCD_TYPE_MAX);
> > >  	if (tcd->tcd_type == CFS_TCD_TYPE_IRQ)
> > > diff --git a/drivers/staging/lustre/lustre/obdclass/cl_object.c b/drivers/staging/lustre/lustre/obdclass/cl_object.c
> > > index ce96bd2..8577f97 100644
> > > --- a/drivers/staging/lustre/lustre/obdclass/cl_object.c
> > > +++ b/drivers/staging/lustre/lustre/obdclass/cl_object.c
> > > @@ -193,6 +193,7 @@ static spinlock_t *cl_object_attr_guard(struct cl_object *o)
> > >   * cl_object_attr_get(), cl_object_attr_set().
> > >   */
> > >  void cl_object_attr_lock(struct cl_object *o)
> > > +	__acquires(cl_object_attr_guard(o))
> > >  {
> > >  	spin_lock(cl_object_attr_guard(o));
> > >  }
> > > @@ -202,6 +203,7 @@ EXPORT_SYMBOL(cl_object_attr_lock);
> > >   * Releases data-attributes lock, acquired by cl_object_attr_lock().
> > >   */
> > >  void cl_object_attr_unlock(struct cl_object *o)
> > > +	__releases(cl_object_attr_guard(o))
> > >  {
> > >  	spin_unlock(cl_object_attr_guard(o));
> > >  }
> > 
> > Same thing here.
> 
> These ones are easy to replace, but the naming scheme of all functions in cl_object.c is consistent,
> from my point of view it ease code reading where they are called, for example in lustre/lustre/osc/osc_request.c:
> 
> before:
> 
> 1827         if (valid != 0) {
> 1828             cl_object_attr_lock(obj);
> 1829             cl_object_attr_set(env, obj, attr, valid);
> 1830             cl_object_attr_unlock(obj);
> 
> after:
> 
> 1827         if (valid != 0) {
> 1828             spin_lock(cl_object_attr_guard(obj));
> 1829             cl_object_attr_set(env, obj, attr, valid);
> 1830             spin_unlock(cl_object_attr_guard(obj));
> 
> 
> But I'm here for learning, and I would be grateful to have your opinion.

Don't hide "implementation of locks" in functions like this, it only
causes problems.  This code has layers of layers of layers of
abstractions due to it wanting to be originally ported to other
operating systems and lots of different kernel versions of Linux itself.
Unwinding and removing those layers is a good thing to do, don't paper
over the nonsense by putting sparse markings on pointless functions.

thanks,

greg k-h
