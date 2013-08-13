Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab3HMXlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 19:41:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45474 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815Ab3HMXlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 19:41:19 -0400
Date: Tue, 13 Aug 2013 16:41:18 -0700 (PDT)
Message-Id: <20130813.164118.1992860501009385037.davem@davemloft.net>
To: oneukum@suse.de
Cc: hayeswang@realtek.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net/usb/r8152: support aggregation
From: David Miller <davem@davemloft.net>
In-Reply-To: <1376407030.3033.13.camel@linux-fkkt.site>
References: <1376383742.1681.1.camel@linux-fkkt.site>
	<9E410853D1BD483E9479C175D5E72EB6@realtek.com.tw>
	<1376407030.3033.13.camel@linux-fkkt.site>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 13 Aug 2013 16:41:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oliver Neukum <oneukum@suse.de>
Date: Tue, 13 Aug 2013 17:17:10 +0200

> On Tue, 2013-08-13 at 20:32 +0800, hayeswang wrote:
>>  Oliver Neukum [mailto:oneukum@suse.de] 
>> > Sent: Tuesday, August 13, 2013 4:49 PM
>> > To: Hayeswang
>> > Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; 
>> > linux-usb@vger.kernel.org
>> > Subject: Re: [PATCH net-next 1/3] net/usb/r8152: support aggregation
>> > 
>> [...]
>> > > +               len_used = 0;
>> > > +               rx_desc = agg->head;
>> > > +               rx_data = agg->head;
>> > > +               smp_wmb();
>> > > +               pkt_len = le32_to_cpu(rx_desc->opts1) & RX_LEN_MASK;
>> > > +               len_used += sizeof(struct rx_desc) + pkt_len;
>> > > +
>> > > +               while (urb->actual_length >= len_used) {
>> > > +                       if (pkt_len < ETH_ZLEN)
>> > > +                               break;
>> > > +
>> > > +                       pkt_len -= 4; /* CRC */
>> > > +                       rx_data += sizeof(struct rx_desc);
>> > > +
>> > > +                       skb = netdev_alloc_skb_ip_align(netdev,
>> > > pkt_len);
>> > > +                       if (!skb) {
>> > > +                               stats->rx_dropped++;
>> > > +                               break;
>> > > +                       }
>> > > +                       memcpy(skb->data, rx_data, pkt_len);
>> > > +                       skb_put(skb, pkt_len);
>> > > +                       skb->protocol = eth_type_trans(skb, netdev);
>> > > +                       netif_rx(skb);
>> > > +                       stats->rx_packets++;
>> > > +                       stats->rx_bytes += pkt_len;
>> > > +
>> > > +                       rx_data = rx_agg_align(rx_data + 
>> > pkt_len + 4);
>> > > +                       rx_desc = (struct rx_desc *)rx_data;
>> > > +                       smp_wmb();
>> > 
>> > Against what is the memory barrier?
>> 
>> Excuse me. I don't understand your question. Do you mean the function should not
>> be used here?
> 
> I don't understand what problem the function is supposed to fix. As long
> as I don't understand it I cannot say for sure whether it is correct.
> There seems no obvious reason for a memory barrier, but there may be a
> hidden reason I don't see.

Hayes, when Oliver asks you "Against what is the memory barrier?" he is asking
you which memory operations you are trying to order.

You do not explain this in your commit message, nor do you explain it with a
suitable comment.  This is not acceptable.

It is absolutely critical, that any time you add a memory barrier, you add a
comment above the new memory barrier explaining exactly what the barrier is
trying to achieve.

In fact, this is required by our coding standards.
