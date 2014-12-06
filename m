Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbaLFR7k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:59:40 -0500
Received: from 1wt.eu ([62.212.114.60]:40716 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468AbaLFRy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:57 -0500
Message-Id: <20141206174149.465456075@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:42:12 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Andy Whitcroft <apw@canonical.com>,
        Stefan Bader <stefan.bader@canonical.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 24/25] mac80211: fix fragmentation code, particularly for
 encryption
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a722a419815ed203b519151f9556859ff256638b upstream

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

Cc: stable@vger.kernel.org
Fixes: 2de8e0d999b8 ("mac80211: rewrite fragmentation")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
(backported from commit 338f977f4eb441e69bb9a46eaa0ac715c931a67f)
CVE-2014-8709
BugLink: http://bugs.launchpad.net/bugs/1392013
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Acked-by: Andy Whitcroft <apw@canonical.com>
Acked-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b1d7904..687fc8e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -770,7 +770,7 @@ static int ieee80211_fragment(struct ieee80211_local *local,
 		pos += fraglen;
 	}
 
-	skb->len = hdrlen + per_fragm;
+	skb_trim(skb, hdrlen + per_fragm);
 	return 0;
 }
 
-- 
1.7.12.2.21.g234cd45.dirty



