Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295AbaKSDJk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:09:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753943AbaKSDJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:09:39 -0500
Message-ID: <546C09ED.8000004@redhat.com>
Date: Wed, 19 Nov 2014 11:09:33 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Amos Kong <akong@redhat.com>
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH net-next] tun: return NET_XMIT_DROP for dropped packets
References: <1416288041-30921-1-git-send-email-jasowang@redhat.com> <20141118165359.GA18636@air.redhat.com>
In-Reply-To: <20141118165359.GA18636@air.redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2014 12:53 AM, Amos Kong wrote:
> On Tue, Nov 18, 2014 at 01:20:41PM +0800, Jason Wang wrote:
>> After commit 5d097109257c03a71845729f8db6b5770c4bbedc
>> ("tun: only queue packets on device"), NETDEV_TX_OK was returned for
>> dropped packets. This will confuse pktgen since dropped packets were
>> counted as sent ones.
>>
>> Fixing this by returning NET_XMIT_DROP to let pktgen count it as error
>> packet.
>>
>> Cc: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> ---
>>  drivers/net/tun.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
>> index e3fa65a..ac53a73 100644
>> --- a/drivers/net/tun.c
>> +++ b/drivers/net/tun.c
>> @@ -819,7 +819,7 @@ drop:
>>  	skb_tx_error(skb);
>>  	kfree_skb(skb);
>>  	rcu_read_unlock();
>> -	return NETDEV_TX_OK;
>> +	return NET_XMIT_DROP;
> Quoted from linux/drivers/firewire/net.c:
>
>   /*
>    * FIXME: According to a patch from 2003-02-26, "returning non-zero
>    * causes serious problems" here, allegedly.  Before that patch,
>    * -ERRNO was returned which is not appropriate under Linux 2.6.
>    * Perhaps more needs to be done?  Stop the queue in serious
>    * conditions and restart it elsewhere?
>    */
>
> I saw many drivers return NETDEV_TX_OK in xmit for drop packets, eg: virtio_net.c

Well, I think you miss some thing:

- Virtio-net only drop packets when there's a bug in either driver or
hypervisor. Other drivers only drop the bad packets. For pktgen, we can
make sure the packet is good.
- Most of the drivers (included virtio-net but not tun) will stop txq
before the ring is full, this could be detected by pktgen
- Tun keep accepting packets and dropping them even if the socket
receive queue is full.

So we really need NET_XMIT_DROP here to let pktgen know the packets were
not sent correctly.
