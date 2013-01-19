Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab3ASENg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 23:13:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59529 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754099Ab3ASENe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 23:13:34 -0500
Message-ID: <1358568804.24121.16.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 10/21] target: Add link_magic for fabric allow_link
 destination target_items
From: Ben Hutchings <ben@decadent.org.uk>
To: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        CAI Qian <caiqian@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 19 Jan 2013 04:13:24 +0000
In-Reply-To: <20130119010713.123101960@linuxfoundation.org>
References: <20130119010710.897187774@linuxfoundation.org>
	 <20130119010713.123101960@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-f0NBTnPYIidaPmPBoto+"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f0NBTnPYIidaPmPBoto+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-01-18 at 17:19 -0800, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>=20
> commit 0ff8754981261a80f4b77db2536dfea92c2d4539 upstream.
>=20
> This patch adds [dev,lun]_link_magic value assignment + checks within gen=
eric
> target_fabric_port_link() and target_fabric_mappedlun_link() code to ensu=
re
> destination config_item *target_item sent from configfs_symlink() ->
> config_item_operations->allow_link() is the underlying se_device->dev_gro=
up
> and se_lun->lun_group that we expect to symlink.
[...]=20
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -72,6 +72,12 @@ static int target_fabric_mappedlun_link(
>  	struct se_portal_group *se_tpg;
>  	struct config_item *nacl_ci, *tpg_ci, *tpg_ci_s, *wwn_ci, *wwn_ci_s;
>  	int ret =3D 0, lun_access;
> +
> +	if (lun->lun_link_magic !=3D SE_LUN_LINK_MAGIC) {
> +		pr_err("Bad lun->lun_link_magic, not a valid lun_ci pointer:"
> +			" %p to struct lun: %p\n", lun_ci, lun);
> +		return -EFAULT;
> +	}
>  	/*
>  	 * Ensure that the source port exists
>  	 */
[...]

This is absolutely not a valid way of doing dynamic type checking.

The problem is that these structures:

> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -779,6 +779,8 @@ struct se_subsystem_dev {
>  };
> =20
>  struct se_device {
> +#define SE_DEV_LINK_MAGIC			0xfeeddeef
> +	u32			dev_link_magic;
>  	/* RELATIVE TARGET PORT IDENTIFER Counter */
>  	u16			dev_rpti_counter;
>  	/* Used for SAM Task Attribute ordering */
> @@ -869,6 +871,8 @@ struct se_port_stat_grps {
>  };
> =20
>  struct se_lun {
> +#define SE_LUN_LINK_MAGIC			0xffff7771
> +	u32			lun_link_magic;
>  	/* See transport_lun_status_table */
>  	enum transport_lun_status_table lun_status;
>  	u32			lun_access;

have struct config_group embedded at different places.  So you know
where the magic number is for the expected type but if you get an object
of the wrong type then you'll read some other area of memory that might
just happen to have the expected magic number anyway.

It seems like you need a superclass for all the structures exposed
through configfs, to hold the type information.  I would suggest that
you define something like:

struct se_config_group {
	struct config_group group;
	u32 magic;
};

and put that in place of the plain struct config_group.  You can then
safely check the magic number before looking at anything in the larger
structure.

Ben.

--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken.

--=-f0NBTnPYIidaPmPBoto+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUPodZOe/yOyVhhEJAQqVKw/+PcqqtQQnNGrp1qw82N6sMysYrfv/3kTs
ExkjQwvpxrwxySI2/D+pkb68HLRLM+Fds3AMsEGkMImCtcFgzpbxHjNgFvrsSqt+
pRfJCQO6aRzrW1qtVLsA82/ZzNmIAyp8FklZreNY+8aIjwZVs+9yCBdHvsTspxdB
iMK9765VLgHfkSTb2/j42ImuR70HVyxlR1njXkA8Z5DSp9khJeJ/m00sHprWMzAw
7WQ5id1xVmgrEdqWq9ByugsQAI9iB8Z1vCfJzRqL3Hc0cz1xMKcb/xw7GGHizmVY
Jk0B1ehyI4j4V2B8K/QZ7Mnz83OW1wZ5W8Py36/9a122BTgKde0zQLiV7100p8wy
ZThh34cvWiF24UsNYhzBfk859HN63BWj6sATbKT9UyFfZqYUS/e5MgVGX9bY2NIw
Pi2LcUgAexaZt7x4ZhKcu2j/uYsOExImg9SMH0dd7lmA02rlEfEMHBAd7mmK8iva
jNfW8sG+ilJTW8wcC8v3IthGFBste/SBS6Y7QaAb//u7KSxoNlF772sAwLAAhATa
VYwy0POxv0bBua1B6K+UEMeoKr4ihR4I+3S8A3lWbaFmpowiGh2odnT17bAemxlO
nsumoTywrMS6rmXpIjcckSQOsgBhcXxhIUlvVG4MBxJV9v5v3PzCUo+B/zL3uHQm
5lzm/qrE0zg=
=WyGU
-----END PGP SIGNATURE-----

--=-f0NBTnPYIidaPmPBoto+--
