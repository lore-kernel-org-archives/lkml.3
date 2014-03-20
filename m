Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759024AbaCTRCq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 13:02:46 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:47958 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbaCTRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 13:02:43 -0400
From: Jay Vosburgh <fubar@us.ibm.com>
To: Zheng Li <zheng.x.li@oracle.com>
cc: netdev@vger.kernel.org, andy@greyhouse.net, linux-kernel@vger.kernel.org,
        davem@davemloft.net, joe.jin@oracle.com
Subject: Re: [PATCH] bonding: Inactive slaves should keep inactive flag's value to 1.
In-reply-to: <1395305504-29973-1-git-send-email-zheng.x.li@oracle.com>
References: <1395305504-29973-1-git-send-email-zheng.x.li@oracle.com>
Comments: In-reply-to Zheng Li <zheng.x.li@oracle.com>
   message dated "Thu, 20 Mar 2014 16:51:44 +0800."
X-Mailer: MH-E 8.3.1; nmh 1.5; GNU Emacs 24.3.50
Date: Thu, 20 Mar 2014 10:02:33 -0700
Message-ID: <3119.1395334953@death.nxdomain>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032017-1344-0000-0000-000000685C4E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Zheng Li <zheng.x.li@oracle.com> wrote:

>Except bond mode 1, in other bond modes, inactive slaves should keep
>inactive flag to 1 to refuse to receive broadcast packets. Now, active
>slave send broadcast packets (for example ARP requests) which will
>arrive inactive slaves on same host from switch, but inactive slave's
>inactive flag is zero that cause bridge receive the broadcast packets
>to produce a wrong entry in forward table. Typical situation is domu
>send some ARP request which go out from dom0 bond's active slave, then
>the ARP broadcast request packets go back to inactive slave from
>switch, because the inactive slave's inactive flag is zero, kernel will
>receive the packets and pass them to bridge, that cause dom0's bridge
>map domu's MAC address to port of bond, bridge should map domu's MAC to
>port of vif.

	I suspect this will break LACP (802.3ad) and Etherchannel
(balance-xor, balance-rr) modes, as those modes can receive broadcast or
multicast on any slave.  In those cases, the switch knows about the
aggregation, and will only send the broadcast / multicast to one of the
ports, but the port selected is not always the same one.

	In which mode are you having trouble?

	-J


>
>Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
>---
> drivers/net/bonding/bond_main.c |    2 +-
> 1 files changed, 1 insertions(+), 1 deletions(-)
>
>diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
>index e5628fc..2f73f18 100644
>--- a/drivers/net/bonding/bond_main.c
>+++ b/drivers/net/bonding/bond_main.c
>@@ -3063,7 +3063,7 @@ static int bond_open(struct net_device *bond_dev)
> 				bond_set_slave_inactive_flags(slave,
> 							      BOND_SLAVE_NOTIFY_NOW);
> 			} else {
>-				bond_set_slave_active_flags(slave,
>+				bond_set_slave_state(slave, BOND_STATE_ACTIVE,
> 							    BOND_SLAVE_NOTIFY_NOW);
> 			}
> 		}
>-- 
>1.7.6.5
>

---
	-Jay Vosburgh, IBM Linux Technology Center, fubar@us.ibm.com

