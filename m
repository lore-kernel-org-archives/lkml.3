Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbbATLvL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:51:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36466 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbbATLvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:51:09 -0500
Date: Tue, 20 Jan 2015 12:51:05 +0100
From: Markus Pargmann <mpa@pengutronix.de>
To: Paul Clements <Paul.Clements@steeleye.com>
Cc: nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [RFC 4/4] nbd: Add support for nbd as root device
Message-ID: <20150120115105.GA26529@pengutronix.de>
References: <1421156665-27318-1-git-send-email-mpa@pengutronix.de>
 <1421156665-27318-5-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <1421156665-27318-5-git-send-email-mpa@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:41:51 up 4 days, 13 min, 90 users,  load average: 1.78, 1.27,
 1.35
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mpa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 13, 2015 at 02:44:25PM +0100, Markus Pargmann wrote:
> Adding support to nbd to use it as a root device. This code essentially
> provides a minimal nbd-client implementation within the kernel. It opens
> a socket and makes the negotiation with the server. Afterwards it passes
> the socket to the normal nbd-code to handle the connection.
>=20
> The arguments for the server are passed via module parameter. The
> module parameter has the format
> '[<SERVER_IP>:]<SERVER_PORT>/<EXPORT_NAME>'.
> SERVER_IP is optional. If it is not available it will use the
> root_server_addr transmitted through DHCP.
>=20
> Based on those arguments, the connection to the server is established
> and is connected to the nbd0 device. The rootdevice therefore is
> root=3D/dev/nbd0.
>=20
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---
>  drivers/block/nbd.c | 306 ++++++++++++++++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 306 insertions(+)
>=20
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 11f7644be111..ac881ae3c15a 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -32,12 +32,17 @@
>  #include <net/sock.h>
>  #include <linux/net.h>
>  #include <linux/kthread.h>
> +#include <net/ipconfig.h>
> +#include <linux/in.h>
> +#include <linux/tcp.h>
> =20
>  #include <asm/uaccess.h>
>  #include <asm/types.h>
> =20
>  #include <linux/nbd.h>
> =20
> +#define ADDR_NONE cpu_to_be32(INADDR_NONE)
> +
>  #define NBD_MAGIC 0x68797548
> =20
>  #ifdef NDEBUG
> @@ -71,6 +76,20 @@ static int max_part;
>   */
>  static DEFINE_SPINLOCK(nbd_lock);
> =20
> +static const char nbd_magic[] =3D "NBDMAGIC";
> +static const u64 nbd_opts_magic =3D 0x49484156454F5054LL;
> +
> +/* Options used for the kernel driver */
> +#define NBD_OPT_EXPORT_NAME 1
> +
> +#define NBD_DEFAULT_BLOCKSIZE 1024
> +
> +extern __be32 root_nfs_parse_addr(char *name);
> +
> +static __be32 nbd_server_addr =3D ADDR_NONE;
> +static __be32 nbd_server_port;
> +static char nbd_server_export[128] =3D "";
> +
>  #ifndef NDEBUG
>  static const char *ioctl_cmd_to_ascii(int cmd)
>  {
> @@ -105,6 +124,52 @@ static const char *nbdcmd_to_ascii(int cmd)
>  }
>  #endif /* NDEBUG */
> =20
> +/*
> + * Parse format "[<SERVER_IP>:]<SERVER_PORT>/<EXPORT_NAME>"
> + */
> +static int nbd_server_addr_set(const char *val, const struct kernel_para=
m *kp)
> +{
> +	char *export;
> +	u16 port;
> +	int ret;
> +	char buf[128];
> +
> +	strncpy(buf, val, 128);
> +
> +	nbd_server_addr =3D root_nfs_parse_addr(buf);
> +
> +	if (*buf =3D=3D '\0') {
> +		ret =3D -EINVAL;
> +		goto free_buf;
> +	}
> +	export =3D strchr(buf, '/');
> +	if (!export || *(export + 1) =3D=3D '\0') {
> +		ret =3D -EINVAL;
> +		goto free_buf;
> +	}
> +	*export =3D '\0';
> +	++export;
> +
> +	ret =3D kstrtou16(buf, 10, &port);
> +	if (ret)
> +		goto free_buf;
> +
> +	memmove(buf, export, strlen(export) + 1);

This memmove() is a leftover from a previous version, it is removed for
the next series version. I also added some documentation patches that
describe this feature in Documentation/blockdev/nbd.txt. I will send it
at the end of this week.

Best regards,

Markus

--=20
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUvkEpAAoJEEpcgKtcEGQQg1EP/3VLo2SFmPDvaHZ3h773jYpz
geHNZW2hPTF8/lFInS8umZgKu8bu18cy6t2xVzdENpydZKGPvDpk4XQvzrd89o0A
iY94fvqw98Ibep3lInYXDZ1uT9T8RyoPqyl/ED9f2eGy+GpNjH3lfGCoYI2QamYk
v8K2b7OyZipZMq+JnLTK5d5Ds/pNExIaDTLvfSGlPY/5Y7OHbV/ilqefYybiXHSQ
DDfFstJtdfkCmsZFSRS4SPF4qXzOnYl+B0M3WiqyT0yHVnCi8Rv3LA6MHOQvXyBj
R8x1/t9hSbgMzSPyE11CNE0/o+aIIyEIeGXQ0ZUPb4+GdmEo+A50ko25RW4bAKLg
N3KFcRwYG7jjZSdW5DCQtvpPqIndZB2ZLxnU9bpjkie74GHKjnnWG1wonag/tdI/
EUWwUqhwsynq/7zsfAR40mW93pC3Ks3tNQHJuLTVDX164Mk92PbV0XipP4+koMFK
yWT5xralPFNT3Gl++fil9BU8dpIbU9KSosH/S9mGynDEXZBwiC5aEW6achydFLzI
Vetv5dTI4iFoQaAn7zU6tFP8yI6MzfoHnNCsfmtSMSrMeHmFYmAz4BqhfPBc8cxI
ammD0BX4Pte7EL/RFTsf73dFckHbo/mw9lMQklH255vWvCxV71QH5NTIKpgT6Fos
sPc5s78haN+Pt2m4pjjq
=cxzD
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
