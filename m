Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaCQWAX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:00:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291AbaCQWAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:00:17 -0400
Date: Tue, 18 Mar 2014 09:00:07 +1100
From: NeilBrown <neilb@suse.de>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: For review: open_by_name_at(2) man page
Message-ID: <20140318090007.3adee3d0@notabene.brown>
In-Reply-To: <53271B69.3000305@gmail.com>
References: <53271B69.3000305@gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eCIPzWk7IjO2aXQk4lh3/Ms"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eCIPzWk7IjO2aXQk4lh3/Ms
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Mar 2014 16:57:29 +0100 "Michael Kerrisk (man-pages)"
<mtk.manpages@gmail.com> wrote:

> Hi Aneesh, (and others)
>=20
> Below is a man page I've written for name_to_handle_at(2) and
> open_by_name_at(2). Would you be willing to review it please,
> and let me know of any corrections/improvements?
>=20
> Thanks,
>=20
> Michael

Thanks for writing this Michael.  The fact that I can only find very small
points to comment on reflects the high quality...


> Otherwise,
> .IR dirfd
> must be a file descriptor that refers to a directory, and
  ^^^^^^^
> .I pathname
> is interpreted relative to that directory.

As you clarify later, "must be" is not correct.  Maybe this is just an issue
of style, in which case you should obviously keep a consistent style across
man pages, but to me it sounds wrong.  I would use "is generally" or simila=
r.



> The
> .IR mountdirfd
> argument is a file descriptor for a directory under
> the mount point with respect to which
> .IR handle
> should be interpreted.

mountdirfd does not have to be for a directory.  It can be for any object in
the filesystem.  And I would say "in", not "under".
If /foo and /foo/bar are both mountpoints, and I want to look up a
filehandle for the filesystem mounted at /foo, then opening "/foo/bar"
wouldn't work even though /foo/bar is "under" /foo.  And opening "/foo" wou=
ld
work even though "/foo" is not under "/foo/" (is it?).

  The
  .IR mountfd
  argument is a file descriptor for any object (file, directory, etc.) in t=
he
  filesystem with respect to which
  .IR handle
  should be interpreted.

??



> .B ESTALE
> The specified
> .I handle
> is no longer valid.

ESTALE is also returned if the filesystem does not support file-handle ->
file mappings.
On filesystems which don't provide export_operations (/sys /proc ubifs
romfs cramfs nfs coda ... several others) name_to_handle_at will produce a
generic handle using the 32 bit inode and 32 bit i_generation.
open_by_name_at given this (or any) filehandle will fail with ESTALE.
I don't know how best to include this in the documentation.  Maybe a note
earlier noting that some filesystems do not support open_by_name_at(), and
you cannot programatically determine which do except by trying.
At the same time note that a file handle can become in valid if a file is
deleted or for any other reason as determined by the filesystem, and that t=
he
error is the same as for when the filesystem doesn't support open_by_name_a=
t.


> For example, one can use the device name in the fifth field of the
> .I mountinfo
> record to search for the corresponding device UUID via the symbolic links=
 in
> .IR /dev/disks/by-uuid .
> (A more comfortable way of obtaining the UUID is to use the
> .\" e.g., http://stackoverflow.com/questions/6748429/using-libblkid-to-fi=
nd-uuid-of-a-partition
> .BR libblkid (3)
> library, which uses the
> .I /sys
> filesystem to obtain the same information.)

Does it?  My understanding from "man libblkid" (it is a while since I've re=
ad
the code) is that it either uses info in /dev/disks/by-* or reads directly
from the block devices (maybe using /sys to find them?) and interprets the
superblock to extract a UUID.



> Now delete and re-create the file with the same inode number;
> .BR open_by_handle_at ()
> recognizes that the file referred to by the file handle no longer exists.
>=20
> .in +4n
> .nf
> $ \fBstat \-\-printf=3D"%i\\n" cecilia.txt\fP       # Display inode numbe=
r=20
> 4072121
> $ \fBecho 'Warum?' > cecilia.txt\fP
> $ \fBstat \-\-printf=3D"%i\\n" cecilia.txt\fP       # Check inode number
> 4072121
> $ \fBsudo ./t_open_by_handle_at < fh\fP
> open_by_handle_at: Stale NFS file handle

Something is very wrong here.
   echo foo > somefile
does not "delete and re-create" the file.  It opens and truncates.
That operation should not invalidate the filehandle on any sane filesystem.


>     if (argc > 1)
>         mount_fd =3D open(argv[1], O_RDONLY | O_DIRECTORY);

O_DIRECTORY is not appropriate, as mentioned earlier.


Thanks,
NeilBrown


--Sig_/eCIPzWk7IjO2aXQk4lh3/Ms
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUydwZznsnt1WYoG5AQLIXhAAocqhRk/0sU3eiIgaN6IXCeVEHgeevYFk
zqLSF+lQ29G5GBkqZCRDYFoAq49gMEuHgGMmMXmxUjIZTG+CeFWkjqm7SX+c+hvJ
OAlxdWxTc1D2qd+lZmnjHQ+944VI4hjPjPrjttCN8xxwfiNq2k2ukDyiz62rasKY
TiXpknehRzwfbBgrg/ZNxHvgFqOJMB5eWvBH7iCDegXVouyNKPT/yMb9bCaGZ9f7
cRpjeR2rMn3tEt+03NVIVYD6Z39XoMu/UlXvlVP56p62KhoFIGnEecGy8ryg8iS2
LLcsKW9wVtvmQP1cN9NWVu3I/m3p/OfifgYE+WTui6NXdMcuT6tZ4E8mHVqXN16I
xRl0YnwL6fZYSCNuieEjH7ezFXArPQAEpIYRHZrmpcD1JnFaHn6uHdJIhWBszVBx
rxgs3pj90wZtc+Nn5yz6bKpYqib3jIf+pcg3Yhun13aNwOhwzGLKxiFMshP/K90P
zMJbaYi/L61vUsBZv1/MIdljYPiUjF0S1P2FVbTT737sRAQkQYGHtHQi0BjMuLfE
LhJos4un65j8qo+6LFkwIviL94t7XvohpQp359FYDJsXXBLIa13o1F0Gc9pg30i8
SqlmcrJnZHDigdekWdC39koA8O+Hvl1z9eV177HpYpaBnmlLWt/JRRl2uD2C7l6t
tpGR9yJ9hTc=
=CtyZ
-----END PGP SIGNATURE-----

--Sig_/eCIPzWk7IjO2aXQk4lh3/Ms--
