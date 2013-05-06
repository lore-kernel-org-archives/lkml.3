Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab3EFMgm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753087Ab3EFMgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:36:38 -0400
Date: Mon, 6 May 2013 14:38:06 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jake Edge <jake@lwn.net>
Cc: linux-wireless@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Bisected 3.9 regression for iwl4965 connection problem to
 1672c0e3
Message-ID: <20130506123805.GA1602@redhat.com>
References: <20130505143803.7e46e4c6@chukar.edge2.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130505143803.7e46e4c6@chukar.edge2.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 05, 2013 at 02:38:03PM -0600, Jake Edge wrote:
> 
> After building 3.9 for my HP/Compaq 2510p laptop, the wireless (iwl4965)
> would seemingly no longer connect.  Actually, it seems that it *will*
> eventually, where that is somewhere between 4 and 21+ retries (from KDE
> network manager).  Going back to 3.8 (and earlier) and the problem goes
> away.  (All on Fedora 18, fwiw, but I don't think that's significant).
> 
> I bisected the problem to:
> 
> commit 1672c0e31917f49d31d30d79067103432bc20cc7
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Tue Jan 29 15:02:27 2013 +0100
> 
>     mac80211: start auth/assoc timeout on frame status
> 
> but I can't (easily) revert that in 3.9 (maybe I can in -rc1 or
> something?  haven't tried that)
> 
> What more information is needed from me?  I may still mess around with
> trying to revert that patch just to nail it down for sure, but two
> separate bisection exercises ended up at the same place.

Below patch should restore old mac80211 behaviour, by stop
telling mac that 4965 supports TX ACK status. Does it help?

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index b8f82e6..eaa756d 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -5741,7 +5741,7 @@ il4965_mac_setup_register(struct il_priv *il, u32 max_probe_length)
 	hw->flags =
 	    IEEE80211_HW_SIGNAL_DBM | IEEE80211_HW_AMPDU_AGGREGATION |
 	    IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC | IEEE80211_HW_SPECTRUM_MGMT |
-	    IEEE80211_HW_REPORTS_TX_ACK_STATUS | IEEE80211_HW_SUPPORTS_PS |
+	    IEEE80211_HW_SUPPORTS_PS |
 	    IEEE80211_HW_SUPPORTS_DYNAMIC_PS;
 	if (il->cfg->sku & IL_SKU_N)
 		hw->flags |=
  
