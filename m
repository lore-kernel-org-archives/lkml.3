Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab3KIHkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 02:40:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32863 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab3KIGuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:50:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Lindroth <thomas.lindroth@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 14/74] mac80211: fix crash if bitrate calculation goes wrong
Date: Fri,  8 Nov 2013 22:51:19 -0800
Message-Id: <20131109065114.552973330@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065113.502217951@linuxfoundation.org>
References: <20131109065113.502217951@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit d86aa4f8ca58898ec6a94c0635da20b948171ed7 upstream.

If a frame's timestamp is calculated, and the bitrate
calculation goes wrong and returns zero, the system
will attempt to divide by zero and crash. Catch this
case and print the rate information that the driver
reported when this happens.

Reported-by: Thomas Lindroth <thomas.lindroth@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/util.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2174,6 +2174,10 @@ u64 ieee80211_calculate_rx_timestamp(str
 	}
 
 	rate = cfg80211_calculate_bitrate(&ri);
+	if (WARN_ONCE(!rate,
+		      "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
+		      status->flag, status->rate_idx, status->vht_nss))
+		return 0;
 
 	/* rewind from end of MPDU */
 	if (status->flag & RX_FLAG_MACTIME_END)


