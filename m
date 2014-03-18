Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbaCRVWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:22:54 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:43368 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaCRVWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:22:50 -0400
Date: Tue, 18 Mar 2014 14:22:43 -0700
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Cong Wang <cwang@twopensource.com>
Cc: "Luis R. Rodriguez" <mcgrof@suse.com>, netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH 2/3] bridge: trigger a bridge calculation upon port
 changes
Message-ID: <20140318212243.GD28471@garbanzo.do-not-panic.com>
References: <1394680527-28970-1-git-send-email-mcgrof@do-not-panic.com>
 <1394680527-28970-3-git-send-email-mcgrof@do-not-panic.com>
 <CAHA+R7Pf6rM5h1uGiqrru5LkN9C7Nm7V42cucHSOV1s7_+F7Gw@mail.gmail.com>
 <20140315013940.GA28801@wotan.suse.de>
 <CAHA+R7MRVyjAN7w_qPxSxkrjo939bNEc3Ej+O3yH-oWj4gGJxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <CAHA+R7MRVyjAN7w_qPxSxkrjo939bNEc3Ej+O3yH-oWj4gGJxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 18, 2014 at 01:46:49PM -0700, Cong Wang wrote:
> On Fri, Mar 14, 2014 at 6:39 PM, Luis R. Rodriguez <mcgrof@suse.com> wrot=
e:
> > On Thu, Mar 13, 2014 at 11:26:25AM -0700, Cong Wang wrote:
> >> On Wed, Mar 12, 2014 at 8:15 PM, Luis R. Rodriguez
> >> <mcgrof@do-not-panic.com> wrote:
> >> >                         spin_unlock_bh(&p->br->lock);
> >> > +                       if (changed)
> >> > +                               call_netdevice_notifiers(NETDEV_CHAN=
GEADDR,
> >> > +                                                        p->br->dev);
> >> > +                       netdev_update_features(p->br->dev);
> >>
> >> I think this is supposed to be in netdev event handler of br->dev
> >> instead of here.
> >
> > Do you mean netdev_update_features() ? I mimic'd what was being done on
> > br_del_if() given that root blocking is doing something similar. If
> > we need to change something for the above then I suppose it means we ne=
ed
> > to change br_del_if() too. Let me know if you see any reason for someth=
ing
> > else.
> >
>=20
> Yeah, for me it looks like it's better to call netdev_update_features()
> in the event handler of br->dev, rather than where calling
> call_netdevice_notifiers(..., br->dev);.

I still don't see why, in fact trying to verify this I am wondering now
if instead we should actually fix br_features_recompute() to take into
consideration BR_ROOT_BLOCK as below. Notice how netdev_update_features()
is called above even if the MAC address did not change, just as is done
on br_del_if(). There is an NETDEV_FEAT_CHANGE event so would it be more
appropriate we just call

call_netdevice_notifiers(NETDEV_FEAT_CHANGE, p->br->dev)

for both the above then and also br_del_if()? How about the below
change?

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 54d207d..dcd9378 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -315,6 +315,8 @@ netdev_features_t br_features_recompute(struct net_brid=
ge *br,
 	features &=3D ~NETIF_F_ONE_FOR_ALL;
=20
 	list_for_each_entry(p, &br->port_list, list) {
+		if (p->flags & BR_ROOT_BLOCK)
+			continue;
 		features =3D netdev_increment_features(features,
 						     p->dev->features, mask);
 	}

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTKLkjAAoJEKwtdpJg+MHGMskP/R2MDoZSYYd06xXAk3Ty5g+S
m0F7fJaPFxNf2HTccY2gnNVOrqc1T70lSKycn5iH36War6k8emxFwYToO8u2I5h/
p86QR4egU98CPz6Ry/dn5HnAW0B1glYnaZQBFiMcNcDMa3RvEIPndcV4H6GfJnCx
fL/1CXzIzyh8xazlPzTnN3jgZCVrsnx0M4jTgNzw2F7pWCx9377z0lnIYHYiw24n
dnwa1bLucYZ5hY4lIAccBfpV1mUFkOafwP8qbNrkrnnFORUo2gmx60tQ3uz+A8Bo
8BHQB50pAu3yKU14PkHL77o+h18Btj3i9/mwGRpkdL4C40BhrLI965LIDn9Lj/73
oYes1C5NqYuzESZ9hDqhduHo35YL2XbNiewogSaBYqOcS8bYhR1nvikvQiu5z0vg
uQsB8kcJxJKHhTGmLrNn2MP/4KzXdujisiLnzk3EoNlVcB1FaBk5Rcg0XcvZAl8q
8eJQMSMv3RIoXHYQu59Xbk/3FLmQoYxOZA2cjwksu4qcMYR5XgvEXB7fTjBk8bL2
lwRtIwj28TSuHB6F1a6G3gSu0ormn0XUrwU7zygLpMtCsTv0zTZtNkai/73eryG0
2n1xNFEBrdvSWX7+4L+wpcVZFjF+MbxX0sXQ1FtymzJ12oMOjOzSXn3mSadQNCVX
HFX9EPcwpF5+/HzbYTwF
=oy77
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
