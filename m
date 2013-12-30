Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab3L3IDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 03:03:33 -0500
Received: from mga14.intel.com ([143.182.124.37]:65421 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375Ab3L3IDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 03:03:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,572,1384329600"; 
   d="asc'?scan'208";a="330982645"
Date: Mon, 30 Dec 2013 02:44:34 -0500
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
Message-ID: <20131230074434.GA20484@gchen.bj.intel.com>
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
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <52BF060E.7090905@redhat.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 28, 2013 at 12:10:38PM -0500, Prarit Bhargava wrote:
> Gong and Rui,
>=20
> After looking at this in detail I realized I made a mistake in my patch by
> including the check for the smp_affinity.  Simply put, it shouldn't be th=
ere
> given Rui's explanation above.
>=20
> So I think the patch simply needs to do:
>=20
>         this_count =3D 0;
>         for (vector =3D FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vecto=
r++) {
>                 irq =3D __this_cpu_read(vector_irq[vector]);
>                 if (irq >=3D 0) {
>                         desc =3D irq_to_desc(irq);
>                         data =3D irq_desc_get_irq_data(desc);
>                         affinity =3D data->affinity;
>                         if (irq_has_action(irq) && !irqd_is_per_cpu(data))
>                                 this_count++;
>                 }
>         }
>=20
> Can the two of you confirm the above is correct?  It would be greatly app=
reciated.
>=20

No, I don't think it is correct. We still need to consider smp_affinity.

fixup_irqs
        irq_set_affinity(native_ioapic_set_affinity)
                __ioapic_set_affinity
                        assign_irq_vector
                                __assign_irq_vector
                        cpu_mask_to_apicid_and
                /* now begin to set ioapic RET */

__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mas=
k)
{
=2E..
        apic->vector_allocation_domain(cpu, tmp_mask, mask);
=2E..
        for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
                per_cpu(vector_irq, new_cpu)[vector] =3D irq;
        cfg->vector =3D vector;
        cpumask_copy(cfg->domain, tmp_mask);
=2E..
}

On same vecotr on all related vector_irq, irq is set. So such kind of
irq should happen in multiple vector_irq. In cpu_mask_to_apicid_and(e.g.
x2apic_cpu_mask_to_apicid_and for cluster mode), apic is updated
depending on new mask. That's why I think this kind of interrupt
should be bypassed.

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSwSRiAAoJEI01n1+kOSLHjXoQAKlxZFD8rOvvZJGAihyG8CPA
AC7zfDFHDu5DmvHhTCw7nz87UD8lJgbUA9mEssaZzLJyNx0xLhrNFdkAGTFr9Tkd
4GjgiAao7osPIKb3sVc6ZZ4/3m31QMUi7WCKbdwrbt0C1sbBPQk8gJUO3CEePyy0
P7S060w42mTdJFK3dNameTMA/UG1NMmUZD7FKLuwDgKxKR3tGwqNpUB8Gwesowdh
6XBZ0kXZLh6DLjnOjPnf2uiUYNqy1GS7i6dwtZwiRry7spUG1sIJDrSsMZerivAZ
SE4++SQMx7XYjhqhjDO3ic5HME/AsiKLEUXR7FvM2z0MeBIsdabfAH2p56rgHfAx
3phCGA+sTg3ERoCbpB3hniHHrCyTbsXthIePu8QC4PuGRPL+E+2JluwKG9GyGBxM
ru4NE25teaMGKZT/xhMPdK9ddkynx6WaD/6V05aEMdVw5dbj8QFYuqwazYGtiAU4
ElmFBVlbT7E1NkAm67vHhI3f8QvndXukJ7sHuLHNNpD+wCQNdaw+9zR4jrXNsrzO
05atU1EjgLJvUPcvxeihVKrQDzuqEDFD53D9F7k7mtBcSJX4TwUvA72Wb6GhQV49
UiD1eyojaEzzHCTIj1Qg2OPgkZumnCwePgCYoZlJs2ZUbtnKQS+g/issWx1uP7Sa
LKhJ/NA+rcREYQSxc2bK
=takK
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
