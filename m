Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbaIOVdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:33:47 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:62484 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310AbaIOVdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:33:45 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_34CBE393-D125-4C22-95F3-1784F3DFB34E"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
Date: Mon, 15 Sep 2014 15:33:47 -0600
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Message-Id: <8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
References: <cover.1410810247.git.milosz@adfin.com>
To: Milosz Tanski <milosz@adfin.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_34CBE393-D125-4C22-95F3-1784F3DFB34E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Sep 15, 2014, at 2:20 PM, Milosz Tanski <milosz@adfin.com> wrote:

> This patcheset introduces an ability to perform a non-blocking read
> from regular files in buffered IO mode. This works by only for those
> filesystems that have data in the page cache.
>=20
> It does this by introducing new syscalls new syscalls readv2/writev2
> and preadv2/pwritev2. These new syscalls behave like the network =
sendmsg,
> recvmsg syscalls that accept an extra flag argument (O_NONBLOCK).

It's too bad that we are introducing yet another new read/write
syscall pair that only allow IO into discontiguous memory regions,
but do not allow a single call to access discontiguous file regions
(i.e. specify a separate file offset for each iov).

Adding syscalls similar to preadv/pwritev() that could take a iovec
that specified the file offset+length in addition to the memory address
would allow efficient scatter-gather IO in a single syscall.  While
that is less critical for local filesystems with small syscall latency,
it is more important for network filesystems, or in the case of
NVRAM-backed filesystems.

Cheers, Andreas

> It's a very common patern today (samba, libuv, etc..) use a large
> threadpool to perform buffered IO operations. They submit the work
> form another thread that performs network IO and epoll or other =
threads
> that perform CPU work. This leads to increased latency for processing,
> esp. in the case of data that's already cached in the page cache.
>=20
> With the new interface the applications will now be able to fetch the
> data in their network / cpu bound thread(s) and only defer to a
> threadpool if it's not there. In our own application (VLDB) we've
> observed a decrease in latency for "fast" request by avoiding =
unnecessary
> queuing and having to swap out current tasks in IO bound work threads.
>=20
> I have co-developed these changes with Christoph Hellwig, a whole lot
> of his fixes went into the first patch in the series (were squashed
> with his approval).
>=20
> I am going to post the perf report in a reply-to to this RFC.
>=20
> Christoph Hellwig (3):
>  documentation updates
>  move flags enforcement to vfs_preadv/vfs_pwritev
>  check for O_NONBLOCK in all read_iter instances
>=20
> Milosz Tanski (4):
>  Prepare for adding a new readv/writev with user flags.
>  Define new syscalls readv2,preadv2,writev2,pwritev2
>  Export new vector IO (with flags) to userland
>  O_NONBLOCK flag for readv2/preadv2
>=20
> Documentation/filesystems/Locking |    4 +-
> Documentation/filesystems/vfs.txt |    4 +-
> arch/x86/syscalls/syscall_32.tbl  |    4 +
> arch/x86/syscalls/syscall_64.tbl  |    4 +
> drivers/target/target_core_file.c |    6 +-
> fs/afs/internal.h                 |    2 +-
> fs/afs/write.c                    |    4 +-
> fs/aio.c                          |    4 +-
> fs/block_dev.c                    |    9 ++-
> fs/btrfs/file.c                   |    2 +-
> fs/ceph/file.c                    |   10 ++-
> fs/cifs/cifsfs.c                  |    9 ++-
> fs/cifs/cifsfs.h                  |   12 ++-
> fs/cifs/file.c                    |   30 +++++---
> fs/ecryptfs/file.c                |    4 +-
> fs/ext4/file.c                    |    4 +-
> fs/fuse/file.c                    |   10 ++-
> fs/gfs2/file.c                    |    5 +-
> fs/nfs/file.c                     |   13 ++--
> fs/nfs/internal.h                 |    4 +-
> fs/nfsd/vfs.c                     |    4 +-
> fs/ocfs2/file.c                   |   13 +++-
> fs/pipe.c                         |    7 +-
> fs/read_write.c                   |  146 =
+++++++++++++++++++++++++++++++------
> fs/splice.c                       |    4 +-
> fs/ubifs/file.c                   |    5 +-
> fs/udf/file.c                     |    5 +-
> fs/xfs/xfs_file.c                 |   12 ++-
> include/linux/fs.h                |   16 ++--
> include/linux/syscalls.h          |   12 +++
> include/uapi/asm-generic/unistd.h |   10 ++-
> mm/filemap.c                      |   34 +++++++--
> mm/shmem.c                        |    6 +-
> 33 files changed, 306 insertions(+), 112 deletions(-)
>=20
> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe =
linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Cheers, Andreas






--Apple-Mail=_34CBE393-D125-4C22-95F3-1784F3DFB34E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVBdbPHKl2rkXzB/gAQIMOw//TkxJL0ltN27POBB8980SlFuLKmuVx25r
xyt5iWWBnq+x7TCfiVKc8L0SxpN2bQasKy1eYibS+7R5Pwm9vo5DwPU7MubNK3pg
pSsMVxisq5wq4556XZ2EO0oYxfOpQC+q/61Fh7POMcqRLw62PGjkP7fd7EWSm/k3
/HR+Hqmy86Ixiya6EMmYzkjYdrxYOyDBV9lhdjxktiXEddMFGaBQDN4txy91uIKa
AjC5jItpxM6xSB+lVitbe6OTT3W4efyO7fidewb+IElBn8k7GtcHkSBYaWSrzReo
/JYPkEC8bzbWqxbYQ/Crd0SBLx/r7ZbtvkPSwBPQ1bqQBo+QLcSQRpMc2sex9pkD
VK7GoeFbPqs9Xs/mWmN9jmhdevc6qV6EOrRpsmgR8sVbgmlvcA5gjBXN5wC+wwV8
l7XTr/OXS0UnOqSh2EM0v6CPxvvPST9duVzz4mt6zLEYevTeKJExw+GHy1D447JQ
cAtbIPPrx46YjMwB9PgopvhyTtm1DoW1lJKkWwe5bbpB8xOyhyS50Q6ZLfqJc9Wx
SwC5CT+HxlAsqsMFtIVaiElq9a3XyUOmOTn6vR8/pQkNe4Jh92UMbFP2lguywn+H
T8kpJ1ph/Gi+NiKwfcIuR/yI/KC8+1j2wJo1rbIk3duTXRSXOdPagKu5M9vyj6a6
ZUDQBoHufi4=
=AdxO
-----END PGP SIGNATURE-----

--Apple-Mail=_34CBE393-D125-4C22-95F3-1784F3DFB34E--
