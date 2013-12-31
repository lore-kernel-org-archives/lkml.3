Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3LaJoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 04:44:17 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:56880 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3LaJoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 04:44:14 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
Date: Tue, 31 Dec 2013 10:44:01 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-15-generic; KDE/4.12.0; x86_64; ; )
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, sre@ring0.de, joni.lapilainen@gmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com> <1386494714-21070-2-git-send-email-pali.rohar@gmail.com> <20131210092114.GB22756@amd.pavel.ucw.cz>
In-Reply-To: <20131210092114.GB22756@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1426400.629Fmge7eP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312311044.09284@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1426400.629Fmge7eP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 10 December 2013 10:21:14 Pavel Machek wrote:
> Hi!
>=20
> > diff --git a/drivers/net/wireless/ti/wl1251/cmd.c
> > b/drivers/net/wireless/ti/wl1251/cmd.c index
> > 6822b84..16b6479 100644
> > --- a/drivers/net/wireless/ti/wl1251/cmd.c
> > +++ b/drivers/net/wireless/ti/wl1251/cmd.c
> > @@ -410,7 +411,10 @@ int wl1251_cmd_scan(struct wl1251 *wl,
> > u8 *ssid, size_t ssid_len,
> >=20
> >  	struct wl1251_cmd_scan *cmd;
> >  	int i, ret =3D 0;
> >=20
> > -	wl1251_debug(DEBUG_CMD, "cmd scan");
> > +	wl1251_debug(DEBUG_CMD, "cmd scan channels %d ssid(%d)
> > '%s'", +		     n_channels, (int)ssid_len, ssid);
> > +
> > +	WARN_ON(n_channels > SCAN_MAX_NUM_OF_CHANNELS);
>=20
> ssids can have \0s in them... and what is worse, they may not
> be 0 terminated AFAICT.
>=20
> Potential solution is at
> http://www.spinics.net/lists/linux-wireless/msg98640.html .
>=20
> Thanks,
> 									Pavel

Ok. To prevent other problems in future, I removed printing ssid
and len params from debug output. I think it is not needed...

Here is updated patch:

=46rom: =3D?UTF-8?q?Pali=3D20Roh=3DC3=3DA1r?=3D <pali.rohar@gmail.com>
Subject: [PATCH v2 01/16] wl1251: fix scan behaviour while not associated
Date: Sun,  8 Dec 2013 10:24:59 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset=3DUTF-8
Content-Transfer-Encoding: 8bit

=46rom: David Gnedt <david.gnedt@davizone.at>

With a dissacociated card I often encoutered very long scan delays.

My guess is that it has something to do with the cards DTIM handling and
another firmware bug mentioned in the TI WLAN driver, which is described as
the card may never end scanning if the channel is overloaded because it
can't send probe requests. I think the firmware somehow also tries to
receive DTIM messages when the BSSID is not set. Therefore most of the time
it waits for DTIM messages and can't do scanning work.

Anyway we can workaround this misbehaviour by setting the HIGH_PRIORITY
bit for scans in disassociated state.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
=2D--
 drivers/net/wireless/ti/wl1251/cmd.c  |   13 ++++++++++++-
 drivers/net/wireless/ti/wl1251/cmd.h  |    5 +++++
 drivers/net/wireless/ti/wl1251/main.c |    1 +
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/cmd.c b/drivers/net/wireless/ti=
/wl1251/cmd.c
index 6822b84..16b6479 100644
=2D-- a/drivers/net/wireless/ti/wl1251/cmd.c
+++ b/drivers/net/wireless/ti/wl1251/cmd.c
@@ -3,6 +3,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/crc7.h>
+#include <linux/etherdevice.h>
=20
 #include "wl1251.h"
 #include "reg.h"
@@ -410,7 +411,9 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_t=
 ssid_len,
 	struct wl1251_cmd_scan *cmd;
 	int i, ret =3D 0;
=20
=2D	wl1251_debug(DEBUG_CMD, "cmd scan");
+	wl1251_debug(DEBUG_CMD, "cmd scan channels %d", n_channels);
+
+	WARN_ON(n_channels > SCAN_MAX_NUM_OF_CHANNELS);
=20
 	cmd =3D kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd)
@@ -421,6 +425,13 @@ int wl1251_cmd_scan(struct wl1251 *wl, u8 *ssid, size_=
t ssid_len,
 						    CFG_RX_MGMT_EN |
 						    CFG_RX_BCN_EN);
 	cmd->params.scan_options =3D 0;
+	/*
+	 * Use high priority scan when not associated to prevent fw issue
+	 * causing never-ending scans (sometimes 20+ minutes).
+	 * Note: This bug may be caused by the fw's DTIM handling.
+	 */
+	if (is_zero_ether_addr(wl->bssid))
+		cmd->params.scan_options |=3D WL1251_SCAN_OPT_PRIORITY_HIGH;
 	cmd->params.num_channels =3D n_channels;
 	cmd->params.num_probe_requests =3D n_probes;
 	cmd->params.tx_rate =3D cpu_to_le16(1 << 1); /* 2 Mbps */
diff --git a/drivers/net/wireless/ti/wl1251/cmd.h b/drivers/net/wireless/ti=
/wl1251/cmd.h
index ee4f2b3..126f273 100644
=2D-- a/drivers/net/wireless/ti/wl1251/cmd.h
+++ b/drivers/net/wireless/ti/wl1251/cmd.h
@@ -167,6 +167,11 @@ struct cmd_read_write_memory {
 #define CMDMBOX_HEADER_LEN 4
 #define CMDMBOX_INFO_ELEM_HEADER_LEN 4
=20
+#define WL1251_SCAN_OPT_PASSIVE		1
+#define WL1251_SCAN_OPT_5GHZ_BAND	2
+#define WL1251_SCAN_OPT_TRIGGERD_SCAN	4
+#define WL1251_SCAN_OPT_PRIORITY_HIGH	8
+
 #define WL1251_SCAN_MIN_DURATION 30000
 #define WL1251_SCAN_MAX_DURATION 60000
=20
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/t=
i/wl1251/main.c
index 3291ffa..4d89ac8 100644
=2D-- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -930,6 +930,7 @@ static int wl1251_op_hw_scan(struct ieee80211_hw *hw,
 	ret =3D wl1251_cmd_scan(wl, ssid, ssid_len, req->channels,
 			      req->n_channels, WL1251_SCAN_NUM_PROBES);
 	if (ret < 0) {
+		wl1251_debug(DEBUG_SCAN, "scan failed %d", ret);
 		wl->scanning =3D false;
 		goto out_idle;
 	}
=2D-=20
1.7.9.5

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com


--nextPart1426400.629Fmge7eP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlLCkeEACgkQi/DJPQPkQ1IdNACgpEL9XuHE+5aOkEeNNPR2gs6Y
mSkAoLd4/X80A28E/ZEZnqdeu8e3EDl9
=U7dr
-----END PGP SIGNATURE-----

--nextPart1426400.629Fmge7eP--
