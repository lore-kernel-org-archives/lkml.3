Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaCMJfK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:35:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39796 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753240AbaCMJfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:35:07 -0400
Date: Thu, 13 Mar 2014 10:34:57 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 4/4] irqchip: sun4i: Use handle_fasteoi_late_irq for
 the ENMI (irq 0)
Message-ID: <20140313093457.GF2815@lukather>
References: <1394644627-12315-1-git-send-email-hdegoede@redhat.com>
 <1394644627-12315-5-git-send-email-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="udOl8koJG4PSVcOF"
Content-Disposition: inline
In-Reply-To: <1394644627-12315-5-git-send-email-hdegoede@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--udOl8koJG4PSVcOF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 12, 2014 at 06:17:07PM +0100, Hans de Goede wrote:
> The ENMI needs to have the ack done *after* clearing the interrupt source,
> otherwise we will get a spurious interrupt for each real interrupt. Switch
> to the new handle_fasteoi_late_irq handler which gives us the desired beh=
avior.
>=20
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/irqchip/irq-sun4i.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/irqchip/irq-sun4i.c b/drivers/irqchip/irq-sun4i.c
> index 8a2fbee..4b1c874 100644
> --- a/drivers/irqchip/irq-sun4i.c
> +++ b/drivers/irqchip/irq-sun4i.c
> @@ -77,15 +77,22 @@ static void sun4i_irq_unmask(struct irq_data *irqd)
>  static struct irq_chip sun4i_irq_chip =3D {
>  	.name		=3D "sun4i_irq",
>  	.irq_ack	=3D sun4i_irq_ack,
> +	.irq_eoi	=3D sun4i_irq_ack, /* For the ENMI */

Hmmm, I wonder if that actually does something.

There's been a patch floating around that I was sure was merged, but
apparently wasn't that remove sun4i_irq_ack, because the register we
were writing to are in read only, and it wasn't doing anything.

>  	.irq_mask	=3D sun4i_irq_mask,
>  	.irq_unmask	=3D sun4i_irq_unmask,
> +	.flags		=3D IRQCHIP_EOI_THREADED, /* Only affects the ENMI */
>  };
> =20
>  static int sun4i_irq_map(struct irq_domain *d, unsigned int virq,
>  			 irq_hw_number_t hw)
>  {
> -	irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> -				 handle_level_irq);
> +	if (hw =3D=3D 0) /* IRQ 0, the ENMI needs special handling */
> +		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> +					 handle_fasteoi_late_irq);
> +	else
> +		irq_set_chip_and_handler(virq, &sun4i_irq_chip,
> +					 handle_level_irq);
> +
>  	set_irq_flags(virq, IRQF_VALID | IRQF_PROBE);

Could that solve the other NMI-related issue we have with Carlo's
patches?

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--udOl8koJG4PSVcOF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTIXvBAAoJEBx+YmzsjxAgWN8P/23YLCdpl1U0khg9bQYkTbCa
BDQWWbK5aXz6pPomk2z3x/iuLqprhx9cloqylzxoJkY0vkHkp350SlL0esh505hk
f8YI7JRmdOelroANFd0kXdMd2MYM9tpfjR2D1hZxtFxqmMEy1IUDEGMyUi+WzkSV
NAD8o7cPL1FBY/3NxZebCBYql+9sOkCmV6u1NpZeZlUHod1p5SwBFCwerR55/EL7
+K8F0UKAedUX2fjNTSdCb4uL27DM+J4usOVVp5c+j/vP9FkYOjVbCDJHp2AfPclX
JSxHZV3YLf3i9ATs0xej/AxCSmXCsJ0Qm/RUplwIK+bHKdBZpKBjU7JaKbtF/nEK
AAdpiB/hf18oLswFu67J3H8PhW08ZzsuhjZ0rl7d+fVNVos/FwLI0oV8dDe/Z3EP
+pkILkvB5bsVtA+Sb32QrzrDSovfkUseQkiIAdwZVcDHw5q2qEGpq/B6QnlPDRrj
XoFr1Wf80CDm//W5DjVaA2ilVflCe5D0MmvYoIamDxAChWt9dvtqCLbIfk07SOKr
IJbSBDIEmEf7zK61CHjspHaJ0q25NR6sIXNGil4c+j6yvsfcUxKQoRKzYQ5c6wYo
3hswunwXfPzLoq9f9pk/tGjvOtMzwK8D7MiS0wp8kG5GqnrWFyGdStHILzBJH6lK
8w3dUmnY2/R8et6G/II+
=0JlX
-----END PGP SIGNATURE-----

--udOl8koJG4PSVcOF--
