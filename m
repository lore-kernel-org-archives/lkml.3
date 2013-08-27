Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3H0EgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 00:36:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37909 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213Ab3H0EgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 00:36:20 -0400
Date: Tue, 27 Aug 2013 14:36:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless-next tree with the  tree
Message-Id: <20130827143611.73ee131ad3889564ecb20a4e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Aug_2013_14_36_11_+1000_HVJm/qg52pZ5_bkS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Aug_2013_14_36_11_+1000_HVJm/qg52pZ5_bkS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/mac80211/ibss.c between commit 75a423f493ff ("mac80211: ibss: fix
ignored channel parameter") from the wireless tree and commit
d51b70ff5122 ("mac80211: move ibss presp generation in own function")
from the wireless-next tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/mac80211/ibss.c
index cb73baf,74de0f1..0000000
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@@ -246,6 -191,90 +191,93 @@@ ieee80211_ibss_build_presp(struct ieee8
 =20
  	presp->head_len =3D pos - presp->head;
  	if (WARN_ON(presp->head_len > frame_len))
+ 		goto error;
+=20
+ 	return presp;
+ error:
+ 	kfree(presp);
+ 	return NULL;
+ }
+=20
+ static void __ieee80211_sta_join_ibss(struct ieee80211_sub_if_data *sdata,
+ 				      const u8 *bssid, const int beacon_int,
 -				      struct ieee80211_channel *chan,
++				      struct cfg80211_chan_def *req_chandef,
+ 				      const u32 basic_rates,
+ 				      const u16 capability, u64 tsf,
+ 				      bool creator)
+ {
+ 	struct ieee80211_if_ibss *ifibss =3D &sdata->u.ibss;
+ 	struct ieee80211_local *local =3D sdata->local;
+ 	struct ieee80211_supported_band *sband;
+ 	struct ieee80211_mgmt *mgmt;
+ 	struct cfg80211_bss *bss;
+ 	u32 bss_change;
+ 	struct cfg80211_chan_def chandef;
++	struct ieee80211_channel *chan;
+ 	struct beacon_data *presp;
+ 	enum nl80211_bss_scan_width scan_width;
+ 	bool have_higher_than_11mbit;
+=20
+ 	sdata_assert_lock(sdata);
+=20
+ 	/* Reset own TSF to allow time synchronization work. */
+ 	drv_reset_tsf(local, sdata);
+=20
+ 	if (!ether_addr_equal(ifibss->bssid, bssid))
+ 		sta_info_flush(sdata);
+=20
+ 	/* if merging, indicate to driver that we leave the old IBSS */
+ 	if (sdata->vif.bss_conf.ibss_joined) {
+ 		sdata->vif.bss_conf.ibss_joined =3D false;
+ 		sdata->vif.bss_conf.ibss_creator =3D false;
+ 		sdata->vif.bss_conf.enable_beacon =3D false;
+ 		netif_carrier_off(sdata->dev);
+ 		ieee80211_bss_info_change_notify(sdata,
+ 						 BSS_CHANGED_IBSS |
+ 						 BSS_CHANGED_BEACON_ENABLED);
+ 	}
+=20
+ 	presp =3D rcu_dereference_protected(ifibss->presp,
+ 					  lockdep_is_held(&sdata->wdev.mtx));
+ 	rcu_assign_pointer(ifibss->presp, NULL);
+ 	if (presp)
+ 		kfree_rcu(presp, rcu_head);
+=20
+ 	sdata->drop_unencrypted =3D capability & WLAN_CAPABILITY_PRIVACY ? 1 : 0;
+=20
 -	chandef =3D ifibss->chandef;
++	/* make a copy of the chandef, it could be modified below. */
++	chandef =3D *req_chandef;
++	chan =3D chandef.chan;
+ 	if (!cfg80211_reg_can_beacon(local->hw.wiphy, &chandef)) {
+ 		if (chandef.width =3D=3D NL80211_CHAN_WIDTH_5 ||
+ 		    chandef.width =3D=3D NL80211_CHAN_WIDTH_10 ||
+ 		    chandef.width =3D=3D NL80211_CHAN_WIDTH_20_NOHT ||
+ 		    chandef.width =3D=3D NL80211_CHAN_WIDTH_20) {
+ 			sdata_info(sdata,
+ 				   "Failed to join IBSS, beacons forbidden\n");
+ 			return;
+ 		}
+ 		chandef.width =3D NL80211_CHAN_WIDTH_20;
+ 		chandef.center_freq1 =3D chan->center_freq;
+ 	}
+=20
+ 	ieee80211_vif_release_channel(sdata);
+ 	if (ieee80211_vif_use_channel(sdata, &chandef,
+ 				      ifibss->fixed_channel ?
+ 					IEEE80211_CHANCTX_SHARED :
+ 					IEEE80211_CHANCTX_EXCLUSIVE)) {
+ 		sdata_info(sdata, "Failed to join IBSS, no channel context\n");
+ 		return;
+ 	}
+=20
+ 	memcpy(ifibss->bssid, bssid, ETH_ALEN);
+=20
+ 	sband =3D local->hw.wiphy->bands[chan->band];
+=20
+ 	presp =3D ieee80211_ibss_build_presp(sdata, beacon_int, basic_rates,
+ 					   capability, tsf, &chandef,
+ 					   &have_higher_than_11mbit);
+ 	if (!presp)
  		return;
 =20
  	rcu_assign_pointer(ifibss->presp, presp);

--Signature=_Tue__27_Aug_2013_14_36_11_+1000_HVJm/qg52pZ5_bkS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHCzAAAoJEECxmPOUX5FENJsP/2XAJcSF2ts42SBxMyc+QQoi
5EYNmZBw+ZiRTrQbb1xzc61PkApH9iag9ciOzC3Yvd5ht4qSJOSVhOAochnNga2Q
Fk0c35lZik3yuiOXNhSXdTwCuccgHrYzCXZBfX12MHHQQKfEyK7HP4EEu7pUYge4
aMKg+bweAoWEU2syZGtZJDn4mTHT6yJB9gQwa/iWNM+q+WlAb6iCONwyX1N4I/AC
0WBRhMxhDzkj+EZbmqldjizSP2lKnFLBJjZ/1dclOjHVLlrL/7/qjiz/l+DYxaGD
mJR1fxxoNcSkF0MjKUdLbZDcAFGA3wVUCVbPsb2W7wAbiBe9yh2SCJZSxdO3gmdn
eJTyaMVnUqZUllWdPNLeWgkWTvEPPIMoGD1bPIXhqcn88XRmesn/doqAHA4zjmZH
lmyprYhPLoIjo9DmCW+UMaEUeNbGSvpb29rs3CNnCA5QuxXECy5R3ot5liNhzCEH
yG+cCMDp1gY9q096eXBR5i+fdcucfMJzbIL1FttwqjCa6f/52tTPRK03/YJbNDnS
LMSuo7/t+73SM3mLT1DxVGp61aP+uB3wRBgNWjVS6LpNs9IwVAVRfsQIAPE7fiRb
5wtWVCKCgg3Y5hxM1f/A+Zk9KFYIdnALhTjwKJLcICX2v5LcRKyFpz4yR/W627GW
IdaBR6oyatd2MhkmoqlP
=hJIh
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Aug_2013_14_36_11_+1000_HVJm/qg52pZ5_bkS--
