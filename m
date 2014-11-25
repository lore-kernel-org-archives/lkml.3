Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752AbaKYBUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:20:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaKYBUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:20:14 -0500
Date: Tue, 25 Nov 2014 12:20:03 +1100
From: NeilBrown <neilb@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>, drbd-dev@lists.linbit.com,
        Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 01/10] writeback: move backing_dev_info->state into
 bdi_writeback
Message-ID: <20141125122003.4a3b8369@notabene.brown>
In-Reply-To: <20141120152702.GF2330@quack.suse.cz>
References: <1416299848-22112-1-git-send-email-tj@kernel.org>
	<1416299848-22112-2-git-send-email-tj@kernel.org>
	<20141120152702.GF2330@quack.suse.cz>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KIP4jcuK0Jyq3Rj4b556uz5"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KIP4jcuK0Jyq3Rj4b556uz5
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 20 Nov 2014 16:27:02 +0100 Jan Kara <jack@suse.cz> wrote:

> On Tue 18-11-14 03:37:19, Tejun Heo wrote:
> > Currently, a bdi (backing_dev_info) embeds single wb (bdi_writeback)
> > and the role of the separation is unclear.  For cgroup support for
> > writeback IOs, a bdi will be updated to host multiple wb's where each
> > wb serves writeback IOs of a different cgroup on the bdi.  To achieve
> > that, a wb should carry all states necessary for servicing writeback
> > IOs for a cgroup independently.
> >=20
> > This patch moves bdi->state into wb.
> >=20
> > * enum bdi_state is renamed to wb_state and the prefix of all enums is
> >   changed from BDI_ to WB_.
> >=20
> > * Explicit zeroing of bdi->state is removed without adding zeoring of
> >   wb->state as the whole data structure is zeroed on init anyway.
> >=20
> > * As there's still only one bdi_writeback per backing_dev_info, all
> >   uses of bdi->state are mechanically replaced with bdi->wb.state
> >   introducing no behavior changes.
>   Hum, does it make sense to convert BDI_sync_congested and
> BDI_async_congested? It contains information whether the *device* is
> congested and cannot take more work.

I think the "congested" concept really applies to a "queue", more than a
"device" ... though devices often have internal and external queues so the
concepts blur.

I think the best operational definition would be:
  "congested" - an attempt to add a request to the queue might block
  "not congested" - an attempt to add a request to the queue will not block

Given that, I would much rather do away with the "congested" flag (in the
interface) and allow submit_bio() to be either blocking or non-blocking.
That way you avoid races ("Why did you block, you weren't congested when I
checked moments ago!!??).  But that is getting a bit off-topic.

As 'struct bdi_writeback' contains some lists of inodes which need to be
written, it is a bit like a queue and so could reasonably be "contested" or
not.

Certainly different cgroups would expect different block/don't block
behaviours for the same bdi, so keeping this flag per-cgroup instead of
per-device makes some sense.

NeilBrown



>     I understand that in a cgroup world
> you want to throttle IO from a cgroup to a device so when you take
> bdi_writeback to be a per-cgroup structure you want some indication there
> that a particular cgroup cannot push more to the device. But is it that
> e.g. mdraid cares about a cgroup and not about the device?
>=20
> 								Honza
> >=20
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Jens Axboe <axboe@kernel.dk>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Wu Fengguang <fengguang.wu@intel.com>
> > Cc: drbd-dev@lists.linbit.com
> > Cc: Neil Brown <neilb@suse.de>
> > Cc: Alasdair Kergon <agk@redhat.com>
> > Cc: Mike Snitzer <snitzer@redhat.com>
> > ---
> >  block/blk-core.c               |  1 -
> >  drivers/block/drbd/drbd_main.c | 10 +++++-----
> >  drivers/md/dm.c                |  2 +-
> >  drivers/md/raid1.c             |  4 ++--
> >  drivers/md/raid10.c            |  2 +-
> >  fs/fs-writeback.c              | 14 +++++++-------
> >  include/linux/backing-dev.h    | 24 ++++++++++++------------
> >  mm/backing-dev.c               | 21 ++++++++++-----------
> >  8 files changed, 38 insertions(+), 40 deletions(-)
> >=20
> > diff --git a/block/blk-core.c b/block/blk-core.c
> > index 0421b53..8801682 100644
> > --- a/block/blk-core.c
> > +++ b/block/blk-core.c
> > @@ -584,7 +584,6 @@ struct request_queue *blk_alloc_queue_node(gfp_t gf=
p_mask, int node_id)
> > =20
> >  	q->backing_dev_info.ra_pages =3D
> >  			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
> > -	q->backing_dev_info.state =3D 0;
> >  	q->backing_dev_info.capabilities =3D BDI_CAP_MAP_COPY;
> >  	q->backing_dev_info.name =3D "block";
> >  	q->node =3D node_id;
> > diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_m=
ain.c
> > index 1fc8342..61b00aa 100644
> > --- a/drivers/block/drbd/drbd_main.c
> > +++ b/drivers/block/drbd/drbd_main.c
> > @@ -2360,7 +2360,7 @@ static void drbd_cleanup(void)
> >   * @congested_data:	User data
> >   * @bdi_bits:		Bits the BDI flusher thread is currently interested in
> >   *
> > - * Returns 1<<BDI_async_congested and/or 1<<BDI_sync_congested if we a=
re congested.
> > + * Returns 1<<WB_async_congested and/or 1<<WB_sync_congested if we are=
 congested.
