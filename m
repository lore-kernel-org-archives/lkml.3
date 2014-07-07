Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaGGJab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 05:30:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:48896 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGGJaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 05:30:30 -0400
Date: Mon, 7 Jul 2014 11:30:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Fernando Luis Vazquez Cao <fernando_b1@lab.ntt.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [RFC PATCH 0/8] rework iowait accounting
Message-ID: <20140707093013.GI6758@twins.programming.kicks-ass.net>
References: <53ABE28F.6010402@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Se7r6+WGlSF2mKVG"
Content-Disposition: inline
In-Reply-To: <53ABE28F.6010402@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Se7r6+WGlSF2mKVG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 26, 2014 at 06:06:23PM +0900, Hidetoshi Seto wrote:
> [Request for Comments]
>=20
>   So, as the first step to solve this bunch of problems, I wrote
>   some pseudo codes for review to check my direction. These codes
>   look like usual patch set but !! _NOT_TESTED_COMPLETELY_ !!
>   Now I don't have s390/ia64/ppc test box so I didn't even check
>   these pass the compiler :-p

qemu? It'd be horridly slow I suppose. But you should be able to get a
cross compiler at the least.

>   What I want to do here is:
>=20
>   - record timestamp at the end of iowait (decrement nr_iowait
>     from 1 to 0) and use it for iowait time accounting
>     (This idea is what PeterZ suggested)
>=20
>   - use same strategy for basic tick-accounting, NO_HZ kernel,
>     s390 and other VIRT_CPU_ACCOUNTING architectures.
>=20
>   Still I'm concerning performance impact by changing scheduler
>   core codes and also possible troubles by comparing timestamps
>   from different clocks.

So I don't _think_ the performance impact is _that_ high for x86, can be
worse for others. On x86 we:

 - iowait_start(): was one atomic_inc(), is now still one atomic op --
   raw_spin_lock().

 - iowait_stop(): was one atomic_dec(), is now still one atomic op --
   raw_spin_lock().

The only case we add lots of pain is the remote iowait to 0 case, where
we call ktime_get(). Which gets us to different clocks, what different
clocks?

Also; there's an argument to be made about correctness over performance;
but I feel its a somewhat weak argument since the entire per-cpu iowait
number is still complete bullshit :-)

>   These codes are based on following patch on top of v3.16-rc2:
>     [PATCH] nohz: make updating sleep stats local, add seqcount
>=20
>   I'd like to ask you:
>=20
>     - Do you think if I continue this direction these blueprints
>       would be acceptable change?

Yeah, so this solves the 'simple' problem of making the iowait
accounting nohz invariant, which is 'good'. It doesn't address the
bigger issue of what it all means. But I suppose we can start here.

>     - Or shall we kill iowait completely?

I'm all in favour of less accounting :-) It might upset some people
though, but you have my blessing if you can get it done.

>     - Are there any good workaround or band-aid for stable kernels?

I suppose this is still backportable to any -stable that is still
maintained ;-) Then again, this has been broken for bloody ever, so I
don't suppose its really that urgent.

--Se7r6+WGlSF2mKVG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTumilAAoJEHZH4aRLwOS66xAP/2f1sbsHpSmwFsc4uE3YL68l
nBXLmu9iB4+uXBVCvB75XiGq3Mffl/lxup9g4vr8fV7OmwyVFAQaLCfILLiUaa6p
ipkl+Vxhe2+Wf5yADMeneGn9W8/33pB/eSpTz1JsoiOGElcDyQjnDBIiGx+1AZdo
LtSdauQQruv2boALaKw5Xc+dzFJaxUbxxy71il1DJvvehRrttsjRrLbT1gYM6tew
G3/1/HDMj2bVq69YbDnaKPvfHRw20r3tA0JjbjVP3N9uSa7Vmg/gOaLzEM68/8C7
AsNKlodV0H7MOGg+Q4vXKUh7Pgc6PETzHBa7zxjtYBl2uoLNaE2pr2W+eMJD3xzn
YW9c96HwlfZXjJBWB9oIZsgPnS9rh58lO8CjbQMFoSRL+Wt686HXlDcCov4DVVpB
4/UnPMdg6GjJRKNd3VxzRHAPmbTFUkCI412Bl1nJtFX5nH2vrDvHgOANfGXVD4SE
j/riOJIua5M6p/JEhXdGpWu8zfHlSOAJrh1K4su5Q1HXByummeMhtiEFCQarLFxF
p0basWqaaemF/SApuAmoAhhfWWQ+ndh3pqSfB+OoRSDIQM33XhvNWIcYQLh7Ct3z
wUgDIH/6YHe6a0bAwKXHPlU4gboUIPCvNjK/YddL0tyPbMT1lx/y9HBN8Zt1CJJ0
QH7AM69G8BMC6Hixkv5R
=wezv
-----END PGP SIGNATURE-----

--Se7r6+WGlSF2mKVG--
