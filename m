Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652Ab3EJO17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:27:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57276 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755958Ab3EJOV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:21:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.136500812@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [034/118] wireless: regulatory: fix channel disabling race condition
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/reg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -853,7 +853,7 @@ static void handle_channel(struct wiphy
 			return;
 
 		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
-		chan->flags = IEEE80211_CHAN_DISABLED;
+		chan->flags |= IEEE80211_CHAN_DISABLED;
 		return;
 	}
 

