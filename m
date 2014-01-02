Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaABDAp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 22:00:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:59951 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958AbaABDAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 22:00:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,588,1384329600"; 
   d="asc'?scan'208";a="452540756"
Date: Wed, 1 Jan 2014 21:41:38 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: rui wang <ruiv.wang@gmail.com>, Tony Luck <tony.luck@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, X86-ML <x86@kernel.org>,
        Michel Lespinasse <walken@google.com>, Andi Kleen <ak@linux.intel.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>, janet.morgan@intel.com,
        "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: Re: [PATCH] x86: Add check for number of available vectors before
 CPU down [v2]
Message-ID: <20140102024138.GA28000@gchen.bj.intel.com>
Mail-Followup-To: Prarit Bhargava <prarit@redhat.com>,
	rui wang <ruiv.wang@gmail.com>, Tony Luck <tony.luck@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	X86-ML <x86@kernel.org>, Michel Lespinasse <walken@google.com>,
	Andi Kleen <ak@linux.intel.com>,
	Seiji Aguchi <seiji.aguchi@hds.com>,
	Yang Zhang <yang.z.zhang@intel.com>,
	Paul Gortmaker <paul.gortmaker@windriver.com>,
	janet.morgan@intel.com, "Yu, Fenghua" <fenghua.yu@intel.com>
References: <1387394945-5704-1-git-send-email-prarit@redhat.com>
 <CA+8MBbKHZ0i0mEYLUrmWwaofvnRcxc7Dvm+w0CfZf2uQydjdjQ@mail.gmail.com>
 <CA+8MBbLMFW5fnUdgNRFpPv9+U1DqB5AeoDOV44kZHozibxjqSg@mail.gmail.com>
 <52B336D4.8010809@redhat.com>
 <CANVTcTa2AiHYrLQt-P_=4GmER_mqbSCZwY13phOkSA4XxrzF=A@mail.gmail.com>
 <52BF060E.7090905@redhat.com>
 <CANVTcTbNqwzVBzqzGisbUJGtVCa9RtA6OuD4hVp0O39Nz_KDrQ@mail.gmail.com>
 <52C18C6B.8090802@redhat.com>
 <CANVTcTbBf8RomFtuvOrkVyHM136ViXVJr2UEQ-i6OvFmRYCqZA@mail.gmail.com>
 <52C33581.1030204@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <52C33581.1030204@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 31, 2013 at 04:22:09PM -0500, Prarit Bhargava wrote:
> Okay, how about,
>                         if (irq_has_action(irq) && !irqd_is_per_cpu(data)=
 &&
>                             ((!cpumask_empty(&affinity_new)) &&
>                               !cpumask_subset(&affinity_new, &online_new)=
) ||
>                              cpumask_empty(&affinity_new))
>                                 this_count++;
>=20
I think it is good but a little bit complicated. How about this:

        if (irq_has_action(irq) && !irqd_is_per_cpu(data) &&
            /* add some commments to emphysize the importance of turn */
            (cpumask_empty(&affinity_new) ||
            !cpumask_subset(&affinity_new, &online_new)))

> I tried this with the following examples and AFAICT I get the correct res=
ult:
>=20
> 1) affinity mask =3D online mask =3D 0xf.  CPU 3 (1000b) is down'd.
>=20
> this_count is not incremented.
>=20
> 2) affinity mask is a non-zero subset of the online mask (which IMO is
> the "typical" case).  For example, affinity_mask =3D 0x9, online mask =3D=
 0xf.  CPU
> 3 is again down'd.
>=20
> this_count is not incremented.
>=20
> 3) affinity_mask =3D 0x1, online mask =3D 0x3. (this is your example).  C=
PU
> 1 is going down.
>=20
> this_count is incremented, as the resulting affinity mask will be 0.
>=20
> 4) affinity_mask =3D 0x0, online mask =3D 0x7.  CPU 1 is going down.
>=20
> this_count is incremented, as the affinity mask is 0.
>=20
The 4th scenario is very tricky. If you try to set affinity from user space,
it will return failure because before kernel tried to change the affinity it
will verify it:
int __ioapic_set_affinity(...)
{
=2E..
        if (!cpumask_intersects(mask, cpu_online_mask))
                return -EINVAL;
=2E..
}

So from this point of view, affinity can't be 0. But your patch is very
special because you change it by hand:
        cpu_clear(smp_processor_id(), affinity_new);

so it is reasonable. It makes me thinking a little bit more. In fixup_irqs
we have similar logic but we don't protect it. Maybe it is because currently
the scenario 4 can't happen because we stop it in advance. But who knows
if one day we use it in other situation we will hit this subtle issue
probably.

So, Prarit, I suggest you writing another patch to fix this potential issue
for fixup_irqs. How would you think?

--ibTvN161/egqYuK8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSxNHiAAoJEI01n1+kOSLHFIsP/i9xiYNIkih3Y7fvb9o3Q1nm
Q/ymvo7dC2b3+9SiK0a8WJgy9ikM6/XshBSxv33cFsV4P9ajvF/uBqGpCedFlJoi
QsvMikRu+qg7WlRB2MnObpqfyd+NBXLj3zcDI3sWJlJVzyI2TNBckTp+0iq/doKn
rCya+g1pEx82TjCghCtjFXTU6qSSe3b0XR6QPWX4j1K7/2J0yMbFSYe4lJKEh6ea
PxhkSc20Fdj1xGr5pzINQXQWIE6mbvPdmsl9kyXqjaAZwKOi10Mf0TqFojxO4S11
ktYQcz9z9tNktV/77o4vI/JgfuVG1luzH7LC2lVUIRfUxhw4TIf58i42C1vEbaSu
cr8sHMP7aD3tbxOLOg8PjFrmozFpJZNmJXhMh9bsEABRQjnn3ZJuLx4oEOaVC381
ZVmqTigMEsCoTIaAklTBOsjgKFen2XpeqsT5CUDk8BSZjOdoQ3dhqzpGpUBV/6qz
giw+WBcRKf+mmQCMcqNWbEIxCUSM//QRjvqakCwRNop1boIAec5eWQL/4L4QSNYA
T64DhBVczAR2h719UQR0mNyE/SzHNOlpMtyNoRXeAW7b+hGBrV11CHJiYBwmmsiQ
vZw5682YmsyttCHn6VGzAFyfea6+34BxgnVZBvH6o1aCSqUqY8YK+E8CIwisfpXL
H/UDHSLS288iKgENUD2c
=FH5O
-----END PGP SIGNATURE-----

--ibTvN161/egqYuK8--
