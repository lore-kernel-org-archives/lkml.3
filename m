Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967668Ab3HICNx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:13:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55747 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967611Ab3HIB7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 042/102] mac80211: fix monitor interface suspend crash regression
Date: Thu,  8 Aug 2013 18:57:18 -0700
Message-Id: <20130809015019.712274073@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit cd34f647a78e7f2296fcb72392b9e5c832793e65 upstream.

My commit:

commit 12e7f517029dad819c45eca9ca01fdb9ba57616b
Author: Stanislaw Gruszka <sgruszka@redhat.com>
Date:   Thu Feb 28 10:55:26 2013 +0100

    mac80211: cleanup generic suspend/resume procedures

removed check for deleting MONITOR and AP_VLAN when suspend. That can
cause a crash (i.e. in iwlagn_mac_remove_interface()) since we remove
interface in the driver that we did not add before.

Reference:
http://marc.info/?l=linux-kernel&m=137391815113860&w=2

Bisected-by: Ortwin Glück <odi@odi.ch>
Reported-and-tested-by: Ortwin Glück <odi@odi.ch>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/pm.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -99,10 +99,13 @@ int __ieee80211_suspend(struct ieee80211
 	}
 	mutex_unlock(&local->sta_mtx);
 
-	/* remove all interfaces */
+	/* remove all interfaces that were created in the driver */
 	list_for_each_entry(sdata, &local->interfaces, list) {
-		if (!ieee80211_sdata_running(sdata))
+		if (!ieee80211_sdata_running(sdata) ||
+		    sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
+		    sdata->vif.type == NL80211_IFTYPE_MONITOR)
 			continue;
+
 		drv_remove_interface(local, sdata);
 	}
 


