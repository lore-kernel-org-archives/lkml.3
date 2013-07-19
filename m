Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965796Ab3GSFdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:33:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440Ab3GSF1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:27:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 44/72] iwlwifi: pcie: wake the queue if stopped when being unmapped
Date: Thu, 18 Jul 2013 22:26:01 -0700
Message-Id: <20130719052602.876093802@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <20130719052559.852627424@linuxfoundation.org>
References: <20130719052559.852627424@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit 8a487b1a7432b20ff3f82387a8ce7555a964b44e upstream.

When the queue is unmapped while it was so loaded that
mac80211's was stopped, we need to wake the queue after
having freed all the packets in the queue.
Not doing so can result in weird stuff like:

* run lots of traffic (mac80211's queue gets stopped)
* RFKILL
* de-assert RFKILL
* no traffic

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/pcie/tx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -583,6 +583,9 @@ static void iwl_pcie_txq_unmap(struct iw
 	}
 	txq->active = false;
 	spin_unlock_bh(&txq->lock);
+
+	/* just in case - this queue may have been stopped */
+	iwl_wake_queue(trans, txq);
 }
 
 /*


