Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3BGILt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:11:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19603 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752493Ab3BGILg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:11:36 -0500
Date: Thu, 7 Feb 2013 10:15:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: netdev@vger.kernel.org, Eilon Greenstein <eilong@broadcom.com>,
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
Message-ID: <20130207081529.GA9126@redhat.com>
References: <cover.1360191528.git.mst@redhat.com>
 <51131E99.8080400@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51131E99.8080400@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2013 at 11:25:13AM +0800, Cong Wang wrote:
> On 02/07/2013 07:02 AM, Michael S. Tsirkin wrote:
> >At the moment, macvtap crashes are observed if macvtap is attached
> >to an interface with LRO enabled.
> >The crash in question is BUG() in macvtap_skb_to_vnet_hdr.
> >This happens because several drivers set gso_size but not gso_type
> >in incoming skbs.
> >The following patches fix this for
> >Additionally, cbf1de72324a8105ddcc3d9ce9acbc613faea17e is required
> >to fix this for broadcom - would it make sense to cherry-pick
> >this patch into 3.8?
> 
> 
> Doesn't macvtap need to call skb_warn_if_lro() too like bridge and
> openvswitch? Something like...

This is what Ben proposed a year ago
http://thread.gmane.org/gmane.linux.network/221695
but apparently people really want LRO to work with macvtap.

> diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
> index b181dfb..b2c6227 100644
> --- a/drivers/net/macvtap.c
> +++ b/drivers/net/macvtap.c
> @@ -253,6 +253,9 @@ static int macvtap_forward(struct net_device
> *dev, struct sk_buff *skb)
>         if (!q)
>                 goto drop;
> 
> +       if (unlikely(skb_warn_if_lro(skb)))
> +               goto drop;
> +
>         if (skb_queue_len(&q->sk.sk_receive_queue) >= dev->tx_queue_len)
>                 goto drop;
> 
> 
> I am not saying these drivers don't need to fix, I am just saying if
> we need to fix LRO case.
> 
> Thanks.
