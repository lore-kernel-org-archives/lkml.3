Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3HMItQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:49:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38564 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755313Ab3HMItE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:49:04 -0400
Message-ID: <1376383742.1681.1.camel@linux-fkkt.site>
Subject: Re: [PATCH net-next 1/3] net/usb/r8152: support aggregation
From: Oliver Neukum <oneukum@suse.de>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Date: Tue, 13 Aug 2013 10:49:02 +0200
In-Reply-To: <1376378913-879-1-git-send-email-hayeswang@realtek.com>
References: <1376378913-879-1-git-send-email-hayeswang@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-13 at 15:28 +0800, Hayes Wang wrote:
> +
> +static void rx_bottom(struct r8152 *tp)
> +{
> +       struct net_device_stats *stats;
> +       struct net_device *netdev;
> +       struct rx_agg *agg;
> +       struct rx_desc *rx_desc;
> +       unsigned long lockflags;
> +       struct list_head *cursor, *next;
> +       struct sk_buff *skb;
> +       struct urb *urb;
> +       unsigned pkt_len;
> +       int len_used;
> +       u8 *rx_data;
> +       int ret;
> +
> +       netdev = tp->netdev;
> +
> +       if (!netif_running(netdev))
>                 return;
> -       dev_kfree_skb_irq(tp->tx_skb);
> -       if (!netif_device_present(tp->netdev))
> +
> +       stats = rtl8152_get_stats(netdev);
> +
> +       spin_lock_irqsave(&tp->rx_lock, lockflags);
> +       list_for_each_safe(cursor, next, &tp->rx_done) {
> +               list_del_init(cursor);
> +               spin_unlock_irqrestore(&tp->rx_lock, lockflags);
> +
> +               agg = list_entry(cursor, struct rx_agg, list);
> +               urb = agg->urb;
> +               if (urb->actual_length < ETH_ZLEN) {
> +                       ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
> +                       spin_lock_irqsave(&tp->rx_lock, lockflags);
> +                       if (ret && ret != -ENODEV) {
> +                               list_add_tail(&agg->list, next);
> +                               tasklet_schedule(&tp->tl);
> +                       }
> +                       continue;
> +               }
> +
> +               len_used = 0;
> +               rx_desc = agg->head;
> +               rx_data = agg->head;
> +               smp_wmb();
> +               pkt_len = le32_to_cpu(rx_desc->opts1) & RX_LEN_MASK;
> +               len_used += sizeof(struct rx_desc) + pkt_len;
> +
> +               while (urb->actual_length >= len_used) {
> +                       if (pkt_len < ETH_ZLEN)
> +                               break;
> +
> +                       pkt_len -= 4; /* CRC */
> +                       rx_data += sizeof(struct rx_desc);
> +
> +                       skb = netdev_alloc_skb_ip_align(netdev,
> pkt_len);
> +                       if (!skb) {
> +                               stats->rx_dropped++;
> +                               break;
> +                       }
> +                       memcpy(skb->data, rx_data, pkt_len);
> +                       skb_put(skb, pkt_len);
> +                       skb->protocol = eth_type_trans(skb, netdev);
> +                       netif_rx(skb);
> +                       stats->rx_packets++;
> +                       stats->rx_bytes += pkt_len;
> +
> +                       rx_data = rx_agg_align(rx_data + pkt_len + 4);
> +                       rx_desc = (struct rx_desc *)rx_data;
> +                       smp_wmb();

Against what is the memory barrier?

> +                       pkt_len = le32_to_cpu(rx_desc->opts1) &
> RX_LEN_MASK;
> +                       len_used = (int)(rx_data - (u8 *)agg->head);
> +                       len_used += sizeof(struct rx_desc) + pkt_len;
> +               }
> +
> +               ret = r8152_submit_rx(tp, agg, GFP_ATOMIC);
> +               spin_lock_irqsave(&tp->rx_lock, lockflags);
> +               if (ret && ret != -ENODEV) {
> +                       list_add_tail(&agg->list, next);
> +                       tasklet_schedule(&tp->tl);
> +               }
> +       }
> +       spin_unlock_irqrestore(&tp->rx_lock, lockflags);
> +}



