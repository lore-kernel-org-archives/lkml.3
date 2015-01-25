Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbbAYTYv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 14:24:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57232 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815AbbAYSJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:09:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Arik Nemtsov <arikx.nemtsov@intel.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.14 30/98] cfg80211: avoid mem leak on driver hint set
Date: Sun, 25 Jan 2015 10:06:48 -0800
Message-Id: <20150125180714.177278756@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180712.859646324@linuxfoundation.org>
References: <20150125180712.859646324@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arik Nemtsov <arik@wizery.com>

commit 34f05f543f02350e920bddb7660ffdd4697aaf60 upstream.

In the already-set and intersect case of a driver-hint, the previous
wiphy regdomain was not freed before being reset with a copy of the
cfg80211 regdomain.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Acked-by: Luis R. Rodriguez <mcgrof@suse.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1547,7 +1547,7 @@ static enum reg_request_treatment
 reg_process_hint_driver(struct wiphy *wiphy,
 			struct regulatory_request *driver_request)
 {
-	const struct ieee80211_regdomain *regd;
+	const struct ieee80211_regdomain *regd, *tmp;
 	enum reg_request_treatment treatment;
 
 	treatment = __reg_process_hint_driver(driver_request);
@@ -1566,7 +1566,10 @@ reg_process_hint_driver(struct wiphy *wi
 			kfree(driver_request);
 			return REG_REQ_IGNORE;
 		}
+
+		tmp = get_wiphy_regdom(wiphy);
 		rcu_assign_pointer(wiphy->regd, regd);
+		rcu_free_regdom(tmp);
 	}
 
 


