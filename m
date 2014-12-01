Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaLAL0R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:26:17 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54279 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105AbaLAL0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:26:14 -0500
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: fix suboptimal seek_{data,hole} extents traversial
In-Reply-To: <20141129175255.GC4362@thunk.org>
References: <87egu7k6ym.fsf@openvz.org> <1413552334-32240-1-git-send-email-dmonakhov@openvz.org> <20141125211433.GB28449@thunk.org> <873893id1x.fsf@openvz.org> <20141129175255.GC4362@thunk.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 01 Dec 2014 14:25:46 +0300
Message-ID: <87a937d32d.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Theodore Ts'o <tytso@mit.edu> writes:

> On Fri, Nov 28, 2014 at 06:02:02PM +0300, Dmitry Monakhov wrote:
>> FYI: inline_data feature is fatally broken
>
> Thanks for finding the bugs!
>
>> 2) ext4_inline_data_fiemap(0 ignores start and len arguments from ext4_f=
ilemap()
>>    which obviously result in endless loop for anyone who want to use
>>    fiemap for inline files (which my patch try to do)
>
> Would this have been triggered using filefrag?  I just checked and
> noticed we don't have a filefrag test in xfstests; of course it would
> be impossible to test other than the filefrag -v command successfully
> completed, but maybe it might be worth adding such a test.
This works only because filefrag use big buffer. If one want to call
fiemap with start !=3D 0 it will loop. So we definitely need a regression
test for fiemap. I'll do it.

BTW bug can be spotted even in case of filefrag -v:
#### Create small file with inlined data=20
# echo test > /mnt/f1
#### Now boost it's i_size=20=20
# truncate --size 4096000 /mnt/f1
# filefrag -v /mnt/f1
Filesystem cylinder groups approximately 39
File size of /mnt/f1 is 4096000 (1000 blocks of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected:
 flags:
    0:        0.. 4095999:    2762792..   6858791: 4096000:last,not_aligned=
,inline,eof
    /mnt/f1: 1 extent found
###According to fiemap we are inlined 4Mb data. :)

At this moment I'm testing my patches, I'll send it today.
>
> 	       	     	      	       	      	   - Ted

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBCgAGBQJUfFA6AAoJELhyPTmIL6kBfGMIALqO+os7ix8PBP2dJ+k6z2Gm
9/FYBxvTlcGFZSJoCXpQ6TicVW2L0Ox/aL0C10HdYN93wMAvvjBJqlf42NdsQgei
inXxoiZnFWS8SUktLt5+zPSJJUF8UQsCvviclhS/7jTwUAXahcHOaXc+u1itEztX
AqbwbSTtYsmHFxMQra3x0YYoQ9RyZA/0GO78zjPz8esytBI85D+0Gl1x/ZOKMwE7
6BfppS3jrFcqJNcK2p9MnikHc/2Um5Xd6k99VdKpc5qlpEId+m1rqtwpXjcACtIz
BJGq2g6Q/Qqn6LbDEexaiJ7AbGbyvbihna0Dyqqx02Wzwzly1Vzp63HhB/I8vpM=
=DRVe
-----END PGP SIGNATURE-----
--=-=-=--
