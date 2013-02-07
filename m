Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3BGDZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:25:30 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:62574 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab3BGDZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:25:25 -0500
Message-ID: <51131E99.8080400@gmail.com>
Date: Thu, 07 Feb 2013 11:25:13 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: netdev@vger.kernel.org, Eilon Greenstein <eilong@broadcom.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Greg Rose <gregory.v.rose@intel.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Alex Duyck <alexander.h.duyck@intel.com>,
        John Ronciak <john.ronciak@intel.com>,
        Tushar Dave <tushar.n.dave@intel.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, linux-driver@qlogic.com,
        John Fastabend <john.r.fastabend@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jacob Keller <jacob.e.keller@intel.com>, linux-kernel@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, bhutchings@solarflare.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH 0/2] fix kernel crash with macvtap on top of LRO
References: <cover.1360191528.git.mst@redhat.com>
In-Reply-To: <cover.1360191528.git.mst@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 07:02 AM, Michael S. Tsirkin wrote:
> At the moment, macvtap crashes are observed if macvtap is attached
> to an interface with LRO enabled.
> The crash in question is BUG() in macvtap_skb_to_vnet_hdr.
> This happens because several drivers set gso_size but not gso_type
> in incoming skbs.
> The following patches fix this for
> Additionally, cbf1de72324a8105ddcc3d9ce9acbc613faea17e is required
> to fix this for broadcom - would it make sense to cherry-pick
> this patch into 3.8?


Doesn't macvtap need to call skb_warn_if_lro() too like bridge and 
openvswitch? Something like...

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index b181dfb..b2c6227 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -253,6 +253,9 @@ static int macvtap_forward(struct net_device *dev, 
struct sk_buff *skb)
         if (!q)
                 goto drop;

+       if (unlikely(skb_warn_if_lro(skb)))
+               goto drop;
+
         if (skb_queue_len(&q->sk.sk_receive_queue) >= dev->tx_queue_len)
                 goto drop;


I am not saying these drivers don't need to fix, I am just saying if we 
need to fix LRO case.

Thanks.
