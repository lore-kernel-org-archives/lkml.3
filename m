Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751230AbaLPX5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 18:57:33 -0500
Received: from ozlabs.org ([103.22.144.67]:35796 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbaLPX5a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 18:57:30 -0500
Date: Wed, 17 Dec 2014 10:57:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Hogan <james.hogan@imgtec.com>, Guenter Roeck <linux@roeck-us.net>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>, <linux-metag@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 16
Message-ID: <20141217105722.3ec1fcf5@canb.auug.org.au>
In-Reply-To: <54900D5D.4060509@imgtec.com>
References: <20141216154622.7c2ded16@canb.auug.org.au>
	<20141216063549.GA1060@roeck-us.net>
	<20141215224444.dc7f0f3c.akpm@linux-foundation.org>
	<548FD746.1050904@roeck-us.net>
	<548FFEA0.1060905@imgtec.com>
	<54900D5D.4060509@imgtec.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/f.6feIL.8V6ZFEcZL8DJ=7."; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/f.6feIL.8V6ZFEcZL8DJ=7.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 16 Dec 2014 10:45:49 +0000 James Hogan <james.hogan@imgtec.com> wro=
te:
>
> On 16/12/14 09:42, James Hogan wrote:
> > On 16/12/14 06:55, Guenter Roeck wrote:
> >> On 12/15/2014 10:44 PM, Andrew Morton wrote:
> >>> On Mon, 15 Dec 2014 22:35:49 -0800 Guenter Roeck <linux@roeck-us.net>
> >>> wrote:
> >>>
> >>>> My metag buildbot test fails with this kernel.
> >>>
> >>> Thanks.  What are the error messages?
> >>>
> >> Nothing. It just hangs until killed.
> >>
> >> qemu log:
> >> char device redirected to /dev/pts/5
> >> Unable to load ROM!
> >> qemu: terminating on signal 15 from pid 17843
> >>
> >> http://server.roeck-us.net:8010/builders/qemu-metag-next/builds/60/ste=
ps/qemubuildcommand/logs/stdio
> >=20
> > Thanks a lot Guenter for report and bisection. I've confirmed on real
> > hardware too. I'll try debugging it.
>=20
> The fmt in the first printk gets corrupted and causes a memory fault
> because the stack isn't 64-bit aligned. The args get saved with a 64-bit
> store (but unaligned access checking isn't turned on yet so this
> silently does the wrong thing), and then read as 1 with a 32-bit load.
>=20
> Enabling unaligned access checking from boot makes it fail at
> metag_start_kernel, immediately after stack pointer is set to
> init_thread_union + THREAD_INFO_SIZE. Basically the restart_block was
> the only thing keeping the struct thread_info as a whole 64-bit aligned
> on Meta.
>=20
> The patch below fixes it. Please can it be squashed into commit "all
> arches, signal: move restart_block to struct task_struct".
>=20
> Thanks
> James
>=20
> From 3ec117304ebde939fd181129227de28c068e7fa2 Mon Sep 17 00:00:00 2001
> From: James Hogan <james.hogan@imgtec.com>
> Date: Tue, 16 Dec 2014 10:15:33 +0000
> Subject: [PATCH] metag: Align thread_info::supervisor_stack
>=20
> Commit a82be12232dc ("all arches, signal: move restart_block to struct
> task_struct") removed restart_block from struct thread_info which was
> the only thing keeping supervisor_stack and the struct as a whole 64-bit
> aligned. This resulted in the initial stack pointer not being 64-bit
> aligned, so when arguments are saved to the stack with a 64-bit SETL
> instruction the values are corrupted resulting in a pretty early
> unserviced memory fault in printk.
>=20
> This is fixed by explicitly aligning supervisor_stack to 8 bytes.
>=20
> Fixes: a82be12232dc ("all arches, signal: move restart_block to struct ta=
sk_struct")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  arch/metag/include/asm/thread_info.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/metag/include/asm/thread_info.h b/arch/metag/include/as=
m/thread_info.h
> index ff4332435d15..afb3ca4776d1 100644
> --- a/arch/metag/include/asm/thread_info.h
> +++ b/arch/metag/include/asm/thread_info.h
> @@ -36,7 +36,7 @@ struct thread_info {
> =20
>  	mm_segment_t addr_limit;	/* thread address space */
> =20
> -	u8 supervisor_stack[0];
> +	u8 supervisor_stack[0] __aligned(8);
>  };
> =20
>  #else /* !__ASSEMBLY__ */
> --=20
> 2.0.4

So should I just dump that patch into my copy of your tree?  (it seems
harmless and lets people get onto other stuff)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/f.6feIL.8V6ZFEcZL8DJ=7.
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUkMbnAAoJEMDTa8Ir7ZwVcokQAIO6Jo+wdu2mdmW+hWkQ6EJu
5R6+A0PuPSTIp6KbNC5JinJ2j9UZNWEoMPn83cB9txLYVsHsl2OxsmEnEG36w70N
36Qbpc1hrAePtMjQmlceEnvVdtNLA8+9f2BdVLxGLsOPv79Ax38z8066QefsDpEU
wykKg+dhEB1DvpjM3Wkcvf6i3sqzL/TvOpQsG/mSQo+MBp4eS1PTKU8tYFH+zKMu
jS8vmi8SqS8ptFRry1Gmw5Yhz2PqQ+xvXMq7/2a434IzW/4yK2j53UqPPqkjRaS6
zCXF4rpahIjYyb2o0JiFoKGLSS1/RTb3CfgsoqXrzRqeoisOnhdcC4BWy/tcfW3W
o7QHGSKGgjWqeArAt7Tz1xWHyx5JvfFgq4+IpSPQ8dqs8wLJzBeaw7A47x/NTpHi
xyussswix5nrMe/4dGs0Yy1lg+BY/L79SI7UvsyAkNe9fRmlssHYeziYmDjl1r3D
pkHExQ2+ury432DyheYmmDlCLg795mEQ6ZWED9D55HFmCJUHs7/v+lEo9AdnIQWi
VUBGwFFDTWkhjER9UCkJIMOulyr/vibifOVtzQk9rbs22UCOKo8QqhNn79RdOXjG
ibk2sm4M01qDSE8t8srGiK7H+TXC3IfE3cLu6cFHpuIzt5hPJYDt96h0xg2NZpAe
DhfE+H5Zk2cHe2kdyo5Z
=0bnD
-----END PGP SIGNATURE-----

--Sig_/f.6feIL.8V6ZFEcZL8DJ=7.--
