Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbbAUP4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:56:03 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:3954 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbbAUPzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:55:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Jan 2015 07:46:21 -0800
Date: Wed, 21 Jan 2015 16:55:21 +0100
From: Thierry Reding <treding@nvidia.com>
To: Tejun Heo <tj@kernel.org>
CC: Paul Walmsley <paul@pwsan.com>, <gregory.clement@free-electrons.com>,
        <hdegoede@redhat.com>, <pwalmsley@nvidia.com>,
        <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>,
        <linux-ide@vger.kernel.org>
Subject: Re: next-20150120 broken on Tegra by "ata: libahci: Allow using
 multiple regulators"
Message-ID: <20150121155519.GA25166@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1501210003010.5450@utopia.booyaka.com>
 <20150121105001.GA9921@ulmo.nvidia.com>
 <20150121123134.GD8684@htj.dyndns.org>
MIME-Version: 1.0
In-Reply-To: <20150121123134.GD8684@htj.dyndns.org>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.2.68.160]
X-ClientProxiedBy: UKMAIL102.nvidia.com (10.26.138.15) To
 UKMAIL101.nvidia.com (10.26.138.13)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IrhDeMKUP4DT/M7F
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2015 at 07:31:34AM -0500, Tejun Heo wrote:
> On Wed, Jan 21, 2015 at 11:50:03AM +0100, Thierry Reding wrote:
> > Tejun, preferably the attached patch should be squashed into commit
> > c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators") to avoid
> > breaking bisectability. If you don't want to rewrite history, let me
> > know and I can turn it into a proper patch.
>=20
> Yes, please make it a proper patch.
>=20
> Thanks a lot!

Attaching the patch.

Thierry

--SLDf9lqlvOQaIe6s
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: inline; filename="0001-ata-libahci-Fix-devres-cleanup-on-failure.patch"
Content-Transfer-Encoding: quoted-printable

=46rom a4f78e3ec05f1b2ad86aa44d6bd5394d75a23a06 Mon Sep 17 00:00:00 2001
=46rom: Thierry Reding <treding@nvidia.com>
Date: Wed, 21 Jan 2015 11:50:52 +0100
Subject: [PATCH] ata: libahci: Fix devres cleanup on failure

Commit c7d7ddee7e24 ("ata: libahci: Allow using multiple regulators")
releases regulators during ahci_platform_put_resources(). That doesn't
work because the function is run as part of the devres machinery. Such
resources are torn down in reverse order. Since the array that holds
pointers to the regulators is allocated using devres after the device
context to which ahci_platform_put_resources() is attached, the memory
will be freed before calling ahci_platform_put_resources() and thereby
causing a use-after-free error.

This commit fixes this by using regular allocations for the array. The
memory can then be freed after the regulators have been released. This
conserves the advantages of using the managed API.

Reported-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/ata/libahci_platform.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libahci_platform.c b/drivers/ata/libahci_platform.c
index 73a086664ee7..504d534ccbfe 100644
--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -276,6 +276,7 @@ static void ahci_platform_put_resources(struct device *=
dev, void *res)
 		if (hpriv->target_pwrs && hpriv->target_pwrs[c])
 			regulator_put(hpriv->target_pwrs[c]);
=20
+	kfree(hpriv->target_pwrs);
 }
=20
 static int ahci_platform_get_phy(struct ahci_host_priv *hpriv, u32 port,
@@ -412,7 +413,7 @@ struct ahci_host_priv *ahci_platform_get_resources(stru=
ct platform_device *pdev)
 		goto err_out;
 	}
 	sz =3D hpriv->nports * sizeof(*hpriv->target_pwrs);
-	hpriv->target_pwrs =3D devm_kzalloc(dev, sz, GFP_KERNEL);
+	hpriv->target_pwrs =3D kzalloc(sz, GFP_KERNEL);
 	if (!hpriv->target_pwrs) {
 		rc =3D -ENOMEM;
 		goto err_out;
--=20
2.1.3


--SLDf9lqlvOQaIe6s--

--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUv8vnAAoJEN0jrNd/PrOhEwIQAMLBYpKKV58MUIA2O91w3pdr
2jYzWy2Dl8iBQOeoYurUIU+MdVt1tqY6ISnaBiSlH+8w2AF7vEo/GbQXUaIiFroW
/9u/QQLQndO/a40/EdWB4lGs2a3vp8sk+pNDK8LpHbtxfNCdERKgHMyfDpbJWpjC
XEiGit0dktT7jrqg8JIaQ3veCvp/6iaByvU4pO+wH92krl2us7NXtweyaF5IKNmv
fliUxmEVXLpM2Jmhogr5UQqS16+nhT6heTK5L7NS69WZd2bOUhYZMPoW4TuwQG6l
SL7dmKaj5fjsmGufmGiccdcF0UN3s/O5ZIUVm3fCTrdjUEg3jleAK9JPdDRGJdqR
p8q4crc+4g3V0tWg5bR/PlLu/HY5U/GDvucMqgM/gXYvg5HFNkpIOzGFoD1rl/Is
VSe9l4uIIZm34kVO/jwaSDdAAMB7PKp7B5YWT7TB81G7H0WnoqwC+vtvj/0iIuJO
UT3jXArYHxf20snTP6Bvt9zCCk2XWS6qvc0F0he2vm3ICTnqs9U/Fu5bgaqe2GDQ
Hgx38ScAzp8614ouv0Jjn5vzrEzZVqKHIcH9eZSw8ssirX1QLodT+6DR3sXjxIwy
WqCLdVHaQlLuyEL4u5mZbhndMUCiPlBnMKk7MrvJeIXi8Z09QbdguR2FwiSlZvDX
tCmZUCv3I3/zgOR4erVW
=1neP
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
