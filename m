Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759816Ab3BLVLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:11:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53400 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab3BLUfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:37 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Nathaniel Doherty <ntdoherty@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 02/61] rtlwifi: Fix scheduling while atomic bug
Date: Tue, 12 Feb 2013 12:34:22 -0800
Message-Id: <20130212203418.315530789@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit a5ffbe0a1993a27072742ef7db6cf9839956fce9 upstream.

Kernel commits 41affd5 and 6539306 changed the locking in rtl_lps_leave()
from a spinlock to a mutex by doing the calls indirectly from a work queue
to reduce the time that interrupts were disabled. This change was fine for
most systems; however a scheduling while atomic bug was reported in
https://bugzilla.redhat.com/show_bug.cgi?id=903881. The backtrace indicates
that routine rtl_is_special(), which calls rtl_lps_leave() in three places
was entered in atomic context. These direct calls are replaced by putting a
request on the appropriate work queue.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-tested-by: Nathaniel Doherty <ntdoherty@gmail.com>
Cc: Nathaniel Doherty <ntdoherty@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/base.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -980,7 +980,8 @@ u8 rtl_is_special_data(struct ieee80211_
 					 is_tx ? "Tx" : "Rx");
 
 				if (is_tx) {
-					rtl_lps_leave(hw);
+					schedule_work(&rtlpriv->
+						      works.lps_leave_work);
 					ppsc->last_delaylps_stamp_jiffies =
 					    jiffies;
 				}
@@ -990,7 +991,7 @@ u8 rtl_is_special_data(struct ieee80211_
 		}
 	} else if (ETH_P_ARP == ether_type) {
 		if (is_tx) {
-			rtl_lps_leave(hw);
+			schedule_work(&rtlpriv->works.lps_leave_work);
 			ppsc->last_delaylps_stamp_jiffies = jiffies;
 		}
 
@@ -1000,7 +1001,7 @@ u8 rtl_is_special_data(struct ieee80211_
 			 "802.1X %s EAPOL pkt!!\n", is_tx ? "Tx" : "Rx");
 
 		if (is_tx) {
-			rtl_lps_leave(hw);
+			schedule_work(&rtlpriv->works.lps_leave_work);
 			ppsc->last_delaylps_stamp_jiffies = jiffies;
 		}
 


