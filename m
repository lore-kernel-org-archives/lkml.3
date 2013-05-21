Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab3EURX6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:23:58 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:59923 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab3EURXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:23:55 -0400
Message-ID: <1369157030.2615.24.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4 net-next 1/4] net: implement support for low latency
 socket polling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Dave Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        "Don Skidmore" <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 18:23:50 +0100
In-Reply-To: <20130521142650.18498.71715.stgit@ladj378.jer.intel.com>
References: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
	 <20130521142650.18498.71715.stgit@ladj378.jer.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19882.005
X-TM-AS-Result: No--18.540300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 17:26 +0300, Eliezer Tamir wrote:
> Adds a new ndo_ll_poll method and the code that supports and uses it.
> This method can be used by low latency applications to busy poll ethernet
> device queues directly from the socket code. The ip_low_latency_poll sysctl
> entry controls how many cycles to poll. Set to zero to disable.

Microseconds, not cycles.

[...]
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -19,6 +19,12 @@ ip_no_pmtu_disc - BOOLEAN
>  	Disable Path MTU Discovery.
>  	default FALSE
>  
> +ip_low_latency_poll - INTEGER
> +	Low latency busy poll timeout. (needs CONFIG_INET_LL_RX_POLL)
> +	Approximate time in ms to spin waiting for packets on the device queue.

us, not ms.

[...]
> --- /dev/null
> +++ b/include/net/ll_poll.h
> @@ -0,0 +1,117 @@
> +/*
> + * low latency network device queue flush
> + * Copyright(c) 2013 Intel Corporation.
> + * Author: Eliezer Tamir
> + *
> + * For now this depends on CONFIG_I86_TSC

CONFIG_X86_TSC

[...]
> +static inline bool sk_poll_ll(struct sock *sk, int nonblock)
> +{
> +	unsigned long end_time = TSC_MHZ * ACCESS_ONCE(sysctl_net_ll_poll)
> +					+ get_cycles();
> +	struct napi_struct *napi = sk->dev_ref;
> +	const struct net_device_ops *ops;
> +	int rc;
> +
> +	if (!napi->dev->netdev_ops->ndo_ll_poll)
> +		return false;
> +
> +	local_bh_disable();
> +
> +	ops = napi->dev->netdev_ops;

Should be done before testing ndo_ll_poll above, so you can avoid
repeating the indirections.

> +	while (skb_queue_empty(&sk->sk_receive_queue) &&
> +			!time_after((unsigned long)get_cycles(), end_time)) {
> +		rc = ops->ndo_ll_poll(napi);
> +
> +		if (rc == LL_FLUSH_FAILED)
> +			break; /* premanent failure */
[...]

Typo: 'permanent'.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

