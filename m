Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab3KAD7o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 23:59:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36409 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653Ab3KAD7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 23:59:42 -0400
Date: Fri, 1 Nov 2013 14:59:25 +1100
From: NeilBrown <neilb@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: devicetree@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Strange location and name for platform  devices when device-tree is
 used.
Message-ID: <20131101145925.66e22f73@notabene.brown>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/h1.1BrEVqtp4AKXPmb+vXJG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/h1.1BrEVqtp4AKXPmb+vXJG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable



My ARM board has a collection of "platform devices".

When I build a kernel using a board file, these platform devices are named
with exactly the names I give them, and they appear in sysfs under
   /sys/devices/platform

all as you might expect.

When I build a kernel using device-tree (and trying to follow the establish=
ed
patterns for the dts file),  these platform devices appear directly in
"/sys/devices" (not in the "platform" subdirectory) and  they don't have the
names I give them, but instead a sequential number is appended.

The former makes /sys/devices look very untidy.  It can presumably be fixed=
 by
changing of_platform_populate() to replace a parent for 'NULL' with
'platform_bus' as the patch below demonstrates.  Is there any chance that is
correct? (It seems to work, but for all I know it might break something els=
e).


The latter is caused by of_device_make_bus_id():

	/*
	 * No BusID, use the node name and add a globally incremented
	 * counter (and pray...)
	 */
	magic =3D atomic_add_return(1, &bus_no_reg_magic);
	dev_set_name(dev, "%s.%d", node->name, magic - 1);


This call to prayer dates back to:

commit 9309180f11f0107c9858a61a1ac2b04518a91080
Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date:   Tue Nov 21 14:56:37 2006 +1100

    [POWERPC] powerpc: Workaround for of_platform without "reg" nor "dcr-re=
g"

and I wonder how relevant it still is in this context.  As platform devices
are all in the root of the device-tree and hence are siblings, they must ha=
ve
unique names in the device-tree and  so the platform devices created from
them will also have unique names -- won't they?

Any help understanding and/or fixing this discrepancy greatly appreciated.

The change of name is particularly annoying to me because one of my platform
devices is a pwm_bl.c backlight.  With a boardfile I
get /sys/class/pwm_backlight.  With devicetree the best I can get
is /sys/class/pwm_backlight.23 (or similar).  It would be really nice to ha=
ve
a more stable and sensible name here.

Thanks,
NeilBrown

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 9b439ac63d8e..af3ef3513cb0 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -476,6 +476,9 @@ int of_platform_populate(struct device_node *root,
 	struct device_node *child;
 	int rc =3D 0;
=20
+	if (parent =3D=3D NULL)
+		parent =3D &platform_bus;
+
 	root =3D root ? of_node_get(root) : of_find_node_by_path("/");
 	if (!root)
 		return -EINVAL;

--Sig_/h1.1BrEVqtp4AKXPmb+vXJG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUnMnHTnsnt1WYoG5AQJVtA/6A6Qc5JcixlvXB0fiRfuEVFkYZLKq2nW4
1jxtm1SfWM08qoNPWjWBGvnzqJ9wk2VT/142JsyFcknpd6S7D7F8u4DHb01DdKKT
YBhcEHiINLhkRLagbe50kMUSMJJMCJYYTxRlVOPrPXULZZ92ARzCsR6llxlBSDB/
BKyFR1b0d+UljswXJyKu2RRv3mDr8AzJF+ZWsxKyf0oCZKF6SadJJW89L0VoFGqx
D+rjHRDA66agrVm7JkzMs3oTkh5zptAvi7anNYIVmurGgewiFkI4OyDM8K0n4sgK
No3fo6OMHsCdMW2liJmhrJeu+bhRAHzxGQJe2FgRhVNTQuMNO1y9AWOwo6M/RPeQ
BsbcE5LvAcMfamAOl3pRej8znJx2ZWsKy3nlMo34CCF35oUXUiL+cfIGxmRhGyTI
eXtqKkZX1B9rbiZGalmwAEUV8djahAxZk3rQ7jkDZtoLxynouE/Fd3hJ+VKHI6OD
Wfnk5V9ok62qQrXZXh/C44/lPXfz6ZGydGcJwqiXsICKikitkBXPCOKlKuJCj7o9
jnB2pe4D0/hNZg6+ukDY7Fsn0az5ZBRB2+c4cXKr4wGo7aZNlkVOeUX7t0Ge7Wfk
amR2RKfy3wQ0A64W1cHRPNlRsbE/LTYz6Z0bqN4rWvlIaSs7z13K5X6qd4+s1vD8
swfPRxWOygQ=
=6F/k
-----END PGP SIGNATURE-----

--Sig_/h1.1BrEVqtp4AKXPmb+vXJG--
