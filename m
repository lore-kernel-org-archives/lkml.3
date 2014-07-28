Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaG1HXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 03:23:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:18833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaG1HXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 03:23:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,747,1400050800"; 
   d="asc'?scan'208";a="462165727"
Date: Mon, 28 Jul 2014 12:46:22 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: linux-next: build failure after merge of the slave-dma tree
Message-ID: <20140728071622.GY8181@intel.com>
References: <20140728121856.56d0162e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iVCmgExH7+hIHJ1A"
Content-Disposition: inline
In-Reply-To: <20140728121856.56d0162e@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iVCmgExH7+hIHJ1A
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 12:18:56PM +1000, Stephen Rothwell wrote:
> Hi Vinod,
>=20
> After merging the slave-dma tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/dma/sun6i-dma.c: In function 'sun6i_dma_dump_chan_regs':
> drivers/dma/sun6i-dma.c:203:2: error: implicit declaration of function '_=
_virt_to_phys' [-Werror=3Dimplicit-function-declaration]
>   phys_addr_t reg =3D __virt_to_phys((unsigned long)pchan->base);
>   ^
>=20
> Caused by commit 555859308723 ("dmaengine: sun6i: Add driver for the
> Allwinner A31 DMA controller").  Presumably missing an include file.
>=20
> I have used the slave-dma tree from next-20140725 for today.

Thanks, Feng's robot also gave such warning. SInce maxime didnt send any
fixes it, I am applying below to fix this.
We shouldnt have used __virt_to_phys here

--x8---
=46rom: Vinod Koul <vinod.koul@intel.com>
Date: Mon, 28 Jul 2014 11:57:25 +0530
Subject: [PATCH 1/2] dmaengine: sun6i: fix build failure on x86, xilinx tar=
gets
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

Since the driver defined COMPILE_TEST, it gets compiled for different arch'=
s.
The driver uses __virt_to_phys() insteadof virt_to_phys, so replace it

drivers/dma/sun6i-dma.c: In function =E2=80=98sun6i_dma_dump_chan_regs=E2=
=80=99:
drivers/dma/sun6i-dma.c:203: error: implicit declaration of function '__vir=
t_to_phys'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
---
 drivers/dma/sun6i-dma.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index ce8d5d1..e9f99bb 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -200,7 +200,7 @@ static inline void sun6i_dma_dump_com_regs(struct sun6i=
_dma_dev *sdev)
 static inline void sun6i_dma_dump_chan_regs(struct sun6i_dma_dev *sdev,
 					    struct sun6i_pchan *pchan)
 {
-	phys_addr_t reg =3D __virt_to_phys((unsigned long)pchan->base);
+	phys_addr_t reg =3D virt_to_phys(pchan->base);
=20
 	dev_dbg(sdev->slave.dev, "Chan %d reg: %pa\n"
 		"\t___en(%04x): \t0x%08x\n"
@@ -330,7 +330,7 @@ static inline int sun6i_dma_cfg_lli(struct sun6i_dma_ll=
i *lli,
 static inline void sun6i_dma_dump_lli(struct sun6i_vchan *vchan,
 				      struct sun6i_dma_lli *lli)
 {
-	phys_addr_t p_lli =3D __virt_to_phys((unsigned long)lli);
+	phys_addr_t p_lli =3D virt_to_phys(lli);
=20
 	dev_dbg(chan2dev(&vchan->vc.chan),
 		"\n\tdesc:   p - %pa v - 0x%p\n"
--=20
1.7.0.4


--iVCmgExH7+hIHJ1A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT1fjGAAoJEHwUBw8lI4NHuGkP+wZvizLhvuTMD+AFfEBTNlES
mGh5t3tVmYotWmKuagpHc4oJCzC3Zeg1OiPoX2lIVXrrtcuZreKzZOshOgflDGZl
YW/MkSWCxNuEkQiPX3o8GAE/1NTSxxtc4yZLvfXOlWX+Ly2izxif1abeMgomvzuQ
yN1Gmssrj/AzSi1Y0aTPAmyR1KBaR/r1l2DEHsZ2JvFTQ2bMh08sPCxKU/YoF6Bm
aTgOPvWcuS8LJtv+OoAygIV8YC6WIyJwcYouIJ9AfB5qhxmjKVfUMQIrO866JLBc
Cy8GVBl0xiWc8E36iZWMWH3sbhUJ/GxIaNl32yeIBm9T84gugcMqXN6IAA6zHSZv
0kfJuNfgD3UZjDGOU5+t2R65zu+i+PBIQmgXFpqoTcM66rAdkyNOKxB1Xoi70SN4
SGDH8BpWZEBnSd5Puzgh1tyRvAtsrpdG/AgNxe+kmVLLmvLS2xEeeBVypnv97Rzw
7xJxwOsORKs5NxoiL/+rH6G1rs12SeUZDrwJ6Kj1jArWduUWxybbgmbtBjxQH1x6
3ZbKG63SUTWnrkEqw7Me8QThcWkQBIXWArMF/s6NsVt2NMp/gos3spB1bJy/UKkD
dzj2jo24GwLB3sXCi8/Wi18l2raQTfwI5zFPxaLsuNOGpqNqUWjKBn9L5m/N20nd
aw0WwnaNH4IDUd3vd+wX
=EnG0
-----END PGP SIGNATURE-----

--iVCmgExH7+hIHJ1A--
