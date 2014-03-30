Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaCaARz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:17:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36377 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753016AbaC3XZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:25:01 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jouni Malinen" <j@w1.fi>,
        "Johannes Berg" <johannes.berg@intel.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.187808835@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 086/200] mac80211: fix fragmentation code,
 particularly for encryption
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -884,7 +884,7 @@ static int ieee80211_fragment(struct iee
 		pos += fraglen;
 	}
 
-	skb->len = hdrlen + per_fragm;
+	skb_trim(skb, hdrlen + per_fragm);
 	return 0;
 }
 

