Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaC1ISr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:18:47 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:46084 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaC1ISn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:18:43 -0400
Date: Fri, 28 Mar 2014 16:18:27 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Dongsheng Wang <dongsheng.wang@freescale.com>
Cc: fweisbec@gmail.com, James Hogan <james.hogan@imgtec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Peter Zijlstra <peterz@infradead.org>, Helge Deller <deller@gmx.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@au1.ibm.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        jason.jin@freescale.com, scottwood@freescale.com,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org,
        Ingo Molnar <mingo@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH] powerpc/irq: Remove HAVE_IRQ_EXIT_ON_IRQ_STACK feature
 at powerpc platform
Message-ID: <20140328081827.GB2176@pek-khao-d1.corp.ad.wrs.com>
References: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LyciRD1jyfeSSjG0"
Content-Disposition: inline
In-Reply-To: <1395992312-23035-1-git-send-email-dongsheng.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LyciRD1jyfeSSjG0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2014 at 03:38:32PM +0800, Dongsheng Wang wrote:
> From: Wang Dongsheng <dongsheng.wang@freescale.com>
>=20
> If softirq use hardirq stack, we will get kernel painc when a hard irq co=
ming again
> during __do_softirq enable local irq to deal with softirq action. So we n=
eed to switch
> satck into softirq stack when invoke soft irq.
>=20
>  Task--->
> 	| Task stack
> 	|
> 	Interrput->EXCEPTION->do_IRQ->
> 	^			     | Hard irq stack
> 	|			     |
> 	|			     irq_exit->__do_softirq->local_irq_enable--   -->local_irq_disab=
le
> 	|									| Hard irq stack
> 	|									|
> 	|									Interrupt coming again
> 	|		There will get a Interrupt nesting			|
> 	------------------------------------------------------------------------
>=20
> Trace 1: Trap 900
>=20
> Kernel stack overflow in process e8152f40, r1=3De8e05ec0
> CPU: 0 PID: 2399 Comm: image_compress/ Not tainted 3.13.0-rc3-03475-g2e3f=
85b #432
> task: e8152f40 ti: c080a000 task.ti: ef176000
> NIP: c05bec04 LR: c0305590 CTR: 00000010
> REGS: e8e05e10 TRAP: 0901   Not tainted  (3.13.0-rc3-03475-g2e3f85b)

Could you double check if you got the following patch applied?

commit 1a18a66446f3f289b05b634f18012424d82aa63a
Author: Kevin Hao <haokexin@gmail.com>
Date:   Fri Jan 17 12:25:28 2014 +0800

    powerpc: Set the correct ksp_limit on ppc32 when switching to irq stack
   =20
    Guenter Roeck has got the following call trace on a p2020 board:
      Kernel stack overflow in process eb3e5a00, r1=3Deb79df90
      CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19ec=
a00 #4
      task: eb3e5a00 ti: c0616000 task.ti: ef440000
      NIP: c003a420 LR: c003a410 CTR: c0017518
      REGS: eb79dee0 TRAP: 0901   Not tainted (3.13.0-rc8-juniper-00146-g19=
eca00)
      MSR: 00029000 <CE,EE,ME>  CR: 24008444  XER: 00000000
      GPR00: c003a410 eb79df90 eb3e5a00 00000000 eb05d900 00000001 65d87646=
 00000000
      GPR08: 00000000 020b8000 00000000 00000000 44008442
      NIP [c003a420] __do_softirq+0x94/0x1ec
      LR [c003a410] __do_softirq+0x84/0x1ec
      Call Trace:
      [eb79df90] [c003a410] __do_softirq+0x84/0x1ec (unreliable)
      [eb79dfe0] [c003a970] irq_exit+0xbc/0xc8
      [eb79dff0] [c000cc1c] call_do_irq+0x24/0x3c
      [ef441f20] [c00046a8] do_IRQ+0x8c/0xf8
      [ef441f40] [c000e7f4] ret_from_except+0x0/0x18
      --- Exception: 501 at 0xfcda524
          LR =3D 0x10024900
      Instruction dump:
      7c781b78 3b40000a 3a73b040 543c0024 3a800000 3b3913a0 7ef5bb78 48201b=
f9
      5463103a 7d3b182e 7e89b92e 7c008146 <3ba00000> 7e7e9b78 48000014 57ff=
f87f
      Kernel panic - not syncing: kernel stack overflow
      CPU: 0 PID: 2838 Comm: ssh Not tainted 3.13.0-rc8-juniper-00146-g19ec=
a00 #4
      Call Trace:
   =20
    The reason is that we have used the wrong register to calculate the
    ksp_limit in commit cbc9565ee826 (powerpc: Remove ksp_limit on ppc64).
    Just fix it.
   =20
    As suggested by Benjamin Herrenschmidt, also add the C prototype of the
    function in the comment in order to avoid such kind of errors in the
    future.
   =20
    Cc: stable@vger.kernel.org # 3.12
    Reported-by: Guenter Roeck <linux@roeck-us.net>
    Tested-by: Guenter Roeck <linux@roeck-us.net>
    Signed-off-by: Kevin Hao <haokexin@gmail.com>
    Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Thanks,
Kevin

--LyciRD1jyfeSSjG0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTNTBTAAoJEJNY7TDerrFx7NAH/1bkccR7DiBc5nizNIBm3hpf
I3QCc7gqSPT/BgQgUxaxfIbFfhNAZWgvqvKkJPSDSuRss/9zYApkFB7QeO8lgdbY
c3lKhARwjeI4l53WjH8+aQzSqoWFrjxAbnyKFYF5PVhiU+8XZXWAmja4alvwyzqP
7ZTfp2yDE2gfDoAbQow2fY64rziUziTaT8ApNZSCHkjMAThc4mh+q649YOsWcUQg
PWjVxBqBbl8ZemdUwlLkHkStOHc+VXJoBwYK99lyzcscV/Ciypq0coXK2wkrslgf
KpmmhWlLuiyLJrWFuwzytvPgl2+LrT5z+zeUfz+MGjLJLzqTIMRjGPOzsfNJqRQ=
=rHaw
-----END PGP SIGNATURE-----

--LyciRD1jyfeSSjG0--
