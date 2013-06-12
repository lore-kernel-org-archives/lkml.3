Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3FLJsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 05:48:11 -0400
Received: from nbd.name ([46.4.11.11]:49779 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab3FLJsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 05:48:09 -0400
Message-ID: <51B843C9.9090500@openwrt.org>
Date: Wed, 12 Jun 2013 11:47:53 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Calvin Owens <jcalvinowens@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: Use RCU protection in ieee80211_get_tx_rates()
References: <20130609225120.GA2789@gmail.com> <20130610042959.GA1902@gmail.com> <1370950926.8356.14.camel@jlt4.sipsolutions.net> <20130611171304.GA2189@gmail.com> <1370980523.8356.70.camel@jlt4.sipsolutions.net> <20130612075634.GA1649@gmail.com> <20130612080042.GA1695@gmail.com>
In-Reply-To: <20130612080042.GA1695@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-06-12 10:00 AM, Calvin Owens wrote:
> Copying the rate table should be done in an RCU read-side critical
> section.
I think this approach is wrong. The sta entry is also under RCU
protection (no locking for read access in that part of the code.
In a normal driver tx path, no extra rcu_read_lock/rcu_read_unlock is
needed. Only if the driver does some scheduling outside of the tx
function (which ath9k does), this RCU warning appears.

How about this change instead:
---
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1570,6 +1570,8 @@ void ath_txq_schedule(struct ath_softc *
 	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
 		return;
 
+	rcu_read_lock();
+
 	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
 	last_ac = list_entry(txq->axq_acq.prev, struct ath_atx_ac, list);
 
@@ -1608,8 +1610,10 @@ void ath_txq_schedule(struct ath_softc *
 
 		if (ac == last_ac ||
 		    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
-			return;
+			break;
 	}
+
+	rcu_read_unlock();
 }
 
 /***********/

