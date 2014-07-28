Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaG1VTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:19:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:56343 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbaG1VTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:19:37 -0400
Content-Type: multipart/signed; boundary="Apple-Mail=_EDC55C45-1FD3-411D-819D-368F853DCA47"; protocol="application/pgp-signature"; micalg=pgp-sha1
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
From: Andreas Dilger <adilger@dilger.ca>
In-Reply-To: <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com>
Date: Mon, 28 Jul 2014 15:19:31 -0600
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        cluster-devel@redhat.com
Message-Id: <7EBB0CF1-6564-4C63-8006-7DEEE8800A19@dilger.ca>
References: <1406309851-10628-1-git-send-email-adas@redhat.com> <CA2BF8AB-6F61-4856-8B0E-9D954BDEB243@dilger.ca> <193414027.14151264.1406551934098.JavaMail.zimbra@redhat.com>
To: Abhijith Das <adas@redhat.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail=_EDC55C45-1FD3-411D-819D-368F853DCA47
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jul 28, 2014, at 6:52 AM, Abhijith Das <adas@redhat.com> wrote:
> OnJuly 26, 2014 12:27:19 AM "Andreas Dilger" <adilger@dilger.ca> =
wrote:
>> Is there a time when this doesn't get called to prefetch entries in
>> readdir() order?  It isn't clear to me what benefit there is of =
returning
>> the entries to userspace instead of just doing the statahead =
implicitly
>> in the kernel?
>>=20
>> The Lustre client has had what we call "statahead" for a while,
>> and similar to regular file readahead it detects the sequential =
access
>> pattern for readdir() + stat() in readdir() order (taking into =
account if
>> ".*"
>> entries are being processed or not) and starts fetching the inode
>> attributes asynchronously with a worker thread.
>=20
> Does this heuristic work well in practice? In the use case we were =
trying to
> address, a Samba server is aware beforehand if it is going to stat all =
the
> inodes in a directory.

Typically this works well for us, because this is done by the Lustre
client, so the statahead is hiding the network latency of the RPCs to
fetch attributes from the server.  I imagine the same could be seen with
GFS2. I don't know if this approach would help very much for local
filesystems because the latency is low.

>> This syscall might be more useful if userspace called readdir() to =
get
>> the dirents and then passed the kernel the list of inode numbers
>> to prefetch before starting on the stat() calls. That way, userspace
>> could generate an arbitrary list of inodes (e.g. names matching a
>> regexp) and the kernel doesn't need to guess if every inode is =
needed.
>=20
> Were you thinking arbitrary inodes across the filesystem or just a =
subset
> from a directory? Arbitrary inodes may potentially throw up locking =
issues.

I was thinking about inodes returned from readdir(), but the syscall
would be much more useful if it could handle arbitrary inodes.  For
example, if directories are small then it may be more efficient to
aggregate inodes from multiple directories for each prefetch syscall.
I can't really think of any locking issues that could exist with
"arbitrary list of inodes" that couldn't be hit by having a directory
with hard links to the same list of inodes, so this is something that
needs to be handled by the filesystem anyway.

Since this would be an advisory syscall (i.e. it doesn't really
return anything and cannot guarantee that all the inodes will be in
memory), then if the filesystem is having trouble prefetching the
inodes (e.g. invalid inode number(s) or lock ordering or contention
issues) it could always bail out and leave it to stat() to actually
fetch the inodes into memory when accessed.

There is no way it would be sane to keep inodes locked in the kernel
after prefetch, in case the "stat" never arrives, so the best it can
do is cache the inodes in memory (on the client for network fs), and
it is possible cache pressure or lock contention drops them from cache.

There are always going to be race conditions even if limited to a
single directory (e.g. another client modifies the inode after calling
dirreadahead(), but before calling stat()) that need to be handled.

I think there are a lot of benefits that could be had by the generic
syscall, possibly similar to what XFS is doing with the "bulkstat"
interfaces that Dave always mentions.  This would be much more so for
cases were you don't want to stat all of the entries in a directory.

> But yeah, as Steve mentioned in a previous email,  limiting the inodes
> readahead in some fashion other than a range in readdir() order is
> something that we are thinking of (list of inodes based on regexps,
> filenames etc). We just chose to do an offset range of the directory
> for a quick, early implementation.



>> As it stands, this syscall doesn't help in anything other than =
readdir
>> order (or of the directory is small enough to be handled in one
>> syscall), which could be handled by the kernel internally already,
>> and it may fetch a considerable number of extra inodes from
>> disk if not every inode needs to be touched.
>=20
> The need for this syscall came up from a specific use case - Samba.
> I'm told that Windows clients like to stat every file in a directory
> as soon as it is read in and this has been a slow operation.

Cheers, Andreas






--Apple-Mail=_EDC55C45-1FD3-411D-819D-368F853DCA47
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIVAwUBU9a+Y3Kl2rkXzB/gAQLdhw//fTI9qhv/x1GH0Ov1c1TI7ixYs85dS/uZ
bAxJFXoxsNJxv8bPtoe1FPQtep/fMiWpotAvQOA7GltDVW8rVsBGmjerVdg5I9EE
cLD6WUszU+R/EEwZbPs+NS4mli4IJJFyCiK1CxA/XsQkfK+bpLk8LuzYnuNcpcbq
V+7lRmT+ksnrZv+bH4b6tkcLVDfIOfY01zbgR2/KlH7EsvFLNBJdrlDIVZjpgw9E
aTyVbEHt2Bh7fNhYhniyGuXgpxIRAn4KedoiodvXIecdfgpCX4IuC5Csaz2S4aKj
YDiV6qT/i31fwTbrWjAF7lunYJ3N+dbf4RGrVw2BULDXGEhMEiAzG6txuq31d+rU
VfPd6kOluAfZA9qDd9BPgr0MRtj1aIC38hBXgPT/f2sn1deWgf5n6ucMvskRFRIr
ffmGXRHLCRu7IbvXWbbLW7C3vOVRJzSzOgAcL7uYwmbxJtC9/hy4nCjO6Xqcfu9h
6+E4XoTl2veLKb/gj/hsJ/vczUdIS8QGe6GoS+z7YmEIy4TJDvVfCP1Tt/2Dp2bH
xpc4WPl4CsWMbOy6km5q6ICiZsbNfU184+cqwu4eD0pkW/ox/llZapisgfg8SLTR
e3VaDA7tJyr6mVKj+9Sqa1C8MVifabrNEIzERDNBuL0TWVKC5rEcoyOo+vMWoipW
JfHWYinmWYs=
=xItN
-----END PGP SIGNATURE-----

--Apple-Mail=_EDC55C45-1FD3-411D-819D-368F853DCA47--
