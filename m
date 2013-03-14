Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460Ab3CNBua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 21:50:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57589 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196Ab3CNBu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 21:50:28 -0400
Message-ID: <1363225816.3937.119.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 031/100] iwlwifi: always copy first 16 bytes of commands
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 14 Mar 2013 01:50:16 +0000
In-Reply-To: <20130312223126.381565711@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
	 <20130312223126.381565711@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-w8qoVUEqVDSxxhyMUMAh"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w8qoVUEqVDSxxhyMUMAh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-12 at 15:31 -0700, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> commit 8a964f44e01ad3bbc208c3e80d931ba91b9ea786 upstream.
[...]
> --- a/drivers/net/wireless/iwlwifi/pcie/tx.c
> +++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
[...]
> @@ -1221,14 +1238,31 @@ static int iwl_pcie_enqueue_hcmd(struct
> =20
>  	/* and copy the data that needs to be copied */
>  	cmd_pos =3D offsetof(struct iwl_device_cmd, payload);
> +	copy_size =3D sizeof(out_cmd->hdr);
>  	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
> -		if (!cmd->len[i])
> +		int copy =3D 0;
> +
> +		if (!cmd->len)
>  			continue;

cmd->len is an array, so the new condition is always false.  Shouldn't
it be 'if (!cmdlen[i])'?

Ben.

> -		if (cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
> -					 IWL_HCMD_DFL_DUP))
> -			break;
> -		memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], cmd->len[i]);
> -		cmd_pos +=3D cmd->len[i];
> +
> +		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
> +		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
> +			copy =3D IWL_HCMD_MIN_COPY_SIZE - copy_size;
> +
> +			if (copy > cmd->len[i])
> +				copy =3D cmd->len[i];
> +		}
> +
> +		/* copy everything if not nocopy/dup */
> +		if (!(cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
> +					   IWL_HCMD_DFL_DUP)))
> +			copy =3D cmd->len[i];
> +
> +		if (copy) {
> +			memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], copy);
> +			cmd_pos +=3D copy;
> +			copy_size +=3D copy;
> +		}
>  	}
> =20
>  	WARN_ON_ONCE(txq->entries[idx].copy_cmd);
[...]

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-w8qoVUEqVDSxxhyMUMAh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUEs2Oe/yOyVhhEJAQo5NQ//TfrfGhHhguD8biD//tLW/V7M2+VRu8Y/
tJLqeNLSwp07/HbxB2g31DnVIU+xOuE0GMp/TUxQjZ24wpbUXLq60oDIm+4lT3b0
c3z+0lWQh8LCb6ikXw89k1Kofj5iI+qB0+/gWfvrOMGeHgt0YZp7lcx1Jm+YqGrk
wc/2a3Meu1oFSYltVz+7bWcI060K5LlW2Bhy9iY7oo2aLNnNFhLBpXmLw1LAJG6t
ETQ6qcI8z5v7BnySu23DxUcpIXZsw6Qlx3R3yBhOSQV/7hGSkM2C5/JVWNnXW9Ln
AzkZci+btA/C1aJpqDvHmMD6nP4GzpP+z6sYlJ/bwC6c9TsIYUcKMC5S98vccZit
e6g8xJtjVYMalGBN5XdV0UZfRYqFgbHbnKOQHJnxDgetJMXdQ+4SFH7vDrvSix5s
+exg063KuzZtaZccZ6hFtksUCm9hh/FCAOxuifbC+HYNutFJZWOvxO1mlpi552kA
oWM/8AsajcLK7CZaF0XIJYCoArUdeMrX9wamKgbERxN6BKI2FoH+bOUL3VKlonyf
KUugwc581qByQgPS1qXGm02M5QgV1HmEoR5p23slvbpVpUu7aKC8QZ4H2n7BUWv2
iCdn5/VeixlSUo9LRif/CjLm7hiD7+U6E/ygGu1DPwmuPf3K/PqgwlxzV+lvtIxD
Bmrj/rOr0KI=
=Jckh
-----END PGP SIGNATURE-----

--=-w8qoVUEqVDSxxhyMUMAh--
