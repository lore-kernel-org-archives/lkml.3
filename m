Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbbALTAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:00:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58051 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913AbbALS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:56 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arik Nemtsov <arikx.nemtsov@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 133/216] cfg80211: avoid mem leak on driver hint set
Date: Mon, 12 Jan 2015 18:28:31 +0000
Message-Id: <1421087394-2712-21-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arik Nemtsov <arik@wizery.com>

commit 34f05f543f02350e920bddb7660ffdd4697aaf60 upstream.

In the already-set and intersect case of a driver-hint, the previous
wiphy regdomain was not freed before being reset with a copy of the
cfg80211 regdomain.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/wireless/reg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 1afdf45db38f..ff7ffeb7947a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1720,7 +1720,7 @@ static enum reg_request_treatment
 reg_process_hint_driver(struct wiphy *wiphy,
 			struct regulatory_request *driver_request)
 {
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *regd, *tmp;
 	enum reg_request_treatment treatment;
 
 	treatment = __reg_process_hint_driver(driver_request);
@@ -1740,7 +1740,10 @@ reg_process_hint_driver(struct wiphy *wiphy,
 			reg_free_request(driver_request);
 			return REG_REQ_IGNORE;
 		}
+
+		tmp = get_wiphy_regdom(wiphy);
 		rcu_assign_pointer(wiphy->regd, regd);
+		rcu_free_regdom(tmp);
 	}
 
 
-- 
2.1.4

