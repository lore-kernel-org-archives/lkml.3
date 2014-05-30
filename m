Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582AbaE3MwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 08:52:21 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:59359 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752615AbaE3MwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 08:52:20 -0400
Message-ID: <1401454338.17240.13.camel@x220>
Subject: [PATCH v2] staging: rtl8192u: remove checks for
 CONFIG_IEEE80211_CRYPT_TKIP
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Fri, 30 May 2014 14:52:18 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 May 2014 12:52:18.0556 (UTC) FILETIME=[FD6E03C0:01CF7C05]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ever since rtl8192u was added as a staging driver in v2.6.33 it contained
checks for CONFIG_IEEE80211_CRYPT_TKIP. But the Kconfig symbol
IEEE80211_CRYPT_TKIP was renamed to LIB80211_CRYPT_TKIP in v2.6.29. So
these checks have always evaluated to false. And these checks were rather
odd to begin with, since rtl8192u comes with its own ieee80211 stack,
which has support for TKIP built in.

Now the safe and easy thing to do here would be to remove these checks
and the code they hide. But it turns out that with some minor cleanup
the code currently hidden behind these checks builds cleanly. And by
building it we allow the people actually running this code to test
whether it is any good.

That minor cleanup is needed because ieee80211_encrypt_fragment()
accesses struct sk_buff's data member as if it is a struct
ieee80211_hdr. It's not. See, in ieee80211_xmit() a struct
ieee80211_hdr_3addrqos is skb_put() into the sk_buff with which
ieee80211_encrypt_fragment() will be called. So switch from
ieee80211_hdr to ieee80211_hdr_3addrqos here.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
v1 was called "staging: rtl8192u: rename CONFIG_IEEE80211_CRYPT_TKIP".
It managed to break the build of next-20142528. It was way too naive and
improperly build tested to boot.

This is build tested, properly, on x86_64. I can't run test this.
Besides, I have no idea what tkip_countermeasures are so I wouldn't know
what to look for.

But perhaps you prefer the safe and easy thing here...

 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c | 2 --
 drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c | 8 ++++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index d9a8299c48eb..73410ccfb1ec 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -352,7 +352,6 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 	hdr = (struct ieee80211_hdr_4addr *) skb->data;
 	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
 
-#ifdef CONFIG_IEEE80211_CRYPT_TKIP
 	if (ieee->tkip_countermeasures &&
 	    strcmp(crypt->ops->name, "TKIP") == 0) {
 		if (net_ratelimit()) {
@@ -362,7 +361,6 @@ ieee80211_rx_frame_decrypt(struct ieee80211_device *ieee, struct sk_buff *skb,
 		}
 		return -1;
 	}
-#endif
 
 	atomic_inc(&crypt->refcnt);
 	res = crypt->ops->decrypt_mpdu(skb, hdrlen, crypt->priv);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
index 029a97651797..7f9e655f9eb8 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_tx.c
@@ -191,20 +191,20 @@ int ieee80211_encrypt_fragment(
 		printk("=========>%s(), crypt is null\n", __func__);
 		return -1;
 	}
-#ifdef CONFIG_IEEE80211_CRYPT_TKIP
-	struct ieee80211_hdr *header;
 
 	if (ieee->tkip_countermeasures &&
 	    crypt && crypt->ops && strcmp(crypt->ops->name, "TKIP") == 0) {
-		header = (struct ieee80211_hdr *) frag->data;
 		if (net_ratelimit()) {
+			struct ieee80211_hdr_3addrqos *header;
+
+			header = (struct ieee80211_hdr_3addrqos *)frag->data;
 			printk(KERN_DEBUG "%s: TKIP countermeasures: dropped "
 			       "TX packet to %pM\n",
 			       ieee->dev->name, header->addr1);
 		}
 		return -1;
 	}
-#endif
+
 	/* To encrypt, frame format is:
 	 * IV (4 bytes), clear payload (including SNAP), ICV (4 bytes) */
 
-- 
1.9.3

