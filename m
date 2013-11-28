Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab3K1Rhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 12:37:36 -0500
Received: from smtp.citrix.com ([66.165.176.89]:38034 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759118Ab3K1Rhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 12:37:35 -0500
X-IronPort-AV: E=Sophos;i="4.93,792,1378857600"; 
   d="scan'208";a="79033343"
Message-ID: <52977F5C.7090703@citrix.com>
Date: Thu, 28 Nov 2013 17:37:32 +0000
From: Zoltan Kiss <zoltan.kiss@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: <wei.liu2@citrix.com>, <xen-devel@lists.xenproject.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <jonathan.davies@citrix.com>
Subject: Re: [PATCH net-next RFC 0/5] xen-netback: TX grant mapping instead
 of copy
References: <1383094220-14775-1-git-send-email-zoltan.kiss@citrix.com>	 <1383303035.672.29.camel@kazak.uk.xensource.com>	 <5273FA37.6020903@citrix.com> <1383821563.26213.168.camel@kazak.uk.xensource.com>
In-Reply-To: <1383821563.26213.168.camel@kazak.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/13 10:52, Ian Campbell wrote:
> On Fri, 2013-11-01 at 19:00 +0000, Zoltan Kiss wrote:
>> On 01/11/13 10:50, Ian Campbell wrote:
>>> Does this always avoid copying when bridging/openvswitching/forwarding
>>> (e.g. masquerading etc)? For both domU->domU and domU->physical NIC?
>> I've tested the domU->domU, domU->physical with bridge and openvswitch
>> usecase, and now I've created a new stat counter to see how often copy
>> happens (the callback's second parameter tells you whether the skb was
>> freed or copied). It doesn't do copy in all of these scenarios.
>> What do you mean by forwarding? The scenario when you use bridge and
>> iptables mangling with the packet, not just filtering?
>
> I mean using L3 routing rather L2 bridging. Which might involve
> NAT/MASQUERADE or might just be normal IP routing.
I still couldn't find time to try out this scenario, but I think in this 
case packet goes through deliver_skb, which means it will get copied. So 
performance would be a bit worse due to the extra map/unmap. And I'm 
afraid we can't help that too much due to this:
https://lkml.org/lkml/2012/7/20/363
However I think using Dom0 as a router/firewall is already a suboptimal 
solution, so maybe a small performance regression is acceptable?
Anyway, I will try this out, and see if it really copies everything, and 
get some numbers as well.

>>> How does it deal with broadcast traffic?
Now I had time to check it: broadcast packets get copied only once, when 
cloning happens. It will swap out the frags with local ones, so any 
subsequent cloning will have a local SKB.

Zoli
