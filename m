Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaCEF5o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:57:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaCEF5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:57:42 -0500
Message-ID: <5316BCC3.50408@redhat.com>
Date: Wed, 05 Mar 2014 13:57:23 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: Re: [PATCH net-next] hyperv: Move state setting for link query
References: <1393890875-1420-1-git-send-email-haiyangz@microsoft.com> <531543FD.7090907@redhat.com> <856c5dedc14a458b8100dcb2d3a2f9e6@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
In-Reply-To: <856c5dedc14a458b8100dcb2d3a2f9e6@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 12:57 AM, Haiyang Zhang wrote:
>
>> -----Original Message-----
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Monday, March 3, 2014 10:10 PM
>> To: Haiyang Zhang; davem@davemloft.net; netdev@vger.kernel.org
>> Cc: KY Srinivasan; olaf@aepfle.de; linux-kernel@vger.kernel.org; driverdev-
>> devel@linuxdriverproject.org
>> Subject: Re: [PATCH net-next] hyperv: Move state setting for link query
>>
>> On 03/04/2014 07:54 AM, Haiyang Zhang wrote:
>>> It moves the state setting for query into rndis_filter_receive_response().
>>> All callbacks including query-complete and status-callback are
>>> synchronized by channel->inbound_lock. This prevents pentential race
>> between them.
>>
>> This still looks racy to me. The problem is workqueue is not synchronized with
>> those here.
>>
>> Consider the following case in netvsc_link_change():
>>
>>     if (rdev->link_state) {
>>     ... receive interrupt ...
>>     rndis_filter_receice_response() which changes rdev->link_state
>>     ...
>>         netif_carrier_off()
>>     }
>>
>> And also it need to schedule a work otherwise the link status is out of sync.
> The rndis_filter_query_device_link_status() makes the query and wait for the
> complete message, including set state, before returning.
>
> The rndis_filter_query_device_link_status() is called from rndis_filter_device_add(),
> which is called from either netvsc_change_mtu() or netvsc_probe().
>
> The change_mtu() and netvsc_link_change() are synchronized by rtnl_lock().
> In netvsc_probe(), the status query & complete happens before register_netdev(), and
> the netvsc_linkstatus_callback() schedules the work only after netdevice is registered.
> So, there are no race in either case.
>
> The carrier_on/off work will be scheduled when netvsc_open() is called. Then,
> the status will be updated based on the latest link_state.
>
> Thanks,
> - Haiyang
>

I see. Then if the link status is changing during mtu changing in guest.
Looks like we may miss a link status updating?
