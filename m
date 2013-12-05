Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756528Ab3LEDPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 22:15:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:46645 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023Ab3LEDPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 22:15:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,830,1378882800"; 
   d="asc'?scan'208";a="394250606"
Date: Wed, 4 Dec 2013 21:57:41 -0500
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Levente Kurusa <levex@linux.com>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        EDAC <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: mcheck: call put_device on device_register failure
Message-ID: <20131205025741.GA26999@gchen.bj.intel.com>
Mail-Followup-To: Levente Kurusa <levex@linux.com>,
	Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, EDAC <linux-edac@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <5298F900.9000208@linux.com>
 <20131129205628.GA20144@pd.tnic>
 <52999419.7040600@linux.com>
 <20131130111214.GB4323@pd.tnic>
 <20131203022330.GA25136@gchen.bj.intel.com>
 <20131203170150.GA5369@pd.tnic>
 <20131204073824.GA22134@gchen.bj.intel.com>
 <529F76CB.8080601@linux.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <529F76CB.8080601@linux.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 04, 2013 at 07:39:07PM +0100, Levente Kurusa wrote:
> Date:	Wed, 04 Dec 2013 19:39:07 +0100
> From: Levente Kurusa <levex@linux.com>
> To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Thomas
>  Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>, "H. Peter
>  Anvin" <hpa@zytor.com>, x86@kernel.org, EDAC <linux-edac@vger.kernel.org=
>,
>  LKML <linux-kernel@vger.kernel.org>
> Subject: Re: [PATCH] x86: mcheck: call put_device on device_register fail=
ure
> User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
>  Thunderbird/24.1.0
>=20
> 2013-12-04 08:38, Chen, Gong:
> > On Tue, Dec 03, 2013 at 06:01:50PM +0100, Borislav Petkov wrote:
> >> Date: Tue, 3 Dec 2013 18:01:50 +0100
> >> From: Borislav Petkov <bp@alien8.de>
> >> To: "Chen, Gong" <gong.chen@linux.intel.com>
> >> Cc: Levente Kurusa <levex@linux.com>, Ingo Molnar <mingo@kernel.org>,
> >>  Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>=
, "H.
> >>  Peter Anvin" <hpa@zytor.com>, x86@kernel.org, EDAC
> >>  <linux-edac@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
> >> Subject: Re: [PATCH] x86: mcheck: call put_device on device_register f=
ailure
> >> User-Agent: Mutt/1.5.21 (2010-09-15)
> >>
> >> Can you please fix your
> >>
> >> Mail-Followup-To:
> >>
> >> header? It is impossible to reply to your emails without fiddling with
> >> the To: and Cc: by hand which gets very annoying over time.
> >=20
> > I add some configs in my muttrc. Hope it works.
> >=20
> >>
> >> On Mon, Dec 02, 2013 at 09:23:30PM -0500, Chen, Gong wrote:
> >>> I have some concerns about it. if device_register is failed, it will
> >>> backtraces all kinds of conditions automatically, including put_device
> >>> definately. So do we really need an extra put_device when it returns
> >>> failure?
> >>
> >> Do you mean the "done:" label in device_add() which does put_device()
> >> and which gets called by device_register()?
> >>
> >=20
> > Not only. I noticed that another put_device under label "Error:".
> >=20
>=20
> That label is called when we failed to add the kobject to its parent.
> It just puts the parent of the device. I don't think it has anything
> to do with us put_device()-ing the actual device too.
>=20
OK, you are right. I read some kobject related codes and get:

static inline void kref_init(struct kref *kref)
{
        atomic_set(&kref->refcount, 1);
}

The init refcount is 1, which means even if we meet an error and put_device
in device_add, we still need an extra put_device to make refcount =3D 0
and then release the dev object.

BTW, from the comments of device_register:

"NOTE: _Never_ directly free @dev after calling this function, even
 if it returned an error! Always use put_device() to give up the
 reference initialized in this function instead. "

Many caller don't follow this logic. For example:
in arch/arm/common/locomo.c
locomo_init_one_child
=2E..
        ret =3D device_register(&dev->dev);
        if (ret) {
out:
                kfree(dev);
        }
=2E..
=20
in arch/parisc/kernel/drivers.c
create_tree_node
=2E..
        if (device_register(&dev->dev)) {
                kfree(dev);
                return NULL;
        }
=2E..

etc.

Maybe we need one more patch to fix them all. :-)
> --=20
> Regards,
> Levente Kurusa
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSn+ulAAoJEI01n1+kOSLHekAP/2qGijIWvxDe3ekFVAKvywaH
J3rAurbzvk+uJn/ZoOXOhWJ6EkctoG7NMionVmgvaeSnGnIj5uye6NTzzD5pfWTv
b6nKQpSb/doxmcYersAm5rn3WSDPTrB+I7915/nP5HH/6aVLojPOAE+ON6JxM8yp
mqA3gGyvddUgErplRZE0wFhJ2dnG6w45Zt1POeDCN3akwAv2cgvmoVxQitwwY1LY
cYxO8roVuxi7BcS3qvc85JQyXV1gr3TQxVW1xXLxQfY9G8Fap2vDZuMTaDW0wnju
S+/3+3TAudjbSgAGORk4yfvG91dn+8AtS4ut97nEp3H0ZCUaBvxhu/S/Y2RYJYK3
CJ9ohxDbSCvT0J6bvZOGRA4Uhuawe4l6PHTLvFB5sfLsei4Spw5afpep2st7A3E5
2VJLtyXgEWFu6JisMmq+sxHjvi8PQWIc2GGhUGICgiFo3hCgnVasLXn9dm8g2rca
KhFlgGL8WYYzPvL0wxVZ3uIGPyf2TzA67TaNPzDLshhnuufw8ZxTga/p0przKx6g
d32QwW6S+t6PisuSphnwHku08QVLrvHqOVqCvi0jvQVLxzdbdXm5DNDBP+Pd7fR9
UiB7eNQB/VmrB0ht9+FZtHOZo/iTzsVyiJnPonWKxdcWrcV9IPcZAgxA5FCPkJP3
GAohR2LbKVyIee08glQJ
=l25A
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
