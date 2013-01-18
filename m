Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324Ab3ARHQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:16:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab3ARHQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:16:19 -0500
Message-ID: <50F8EE40.6010002@redhat.com>
Date: Fri, 18 Jan 2013 14:40:00 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: gaowanlong@cn.fujitsu.com
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eric Dumazet <erdnetdev@gmail.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: Re: [PATCH V5 1/2] virtio-net: fix the set affinity bug when CPU
 IDs are not consecutive
References: <1358487121-7956-1-git-send-email-gaowanlong@cn.fujitsu.com> <50F8E93B.4090004@redhat.com> <50F8EAD2.3040606@cn.fujitsu.com>
In-Reply-To: <50F8EAD2.3040606@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 02:25 PM, Wanlong Gao wrote:
> On 01/18/2013 02:18 PM, Jason Wang wrote:
>> On 01/18/2013 01:32 PM, Wanlong Gao wrote:
>>> As Michael mentioned, set affinity and select queue will not work very
>>> well when CPU IDs are not consecutive, this can happen with hot unplug.
>>> Fix this bug by traversal the online CPUs, and create a per cpu variable
>>> to find the mapping from CPU to the preferable virtual-queue.
>>>
>>> Cc: Rusty Russell <rusty@rustcorp.com.au>
>>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>>> Cc: Jason Wang <jasowang@redhat.com>
>>> Cc: Eric Dumazet <erdnetdev@gmail.com>
>>> Cc: virtualization@lists.linux-foundation.org
>>> Cc: netdev@vger.kernel.org
>>> Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
>>> ---
>>> V4->V5:
>>> 	Add get/put_online_cpus to avoid CPUs go up and down during operations (Rusty)
>>>
>>> V3->V4:
>>> 	move vq_index into virtnet_info	(Jason)
>>> 	change the mapping value when not setting affinity (Jason)
>>> 	address the comments about select_queue (Rusty)
>>>
>>>  drivers/net/virtio_net.c | 60 +++++++++++++++++++++++++++++++++++++++---------
>>>  1 file changed, 49 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
>>> index a6fcf15..440b0eb 100644
>>> --- a/drivers/net/virtio_net.c
>>> +++ b/drivers/net/virtio_net.c
>>> @@ -123,6 +123,9 @@ struct virtnet_info {
>>>  
>>>  	/* Does the affinity hint is set for virtqueues? */
>>>  	bool affinity_hint_set;
>>> +
>>> +	/* Per-cpu variable to show the mapping from CPU to virtqueue */
>>> +	int __percpu *vq_index;
>>>  };
>>>  
>>>  struct skb_vnet_hdr {
>>> @@ -1016,6 +1019,7 @@ static int virtnet_vlan_rx_kill_vid(struct net_device *dev, u16 vid)
>>>  static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
>>>  {
>>>  	int i;
>>> +	int cpu;
>>>  
>>>  	/* In multiqueue mode, when the number of cpu is equal to the number of
>>>  	 * queue pairs, we let the queue pairs to be private to one cpu by
>>> @@ -1029,16 +1033,29 @@ static void virtnet_set_affinity(struct virtnet_info *vi, bool set)
>>>  			return;
>>>  	}
>>>  
>>> -	for (i = 0; i < vi->max_queue_pairs; i++) {
>>> -		int cpu = set ? i : -1;
>>> -		virtqueue_set_affinity(vi->rq[i].vq, cpu);
>>> -		virtqueue_set_affinity(vi->sq[i].vq, cpu);
>>> -	}
>>> +	if (set) {
>>> +		i = 0;
>>> +		for_each_online_cpu(cpu) {
>>> +			virtqueue_set_affinity(vi->rq[i].vq, cpu);
>>> +			virtqueue_set_affinity(vi->sq[i].vq, cpu);
>>> +			*per_cpu_ptr(vi->vq_index, cpu) = i;
>>> +			i++;
>>> +		}
>>>  
>>> -	if (set)
>>>  		vi->affinity_hint_set = true;
>>> -	else
>>> +	} else {
>>> +		for(i = 0; i < vi->max_queue_pairs; i++) {
>>> +			virtqueue_set_affinity(vi->rq[i].vq, -1);
>>> +			virtqueue_set_affinity(vi->sq[i].vq, -1);
>>> +		}
>>> +
>>> +		i = 0;
>>> +		for_each_online_cpu(cpu)
>>> +			*per_cpu_ptr(vi->vq_index, cpu) =
>>> +				++i % vi->curr_queue_pairs;
>>> +
>>>  		vi->affinity_hint_set = false;
>>> +	}
>>>  }
>>>  
>>>  static void virtnet_get_ringparam(struct net_device *dev,
>>> @@ -1087,7 +1104,9 @@ static int virtnet_set_channels(struct net_device *dev,
>>>  		netif_set_real_num_tx_queues(dev, queue_pairs);
>>>  		netif_set_real_num_rx_queues(dev, queue_pairs);
>>>  
>>> +		get_online_cpus();
>>>  		virtnet_set_affinity(vi, true);
>>> +		put_online_cpus();
>>>  	}
>>>  
>>>  	return err;
>>> @@ -1127,12 +1146,19 @@ static int virtnet_change_mtu(struct net_device *dev, int new_mtu)
>>>  
>>>  /* To avoid contending a lock hold by a vcpu who would exit to host, select the
>>>   * txq based on the processor id.
>>> - * TODO: handle cpu hotplug.
>>>   */
>>>  static u16 virtnet_select_queue(struct net_device *dev, struct sk_buff *skb)
>>>  {
>>> -	int txq = skb_rx_queue_recorded(skb) ? skb_get_rx_queue(skb) :
>>> -		  smp_processor_id();
>>> +	int txq;
>>> +	struct virtnet_info *vi = netdev_priv(dev);
>>> +
>>> +	if (skb_rx_queue_recorded(skb)) {
>>> +		txq = skb_get_rx_queue(skb);
>>> +	} else {
>>> +		txq = *__this_cpu_ptr(vi->vq_index);
>>> +		if (txq == -1)
>>> +			txq = 0;
>>> +	}
>>>  
>>>  	while (unlikely(txq >= dev->real_num_tx_queues))
>>>  		txq -= dev->real_num_tx_queues;
>>> @@ -1248,7 +1274,9 @@ static void virtnet_del_vqs(struct virtnet_info *vi)
>>>  {
>>>  	struct virtio_device *vdev = vi->vdev;
>>>  
>>> +	get_online_cpus();
>>>  	virtnet_set_affinity(vi, false);
>>> +	put_online_cpus();
>> I think the {get|put}_online_cpus() is not necessary here when we are
>> cleaning.
> When cleaning, we also set the per-cpu variable, is avoiding hot plug
> or unplug unnecessary?

We del vqs when:

1) fail to probe the device
2) device removal
3) freeze before suspend

In both cases, the device has been stopped. And in 1 and 2 we are about
to free the device, the per-cpu won't be used any more. For 3, we will
re-initialize the virtqueues during restoring which will call
virtnet_set_affinity() which has been protected by
{get|put}_online_cpus() below.

So looks we could safely remove this.

Thanks

>
> Thanks,
> Wanlong Gao
>
>>>  
>>>  	vdev->config->del_vqs(vdev);
>>>  
>>> @@ -1371,7 +1399,10 @@ static int init_vqs(struct virtnet_info *vi)
>>>  	if (ret)
>>>  		goto err_free;
>>>  
>>> +	get_online_cpus();
>>>  	virtnet_set_affinity(vi, true);
>>> +	put_online_cpus();
>>> +
>>>  	return 0;
>>>  
>>>  err_free:
>>> @@ -1453,6 +1484,10 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>  	if (vi->stats == NULL)
>>>  		goto free;
>>>  
>>> +	vi->vq_index = alloc_percpu(int);
>>> +	if (vi->vq_index == NULL)
>>> +		goto free_stats;
>>> +
>>>  	mutex_init(&vi->config_lock);
>>>  	vi->config_enable = true;
>>>  	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
>>> @@ -1476,7 +1511,7 @@ static int virtnet_probe(struct virtio_device *vdev)
>>>  	/* Allocate/initialize the rx/tx queues, and invoke find_vqs */
>>>  	err = init_vqs(vi);
>>>  	if (err)
>>> -		goto free_stats;
>>> +		goto free_index;
>>>  
>>>  	netif_set_real_num_tx_queues(dev, 1);
>>>  	netif_set_real_num_rx_queues(dev, 1);
>>> @@ -1520,6 +1555,8 @@ free_recv_bufs:
>>>  free_vqs:
>>>  	cancel_delayed_work_sync(&vi->refill);
>>>  	virtnet_del_vqs(vi);
>>> +free_index:
>>> +	free_percpu(vi->vq_index);
>>>  free_stats:
>>>  	free_percpu(vi->stats);
>>>  free:
>>> @@ -1554,6 +1591,7 @@ static void virtnet_remove(struct virtio_device *vdev)
>>>  
>>>  	flush_work(&vi->config_work);
>>>  
>>> +	free_percpu(vi->vq_index);
>>>  	free_percpu(vi->stats);
>>>  	free_netdev(vi->dev);
>>>  }
>>

