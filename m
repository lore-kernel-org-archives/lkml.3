Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab3BANKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 08:10:17 -0500
Received: from mail.kernel.org ([198.145.19.201]:44760 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757293Ab3BANKN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 08:10:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?ISO-8859-15?q?C=C3=A9dric=20Debarge?= <cedric.debarge@acksys.fr>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 33/89] mac80211: fix FT roaming
Date: Fri,  1 Feb 2013 14:07:48 +0100
Message-Id: <20130201130209.891025375@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130201130207.444989281@linuxfoundation.org>
References: <20130201130207.444989281@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -164,7 +164,17 @@ static int ieee80211_add_key(struct wiph
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


