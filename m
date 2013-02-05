Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590Ab3BERtb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 12:49:31 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:38735 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018Ab3BERt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 12:49:29 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <dhillf@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: next-20130117 - kernel BUG with aio
In-Reply-To: Your message of "Tue, 05 Feb 2013 09:20:15 -0800."
             <20130205172015.GA27179@google.com>
From: Valdis.Kletnieks@vt.edu
References: <3544.1358774694@turing-police.cc.vt.edu> <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com> <2553.1358890098@turing-police.cc.vt.edu> <20130131135952.77cf5d3a.akpm@linux-foundation.org> <20130201003727.GK12631@moria.home.lan> <5602.1360079580@turing-police.cc.vt.edu>
            <20130205172015.GA27179@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1360086503_2221P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2013 12:48:23 -0500
Message-ID: <16994.1360086503@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.511145E8.00F9,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1360086503_2221P
Content-Type: text/plain; charset=us-ascii

On Tue, 05 Feb 2013 09:20:15 -0800, Kent Overstreet said:
> On Tue, Feb 05, 2013 at 10:53:00AM -0500, Valdis.Kletnieks@vt.edu wrote:
> > On Thu, 31 Jan 2013 16:37:27 -0800, Kent Overstreet said:
> > > On Thu, Jan 31, 2013 at 01:59:52PM -0800, Andrew Morton wrote:
> > > > Did this get fixed?
> >
> > > With the patches I sent you, yes - not seeing a new linux-next tree yet?
> >
> > Well, it's a mixed bag at my end.  Finally got a chance to do some more
> > testing, and:
> >
> > 1) next-20130128 didn't show anything in dmesg, but my VirtualBox Windows 7
> > images appear to livelock on the way up - the Windows throbber would keep
> > going, but it never made any actual progress towards booting. (Part of the
> > delay was fixing a next-20121224 environment, and then discovering it
> > took Windows *two* reboot cycles to get its act back together after getting
> > into that hung state).
> >
> > 2_ next-20130128 plus the following 3 patches:
> >
> > Subject: [PATCH 1/3] aio: Fix a null pointer deref in batch_complete_aio
> > Subject: [PATCH 3/3] aio-use-cancellation-list-lazily-fix
> > Subject: [PATCH 2/3] aio-kill-ki_retry-fix-fix
>
> The "smoosh struct kiocb" patch also needs to be dropped. That causes
> aio_rw_vect_retry() to check ki_nbytes/ki_left after they've been
> overwritten by aio_complete(), which causes it to return an error when
> it shouldn't have, which causes aio_run_iocb() to double complete the
> iocb causing put_reqs_available() to be called twice and the count
> screwed up.

Unfortunately, that's not a clean slam-dunk revert:

[/usr/src/linux-next] patch -p1 -R --dry-run < ~/Downloads/32-32-aio-Smoosh-struct-kiocb.patch
checking file fs/aio.c
Hunk #1 FAILED at 570.
Hunk #2 FAILED at 634.
Hunk #3 FAILED at 1246.
3 out of 3 hunks FAILED
checking file include/linux/aio.h
Hunk #1 succeeded at 31 (offset 11 lines).

Looks like the above 3 patches introduce conflicts. Not sure what the proper
resolution is for some of it. For the first hunk, the smoosh patch has near
line 590:

-       atomic_set(&req->ki_users, 1);
+       memset(req, 0, offsetof(struct kiocb, ki_ctx));
        req->ki_ctx = ctx;
+       atomic_set(&req->ki_users, 1);
        return req;

but after the 3 patches, I have:

        memset(req, 0, offsetof(struct kiocb, ki_ctx));
        req->ki_ctx = ctx;
        atomic_set(&req->ki_users, 2);
        return req;

Easy to fix, except that '2' is too magical for me to understand, so I'm
not sure I want to smash it to a 1 to make the revert easier. :)

--==_Exmh_1360086503_2221P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBURFF5wdmEQWDXROgAQI4xhAAvJCP1BLP9b9PfJpYok19N1E0FmKhAmHc
XMz0d4/8k2RM3KpRTs9/UZyDD3bjzYQ/gB6UUQD9fat9CGMQ4Lzx5KCAOnFyRyh0
CGMMb6NlCzC+ca6QPv44TB6SxUgGygrQzDMiZ65j4ZAvFYNcQktoPzYF+hXGPYOL
Jw3K8Qb3KtCCxg3wo+7Oqlb0WAA5FhFm733U1OV4g0TsLFUTE2S/2/oAqk0Zo3bb
V2TGY8ZBOBgiyiOgy1reKKyUyuVbDSnPkJKQ8xQizq+RYaXJmPnyisjp5zK+ytSB
ofTh0/P4D/P5tnjV39v4VKUTFXaonDes2+ZIGy2yjEXJ73XBhCllZ/2729tLk2v6
d2KVzCZR01EbEfhZLL94DxtROH29P9cwuM1QtoIM2m8bUa2oGLJAyB8AvDP2BQwQ
zJDQYgzLaDb1stTT1LR4lC+ojssRO6r5bKV5XeguLd0r3z00mSFGPG9XREMVgXbf
h5yBElvvPN+NkeDlc7Uk7JC1K8+Huh8wnWJW2c4pGZwKLPO/Q/hGf9hGCqv9o5Xu
x2VR+2K11XrmFg4gSqROJEckUe+ZXez0bjN5P+T7fZ+6FNlNrGZRJJChZ9PJfT3P
gFg0YrlYYNj8FQot3ef2YxGxOrOeb7Zy6sgN+wKDkJyaFzY/c0Sl4stvbsteHrqd
RJo0g4eYJas=
=vAr5
-----END PGP SIGNATURE-----

--==_Exmh_1360086503_2221P--

