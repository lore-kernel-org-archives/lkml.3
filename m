Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaBXNYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:24:49 -0500
Received: from multi.imgtec.com ([194.200.65.239]:43445 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbaBXNYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:24:47 -0500
Message-ID: <530B47FD.80608@imgtec.com>
Date: Mon, 24 Feb 2014 13:24:13 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        "Peter Zijlstra" <peterz@infradead.org>,
        metag <linux-metag@vger.kernel.org>
Subject: Re: [patch 06/26] metag: Use irq_set_affinity instead of homebrewn
 code
References: <20140223212703.511977310@linutronix.de> <20140223212736.887575774@linutronix.de>
In-Reply-To: <20140223212736.887575774@linutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="ommMFWMnqXrcdWGbTDGXD3vUoDKHi0ivw"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2014_02_24_13_24_21
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ommMFWMnqXrcdWGbTDGXD3vUoDKHi0ivw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On 23/02/14 21:40, Thomas Gleixner wrote:
> There is no point in having an incomplete copy of irq_set_affinity()
> for the hotplug irq migration code.

That sounds reasonable, but when I gave it a try I started getting
warnings on the log after offlining one cpu then the other:

META213-Thread0 DSP [LogF] IRQ13 no longer affine to CPU1
META213-Thread0 DSP [LogF] IRQ14 no longer affine to CPU1
META213-Thread0 DSP [LogF] IRQ15 no longer affine to CPU1
META213-Thread0 DSP [LogF] IRQ18 no longer affine to CPU1
META213-Thread0 DSP [LogF] IRQ29 no longer affine to CPU1
META213-Thread0 DSP [LogF] IRQ30 no longer affine to CPU1
META213-Thread0 DSP [LogF] IRQ31 no longer affine to CPU1

It appears that the irq affinities weren't getting modified previously,
whereas now irq_do_set_affinity() does do cpumask_copy(data->affinity,
mask). Once all CPUs have been offlined at least once you get those
spurious messages even though the IRQ affinities haven't been explicitly
limited by anything.

I wonder if the stored affinity should really be altered in this case?

Cheers
James

>=20
> Use the core function instead and while at it switch to
> for_each_active_irq()
>=20
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: James Hogan <james.hogan@imgtec.com>
> Cc: metag <linux-metag@vger.kernel.org>
> ---
>  arch/metag/kernel/irq.c |   20 +++-----------------
>  1 file changed, 3 insertions(+), 17 deletions(-)
>=20
> Index: tip/arch/metag/kernel/irq.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- tip.orig/arch/metag/kernel/irq.c
> +++ tip/arch/metag/kernel/irq.c
> @@ -261,18 +261,6 @@ int __init arch_probe_nr_irqs(void)
>  }
> =20
>  #ifdef CONFIG_HOTPLUG_CPU
> -static void route_irq(struct irq_data *data, unsigned int irq, unsigne=
d int cpu)
> -{
> -	struct irq_desc *desc =3D irq_to_desc(irq);
> -	struct irq_chip *chip =3D irq_data_get_irq_chip(data);
> -	unsigned long flags;
> -
> -	raw_spin_lock_irqsave(&desc->lock, flags);
> -	if (chip->irq_set_affinity)
> -		chip->irq_set_affinity(data, cpumask_of(cpu), false);
> -	raw_spin_unlock_irqrestore(&desc->lock, flags);
> -}
> -
>  /*
>   * The CPU has been marked offline.  Migrate IRQs off this CPU.  If
>   * the affinity settings do not allow other CPUs, force them onto any
> @@ -281,10 +269,9 @@ static void route_irq(struct irq_data *d
>  void migrate_irqs(void)
>  {
>  	unsigned int i, cpu =3D smp_processor_id();
> -	struct irq_desc *desc;
> =20
> -	for_each_irq_desc(i, desc) {
> -		struct irq_data *data =3D irq_desc_get_irq_data(desc);
> +	for_each_active_irq(i) {
> +		struct irq_data *data =3D irq_get_irq_data(i);
>  		unsigned int newcpu;
> =20
>  		if (irqd_is_per_cpu(data))
> @@ -303,8 +290,7 @@ void migrate_irqs(void)
>  			newcpu =3D cpumask_any_and(data->affinity,
>  						 cpu_online_mask);
>  		}
> -
> -		route_irq(data, i, newcpu);
> +		irq_set_affinity(i, cpumask_of(newcpu));
>  	}
>  }
>  #endif /* CONFIG_HOTPLUG_CPU */
>=20
>=20


--ommMFWMnqXrcdWGbTDGXD3vUoDKHi0ivw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJTC0gDAAoJEKHZs+irPybf29cP/26RbV8r5wbxcj7LWrjj2o6Z
sy9kelW7oG2mMzwDcrT54AtZcRkCRDQG0jhKOWm8rFktuikTCS4D7/4sd8XCjC/J
5FKntTNNWnJMzWBuHl7WG7uR7/MOw4POhRWO/pSIzUosiFpxewdwtuSgCwFxguGr
DNZpUGeGVQGk1OGnRagXSb7mRmzJR9WSaxDNDbRcYOu48UAXI5TYzXI0njUiEcXS
NEq/TO1OE/z8S0yuzPYLa2DITFSEx3Cb+4GWMWAmDw0CDNEsrO4Vug5QBZaNdSII
N+wtEgRaKQqNI0Lh7jKPXFsr08c0tO+RmlypF1EFUUODVEL2mruKB/rcG54Ut/a8
J1hPzGtykV/Q+AEiOvWwLFrPkdDHkdlCq4LmXYeXdX9rj+4bfCJ33Tn33qkklROP
GnufPuZH5mkH8/EIJq42hbBCM8gPOarylZiZRIsT6NjRdQa4f8mbeAH8R0lbhxSI
QgPezsNYIdoL61pgNZYI95ZtJoMHzKKe1Tjl0H+unk8gftXY0/LiqoighanE74J4
RDCYQZtPJifiLfNKN4LLUZGJUM5IEoyqd3sSbAXqm9MBqRgFNg0tKjtFGmDF2F3A
JDIS6u4YeQLyLtC7LxHwwRWSz1m7mFTUnmfbCjWpRmMlUYtbpvt5etQvtZoqFB+c
CB2QVnGzbXuUvyU6Jwua
=V1NO
-----END PGP SIGNATURE-----

--ommMFWMnqXrcdWGbTDGXD3vUoDKHi0ivw--

