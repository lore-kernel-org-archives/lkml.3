Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3L0WAD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 17:00:03 -0500
Received: from mga09.intel.com ([134.134.136.24]:40372 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754786Ab3L0WAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 17:00:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,562,1384329600"; 
   d="asc'?scan'208";a="430826669"
Message-ID: <1388181598.2183.176.camel@jtkirshe-mobl>
Subject: Re: [PATCH] i40e: use ether_addr_equal_64bits
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net, Julia Lawall <julia.lawall@lip6.fr>
Date: Fri, 27 Dec 2013 13:59:58 -0800
In-Reply-To: <1388181371.30298.38.camel@joe-AO722>
References: <52BD22ED.4030302@huawei.com>
	 <1388159283.12212.80.camel@edumazet-glaptop2.roam.corp.google.com>
	 <1388163982.30298.12.camel@joe-AO722>
	 <alpine.DEB.2.02.1312272112110.2018@localhost6.localdomain6>
	 <1388177217.30298.24.camel@joe-AO722> <1388181371.30298.38.camel@joe-AO722>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-MrLncDV2xTjMWa3m3dqG"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MrLncDV2xTjMWa3m3dqG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-12-27 at 13:56 -0800, Joe Perches wrote:
> All ether_addr_equal tests in i40e can use the
> slightly more efficient ether_addr_equal_64bits.
>=20
> All addresses passed to the various functions that
> use ether_addr_equal are using structs that have 2
> or more bytes of additional data after the mac addr
> being tested.
>=20
> struct i40e_mac_filter.macaddr[6] (followed by s16 vlan)
> struct net_device.dev_addr (pointer to char array of MAX_ADDR_LEN)
> struct sockaddr.sa_data (array of 14 bytes)
> struct netdev_hw_addr.addr (pointer to char array of MAX_ADDR_LEN)
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

It looks good, but I would like Jesse and Shannon to review it since we
just were talking about a similar patch last week.

I will add the patch to my queue for now, thanks Joe.

> ---
>=20
> On Fri, 2013-12-27 at 12:46 -0800, Joe Perches wrote:
> > On Fri, 2013-12-27 at 21:12 +0100, Julia Lawall wrote:
> > > On Fri, 27 Dec 2013, Joe Perches wrote:
> > >=20
> > > > On Fri, 2013-12-27 at 07:48 -0800, Eric Dumazet wrote:
> > > > > On Fri, 2013-12-27 at 14:49 +0800, Ding Tianhong wrote:
> > > > > > Use possibly more efficient ether_addr_equal
> > > > > > to instead of memcmp.
> > > > []
> > > > > > diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
> > > > []
> > > > > > @@ -549,7 +549,7 @@ static __be16 plip_type_trans(struct sk_buf=
f *skb, struct net_device *dev)
> > > > > > =20
> > > > > >  	if(*eth->h_dest&1)
> > > > > >  	{
> > > > > > -		if(memcmp(eth->h_dest,dev->broadcast, ETH_ALEN)=3D=3D0)
> > > > > > +		if(ether_addr_equal(eth->h_dest, dev->broadcast))
> > > > > >  			skb->pkt_type=3DPACKET_BROADCAST;
> > > > > >  		else
> > > > > >  			skb->pkt_type=3DPACKET_MULTICAST;
> > > > >=20
> > > > > What about :
> > > > >=20
> > > > >         if (is_multicast_ether_addr(eth->h_dest)) {
> > > > >                 if (ether_addr_equal_64bits(eth->h_dest, dev->bro=
adcast))
> > > > >                         skb->pkt_type =3D PACKET_BROADCAST;
> > > > >                 else
> > > > >                         skb->pkt_type =3D PACKET_MULTICAST;
> > > > >         }
> > > >=20
> > > > That is better though I wonder how many systems are
> > > > still using laplink via parallel null-printer cables.
> > > >=20
> > > > No matter, better is better.
> > > >=20
> > > > The same optimization using ether_addr_equal_64bits
> > > > may be possible to do in other places given other
> > > > structs too.
> > > >=20
> > > > Perhaps it's a possible spatch/coccinelle conversion,
> > > >=20
> > > > I don't know spatch well enough to know if a
> > > > mechanism to check if structure members have other
> > > > fields that follow them in the structure or if the
> > > > structure member is an array of a minimum size.
> > > >=20
> > > > Maybe Julia does.  (cc'd)
> > >=20
> > > I'm not sure to competely understand the issues.  Could you explain m=
ore?
> >=20
> > Hi Julia.
> >=20
> > Maybe this explanation is helpful?
> >=20
> > ethernet addresses are u8[6] (48 bits)
> >=20
> > ether_addr_equal_64bits gets passed a pointer to u8[8]
> > and is more efficient on 64 bit architectures than
> > ether_addr_equal because the test can be done with a
> > single compare and shift.
> >=20
> > The idea is not to access past the end of the ethernet
> > address as appropriate (think pointer to eeprom or other
> > such end-of-addressable memory conditions)
> >=20
> > If a struct containing an ethernet address has additional
> > members after the ethernet address, or the u8[6] addressa
> > passed to ether_addr_equal is not going to access past
> > the end of memory or the structure, then
> > ether_addr_equal_64bits should be used in lieu of
> > ether_addr_equal.
>=20
> I believe this is correct, but maybe the
> conditions for using ether_addr_equal_64bits
> could be documented a bit better.
>=20
> Jeff/Intel folk?  What do you think?
>=20
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 18 +++++++++++-------
>  1 file changed, 11 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/et=
hernet/intel/i40e/i40e_main.c
> index efdf8a2..4c1d35c 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
> @@ -992,7 +992,7 @@ static struct i40e_mac_filter *i40e_find_filter(struc=
t i40e_vsi *vsi,
>  		return NULL;
> =20
>  	list_for_each_entry(f, &vsi->mac_filter_list, list) {
> -		if ((ether_addr_equal(macaddr, f->macaddr)) &&
> +		if (ether_addr_equal_64bits(macaddr, f->macaddr) &&
>  		    (vlan =3D=3D f->vlan)    &&
>  		    (!is_vf || f->is_vf) &&
>  		    (!is_netdev || f->is_netdev))
> @@ -1020,7 +1020,7 @@ struct i40e_mac_filter *i40e_find_mac(struct i40e_v=
si *vsi, u8 *macaddr,
>  		return NULL;
> =20
>  	list_for_each_entry(f, &vsi->mac_filter_list, list) {
> -		if ((ether_addr_equal(macaddr, f->macaddr)) &&
> +		if (ether_addr_equal_64bits(macaddr, f->macaddr) &&
>  		    (!is_vf || f->is_vf) &&
>  		    (!is_netdev || f->is_netdev))
>  			return f;
> @@ -1209,7 +1209,7 @@ static int i40e_set_mac(struct net_device *netdev, =
void *p)
> =20
>  	netdev_info(netdev, "set mac address=3D%pM\n", addr->sa_data);
> =20
> -	if (ether_addr_equal(netdev->dev_addr, addr->sa_data))
> +	if (ether_addr_equal_64bits(netdev->dev_addr, addr->sa_data))
>  		return 0;
> =20
>  	if (vsi->type =3D=3D I40E_VSI_MAIN) {
> @@ -1409,21 +1409,24 @@ static void i40e_set_rx_mode(struct net_device *n=
etdev)
> =20
>  		if (is_multicast_ether_addr(f->macaddr)) {
>  			netdev_for_each_mc_addr(mca, netdev) {
> -				if (ether_addr_equal(mca->addr, f->macaddr)) {
> +				if (ether_addr_equal_64bits(mca->addr,
> +							    f->macaddr)) {
>  					found =3D true;
>  					break;
>  				}
>  			}
>  		} else {
>  			netdev_for_each_uc_addr(uca, netdev) {
> -				if (ether_addr_equal(uca->addr, f->macaddr)) {
> +				if (ether_addr_equal_64bits(uca->addr,
> +							    f->macaddr)) {
>  					found =3D true;
>  					break;
>  				}
>  			}
> =20
>  			for_each_dev_addr(netdev, ha) {
> -				if (ether_addr_equal(ha->addr, f->macaddr)) {
> +				if (ether_addr_equal_64bits(ha->addr,
> +							    f->macaddr)) {
>  					found =3D true;
>  					break;
>  				}
> @@ -1889,7 +1892,8 @@ int i40e_vsi_kill_vlan(struct i40e_vsi *vsi, s16 vi=
d)
>  	list_for_each_entry(f, &vsi->mac_filter_list, list) {
>  		if (is_netdev) {
>  			if (f->vlan &&
> -			    ether_addr_equal(netdev->dev_addr, f->macaddr))
> +			    ether_addr_equal_64bits(netdev->dev_addr,
> +						    f->macaddr))
>  				filter_count++;
>  		}
> =20
>=20
>=20



--=-MrLncDV2xTjMWa3m3dqG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAABCgAGBQJSvfheAAoJEOVv75VaS+3OwzcQAIpZSKTvxSXaDlbMQko4btFG
XESCfFq+th7n55WXnWYk+7/4YAlY+n1oP3Ul8zmUGInvIZ8ZONJrV4w4Mg9zfLz9
5uP1GM/wX/OBICICUhKvq6CGZb0Q6B0/pY9loQNw0jclTcw0M4xyMG4HnyEdlcFt
eHUHjvfgapcolKTdWkNvdp3H03Rv4fQvwLJSVCPSySpPGodcwjpDZxOj8Nr2R3b8
eG+T4mizAmR9kUVcnaHc+S8oyD28IZps/M7TCU+dK98sRIJmnnNPpCj986Hs1soC
bcAUAaLTXKkfXf8QFNcoIs2hrYTohRrPyodfGCRKQG9m2aW/cy00/W4F7FGZ8Ckn
8G2nUQqN0aIUixlnr1MlbexXN8AibFSFhc2dxAQsc4bsePa7TEbk5J2jxfUWu8xX
8pP9RYcR2hEKODbnUdoSn1mhEaSYa/2aq207pMjxyhnFtDwevApTKvMg1aMxC23l
qp7pkalKTZbXw2U2uG3nQl6VN5eEzVnmo+0uwsaiWrT4wK6d3XuFFyoyOQstnZ8d
kZ4oWYfjfWVZzsA38adKZDQPQx5gh5G3rtwvncDouYIVfbCdJ0xbcQy/jXDlA8tG
qwUvo9FX33YV9/YRPUSRZHfNhFdakLaK1l6NehJDQ80wnrpBgb6ugvKgZscI1FSR
Y8bj1ZoGLnIbvCnslsuZ
=1+Ak
-----END PGP SIGNATURE-----

--=-MrLncDV2xTjMWa3m3dqG--

