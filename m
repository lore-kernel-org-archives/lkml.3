Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab3EFXEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:04:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36423 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab3EFW7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:59:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 39/46] wireless: regulatory: fix channel disabling race condition
Date: Mon,  6 May 2013 15:58:45 -0700
Message-Id: <20130506225824.760313478@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506225820.628893970@linuxfoundation.org>
References: <20130506225820.628893970@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 990de49f74e772b6db5208457b7aa712a5f4db86 upstream.

When a full scan 2.4 and 5 GHz scan is scheduled, but then the 2.4 GHz
part of the scan disables a 5.2 GHz channel due to, e.g. receiving
country or frequency information, that 5.2 GHz channel might already
be in the list of channels to scan next. Then, when the driver checks
if it should do a passive scan, that will return false and attempt an
active scan. This is not only wrong but can also lead to the iwlwifi
device firmware crashing since it checks regulatory as well.

Fix this by not setting the channel flags to just disabled but rather
OR'ing in the disabled flag. That way, even if the race happens, the
channel will be scanned passively which is still (mostly) correct.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -852,7 +852,7 @@ static void handle_channel(struct wiphy
 			return;
 
 		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
-		chan->flags = IEEE80211_CHAN_DISABLED;
+		chan->flags |= IEEE80211_CHAN_DISABLED;
 		return;
 	}
 


