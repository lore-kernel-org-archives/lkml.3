Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3LSRqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 12:46:25 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:11232 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LSRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 12:46:24 -0500
Message-ID: <1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
From: Ben Hutchings <bhutchings@solarflare.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
CC: <davem@davemloft.net>, <netdev@vger.kernel.org>, <kys@microsoft.com>,
        <olaf@aepfle.de>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        <driverdev-devel@linuxdriverproject.org>
Date: Thu, 19 Dec 2013 17:46:18 +0000
In-Reply-To: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20370.002
X-TM-AS-Result: No--11.349500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-18 at 14:21 -0800, Haiyang Zhang wrote:
> This feature allows multiple channels to be used by each virtual NIC.
> It is available on Hyper-V host 2012 R2.
[...]
> --- a/drivers/net/hyperv/netvsc.c
> +++ b/drivers/net/hyperv/netvsc.c
[...]
> @@ -525,15 +535,21 @@ int netvsc_send(struct hv_device *device,
>  	else
>  		req_id = 0;
>  
> +	if (packet->is_hash)
> +		out_channel = net_device->chn_table[net_device->send_table[
> +					packet->hash % VRSS_SEND_TAB_SIZE]];
> +	if (out_channel == NULL)
> +		out_channel = device->channel;
> +
>  	if (packet->page_buf_cnt) {
> -		ret = vmbus_sendpacket_pagebuffer(device->channel,
> +		ret = vmbus_sendpacket_pagebuffer(out_channel,
>  						  packet->page_buf,
>  						  packet->page_buf_cnt,
>  						  &sendMessage,
>  						  sizeof(struct nvsp_message),
>  						  req_id);
>  	} else {
> -		ret = vmbus_sendpacket(device->channel, &sendMessage,
> +		ret = vmbus_sendpacket(out_channel, &sendMessage,
>  				sizeof(struct nvsp_message),
>  				req_id,
>  				VM_PKT_DATA_INBAND,
> @@ -544,15 +560,15 @@ int netvsc_send(struct hv_device *device,
>  		atomic_inc(&net_device->num_outstanding_sends);
>  		if (hv_ringbuf_avail_percent(&device->channel->outbound) <
>  			RING_AVAIL_PERCENT_LOWATER) {
> -			netif_stop_queue(ndev);
> +			netif_tx_stop_all_queues(ndev);
>  			if (atomic_read(&net_device->
>  				num_outstanding_sends) < 1)
> -				netif_wake_queue(ndev);
> +				netif_tx_wake_all_queues(ndev);
>  		}
>  	} else if (ret == -EAGAIN) {
> -		netif_stop_queue(ndev);
> +		netif_tx_stop_all_queues(ndev);
>  		if (atomic_read(&net_device->num_outstanding_sends) < 1) {
> -			netif_wake_queue(ndev);
> +			netif_tx_wake_all_queues(ndev);
>  			ret = -ENOSPC;
>  		}
>  	} else {

This doesn't makes any sense to me.  How can you safely share the same
channels between all TX queues?

I think you need to associate TX queues and channels 1-1.  If you are
required to map packets to TX queues using the Toeplitz hash, you should
implement ndo_select_queue and do the mapping there.  Then in
netvsc_send() you would use the queue number from the skb to find which
channel to use and which queue may need to be stopped/woken.

[...]
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
[...]
> +/* Toeplitz hash function
> + * data: network byte order
> + * return: host byte order
> + */
> +static u32 comp_hash(u8 *key, int klen, u8 *data, int dlen)
> +{
> +	union sub_key subk;
> +	int k_next = 4;
> +	u8 dt;
> +	int i, j;
> +	u32 ret = 0;
> +
> +	subk.k = 0;
> +	subk.ka = ntohl(*(u32 *)key);
> +
> +	for (i = 0; i < dlen; i++) {
> +		subk.kb = key[k_next];
> +		k_next = (k_next + 1) % klen;
> +		dt = data[i];
> +		for (j = 0; j < 8; j++) {
> +			if (dt & 0x80)
> +				ret ^= subk.ka;
> +			dt <<= 1;
> +			subk.k <<= 1;
> +		}
> +	}
> +
> +	return ret;
> +}

This looks incredibly slow.  I've seen software implementations that are
likely to be more efficient, e.g.
<http://thread.gmane.org/gmane.linux.network/284612/>

[...]
> @@ -411,9 +483,11 @@ static int netvsc_probe(struct hv_device *dev,
>  	struct net_device *net = NULL;
>  	struct net_device_context *net_device_ctx;
>  	struct netvsc_device_info device_info;
> +	struct netvsc_device *nvdev;
>  	int ret;
>  
> -	net = alloc_etherdev(sizeof(struct net_device_context));
> +	net = alloc_etherdev_mq(sizeof(struct net_device_context),
> +				num_online_cpus());
>  	if (!net)
>  		return -ENOMEM;
>  
> @@ -435,6 +509,9 @@ static int netvsc_probe(struct hv_device *dev,
>  	SET_ETHTOOL_OPS(net, &ethtool_ops);
>  	SET_NETDEV_DEV(net, &dev->device);
>  
> +	netif_set_real_num_tx_queues(net, 1);
> +	netif_set_real_num_rx_queues(net, 1);
> +
>  	ret = register_netdev(net);
>  	if (ret != 0) {
>  		pr_err("Unable to register netdev.\n");
> @@ -453,6 +530,13 @@ static int netvsc_probe(struct hv_device *dev,
>  		return ret;
>  	}
>  	memcpy(net->dev_addr, device_info.mac_adr, ETH_ALEN);
> +	nvdev = hv_get_drvdata(dev);
> +	rtnl_lock();
> +	netif_set_real_num_tx_queues(net, nvdev->num_chn);
> +	netif_set_real_num_rx_queues(net, nvdev->num_chn);
[...]

These functions can fail if called after registering the net device, so
you should either call them with the final values earlier or handle
failure here.

Also, I notice that dev_addr is only set after registering; that should
be fixed.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

