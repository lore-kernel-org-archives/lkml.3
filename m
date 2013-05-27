Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab3E0Ppq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 11:45:46 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:64576 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab3E0Ppo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 11:45:44 -0400
Date: Mon, 27 May 2013 17:45:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mayuresh Kulkarni <mkulkarni@nvidia.com>
Cc: tbergstrom@nvidia.com, amerilainen@nvidia.com,
        thierry.reding@avionic-design.de, airlied@redhat.com,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/tegra: add support for runtime pm
Message-ID: <20130527154539.GD9460@mithrandir>
References: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <1369662568-22390-1-git-send-email-mkulkarni@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2013 at 07:19:28PM +0530, Mayuresh Kulkarni wrote:
> - as of now host1x and gr2d module's clocks are enabled
> in their driver's .probe and never disabled
> - this commit adds support for runtime pm in host1x and
> gr2d drivers
> - during boot-up clocks are enabled in .probe and disabled
> on its exit
> - when new work is submitted, clocks are enabled in submit
> and disabled when submit completes
> - parent->child relation between host1x and gr2d ensures
> that host1x clock is also enabled before enabling gr2d clock
> and it is turned off after gr2d clock is turned off

I think this format is a little odd and hard to follow for a commit
message. You can easily turn these into proper sentences and hence make
it much easier to read.

> diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
[...]
> @@ -41,6 +42,10 @@ int host1x_job_submit(struct host1x_job *job)
>  {
>  	struct host1x *host =3D dev_get_drvdata(job->channel->dev->parent);
> =20
> +	/* enable clocks
> +	 * they will be disabled in action_submit_complete */
> +	pm_runtime_get_sync(job->channel->dev);

This comment is misleading. Runtime PM could be used for more than just
enabling clocks. Also it should be following the format defined in the
CodingStyle document, like so:

	/*
	 * Enable clocks...
	 * ...
	 */

> diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
[...]
> @@ -143,11 +144,11 @@ static int host1x_probe(struct platform_device *pde=
v)
>  		return err;
>  	}
> =20
> -	err =3D clk_prepare_enable(host->clk);
> -	if (err < 0) {
> -		dev_err(&pdev->dev, "failed to enable clock\n");
> -		return err;
> -	}
> +	/* enable runtime pm */
> +	pm_runtime_enable(&pdev->dev);
> +
> +	/* enable clocks */
> +	pm_runtime_get_sync(&pdev->dev);

I think the comments can be dropped. They don't add any useful
information.

> @@ -165,6 +166,9 @@ static int host1x_probe(struct platform_device *pdev)
> =20
>  	host1x_drm_alloc(pdev);
> =20
> +	/* disable clocks */
> +	pm_runtime_put(&pdev->dev);

Same here.

> +#ifdef CONFIG_PM_RUNTIME
> +static int host1x_runtime_suspend(struct device *dev)
> +{
> +	struct host1x *host;
> +
> +	host =3D dev_get_drvdata(dev);
> +	if (IS_ERR_OR_NULL(host))

I think a simple

	if (!host)
		return -EINVAL;

would be enough here. The driver-data of the device should never be an
ERR_PTR()-encoded value, but either a valid pointer to a host1x object
or NULL.

> +#ifdef CONFIG_PM
> +static const struct dev_pm_ops host1x_pm_ops =3D {
> +#ifdef CONFIG_PM_RUNTIME
> +	.runtime_suspend =3D host1x_runtime_suspend,
> +	.runtime_resume =3D host1x_runtime_resume,
> +#endif

SET_RUNTIME_PM_OPS?

> diff --git a/drivers/gpu/host1x/drm/gr2d.c b/drivers/gpu/host1x/drm/gr2d.c
[...]

Same comments apply here. Also I think it might be a good idea to split
the host1x and gr2d changes into separate patches.

> diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
> index 2491bf8..c23fb64 100644
> --- a/drivers/gpu/host1x/intr.c
> +++ b/drivers/gpu/host1x/intr.c
> @@ -20,6 +20,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/slab.h>
>  #include <linux/irq.h>
> +#include <linux/pm_runtime.h>
> =20
>  #include <trace/events/host1x.h>
>  #include "channel.h"
> @@ -109,14 +110,18 @@ static void reset_threshold_interrupt(struct host1x=
 *host,
> =20
>  static void action_submit_complete(struct host1x_waitlist *waiter)
>  {
> +	int completed =3D waiter->count;
>  	struct host1x_channel *channel =3D waiter->data;
> =20
> +	/* disable clocks for all the submits that got completed in this lot */
> +	while (completed--)
> +		pm_runtime_put(channel->dev);
> +
>  	host1x_cdma_update(&channel->cdma);
> =20
> -	/*  Add nr_completed to trace */
> +	/* Add nr_completed to trace */
>  	trace_host1x_channel_submit_complete(dev_name(channel->dev),
>  					     waiter->count, waiter->thresh);
> -
>  }

This feels hackish. But I can't see any better place to do this. Terje,
Arto: any ideas how we can do this in a cleaner way? If there's nothing
better then maybe moving the code into a separate function, say
host1x_waitlist_complete(), might make this less awkward?

Thierry

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRo3+jAAoJEN0jrNd/PrOhdtkQAMKRrNmtVQyxCFWKx+6Enij0
vvMVnxcBw14zd5be0WGPALsmh21stPbFwXmEGypqszC3PM1ACEQoY25EHINVmZYO
jRgS20bb2/rJ+JHLEv2jTCg9rJTMkhdlEm3dzRpmZw9bNXA1B0YczYNzLv6+aykJ
rb+ovh0tKYr4Khd7+4V3C7Rc+4POXWtci42oypW1R42WMgyNO7DorigsWnkMfyZE
B6uGTcS1+eJC5oyCSCH+6xHzvc8QbaONMX+bu37+dqdctTb8UTQ07DPbZBv767BB
2x1Q+HQsdKvCtFWsxB9g7nNIPECrbSj5FEF3+CiMv0hyqMZ+6ufKZC26cR6uB4dx
uu6T4x+ix27pfKOOB+Ft3KnfSpkpo9nTpUjbJltDEmSemHKKM6Jf2Dk31cFIivNm
OeqRlVMFROJcWDtKw9CbPBwfxvOLgPofQu7yOQ9PVjcEEK3Ho/ucMbGFqmaqy7fe
kJuaGNVjz8E+6SfukZxrgXXHMJiYkLIVbvcOjfzQYa404JyNFSI/+RcVVqmSs+ny
3Cit0gQhpvMXIj20ZyxaQfIzmrzrmdKdOy2yJMUqRZD34nihvBocS5m93ZnGLjFn
ael0OHsGBQ7akX9lqIS6QIBa1g0OG0NnEb7FdRB55WcYY2slu+n+lJ08rGYhfY0Q
vlPfg+y9HUG6zT81hHg+
=Vvpf
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
