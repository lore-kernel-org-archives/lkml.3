Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaIPT2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:28:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754468AbaIPT2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:28:21 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
References: <cover.1410810247.git.milosz@adfin.com>
	<c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Sep 2014 15:27:41 -0400
In-Reply-To: <c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
	(Christoph Hellwig's message of "Mon, 15 Sep 2014 16:22:12 -0400")
Message-ID: <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <milosz@adfin.com> writes:

Hrm, you're not Christoph...

> Acked-by: Milosz Tanski <milosz@adfin.com>
> ---
>  fs/ceph/file.c    |    2 ++
>  fs/cifs/file.c    |    6 ++++++
>  fs/nfs/file.c     |    5 ++++-
>  fs/ocfs2/file.c   |    6 ++++++
>  fs/pipe.c         |    3 ++-
>  fs/read_write.c   |   17 +++++++++++------
>  fs/xfs/xfs_file.c |    4 ++++
>  mm/shmem.c        |    4 ++++
>  8 files changed, 39 insertions(+), 8 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 4776257..b62e3a5 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -808,6 +808,8 @@ again:
>  	if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
>  	    (iocb->ki_filp->f_flags & O_DIRECT) ||
>  	    (fi->flags & CEPH_F_SYNC)) {
> +		if (flags & O_NONBLOCK)
> +			return -EAGAIN;

Again, the right return value for the O_DIRECT case is EINVAL.

> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 4072f3a..116bed2 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -170,8 +170,11 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to, int flags)
>  	struct inode *inode = file_inode(iocb->ki_filp);
>  	ssize_t result;
>  
> -	if (iocb->ki_filp->f_flags & O_DIRECT)
> +	if (iocb->ki_filp->f_flags & O_DIRECT) {
> +		if (flags & O_NONBLOCK)
> +			return -EAGAIN;
>  		return nfs_file_direct_read(iocb, to, iocb->ki_pos, true);
> +	}

And here.  I stopped looking for that case at this point.

Cheers,
Jeff
