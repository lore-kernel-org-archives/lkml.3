Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaCMAQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:16:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56684 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbaCMAQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:16:05 -0400
Date: Thu, 13 Mar 2014 11:15:55 +1100
From: NeilBrown <neilb@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org
Subject: Re: SuSE O_DIRECT|O_NONBLOCK overload
Message-ID: <20140313111555.2f15f19f@notabene.brown>
In-Reply-To: <20140312110015.GA29907@infradead.org>
References: <20140130132620.GA6031@infradead.org>
	<20140130132630.GB6031@infradead.org>
	<x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
	<20140308155240.GA32297@infradead.org>
	<CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
	<531B74B6.4070004@suse.de>
	<20140312102849.GA26509@infradead.org>
	<53203BE5.402@suse.de>
	<20140312110015.GA29907@infradead.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ivbOa3Y6lmci+q5n7EsU3vm"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ivbOa3Y6lmci+q5n7EsU3vm
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 12 Mar 2014 04:00:15 -0700 Christoph Hellwig <hch@infradead.org>
wrote:

> The SLES12 tree has various patches to implement special
> O_DIRECT|O_NONBLOCK semantics for block devices:
>=20
> 	https://gitorious.org/opensuse/kernel-source/source/806eab3e4b02e798c1ae=
942440051f81c822ca35:patches.suse/block-nonblock-causes-failfast
>=20
> this seems genuinely useful and I'd be really happy if people would do
> this work upstream for two reasons:
>=20
>  a) implementing different semantics only in a vendor kernel is a
>     nightmare.  No proper way to document it in the man pages for
>     example, and silent breakage of applications that expect it to be
>     present, or even more nasty not present.
>  b) Which brings us to: we had various issues with adding O_NONBLOCK to
>     files that didn't support it before.  How well was this whole feature
>     tested?


This "feature" was really just a hack because a particular customer needed
something in a particular situation.

At the core of this in my thinking is the 'failfast' BIO flag ... or 'flags'
really because there are now three of them.

They don't seem to be documented or uniformly supported or used much at
all.  dm-multipath uses one, and btrfs uses another.  There could be value =
in
using one or more or something in md but as they aren't documented and could
mean almost anything I have stayed away.
I tried adding some sort of 'failfast' support to md once and I would get
occasional failures from regular sata devices which otherwise appeared to be
working perfectly well.  So it seemed that "fast" was altogether *too* fast.

For a particular customer with some particular hardware there were issues
where that hardware could choose not to respond for extended periods.  So we
modified the driver to accept a 'timeout' module parameter and to cause
REQ_FAILFAST_DEV (I think) requests to fail with -ETIMEDOUT if they could n=
ot
be serviced in that time.

We then modified md to cope with that particular well-defined semantic. And
hacked "O_NONBLOCK" support in so that mdadm could access the device without
the risk of hanging indefinitely.

I would be happy to bring at least some of this functionality into mainline,
but I would need a "FAILFAST" flag that actually meant something useful and
was sufficiently well documented so that if some driver got it wrong, I wou=
ld
be justified in blaming the driver for not meeting the expectations that I
encoded into md.

I think that the FAILFAST flag that I need would do some error recovery but
would be time limited.  Maybe a software TLER (Time Limited Error Recovery).

I also think there should probably be just one FAILFAST flag.  Where it was
the DEV or the TRANSPORT or the DRIVER that failed could be returned in the
error code for any caller that cared.  But as I don't know why the one beca=
me
three I could well be missing something important.


As for testing, only basic "does it function as expected" testing.
Part of the reason for only modifying O_NONBLOCK behaviour where O_DIRECT w=
as
also set was to make it extremely unlikely that any code would use this
feature except code that specifically needed it.

NeilBrown

--Sig_/ivbOa3Y6lmci+q5n7EsU3vm
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUyD4uznsnt1WYoG5AQJdow//dxpHXpgPD38pdlYFUQkFAG86v7lpOeiq
V8/KwEI3gPcyQlWeDGhwh+H8OOYqdgsxaArhA+uGIzSNhnIH1uNYcAodrsOOvLdU
YzafSjU4N76Rm7FsjcMqZju7308DjeNRXLczIE44TX4ABIUBa6iG5YAUbjhEAiSO
sOjUPCT1OovAciZBnJl9cwPWJ0EupuClMARPtFwi5HPjcgRSsz7lGMNG6QBdhHlH
sXIK3u9hqmtjBt2k7SAAZsQnsyEneBUeR8Wrs47nH++K2YcFRQiPqyD4ugoWoVP2
ikonN+gE6vydx7SeZiNgofQG8wYZWC327ExzcoDFvdRlegJFhrF7QNMuypXigO45
xKq0B3yM/nZ0581w/oPCW6GGT1HrmdH6cPB20U/sWq+xOjl5NzE/YhnqMF1q3IWe
h9PpPoCQMGH6trk8qHq66CbW0I/vs7PYM9RRBkuMWUy3kc3TDjm+XHoqSXyvX306
kUHhQRHUqRllK4nPpJxIyMfptSYkXj7iNpdqKcUmkSDtqdFUee8x7JmZ+R0PiJDL
QSKEeuCGl87CbD2HuH2NaEYnfEJVJoThVxVJkg/wtby95M/ddhZ/vp0VHj+1yPGj
z+mSXIAtfXWyIHAV3UmShsLuN7fAYRaqiYhXqesSlkM6hWI1so1La/HzJ57HAOwQ
F+kWCXTer3Y=
=5B4j
-----END PGP SIGNATURE-----

--Sig_/ivbOa3Y6lmci+q5n7EsU3vm--
