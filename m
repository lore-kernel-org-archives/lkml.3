Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3ERDDB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 23:03:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26211 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822Ab3ERDAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 23:00:32 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Fj0BgW9vGqAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=_yy8vF1cj90A:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=aCPqOQJ_S1qBLZ7JjQ4A:9 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021653.080438088@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:17:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [ 070/136 ] wireless: regulatory: fix channel disabling race condition
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0070-wireless-regulatory-fix-channel-disabling-race-condi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 990de49f74e772b6db5208457b7aa712a5f4db86 ]

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

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 3062b88..633806e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -874,7 +874,7 @@ static void handle_channel(struct wiphy *wiphy,
 			return;
 
 		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
-		chan->flags = IEEE80211_CHAN_DISABLED;
+		chan->flags |= IEEE80211_CHAN_DISABLED;
 		return;
 	}
 
-- 
1.7.10.4


