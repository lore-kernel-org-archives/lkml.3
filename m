Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688Ab3KTDGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 22:06:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab3KTDF7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 22:05:59 -0500
Message-ID: <528C2700.1060808@redhat.com>
Date: Wed, 20 Nov 2013 11:05:36 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: rusty@rustcorp.com.au, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] virtio-net: fix page refcnt leaking when fail to
 allocate frag skb
References: <1384848307-7217-1-git-send-email-jasowang@redhat.com> <1384869828.8604.97.camel@edumazet-glaptop2.roam.corp.google.com> <20131119204909.GA15004@redhat.com>
In-Reply-To: <20131119204909.GA15004@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 04:49 AM, Michael S. Tsirkin wrote:
> On Tue, Nov 19, 2013 at 06:03:48AM -0800, Eric Dumazet wrote:
>> On Tue, 2013-11-19 at 16:05 +0800, Jason Wang wrote:
>>> We need to drop the refcnt of page when we fail to allocate an skb for frag
>>> list, otherwise it will be leaked. The bug was introduced by commit
>>> 2613af0ed18a11d5c566a81f9a6510b73180660a ("virtio_net: migrate mergeable rx
>>> buffers to page frag allocators").
>>>
>>> Cc: Michael Dalton <mwdalton@google.com>
>>> Cc: Eric Dumazet <edumazet@google.com>
>>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>>> Cc: Michael S. Tsirkin <mst@redhat.com>
>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>> ---
>>> The patch was needed for 3.12 stable.
>> Good catch, but if we return from receive_mergeable() in the 'middle'
>> of the frags we would need for the current skb, who will
>> call the virtqueue_get_buf() to flush the remaining frags ?
>>
>> Don't we also need to call virtqueue_get_buf() like 
>>
>> while (--num_buf) {
>>     buf = virtqueue_get_buf(rq->vq, &len);
>>     if (!buf)
>>         break;
>>     put_page(virt_to_head_page(buf));
>> }
>>
>> ?
>>
>>
>
> Let me explain what worries me in your suggestion:
>
>                         struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
>                         if (unlikely(!nskb)) {
>                                 head_skb->dev->stats.rx_dropped++;
>                                 return -ENOMEM;
>                         }
>
> is this the failure case we are talking about?
>
> I think this is a symprom of a larger problem
> introduced by 2613af0ed18a11d5c566a81f9a6510b73180660a,
> namely that we now need to allocate memory in the
> middle of processing a packet.
>
>
> I think discarding a completely valid and well-formed
> packet from the receive queue because we are unable
> to allocate new memory with GFP_ATOMIC
> for future packets is not a good idea.
>
> It certainly violates the principle of least surprize:
> when one sees host pass packet to guest, one expects
> the packet to get into the networking stack, not get
> dropped by the driver internally.
> Guest stack can do with the packet what it sees fit.
>
> We actually wake up a thread if we can't fill up the queue,
> that will fill it up in GFP_KERNEL context.
>
> So I think we should find a way to pre-allocate if necessary and avoid
> error paths where allocating new memory is a required to avoid drops.
>

The problem happens only on memory pressure, this pre-allocation may add
more stress on this.
