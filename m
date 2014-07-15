Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbaGOJvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:51:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39118 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039AbaGOJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:51:00 -0400
Date: Tue, 15 Jul 2014 11:50:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Message-ID: <20140715095045.GV9918@twins.programming.kicks-ass.net>
References: <cover.1405074379.git.tim.c.chen@linux.intel.com>
 <1405110784.2970.655.camel@schen9-DESK>
 <20140714101611.GS9918@twins.programming.kicks-ass.net>
 <1405354214.2970.663.camel@schen9-DESK>
 <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
 <20140714191504.GO9918@twins.programming.kicks-ass.net>
 <1405367450.2970.750.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AJ3oM32U01nchLSz"
Content-Disposition: inline
In-Reply-To: <1405367450.2970.750.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AJ3oM32U01nchLSz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 12:50:50PM -0700, Tim Chen wrote:

> There is a generic multi-buffer infrastructure portion that manages
> pulling and queuing jobs on the crypto workqueue, and it is separated out
> in patch 1 of the patchset.

There's one very weird multi-line comment in that patch.

> The other portions are algorithm specific that defines
> algorithm specific data structure and  does the crypto computation=20
> for a particular algorithm, mostly in
> assemblies and C glue code.  The infrastructure code is=20
> meant to be reused for other similar=20
> multi-buffer algorithms.

The flushing part that uses the sched thing is sha1 specific, even
though it strikes me as not being so. Flushing buffers on idle seems
like a 'generic' thing.

> We use nr_running_cpu to check whether there are other tasks running on
> the *current* cpu, (not for another cpu),

And yet, the function allows you do to exactly that..

> to decide if we should flush
> and compute crypto jobs accumulated.  If there's nobody else running,
> we can take advantage of available cpu cycles on the cpu we are running=
=20
> on to do computation on the existing jobs in a SIMD mannner.=20
> Waiting a bit longer may accumulate more jobs to process in parallel
> in a single SIMD instruction, but will have more delay. =20

So you already have an idle notifier (which is x86 only, we should fix
that I suppose), and you then double check there really isn't anything
else running.

How much, if anything, does that second check buy you? There's just not
a single word on that.

Also, there is not a word on the latency vs throughput tradeoff you
make. I can imagine that for very short idle durations you loose, not
win with this thing.

So for now I still see no reason for doing this.

Also, I wonder about SMT, the point of this is to make best use of the
SIMD pipelines, does it still make sense to use siblings at the same
time even though you're running hand crafted ASM to stuff the pipelines
to the brim? Should this thing be SMT aware and not gather queues for
both siblings?

--AJ3oM32U01nchLSz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxPl1AAoJEHZH4aRLwOS69hEP/ijVdpPh1qUhdXCD/dyTioPc
DIiyXLhIkxkYUo5s1Acu4rF4UCHkXDimMd7y0zGKGbkFANf7RAtSxgotM9qBA2MV
hObU4QAXF0OtHv+IEd+jdTY0ZFPNEJknDhmJ2cdrSTVtiXdutuYU6JtgQNuSCQ5F
ZsnjIR5VcBwmO7xdVwmEOK6o9RKdOvDgWr1hDHV3wgKsBAVbnY8FixN3r1UHJZCO
UWq4AvvlKUx4S2YtHcimRD5Z3q31FPP5cH9ckwBh5h0lK/rWl71QLdfKRurge8p8
JjStzRCfxjV9im3+ZxgcqdCsdKbsKjsb9afpBWF627DhiPE6xZj7fbssje3eK9wZ
tUxk3VbZ52noUBFZemzheD8C4DNwQyqbM0lD77qh1Y4973qWaoIfv2YXUmNyBXYy
ANEdKm0ELgaDl+0WTZWN4NBrBrzf7VSUULcfR53AUerhaCJEDut2REUg3iyY7nZi
hTZo1OVhJ2fHkKWUmEGjSJFI7yRaXkgZ9iGcZBknCDQWoiISLSwxY6aMLo8u6Ma/
lD2dKQ0dkm5z1bfaiTcRYgzSDzhA3/hKvYX5Ct5gwkKaUtZDLDkqBJKTN1aSUEKn
ASeqQxOX8FIoGQ/gvC0kII6pUqmk5bOOzZExr0T9G8jJSas085cW7GEkoOSHQ6Q8
5TBaGIl43vAZBg/26qoR
=/5tn
-----END PGP SIGNATURE-----

--AJ3oM32U01nchLSz--
