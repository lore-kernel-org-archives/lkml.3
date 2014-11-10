Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaKJWXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 17:23:09 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:33874 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaKJWXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:23:06 -0500
Content-Type: multipart/signed; boundary="Apple-Mail=_0EBD6F16-4BB7-4BD2-85DD-184A0275DD8C"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <1672873802.9686431.1415590877143.JavaMail.zimbra@redhat.com>
Date: Mon, 10 Nov 2014 15:23:25 -0700
Cc: Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel@redhat.com, Steven Whitehouse <swhiteho@redhat.com>
Message-Id: <A56008A1-6C4D-44A4-BE02-DA28C2FC6DF2@dilger.ca>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca> <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com> <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca> <20140731044909.GR26465@dastard> <351B218B-259B-4066-8E78-0B0EA05D087E@dilger.ca> <20140731235306.GR20518@dastard> <1218263590.8113472.1413868891802.JavaMail.zimbra@redhat.com> <1672873802.9686431.1415590877143.JavaMail.zimbra@redhat.com>
To: Abhijith Das <adas@redhat.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_0EBD6F16-4BB7-4BD2-85DD-184A0275DD8C
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Nov 9, 2014, at 8:41 PM, Abhijith Das <adas@redhat.com> wrote:
>> Hi Dave/all,
>>=20
>> I finally got around to playing with the multithreaded userspace =
readahead
>> idea and the results are quite promising. I tried to mimic what my =
kernel
>> readahead patch did with this userspace program (userspace_ra.c)
>> Source code here:
>> https://www.dropbox.com/s/am9q26ndoiw1cdr/userspace_ra.c?dl=3D0
>>=20
>> Each thread has an associated buffer into which a chunk of directory
>> entries are read in using getdents(). Each thread then sorts the
>> entries in inode number order (for GFS2, this is also their disk
>> block order) and proceeds to cache in the inodes in that order by
>> issuing open(2) syscalls against them.  In my tests, I backgrounded
>> this program and issued an 'ls -l' on the dir in question. I did the
>> same following the kernel dirreadahead syscall as well.
>>=20
>> I did not manage to test out too many parameter combinations for both
>> userspace_ra and SYS_dirreadahead because the test matrix got pretty
>> big and time consuming. However, I did notice that without sorting,
>> userspace_ra did not perform as well in some of my tests. I haven't
>> investigated that, so numbers shown here are all with sorting =
enabled.

One concern is for filesystems where inode order does not necessarily
match the on-disk order.  I believe that filesystems like ext4 and XFS
have matching inode/disk order, but tree-based COW filesystems like
Btrfs do not necessarily preserve this order, so sorting in userspace
will not help and may in fact hurt readahead compared to readdir order.

What filesystem(s) have you tested this besides GFS?

Cheers, Andreas

>> For a directory with 100000 files,
>> a) simple 'ls -l' took 14m11s
>> b) SYS_dirreadahead + 'ls -l' took 3m9s, and
>> c) userspace_ra (1M buffer/thread, 32 threads) took 1m42s
>>=20
>> https://www.dropbox.com/s/85na3hmo3qrtib1/ra_vs_u_ra_vs_ls.jpg?dl=3D0 =
is a
>> graph
>> that contains a few more data points. In the graph, along with data =
for 'ls
>> -l'
>> and SYS_dirreadahead, there are six data series for userspace_ra for =
each
>> directory size (10K, 100K and 200K files). i.e. u_ra:XXX,YYY, where =
XXX is
>> one
>> of (64K, 1M) buffer size and YYY is one of (4, 16, 32) threads.
>>=20
>=20
> Hi,
>=20
> Here are some more numbers for larger directories and it seems like
> userspace readahead scales well and is still a good option.
>=20
> I've chosen the best-performing runs for kernel readahead and =
userspace
> readahead. I have data for runs with different parameters (buffer =
size,
> number of threads, etc) that I can provide, if anybody's interested.
>=20
> The numbers here are total elapsed times for the readahead plus 'ls =
-l'
> operations to complete.
>=20
> 							#files in =
testdir
> 						50k	100k	200k	=
500k	1m
> =
--------------------------------------------------------------------------=
----------
> Readdir 'ls -l'					11	849	=
1873	5024	10365
> Kernel readahead + 'ls -l' (best case)		7	214	=
814	2330	4900
> Userspace MT readahead + 'ls -l' (best case)	12	99	239	=
1351	4761
>=20
> Cheers!
> --Abhi


Cheers, Andreas






--Apple-Mail=_0EBD6F16-4BB7-4BD2-85DD-184A0275DD8C
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBVGE63nKl2rkXzB/gAQJyWg/+PC5OKwtK46iaJ1sQETzv8P42WLC8sy6F
605tgQ1K6fjLzCx98Xl9fKldzeMEw9DbBIfRzbcsZOJzfN6wjsF84SKQ/8zOYl1c
ahB42FTw2czepfvkwG2uv8FmRPwQdslaolS46SHYWvYGw2D3QdJ5/6UPyggsUszY
xPqSMWEJxBIYctbeLtcicINeQW7oWP/FWAyuK4OYYForfobPZqGB+D4m046W4mvl
2VH/B/YGR+xOxcom6zfws2uvrwPyGi3miIZUfAa1QaIukQOjq0GqGgxWtPolXPTo
6PnpseoPxvbpjoEH/GAvypcMNRk767xRMFm5W9qt3andb0LmbmRx04ErHoxqh4fM
sMhGZy34idBxByrT0QPspATL4ezRwS6UqAGyDOdgXwexTFchgcpKR1LlgW19otSm
pMfg5bmEnxznGtJ3kquk46nPzFvWbTgzlOI2B0XcvtzsIMpXsRrSHPI116sH8aQz
GarbvUyy3rzFlnhPCwciW4OaB62e6adhHXIl1vjtGxXowNp6tfqzphKUvFqhPBX/
SYDgksffj77bgRTHKYl6jRzhmfqboIOJhbYMuJu0SJbSwFlxmyDgLlSIOhRv7Dzo
9xf7VmnoLEGy1hHAJxbDne96+4R0jnJ3TPex6xknxM5G8+4DJ0E9KOwZoSet8Ruw
kFiFP6teXUc=
=kp1k
-----END PGP SIGNATURE-----

--Apple-Mail=_0EBD6F16-4BB7-4BD2-85DD-184A0275DD8C--
