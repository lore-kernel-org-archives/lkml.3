Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbaCEBbn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:31:43 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:64165 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753904AbaCEBbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:31:42 -0500
Message-ID: <53167E62.4020601@huawei.com>
Date: Wed, 5 Mar 2014 09:31:14 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>,
        John Fastabend <john.r.fastabend@intel.com>
CC: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net RESEND] vlan: don't allow to add VLAN on VLAN device
References: <530FF7BF.4030706@huawei.com> <53100677.2060705@intel.com> <1393978247.16256.27.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1393978247.16256.27.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/3/5 8:10, Ben Hutchings wrote:
> On Thu, 2014-02-27 at 19:45 -0800, John Fastabend wrote:
>> On 2/27/2014 6:43 PM, Ding Tianhong wrote:
>>> I run these steps:
>>>
>>> modprobe 8021q
>>> vconfig add eth2 20
>>> vconfig add eth2.20 20
>>> ifconfig eth2 xx.xx.xx.xx
>>>
>>> then the Call Trace happened:
>>>
>>
>> [...]
>>
>>> ========================================================================
>>>
>>> The reason is that if add vlan on vlan dev, the vlan dev will create vlan_info,
>>> then the notification will let the real dev to run dev_set_rx_mode() and hold
>>> netif_addr_lock, and then the real dev will call ndo_set_rx_mode(), if the real
>>> dev is vlan dev, the ndo_set_rx_mode() will hold netif_addr_lock again, so deadlock
>>> happened.
>>>
>>> Don't allow to add vlan on vlan dev to fix this problem.
>>>
>>> Signed-off-by: Ding Tianhong <dingtianhong@huawei.com>
>>> ---
>>
>> I'm not sure we can just disable stacked vlans. There might be something
>> using them today and they have worked in the past. Lets try to find a
>> better fix.
> 
> I don't think there's any deadlock possible here.  We try to acquire the
> addr_list_lock for eth2.20, then the addr_list_lock for eth2.  We never
> try to acquire them in the opposite order.  The fix would involve
> telling lockdep about lock ordering between stacked net_devices (I have
> no idea how that's done).
> 
> Ben.
> 

Yep, it is a warning when the lockdep is open, I review the code again, and the deadlock would not happen,
just the same class of locks twice, so I think it is not a bugfix, just like a optimization.

Regards
Ding


