Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaIPTpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:45:55 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:62661 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966AbaIPTpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:45:54 -0400
MIME-Version: 1.0
In-Reply-To: <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
References: <cover.1410810247.git.milosz@adfin.com>
	<c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
	<x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 16 Sep 2014 15:45:52 -0400
Message-ID: <CANP1eJF3Kxj+yOndLLS749bEy6=MmSJ1iBpPn6JPbKN3h3q87g@mail.gmail.com>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
From: Milosz Tanski <milosz@adfin.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not Christoph, we collaborated and he sent me this patch.

On Tue, Sep 16, 2014 at 3:27 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Christoph Hellwig <milosz@adfin.com> writes:
>
> Hrm, you're not Christoph...
>
>> Acked-by: Milosz Tanski <milosz@adfin.com>
>> ---
>>  fs/ceph/file.c    |    2 ++
>>  fs/cifs/file.c    |    6 ++++++
>>  fs/nfs/file.c     |    5 ++++-
>>  fs/ocfs2/file.c   |    6 ++++++
>>  fs/pipe.c         |    3 ++-
>>  fs/read_write.c   |   17 +++++++++++------
>>  fs/xfs/xfs_file.c |    4 ++++
>>  mm/shmem.c        |    4 ++++
>>  8 files changed, 39 insertions(+), 8 deletions(-)
>>
>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>> index 4776257..b62e3a5 100644
>> --- a/fs/ceph/file.c
>> +++ b/fs/ceph/file.c
>> @@ -808,6 +808,8 @@ again:
>>       if ((got & (CEPH_CAP_FILE_CACHE|CEPH_CAP_FILE_LAZYIO)) == 0 ||
>>           (iocb->ki_filp->f_flags & O_DIRECT) ||
>>           (fi->flags & CEPH_F_SYNC)) {
>> +             if (flags & O_NONBLOCK)
>> +                     return -EAGAIN;
>
> Again, the right return value for the O_DIRECT case is EINVAL.
>
>> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
>> index 4072f3a..116bed2 100644
>> --- a/fs/nfs/file.c
>> +++ b/fs/nfs/file.c
>> @@ -170,8 +170,11 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to, int flags)
>>       struct inode *inode = file_inode(iocb->ki_filp);
>>       ssize_t result;
>>
>> -     if (iocb->ki_filp->f_flags & O_DIRECT)
>> +     if (iocb->ki_filp->f_flags & O_DIRECT) {
>> +             if (flags & O_NONBLOCK)
>> +                     return -EAGAIN;
>>               return nfs_file_direct_read(iocb, to, iocb->ki_pos, true);
>> +     }
>
> And here.  I stopped looking for that case at this point.
>
> Cheers,
> Jeff



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
