Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaC0CM3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 22:12:29 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:49053 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaC0CM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 22:12:28 -0400
Message-ID: <53338C3B.5000300@oracle.com>
Date: Thu, 27 Mar 2014 10:26:03 +0800
From: "zheng.li" <zheng.x.li@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: fubar@us.ibm.com
CC: Ding Tianhong <dingtianhong@huawei.com>, netdev@vger.kernel.org,
        andy@greyhouse.net, linux-kernel@vger.kernel.org, davem@davemloft.net,
        joe.jin@oracle.com
Subject: Re: [PATCH] bonding: Inactive slaves should keep inactive flag's
 value to 1 in tlb and alb mode.
References: <1395716407-31601-1-git-send-email-zheng.x.li@oracle.com> <5330FB34.4090005@huawei.com> <53314017.8040104@oracle.com> <533224FA.6040307@huawei.com>
In-Reply-To: <533224FA.6040307@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jay,
What's your opinion about the new patch.

Thanks,
Zheng Li

于 2014年03月26日 08:53, Ding Tianhong 写道:
> On 2014/3/25 16:36, zheng.li wrote:
>> 于 2014年03月25日 11:42, Ding Tianhong 写道:
>>> On 2014/3/25 11:00, Zheng Li wrote:
>>>> In bond mode tlb and alb, inactive slaves should keep inactive flag to
>>>> 1 to refuse to receive broadcast packets. Now, active slave send broadcast packets
>>>> (for example ARP requests) which will arrive inactive slaves on same host from switch,
>>>> but inactive slave's inactive flag is zero that cause bridge receive the broadcast
>>>> packets to produce a wrong entry in forward table. Typical situation is domu send some
>>>> ARP request which go out from dom0 bond's active slave, then the ARP broadcast request
>>>> packets go back to inactive slave from switch, because the inactive slave's inactive
>>>> flag is zero, kernel will receive the packets and pass them to bridge, that cause dom0's
>>>> bridge map domu's MAC address to port of bond, bridge should map domu's MAC to port of vif.
>>>>
>>>> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
>>>> ---
>>>>  drivers/net/bonding/bond_main.c |    2 +-
>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>>> index e5628fc..8761df6 100644
>>>> --- a/drivers/net/bonding/bond_main.c
>>>> +++ b/drivers/net/bonding/bond_main.c
>>>> @@ -3062,7 +3062,7 @@ static int bond_open(struct net_device *bond_dev)
>>>>  				&& (slave != bond->curr_active_slave)) {
>>>>  				bond_set_slave_inactive_flags(slave,
>>>>  							      BOND_SLAVE_NOTIFY_NOW);
>>>> -			} else {
>>>> +			} else if (!bond_is_lb(bond)) {
>>>>  				bond_set_slave_active_flags(slave,
>>>>  							    BOND_SLAVE_NOTIFY_NOW);
>>>>  			}
>>>>
>>> I think you did not fix the problem completely, the state monitor will change the status for the slaves
>>> and the inactive slave still could receive the broadcast.
>>
>> Had tested, it can fix the issue, verified by our QA.
>> Default set slave of bond as inactive when add a slave to bond, when
>> link UP, just set one slave as current active slave and clear its
>> inactive flag, the inactive slave's inactive flag will keep the value of 1.
>>
>>
> Ok, I found that in the mii monitor, it will only change the backup state, no problem,
> it looks good to me.
> 
> Ding
> 
>>>
>>> Regards
>>> Ding
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>>
>>
>> .
>>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


