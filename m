Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab3AOSxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 13:53:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:34279 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756294Ab3AOSxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:53:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sean Patrick Santos <quantheory@gmail.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 025/221] carl9170: fix -EINVAL bailout during init with !CONFIG_MAC80211_MESH
Date: Tue, 15 Jan 2013 10:49:12 -0800
Message-Id: <20130115184959.860421713@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Lamparter <chunkeey@googlemail.com>

commit 6c653f66772c39c5e25db715bbd4730596fccd9e upstream.

Sean reported that as of 3.7, his AR9170 device no longer works
because the driver fails during initialization. He noted this
is due to:
"In carl9170/fw.c, ar->hw->wiphy is tagged with
NL80211_IFTYPE_MESH_POINT support if the firmware has Content
after Beacon Queuing. This is both in interface_modes and the
only iface_combinations entry.

If CONFIG_MAC80211_MESH is not set, ieee80211_register_hw
removes NL80211_IFTYPE_MESH_POINT from interface_modes, but
not iface_combinations.

wiphy_register then checks to see if every interface type in
every interface combination is in interface_modes.
NL80211_IFTYPE_MESH_POINT was removed, so you get a WARN_ON
warning and it returns -EINVAL, giving up."

Unfortunately, the iface_combination (types) feature bitmap
in ieee80211_iface_limit is part of a const member in the
ieee80211_iface_combination struct. Hence, the MESH_POINT
feature flag can't be masked by wiphy_register in the
same way as interface_modes in ieee80211_register_hw.

Reported-by: Sean Patrick Santos <quantheory@gmail.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Tested-by: Sean Patrick Santos <quantheory@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/carl9170/fw.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/carl9170/fw.c
+++ b/drivers/net/wireless/ath/carl9170/fw.c
@@ -341,8 +341,12 @@ static int carl9170_fw(struct ar9170 *ar
 		if (SUPP(CARL9170FW_WLANTX_CAB)) {
 			if_comb_types |=
 				BIT(NL80211_IFTYPE_AP) |
-				BIT(NL80211_IFTYPE_MESH_POINT) |
 				BIT(NL80211_IFTYPE_P2P_GO);
+
+#ifdef CONFIG_MAC80211_MESH
+			if_comb_types |=
+				BIT(NL80211_IFTYPE_MESH_POINT);
+#endif /* CONFIG_MAC80211_MESH */
 		}
 	}
 


