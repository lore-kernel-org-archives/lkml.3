Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbaEMPaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 11:30:18 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:51199 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaEMP25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 11:28:57 -0400
Date: Tue, 13 May 2014 08:28:53 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Jon Maxwell <jmaxwell37@gmail.com>, davem@davemloft.net,
        makita.toshiaki@lab.ntt.co.jp, vyasevic@redhat.com,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jpirko@redhat.com, jmaxwell@redhat.com
Subject: Re: [PATCH net] bridge: notify user space of fdb port change
Message-ID: <20140513082853.25e99c67@nehalam.linuxnetplumber.net>
In-Reply-To: <20140513151611.GA2966@minipsycho.orion>
References: <1399967708-7283-1-git-send-email-jmaxwell@redhat.com>
	<20140513151611.GA2966@minipsycho.orion>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2014 17:16:11 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> Tue, May 13, 2014 at 09:55:08AM CEST, jmaxwell37@gmail.com wrote:
> >From: Jon Maxwell <jmaxwell37@gmail.com>
> >
> >There has been a number incidents recently where customers running KVM have 
> >reported that VM hosts on different Hypervisors are unreachable. Based on 
> >pcap traces we found that the bridge was broadcasting the ARP request out 
> >onto the network. However some NICs have an inbuilt switch which on occasions 
> >were broadcasting the VMs ARP request back through the physical NIC on the 
> >Hypervisor. This resulted in the bridge changing ports and incorrectly learning
> >that the VMs mac address was external. As a result the ARP reply was directed 
> >back onto the external network and VM never updated it's ARP cache. This patch 
> >will notify the bridge command to identify such port toggling.
> >
> >Signed-off-by: Jon Maxwell <jmaxwell37@gmail.com>
> >---
> > net/bridge/br_fdb.c | 2 ++
> > 1 file changed, 2 insertions(+)
> >
> >diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> >index 9203d5a..37742e2 100644
> >--- a/net/bridge/br_fdb.c
> >+++ b/net/bridge/br_fdb.c
> >@@ -507,6 +507,8 @@ void br_fdb_update(struct net_bridge *br, struct net_bridge_port *source,
> > 					source->dev->name);
> > 		} else {
> > 			/* fastpath: update of existing entry */
> >+			if (source->port_no != fdb->dst->port_no)
> >+				fdb_notify(br, fdb, RTM_NEWNEIGH);
> > 			fdb->dst = source;
> > 			fdb->updated = jiffies;
> > 			if (unlikely(added_by_user))
> >-- 
> >1.8.3.1
> 
> 
> Reviewed-by: Jiri Pirko <jiri@resnulli.us>

I like the patch, but please add unlikely() to this conditional.
This is in the fast path code for bridge learning.
