Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab3CSBSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 21:18:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40952 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754222Ab3CSBSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 21:18:37 -0400
Message-ID: <1363655903.3937.350.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 04/21] target/pscsi: Fix page increment
From: Ben Hutchings <ben@decadent.org.uk>
To: Asias He <asias@redhat.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        target-devel <target-devel@vger.kernel.org>
Date: Tue, 19 Mar 2013 01:18:23 +0000
In-Reply-To: <20130319005659.GB15879@hj.localdomain>
References: <20130312223245.109098379@linuxfoundation.org>
	 <20130312223245.664885170@linuxfoundation.org>
	 <1363399822.3937.161.camel@deadeye.wl.decadent.org.uk>
	 <20130318053519.GE6232@hj.localdomain>
	 <1363640434.3156.36.camel@haakon2.linux-iscsi.org>
	 <1363649447.3937.348.camel@deadeye.wl.decadent.org.uk>
	 <20130319005659.GB15879@hj.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Q0o54vILwLAc2gWg+fCO"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q0o54vILwLAc2gWg+fCO
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-19 at 08:56 +0800, Asias He wrote:
> On Mon, Mar 18, 2013 at 11:30:47PM +0000, Ben Hutchings wrote:
> > On Mon, 2013-03-18 at 14:00 -0700, Nicholas A. Bellinger wrote:
> > > On Mon, 2013-03-18 at 13:35 +0800, Asias He wrote:
> > > > On Sat, Mar 16, 2013 at 02:10:22AM +0000, Ben Hutchings wrote:
> > > > > On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> > > > > > 3.0-stable review patch.  If anyone has any objections, please =
let me know.
> > > > > >=20
> > > > > > ------------------
> > > > > >=20
> > > > > > From: Asias He <asias@redhat.com>
> > > > > >=20
> > > > > > commit 472b72f2db7831d7dbe22ffdff4adee3bd49b05d upstream.
> > > > > >=20
> > > > > > The page++ is wrong. It makes bio_add_pc_page() pointing to a w=
rong page
> > > > > > address if the 'while (len > 0 && data_len > 0) { ... }' loop i=
s
> > > > > > executed more than one once.
> > > > > >=20
> > > > > > Signed-off-by: Asias He <asias@redhat.com>
> > > > > > Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> > > > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > > >=20
> > > > > > ---
> > > > > >  drivers/target/target_core_pscsi.c |    1 -
> > > > > >  1 file changed, 1 deletion(-)
> > > > > >=20
> > > > > > --- a/drivers/target/target_core_pscsi.c
> > > > > > +++ b/drivers/target/target_core_pscsi.c
> > > > > > @@ -1210,7 +1210,6 @@ static int __pscsi_map_task_SG(
> > > > > >  				bio =3D NULL;
> > > > > >  			}
> > > > > > =20
> > > > > > -			page++;
> > > > > >  			len -=3D bytes;
> > > > > >  			data_len -=3D bytes;
> > > > > >  			off =3D 0;
> > > > >=20
> > > > > So in case a fragment crosses a page boundary, we wrap around to =
the
> > > > > beginning of the same page?  That doesn't look right.
> > > >=20
> > > > If the fragment crosses a page boundary, what is the correct page
> > > > for it?
> > > >=20
> > > > Nicholas, can we assume sg->length + sg->offset should be less than=
 PAGE_SIZE here?
> > > >=20
> > >=20
> > > sg->length + sg->offset can be less than or equal to PAGE_SIZE here.
> > >
> > > For everything other than tcm_loop + tcm_vhost using externally
> > > allocated SGLs, we can expect fragments to never cross the page
> > > boundary.
> > >=20
> > > For tcm_loop + tcm_vhost, there are a few special cases with control =
CDB
> > > paylaods (usually going through scsi-generic) where we can have a non
> > > zero sg->offset, but at least in the cases I've seen this is still no=
t
> > > using SGL elements that exceed PAGE_SIZE.
> > >
> > > So, I think this logic is OK for SGLs that cross page boundries, give=
n
> > > that it's done outside of the inner loop where *page is set during ea=
ch
> > > for_each_sg().
> >=20
> > The page is set using sg_page() in the outer loop and was then
> > incremented in the inner loop.
> >=20
> > 	for_each_sg(sgl, sg, sgl_nents, i) {
> > 		page =3D sg_page(sg);
> > 		off =3D sg->offset;
> > 		len =3D sg->length;
> >=20
> > 		while (len > 0 && data_len > 0) {
> > 			bytes =3D min_t(unsigned int, len, PAGE_SIZE - off);
> > 			bytes =3D min(bytes, data_len);
> > 			...
> > 			/* page++; */
> > 			len -=3D bytes;
> > 			data_len -=3D bytes;
> > 			off =3D 0;
> > 		}
> > 	}
> >=20
> > The inner loop is apparently meant to iterate over pages of a segment,
> > but is now just wrapping around a single page.
>=20
> Yes, but we never loop more than once in the inner loop.

If you're sure of that, then:

> So, how about
> 1) fail on  sg->offset + sg->length > PAGE_SIZE (we can not find a
> proper page address in this case)
> 2) remove the inner while loop, run the code was in the loop only once.

this is fine, but then I don't understand why you sent a no-op change to
stable in the first place.

Ben.

--=20
Ben Hutchings
When you say `I wrote a program that crashed Windows', people just stare ..=
.
and say `Hey, I got those with the system, *for free*'. - Linus Torvalds

--=-Q0o54vILwLAc2gWg+fCO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUe83+e/yOyVhhEJAQoMlhAAzXSh0LvVc3FwmgPk8KCSIq5Pv3J7gHC8
lGK/BK1oRBxNjkuLrc5sS7FCPeFibZK/cjR/geg34tZ8FPPCGqEle7X+Nf2c6RF3
4QZfFveMfcmxlhsG0Gp3iB2Q+DKvV1nD6PXxD6BEN4ue7Uta8qqiDK3PbGxMaiaA
GHqgxtpzDjNS+0ZHHtpGR1eWywuQQ0qnQzjM/AzX1O31cKP3L4damZQOtXwcgHDn
Gugwm3BAvJ+R8P4h/usMiyYLcnkDG1HndQzeeJEPc0bRUXQN5fDnsJOOncB4MyqF
lw6/4RE4fxBXK15cTIElafUOorBy8IQUVbkw1YkVi3DcI5mGiGrfXcmXnAIpurAH
xhvUvkdCcaka/F8IK9T1VT6wkx5P+bKO/6tJtlJN1WK3OKgnoxkAzaijX4Bhvctg
JqhpMRMM09bpKtEgYPpuES+lScDlUNsiex1oOcZHnE6jzRxTsMVcXJEH6LVKFjpV
Qb9guYjW1h5te1BQhvr4F7BAeE/gjzHhJJnfXVx7Z78vxELxFsUs8vjlvGYoBtCc
MBOcnaMDRtRita1BySBcyFvoTYJdrAhjMujbTdbgdeLs0FVrtlR4XNu0xDv7aFTU
PwS3fOE2gjeA8bJ266faKOuq18Ln91f1mapJ1pxSQksKTUFoBgSm640deU+LI+mv
D//doulkL+A=
=WOnf
-----END PGP SIGNATURE-----

--=-Q0o54vILwLAc2gWg+fCO--
