Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407AbaBUMuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:50:50 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47081 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaBUMuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:50:46 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 072/121] mac80211: fix fragmentation code, particularly for encryption
Date: Fri, 21 Feb 2014 12:48:16 +0000
Message-Id: <1392986945-9693-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 338f977f4eb441e69bb9a46eaa0ac715c931a67f upstream.

The "new" fragmentation code (since my rewrite almost 5 years ago)
erroneously sets skb->len rather than using skb_trim() to adjust
the length of the first fragment after copying out all the others.
This leaves the skb tail pointer pointing to after where the data
originally ended, and thus causes the encryption MIC to be written
at that point, rather than where it belongs: immediately after the
data.

The impact of this is that if software encryption is done, then
 a) encryption doesn't work for the first fragment, the connection
    becomes unusable as the first fragment will never be properly
    verified at the receiver, the MIC is practically guaranteed to
    be wrong
 b) we leak up to 8 bytes of plaintext (!) of the packet out into
    the air

This is only mitigated by the fact that many devices are capable
of doing encryption in hardware, in which case this can't happen
as the tail pointer is irrelevant in that case. Additionally,
fragmentation is not used very frequently and would normally have
to be configured manually.

Fix this by using skb_trim() properly.

Fixes: 2de8e0d999b8 ("mac80211: rewrite fragmentation")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index ebd9471..cf8d00a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -855,7 +855,7 @@ static int ieee80211_fragment(struct ieee80211_tx_data *tx,
 	}
 
 	/* adjust first fragment's length */
-	skb->len = hdrlen + per_fragm;
+	skb_trim(skb, hdrlen + per_fragm);
 	return 0;
 }
 
-- 
1.9.0

