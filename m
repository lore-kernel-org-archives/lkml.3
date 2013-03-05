Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757900Ab3CEQn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:43:27 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:36555 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab3CEQnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:43:24 -0500
Message-ID: <1362501781.2791.19.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 1/5] net: implement support for low latency socket
 polling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 5 Mar 2013 16:43:01 +0000
In-Reply-To: <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227175555.10611.42794.stgit@gitlad.jf.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19688.000
X-TM-AS-Result: No--21.447800-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 09:55 -0800, Eliezer Tamir wrote:
> Adds a new ndo_ll_poll method and the code that supports and uses it.
> This method can be used by low latency applications to busy poll ethernet
> device queues directly from the socket code. The ip_low_latency_poll sysctl
> entry controls how many cycles to poll. Set to zero to disable.
[...]
> --- /dev/null
> +++ b/include/net/ll_poll.h
> @@ -0,0 +1,71 @@
> +/*
> + * low latency device queue flush
> + */
> +
> +#ifndef _LINUX_NET_LL_POLL_H
> +#define _LINUX_NET_LL_POLL_H
> +#ifdef CONFIG_INET_LL_RX_POLL
> +#include <linux/netdevice.h>
> +struct napi_struct;
> +extern int sysctl_net_ll_poll __read_mostly;
> +
> +/* return values from ndo_ll_poll */
> +#define LL_FLUSH_DONE		0
> +#define LL_FLUSH_FAILED		1
> +#define LL_FLUSH_BUSY		2
> +
> +static inline int sk_valid_ll(struct sock *sk)

bool

> +{
> +	return sysctl_net_ll_poll && sk->dev_ref &&
> +		!need_resched() && !signal_pending(current);
> +}
> +
> +/*
> + * TODO: how do we know that we have a working get_cycles?
> + * do we limit this by a configure dependacy?

In general it appears to require a run-time check.  You might need to
augment <asm/timex.h>.

> + * TODO: this is not safe when the device can be removed,
> + * but simple refcounting may prevent removal indefinatly
> + */
> +static inline int sk_poll_ll(struct sock *sk)
> +{
> +	struct napi_struct *napi = sk->dev_ref;
> +	const struct net_device_ops *ops;
> +	unsigned long end_time = sysctl_net_ll_poll + get_cycles();

ACCESS_ONCE(sysctl_net_ll_poll)

> +	if (!napi->dev || !napi->dev->netdev_ops ||
> +	    !napi->dev->netdev_ops->ndo_ll_poll)
> +		return false;
> +
> +	local_bh_disable();
> +
> +	ops = napi->dev->netdev_ops;
> +	while (skb_queue_empty(&sk->sk_receive_queue) &&
> +			!time_after((unsigned long)get_cycles(), end_time))

cycles_t may be narrower than unsigned long, in which case time_after()
will not compare correctly.  I think you need to open-code the
equivalent of time_after() but using cycles_t.

> +		if (ops->ndo_ll_poll(napi) == LL_FLUSH_FAILED)
> +				break; /* premanent failure */
> +
> +	local_bh_enable();
> +
> +	return !skb_queue_empty(&sk->sk_receive_queue);
> +}
> +
> +static inline void skb_mark_ll(struct napi_struct *napi, struct sk_buff *skb)
> +{
> +	skb->dev_ref = napi;
> +}

Slightly odd - I would expect skb to be the first parameter.

[...]
> --- a/net/ipv4/Kconfig
> +++ b/net/ipv4/Kconfig
> @@ -402,6 +402,18 @@ config INET_LRO
>  
>  	  If unsure, say Y.
>  
> +config INET_LL_RX_POLL
> +	bool "Low Latency Receive Poll"
> +	default n
> +	---help---
> +	  Support Low Latency Receive Queue Poll.
> +	  (For network card drivers which support this option.)
> +	  When waiting for data in read or poll call directly into the the device driver
> +	  to flush packets which may be pending on the device queues into the stack.
> +
> +
> +	  If unsure, say N.

Of course, all distributions will be expected to enable this.  So I'm
not sure what the point of the compile-time option is.  You might as
well enable it at compile-time but leave the default set to 0.

>  config INET_DIAG
>  	tristate "INET: socket monitoring interface"
>  	default y
> diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
> index 960fd29..0c060c6 100644
> --- a/net/ipv4/sysctl_net_ipv4.c
> +++ b/net/ipv4/sysctl_net_ipv4.c
> @@ -25,6 +25,7 @@
>  #include <net/inet_frag.h>
>  #include <net/ping.h>
>  #include <net/tcp_memcontrol.h>
> +#include <net/ll_poll.h>
>  
>  static int zero;
>  static int one = 1;
> @@ -326,6 +327,15 @@ static struct ctl_table ipv4_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec
>  	},
> +#ifdef CONFIG_INET_LL_RX_POLL
> +	{
> +		.procname	= "ip_low_latency_poll",
> +		.data		= &sysctl_net_ll_poll,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec
> +	},
> +#endif

This would need to be added to Documentation/networking/ip-sysctl.txt.

Should the units really be cycles or, say, microseconds?  I assume that
a sysctl setter can do a conversion to cycles so that there's no need to
multiply every time the value is used.  (If the CPU doesn't have
constant_tsc or equivalent then this conversion doesn't quite work, but
then low-latency tunng usually includes disabling frequency scaling.)

Also, this should be a per-device (or even per-NAPI-context?) setting.

>  	{
>  		.procname	= "tcp_syn_retries",
>  		.data		= &sysctl_tcp_syn_retries,
> diff --git a/net/socket.c b/net/socket.c
> index ee0d029..86da082 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -105,6 +105,12 @@
>  #include <linux/sockios.h>
>  #include <linux/atalk.h>
>  
> +#ifdef CONFIG_INET_LL_RX_POLL
> +#include <net/ll_poll.h>
> +int sysctl_net_ll_poll __read_mostly = 150000;

Nicely tuned for your specific test system, no doubt. :-)

> +EXPORT_SYMBOL_GPL(sysctl_net_ll_poll);
> +#endif
[...]

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

