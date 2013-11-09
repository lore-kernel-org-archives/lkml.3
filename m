Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab3KIHRm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:17:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33261 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932663Ab3KIGvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.11 25/94] iwlwifi: mvm: call ieee80211_scan_completed when needed
Date: Fri,  8 Nov 2013 22:51:31 -0800
Message-Id: <20131109065206.004811443@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 5a3e9f7f8c8768b5f7df81100c684e4cd00a6eb5 upstream.

When RFKill cuts short a scan, mac80211 cancels the scan.
This is done by sending a host command to the firmware, but
this command was dropped because of RFKill. Flag this
command as "SEND_IN_RFKILL" to make sure it is sent to the
firmware. The firmware will send SCAN_COMPLETE_NOTIFICATION
which will trigger a call to ieee80211_scan_completed.

If the scan cannot be aborted, it is because the firmware
already finished the scan but we hadn't notified mac80211
at the time mac80211 decided to cancel the scan. By the time
we see the scan could not be aborted, mac80211 has been
notified already.

This patch fixes situations in which we didn't notify
mac80211 upon completion of the scan that was cut short
by RFkill.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/scan.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/iwlwifi/mvm/scan.c
@@ -392,6 +392,11 @@ static bool iwl_mvm_scan_abort_notif(str
 			return false;
 		}
 
+		/*
+		 * If scan cannot be aborted, it means that we had a
+		 * SCAN_COMPLETE_NOTIFICATION in the pipe and it called
+		 * ieee80211_scan_completed already.
+		 */
 		IWL_DEBUG_SCAN(mvm, "Scan cannot be aborted, exit now: %d\n",
 			       *resp);
 		return true;
@@ -415,14 +420,19 @@ void iwl_mvm_cancel_scan(struct iwl_mvm
 					       SCAN_COMPLETE_NOTIFICATION };
 	int ret;
 
+	if (mvm->scan_status == IWL_MVM_SCAN_NONE)
+		return;
+
 	iwl_init_notification_wait(&mvm->notif_wait, &wait_scan_abort,
 				   scan_abort_notif,
 				   ARRAY_SIZE(scan_abort_notif),
 				   iwl_mvm_scan_abort_notif, NULL);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD, CMD_SYNC, 0, NULL);
+	ret = iwl_mvm_send_cmd_pdu(mvm, SCAN_ABORT_CMD,
+				   CMD_SYNC | CMD_SEND_IN_RFKILL, 0, NULL);
 	if (ret) {
 		IWL_ERR(mvm, "Couldn't send SCAN_ABORT_CMD: %d\n", ret);
+		/* mac80211's state will be cleaned in the fw_restart flow */
 		goto out_remove_notif;
 	}
 


