Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541Ab3BEWKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:10:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48019 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516Ab3BEWKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:10:12 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 41/93] mac80211: fix FT roaming
Date: Tue,  5 Feb 2013 20:06:30 -0200
Message-Id: <1360102042-10732-42-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 1626e0fa740dec8665a973cf2349405cdfeb46dc upstream.

During FT roaming, wpa_supplicant attempts to set the
key before association. This used to be rejected, but
as a side effect of my commit 66e67e418908442389d3a9e
("mac80211: redesign auth/assoc") the key was accepted
causing hardware crypto to not be used for it as the
station isn't added to the driver yet.

It would be possible to accept the key and then add it
to the driver when the station has been added. However,
this may run into issues with drivers using the state-
based station adding if they accept the key only after
association like it used to be.

For now, revert to the behaviour from before the auth
and assoc change.

Reported-by: Cédric Debarge <cedric.debarge@acksys.fr>
Tested-by: Cédric Debarge <cedric.debarge@acksys.fr>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/mac80211/cfg.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7d5108a..56386f1 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -151,7 +151,17 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 			sta = sta_info_get(sdata, mac_addr);
 		else
 			sta = sta_info_get_bss(sdata, mac_addr);
-		if (!sta) {
+		/*
+		 * The ASSOC test makes sure the driver is ready to
+		 * receive the key. When wpa_supplicant has roamed
+		 * using FT, it attempts to set the key before
+		 * association has completed, this rejects that attempt
+		 * so it will set the key again after assocation.
+		 *
+		 * TODO: accept the key if we have a station entry and
+		 *       add it to the device after the station.
+		 */
+		if (!sta || !test_sta_flag(sta, WLAN_STA_ASSOC)) {
 			ieee80211_key_free(sdata->local, key);
 			err = -ENOENT;
 			goto out_unlock;
-- 
1.7.9.5

