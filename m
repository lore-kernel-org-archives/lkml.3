Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbaGWBxi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 21:53:38 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:57297 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaGWBxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 21:53:36 -0400
Message-ID: <53CF159C.8040102@greenwavereality.com>
Date: Tue, 22 Jul 2014 18:53:32 -0700
From: Bob Richmond <robert.richmond@greenwavereality.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Adding neighbor cache entry solely initiated by multicast traffic
Content-Type: multipart/mixed;
 boundary="------------050208040009090506070305"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050208040009090506070305
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

For a device on the local network that mostly functions as a multicast 
receiver, the only packets a router may see from this client are IGMP 
membership reports. I believe that alone should be enough information to 
establish a neighbor cache entry for it.

A client intending to unicast to the router will first ARP for the 
router's address, and the router will then respond to the ARP AND cache 
the client's address to avoid ARPing for the client's address when 
replying to original packet.

I believe this patch functions in the same spirit of that approach.

Something like this is necessary for a router managing multicast 
subscriptions in userspace using the ipmr API. Such a thing would need 
to know which interface an IGMP membership report came in on, in order 
to establish a vif route for it. Without a netlink message indicating a 
new neighbor for the subscriber's IP address, it can't be known which 
vif to establish the route on.

Is there anything glaringly wrong with this?

--------------050208040009090506070305
Content-Type: text/x-patch;
 name="linux-3.4.91_add_neighbour_on_multicast.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linux-3.4.91_add_neighbour_on_multicast.patch"

*** linux-3.4.91/net/ipv4/route.c.orig	2014-05-18 05:26:09.000000000 -0700
--- linux-3.4.91/net/ipv4/route.c	2014-07-22 17:20:03.156032862 -0700
***************
*** 2008,2031 ****
--- 2008,2033 ----
  	return dst_alloc(&ipv4_dst_ops, dev, 1, -1,
  			 DST_HOST |
  			 (nopolicy ? DST_NOPOLICY : 0) |
  			 (noxfrm ? DST_NOXFRM : 0));
  }
  
  /* called in rcu_read_lock() section */
  static int ip_route_input_mc(struct sk_buff *skb, __be32 daddr, __be32 saddr,
  				u8 tos, struct net_device *dev, int our)
  {
  	unsigned int hash;
  	struct rtable *rth;
+ 	struct neighbour *n;
+ 	char lladdr[8];
  	__be32 spec_dst;
  	struct in_device *in_dev = __in_dev_get_rcu(dev);
  	u32 itag = 0;
  	int err;
  
  	/* Primary sanity checks. */
  
  	if (in_dev == NULL)
  		return -EINVAL;
  
  	if (ipv4_is_multicast(saddr) || ipv4_is_lbcast(saddr) ||
  	    ipv4_is_loopback(saddr) || skb->protocol != htons(ETH_P_IP))
***************
*** 2072,2095 ****
--- 2074,2101 ----
  		rth->dst.input= ip_local_deliver;
  		rth->rt_flags |= RTCF_LOCAL;
  	}
  
  #ifdef CONFIG_IP_MROUTE
  	if (!ipv4_is_local_multicast(daddr) && IN_DEV_MFORWARD(in_dev))
  		rth->dst.input = ip_mr_input;
  #endif
  	RT_CACHE_STAT_INC(in_slow_mc);
  
  	hash = rt_hash(daddr, saddr, dev->ifindex, rt_genid(dev_net(dev)));
  	rth = rt_intern_hash(hash, rth, skb, dev->ifindex);
+ 	if (dev_parse_header(skb, lladdr) > 0) {
+ 		n = __neigh_lookup(&arp_tbl, &saddr, dev, 1);
+ 		neigh_update(n, lladdr, NUD_REACHABLE, 0);
+ 	}
  	return IS_ERR(rth) ? PTR_ERR(rth) : 0;
  
  e_nobufs:
  	return -ENOBUFS;
  e_inval:
  	return -EINVAL;
  e_err:
  	return err;
  }
  
  
  static void ip_handle_martian_source(struct net_device *dev,

--------------050208040009090506070305--
