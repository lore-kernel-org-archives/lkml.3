Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102AbaLVR3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 12:29:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755373AbaLVR3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 12:29:10 -0500
Date: Mon, 22 Dec 2014 18:28:59 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, acme@kernel.org, linux-kernel@vger.kernel.org,
        Namhyung Kim <namhyung@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] tools lib traceevent: Add support for IP address formats
Message-ID: <20141222172859.GA11479@krava.brq.redhat.com>
References: <1418915443-45707-1-git-send-email-dsahern@gmail.com>
 <17321.1418939104@turing-police.cc.vt.edu>
 <549351A7.9040408@gmail.com>
 <54938266.9090007@gmail.com>
 <20141222170103.GG29096@krava.brq.redhat.com>
 <5498506A.4010100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5498506A.4010100@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 10:10:02AM -0700, David Ahern wrote:
> On 12/22/14 10:01 AM, Jiri Olsa wrote:
> >apart from your tracepoints, is there another tracepoint using this?
> >I couldn't find any.. I dont think it's a problem.. just wanted to
> >try it;-)
> 
> grrr... i was hoping no one would ask that question. I am not aware of any
> in tree. We use it locally in custom tracepoints in the networking stack
> (from what I can tell netdev will not take -- LTTng tried many years ago)
> and in a couple of klms.

hehe ;-) as I said I dont think this is a problem, as people can add their
own tracepoints (like you did) with print fmt allowing anything that could
go into printk..

> 
> The attached patch is what I used to test (plus our local versions). It is
> derived from a patch on the 3.4 kernel which allows us to trace address
> changes.

thanks,
jirka

> 
> David

