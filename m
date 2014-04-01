Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaDALfO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:35:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55830 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbaDALfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:35:04 -0400
Message-ID: <533AA35B.8050004@redhat.com>
Date: Tue, 01 Apr 2014 13:30:35 +0200
From: Nikolay Aleksandrov <nikolay@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Zheng Li <zheng.x.li@oracle.com>, netdev@vger.kernel.org, fubar@us.ibm.com,
        andy@greyhouse.net, j.vosburgh@gmail.com
CC: linux-kernel@vger.kernel.org, davem@davemloft.net, joe.jin@oracle.com
Subject: Re: [PATCH v2] bonding: Inactive slaves should keep inactive flag's
 value
References: <1396339327-24899-1-git-send-email-zheng.x.li@oracle.com>
In-Reply-To: <1396339327-24899-1-git-send-email-zheng.x.li@oracle.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 10:02 AM, Zheng Li wrote:
> bond_open is not setting the inactive flag correctly for some modes (alb and
> tlb), resulting in error behavior if the bond has been administratively set
> down and then back up. This effect should not occur when slaves are added while
> the bond is up; it's something that only happens after a down/up bounce of the
> bond.
> 
> For example, in bond tlb or alb mode, domu send some ARP request which go out
> from dom0 bond's active slave, then the ARP broadcast request packets go back to
> inactive slave from switch, because the inactive slave's inactive flag is zero,
> kernel will receive the packets and pass them to bridge that cause dom0's bridge
> map domu's MAC address to port of bond, bridge should map domu's MAC to port of
> vif.
> 
> Signed-off-by: Zheng Li <zheng.x.li@oracle.com>
> Signed-off-by: Jay Vosburgh <j.vosburgh@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index e5628fc..f97d72e 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3058,7 +3058,7 @@ static int bond_open(struct net_device *bond_dev)
>  	if (bond_has_slaves(bond)) {
>  		read_lock(&bond->curr_slave_lock);
>  		bond_for_each_slave(bond, slave, iter) {
> -			if ((bond->params.mode == BOND_MODE_ACTIVEBACKUP)
> +			if ((bond->params.mode == BOND_MODE_ACTIVEBACKUP || bond_is_lb(bond))
IIRC, this check is identical to USES_PRIMARY().

>  				&& (slave != bond->curr_active_slave)) {
>  				bond_set_slave_inactive_flags(slave,
>  							      BOND_SLAVE_NOTIFY_NOW);
> 

