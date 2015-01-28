Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188AbbA2JFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:05:04 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44827 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759579AbbA2JEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:04:52 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
        Arik Nemtsov <arikx.nemtsov@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 080/176] cfg80211: avoid mem leak on driver hint set
Date: Wed, 28 Jan 2015 15:28:30 +0100
Message-Id: <dd16b23e0c1353078e7303c4f0ceaaa30079b6c0.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arik Nemtsov <arik@wizery.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 34f05f543f02350e920bddb7660ffdd4697aaf60 upstream.

In the already-set and intersect case of a driver-hint, the previous
wiphy regdomain was not freed before being reset with a copy of the
cfg80211 regdomain.

[js: backport to 3.12]

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/wireless/reg.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index de06d5d1287f..8eedb1507ccc 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1432,7 +1432,7 @@ static enum reg_request_treatment
 __regulatory_hint(struct wiphy *wiphy,
 		  struct regulatory_request *pending_request)
 {
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *regd, *tmp;
 	bool intersect = false;
 	enum reg_request_treatment treatment;
 	struct regulatory_request *lr;
@@ -1448,7 +1448,9 @@ __regulatory_hint(struct wiphy *wiphy,
 				kfree(pending_request);
 				return PTR_ERR(regd);
 			}
+			tmp = get_wiphy_regdom(wiphy);
 			rcu_assign_pointer(wiphy->regd, regd);
+			rcu_free_regdom(tmp);
 		}
 		intersect = true;
 		break;
@@ -1468,7 +1470,9 @@ __regulatory_hint(struct wiphy *wiphy,
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
2.2.2

