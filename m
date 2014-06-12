Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932543AbaFLDYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 23:24:04 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44883 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbaFLDYC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 23:24:02 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
CC: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 11 Jun 2014 20:22:11 -0700
Subject: RE: [patch 11/13] wireless: mwifiex: Use the proper interfaces
Thread-Topic: [patch 11/13] wireless: mwifiex: Use the proper interfaces
Thread-Index: Ac+F0Szq2h2yZIkdSr6dHXYrTjoLmwAGzTYw
Message-ID: <477F20668A386D41ADCC57781B1F70430FE1F8B507@SC-VEXCH1.marvell.com>
References: <20140611234024.103571777@linutronix.de>
 <20140611234607.607201623@linutronix.de>
In-Reply-To: <20140611234607.607201623@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-12_02:2014-06-11,2014-06-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406120043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

Thanks for your patch.

> Why is converting time formats so desired if there are proper
> interfaces for this?
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org

[...]

> Index: linux/drivers/net/wireless/mwifiex/main.c
> ===================================================================
> --- linux.orig/drivers/net/wireless/mwifiex/main.c
> +++ linux/drivers/net/wireless/mwifiex/main.c
> @@ -611,7 +611,6 @@ mwifiex_hard_start_xmit(struct sk_buff *
>  	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
>  	struct sk_buff *new_skb;
>  	struct mwifiex_txinfo *tx_info;
> -	struct timeval tv;
> 
>  	dev_dbg(priv->adapter->dev, "data: %lu BSS(%d-%d): Data <= kernel\n",
>  		jiffies, priv->bss_type, priv->bss_num);
> @@ -658,8 +657,7 @@ mwifiex_hard_start_xmit(struct sk_buff *
>  	 * firmware for aggregate delay calculation for stats and
>  	 * MSDU lifetime expiry.
>  	 */
> -	do_gettimeofday(&tv);
> -	skb->tstamp = timeval_to_ktime(tv);
> +	__net_timestamp(skb);
> 
>  	mwifiex_queue_tx_pkt(priv, skb);
> 
> Index: linux/drivers/net/wireless/mwifiex/tdls.c
> ===================================================================
> --- linux.orig/drivers/net/wireless/mwifiex/tdls.c
> +++ linux/drivers/net/wireless/mwifiex/tdls.c
> @@ -552,8 +552,7 @@ int mwifiex_send_tdls_data_frame(struct
>  	tx_info->bss_num = priv->bss_num;
>  	tx_info->bss_type = priv->bss_type;
> 
> -	do_gettimeofday(&tv);
> -	skb->tstamp = timeval_to_ktime(tv);
> +	__net_timestamp(skb);

I guess we need to remove "struct timeval tv" local variable too.

>  	mwifiex_queue_tx_pkt(priv, skb);
> 
>  	return 0;
> @@ -710,8 +709,7 @@ int mwifiex_send_tdls_action_frame(struc
>  	pkt_len = skb->len - MWIFIEX_MGMT_FRAME_HEADER_SIZE - sizeof(pkt_len);
>  	memcpy(skb->data + MWIFIEX_MGMT_FRAME_HEADER_SIZE, &pkt_len,
>  	       sizeof(pkt_len));
> -	do_gettimeofday(&tv);
> -	skb->tstamp = timeval_to_ktime(tv);
> +	__net_timestamp(skb);

And here too.

Could you please remove these two "struct timeval tv" and send v2 with my ACK?

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

>  	mwifiex_queue_tx_pkt(priv, skb);
> 
>  	return 0;

