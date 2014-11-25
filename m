Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaKYRZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 12:25:16 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:39621 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480AbaKYRZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 12:25:10 -0500
Date: Tue, 25 Nov 2014 01:23:00 -0400
From: Eduardo Valentin <edubezval@gmail.com>
To: Maurice Petallo <mauricex.r.petallo@intel.com>
Cc: Zhang Rui <rui.zhang@intel.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thermal: Don't call thermal_zone_device_update inside
 spinlock
Message-ID: <20141125052258.GB29240@developer>
References: <1415875624-587-1-git-send-email-mauricex.r.petallo@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
In-Reply-To: <1415875624-587-1-git-send-email-mauricex.r.petallo@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

A minor thing. Your patch title makes us think this fix affects the
thermal subsystem completely, whereas it affects a specific driver.


On Thu, Nov 13, 2014 at 06:47:04PM +0800, Maurice Petallo wrote:
> The driver calls spin_lock_irqsave during DTS interrupt. The interrupt
> handle then calls thermal_zone_device_update which implicitly calls
> a sleep function and produce the following bug:
>=20
> BUG: sleeping function called from invalid context at kernel/locking/mute=
x.c:97
> in_atomic(): 1, irqs_disabled(): 1, pid: 920, name: irq/86-soc_dts
> CPU: 0 PID: 920 Comm: irq/86-soc_dts Tainted: G            E  3.17.0-rc2+=
 #1
> Hardware name: Intel Corp. VALLEYVIEW B3 PLATFORM/NOTEBOOK, BIOS BYTICRB1=
=2E86C.0092.R31.1408290850 08/29/2014
>  00000000 00000000 c25dbe74 c1818cfd f3cc488c c25dbe9c c1059305 c1b4063b
>  00000001 00000001 00000398 f3cc488c f6817644 f6817644 f3ecc6c0 c25dbea8
>  c18208f2 f6817400 c25dbebc c159b0bb c25dbedc f6817400 f32a2300 c25dbee8
> Call Trace:
>  [<c1818cfd>] dump_stack+0x48/0x60
>  [<c1059305>] __might_sleep+0xec/0xf4
>  [<c18208f2>] mutex_lock+0x1c/0x34
>  [<c159b0bb>] thermal_zone_get_temp+0x34/0x59
>  [<c159bde5>] thermal_zone_device_update+0x2d/0xcb
>  [<f85da16a>] ? iosf_mbi_write+0x6c/0x74 [iosf_mbi]
>  [<f7c7445d>] soc_irq_thread_fn+0x10c/0x163 [intel_soc_dts_thermal]
>  [<c107b72b>] irq_thread_fn+0x18/0x2a
>  [<c107bedb>] irq_thread+0x81/0x11f
>  [<c107b713>] ? irq_finalize_oneshot+0x7c/0x7c
>  [<c107bf79>] ? irq_thread+0x11f/0x11f
>  [<c107be5a>] ? wake_threads_waitq+0x31/0x31
>  [<c1054217>] kthread+0x87/0x8c
>  [<c1821e41>] ret_from_kernel_thread+0x21/0x30
>  [<c1054190>] ? __kthread_parkme+0x55/0x55
>=20
> Signed-off-by: Maurice Petallo <mauricex.r.petallo@intel.com>
> Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
> ---
>  drivers/thermal/intel_soc_dts_thermal.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/thermal/intel_soc_dts_thermal.c b/drivers/thermal/in=
tel_soc_dts_thermal.c
> index a6a0a18..5580f5b 100644
> --- a/drivers/thermal/intel_soc_dts_thermal.c
> +++ b/drivers/thermal/intel_soc_dts_thermal.c
> @@ -360,6 +360,9 @@ static void proc_thermal_interrupt(void)
>  	u32 sticky_out;
>  	int status;
>  	u32 ptmc_out;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&intr_notify_lock, flags);
> =20
>  	/* Clear APIC interrupt */
>  	status =3D iosf_mbi_read(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_READ,
> @@ -378,21 +381,20 @@ static void proc_thermal_interrupt(void)
>  		/* reset sticky bit */
>  		status =3D iosf_mbi_write(BT_MBI_UNIT_PMC, BT_MBI_BUNIT_WRITE,
>  					SOC_DTS_OFFSET_PTTSS, sticky_out);
> +		spin_unlock_irqrestore(&intr_notify_lock, flags);
> +
>  		for (i =3D 0; i < SOC_MAX_DTS_SENSORS; ++i) {
>  			pr_debug("TZD update for zone %d\n", i);
>  			thermal_zone_device_update(soc_dts[i]->tzone);
>  		}
> -	}
> +	} else
> +		spin_unlock_irqrestore(&intr_notify_lock, flags);
> =20
>  }
> =20
>  static irqreturn_t soc_irq_thread_fn(int irq, void *dev_data)
>  {
> -	unsigned long flags;
> -
> -	spin_lock_irqsave(&intr_notify_lock, flags);
>  	proc_thermal_interrupt();
> -	spin_unlock_irqrestore(&intr_notify_lock, flags);
>  	pr_debug("proc_thermal_interrupt\n");
> =20
>  	return IRQ_HANDLED;

A part from the minor thing I mentioned before, you can add my:

Acked-by: Eduardo Valentin <edubezval@gmail.com>

> --=20
> 1.7.9.5
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdBIpAAoJEMLUO4d9pOJWurYH/06m0uzqeEQxcl8TRvTJYCP8
MLUV/hqW3gZQZJdHCA5kpNVwlXn5BX8viGz25R6otgZ9856Hveq3ULvY98MgZexR
hg2ErqeKlbX+7MG3PzrAoCqCrTCXlcdP04gEM64M/mhBlwsGSG7kT6Q3gONQ5a+C
6dMWfpXBR3B6S9L9krQdiyylQjySOBmAvasBlnIc/YiAC4uYjDg5TSYTWoXzAzAT
xXaeiuz6L4AMfevJ5BkTEcNqWaPH2+zHb9qdaJzZ/bgmLzIC3gJ+RpWt27KDt0cA
jkVdju+wQiY5hSBx0r4ocw4fdjV9X5m6lemwe6MvQbVU6VgHB2HBBDaBOLVKiC0=
=+oTZ
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
