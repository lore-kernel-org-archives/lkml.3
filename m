Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbaCXIsK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:48:10 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50759 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752912AbaCXIsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:48:05 -0400
Message-ID: <532FF476.9060008@oracle.com>
Date: Mon, 24 Mar 2014 17:01:42 +0800
From: "zheng.li" <zheng.x.li@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jay Vosburgh <fubar@us.ibm.com>
CC: netdev@vger.kernel.org, andy@greyhouse.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: Inactive slaves should keep inactive flag's
 value to 1.
References: <1395305504-29973-1-git-send-email-zheng.x.li@oracle.com> <3119.1395334953@death.nxdomain> <532BA648.6060600@oracle.com> <13028.1395423785@death.nxdomain>
In-Reply-To: <13028.1395423785@death.nxdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recreate patch again as below, please check.


>From 9f504b1ee94e87dcfbb330ebd2f5bc6ca91f4b5b Mon Sep 17 00:00:00 2001
From: Zheng Li <zheng.x.li@oracle.com>
Date: Mon, 24 Mar 2014 16:53:25 +0800
Subject: [PATCH] bonding: Inactive slaves should keep inactive flag's
value to 1 in
 tlb and alb mode.

In bond mode tlb and alb, inactive slaves should keep inactive flag to
1 to refuse to receive broadcast packets. Now, active slave send
broadcast packets
(for example ARP requests) which will arrive inactive slaves on same
host from switch,
but inactive slave's inactive flag is zero that cause bridge receive the
broadcast
packets to produce a wrong entry in forward table. Typical situation is
domu send some
ARP request which go out from dom0 bond's active slave, then the ARP
broadcast request
packets go back to inactive slave from switch, because the inactive
slave's inactive
flag is zero, kernel will receive the packets and pass them to bridge,
that cause dom0's
bridge map domu's MAC address to port of bond, bridge should map domu's
MAC to port of vif.

Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
---
 drivers/net/bonding/bond_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c
b/drivers/net/bonding/bond_main.c
index e5628fc..8761df6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -3062,7 +3062,7 @@ static int bond_open(struct net_device *bond_dev)
                                && (slave != bond->curr_active_slave)) {
                                bond_set_slave_inactive_flags(slave,

BOND_SLAVE_NOTIFY_NOW);
-                       } else {
+                       } else if (!bond_is_lb(bond)) {
                                bond_set_slave_active_flags(slave,

BOND_SLAVE_NOTIFY_NOW);
                        }
--
1.7.6.5


Thanks,
Zheng Li

