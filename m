Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761026Ab3DCCZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 22:25:28 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46464 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760547Ab3DCCZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 22:25:26 -0400
X-Sasl-enc: uOQxfbGgDJgG/z6BNFCdqIxP7R+NG0IslGBIXF1Z3kW5 1364955925
Message-ID: <515B9318.8090101@signal11.us>
Date: Tue, 02 Apr 2013 22:25:28 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: werner@almesberger.net, netdev@vger.kernel.org,
        linux-zigbee-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Linux-zigbee-devel] [PATCH 1/6] mac802154: Immediately retry
 sending failed packets
References: <515B84EB.8020006@signal11.us> <20130402.215625.1555279506975246223.davem@davemloft.net> <515B8D09.9050304@signal11.us> <20130402.220315.1782012687105065631.davem@davemloft.net>
In-Reply-To: <20130402.220315.1782012687105065631.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 10:03 PM, David Miller wrote:
> From: Alan Ott <alan@signal11.us>
> Date: Tue, 02 Apr 2013 21:59:37 -0400
>
>> On 04/02/2013 09:56 PM, David Miller wrote:
>>> From: Alan Ott <alan@signal11.us>
>>> Date: Tue, 02 Apr 2013 21:24:59 -0400
>>>
>>>> I like it for a couple of reasons.
>>>> 1. Most supported devices have only single packet output buffer, so
>>>> blocking in the driver is the most straight-forward way to handle it.
>>>> The alternative is to make each driver have a workqueue for xmit() (to
>>>> lift the blocking out from atomic context). This makes each driver simpler.
>>>>
>>>> 2. All of the flow control can be handled one time in the mac802154 layer.
>>> We have a perfectly working flow control mechanism in the generic
>>> networking queuing layer.  Please use it instead of inventing things.
>> I'm pretty sure that's what I'm doing in [1]. When I say "flow control
>> can be handled," I mean managing calls to netif_stop_queue() and
>> netif_wake_queue(). Is there something else I should be doing instead?
> Then you shouldn't need workqueues if the generic netdev facilities
> can do the flow control properly.

The workqueue in mac802154 is only needed because the current mac802154
xmit() function is designed to be blocking and synchronous.

Prior to my patch (#3/6), that very same workqueue would actually queue
up packets (without bound). That's what my patch fixes.

The workqueue in mac802154 also serializes the access to the device for
other functions like setting the channel, ensuring that in the driver
code, one doesn't have to mutex everything. I'm not sure if that's the
"right" way to do it, but that's the way it was when I got here.

> There are several ethernet devices that have a single transmit buffer
> and function just fine, and optimally, solely using the transmit queue
> stop/start/wake infrastructure.

Yes, that does work. enc28j60 works like this. However, since it's an
SPI device (and can sleep), its ndo_start_xmit() _does_ use a workqueue
(to remove it from atomic context), the same as ours (mac802154) does.
The difference is that we do it at the mac802154 layer, while Ethernet
devices do it in the driver.

I guess one advantage to the way it currently is in mac802154, with the
synchronous xmit(), is that a return code can be had from the driver for
each packet. With my new idea that we don't need to retransmit on
failure, I'm not sure we need this return code at all.

Alan.

