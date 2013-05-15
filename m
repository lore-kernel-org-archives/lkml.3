Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932939Ab3EOQns (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 12:43:48 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:35057 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932899Ab3EOQnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 12:43:46 -0400
Message-ID: <5193BB40.4000501@inktank.com>
Date: Wed, 15 May 2013 11:43:44 -0500
From: Alex Elder <elder@inktank.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jim Schutt <jaschut@sandia.gov>
CC: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ceph: add missing cpu_to_le32() calls when encoding
 a reconnect capability
References: <1368635894-114707-1-git-send-email-jaschut@sandia.gov> <1368635894-114707-3-git-send-email-jaschut@sandia.gov>
In-Reply-To: <1368635894-114707-3-git-send-email-jaschut@sandia.gov>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2013 11:38 AM, Jim Schutt wrote:
> In his review, Alex Elder mentioned that he hadn't checked that num_fcntl_locks
> and num_flock_locks were properly decoded on the server side, from a le32
> over-the-wire type to a cpu type.  I checked, and AFAICS it is done; those
> interested can consult Locker::_do_cap_update() in src/mds/Locker.cc and
> src/include/encoding.h in the Ceph server code (git://github.com/ceph/ceph).
> 
> I also checked the server side for flock_len decoding, and I believe that
> also happens correctly, by virtue of having been declared __le32 in
> struct ceph_mds_cap_reconnect, in src/include/ceph_fs.h.
> 
> Signed-off-by: Jim Schutt <jaschut@sandia.gov>

Looks good, but I'd like to get someone else to confirm
the other end is doing it right (i.e., expecting little
endian values).

Reviewed-by: Alex Elder <elder@inktank.com>

> ---
>  fs/ceph/locks.c      |    7 +++++--
>  fs/ceph/mds_client.c |    2 +-
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> index ffc86cb..4518313 100644
> --- a/fs/ceph/locks.c
> +++ b/fs/ceph/locks.c
> @@ -206,10 +206,12 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
>  	int err = 0;
>  	int seen_fcntl = 0;
>  	int seen_flock = 0;
> +	__le32 nlocks;
>  
>  	dout("encoding %d flock and %d fcntl locks", num_flock_locks,
>  	     num_fcntl_locks);
> -	err = ceph_pagelist_append(pagelist, &num_fcntl_locks, sizeof(u32));
> +	nlocks = cpu_to_le32(num_fcntl_locks);
> +	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
>  	if (err)
>  		goto fail;
>  	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
> @@ -229,7 +231,8 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
>  			goto fail;
>  	}
>  
> -	err = ceph_pagelist_append(pagelist, &num_flock_locks, sizeof(u32));
> +	nlocks = cpu_to_le32(num_flock_locks);
> +	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
>  	if (err)
>  		goto fail;
>  	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
> diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> index 4f22671..d9ca152 100644
> --- a/fs/ceph/mds_client.c
> +++ b/fs/ceph/mds_client.c
> @@ -2485,7 +2485,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
>  			lock_flocks();
>  			ceph_count_locks(inode, &num_fcntl_locks,
>  					 &num_flock_locks);
> -			rec.v2.flock_len = (2*sizeof(u32) +
> +			rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
>  					    (num_fcntl_locks+num_flock_locks) *
>  					    sizeof(struct ceph_filelock));
>  			unlock_flocks();
> 

