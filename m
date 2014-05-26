Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaEZJGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:06:47 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:39226 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaEZJGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:06:45 -0400
Message-ID: <1401095199.11908.6.camel@umadbro>
Subject: Re: [RFC 1/2] cfg80211: Add channel flags limiting availability to
 OCB mode only
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Sojka <sojkam1@fel.cvut.cz>, s.sander@nordsys.de,
        jan-niklas.meier@volkswagen.de,
        Rostislav Lisovy <rostislav.lisovy@fel.cvut.cz>
Date: Mon, 26 May 2014 11:06:39 +0200
In-Reply-To: <1400511063.4273.10.camel@jlt4.sipsolutions.net>
References: <1400510945-24868-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1400510945-24868-2-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140519_164914_781166_025BC930) <1400511063.4273.10.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 16:51 +0200, Johannes Berg wrote:
> This patch is fine, but insufficient - you should also do something
> with
> the new flags?

That's definitely a good point. I think the biggest issue is that the
flags can't be checked only with the knowledge of the 'wiphy' but they
are related to the 'vif' type -- this prohibits checking in the
cfg80211_chandef_usable() (I assume).

Would the following be sufficient?

--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -801,6 +801,10 @@ static int __ieee80211_vif_change_channel(struct ieee80211_sub_if_data *sdata,
 		*changed |= BSS_CHANGED_BANDWIDTH;
 	}
 
+	if (sdata->vif.type == NL80211_IFTYPE_OCB &&
+	    !(chandef->chan->flags & IEEE80211_CHAN_OCB_ONLY))
+		return -EINVAL;
+
 	sdata->vif.bss_conf.chandef = *chandef;
 	ctx->conf.def = *chandef;
 
@@ -1049,6 +1053,12 @@ int ieee80211_vif_change_bandwidth(struct ieee80211_sub_if_data *sdata,
 		goto out;
 	}
 
+	if (sdata->vif.type == NL80211_IFTYPE_OCB &&
+	    !(chandef->chan->flags & IEEE80211_CHAN_OCB_ONLY)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	if (chandef->width == NL80211_CHAN_WIDTH_20_NOHT ||
 	    sdata->vif.bss_conf.chandef.width == NL80211_CHAN_WIDTH_20_NOHT) {
 		ret = -EINVAL;

--
Best regards;
Rostislav Lisovy


