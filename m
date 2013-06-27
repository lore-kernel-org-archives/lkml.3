Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181Ab3F0EXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:23:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48037 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab3F0EX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:23:29 -0400
Date: Thu, 27 Jun 2013 14:23:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: linux-next: manual merge of the wireless-next tree with the
 net-next tree
Message-Id: <20130627142318.78f78fdbb49c927a7cb7bc50@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Jun_2013_14_23_18_+1000_=EhFNpj+hBjn1IEi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Jun_2013_14_23_18_+1000_=EhFNpj+hBjn1IEi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless-next tree got a conflict in
net/wireless/nl80211.c between merge commits from the net-next tree and
commit 86e8cf98de3e ("nl80211: use small state buffer for wiphy_dump")
from the wireless-next tree.

I think I fixed it up (see below, please check) and can carry the fix as
necessary (no action is required).  I think that my fix means that that
commit 86e8cf98de3e is missing the extra "rtnl_unlock();", right?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/wireless/nl80211.c
index e545023,7dc3343..0000000
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@@ -1520,47 -1562,23 +1562,25 @@@ static int nl80211_dump_wiphy_parse(str
  static int nl80211_dump_wiphy(struct sk_buff *skb, struct netlink_callbac=
k *cb)
  {
  	int idx =3D 0, ret;
- 	int start =3D cb->args[0];
+ 	struct nl80211_dump_wiphy_state *state =3D (void *)cb->args[0];
  	struct cfg80211_registered_device *dev;
- 	s64 filter_wiphy =3D -1;
- 	bool split =3D false;
- 	struct nlattr **tb;
- 	int res;
-=20
- 	/* will be zeroed in nlmsg_parse() */
- 	tb =3D kmalloc(sizeof(*tb) * (NL80211_ATTR_MAX + 1), GFP_KERNEL);
- 	if (!tb)
- 		return -ENOMEM;
 =20
  	rtnl_lock();
-=20
- 	res =3D nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
- 			  tb, NL80211_ATTR_MAX, nl80211_policy);
- 	if (res =3D=3D 0) {
- 		split =3D tb[NL80211_ATTR_SPLIT_WIPHY_DUMP];
- 		if (tb[NL80211_ATTR_WIPHY])
- 			filter_wiphy =3D nla_get_u32(tb[NL80211_ATTR_WIPHY]);
- 		if (tb[NL80211_ATTR_WDEV])
- 			filter_wiphy =3D nla_get_u64(tb[NL80211_ATTR_WDEV]) >> 32;
- 		if (tb[NL80211_ATTR_IFINDEX]) {
- 			struct net_device *netdev;
- 			int ifidx =3D nla_get_u32(tb[NL80211_ATTR_IFINDEX]);
-=20
- 			netdev =3D dev_get_by_index(sock_net(skb->sk), ifidx);
- 			if (!netdev) {
- 				rtnl_unlock();
- 				kfree(tb);
- 				return -ENODEV;
- 			}
- 			if (netdev->ieee80211_ptr) {
- 				dev =3D wiphy_to_dev(
- 					netdev->ieee80211_ptr->wiphy);
- 				filter_wiphy =3D dev->wiphy_idx;
- 			}
- 			dev_put(netdev);
+ 	if (!state) {
+ 		state =3D kzalloc(sizeof(*state), GFP_KERNEL);
 -		if (!state)
++		if (!state) {
++			rtnl_unlock();
+ 			return -ENOMEM;
 +		}
+ 		state->filter_wiphy =3D -1;
+ 		ret =3D nl80211_dump_wiphy_parse(skb, cb, state);
+ 		if (ret) {
+ 			kfree(state);
+ 			rtnl_unlock();
+ 			return ret;
+ 		}
+ 		cb->args[0] =3D (long)state;
  	}
- 	kfree(tb);
 =20
  	list_for_each_entry(dev, &cfg80211_rdev_list, list) {
  		if (!net_eq(wiphy_net(&dev->wiphy), sock_net(skb->sk)))

--Signature=_Thu__27_Jun_2013_14_23_18_+1000_=EhFNpj+hBjn1IEi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRy746AAoJEECxmPOUX5FEBcsP/i5W3WsuWTGCFZbLWbrIwfbW
GiUPzKTleWXMOLiOkNyRh/4YhSOrCuuOyeRdZe5c6VUSvpKDY78By7IpnVTX1U4y
/dZP2s+qTMnMa3DLMSpWBGQ2sojMKWUXpFdUmkp1ucxWc03edzn75yIEiZ0pM25G
bhNTlLWd/S9VAJUsh+daaMDXgoQMz0+8yIVT9iRhbu6thhWcKIenlgqQgi2X52qM
ox0AHciiaM6Mn6fcdn0oLlXbYWN4GiBxEenQv9Q0CQ769RwyGxLnbVsiRNnURbuL
XxcumrRNOYeQG9Ty/RjyD1OE+AzwK+WWkjlLE9emg1IzhjCuWSPmAmaAAAs/AIAe
4+Ks3AK9jvM8LU7HbF+ygIxzx+GCCFs9I4eKZ4trPZyiQScCCgg4HZBmDFT576YA
ZE/HRw5BbHzWv2EUYqG6nXp8VWSAzVqPSz107zpAwW96NvlBq/GS1mLzVFC1z2AJ
X6oSppbgXKWS0N4hqWDJKcB4+Quil5A3VxvOf2ATrN+YuD+CBepm+FwaBheFHEk8
6rmeHLF04wiacnJY5TqfPtcC3E+zh3YZ87gpvwHU6t49sWldz9uxlgd9qz0iyPTL
6oYODfItaxmukZNSoKGCkn3/9Yvidwc9Fn7O6TsrYLyIzzcSZzCtkIlCvahmKrlg
MQJEJHT0cZiHsBiH1xUp
=SamX
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Jun_2013_14_23_18_+1000_=EhFNpj+hBjn1IEi--