于 2014年03月22日 01:43, Jay Vosburgh 写道:
> zheng.li <zheng.x.li@oracle.com> wrote:
> 
>> 于 2014年03月21日 01:02, Jay Vosburgh 写道:
>>> Zheng Li <zheng.x.li@oracle.com> wrote:
>>>
>>>> Except bond mode 1, in other bond modes, inactive slaves should keep
>>>> inactive flag to 1 to refuse to receive broadcast packets. Now, active
>>>> slave send broadcast packets (for example ARP requests) which will
>>>> arrive inactive slaves on same host from switch, but inactive slave's
>>>> inactive flag is zero that cause bridge receive the broadcast packets
>>>> to produce a wrong entry in forward table. Typical situation is domu
>>>> send some ARP request which go out from dom0 bond's active slave, then
>>>> the ARP broadcast request packets go back to inactive slave from
>>>> switch, because the inactive slave's inactive flag is zero, kernel will
>>>> receive the packets and pass them to bridge, that cause dom0's bridge
>>>> map domu's MAC address to port of bond, bridge should map domu's MAC to
>>>> port of vif.
>>>
>>> 	I suspect this will break LACP (802.3ad) and Etherchannel
>>> (balance-xor, balance-rr) modes, as those modes can receive broadcast or
>>> multicast on any slave.  In those cases, the switch knows about the
>>> aggregation, and will only send the broadcast / multicast to one of the
>>> ports, but the port selected is not always the same one.
>>>
>>> 	In which mode are you having trouble?
>>>
>>> 	-J
>>
>> Except bond mode 1, in other modes (major test in mode 6, and test all
>> other mode,  except mode 1, all other modes has the bug), the bridge
>> make a wrong entry which map guest MAC to the port of bond, it should
>> map guest MAC to the port of vif.
>>
>> Env description: dom0's bridge contains bond1 and vif ports, bond1 as
>> port 1 , vif as port 2, bond1 has two slaves which connect a switch.
>> when from guest ping others ,the arp broadcast request will go out from
>> bond1's active slave, and then go back to itself inactive slave from
>> switch , in function of bond_should_deliver_exact_match will return
>> false by inactive is zero, return false will cause bridge receive the
>> arp request packets whose original is from guest through vif that let
>> bridge consider the SRC MAC of guest is from bond1 by analyzing the arp
>> broadcast packets, then make a wrong forward entry "MAC of guest, from
>> port 1 (bond1)" , the correct entry should be "MAC of guest , from port
>> 2 (vif)".
> 
> 	I believe I understand; the crux of the problem is that the
> broadcast is looped by the switch to the other bond port, which then
> processes it as a received packet.
> 
> 	For the tlb and alb modes, you're logically correct; the slaves
> other than the active slave should be set to inactive when the bond is
> opened.  This is how they are set when configured normally to limit
> inbound broadcast and multicast traffic to just one slave (because these
> modes do not configure the switch ports into channel groups or
> aggregators; the switch has no knowledge of the bond).
> 
> 	Your patch is still incorrect, though; the slaves should be set
> to actually be inactive via bond_set_slave_inactive_flags, not left
> "semi-active," i.e., BOND_STATE_ACTIVE but slave->inactive set. More on
> the slave->inactive flag handling later, though.
> 
> 	For the balance-rr/-xor and 802.3ad modes, I suspect you have a
> configuration problem of some sort.  For those modes, the switch should
> not loop back the broadcast as you describe when correctly configured.
> 
> 	The balance-rr/-xor modes should be connected to switch ports
> that are configured into a single Etherchannel group (static link
> aggregation).  If they are not, the looping back behavior you describe
> is expected, as the switch will flood the broadcast to all ports.
> 
> 	Similarly, the 802.3ad mode should be connected to a switch with
> the ports configured for LACP, in which case the ports will
> automatically configure into one or more aggregators, and again, the
> switch will limit broadcast and multicast traffic to just one member of
> an aggregator.
> 
> 	The -rr/-xor/802.3ad modes must have all slaves set to active in
> order for them to correctly process incoming broadcast and multicast
> traffic in their proper configuration.  Setting them to inactive will
> cause packet loss in those configurations.
> 
> 	The 802.3ad mode is probably the easiest to examine; if you
> configure the switch ports for LACP mode, the /proc/net/bonding/bond0
> file should indicate that all the slaves are in the same aggregator
> (have the same Aggregator ID), and that that aggregator is the active
> one.  The switch should have similar indications, although the format is
> vendor-specific.  If your switch is configured for LACP and you still
> have issues, please post the /proc/net/bonding/bond0 contents.
> 
> 	Finally, getting back to the slave->inactive flag.  The only
> difference between bond_set_slave_active_flags or _inactive_flags and
> bond_set_slave_state is that the slave->inactive flag (whose only
> purpose is duplicate suppression for incoming packets) is cleared by the
> first (_flags variant), but not by the second.  Right now, the only
> caller of _set_slave_state are the _active/_inactive_flags functions, so
> it all works.  If _set_slave_state is called independently, then the
> slave->inactive flag and the actual state may become unsynchronized.
> 
> 	In summary, it looks to me like:
> 
> 	(a) bond_set_slave_state should fix slave->inactive to match the
> slave state if there are going to be callers other than
> bond_set_slave_active_flags or _inactive_flags, or remove the
> slave->inactive field entirely and have bond_is_slave_inactive use
> slave->back directly.
> 
> 	and, the immediate problem here,
> 
> 	(b) bond_open should call bond_set_slave_active_flags or
> _inactive_flags based on the mode and whether or not the slave is the
> curr_active_slave.  For active-backup, alb and tlb modes, the active
> slave is active, the others are inactive; for -rr, -xor and 802.3ad
> modes, all slaves are active.  I dunno what to do with broadcast mode;
> make 'em all active, I guess.
> 
> 	-J
> 
>> bond_should_deliver_exact_match(struct sk_buff *skb,
>> 					    struct slave *slave,
>> 					    struct bonding *bond)
>> {
>> 	if (bond_is_slave_inactive(slave)) {
>> 		if (bond->params.mode == BOND_MODE_ALB &&
>> 		    skb->pkt_type != PACKET_BROADCAST &&
>> 		    skb->pkt_type != PACKET_MULTICAST)
>> 			return false;
>> 		return true;
>> 	}
>> 	return false;
>> }
>>
>> Thanks,
>> Zheng Li
>>
>>
>>>
>>>>
>>>> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
>>>> ---
>>>> drivers/net/bonding/bond_main.c |    2 +-
>>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>>>> index e5628fc..2f73f18 100644
>>>> --- a/drivers/net/bonding/bond_main.c
>>>> +++ b/drivers/net/bonding/bond_main.c
>>>> @@ -3063,7 +3063,7 @@ static int bond_open(struct net_device *bond_dev)
>>>> 				bond_set_slave_inactive_flags(slave,
>>>> 							      BOND_SLAVE_NOTIFY_NOW);
>>>> 			} else {
>>>> -				bond_set_slave_active_flags(slave,
>>>> +				bond_set_slave_state(slave, BOND_STATE_ACTIVE,
>>>> 							    BOND_SLAVE_NOTIFY_NOW);
>>>> 			}
>>>> 		}
>>>> -- 
>>>> 1.7.6.5
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


