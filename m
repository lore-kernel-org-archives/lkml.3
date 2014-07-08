Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaGHSjH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:39:07 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbaGHSjF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:39:05 -0400
Message-ID: <53BC3AC5.6000203@nod.at>
Date: Tue, 08 Jul 2014 20:39:01 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: KY Srinivasan <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>
CC: "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hyperv: Add netpoll support
References: <1404811947-5174-1-git-send-email-richard@nod.at> <9fb91c2ee32a4a59a2bec54043a6b9fd@BY2PR03MB299.namprd03.prod.outlook.com>
In-Reply-To: <9fb91c2ee32a4a59a2bec54043a6b9fd@BY2PR03MB299.namprd03.prod.outlook.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 08.07.2014 20:01, schrieb KY Srinivasan:
> 
> 
>> -----Original Message-----
>> From: Richard Weinberger [mailto:richard@nod.at]
>> Sent: Tuesday, July 8, 2014 2:32 AM
>> To: KY Srinivasan; Haiyang Zhang
>> Cc: devel@linuxdriverproject.org; netdev@vger.kernel.org; linux-
>> kernel@vger.kernel.org; Richard Weinberger
>> Subject: [PATCH] hyperv: Add netpoll support
>>
>> In order to have at least a netconsole to debug kernel issues on Windows
>> Azure this patch implements netpoll support.
>> Sending packets is easy, netvsc_start_xmit() does already everything
>> needed.
>> To receive we need to trigger the channel callback which is usally called via
>> tasklet_schedule().
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/net/hyperv/netvsc_drv.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/drivers/net/hyperv/netvsc_drv.c
>> b/drivers/net/hyperv/netvsc_drv.c index 4fd71b7..367b71e 100644
>> --- a/drivers/net/hyperv/netvsc_drv.c
>> +++ b/drivers/net/hyperv/netvsc_drv.c
>> @@ -736,6 +736,17 @@ static int netvsc_set_mac_addr(struct net_device
>> *ndev, void *p)
>>  	return err;
>>  }
>>
>> +#ifdef CONFIG_NET_POLL_CONTROLLER
>> +static void netvsc_poll_controller(struct net_device *net) {
>> +	struct net_device_context *net_device_ctx = netdev_priv(net);
>> +	struct hv_device *dev = net_device_ctx->device_ctx;
>> +
>> +	local_bh_disable();
>> +	netvsc_channel_cb(dev->channel);
>> +	local_bh_enable();
>> +}
>> +#endif
> 
> Each channel is bound to a specific VCPU in the guest and the channel callback is expected to be delivered on
> the VCPU the channel is bound to. This code is not satisfying that requirement.

But struct hv_device has only one channel attribute. How does this work with multiple VCPUs?

Anyways, what solution to you propose?

Thanks,
//richard
