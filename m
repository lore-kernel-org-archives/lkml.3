Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab3BGIMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 03:12:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab3BGIMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 03:12:31 -0500
Date: Thu, 7 Feb 2013 10:16:35 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
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
        e1000-devel@lists.sourceforge.net, bhutchings@solarflare.com
Subject: Re: [PATCH 2/2] qlcnic: set gso_type
Message-ID: <20130207081634.GB9126@redhat.com>
References: <cover.1360191528.git.mst@redhat.com>
 <f262d9330d22447ed8fd487ad7b28d668efbf333.1360191528.git.mst@redhat.com>
 <1360207237.28557.48.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360207237.28557.48.camel@edumazet-glaptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 06, 2013 at 07:20:37PM -0800, Eric Dumazet wrote:
> On Thu, 2013-02-07 at 01:02 +0200, Michael S. Tsirkin wrote:
> > qlcnic set gso_size but not gso type. This leads to crashes
> > in macvtap.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> > This one I only compiled - don't have qlogic hardware.
> > 
> >  drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> > index bb4311e..370049c 100644
> > --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> > +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_io.c
> > @@ -1043,8 +1043,13 @@ qlcnic_process_lro(struct qlcnic_adapter *adapter,
> >  	th->seq = htonl(seq_number);
> >  	length = skb->len;
> >  
> > -	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP)
> > +	if (adapter->flags & QLCNIC_FW_LRO_MSS_CAP) {
> >  		skb_shinfo(skb)->gso_size = qlcnic_get_lro_sts_mss(sts_data1);
> > +		if (skb->protocol == ETH_P_IPV6)
> 
> Are you sure its not skb->protocol == htons(ETH_P_IPV6) ?

Um, so it is. It just happens to work correctly for ipv4 :)
I'll respin.

> > +			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV6;
> > +		else
> > +			skb_shinfo(skb)->gso_type = SKB_GSO_TCPV4;
> > +	}
> >  
> >  	if (vid != 0xffff)
> >  		__vlan_hwaccel_put_tag(skb, vid);
> 
