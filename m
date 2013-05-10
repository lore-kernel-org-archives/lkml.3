Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3EJN6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:58:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642Ab3EJN6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:58:08 -0400
Date: Fri, 10 May 2013 15:58:10 +0200
From: Michal Kubecek <mkubecek@suse.cz>
To: Imre Deak <imre.deak@intel.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 06/11] net/bonding: take msecs_to_jiffies_min into use
Message-ID: <20130510135810.GA30139@unicorn.suse.cz>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
 <1368188011-23661-6-git-send-email-imre.deak@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1368188011-23661-6-git-send-email-imre.deak@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 03:13:24PM +0300, Imre Deak wrote:
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1751,7 +1751,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
>  	read_lock(&bond->lock);
>  
>  	new_slave->last_arp_rx = jiffies -
> -		(msecs_to_jiffies(bond->params.arp_interval) + 1);
> +		(msecs_to_jiffies_min(bond->params.arp_interval));
>  
>  	if (bond->params.miimon && !bond->params.use_carrier) {
>  		link_reporting = bond_check_dev_link(bond, slave_dev, 1);

This "+ 1" was actually meant as "plus one". We need to ensure that

  slave->last_arp_rx + msecs_to_jiffies(bond->params.arp_interval)

is strictly less than current value of jiffies. So with proposed
definition of msecs_to_jiffies_min() it works correctly but if the
implementation ever changes in such way that

  msecs_to_jiffies_min(x) >= msecs_to_jiffies(x)

for some value of x, the code would be incorrect.

                                                       Michal Kubeèek

