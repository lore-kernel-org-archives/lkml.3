Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab3BEPyK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:54:10 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55167 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858Ab3BEPyF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:54:05 -0500
X-Mailer: exmh version 2.8.0 04/21/2012 with nmh-1.4-dev
To: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hillf Danton <dhillf@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: next-20130117 - kernel BUG with aio
In-Reply-To: Your message of "Thu, 31 Jan 2013 16:37:27 -0800."
             <20130201003727.GK12631@moria.home.lan>
From: Valdis.Kletnieks@vt.edu
References: <3544.1358774694@turing-police.cc.vt.edu> <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com> <2553.1358890098@turing-police.cc.vt.edu> <20130131135952.77cf5d3a.akpm@linux-foundation.org>
            <20130201003727.GK12631@moria.home.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1360079580_2221P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 05 Feb 2013 10:53:00 -0500
Message-ID: <5602.1360079580@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020203.51112ADE.0001,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1360079580_2221P
Content-Type: text/plain; charset=us-ascii

On Thu, 31 Jan 2013 16:37:27 -0800, Kent Overstreet said:
> On Thu, Jan 31, 2013 at 01:59:52PM -0800, Andrew Morton wrote:
> > Did this get fixed?

> With the patches I sent you, yes - not seeing a new linux-next tree yet?

Well, it's a mixed bag at my end.  Finally got a chance to do some more
testing, and:

1) next-20130128 didn't show anything in dmesg, but my VirtualBox Windows 7
images appear to livelock on the way up - the Windows throbber would keep
going, but it never made any actual progress towards booting. (Part of the
delay was fixing a next-20121224 environment, and then discovering it
took Windows *two* reboot cycles to get its act back together after getting
into that hung state).

2_ next-20130128 plus the following 3 patches:

Subject: [PATCH 1/3] aio: Fix a null pointer deref in batch_complete_aio
Subject: [PATCH 3/3] aio-use-cancellation-list-lazily-fix
Subject: [PATCH 2/3] aio-kill-ki_retry-fix-fix

VirtualBox appears to be functional (I did 2 complete boot/shutdown
sequences of both a 32-bit and 64-bit Win7 Enterprise image). *HOWEVER*,
I saw 3 of these in dmesg:

[  668.278624] WARNING: at fs/aio.c:348 put_ioctx+0x1c0/0x241()

[  668.278652] Call Trace:
[  668.278660]  [<ffffffff8102ed10>] warn_slowpath_common+0x7c/0x96
[  668.278665]  [<ffffffff8102edc9>] warn_slowpath_null+0x15/0x17
[  668.278669]  [<ffffffff8114c562>] put_ioctx+0x1c0/0x241
[  668.278673]  [<ffffffff8114d42a>] sys_io_destroy+0x4c/0x5c
[  668.278679]  [<ffffffff8160c112>] system_call_fastpath+0x16/0x1b

and the code there says:

        WARN_ON(atomic_read(&ctx->reqs_available) > ctx->nr);

which leaves me wondering exactly how we exited the while loop
just above - is the intention that it loop until reqs_available == ctx->nr
exactly?  Looks like if 'avail' is anything other than exactly 1 in
that while loop, we can be at a state where reqs_avail == (ctx->nr -1),
get 'avail=2', do the atomic_add, fall out of the loop, and trigger
the WARN_ON.

Damned if I see how that can happen though....








--==_Exmh_1360079580_2221P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBUREq3AdmEQWDXROgAQIKuw//f7e6rfYunhFaUp0Zrr25eKJqn8b2CeXB
VaC7ZYnC21He1cyxm96L3GZeuj2VQjIWiPbJ7oEVtXAqn8cZ4O2HG3t+Ps74iBnJ
5NrCf/pf3plm8LOOqoX7jd3IiLqaSUJ5rbSITEOPzsnGPrl5Pe1oLPJmzinslLxf
NHSX9iyZhPht25229TUb+UTG7Do85yoS/RAnexd9XgK8NO0EkDo8Rmfus/0zKi/D
gDuZOSY/aasJZ2fsJKmnmkE6OsAtBsqy+VcM6n0oebaBOIa7C/AiG4mwYYYBTROr
ejajbcPfnEl06ArebIxQlCk87rab/pUy+bsX/iJ7SU34/4BXqZtUhszs5BbkwHDt
Pbi0cRN6zPtx+erG2hkJdWD+QiYAOLsCBxPQy+gAGHniyTdGb5VLRrQz+pPpt5Pg
IugoJd2UVoj+4PBw8afSVYdd4znRZfzBuelstlnYw1e0xnTBfcHQmcV/xGiY+18i
0QvqYSizQW2VP8AkZ96rkHCvLYnbl0flXTT3Nho/g5e6CW69lqY4RDPwPwRi/v2D
2C2cIOUGdqHYn5TM62byXGtmIIGC0RnOPxMy+EXKjBrwmIqP7BUVSGfj1LOp1vZd
ymZV4xguBA5pVBI3z7mzu2iNxywgZ+SUlZa+9B2+AZavdiXBnHDDcTVIpAiMi2V0
rEug9flbyXU=
=Uf5x
-----END PGP SIGNATURE-----

--==_Exmh_1360079580_2221P--

