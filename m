Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaCXWev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 18:34:51 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:37379 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaCXWet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 18:34:49 -0400
Date: Mon, 24 Mar 2014 23:34:45 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 06/12] drm/nouveau/ibus: add GK20A support
Message-ID: <20140324223444.GF17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-7-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bGR76rFJjkSxVeRa"
Content-Disposition: inline
In-Reply-To: <1395650554-31925-7-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bGR76rFJjkSxVeRa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 24, 2014 at 05:42:28PM +0900, Alexandre Courbot wrote:
[...]
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c b/drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c
[...]
> +#include <subdev/ibus.h>
> +
> +struct nvea_ibus_priv {
> +	struct nouveau_ibus base;
> +};
> +
> +static void
> +nvea_ibus_init_priv_ring(struct nvea_ibus_priv *priv)
> +{
> +	nv_mask(priv, 0x137250, 0x3f, 0);
> +
> +	nv_mask(priv, 0x000200, 0x20, 0);
> +	udelay(20);

usleep_range()?

> +static void
> +nvea_ibus_intr(struct nouveau_subdev *subdev)
> +{
[...]
> +	/* Acknowledge interrupt */
> +	nv_mask(priv, 0x12004c, 0x2, 0x2);
> +
> +	while (--retry >= 0) {
> +		command = nv_rd32(priv, 0x12004c) & 0x3f;
> +		if (command == 0)
> +			break;
> +	}
> +
> +	if (retry < 0)
> +		nv_warn(priv, "timeout waiting for ringmaster ack\n");
> +}

Perhaps I'm being paranoid, but this loop now depends on the frequency
of the various clocks involved and therefore might break at some point
if the frequencies get sufficiently high.

So a slightly safer implementation would use a proper timeout using a
combination of msecs_to_jiffies(), time_before() and usleep_range(),
like so:

	timeout = jiffies + msecs_to_jiffies(...);

	while (time_before(jiffies, timeout)) {
		command = nv_rd32(...) & 0x3f;
		if (command == 0)
			break;

		usleep_range(...);
	}

	if (time_after(jiffies, timeout))
		nv_warn(...);

This assumes that there's some known timeout after which the ringmaster
is expected to have acked the interrupt. On that note, I wonder if the
warning is accurate here: it's my understanding that writing 0x2 to the
register does acknowledge the interrupt, so the ringmaster does in fact
"clear" it rather than "acknowledge" it, doesn't it?

Although now that I mention it I seem to remember that this write is
actually sending a command to the ring master and perhaps waiting for
the register to return to 0 is indeed waiting for an ACK of sorts. Maybe
adding a comment or so describing what this sequence does would be
appropriate here?

Thierry

--bGR76rFJjkSxVeRa
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMLMEAAoJEN0jrNd/PrOhTnYQALxMAyx6C5uktVz+P1nQTFPv
zzyZBe3LycCcoQsy2Yy+3ND+8OgA56zCsGYCEdhbjRScADzUjq4QpX0eMxCVFEkH
2DuyFyJgRuwZwgJLXQEY+xlJQlSCA07E4caM7BRPchYBSuOmeDgSritSZQVq2D+z
r8mIegwsto90nfjN20M8BPBReatvVNYh25hZEvdysX90MlEonq1P+cEUPa+QSe7D
foH1sQqt7kfpPOMsOcYhq+ZAXGyxDNuuokxV1Ie+bsSYvcJr1HQ6gdPFPCjvHAbr
ek9M2EVDdK072oX+sFKe8lCpKJQSUfm8WHMjRR5qpyfKHiFl5aGSULe6Ihs8MA1n
mGYVzcUF/4XruASL02TbqQ81rqMRWv6vrjfri7oWUBhl4go7L1bB1PKKZEpvowNP
RHrCD2QnjXvvLaFHTwxsLGouwqiCSS4eILK9vijLkKTKguiwFv5ypBM01ch+U1cq
QwEMh0+YySSl5R3muiPalK2De1SBuA/UTkKxj7EydyigTpeOtzgW4oxqTI2Z56vj
hrHh9++5PDZ4DKLtAPhaUoFT922BACbG81lNqIouN8IpnOv+s786ETwdd2/9nVbr
/YxsiSXzS+ipdeLcFRkil+mf+slu8Gn+vsS8KwZNow5sWlpRT9s8x5hcOn6Id7rE
jRzpsKlbBh6NdJCfQupv
=6rRj
-----END PGP SIGNATURE-----

--bGR76rFJjkSxVeRa--
