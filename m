Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751391AbaDYVEq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:04:46 -0400
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:44250 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750971AbaDYVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:04:44 -0400
MIME-Version: 1.0
In-Reply-To: <1398431623.3010.76.camel@deneb.redhat.com>
References: <1397702368-4846-1-git-send-email-isubramanian@apm.com>
	<1397702368-4846-5-git-send-email-isubramanian@apm.com>
	<1398431623.3010.76.camel@deneb.redhat.com>
Date: Fri, 25 Apr 2014 14:04:41 -0700
Message-ID: <CAKh23Fn2LvhNt_ZMQcDwu3W5Gw_ZJ1NUAcjDexDCKtkR1Ww-YQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] drivers: net: Add APM X-Gene SoC ethernet driver support.
From: Iyappan Subramanian <isubramanian@apm.com>
To: Mark Salter <msalter@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "jcm@redhat.com" <jcm@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, patches <patches@apm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Keyur Chudgar <kchudgar@apm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ravi Patel <rapatel@apm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 6:13 AM, Mark Salter <msalter@redhat.com> wrote:
> On Wed, 2014-04-16 at 19:39 -0700, Iyappan Subramanian wrote:
>> +static int xgene_enet_refill_bufpool(struct xgene_enet_desc_ring *buf_pool,
>> +                                    u32 nbuf)
>> +{
>> +       struct sk_buff *skb;
>> +       struct xgene_enet_desc16 *desc;
>> +       struct net_device *ndev;
>> +       struct device *dev;
>> +       dma_addr_t dma_addr;
>> +       u32 tail = buf_pool->tail;
>> +       u32 slots = buf_pool->slots - 1;
>> +       int i, ret = 0;
>> +       u16 bufdatalen = BUF_LEN_CODE_2K | (SKB_BUFFER_SIZE & GENMASK(11, 0));
>> +
>> +       ndev = buf_pool->ndev;
>> +       dev = ndev_to_dev(buf_pool->ndev);
>> +
>> +       for (i = 0; i < nbuf; i++) {
>> +               desc = &buf_pool->desc16[tail];
>> +
>> +               skb = netdev_alloc_skb_ip_align(ndev, XGENE_ENET_MAX_MTU);
>> +               if (unlikely(!skb)) {
>> +                       netdev_err(ndev, "Could not allocate skb");
>> +                       ret = -ENOMEM;
>> +                       goto out;
>> +               }
>> +               buf_pool->rx_skb[tail] = skb;
>> +
>> +               dma_addr = dma_map_single(dev, skb->data, skb->len,
>> +                                         DMA_TO_DEVICE);
>
> Shouldn't this be:
>
>                dma_addr = dma_map_single(dev, skb->data, XGENE_ENET_MAX_MTU,
>                                          DMA_TO_DEVICE);
>
> You just allocated the skb and nothing is in it, so ->len is zero.

Thanks Mark.  I will fix the code.

>
>> +
>> +static int xgene_enet_rx_frame(struct xgene_enet_desc_ring *rx_ring,
>> +                               struct xgene_enet_desc *desc)
>> +{
>> +       struct net_device *ndev = rx_ring->ndev;
>> +       struct device *dev = ndev_to_dev(rx_ring->ndev);
>> +       struct xgene_enet_desc_ring *buf_pool = rx_ring->buf_pool;
>> +       u32 datalen, skb_index;
>> +       struct sk_buff *skb;
>> +       dma_addr_t pa;
>> +       size_t len;
>> +       int ret = 0;
>> +
>> +       skb_index = get_desc(desc, USERINFO);
>> +       skb = buf_pool->rx_skb[skb_index];
>> +       prefetch(skb->data - NET_IP_ALIGN);
>> +
>> +       /* Strip off CRC as HW isn't doing this */
>> +       datalen = get_desc(desc, BUFDATALEN);
>> +       datalen -= 4;
>> +       skb_put(skb, datalen);
>> +
>> +       pa = (dma_addr_t)get_desc(desc, DATAADDR);
>> +       len = get_desc(desc, BUFDATALEN);
>> +       dma_unmap_single(dev, pa, len, DMA_TO_DEVICE);
>> +
>
> And here, should be:
>
>         dma_unmap_single(dev, pa, XGENE_ENET_MAX_MTU, DMA_TO_DEVICE);
>
> You want to unmap the whole buffer, not just the part actually used.
>
> The underlying code works with pages, so the existing code may work by
> chance, but you get err_printks is you turn on dma debug.

I will fix the code.  DMA_API_DEBUG option is very handy.  Thanks.

>
> --Mark
>
>
