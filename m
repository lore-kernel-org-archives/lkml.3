Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3G0Q4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 12:56:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59947 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354Ab3G0Q4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 12:56:07 -0400
Message-ID: <1374944157.13555.43.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 42/79] vlan: fix a race in egress prio management
From: Ben Hutchings <ben@decadent.org.uk>
To: Eric Dumazet <edumazet@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Jul 2013 17:55:57 +0100
In-Reply-To: <20130726204726.846842461@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204726.846842461@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hj8/HHSM/OVDlO2T3Zr4"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hj8/HHSM/OVDlO2T3Zr4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-07-26 at 13:47 -0700, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Eric Dumazet <edumazet@google.com>
>=20
> [ Upstream commit 3e3aac497513c669e1c62c71e1d552ea85c1d974 ]
>=20
> egress_priority_map[] hash table updates are protected by rtnl,
> and we never remove elements until device is dismantled.
>=20
> We have to make sure that before inserting an new element in hash table,
> all its fields are committed to memory or else another cpu could
> find corrupt values and crash.
>=20
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Patrick McHardy <kaber@trash.net>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  net/8021q/vlan_dev.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> --- a/net/8021q/vlan_dev.c
> +++ b/net/8021q/vlan_dev.c
> @@ -73,6 +73,8 @@ vlan_dev_get_egress_qos_mask(struct net_
>  {
>  	struct vlan_priority_tci_mapping *mp;
> =20
> +	smp_rmb(); /* coupled with smp_wmb() in vlan_dev_set_egress_priority() =
*/
> +
>  	mp =3D vlan_dev_priv(dev)->egress_priority_map[(skb->priority & 0xF)];

This barrier is the wrong type in the wrong place; there should be a
smp_read_barrier_depends() *after* reading the pointer from
egress_priority_map, and after reading each next pointer.

(In practice, I think this error is harmless except on Alpha.  So the
patch is worth applying anyway.)

Ben.

>  	while (mp) {
>  		if (mp->priority =3D=3D skb->priority) {
> @@ -249,6 +251,11 @@ int vlan_dev_set_egress_priority(const s
>  	np->next =3D mp;
>  	np->priority =3D skb_prio;
>  	np->vlan_qos =3D vlan_qos;
> +	/* Before inserting this element in hash table, make sure all its field=
s
> +	 * are committed to memory.
> +	 * coupled with smp_rmb() in vlan_dev_get_egress_qos_mask()
> +	 */
> +	smp_wmb();
>  	vlan->egress_priority_map[skb_prio & 0xF] =3D np;
>  	if (vlan_qos)
>  		vlan->nr_egress_mappings++;

--=20
Ben Hutchings
Once a job is fouled up, anything done to improve it makes it worse.

--=-hj8/HHSM/OVDlO2T3Zr4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUfP7nee/yOyVhhEJAQq62A//ai98Wr7D8vTOClXr53lY+IywcFo7Xuu0
oNW1m+tkji6iKRJCL6XSZoCuZjv7yjKPCWJGguFsIKPz1wPI6LhZdKr/oJMlLjHV
Sw9laahFxa3Sb/8Bk1Y0v58FdcrpsMoGMjZPC4Ncr0ZAcW77epdS0j5irTyuPwP7
KDBpuqqmvgvvA2JtbJMg/qHIdtfmOTaH88vPcO1Xufvenn6SHnEnsyBPnDHAxwYb
5DKLRA3iMMy+Q2IFEmLBccE2EHYFVJiuKDmBl7kR5eUQRJGju8a0RU955fpSAUke
NhaUs2TRx5pzZzgnr+oN2MtYkzq5q5FxUmNym0jQS5WwkAbf0teJZ9sRUrWRc8ku
+hSYlUb9dBz6yKAY5RI/KSZ+/G3wi4KAEkSfAGzSi2AYmF3TkJYiol9eTK1Jt6Tz
akAv8vBdTFsvVCOe0d7muXt6fyswJerxq67+nJ0euSp1vqVLYqyqjSz1iPHQsGAB
mPSvSGCc24bhVmF2CH8fH3kDTbAszv/xD1P5ZbVk7HZw97VV6u5vpDD+JGUAoUiK
4GlS7oWCaV8PJO3x3S9l85wdT+SlQqoWjp/F+0A+uzsKFGsuW+VN7vbsuDm6gh3g
sEqWCPNqXGSzW554757+Lm3GJsJewomlYcHvt26hnw+9TTDKpMI75SaMUHa12AYW
Kf20HZtt5o4=
=laBw
-----END PGP SIGNATURE-----

--=-hj8/HHSM/OVDlO2T3Zr4--
