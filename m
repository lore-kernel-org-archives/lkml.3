Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309AbbAFLgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:36:37 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:61826 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755105AbbAFLgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:36:33 -0500
Date: Tue, 6 Jan 2015 12:36:28 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Lucas Stach <dev@lynxeye.de>, swarren@wwwdotorg.org, gnurou@gmail.com,
        bskeggs@redhat.com, martin.peres@free.fr, seven@nimrod-online.com,
        samuel.pitoiset@gmail.com, nouveau@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nouveau 06/11] platform: complete the power up/down
 sequence
Message-ID: <20150106113626.GC31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-7-git-send-email-vinceh@nvidia.com>
 <1419427385.2179.13.camel@lynxeye.de>
 <549B79B2.6010301@nvidia.com>
 <20150105152552.GH12010@ulmo.nvidia.com>
 <54ABAC09.4080306@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <54ABAC09.4080306@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 05:34:01PM +0800, Vince Hsu wrote:
>=20
> On 01/05/2015 11:25 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Thu, Dec 25, 2014 at 10:42:58AM +0800, Vince Hsu wrote:
> >>On 12/24/2014 09:23 PM, Lucas Stach wrote:
> >>>Am Dienstag, den 23.12.2014, 18:39 +0800 schrieb Vince Hsu:
> >>>>This patch adds some missing pieces of the rail gaing/ungating sequen=
ce that
> >>>>can improve the stability in theory.
> >>>>
> >>>>Signed-off-by: Vince Hsu <vinceh@nvidia.com>
> >>>>---
> >>>>  drm/nouveau_platform.c | 42 +++++++++++++++++++++++++++++++++++++++=
+++
> >>>>  drm/nouveau_platform.h |  3 +++
> >>>>  2 files changed, 45 insertions(+)
> >>>>
> >>>>diff --git a/drm/nouveau_platform.c b/drm/nouveau_platform.c
> >>>>index 68788b17a45c..527fe2358fc9 100644
> >>>>--- a/drm/nouveau_platform.c
> >>>>+++ b/drm/nouveau_platform.c
> >>>>@@ -25,9 +25,11 @@
> >>>>  #include <linux/module.h>
> >>>>  #include <linux/platform_device.h>
> >>>>  #include <linux/of.h>
> >>>>+#include <linux/of_platform.h>
> >>>>  #include <linux/reset.h>
> >>>>  #include <linux/regulator/consumer.h>
> >>>>  #include <soc/tegra/fuse.h>
> >>>>+#include <soc/tegra/mc.h>
> >>>>  #include <soc/tegra/pmc.h>
> >>>>  #include "nouveau_drm.h"
> >>>>@@ -61,6 +63,9 @@ static int nouveau_platform_power_up(struct nouveau=
_platform_gpu *gpu)
> >>>>  	reset_control_deassert(gpu->rst);
> >>>>  	udelay(10);
> >>>>+	tegra_mc_flush(gpu->mc, gpu->swgroup, false);
> >>>>+	udelay(10);
> >>>>+
> >>>>  	return 0;
> >>>>  err_clamp:
> >>>>@@ -77,6 +82,14 @@ static int nouveau_platform_power_down(struct nouv=
eau_platform_gpu *gpu)
> >>>>  {
> >>>>  	int err;
> >>>>+	tegra_mc_flush(gpu->mc, gpu->swgroup, true);
> >>>>+	udelay(10);
> >>>>+
> >>>>+	err =3D tegra_powergate_gpu_set_clamping(true);
> >>>>+	if (err)
> >>>>+		return err;
> >>>>+	udelay(10);
> >>>>+
> >>>>  	reset_control_assert(gpu->rst);
> >>>>  	udelay(10);
> >>>>@@ -91,6 +104,31 @@ static int nouveau_platform_power_down(struct nou=
veau_platform_gpu *gpu)
> >>>>  	return 0;
> >>>>  }
> >>>>+static int nouveau_platform_get_mc(struct device *dev,
> >>>>+		struct tegra_mc **mc, unsigned int *swgroup)
> >>>Uhm, no. If this is needed this has to be a Tegra MC function and not
> >>>burried into nouveau code. You are using knowledge about the internal
> >>>workings of the MC driver here.
> >>>
> >>>Also this should probably only take the Dt node pointer as argument and
> >>>return a something like a tegra_mc_client struct that contains both the
> >>>MC device pointer and the swgroup so you can pass that to
> >>>tegra_mc_flush().
> >>Good idea. I will have something as below in V2 if there is no other
> >>comments for this.
> >>
> >>tegra_mc_client *tegra_mc_find_client(struct device_node *node)
> >>{
> >>     ...
> >>     ret =3D of_parse_phandle_with_args(node, "nvidia,memory-client", .=
=2E.)
> >>     ...
> >>}
> >>
> >>There were some discussion about this few weeks ago. I'm not sure wheth=
er we
> >>have some conclusion/implementation though. Thierry?
> >>
> >>http://lists.infradead.org/pipermail/linux-arm-kernel/2014-December/308=
703.html
> >I don't think client is a good fit here. Flushing is done per SWGROUP
> >(on all clients of the SWGROUP). So I think we'll want something like:
> >
> >	gpu@0,57000000 {
> >		...
> >		nvidia,swgroup =3D <&mc TEGRA_SWGROUP_GPU>;
> >		...
> >	};
> >
> >In the DT and return a struct tegra_mc_swgroup along the lines of:
> >
> >	struct tegra_mc_client {
> >		unsigned int id;
> >		unsigned int swgroup;
> >
> >		struct list_head list;
> >	};
> >
> >	struct tegra_mc_swgroup {
> >		struct list_head clients;
> >		unsigned int id;
> >	};
> >
> >Where tegra_mc_swgroup.clients is a list of struct tegra_mc_client
> >structures, each representing a memory client pertaining to the
> >SWGROUP.
> Based on your suggestion above, I created a struct tegra_mc_swgroup:
>=20
> struct tegra_mc_swgroup {
>     unsigned int id;
>     struct tegra_mc *mc;
>     struct list_head head;
>     struct list_head clients;
> };
>=20
> And added the list head in the struct tegra_mc_soc.
>=20
> struct tegra_mc_soc {
>     struct tegra_mc_client *clients;
>     unsigned int num_clients;
>=20
>     struct tegra_mc_hr *hr_clients;
>     unsigned int num_hr_clients;

Why do you still need these?

>     struct list_head swgroups;

This doesn't belong in struct tegra_mc_soc because that's meant to be
static information about the specific variant of the memory-controller.
Put it in struct tegra_mc instead.

> ...
>=20
> Created one function to build the swgroup list.
>=20
> static int tegra_mc_build_swgroup(struct tegra_mc *mc)
> {
>     int i;
>=20
>     for (i =3D 0; i < mc->soc->num_clients; i++) {
>         struct tegra_mc_swgroup *sg;
>         bool found =3D false;
>=20
>         list_for_each_entry(sg, &mc->soc->swgroups, head) {
>             if (sg->id =3D=3D mc->soc->clients[i].swgroup) {
>                 found =3D true;
>                 break;
>             }
>         }

Can't you use your new tegra_mc_find_swgroup() function here? That way
you could turn it into something slightly more readable:

	unsigned int swgroup =3D mc->soc->clients[i].swgroup;
	struct tegra_mc_swgroup *group;

	group =3D tegra_mc_find_swgroup(mc, swgroup);
	if (!group) {
		/* allocates and adds to mc->swgroups */
		group =3D tegra_mc_add_swgroup(mc, swgroup);
		if (!group)
			return -ENOMEM;
	}

	list_add_tail(&group->list, &mc->swgroups);

where tegra_mc_add_swgroup() is something like this:

	group =3D devm_kzalloc(mc->dev, sizeof(*group), GFP_KERNEL);
	if (!group)
		return NULL;

	INIT_LIST_HEAD(&group->clients);
	group->mc =3D mc;
	group->id =3D id;

I don't like very much how this duplicates information that is already
available in tegra_mc_soc, but I can't think of a better way to couple
the SWGROUP ID with the struct tegra_mc *, so I think we'll have to
proceed with something like the above.

Thierry

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq8i6AAoJEN0jrNd/PrOhaX4P/j4vAmLwv2hSDrP90cWpuZqb
+VME9sAkdr4uK29fkcEIh8a2MOPXKmiHRL4QoFDtNagZwGHGn32VQ/B3jdCMHCwK
IcqJwFrSvx+OaLBdj7tB587xUbI2EStCd6Hrfiy698pdshtujByybpvFDooEFwa9
AivBmxSuP3UO+PyQR9kKEL2L0kvyxR1vKcQYgLCx9rfnpfrE6G+dsZ2WZ5rJGMiC
1FLv5Y0IMQXgybagds2+6oDeJl+4mCTgFqcOSDrP53gut9CBY4fZZJ+1YNS2vpA+
AXFdidgmp0SXB0+vb1aZceZ1NaA0CSYlocZWpyg+GEcNP7rVXPq+LLupUHze+/Iq
RUkQVGz1TwYV2tIM2z5nWm3eLqslVKD+PzGRph0PWhuQ7qaRBYF2TQ/TtJm94+L5
QcaTbGIxyXjIy05zJG+HrWQzGhbFt8RWn0w0sdGb/Ao5ONxJlmOICM7gvoFxL4nd
kdKFHr9mng2nSnt6MZSIEgPCWHLeDBQi24WhDXh9i0jPe6p0vMiRn9VnsYSo5PSr
U8tXRpnr+N8E192OSjr9jocueOI1VdPIV25VhBw730FQAsAPYpVCsPY8oEVzkHUH
Y4hUHLZkHLPotimLVUgYYVyVxbf5Hc8RSJrdIR4Vd64kUs+YDrSUriedrx1F7ZbO
S03wCDO0wRQyw1kQ8nd5
=6N0V
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
