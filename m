Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621Ab3EOQtQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:49:16 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:42637 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758912Ab3EOQtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:49:14 -0400
Message-ID: <5193BC89.6030807@inktank.com>
Date: Wed, 15 May 2013 11:49:13 -0500
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jim Schutt <jaschut@sandia.gov>
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] ceph: ceph_pagelist_append might sleep while atomic
References: <1368635894-114707-1-git-send-email-jaschut@sandia.gov> <1368635894-114707-4-git-send-email-jaschut@sandia.gov>
In-Reply-To: <1368635894-114707-4-git-send-email-jaschut@sandia.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 11:38 AM, Jim Schutt wrote:
> Ceph's encode_caps_cb() worked hard to not call __page_cache_alloc() while
> holding a lock, but it's spoiled because ceph_pagelist_addpage() always
> calls kmap(), which might sleep.  Here's the result:

This looks good to me, but I admit I didn't take as close
a look at it this time.

I appreciate your updating the series to include the things
I mentioned.

I'll commit these for you, and I'll get confirmation on the
byte order thing as well.

Reviewed-by: Alex Elder <elder@inktank.com>


> [13439.295457] ceph: mds0 reconnect start
> [13439.300572] BUG: sleeping function called from invalid context at include/linux/highmem.h:58
> [13439.309243] in_atomic(): 1, irqs_disabled(): 0, pid: 12059, name: kworker/1:1
> [13439.316464] 5 locks held by kworker/1:1/12059:
> [13439.320998]  #0:  (ceph-msgr){......}, at: [<ffffffff810609f8>] process_one_work+0x218/0x480
> [13439.329701]  #1:  ((&(&con->work)->work)){......}, at: [<ffffffff810609f8>] process_one_work+0x218/0x480
> [13439.339446]  #2:  (&s->s_mutex){......}, at: [<ffffffffa046273c>] send_mds_reconnect+0xec/0x450 [ceph]
> [13439.349081]  #3:  (&mdsc->snap_rwsem){......}, at: [<ffffffffa04627be>] send_mds_reconnect+0x16e/0x450 [ceph]
> [13439.359278]  #4:  (file_lock_lock){......}, at: [<ffffffff811cadf5>] lock_flocks+0x15/0x20
> [13439.367816] Pid: 12059, comm: kworker/1:1 Tainted: G        W    3.9.0-00358-g308ae61 #557
> [13439.376225] Call Trace:
> [13439.378757]  [<ffffffff81076f4c>] __might_sleep+0xfc/0x110
> [13439.384353]  [<ffffffffa03f4ce0>] ceph_pagelist_append+0x120/0x1b0 [libceph]
> [13439.391491]  [<ffffffffa0448fe9>] ceph_encode_locks+0x89/0x190 [ceph]
> [13439.398035]  [<ffffffff814ee849>] ? _raw_spin_lock+0x49/0x50
> [13439.403775]  [<ffffffff811cadf5>] ? lock_flocks+0x15/0x20
> [13439.409277]  [<ffffffffa045e2af>] encode_caps_cb+0x41f/0x4a0 [ceph]
> [13439.415622]  [<ffffffff81196748>] ? igrab+0x28/0x70
> [13439.420610]  [<ffffffffa045e9f8>] ? iterate_session_caps+0xe8/0x250 [ceph]
> [13439.427584]  [<ffffffffa045ea25>] iterate_session_caps+0x115/0x250 [ceph]
> [13439.434499]  [<ffffffffa045de90>] ? set_request_path_attr+0x2d0/0x2d0 [ceph]
> [13439.441646]  [<ffffffffa0462888>] send_mds_reconnect+0x238/0x450 [ceph]
> [13439.448363]  [<ffffffffa0464542>] ? ceph_mdsmap_decode+0x5e2/0x770 [ceph]
> [13439.455250]  [<ffffffffa0462e42>] check_new_map+0x352/0x500 [ceph]
> [13439.461534]  [<ffffffffa04631ad>] ceph_mdsc_handle_map+0x1bd/0x260 [ceph]
> [13439.468432]  [<ffffffff814ebc7e>] ? mutex_unlock+0xe/0x10
> [13439.473934]  [<ffffffffa043c612>] extra_mon_dispatch+0x22/0x30 [ceph]
> [13439.480464]  [<ffffffffa03f6c2c>] dispatch+0xbc/0x110 [libceph]
> [13439.486492]  [<ffffffffa03eec3d>] process_message+0x1ad/0x1d0 [libceph]
> [13439.493190]  [<ffffffffa03f1498>] ? read_partial_message+0x3e8/0x520 [libceph]
> [13439.500583]  [<ffffffff81415184>] ? kernel_recvmsg+0x44/0x60
> [13439.506324]  [<ffffffffa03ef3a8>] ? ceph_tcp_recvmsg+0x48/0x60 [libceph]
> [13439.513140]  [<ffffffffa03f2aae>] try_read+0x5fe/0x7e0 [libceph]
> [13439.519246]  [<ffffffffa03f39f8>] con_work+0x378/0x4a0 [libceph]
> [13439.525345]  [<ffffffff8107792f>] ? finish_task_switch+0x3f/0x110
> [13439.531515]  [<ffffffff81060a95>] process_one_work+0x2b5/0x480
> [13439.537439]  [<ffffffff810609f8>] ? process_one_work+0x218/0x480
> [13439.543526]  [<ffffffff81064185>] worker_thread+0x1f5/0x320
> [13439.549191]  [<ffffffff81063f90>] ? manage_workers+0x170/0x170
> [13439.555102]  [<ffffffff81069641>] kthread+0xe1/0xf0
> [13439.560075]  [<ffffffff81069560>] ? __init_kthread_worker+0x70/0x70
> [13439.566419]  [<ffffffff814f7edc>] ret_from_fork+0x7c/0xb0
> [13439.571918]  [<ffffffff81069560>] ? __init_kthread_worker+0x70/0x70
> [13439.587132] ceph: mds0 reconnect success
> [13490.720032] ceph: mds0 caps stale
> [13501.235257] ceph: mds0 recovery completed
> [13501.300419] ceph: mds0 caps renewed
> 
> Fix it up by encoding locks into a buffer first, and when the
> number of encoded locks is stable, copy that into a ceph_pagelist.
> 
> Signed-off-by: Jim Schutt <jaschut@sandia.gov>
> ---
>  fs/ceph/locks.c      |   76 +++++++++++++++++++++++++++++++-------------------
>  fs/ceph/mds_client.c |   65 +++++++++++++++++++++++-------------------
>  fs/ceph/super.h      |    9 ++++-
>  3 files changed, 89 insertions(+), 61 deletions(-)
> 
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 4518313..8978851 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -191,29 +191,23 @@ void ceph_count_locks(struct inode *inode, int *fcntl_count, int *flock_count)
>  }
>  
>  /**
> - * Encode the flock and fcntl locks for the given inode into the pagelist.
> - * Format is: #fcntl locks, sequential fcntl locks, #flock locks,
> - * sequential flock locks.
> - * Must be called with lock_flocks() already held.
> - * If we encounter more of a specific lock type than expected,
> - * we return the value 1.
> + * Encode the flock and fcntl locks for the given inode into the ceph_filelock
> + * array. Must be called with lock_flocks() already held.
> + * If we encounter more of a specific lock type than expected, return -ENOSPC.
>   */
> -int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
> -		      int num_fcntl_locks, int num_flock_locks)
> +int ceph_encode_locks_to_buffer(struct inode *inode,
> +				struct ceph_filelock *flocks,
> +				int num_fcntl_locks, int num_flock_locks)
>  {
>  	struct file_lock *lock;
> -	struct ceph_filelock cephlock;
>  	int err = 0;
>  	int seen_fcntl = 0;
>  	int seen_flock = 0;
> -	__le32 nlocks;
> +	int l = 0;
>  
>  	dout("encoding %d flock and %d fcntl locks", num_flock_locks,
>  	     num_fcntl_locks);
> -	nlocks = cpu_to_le32(num_fcntl_locks);
> -	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
> -	if (err)
> -		goto fail;
> +
>  	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
>  		if (lock->fl_flags & FL_POSIX) {
>  			++seen_fcntl;
> @@ -221,20 +215,12 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
>  				err = -ENOSPC;
>  				goto fail;
>  			}
> -			err = lock_to_ceph_filelock(lock, &cephlock);
> +			err = lock_to_ceph_filelock(lock, &flocks[l]);
>  			if (err)
>  				goto fail;
> -			err = ceph_pagelist_append(pagelist, &cephlock,
> -					   sizeof(struct ceph_filelock));
> +			++l;
>  		}
> -		if (err)
> -			goto fail;
>  	}
> -
> -	nlocks = cpu_to_le32(num_flock_locks);
> -	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
> -	if (err)
> -		goto fail;
>  	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
>  		if (lock->fl_flags & FL_FLOCK) {
>  			++seen_flock;
> @@ -242,19 +228,51 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
>  				err = -ENOSPC;
>  				goto fail;
>  			}
> -			err = lock_to_ceph_filelock(lock, &cephlock);
> +			err = lock_to_ceph_filelock(lock, &flocks[l]);
>  			if (err)
>  				goto fail;
> -			err = ceph_pagelist_append(pagelist, &cephlock,
> -					   sizeof(struct ceph_filelock));
> +			++l;
>  		}
> -		if (err)
> -			goto fail;
>  	}
>  fail:
>  	return err;
>  }
>  
> +/**
> + * Copy the encoded flock and fcntl locks into the pagelist.
> + * Format is: #fcntl locks, sequential fcntl locks, #flock locks,
> + * sequential flock locks.
> + * Returns zero on success.
> + */
> +int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
> +			   struct ceph_pagelist *pagelist,
> +			   int num_fcntl_locks, int num_flock_locks)
> +{
> +	int err = 0;
> +	__le32 nlocks;
> +
> +	nlocks = cpu_to_le32(num_fcntl_locks);
> +	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
> +	if (err)
> +		goto out_fail;
> +
> +	err = ceph_pagelist_append(pagelist, flocks,
> +				   num_fcntl_locks * sizeof(*flocks));
> +	if (err)
> +		goto out_fail;
> +
> +	nlocks = cpu_to_le32(num_flock_locks);
> +	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
> +	if (err)
> +		goto out_fail;
> +
> +	err = ceph_pagelist_append(pagelist,
> +				   &flocks[num_fcntl_locks],
> +				   num_flock_locks * sizeof(*flocks));
> +out_fail:
> +	return err;
> +}
> +
>  /*
>   * Given a pointer to a lock, convert it to a ceph filelock
>   */
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index d9ca152..4d29203 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2478,39 +2478,44 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  
>  	if (recon_state->flock) {
>  		int num_fcntl_locks, num_flock_locks;
> -		struct ceph_pagelist_cursor trunc_point;
> -
> -		ceph_pagelist_set_cursor(pagelist, &trunc_point);
> -		do {
> -			lock_flocks();
> -			ceph_count_locks(inode, &num_fcntl_locks,
> -					 &num_flock_locks);
> -			rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
> -					    (num_fcntl_locks+num_flock_locks) *
> -					    sizeof(struct ceph_filelock));
> -			unlock_flocks();
> -
> -			/* pre-alloc pagelist */
> -			ceph_pagelist_truncate(pagelist, &trunc_point);
> -			err = ceph_pagelist_append(pagelist, &rec, reclen);
> -			if (!err)
> -				err = ceph_pagelist_reserve(pagelist,
> -							    rec.v2.flock_len);
> -
> -			/* encode locks */
> -			if (!err) {
> -				lock_flocks();
> -				err = ceph_encode_locks(inode,
> -							pagelist,
> -							num_fcntl_locks,
> -							num_flock_locks);
> -				unlock_flocks();
> -			}
> -		} while (err == -ENOSPC);
> +		struct ceph_filelock *flocks;
> +
> +encode_again:
> +		lock_flocks();
> +		ceph_count_locks(inode, &num_fcntl_locks, &num_flock_locks);
> +		unlock_flocks();
> +		flocks = kmalloc((num_fcntl_locks+num_flock_locks) *
> +				 sizeof(struct ceph_filelock), GFP_NOFS);
> +		if (!flocks) {
> +			err = -ENOMEM;
> +			goto out_free;
> +		}
> +		lock_flocks();
> +		err = ceph_encode_locks_to_buffer(inode, flocks,
> +						  num_fcntl_locks,
> +						  num_flock_locks);
> +		unlock_flocks();
> +		if (err) {
> +			kfree(flocks);
> +			if (err == -ENOSPC)
> +				goto encode_again;
> +			goto out_free;
> +		}
> +		/*
> +		 * number of encoded locks is stable, so copy to pagelist
> +		 */
> +		rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
> +				    (num_fcntl_locks+num_flock_locks) *
> +				    sizeof(struct ceph_filelock));
> +		err = ceph_pagelist_append(pagelist, &rec, reclen);
> +		if (!err)
> +			err = ceph_locks_to_pagelist(flocks, pagelist,
> +						     num_fcntl_locks,
> +						     num_flock_locks);
> +		kfree(flocks);
>  	} else {
>  		err = ceph_pagelist_append(pagelist, &rec, reclen);
>  	}
> -
>  out_free:
>  	kfree(path);
>  out_dput:
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 8696be2..7ccfdb4 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -822,8 +822,13 @@ extern const struct export_operations ceph_export_ops;
>  extern int ceph_lock(struct file *file, int cmd, struct file_lock *fl);
>  extern int ceph_flock(struct file *file, int cmd, struct file_lock *fl);
>  extern void ceph_count_locks(struct inode *inode, int *p_num, int *f_num);
> -extern int ceph_encode_locks(struct inode *i, struct ceph_pagelist *p,
> -			     int p_locks, int f_locks);
> +extern int ceph_encode_locks_to_buffer(struct inode *inode,
> +				       struct ceph_filelock *flocks,
> +				       int num_fcntl_locks,
> +				       int num_flock_locks);
> +extern int ceph_locks_to_pagelist(struct ceph_filelock *flocks,
> +				  struct ceph_pagelist *pagelist,
> +				  int num_fcntl_locks, int num_flock_locks);
>  extern int lock_to_ceph_filelock(struct file_lock *fl, struct ceph_filelock *c);
>  
>  /* debugfs.c */
> 

