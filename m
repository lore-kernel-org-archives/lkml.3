Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965499AbbA2CiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:38:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47026 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965460AbbA2CiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:38:12 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arik Nemtsov <arikx.nemtsov@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 116/139] cfg80211: avoid mem leak on driver hint set
Date: Wed, 28 Jan 2015 14:20:59 -0800
Message-Id: <1422483682-15393-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arik Nemtsov <arik@wizery.com>

commit 34f05f543f02350e920bddb7660ffdd4697aaf60 upstream.

In the already-set and intersect case of a driver-hint, the previous
wiphy regdomain was not freed before being reset with a copy of the
cfg80211 regdomain.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/wireless/reg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 7da67fd..e90e22f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1455,7 +1455,7 @@ static enum reg_request_treatment
 __regulatory_hint(struct wiphy *wiphy,
 		  struct regulatory_request *pending_request)
 {
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *regd, *tmp;
 	bool intersect = false;
 	enum reg_request_treatment treatment;
 	struct regulatory_request *lr;
@@ -1491,7 +1491,9 @@ __regulatory_hint(struct wiphy *wiphy,
 				return REG_REQ_IGNORE;
 			}
 			treatment = REG_REQ_ALREADY_SET;
+			tmp = get_wiphy_regdom(wiphy);
 			rcu_assign_pointer(wiphy->regd, regd);
+			rcu_free_regdom(tmp);
 			goto new_request;
 		}
 		kfree(pending_request);
-- 
1.9.1

