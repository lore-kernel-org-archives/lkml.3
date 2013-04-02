Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761656Ab3DBV20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 17:28:26 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:50264 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759605Ab3DBV2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 17:28:24 -0400
X-Sasl-enc: cs5noqclMPct58sMK1AcDwA5B+6FxmodpgKdCud+DHqC 1364938103
Message-ID: <515B4D79.40805@signal11.us>
Date: Tue, 02 Apr 2013 17:28:25 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>
CC: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-zigbee-devel <linux-zigbee-devel@lists.sourceforge.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] mac802154: Immediately retry sending failed packets
References: <1364928481-1813-1-git-send-email-alan@signal11.us> <1364928481-1813-2-git-send-email-alan@signal11.us> <CAJmB2rCr5ds11+iN=W5GCKsUgdfb57uKg+mH4NY4CWw6EFCTbg@mail.gmail.com> <515B3F78.2020301@signal11.us>
In-Reply-To: <515B3F78.2020301@signal11.us>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 04:28 PM, Alan Ott wrote:
> On 04/02/2013 03:11 PM, Alexander Smirnov wrote:
>> 2013/4/2 Alan Ott <alan@signal11.us <mailto:alan@signal11.us>>
>>
>>     When ops->xmit() fails, immediately retry. Previously the packet was
>>     sent
>>     to the back of the workqueue.
>>
>>     Signed-off-by: Alan Ott <alan@signal11.us <mailto:alan@signal11.us>>
>>     ---
>>      net/mac802154/tx.c | 17 ++++++++---------
>>      1 file changed, 8 insertions(+), 9 deletions(-)
>>
>>     diff --git a/net/mac802154/tx.c b/net/mac802154/tx.c
>>     index 4e09d07..fbf937c 100644
>>     --- a/net/mac802154/tx.c
>>     +++ b/net/mac802154/tx.c
>>     @@ -59,19 +59,18 @@ static void mac802154_xmit_worker(struct
>>     work_struct *work)
>>                     }
>>             }
>>
>>     -       res = xw->priv->ops->xmit(&xw->priv->hw, xw->skb);
>>     +       do {
>>     +               res = xw->priv->ops->xmit(&xw->priv->hw, xw->skb);
>>     +               if (res && ++xw->xmit_attempts >=
>>     MAC802154_MAX_XMIT_ATTEMPTS) {
>>     +                       pr_debug("transmission failed for %d times",
>>     +                                MAC802154_MAX_XMIT_ATTEMPTS);
>>     +                       break;
>>     +               }
>>     +       } while (res);
>>
>>  
>>
>> IIRC this 802.15.4 stack uses single-thread-work-queue and all RX/TX
>> are performed by using it.
> Hi Alexander,
>
> Yes, that is true. As is currently implemented, the driver xmit()
> functions are called from a workqueue and block until the packet is sent.
>
>
>> Doing TX retry in the way you proposed -
>> it's possible that you will block other packets pending in this
>> queue.
> Yes. Since sending data is a blocking operation, any time spent sending
> (or re-sending) is blocking.
>
> As it was before this patch series, with the buffer (workqueue) growing
> arbitrarily large, doing retry by putting a packet at the end of the
> workqueue was largely useless because by the time it came to retry it,
> any state associated with it (with respect to fragmentation/reassembly)
> had expired.
>
> Keep in mind that with the netif stop/wake code, putting retries at the
> end of the workqueue or doing them immediately is basically the same
> thing, since the workqueue is no longer the packet queue (and will
> ideally only have 0 or 1 packets in it). The workqueue (with these
> patches) only serves to lift the driver xmit() calls out of atomic
> context, allowing them to block.
>
> However, it is easy to envision one process clogging up the works with
> retries by sending many packets to an unavailable address.
>
> What do you recommend doing here instead?

According to 7.5.6.5 of IEEE 802.15.4-2003, if the retransmission fails
more than aMaxFrameRetries (3) times, it is assumed that it has failed.
Since some transceivers (and I would assume most if not all) do this in
hardware, it's now my opinion that we should _not_ try to retransmit at
all in mac802154/tx.c.

For a driver for a device which _doesn't_ do retransmission in hardware,
maybe it should be handled by that driver then.

>
>> Despite on Linux is already 'slow' system to provide
>> real-time for specific 802.15.4 features, I think it's not a good
>> idea to increase nodes communication latency.
> With the transmit buffer length increased (and actually being used),
> maybe the packets with realtime requirements can be given a higher
> priority to deal with these requirements.
>
> Alan.
>
>>
>>      out:
>>             mutex_unlock(&xw->priv->phy->pib_lock);
>>
>>     -       if (res) {
>>     -               if (xw->xmit_attempts++ < MAC802154_MAX_XMIT_ATTEMPTS) {
>>     -                       queue_work(xw->priv->dev_workqueue, &xw->work);
>>     -                       return;
>>     -               } else
>>     -                       pr_debug("transmission failed for %d times",
>>     -                                MAC802154_MAX_XMIT_ATTEMPTS);
>>     -       }
>>
>>             dev_kfree_skb(xw->skb);
>>
>>     --
>>     1.7.11.2
>>
>>

