Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612AbaKFH6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 02:58:47 -0500
Received: from antispam.ahnlab.com ([210.121.169.55]:59179 "EHLO
	antispam.ahnlab.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070AbaKFH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 02:58:45 -0500
X-Original-SENDERIP: 172.16.11.209
X-Original-MAILFROM: suhyun.park@ahnlab.com
From: =?ks_c_5601-1987?B?udq89sf2?= <suhyun.park@ahnlab.com>
To: Toshiaki Makita <makita.toshiaki@lab.ntt.co.jp>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
CC: "bridge@lists.linux-foundation.org" 
	<bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] bridge: missing null bridge device check causing null
 pointer dereference (bugfix)
Thread-Topic: [PATCH] bridge: missing null bridge device check causing null
 pointer dereference (bugfix)
Thread-Index: AQHP+YqrhNePGBbJkEOg7Nz1l90pj5xSlqaAgACjdfA=
Date: Thu, 6 Nov 2014 07:58:41 +0000
Message-ID: <8D1F1238A24CE743B8F3CED0F137C69E408AA087@EXMB02.ahnbang.ahnlab.com>
References: <1415255192-13584-1-git-send-email-suhyun.park@ahnlab.com>
 <545B1E27.3080302@lab.ntt.co.jp>
In-Reply-To: <545B1E27.3080302@lab.ntt.co.jp>
Accept-Language: ko-KR, en-US
Content-Language: ko-KR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.20.32.26]
Content-Type: text/plain; charset="ks_c_5601-1987"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sA67wqet000986

>-----Original Message-----
>From: Toshiaki Makita [mailto:makita.toshiaki@lab.ntt.co.jp]
>Sent: Thursday, November 06, 2014 4:07 PM
>To: ¹Ú¼öÇö; Stephen Hemminger; David S. Miller
>Cc: bridge@lists.linux-foundation.org; netdev@vger.kernel.org; linux-
>kernel@vger.kernel.org
>Subject: Re: [PATCH] bridge: missing null bridge device check causing null
>pointer dereference (bugfix)
>
>On 2014/11/06 15:26, Su-Hyun Park wrote:
>> the bridge device can be null if the bridge is being deleted while
>> processing the packet, which causes the null pointer dereference in
>switch statement.
>
>How can this happen??
>It is guarded by rcu.
>netdev_rx_handler_unregister() ensures rx_handler_data is non NULL.
>

The RCU protect rx_handler_data, not the bridge member port. It can be NULL according to below code.

static inline struct net_bridge_port *br_port_get_rcu(const struct net_device *dev) {
	struct net_bridge_port *port = rcu_dereference(dev->rx_handler_data);
	return br_port_exists(dev) ? port : NULL; 
}

The crash happens at the below switch statement in br_handle_frame, where p is NULL.

	switch (p->state)

>>
>> crash dump snippet:
>>
>> <1>BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000021
>> <1>IP: [<ffffffff814179f6>] br_handle_frame+0xe6/0x270
>>
>> <0>Code: 4c 0f 44 f0 89 f8 66 33 15 32 52 24 00 66 33 05 29 52 24 00
>> 09 c2 89
>> f0 66 33 05 22 52 24 00 80 e4 f0 66 09 c2 0f 84 eb 00 00 00 <41> 0f b6
>> 46 21 3c 02 74 61 3c 03 74 1d 48 89 df e8 d5 bc f0 ff
>> ---
>>  net/bridge/br_input.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c index
>> 6fd5522..7e899ca 100644
>> --- a/net/bridge/br_input.c
>> +++ b/net/bridge/br_input.c
>> @@ -176,6 +176,8 @@ rx_handler_result_t br_handle_frame(struct sk_buff
>**pskb)
>>  		return RX_HANDLER_CONSUMED;
>>
>>  	p = br_port_get_rcu(skb->dev);
>> +	if (!p)
>> +		goto drop;
>>
>>  	if (unlikely(is_link_local_ether_addr(dest))) {
>>  		u16 fwd_mask = p->br->group_fwd_mask_required;
>>
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
