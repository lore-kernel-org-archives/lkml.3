Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3EPAKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 20:10:09 -0400
Received: from cobra.newdream.net ([66.33.216.30]:36015 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab3EPAKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 20:10:07 -0400
Date: Wed, 15 May 2013 17:10:06 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: Alex Elder <elder@inktank.com>
cc: Jim Schutt <jaschut@sandia.gov>, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ceph: add missing cpu_to_le32() calls when encoding
 a reconnect capability
In-Reply-To: <5193BB40.4000501@inktank.com>
Message-ID: <alpine.DEB.2.00.1305151709120.26171@cobra.newdream.net>
References: <1368635894-114707-1-git-send-email-jaschut@sandia.gov> <1368635894-114707-3-git-send-email-jaschut@sandia.gov> <5193BB40.4000501@inktank.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 May 2013, Alex Elder wrote:
> On 05/15/2013 11:38 AM, Jim Schutt wrote:
> > In his review, Alex Elder mentioned that he hadn't checked that num_fcntl_locks
> > and num_flock_locks were properly decoded on the server side, from a le32
> > over-the-wire type to a cpu type.  I checked, and AFAICS it is done; those
> > interested can consult Locker::_do_cap_update() in src/mds/Locker.cc and
> > src/include/encoding.h in the Ceph server code (git://github.com/ceph/ceph).
> > 
> > I also checked the server side for flock_len decoding, and I believe that
> > also happens correctly, by virtue of having been declared __le32 in
> > struct ceph_mds_cap_reconnect, in src/include/ceph_fs.h.
> > 
> > Signed-off-by: Jim Schutt <jaschut@sandia.gov>
> 
> Looks good, but I'd like to get someone else to confirm
> the other end is doing it right (i.e., expecting little
> endian values).

The server-side endianness conversions are all done through the magic of 
C++ for the __le* types.  Should be good!

sge


> 
> Reviewed-by: Alex Elder <elder@inktank.com>
> 
> > ---
> >  fs/ceph/locks.c      |    7 +++++--
> >  fs/ceph/mds_client.c |    2 +-
> >  2 files changed, 6 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/ceph/locks.c b/fs/ceph/locks.c
> > index ffc86cb..4518313 100644
> > --- a/fs/ceph/locks.c
> > +++ b/fs/ceph/locks.c
> > @@ -206,10 +206,12 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
> >  	int err = 0;
> >  	int seen_fcntl = 0;
> >  	int seen_flock = 0;
> > +	__le32 nlocks;
> >  
> >  	dout("encoding %d flock and %d fcntl locks", num_flock_locks,
> >  	     num_fcntl_locks);
> > -	err = ceph_pagelist_append(pagelist, &num_fcntl_locks, sizeof(u32));
> > +	nlocks = cpu_to_le32(num_fcntl_locks);
> > +	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
> >  	if (err)
> >  		goto fail;
> >  	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
> > @@ -229,7 +231,8 @@ int ceph_encode_locks(struct inode *inode, struct ceph_pagelist *pagelist,
> >  			goto fail;
> >  	}
> >  
> > -	err = ceph_pagelist_append(pagelist, &num_flock_locks, sizeof(u32));
> > +	nlocks = cpu_to_le32(num_flock_locks);
> > +	err = ceph_pagelist_append(pagelist, &nlocks, sizeof(nlocks));
> >  	if (err)
> >  		goto fail;
> >  	for (lock = inode->i_flock; lock != NULL; lock = lock->fl_next) {
> > diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
> > index 4f22671..d9ca152 100644
> > --- a/fs/ceph/mds_client.c
> > +++ b/fs/ceph/mds_client.c
> > @@ -2485,7 +2485,7 @@ static int encode_caps_cb(struct inode *inode, struct ceph_cap *cap,
> >  			lock_flocks();
> >  			ceph_count_locks(inode, &num_fcntl_locks,
> >  					 &num_flock_locks);
> > -			rec.v2.flock_len = (2*sizeof(u32) +
> > +			rec.v2.flock_len = cpu_to_le32(2*sizeof(u32) +
> >  					    (num_fcntl_locks+num_flock_locks) *
> >  					    sizeof(struct ceph_filelock));
> >  			unlock_flocks();
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
