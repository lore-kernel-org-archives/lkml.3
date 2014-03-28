Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaC1IZr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:25:47 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31641 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaC1IZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:25:44 -0400
Message-ID: <5335353C.1050409@oracle.com>
Date: Fri, 28 Mar 2014 16:39:24 +0800
From: "zheng.li" <zheng.x.li@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: netdev@vger.kernel.org, andy@greyhouse.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: Inactive slaves should keep inactive flag's
 value to 1 in tlb and alb mode.
References: <1395716407-31601-1-git-send-email-zheng.x.li@oracle.com> <9725.1395940983@death.nxdomain>
In-Reply-To: <9725.1395940983@death.nxdomain>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2014年03月28日 01:23, Jay Vosburgh 写道:
> Zheng Li <zheng.x.li@oracle.com> wrote:
> 
>> In bond mode tlb and alb, inactive slaves should keep inactive flag to
>> 1 to refuse to receive broadcast packets. Now, active slave send broadcast packets
>> (for example ARP requests) which will arrive inactive slaves on same host from switch,
>> but inactive slave's inactive flag is zero that cause bridge receive the broadcast
>> packets to produce a wrong entry in forward table. Typical situation is domu send some
>> ARP request which go out from dom0 bond's active slave, then the ARP broadcast request
>> packets go back to inactive slave from switch, because the inactive slave's inactive
>> flag is zero, kernel will receive the packets and pass them to bridge, that cause dom0's
>> bridge map domu's MAC address to port of bond, bridge should map domu's MAC to port of vif.
> 
> 	It's probably worth noting that this effect is something that
> happens after the bonding master device is opened with slaves, i.e.,
> it's got a bunch of slaves, and is then set administratively down for
> whatever reason, and is now being set back up, and needs to set the
> active or inactive state of all the slaves.

I think bond_miimon_commit() funciotn will process this situation,
case BOND_LINK_UP:
   if (!bond->curr_active_slave ||
			    (slave == bond->primary_slave))
				goto do_failover;

do_failover:
		bond_select_active_slave(bond);

> 
> 	It'd also be a little easier to read if it was formatted for 80
> columns.
> 
>> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
>> ---
>> drivers/net/bonding/bond_main.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>> index e5628fc..8761df6 100644
>> --- a/drivers/net/bonding/bond_main.c
>> +++ b/drivers/net/bonding/bond_main.c
>> @@ -3062,7 +3062,7 @@ static int bond_open(struct net_device *bond_dev)
>> 				&& (slave != bond->curr_active_slave)) {
>> 				bond_set_slave_inactive_flags(slave,
>> 							      BOND_SLAVE_NOTIFY_NOW);
>> -			} else {
>> +			} else if (!bond_is_lb(bond)) {
>> 				bond_set_slave_active_flags(slave,
>> 							    BOND_SLAVE_NOTIFY_NOW);
> 
> 	This patch doesn't do anything for the modes that are
> bond_is_lb, i.e., the balance-tlb and -alb modes.  I believe those two
> should be set similarly to active-backup: the curr_active_slave is
> active, other slaves are inactive.  The "inactive" setting for alb is
> special, and means to not pass broadcast or multicast, but let unicast
> through.

>From dmesg and the source code in kernel, every slave of bond default been set to inactive 1 when slave be added in the bond, and then "Link UP" will comes that let bond choose one as cur_active_salve and change it's inactive value to 0 and other slaves will keep their value of inactive to 1, so it doesn't need set inactive again in bong_open by default all salves inactive is 1 when bond add salves.

You can add printk in kernel, will find the flow, my print show the flow:
1 step ) bonding: bond1 is being created...

2 step ) bonding: bond1: Adding slave eth2. // in this stage, every slave will be set to inactive 1;
          zheng debug set inactive eth2 bond bond1 
          zheng debug set inactive flag eth2 

   bonding: bond1: Adding slave eth3.
            zheng2 set slave inactive eth3
            zheng debug set inactive eth3 bond bond1 
   
3 step ) zheng bonding open 
   //in bond_open function, we just need keep the inactive to 1 for alb and tlb, .i.e don't 
   clear the inactive is ok, my patch did that.

4 setp)  "LINK UP" will make one slave to cur_active_slave and change it's inactive to 0, other slaves will keep their original inactive value to 1;

e1000e: eth2 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None

bonding: bond1: link status up for interface eth2, enabling it in 0 ms.

bonding: bond1: link status definitely up for interface eth2, 1000 Mbps full duplex.

bonding: bond1: making interface eth2 the new active one.

device eth2 entered promiscuous mode

zheng1 set new slave active eth2

zheng debug set active flag eth2 

bonding: bond1: first active interface up!

Thanks,
Zheng Li


> 	-J
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


