Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3G0Rix (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 13:38:53 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37189 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab3G0Riw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 13:38:52 -0400
Message-ID: <1374946729.3669.5.camel@edumazet-glaptop>
Subject: Re: [ 42/79] vlan: fix a race in egress prio management
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Jul 2013 10:38:49 -0700
In-Reply-To: <1374944157.13555.43.camel@deadeye.wl.decadent.org.uk>
References: <20130726204721.849052763@linuxfoundation.org>
	 <20130726204726.846842461@linuxfoundation.org>
	 <1374944157.13555.43.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-27 at 17:55 +0100, Ben Hutchings wrote:
> On Fri, 2013-07-26 at 13:47 -0700, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eric Dumazet <edumazet@google.com>
> > 
> > [ Upstream commit 3e3aac497513c669e1c62c71e1d552ea85c1d974 ]
> > 
> > egress_priority_map[] hash table updates are protected by rtnl,
> > and we never remove elements until device is dismantled.
> > 
> > We have to make sure that before inserting an new element in hash table,
> > all its fields are committed to memory or else another cpu could
> > find corrupt values and crash.
> > 
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
> > Cc: Patrick McHardy <kaber@trash.net>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  net/8021q/vlan_dev.c |    7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > --- a/net/8021q/vlan_dev.c
> > +++ b/net/8021q/vlan_dev.c
> > @@ -73,6 +73,8 @@ vlan_dev_get_egress_qos_mask(struct net_
> >  {
> >  	struct vlan_priority_tci_mapping *mp;
> >  
> > +	smp_rmb(); /* coupled with smp_wmb() in vlan_dev_set_egress_priority() */
> > +
> >  	mp = vlan_dev_priv(dev)->egress_priority_map[(skb->priority & 0xF)];
> 
> This barrier is the wrong type in the wrong place; there should be a
> smp_read_barrier_depends() *after* reading the pointer from
> egress_priority_map, and after reading each next pointer.
> 

Not sure its a problem anyway, as we insert new items at the beginning
of the chain, and we never delete any item. What you describe would make
sense if we were deleting an item.

Once a reader gets a pointer, the whole chain is stable.

The important part of the patch was the smp_wmb(), to make sure np->next
was committed before "vlan->egress_priority_map[skb_prio & 0xF] = np;"



