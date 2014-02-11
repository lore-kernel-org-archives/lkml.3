Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaBKVSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 16:18:34 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:64452 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbaBKVSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 16:18:32 -0500
Date: Tue, 11 Feb 2014 22:18:28 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, josephl@nvidia.com, dev@lynxeye.de,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: don't timeout if CPU is powergated
Message-ID: <20140211211827.GC1895@mithrandir>
References: <1d5ea6b7df4573d866779857922ac650fe59af60.1392078805.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <1d5ea6b7df4573d866779857922ac650fe59af60.1392078805.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2014 at 01:44:13AM +0100, Stefan Agner wrote:
> When booting secondary CPU(s) which are not yet powergated, a wrong
> check lead to a timeout after 100 jiffies. With this patch, we only
> delay powergating if CPUs are still not powered yet.
>=20
> Signed-off-by: Stefan Agner <stefan@agner.ch>
> ---
> I happend to come accross this while working on Colibri T30 support.
> Obviously, the downstream U-Boot doesn't powergate all CPUs, so
> the Linux kernel always timed out when booting CPU 1 through 3...
>=20
>  arch/arm/mach-tegra/platsmp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/mach-tegra/platsmp.c b/arch/arm/mach-tegra/platsmp.c
> index eb72ae7..929d104 100644
> --- a/arch/arm/mach-tegra/platsmp.c
> +++ b/arch/arm/mach-tegra/platsmp.c
> @@ -114,7 +114,7 @@ static int tegra30_boot_secondary(unsigned int cpu, s=
truct task_struct *idle)
> =20
>  		/* Wait for the power to come up. */
>  		timeout =3D jiffies + msecs_to_jiffies(100);
> -		while (tegra_pmc_cpu_is_powered(cpu)) {
> +		while (!tegra_pmc_cpu_is_powered(cpu)) {
>  			if (time_after(jiffies, timeout))
>  				return -ETIMEDOUT;
>  			udelay(10);

This is indeed what I'd expect the code to look like. Since the code
enables power to the CPU, the logical thing to do would be to then wait
for it to be powered up.

I don't quite understand when exactly this will fail, since the whole
block above is conditional on !tegra_pmc_cpu_is_powered() condition, so
the only way that this can happen is when the first check fails, then
the CPU is powered on and the PMC recognizes the CPU as powered before
the while (...) is executed.

Thinking about it I've seen an issue on Cardhu where occasionally only
three of the four CPUs actually came up (I've only noticed this since
the DRM panel patches because three penguins looks kind of weird =3D).
This bug would explain that issue.

Any way, the new code makes much more sense than the old one, so:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+pOjAAoJEN0jrNd/PrOh0s0QAJ8q37hTMF07XcU1eaIuuYg2
K3xAOw+4bDsrr4QvTxG6GD8BOjmRQodx/fNPIseF6TQdhftrVjb3gnhrb18pWrTa
w6fpnd0Tg75HoeKibh+0jxwBP0QV5yhbmgQbc31hVzZ0tNoVb7VtV4vZPuGfT7Va
TosTMebq15uNSwoEewZ9IfSegbIuO4KFD7ZTfj0Mxkmrq0wtyrL8W0/KGA/bD5q0
Iia5DevwEKtxx26m8fGS5KtTCcoWRjUrSuJ90l978Z4hmnmp3W4q9EsNxih/OGFs
PZLZWo179+QrDzN+bE8m5Z/U3x7AvfQJF+RmPI8jJfbRzXQr+cjQ7DUhyajBgFHr
Xh3J3lNRbxHZ48ACz0XNnbhY2K8oar1aVzeN91/POUuayxRLPVKnzCRKwpp9yx4Q
0lJji6fcQE8xWn0QI0G0rzNvRVyCDqFgQTXLeNo9eRxMAmg+29KctZ4W2FOXZjW2
T27Odf1FtJkzzsKHrzALOSstt91YdliMWXy1+cZVlzaUODVlpVFdwGmL25NZUl6I
AHsQfuFDPOR/P224WkRTTl/yWFgj1IjpHq7veHwHE5JbkkBsW5nn0TVKg06JPHN8
t9HNZZAS4MBsKrFeqNrguIK2Sq5naN9/vHYdk4xgf/Wf9VrQZvvHeByKizDANVnY
pDSMfE4LpHPW5M4/HjXn
=a3CK
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
