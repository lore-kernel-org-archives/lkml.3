Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbaHZVhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:37:16 -0400
Received: from ozlabs.org ([103.22.144.67]:50666 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286AbaHZVhL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:37:11 -0400
Date: Wed, 27 Aug 2014 07:37:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ulrich Obergfell <uobergfe@redhat.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-ID: <20140827073702.0d916839@canb.auug.org.au>
In-Reply-To: <20140826135417.GK49576@redhat.com>
References: <20140826171818.719c4e6a@canb.auug.org.au>
	<20140826135417.GK49576@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/a074Q.fIWt1v59a8t8dyQgR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/a074Q.fIWt1v59a8t8dyQgR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Don,

On Tue, 26 Aug 2014 09:54:17 -0400 Don Zickus <dzickus@redhat.com> wrote:
>
> On Tue, Aug 26, 2014 at 05:18:18PM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> >=20
> > After merging the akpm tree, today's linux-next build (sparc64
> > defconfig) failed like this:
> >=20
> > kernel/built-in.o: In function `proc_dowatchdog':
> > (.text+0x6a620): undefined reference to `watchdog_hardlockup_detector_i=
s_enabled'
> > kernel/built-in.o: In function `proc_dowatchdog':
> > (.text+0x6a6a8): undefined reference to `watchdog_enable_hardlockup_det=
ector'
> > kernel/built-in.o: In function `proc_dowatchdog':
> > (.text+0x6a79c): undefined reference to `watchdog_enable_hardlockup_det=
ector'
> >=20
> > Caused by commit 72355eed4bd7 ("kernel/watchdog.c: control hard lockup
> > detection default").  This build has CONFIG_HAVE_NMI_WATCHDOG=3Dy,
> > CONFIG_HARDLOCKUP_DETECTOR not set.
>=20
> :-(  I was trying to figure out why touch_nmi_watchdog doesn't break the
> same way until I noticed sparc has its own personal implementation of this
> function (instead of using kernel/watchdog.c's version).
>=20
> We are going to have to split the include/linux/nmi.h changes out into its
> own #ifdef area.  I am not sure my brain is quite ready to untangle the
> sparc implementation of the watchdog stuff and try to make it use the
> generic one yet.
>=20
> This patch I believe fixes the compile problem for now.
>=20
> Not sure the proper way to post this or who to send this too.

Send it to Andrew Morton (since he has the original patch) who is cc'd
anyway.  I will put this in linux-next today instead of reverting the
other patches if he doesn't get around to doing another mmotm before
then.

> From: Don Zickus <dzickus@redhat.com>
> Date: Tue, 26 Aug 2014 09:50:21 -0400
> Subject: [PATCH] watchdog, nmi: Fix compile issues on sparc
>=20
> Sparc doesn't use HARDLOCKUP_DETECTOR the same way x86 does.  As a
> result break out the new functions
>=20
> watchdog_hardlockup_detector_is_enabled
> watchdog_enable_hardlockup_detector
>=20
> into their own #if defined area.  This resolves the compile issue
> where CONFIG_NMI_WATCHDOG=3Dy and CONFIG_HARDLOCKUP_DETECTOR is not set
> on sparc.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

> Signed-off-by: Don Zickus <dzickus@redhat.com>
> ---
>  include/linux/nmi.h |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/linux/nmi.h b/include/linux/nmi.h
> index 72aacf4..f82a5bf 100644
> --- a/include/linux/nmi.h
> +++ b/include/linux/nmi.h
> @@ -17,14 +17,18 @@
>  #if defined(CONFIG_HAVE_NMI_WATCHDOG) ||
> defined(CONFIG_HARDLOCKUP_DETECTOR) #include <asm/nmi.h>
>  extern void touch_nmi_watchdog(void);
> -extern void watchdog_enable_hardlockup_detector(bool val);
> -extern bool watchdog_hardlockup_detector_is_enabled(void);
>  #else
>  static inline void touch_nmi_watchdog(void)
>  {
>  	touch_softlockup_watchdog();
>  }
> -static inline void watchdog_enable_hardlockup_detector(bool)
> +#endif
> +
> +#if defined(CONFIG_HARDLOCKUP_DETECTOR)
> +extern void watchdog_enable_hardlockup_detector(bool val);
> +extern bool watchdog_hardlockup_detector_is_enabled(void);
> +#else
> +static inline void watchdog_enable_hardlockup_detector(bool val)
>  {
>  }
>  static inline bool watchdog_hardlockup_detector_is_enabled(void)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/a074Q.fIWt1v59a8t8dyQgR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/P4FAAoJEMDTa8Ir7ZwVsJMQAJTxIVA18NoP8W1JgVQ3Z1sF
srQ3Jcmn2GbYxzBDTx9d3n662K7o0+5uugs4TnBlX8x4MC3pSJkrv9fZkWOTgD66
xpE2xarmWSZO2+fVwzjK0/7fhI+qc9eAweZCIboytcLIhrRCa2cFd6aovhmxR0Ow
zFzbLfdjeXuYFMkAEkeI5ljnZOaLwvJfqGiQRfIwbSllicFbYJpU0FRkLNa+48WU
iKEUev+29bEN5ZqIU5ftWJowY0guu/CzvN5iXTNZcwAxKEOgRm8VbBhmdPcEINl2
0362pMSeSORLh8n2ne9zHnwkP4QojDd1otcs3ti+1Phzp610l1Z2Qy3GztwVnMBn
VBa3fYOfbnDwpNTTJFiB6dUN8cNnAb/unOi2ccCXpyovTVdvPAvoef1HAwIPon9M
zUZ0k7Sw+hJjQV3iPNBCALdAqgIZCEJuB4ejPiY/EfMVkyVacTStkuR8VIvCS6Oy
OwwBZXAdrB/+1LBTdRLPeLS7vVveHZu6v13vOkrEeqCj7Hwe2jLypWkPTX/iN4sh
2QARwpJ66i7Mlh71L33wdzauO0y7Gxz1UTxMbvGGR4vrv7H5Qw1J7H3M9pXr1Vy4
Q02geQQloklnlRJ/S5LmOXYFSrYQRlZyAnOMwgRg1z13RdUJcGSfM4c6CAMd4/6j
NwEqFb3K40WMoFicJFus
=sgAh
-----END PGP SIGNATURE-----

--Sig_/a074Q.fIWt1v59a8t8dyQgR--
