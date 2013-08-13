Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab3HMPRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 11:17:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758185Ab3HMPRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:17:12 -0400
Message-ID: <1376407030.3033.13.camel@linux-fkkt.site>
Subject: Re: [PATCH net-next 1/3] net/usb/r8152: support aggregation
From: Oliver Neukum <oneukum@suse.de>
To: hayeswang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Tue, 13 Aug 2013 17:17:10 +0200
In-Reply-To: <9E410853D1BD483E9479C175D5E72EB6@realtek.com.tw>
References: <1376378913-879-1-git-send-email-hayeswang@realtek.com>
	 <1376383742.1681.1.camel@linux-fkkt.site>
	 <9E410853D1BD483E9479C175D5E72EB6@realtek.com.tw>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 20:32 +0800, hayeswang wrote:
>  Oliver Neukum [mailto:oneukum@suse.de] 
> > Sent: Tuesday, August 13, 2013 4:49 PM
> > To: Hayeswang
> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; 
> > linux-usb@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/3] net/usb/r8152: support aggregation
> > 
> [...]
> > > +               len_used = 0;
> > > +               rx_desc = agg->head;
> > > +               rx_data = agg->head;
> > > +               smp_wmb();
> > > +               pkt_len = le32_to_cpu(rx_desc->opts1) & RX_LEN_MASK;
> > > +               len_used += sizeof(struct rx_desc) + pkt_len;
> > > +
> > > +               while (urb->actual_length >= len_used) {
> > > +                       if (pkt_len < ETH_ZLEN)
> > > +                               break;
> > > +
> > > +                       pkt_len -= 4; /* CRC */
> > > +                       rx_data += sizeof(struct rx_desc);
> > > +
> > > +                       skb = netdev_alloc_skb_ip_align(netdev,
> > > pkt_len);
> > > +                       if (!skb) {
> > > +                               stats->rx_dropped++;
> > > +                               break;
> > > +                       }
> > > +                       memcpy(skb->data, rx_data, pkt_len);
> > > +                       skb_put(skb, pkt_len);
> > > +                       skb->protocol = eth_type_trans(skb, netdev);
> > > +                       netif_rx(skb);
> > > +                       stats->rx_packets++;
> > > +                       stats->rx_bytes += pkt_len;
> > > +
> > > +                       rx_data = rx_agg_align(rx_data + 
> > pkt_len + 4);
> > > +                       rx_desc = (struct rx_desc *)rx_data;
> > > +                       smp_wmb();
> > 
> > Against what is the memory barrier?
> 
> Excuse me. I don't understand your question. Do you mean the function should not
> be used here?

I don't understand what problem the function is supposed to fix. As long
as I don't understand it I cannot say for sure whether it is correct.
There seems no obvious reason for a memory barrier, but there may be a
hidden reason I don't see.

	Regards
		Oliver


