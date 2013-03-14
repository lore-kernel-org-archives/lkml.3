Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab3CNCFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:05:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57675 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755196Ab3CNCFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:05:35 -0400
Message-ID: <1363226724.3937.123.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 031/100] iwlwifi: always copy first 16 bytes of commands
From: Ben Hutchings <ben@decadent.org.uk>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes.berg@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Thu, 14 Mar 2013 02:05:24 +0000
In-Reply-To: <1363225816.3937.119.camel@deadeye.wl.decadent.org.uk>
References: <20130312223122.884099393@linuxfoundation.org>
	 <20130312223126.381565711@linuxfoundation.org>
	 <1363225816.3937.119.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-WNEdi2OuU0oopAKnGPN4"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WNEdi2OuU0oopAKnGPN4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-03-14 at 01:50 +0000, Ben Hutchings wrote:
> On Tue, 2013-03-12 at 15:31 -0700, Greg Kroah-Hartman wrote:
> > 3.8-stable review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Johannes Berg <johannes.berg@intel.com>
> >=20
> > commit 8a964f44e01ad3bbc208c3e80d931ba91b9ea786 upstream.
> [...]
> > --- a/drivers/net/wireless/iwlwifi/pcie/tx.c
> > +++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
> [...]
> > @@ -1221,14 +1238,31 @@ static int iwl_pcie_enqueue_hcmd(struct
> > =20
> >  	/* and copy the data that needs to be copied */
> >  	cmd_pos =3D offsetof(struct iwl_device_cmd, payload);
> > +	copy_size =3D sizeof(out_cmd->hdr);
> >  	for (i =3D 0; i < IWL_MAX_CMD_TFDS; i++) {
> > -		if (!cmd->len[i])
> > +		int copy =3D 0;
> > +
> > +		if (!cmd->len)
> >  			continue;
>=20
> cmd->len is an array, so the new condition is always false.  Shouldn't
> it be 'if (!cmdlen[i])'?

To answer myself: no, it should still be 'if (!cmd->len[i])' as this
loop needs to include input fragments that will be completely copied
into the header fragment.

Ben.

> Ben.
>=20
> > -		if (cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
> > -					 IWL_HCMD_DFL_DUP))
> > -			break;
> > -		memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], cmd->len[i]);
> > -		cmd_pos +=3D cmd->len[i];
> > +
> > +		/* need at least IWL_HCMD_MIN_COPY_SIZE copied */
> > +		if (copy_size < IWL_HCMD_MIN_COPY_SIZE) {
> > +			copy =3D IWL_HCMD_MIN_COPY_SIZE - copy_size;
> > +
> > +			if (copy > cmd->len[i])
> > +				copy =3D cmd->len[i];
> > +		}
> > +
> > +		/* copy everything if not nocopy/dup */
> > +		if (!(cmd->dataflags[i] & (IWL_HCMD_DFL_NOCOPY |
> > +					   IWL_HCMD_DFL_DUP)))
> > +			copy =3D cmd->len[i];
> > +
> > +		if (copy) {
> > +			memcpy((u8 *)out_cmd + cmd_pos, cmd->data[i], copy);
> > +			cmd_pos +=3D copy;
> > +			copy_size +=3D copy;
> > +		}
> >  	}
> > =20
> >  	WARN_ON_ONCE(txq->entries[idx].copy_cmd);
> [...]
>=20

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-WNEdi2OuU0oopAKnGPN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUEwZOe/yOyVhhEJAQo0nw//T1kGc089ufhaMzdPdU5jdNK6sVU+onjU
1f0eumo2ouWyLOGDl1890m5SAWYDdIxw5MOAWz/vRQWgbGke6ufU6fdFUnrU5qbk
Gd2OTZN/NbWo0PRmdG6Zk50nDL97yQEGSPvhFCeFavMtQ79QaxJGuREMgdd/5YSA
Ird/rZqlKLlm7AviCX7FMxNWpdRSwQN0vgpIuyvymPSn/DYoiZIb3o1YDyJlM0un
PpxzpKOQoE0MBw7sa/tWzm3Ri6DY/xI8bCLO6iik8a76Yhduq4KhV+c/cn5+7+QN
becMfidNeb0hYwKaGHA2VoY665H+8yvAmNscVEOFmf7zOiG2yBnJpU/6tlnwA75B
17TFPHJhO/FiroNCN/FLlxmB979PnS54GLKq0zzdJTrF9kG928Qk5AUbRu1L/1fG
gWpGUVbs0lbKlMajV/04ky/Nc1mdf/CiXpAoggrf9k/+X0Qvl9ZjgUKKcIn0mvZH
erkJsVIDoXi/L+3QKigzYy5lQl49XOJQEeWKhVhREH8kkAdBCICynEhSp8l3rThM
x4PWUJXeyVSIhZhBCqnwudmf/+M0TBSvjF/bdPkLLhuXhakiL+n+2zjctUaFc+OU
xWd7kc5eQsl4zOcgq3KwtUKZHTRent2j9Y8PSpw6reJJypKuGl1/ql2ku4JnpqOn
cCavhYV+P/E=
=403X
-----END PGP SIGNATURE-----

--=-WNEdi2OuU0oopAKnGPN4--