> From bedfad82a159226f06a8035f6a7622fce6df7a0a Mon Sep 17 00:00:00 2001
> From: David Ahern <dsahern@gmail.com>
> Date: Thu, 18 Dec 2014 19:03:28 -0700
> Subject: [PATCH 2/2] tracepoints to test IP address format output
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> ---
>  include/trace/events/ipv4.h | 42 ++++++++++++++++++++++++++++++++++++++++++
>  include/trace/events/ipv6.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  net/core/net-traces.c       |  2 ++
>  net/ipv4/devinet.c          |  4 ++++
>  net/ipv6/addrconf.c         |  4 ++++
>  5 files changed, 96 insertions(+)
>  create mode 100644 include/trace/events/ipv4.h
>  create mode 100644 include/trace/events/ipv6.h
> 
> diff --git a/include/trace/events/ipv4.h b/include/trace/events/ipv4.h
> new file mode 100644
> index 000000000000..24e1e8a8b843
> --- /dev/null
> +++ b/include/trace/events/ipv4.h
> @@ -0,0 +1,42 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ipv4
> +
> +#if !defined(_TRACE_EVENTS_IPV4_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_EVENTS_IPV4_H
> +
> +#include <linux/inetdevice.h>
> +#include <linux/tracepoint.h>
> +
> +DECLARE_EVENT_CLASS(ipv4_addr_template,
> +
> +	TP_PROTO(struct in_ifaddr *ifa,
> +		 struct in_device *in_dev),
> +
> +	TP_ARGS(ifa, in_dev),
> +
> +	TP_STRUCT__entry(
> +		__array(__u8, addr, 4)
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(&__entry->addr,  &ifa->ifa_address, 4);
> +	),
> +
> +	TP_printk("pI4=%pI4 pi4=%pi4",
> +		__entry->addr, __entry->addr)
> +);
> +
> +DEFINE_EVENT(ipv4_addr_template, ipv4_add_addr,
> +	TP_PROTO(struct in_ifaddr *ifa, struct in_device *in_dev),
> +	TP_ARGS(ifa, in_dev)
> +);
> +
> +DEFINE_EVENT(ipv4_addr_template, ipv4_del_addr,
> +	TP_PROTO(struct in_ifaddr *ifa, struct in_device *in_dev),
> +	TP_ARGS(ifa, in_dev)
> +);
> +
> +#endif /* _TRACE_EVENTS_IPV4_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/include/trace/events/ipv6.h b/include/trace/events/ipv6.h
> new file mode 100644
> index 000000000000..db1ae85eaa0c
> --- /dev/null
> +++ b/include/trace/events/ipv6.h
> @@ -0,0 +1,44 @@
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM ipv6
> +
> +#if !defined(_TRACE_EVENTS_IPV6_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_EVENTS_IPV6_H
> +
> +#include <net/if_inet6.h>
> +#include <linux/tracepoint.h>
> +
> +DECLARE_EVENT_CLASS(ipv6_addr_template,
> +
> +	TP_PROTO(struct inet6_ifaddr *ifa),
> +
> +	TP_ARGS(ifa),
> +
> +	TP_STRUCT__entry(
> +		__array(__u8, addr, (int)sizeof(struct in6_addr))
> +	),
> +
> +	TP_fast_assign(
> +		memcpy(&__entry->addr,  &ifa->addr, (int)sizeof(struct in6_addr));
> +	),
> +
> +	TP_printk("pi6=%pi6 pI6=%pI6 pI6c=%pI6c",
> +		__entry->addr, __entry->addr, __entry->addr)
> +);
> +
> +DEFINE_EVENT(ipv6_addr_template, ipv6_add_addr,
> +
> +	TP_PROTO(struct inet6_ifaddr *ifa),
> +
> +	TP_ARGS(ifa)
> +);
> +DEFINE_EVENT(ipv6_addr_template, ipv6_del_addr,
> +
> +	TP_PROTO(struct inet6_ifaddr *ifa),
> +
> +	TP_ARGS(ifa)
> +);
> +
> +#endif /* _TRACE_EVENTS_IPV6_H */
> +
> +/* This part must be outside protection */
> +#include <trace/define_trace.h>
> diff --git a/net/core/net-traces.c b/net/core/net-traces.c
> index ba3c0120786c..b564a28852d1 100644
> --- a/net/core/net-traces.c
> +++ b/net/core/net-traces.c
> @@ -31,6 +31,8 @@
>  #include <trace/events/napi.h>
>  #include <trace/events/sock.h>
>  #include <trace/events/udp.h>
> +#include <trace/events/ipv4.h>
> +#include <trace/events/ipv6.h>
>  
>  EXPORT_TRACEPOINT_SYMBOL_GPL(kfree_skb);
>  
> diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
> index 214882e7d6de..aa6ba2ad93fd 100644
> --- a/net/ipv4/devinet.c
> +++ b/net/ipv4/devinet.c
> @@ -64,6 +64,7 @@
>  #include <net/rtnetlink.h>
>  #include <net/net_namespace.h>
>  #include <net/addrconf.h>
> +#include <trace/events/ipv4.h>
>  
>  #include "fib_lookup.h"
>  
> @@ -358,6 +359,7 @@ static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
>  				inet_hash_remove(ifa);
>  				*ifap1 = ifa->ifa_next;
>  
> +				trace_ipv4_del_addr(ifa, in_dev);
>  				rtmsg_ifa(RTM_DELADDR, ifa, nlh, portid);
>  				blocking_notifier_call_chain(&inetaddr_chain,
>  						NETDEV_DOWN, ifa);
> @@ -395,6 +397,7 @@ static void __inet_del_ifa(struct in_device *in_dev, struct in_ifaddr **ifap,
>  	   is valid, it will try to restore deleted routes... Grr.
>  	   So that, this order is correct.
>  	 */
> +	trace_ipv4_del_addr(ifa1, in_dev);
>  	rtmsg_ifa(RTM_DELADDR, ifa1, nlh, portid);
>  	blocking_notifier_call_chain(&inetaddr_chain, NETDEV_DOWN, ifa1);
>  
> @@ -476,6 +479,7 @@ static int __inet_insert_ifa(struct in_ifaddr *ifa, struct nlmsghdr *nlh,
>  	ifa->ifa_next = *ifap;
>  	*ifap = ifa;
>  
> +	trace_ipv4_add_addr(ifa, in_dev);
>  	inet_hash_insert(dev_net(in_dev->dev), ifa);
>  
>  	cancel_delayed_work(&check_lifetime_work);
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index f7c8bbeb27b7..294cb618baf5 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -90,6 +90,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/seq_file.h>
>  #include <linux/export.h>
> +#include <trace/events/ipv6.h>
>  
>  /* Set to 3 to get tracing... */
>  #define ACONF_DEBUG 2
> @@ -874,6 +875,7 @@ ipv6_add_addr(struct inet6_dev *idev, const struct in6_addr *addr,
>  	in6_dev_hold(idev);
>  	/* For caller */
>  	in6_ifa_hold(ifa);
> +	trace_ipv6_add_addr(ifa);
>  
>  	/* Add to big hash table */
>  	hash = inet6_addr_hash(addr);
> @@ -1658,8 +1660,10 @@ static void addrconf_dad_stop(struct inet6_ifaddr *ifp, int dad_failed)
>  		} else {
>  			spin_unlock_bh(&ifp->lock);
>  		}
> +		trace_ipv6_del_addr(ifp);
>  		ipv6_del_addr(ifp);
>  	} else {
> +		trace_ipv6_del_addr(ifp);
>  		ipv6_del_addr(ifp);
>  	}
>  }
> -- 
> 1.9.3 (Apple Git-50)
> 

