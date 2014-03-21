Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965508AbaCUCZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 22:25:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40578 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355AbaCUCZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 22:25:29 -0400
Message-ID: <532BA648.6060600@oracle.com>
Date: Fri, 21 Mar 2014 10:39:04 +0800
From: "zheng.li" <zheng.x.li@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: netdev@vger.kernel.org, andy@greyhouse.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: Inactive slaves should keep inactive flag's
 value to 1.
References: <1395305504-29973-1-git-send-email-zheng.x.li@oracle.com> <3119.1395334953@death.nxdomain>
In-Reply-To: <3119.1395334953@death.nxdomain>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年03月21日 01:02, Jay Vosburgh 写道:
> Zheng Li <zheng.x.li@oracle.com> wrote:
> 
>> Except bond mode 1, in other bond modes, inactive slaves should keep
>> inactive flag to 1 to refuse to receive broadcast packets. Now, active
>> slave send broadcast packets (for example ARP requests) which will
>> arrive inactive slaves on same host from switch, but inactive slave's
>> inactive flag is zero that cause bridge receive the broadcast packets
>> to produce a wrong entry in forward table. Typical situation is domu
>> send some ARP request which go out from dom0 bond's active slave, then
>> the ARP broadcast request packets go back to inactive slave from
>> switch, because the inactive slave's inactive flag is zero, kernel will
>> receive the packets and pass them to bridge, that cause dom0's bridge
>> map domu's MAC address to port of bond, bridge should map domu's MAC to
>> port of vif.
> 
> 	I suspect this will break LACP (802.3ad) and Etherchannel
> (balance-xor, balance-rr) modes, as those modes can receive broadcast or
> multicast on any slave.  In those cases, the switch knows about the
> aggregation, and will only send the broadcast / multicast to one of the
> ports, but the port selected is not always the same one.
> 
> 	In which mode are you having trouble?
> 
> 	-J

Except bond mode 1, in other modes (major test in mode 6, and test all
other mode,  except mode 1, all other modes has the bug), the bridge
make a wrong entry which map guest MAC to the port of bond, it should
map guest MAC to the port of vif.

Env description: dom0's bridge contains bond1 and vif ports, bond1 as
port 1 , vif as port 2, bond1 has two slaves which connect a switch.
when from guest ping others ,the arp broadcast request will go out from
bond1's active slave, and then go back to itself inactive slave from
switch , in function of bond_should_deliver_exact_match will return
false by inactive is zero, return false will cause bridge receive the
arp request packets whose original is from guest through vif that let
bridge consider the SRC MAC of guest is from bond1 by analyzing the arp
broadcast packets, then make a wrong forward entry "MAC of guest, from
port 1 (bond1)" , the correct entry should be "MAC of guest , from port
2 (vif)".


bond_should_deliver_exact_match(struct sk_buff *skb,
					    struct slave *slave,
					    struct bonding *bond)
{
	if (bond_is_slave_inactive(slave)) {
		if (bond->params.mode == BOND_MODE_ALB &&
		    skb->pkt_type != PACKET_BROADCAST &&
		    skb->pkt_type != PACKET_MULTICAST)
			return false;
		return true;
	}
	return false;
}

Thanks,
Zheng Li


> 
>>
>> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
>> ---
>> drivers/net/bonding/bond_main.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index e5628fc..2f73f18 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -3063,7 +3063,7 @@ static int bond_open(struct net_device *bond_dev)
>> 				bond_set_slave_inactive_flags(slave,
>> 							      BOND_SLAVE_NOTIFY_NOW);
>> 			} else {
>> -				bond_set_slave_active_flags(slave,
>> +				bond_set_slave_state(slave, BOND_STATE_ACTIVE,
>> 							    BOND_SLAVE_NOTIFY_NOW);
>> 			}
>> 		}
>> -- 
>> 1.7.6.5
>>
> 
> ---
> 	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


