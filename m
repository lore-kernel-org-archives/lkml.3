Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaGaDSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 23:18:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932096AbaGaDSQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 23:18:16 -0400
Date: Thu, 31 Jul 2014 13:18:05 +1000
From: NeilBrown <neilb@suse.de>
To: Abhi Das <adas@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: [RFC PATCH 0/2] dirreadahead system call
Message-ID: <20140731131805.5280c697@notabene.brown>
In-Reply-To: <1406309851-10628-1-git-send-email-adas@redhat.com>
References: <1406309851-10628-1-git-send-email-adas@redhat.com>
X-Mailer: Claws Mail 3.10.1-123-gae895c (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/DpDtpqMsgxApO/fL3Qi4fE+"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DpDtpqMsgxApO/fL3Qi4fE+
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jul 2014 12:37:29 -0500 Abhi Das <adas@redhat.com> wrote:

> This system call takes 3 arguments:
> fd      - file descriptor of the directory being readahead
> *offset - offset in dir from which to resume. This is updated
>           as we move along in the directory
> count   - The max number of entries to readahead
>=20
> The syscall is supposed to read upto 'count' entries starting at
> '*offset' and cache the inodes corresponding to those entries. It
> returns a negative error code or a positive number indicating
> the number of inodes it has issued readaheads for. It also
> updates the '*offset' value so that repeated calls to dirreadahead
> can resume at the right location. Returns 0 when there are no more
> entries left.

Hi Abhi,

 I like the idea of enhanced read-ahead on a directory.
 It isn't clear to me why you have included these particular fields in the
 interface though.

 - why have an 'offset'?  Why not just use the current offset of the
   directory 'fd'?
 - Why have a count?  How would a program choose what count to give?

 Maybe you imagine using 'getdents' first to get a list of names, then
 selectively calling 'dirreadahead'  on the offsets of the names you are
 interested it?  That would be racy as names can be added and removed which
 might change offsets.  So maybe you have another reason?

 I would like to suggest an alternate interface (I love playing the API
 game....).

 1/ Add a flag to 'fstatat'  AT_EXPECT_MORE.
    If the pathname does not contain a '/', then the 'dirfd' is marked
    to indicate that stat information for all names returned by getdents wi=
ll
    be wanted.  The filesystem can choose to optimise that however it sees
    fit.

 2/ Add a flag to 'fstatat'  AT_NONBLOCK.
    This tells the filesystem that you want this information, so if it can
    return it immediately it should, and if not it should start pulling it
    into cache.  Possibly this should be two flags: AT_NONBLOCK just avoids
    any IO, and AT_ASYNC instigates IO even if NONBLOCK is set.

 Then an "ls -l" could use AT_EXPECT_MORE and then just stat each name.
 An "ls -l *.c", might avoid AT_EXPECT_MORE, but would use AT_NONBLOCK
 against all names, then try again with all the names that returned
 EWOULDBLOCK the first time.


 I would really like to see the 'xstat' syscall too, but there is no point
 having both "xstat" and "fxstat".  Follow the model of "fstatat" and provi=
de
 just "fxstatat" which can do both.
 With fxstatat, AT_EXPECT_MORE would tell the dirfd exactly which attributes
 would be wanted so it can fetch only that which is desired.

 I'm not very keen on the xgetdents idea of including name information and
 stat information into the one syscall - I would prefer getdents and xstat =
be
 kept separate.  Of course if a genuine performance cost of the separate can
 be demonstrated, I could well change my mind.

 It does, however, have the advantage that the kernel doesn't need to worry
 about how long read-ahead data needs to be kept, and the application doesn=
't
 need to worry about how soon to retry an fstatat which failed with
 EWOULDBLOCK.

Thanks for raising this issue again.  I hope it gets fixed one day...

NeilBrown

--Sig_/DpDtpqMsgxApO/fL3Qi4fE+
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU9m1bTnsnt1WYoG5AQI3JA//ZiEwigW8+Zb714jj2JtGCgUWR+5oLvWl
zXqLleNS3qLE84/Ju+EjWhzU1xsvKSK0MA0phAP/QNaVBEQUUyi25Yj0Vp+HfY+l
lMJOG415RcQUGH0Q5U8ezgWmYlM3OFAWr6iKwjFri9PPiAy5XmpS4NlzP5iPmc8y
ix/p2xzRNOydY6IS0XxHaV1xHxDuf+hN6ZGLD6vh3LJ2Y4TzOIGE5rhaF0ntu4+F
KVLQlfSPYFQerL3NO6CtnEonRdl7gr7dPmWfyMM+jyfpmvjWXWQICQiMOJ7a3ecf
AVCvC6DOhlRyzo8FKdAwlWWf2DXaoq5+qb6sxkegAbv+GFYPZwCW5Umn9K4ikTsz
bJWCIsRq5dyTYtACGYnzwdx897AbnpN737qpSQnSSQi+d5ek56zEQtDM8RM2irwz
RJWuCjZBw3ZoeoyPSSBARI7Md3vSOTiN8UfcbMSlanO6Vi0HQ6JWAAH7IwNFQqkZ
zM1jDEhrlPOxr/0AmkQTmwnKUfJ7MkiNBXrXz+bgKqkfTXVw2cDhcwaWvfMS5ZOo
CRnAWvpkNGeitM7p3TxXK7elMLlkE4P6fTKxWx3FCWesyYPCPF+WWRHnQx3dDCwV
Ir981c/UyT+iW4JGf6OezOhEd9ez8kVCzxBPBOS25x1w4c0LLvJNkaw6pUp4+pG8
lcOcjdcWRAU=
=dAZW
-----END PGP SIGNATURE-----

--Sig_/DpDtpqMsgxApO/fL3Qi4fE+--
