Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbaA0K3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 05:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610AbaA0K3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 05:29:18 -0500
Message-ID: <52E634DA.3040200@redhat.com>
Date: Mon, 27 Jan 2014 18:28:42 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: David Miller <davem@davemloft.net>, kys@microsoft.com,
        haiyangz@microsoft.com, devel@linuxdriverproject.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: hyperv: initialize link status correctly
References: <1390807854-4469-1-git-send-email-jasowang@redhat.com>	 <20140127.003559.2290408024387922847.davem@davemloft.net>	 <52E629A8.5010302@redhat.com> <1390818121.2735.130.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1390818121.2735.130.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2014 06:22 PM, Ben Hutchings wrote:
> On Mon, 2014-01-27 at 17:40 +0800, Jason Wang wrote:
>> On 01/27/2014 04:35 PM, David Miller wrote:
>>> From: Jason Wang <jasowang@redhat.com>
>>> Date: Mon, 27 Jan 2014 15:30:54 +0800
>>>
>>>> Call netif_carrier_on() after register_device(). Otherwise it won't work since
>>>> the device was still in NETREG_UNINITIALIZED state.
>>>>
>>>> Fixes a68f9614614749727286f675d15f1e09d13cb54a
>>>> (hyperv: Fix race between probe and open calls)
>>>>
>>>> Cc: Haiyang Zhang <haiyangz@microsoft.com>
>>>> Cc: K. Y. Srinivasan <kys@microsoft.com>
>>>> Reported-by: Di Nie <dnie@redhat.com>
>>>> Tested-by: Di Nie <dnie@redhat.com>
>>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>>> A device up can occur at the moment you call register_netdevice(),
>>> therefore that up call can see the carrier as down and fail or
>>> similar.  So you really cannot resolve the carrier to be on in this
>>> way.
>> True, we need a workqueue to synchronize them.
> Whatever for?  All you need to do is:
>
> 	rtnl_lock();
> 	register_netdevice();
> 	netif_carrier_on();
> 	rtnl_unlock();
>
> It would be nice if we could make the current code work with a change in
> the core, though.
>
> Ben.
>

Looks like the link status interrupt may happen during this (after
netvsc_device_add() was called by rndis_filter_device_add()) without any
synchronization. This may lead a wrong link status here.