> >   */
> >  static int drbd_congested(void *congested_data, int bdi_bits)
> >  {
> > @@ -2377,14 +2377,14 @@ static int drbd_congested(void *congested_data,=
 int bdi_bits)
> >  	}
> > =20
> >  	if (test_bit(CALLBACK_PENDING, &first_peer_device(device)->connection=
->flags)) {
> > -		r |=3D (1 << BDI_async_congested);
> > +		r |=3D (1 << WB_async_congested);
> >  		/* Without good local data, we would need to read from remote,
> >  		 * and that would need the worker thread as well, which is
> >  		 * currently blocked waiting for that usermode helper to
> >  		 * finish.
> >  		 */
> >  		if (!get_ldev_if_state(device, D_UP_TO_DATE))
> > -			r |=3D (1 << BDI_sync_congested);
> > +			r |=3D (1 << WB_sync_congested);
> >  		else
> >  			put_ldev(device);
> >  		r &=3D bdi_bits;
> > @@ -2400,9 +2400,9 @@ static int drbd_congested(void *congested_data, i=
nt bdi_bits)
> >  			reason =3D 'b';
> >  	}
> > =20
> > -	if (bdi_bits & (1 << BDI_async_congested) &&
> > +	if (bdi_bits & (1 << WB_async_congested) &&
> >  	    test_bit(NET_CONGESTED, &first_peer_device(device)->connection->f=
lags)) {
> > -		r |=3D (1 << BDI_async_congested);
> > +		r |=3D (1 << WB_async_congested);
> >  		reason =3D reason =3D=3D 'b' ? 'a' : 'n';
> >  	}
> > =20
> > diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> > index 58f3927..c4c53af 100644
> > --- a/drivers/md/dm.c
> > +++ b/drivers/md/dm.c
> > @@ -1950,7 +1950,7 @@ static int dm_any_congested(void *congested_data,=
 int bdi_bits)
> >  			 * the query about congestion status of request_queue
> >  			 */
> >  			if (dm_request_based(md))
> > -				r =3D md->queue->backing_dev_info.state &
> > +				r =3D md->queue->backing_dev_info.wb.state &
> >  				    bdi_bits;
> >  			else
> >  				r =3D dm_table_any_congested(map, bdi_bits);
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 40b35be..aad1482 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -739,7 +739,7 @@ int md_raid1_congested(struct mddev *mddev, int bit=
s)
> >  	struct r1conf *conf =3D mddev->private;
> >  	int i, ret =3D 0;
> > =20
> > -	if ((bits & (1 << BDI_async_congested)) &&
> > +	if ((bits & (1 << WB_async_congested)) &&
> >  	    conf->pending_count >=3D max_queued_requests)
> >  		return 1;
> > =20
> > @@ -754,7 +754,7 @@ int md_raid1_congested(struct mddev *mddev, int bit=
s)
> >  			/* Note the '|| 1' - when read_balance prefers
> >  			 * non-congested targets, it can be removed
> >  			 */
> > -			if ((bits & (1<<BDI_async_congested)) || 1)
> > +			if ((bits & (1<<WB_async_congested)) || 1)
> >  				ret |=3D bdi_congested(&q->backing_dev_info, bits);
> >  			else
> >  				ret &=3D bdi_congested(&q->backing_dev_info, bits);
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 32e282f..5180e75 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -915,7 +915,7 @@ int md_raid10_congested(struct mddev *mddev, int bi=
ts)
> >  	struct r10conf *conf =3D mddev->private;
> >  	int i, ret =3D 0;
> > =20
> > -	if ((bits & (1 << BDI_async_congested)) &&
> > +	if ((bits & (1 << WB_async_congested)) &&
> >  	    conf->pending_count >=3D max_queued_requests)
> >  		return 1;
> > =20
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 2d609a5..a797bda 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -62,7 +62,7 @@ struct wb_writeback_work {
> >   */
> >  int writeback_in_progress(struct backing_dev_info *bdi)
> >  {
> > -	return test_bit(BDI_writeback_running, &bdi->state);
> > +	return test_bit(WB_writeback_running, &bdi->wb.state);
> >  }
> >  EXPORT_SYMBOL(writeback_in_progress);
> > =20
> > @@ -94,7 +94,7 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(wbc_writepage);
> >  static void bdi_wakeup_thread(struct backing_dev_info *bdi)
> >  {
> >  	spin_lock_bh(&bdi->wb_lock);
> > -	if (test_bit(BDI_registered, &bdi->state))
> > +	if (test_bit(WB_registered, &bdi->wb.state))
> >  		mod_delayed_work(bdi_wq, &bdi->wb.dwork, 0);
> >  	spin_unlock_bh(&bdi->wb_lock);
> >  }
> > @@ -105,7 +105,7 @@ static void bdi_queue_work(struct backing_dev_info =
*bdi,
> >  	trace_writeback_queue(bdi, work);
> > =20
> >  	spin_lock_bh(&bdi->wb_lock);
> > -	if (!test_bit(BDI_registered, &bdi->state)) {
> > +	if (!test_bit(WB_registered, &bdi->wb.state)) {
> >  		if (work->done)
> >  			complete(work->done);
> >  		goto out_unlock;
> > @@ -1007,7 +1007,7 @@ static long wb_do_writeback(struct bdi_writeback =
*wb)
> >  	struct wb_writeback_work *work;
> >  	long wrote =3D 0;
> > =20
> > -	set_bit(BDI_writeback_running, &wb->bdi->state);
> > +	set_bit(WB_writeback_running, &wb->state);
> >  	while ((work =3D get_next_work_item(bdi)) !=3D NULL) {
> > =20
> >  		trace_writeback_exec(bdi, work);
> > @@ -1029,7 +1029,7 @@ static long wb_do_writeback(struct bdi_writeback =
*wb)
> >  	 */
> >  	wrote +=3D wb_check_old_data_flush(wb);
> >  	wrote +=3D wb_check_background_flush(wb);
> > -	clear_bit(BDI_writeback_running, &wb->bdi->state);
> > +	clear_bit(WB_writeback_running, &wb->state);
> > =20
> >  	return wrote;
> >  }
> > @@ -1049,7 +1049,7 @@ void bdi_writeback_workfn(struct work_struct *wor=
k)
> >  	current->flags |=3D PF_SWAPWRITE;
> > =20
> >  	if (likely(!current_is_workqueue_rescuer() ||
> > -		   !test_bit(BDI_registered, &bdi->state))) {
> > +		   !test_bit(WB_registered, &wb->state))) {
> >  		/*
> >  		 * The normal path.  Keep writing back @bdi until its
> >  		 * work_list is empty.  Note that this path is also taken
> > @@ -1211,7 +1211,7 @@ void __mark_inode_dirty(struct inode *inode, int =
flags)
> >  			spin_unlock(&inode->i_lock);
> >  			spin_lock(&bdi->wb.list_lock);
> >  			if (bdi_cap_writeback_dirty(bdi)) {
> > -				WARN(!test_bit(BDI_registered, &bdi->state),
> > +				WARN(!test_bit(WB_registered, &bdi->wb.state),
> >  				     "bdi-%s not registered\n", bdi->name);
> > =20
> >  				/*
> > diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> > index 5da6012..a356ccd 100644
> > --- a/include/linux/backing-dev.h
> > +++ b/include/linux/backing-dev.h
> > @@ -25,13 +25,13 @@ struct device;
> >  struct dentry;
> > =20
> >  /*
> > - * Bits in backing_dev_info.state
> > + * Bits in bdi_writeback.state
> >   */
> > -enum bdi_state {
> > -	BDI_async_congested,	/* The async (write) queue is getting full */
> > -	BDI_sync_congested,	/* The sync queue is getting full */
> > -	BDI_registered,		/* bdi_register() was done */
> > -	BDI_writeback_running,	/* Writeback is in progress */
> > +enum wb_state {
> > +	WB_async_congested,	/* The async (write) queue is getting full */
> > +	WB_sync_congested,	/* The sync queue is getting full */
> > +	WB_registered,		/* bdi_register() was done */
> > +	WB_writeback_running,	/* Writeback is in progress */
> >  };
> > =20
> >  typedef int (congested_fn)(void *, int);
> > @@ -49,6 +49,7 @@ enum bdi_stat_item {
> >  struct bdi_writeback {
> >  	struct backing_dev_info *bdi;	/* our parent bdi */
> > =20
> > +	unsigned long state;		/* Always use atomic bitops on this */
> >  	unsigned long last_old_flush;	/* last old data flush */
> > =20
> >  	struct delayed_work dwork;	/* work item used for writeback */
> > @@ -61,7 +62,6 @@ struct bdi_writeback {
> >  struct backing_dev_info {
> >  	struct list_head bdi_list;
> >  	unsigned long ra_pages;	/* max readahead in PAGE_CACHE_SIZE units */
> > -	unsigned long state;	/* Always use atomic bitops on this */
> >  	unsigned int capabilities; /* Device capabilities */
> >  	congested_fn *congested_fn; /* Function pointer if device is md/dm */
> >  	void *congested_data;	/* Pointer to aux data for congested func */
> > @@ -276,23 +276,23 @@ static inline int bdi_congested(struct backing_de=
v_info *bdi, int bdi_bits)
> >  {
> >  	if (bdi->congested_fn)
> >  		return bdi->congested_fn(bdi->congested_data, bdi_bits);
> > -	return (bdi->state & bdi_bits);
> > +	return (bdi->wb.state & bdi_bits);
> >  }
> > =20
> >  static inline int bdi_read_congested(struct backing_dev_info *bdi)
> >  {
> > -	return bdi_congested(bdi, 1 << BDI_sync_congested);
> > +	return bdi_congested(bdi, 1 << WB_sync_congested);
> >  }
> > =20
> >  static inline int bdi_write_congested(struct backing_dev_info *bdi)
> >  {
> > -	return bdi_congested(bdi, 1 << BDI_async_congested);
> > +	return bdi_congested(bdi, 1 << WB_async_congested);
> >  }
> > =20
> >  static inline int bdi_rw_congested(struct backing_dev_info *bdi)
> >  {
> > -	return bdi_congested(bdi, (1 << BDI_sync_congested) |
> > -				  (1 << BDI_async_congested));
> > +	return bdi_congested(bdi, (1 << WB_sync_congested) |
> > +				  (1 << WB_async_congested));
> >  }
> > =20
> >  enum {
> > diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> > index 0ae0df5..62f3b33 100644
> > --- a/mm/backing-dev.c
> > +++ b/mm/backing-dev.c
> > @@ -17,7 +17,6 @@ static atomic_long_t bdi_seq =3D ATOMIC_LONG_INIT(0);
> >  struct backing_dev_info default_backing_dev_info =3D {
> >  	.name		=3D "default",
> >  	.ra_pages	=3D VM_MAX_READAHEAD * 1024 / PAGE_CACHE_SIZE,
> > -	.state		=3D 0,
> >  	.capabilities	=3D BDI_CAP_MAP_COPY,
> >  };
> >  EXPORT_SYMBOL_GPL(default_backing_dev_info);
> > @@ -111,7 +110,7 @@ static int bdi_debug_stats_show(struct seq_file *m,=
 void *v)
> >  		   nr_dirty,
> >  		   nr_io,
> >  		   nr_more_io,
> > -		   !list_empty(&bdi->bdi_list), bdi->state);
> > +		   !list_empty(&bdi->bdi_list), bdi->wb.state);
> >  #undef K
> > =20
> >  	return 0;
> > @@ -298,7 +297,7 @@ void bdi_wakeup_thread_delayed(struct backing_dev_i=
nfo *bdi)
> > =20
> >  	timeout =3D msecs_to_jiffies(dirty_writeback_interval * 10);
> >  	spin_lock_bh(&bdi->wb_lock);
> > -	if (test_bit(BDI_registered, &bdi->state))
> > +	if (test_bit(WB_registered, &bdi->wb.state))
> >  		queue_delayed_work(bdi_wq, &bdi->wb.dwork, timeout);
> >  	spin_unlock_bh(&bdi->wb_lock);
> >  }
> > @@ -333,7 +332,7 @@ int bdi_register(struct backing_dev_info *bdi, stru=
ct device *parent,
> >  	bdi->dev =3D dev;
> > =20
> >  	bdi_debug_register(bdi, dev_name(dev));
> > -	set_bit(BDI_registered, &bdi->state);
> > +	set_bit(WB_registered, &bdi->wb.state);
> > =20
> >  	spin_lock_bh(&bdi_lock);
> >  	list_add_tail_rcu(&bdi->bdi_list, &bdi_list);
> > @@ -365,7 +364,7 @@ static void bdi_wb_shutdown(struct backing_dev_info=
 *bdi)
> > =20
> >  	/* Make sure nobody queues further work */
> >  	spin_lock_bh(&bdi->wb_lock);
> > -	clear_bit(BDI_registered, &bdi->state);
> > +	clear_bit(WB_registered, &bdi->wb.state);
> >  	spin_unlock_bh(&bdi->wb_lock);
> > =20
> >  	/*
> > @@ -543,11 +542,11 @@ static atomic_t nr_bdi_congested[2];
> > =20
> >  void clear_bdi_congested(struct backing_dev_info *bdi, int sync)
> >  {
> > -	enum bdi_state bit;
> > +	enum wb_state bit;
> >  	wait_queue_head_t *wqh =3D &congestion_wqh[sync];
> > =20
> > -	bit =3D sync ? BDI_sync_congested : BDI_async_congested;
> > -	if (test_and_clear_bit(bit, &bdi->state))
> > +	bit =3D sync ? WB_sync_congested : WB_async_congested;
> > +	if (test_and_clear_bit(bit, &bdi->wb.state))
> >  		atomic_dec(&nr_bdi_congested[sync]);
> >  	smp_mb__after_atomic();
> >  	if (waitqueue_active(wqh))
> > @@ -557,10 +556,10 @@ EXPORT_SYMBOL(clear_bdi_congested);
> > =20
> >  void set_bdi_congested(struct backing_dev_info *bdi, int sync)
> >  {
> > -	enum bdi_state bit;
> > +	enum wb_state bit;
> > =20
> > -	bit =3D sync ? BDI_sync_congested : BDI_async_congested;
> > -	if (!test_and_set_bit(bit, &bdi->state))
> > +	bit =3D sync ? WB_sync_congested : WB_async_congested;
> > +	if (!test_and_set_bit(bit, &bdi->wb.state))
> >  		atomic_inc(&nr_bdi_congested[sync]);
> >  }
> >  EXPORT_SYMBOL(set_bdi_congested);
> > --=20
> > 1.9.3
> >=20


--Sig_/KIP4jcuK0Jyq3Rj4b556uz5
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVHPZQznsnt1WYoG5AQLUVw//eVX+Rrn3U6/pY2nh0MxOLyNepqCM50Bg
q6+QF7Z+8n785c82vPz2qGdwKrzTKLNaOPUXNXjnP3pqBoNKWNEg/ve4hy7P+H2/
rNyc06/7oDATwIWB5R52M+xNElbEKt8RD96vta5j9X3yR7F2a+wiu3DuCHI4CZQk
7CDdssWdTQbgamoQrIcbarBF3CuqjsWcy+ee6XwbvCh/r5LOoMBEWzUJkhzfzgGG
ZVWeCGlXWLumuslgiydhTCgsEnPza9pgQI8wYCA8U8jAR2WhaqXOkWpaEy6nPn1Z
KMFvIjlL3nLVlYvtPH+4SErBpbz2O5w+dJii88LiENQQRAoZ5pfcWGi8Pdsiku68
fV3ypXWopp5J+Ad/ixRW1HSF/S1ALB3JGATnm4py07imFnK0DCcfIDchfF5RSFcG
un0txx74lFPHw1FDwyjKKEkKu6lQzR76EyzqT6ZtZJQPPjF4nHIh92/lf5rshdan
0HlMjNQl5IEABN4aPR5Mt8Nrt/kV9xl5FOTAEOkwY5Yc2qVMej0QGA/stPSxKoBW
LJ/8fDm0RZZMfZsXqDbcDXx3GeV7TWYtfvxz2yu0G8aI21b3n/15TxgfJdfahZrR
YCVZi1EKVZRYVfFrDzjmazeRCu7+Hgt4yNNKhPIFcP4Srd977qqgG31iZSDpGTEt
IhHqyJVYIC4=
=mhBx
-----END PGP SIGNATURE-----

--Sig_/KIP4jcuK0Jyq3Rj4b556uz5--
