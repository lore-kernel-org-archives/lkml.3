Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3H3DEO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 23:04:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44635 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3H3DEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 23:04:13 -0400
Date: Fri, 30 Aug 2013 13:03:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@linux.ie>,
        Wang Xingchao <xingchao.wang@linux.intel.com>
Subject: linux-next: manual merge of the sound tree with the drm tree
Message-Id: <20130830130355.02cefec7e2308390a506fd1d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Aug_2013_13_03_55_+1000_HiLpskYynwPmCto6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Aug_2013_13_03_55_+1000_HiLpskYynwPmCto6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next merge of the sound tree got a conflict in
sound/pci/hda/hda_intel.c between commit 246efa4a072f ("snd/hda: add
runtime suspend/resume on optimus support (v4)") from the drm tree and
commit 7d4f606c50ff ("ALSA: hda - WAKEEN feature enabling for runtime
pm") from the sound tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc sound/pci/hda/hda_intel.c
index bf5e58e,c6c9829..0000000
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@@ -2975,12 -2971,10 +2975,16 @@@ static int azx_runtime_suspend(struct d
  	struct snd_card *card =3D dev_get_drvdata(dev);
  	struct azx *chip =3D card->private_data;
 =20
 +	if (chip->disabled)
 +		return 0;
 +
 +	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
 +		return 0;
 +
+ 	/* enable controller wake up event */
+ 	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) |
+ 		  STATESTS_INT_MASK);
+=20
  	azx_stop_chip(chip);
  	azx_enter_link_reset(chip);
  	azx_clear_irq_pending(chip);
@@@ -2993,17 -2987,31 +2997,37 @@@ static int azx_runtime_resume(struct de
  {
  	struct snd_card *card =3D dev_get_drvdata(dev);
  	struct azx *chip =3D card->private_data;
+ 	struct hda_bus *bus;
+ 	struct hda_codec *codec;
+ 	int status;
 =20
 +	if (chip->disabled)
 +		return 0;
 +
 +	if (!(chip->driver_caps & AZX_DCAPS_PM_RUNTIME))
 +		return 0;
 +
  	if (chip->driver_caps & AZX_DCAPS_I915_POWERWELL)
  		hda_display_power(true);
+=20
+ 	/* Read STATESTS before controller reset */
+ 	status =3D azx_readw(chip, STATESTS);
+=20
  	azx_init_pci(chip);
  	azx_init_chip(chip, 1);
+=20
+ 	bus =3D chip->bus;
+ 	if (status && bus) {
+ 		list_for_each_entry(codec, &bus->codec_list, list)
+ 			if (status & (1 << codec->addr))
+ 				queue_delayed_work(codec->bus->workq,
+ 						   &codec->jackpoll_work, codec->jackpoll_interval);
+ 	}
+=20
+ 	/* disable controller Wake Up event*/
+ 	azx_writew(chip, WAKEEN, azx_readw(chip, WAKEEN) &
+ 			~STATESTS_INT_MASK);
+=20
  	return 0;
  }
 =20

--Signature=_Fri__30_Aug_2013_13_03_55_+1000_HiLpskYynwPmCto6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSIAugAAoJEECxmPOUX5FE/K0P/j/E3WLwZxyh7iLhX5KjdItV
6Ls9L5fRrqfM2Nc7P+/J9avcevlDCrinLoVVt2fgrSqMUOUx24iQuFaqoNaa1k9k
6Mg4DyaQ8ZfcE3CuWecK4+ZrDpRq9hSd1yF0kKi2dAbk//Z7hiIRfkPitK25T5+s
VfzP+kv+g1S2xO/HtHD1T9cs6azhkyIp8cDNe53s1zXklu+nmXkaqi9G3vxttCHW
59JnD+gMu9Ngad/9xMFGhxQXHvn5e1c2/fvR6HY2QgNURUFLgNq3sVhVysJR4oCe
+6bupJckf7eWJ/h2YysQG75vGPOjEZb39MAN1SEAObXrMbyGsb65dWxgSO7XaPvr
QrSwRlVT926Zs5A4pw45G0Te+OsbzkpIMWtf4+v8KlWj0UyHlqk5/CCUizlQW0mG
yHs4Elb6xN4EFm3nY30DwZwAezf4t4mhEKxZk7rHqwLBkFSHxWMOlh8zNJgF3RqJ
nOvPoX33F02Jo18MftdSYgyIxGNFQ8OQaeaw283K2nT2AkcO9a81z2XhNAnZwWKV
xzH73Ssg4qcyBqxeynXaTCTq0jvRgXE+RfdMOiFeAfFBH9z8j7t4ziuQ3mSS3apg
mcBsXItMU/ZlFt5Fbq0G6xJMrWzmYb/OgmnsD02A8uAnqadAFjx4EbG7OGI+iP/L
7P5A/Iy1K1iBAhlKmCHu
=U0Re
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Aug_2013_13_03_55_+1000_HiLpskYynwPmCto6--
