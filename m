Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933063Ab3GLMId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 08:08:33 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:62073 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab3GLMIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 08:08:32 -0400
Message-ID: <51DFF1AA.8080407@monstr.eu>
Date: Fri, 12 Jul 2013 14:08:10 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Baruch Siach <baruch@tkos.co.il>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 2/2] clocksource/cadence_ttc: Reuse clocksource as
 sched_clock
References: <1373302298-27957-1-git-send-email-soren.brinkmann@xilinx.com> <1373302298-27957-3-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1373302298-27957-3-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2VGLLSUGHEXHTBACBONXT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2VGLLSUGHEXHTBACBONXT
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 07/08/2013 06:51 PM, Soren Brinkmann wrote:
> Reuse the TTC clocksource timer as sched clock provider.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> v2:
>  - #include linux/sched_clock.h instead of asm/sched_clock.h
>  - remove Kconfig options and #ifdefs around sched_clock related code
>     The reasons for having those are obsolete, since ARM deprecated its=

>     custom sched_clock framework and migrated to the common one.
>=20
>  drivers/clocksource/cadence_ttc_timer.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>=20
> diff --git a/drivers/clocksource/cadence_ttc_timer.c b/drivers/clocksou=
rce/cadence_ttc_timer.c
> index 0eefc8d..b2bb3a4b 100644
> --- a/drivers/clocksource/cadence_ttc_timer.c
> +++ b/drivers/clocksource/cadence_ttc_timer.c
> @@ -21,6 +21,7 @@
>  #include <linux/of_address.h>
>  #include <linux/of_irq.h>
>  #include <linux/slab.h>
> +#include <linux/sched_clock.h>
> =20
>  /*
>   * This driver configures the 2 16-bit count-up timers as follows:
> @@ -94,6 +95,8 @@ struct ttc_timer_clockevent {
>  #define to_ttc_timer_clkevent(x) \
>  		container_of(x, struct ttc_timer_clockevent, ce)
> =20
> +static void __iomem *ttc_sched_clock_val_reg;
> +
>  /**
>   * ttc_set_interval - Set the timer interval value
>   *
> @@ -155,6 +158,11 @@ static cycle_t __ttc_clocksource_read(struct clock=
source *cs)
>  				TTC_COUNT_VAL_OFFSET);
>  }
> =20
> +static u32 notrace ttc_sched_clock_read(void)
> +{
> +	return __raw_readl(ttc_sched_clock_val_reg);
> +}
> +
>  /**
>   * ttc_set_next_event - Sets the time interval for next event
>   *
> @@ -296,6 +304,10 @@ static void __init ttc_setup_clocksource(struct cl=
k *clk, void __iomem *base)
>  		kfree(ttccs);
>  		return;
>  	}
> +
> +	ttc_sched_clock_val_reg =3D base + TTC_COUNT_VAL_OFFSET;
> +	setup_sched_clock(ttc_sched_clock_read, 16,
> +			clk_get_rate(ttccs->ttc.clk) / PRESCALE);
>  }
> =20
>  static int ttc_rate_change_clockevent_cb(struct notifier_block *nb,
>=20

Acked-by: Michal Simek <monstr@monstr.eu>

Thomas, John: Can you please add this patch to your queue?
IRC all these timer patches should go through your trees.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2VGLLSUGHEXHTBACBONXT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlHf8asACgkQykllyylKDCHxZgCfRQbldmvpUzS/9/ubdXeGK/F2
KDEAnjW7++fQOTBwqSTol3fFy4KA3fo3
=4VTE
-----END PGP SIGNATURE-----

------enig2VGLLSUGHEXHTBACBONXT--
