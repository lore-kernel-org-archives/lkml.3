Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396Ab3ETP3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 11:29:35 -0400
Received: from mail-da0-f49.google.com ([209.85.210.49]:58157 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3ETP3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 11:29:32 -0400
Message-ID: <1369063764.3301.182.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 net-next 1/4] net: implement support for low latency
 socket polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 20 May 2013 08:29:24 -0700
In-Reply-To: <20130520101601.14133.874.stgit@ladj378.jer.intel.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	 <20130520101601.14133.874.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 13:16 +0300, Eliezer Tamir wrote:
> Adds a new ndo_ll_poll method and the code that supports and uses it.
> This method can be used by low latency applications to busy poll ethernet
> device queues directly from the socket code. The ip_low_latency_poll sysctl
> entry controls how many cycles to poll. Set to zero to disable.
> 

This changelog lacks a lot of information, see below.

Part of this information was in your 0/4 text, but it wont be included
in the git tree.

> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 

> +
> +static inline void skb_mark_ll(struct sk_buff *skb, struct napi_struct *napi)
> +{
> +	skb->dev_ref = napi;
> +}
> +
> +static inline void sk_mark_ll(struct sock *sk, struct sk_buff *skb)
> +{
> +	sk->dev_ref = skb->dev_ref;
> +}

I do not see why it's safe to keep a pointer to a napi object without
taking a reference, or something to prevent object being removed.

Using a genid might be enough. (some counter incremented every time a
napi is dismantled)

Alternatively, use a napi_id instead of a pointer.



