Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab3FMP1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 11:27:49 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:41717 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FMP1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 11:27:47 -0400
Date: Thu, 13 Jun 2013 10:27:35 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath9k-devel@venema.h4ckr.net, netdev@vger.kernel.org,
        jcalvinowens@gmail.com
Subject: Re: [PATCH] mac80211: Use RCU protection in ieee80211_get_tx_rates()
Message-ID: <20130613152735.GA1822@gmail.com>
References: <20130609225120.GA2789@gmail.com>
 <20130610042959.GA1902@gmail.com>
 <1370950926.8356.14.camel@jlt4.sipsolutions.net>
 <20130611171304.GA2189@gmail.com>
 <1370980523.8356.70.camel@jlt4.sipsolutions.net>
 <20130612075634.GA1649@gmail.com>
 <20130612080042.GA1695@gmail.com>
 <51B843C9.9090500@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51B843C9.9090500@openwrt.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06/12 at 11:47 +0200, Felix Fietkau wrote:
> On 2013-06-12 10:00 AM, Calvin Owens wrote:
> > Copying the rate table should be done in an RCU read-side critical
> > section.
> I think this approach is wrong. The sta entry is also under RCU
> protection (no locking for read access in that part of the code.
> In a normal driver tx path, no extra rcu_read_lock/rcu_read_unlock is
> needed. Only if the driver does some scheduling outside of the tx
> function (which ath9k does), this RCU warning appears.
> 
> How about this change instead:
> ---
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -1570,6 +1570,8 @@ void ath_txq_schedule(struct ath_softc *
>  	    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
>  		return;
>  
> +	rcu_read_lock();
> +
>  	ac = list_first_entry(&txq->axq_acq, struct ath_atx_ac, list);
>  	last_ac = list_entry(txq->axq_acq.prev, struct ath_atx_ac, list);
>  
> @@ -1608,8 +1610,10 @@ void ath_txq_schedule(struct ath_softc *
>  
>  		if (ac == last_ac ||
>  		    txq->axq_ampdu_depth >= ATH_AGGR_MIN_QDEPTH)
> -			return;
> +			break;
>  	}
> +
> +	rcu_read_unlock();
>  }
>  
>  /***********/
>

Yep, that stops the RCU warning for me.

Tested-by: Calvin Owens <jcalvinowens@gmail.com>
