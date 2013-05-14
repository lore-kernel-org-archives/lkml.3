Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848Ab3ENQoj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:44:39 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:40709 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3ENQoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:44:37 -0400
Message-ID: <519269F2.1000907@inktank.com>
Date: Tue, 14 May 2013 11:44:34 -0500
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jim Schutt <jaschut@sandia.gov>
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libceph: ceph_pagelist_append might sleep while atomic
References: <1368110565-125922-1-git-send-email-jaschut@sandia.gov>
In-Reply-To: <1368110565-125922-1-git-send-email-jaschut@sandia.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 09:42 AM, Jim Schutt wrote:
> Ceph's encode_caps_cb() worked hard to not call __page_cache_alloc while
> holding a lock, but it's spoiled because ceph_pagelist_addpage() always
> calls kmap(), which might sleep.  Here's the result:

I finally took a close look at this today, Jim.  Sorry
for the delay.

The issue is formatting the reconnect message--which will
hold an arbitrary amount of data and therefore which we'll
need to do some allocation (and kmap) for--in the face of
having to hold the flock spinlock while doing so.

And as you found, ceph_pagelist_addpage(), which is called
by ceph_pagelist_append(), calls kmap() even if it doesn't
need to allocate anything.  This means that despite reserving
the pages, those pages are in the free list and because they'll
need to be the subject of kmap() their preallocation doesn't
help.

Your solution was to pre-allocate a buffer, format the locks
into that buffer while holding the lock, then append the
buffer contents to a pagelist after releasing the lock.  You
check for a changing (increasing) lock count while you format
the locks, which is good.

So...  Given that, I think your change looks good.  It's a shame
we can't format directly into the pagelist buffer but this won't
happen much so it's not a big deal.  I have a few small suggestions,
below.

I do find some byte order bugs though.   They aren't your doing,
but I think they ought to be fixed first, as a separate patch
that would precede this one.  The bug is that the lock counts
that are put into the buffer (num_fcntl_locks and num_flock_locks)
are not properly byte-swapped.  I'll point it out inline
in your code, below.

I'll say that what you have is OK.  Consider my suggestions, and
if you choose not to fix the byte order bugs, please let me know.

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

. . .

> [13501.300419] ceph: mds0 caps renewed
> 
> Fix it up by encoding locks into a buffer first, and when the
> number of encoded locks is stable, copy that into a ceph_pagelist.
> 
> Signed-off-by: Jim Schutt <jaschut@sandia.gov>
> ---
>  fs/ceph/locks.c      |   73 +++++++++++++++++++++++++++++++++----------------
>  fs/ceph/mds_client.c |   62 ++++++++++++++++++++++--------------------
>  fs/ceph/super.h      |    9 +++++-
>  3 files changed, 88 insertions(+), 56 deletions(-)
> 
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index 202dd3d..9a46161 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c

Unrelated, but I noticed that the comment above
ceph_count_locks() is out of date ("BKL").  Maybe
you could fix that.

. . .

> @@ -239,12 +228,48 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
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
> +	}
> +fail:
> +	return err;
> +}
> +
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
> +	int l;
> +
> +	err = ceph_pagelist_append(pagelist, &num_fcntl_locks, sizeof(u32));

This is a bug, but I realize you're preserving the existing
functionality.  The fcntl lock count should be converted to
le32 for over-the-wire format.  (I haven't checked the other
end--if it's not expecting le32, it's got a bug too.)

> +	if (err)
> +		goto fail;
> +
> +	for (l = 0; l < num_fcntl_locks; l++) {
> +		err = ceph_pagelist_append(pagelist, &flocks[l],
> +					   sizeof(struct ceph_filelock));
> +		if (err)
> +			goto fail;
> +	}

I think you can just do a single bigger pagelist append rather
than looping through the entries.  I.e.:

    fcntl_locks = &flocks[0];
    flock_locks = &flocks[num_fcntl_locks];

    size = num_fcntl_locks * sizeof (flocks[0]);
    err = ceph_pagelist_append(pagelist, fcntl_locks, size);
    if (err)
        goto fail;

> +	err = ceph_pagelist_append(pagelist, &num_flock_locks, sizeof(u32));

Same byte order problem here, of course.

> +	if (err)
> +		goto fail;
> +

You can do one pagelist append here too:
    size = num_fcntl_locks * sizeof (flocks[0]);
    err = ceph_pagelist_append(pagelist, flock_locks, size);

> +	for (l = 0; l < num_flock_locks; l++) {
> +		err = ceph_pagelist_append(pagelist,
> +					   &flocks[num_fcntl_locks + l],
> +					   sizeof(struct ceph_filelock));
>  		if (err)
>  			goto fail;
>  	}
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 4f22671..be87c36 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2478,39 +2478,41 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
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
> -			rec.v2.flock_len = (2*sizeof(u32) +
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
> +		if (!flocks)
> +			goto out_free;
> +
> +		lock_flocks();
> +		err = ceph_encode_locks_to_buffer(inode, flocks,
> +						  num_fcntl_locks,
> +						  num_flock_locks);
> +		unlock_flocks();
> +		if (err) {
> +			kfree(flocks);
> +			goto encode_again;
> +		}
> +		/*
> +		 * number of encoded locks is stable, so copy to pagelist
> +		 */
> +		rec.v2.flock_len = (2*sizeof(u32) +

I think this is also the same sort of byte order bug.  I'm really
not sure how (that is, whether) this works.  (I think the sparse
scanner ought to be flagging this.  I haven't checked.)

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

