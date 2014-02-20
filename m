Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529AbaBUBGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:06:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45320 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647AbaBTXuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:50:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jouni Malinen <j@w1.fi>, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.4 03/25] mac80211: fix fragmentation code, particularly for encryption
Date: Thu, 20 Feb 2014 15:51:19 -0800
Message-Id: <20140220234842.580678666@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
References: <20140220234842.483343851@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -907,7 +907,7 @@ static int ieee80211_fragment(struct iee
 	}
 
 	/* adjust first fragment's length */
-	skb->len = hdrlen + per_fragm;
+	skb_trim(skb, hdrlen + per_fragm);
 	return 0;
 }
 


