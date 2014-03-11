Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754351AbaCKNF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:05:29 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:55023 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbaCKNF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:05:26 -0400
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Subject: [PATCH 2/5] nl80211: Support for 5/10 MHz channels when reporting BW restrictions
Date: Tue, 11 Mar 2014 14:05:11 +0100
Message-Id: <1394543114-6700-3-git-send-email-rostislav.lisovy@fel.cvut.cz>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
References: <1394543114-6700-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the 'split wiphy dump' is enabled report the extra attributes
(if present) describing the bandwidth restrictions.
If the 'split wiphy dump' is not enabled completely omit those
channels that have flags set to either IEEE80211_CHAN_NO_10MHZ
or IEEE80211_CHAN_NO_20MHZ thus preventing breaking of old
user-space tools.

Signed-off-by: Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
---
 net/wireless/nl80211.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4fe2e6e..c62c572 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -563,6 +563,13 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 				   struct ieee80211_channel *chan,
 				   bool large)
 {
+	/* Some channels must be completely excluded from the
+	 * list to protect old user-space tools from breaking
+	 */
+	if (!large && chan->flags &
+	    (IEEE80211_CHAN_NO_10MHZ | IEEE80211_CHAN_NO_20MHZ))
+		return 0;
+
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_FREQ,
 			chan->center_freq))
 		goto nla_put_failure;
@@ -606,6 +613,12 @@ static int nl80211_msg_put_channel(struct sk_buff *msg,
 		if ((chan->flags & IEEE80211_CHAN_NO_160MHZ) &&
 		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_160MHZ))
 			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_20MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_20MHZ))
+			goto nla_put_failure;
+		if ((chan->flags & IEEE80211_CHAN_NO_10MHZ) &&
+		    nla_put_flag(msg, NL80211_FREQUENCY_ATTR_NO_10MHZ))
+			goto nla_put_failure;
 	}
 
 	if (nla_put_u32(msg, NL80211_FREQUENCY_ATTR_MAX_TX_POWER,
-- 
1.8.5.1

