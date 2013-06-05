Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933461Ab3FEWJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:09:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37640 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab3FEVfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Milan Kocian <milon@wq.cz>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 014/127] mac80211: use just spin_lock() in ieee80211_get_tkip_p2k()
Date: Wed,  5 Jun 2013 14:33:01 -0700
Message-Id: <20130605213219.659931884@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 655914ab863bcc06c84270e4159fd59002d6b529 upstream.

ieee80211_get_tkip_p2k() may be called with interrupts
disabled, so spin_unlock_bh() isn't safe and leads to
warnings. Since it's always called with BHs disabled
already, just use spin_lock().

Reported-by: Milan Kocian <milon@wq.cz>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/tkip.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/tkip.c
+++ b/net/mac80211/tkip.c
@@ -208,10 +208,10 @@ void ieee80211_get_tkip_p2k(struct ieee8
 	u32 iv32 = get_unaligned_le32(&data[4]);
 	u16 iv16 = data[2] | (data[0] << 8);
 
-	spin_lock_bh(&key->u.tkip.txlock);
+	spin_lock(&key->u.tkip.txlock);
 	ieee80211_compute_tkip_p1k(key, iv32);
 	tkip_mixing_phase2(tk, ctx, iv16, p2k);
-	spin_unlock_bh(&key->u.tkip.txlock);
+	spin_unlock(&key->u.tkip.txlock);
 }
 EXPORT_SYMBOL(ieee80211_get_tkip_p2k);
 


