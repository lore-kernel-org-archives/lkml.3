Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab3EJVTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 17:19:43 -0400
Received: from mga01.intel.com ([192.55.52.88]:6052 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab3EJVTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 17:19:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,651,1363158000"; 
   d="scan'208";a="335719537"
Message-ID: <1368220776.18714.30.camel@ideak-mobl>
Subject: Re: [PATCH 06/11] net/bonding: take msecs_to_jiffies_min into use
From: Imre Deak <imre.deak@intel.com>
To: Michal Kubecek <mkubecek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>,
        netdev@vger.kernel.org
Date: Sat, 11 May 2013 00:19:36 +0300
In-Reply-To: <20130510135810.GA30139@unicorn.suse.cz>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	 <1368188011-23661-6-git-send-email-imre.deak@intel.com>
	 <20130510135810.GA30139@unicorn.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-05-10 at 15:58 +0200, Michal Kubecek wrote:
> On Fri, May 10, 2013 at 03:13:24PM +0300, Imre Deak wrote:
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -1751,7 +1751,7 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev)
> >  	read_lock(&bond->lock);
> >  
> >  	new_slave->last_arp_rx = jiffies -
> > -		(msecs_to_jiffies(bond->params.arp_interval) + 1);
> > +		(msecs_to_jiffies_min(bond->params.arp_interval));
> >  
> >  	if (bond->params.miimon && !bond->params.use_carrier) {
> >  		link_reporting = bond_check_dev_link(bond, slave_dev, 1);
> 
> This "+ 1" was actually meant as "plus one". We need to ensure that
> 
>   slave->last_arp_rx + msecs_to_jiffies(bond->params.arp_interval)
> 
> is strictly less than current value of jiffies.

Ok, I see, the adjustment here is for a different reason and
msecs_to_jiffies_min wouldn't express this properly. So we should drop
this patch. Perhaps it'd be nice to add something like the above
explanation as a code comment, to make it clear that the adjustment is
not for guaranteeing a minimum duration as it is in many other places.

--Imre

> So with proposed
> definition of msecs_to_jiffies_min() it works correctly but if the
> implementation ever changes in such way that
> 
>   msecs_to_jiffies_min(x) >= msecs_to_jiffies(x)
> 
> for some value of x, the code would be incorrect.
> 
>                                                        Michal Kubeček
> 


