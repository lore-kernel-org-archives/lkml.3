Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaDAMXE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:23:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42112 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544AbaDALQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:11 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 013/144] mac80211: don't validate unchanged AP bandwidth while tracking
Date: Tue,  1 Apr 2014 12:13:37 +0100
Message-Id: <1396350948-29910-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 963a1852fbac4f75a2d938fa2e734ef1e6d4c044 upstream.

The MLME code in mac80211 must track whether or not the AP changed
bandwidth, but if there's no change while tracking it shouldn't do
anything, otherwise regulatory updates can make it impossible to
connect to certain APs if the regulatory database doesn't match the
information from the AP. See the precise scenario described in the
code.

This still leaves some possible problems with CSA or if the AP
actually changed bandwidth, but those cases are less common and
won't completely prevent using it.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=70881

Reported-and-tested-by: Nate Carlson <kernel@natecarlson.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/mlme.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7a98d52..59f69fd 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -331,6 +331,28 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	ret = 0;
 
 out:
+	/*
+	 * When tracking the current AP, don't do any further checks if the
+	 * new chandef is identical to the one we're currently using for the
+	 * connection. This keeps us from playing ping-pong with regulatory,
+	 * without it the following can happen (for example):
+	 *  - connect to an AP with 80 MHz, world regdom allows 80 MHz
+	 *  - AP advertises regdom US
+	 *  - CRDA loads regdom US with 80 MHz prohibited (old database)
+	 *  - the code below detects an unsupported channel, downgrades, and
+	 *    we disconnect from the AP in the caller
+	 *  - disconnect causes CRDA to reload world regdomain and the game
+	 *    starts anew.
+	 * (see https://bugzilla.kernel.org/show_bug.cgi?id=70881)
+	 *
+	 * It seems possible that there are still scenarios with CSA or real
+	 * bandwidth changes where a this could happen, but those cases are
+	 * less common and wouldn't completely prevent using the AP.
+	 */
+	if (tracking &&
+	    cfg80211_chandef_identical(chandef, &sdata->vif.bss_conf.chandef))
+		return ret;
+
 	/* don't print the message below for VHT mismatch if VHT is disabled */
 	if (ret & IEEE80211_STA_DISABLE_VHT)
 		vht_chandef = *chandef;
-- 
1.9.1

