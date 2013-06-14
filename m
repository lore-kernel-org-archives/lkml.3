Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751021Ab3FNDM5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 23:12:57 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:43630 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3FNDMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 23:12:55 -0400
Message-ID: <1371179569.3252.120.camel@edumazet-glaptop>
Subject: Re: [PATCH v4 net-next 2/4] net: convert low latency sockets to
 sched_clock()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Alex Rosenbaum <alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>,
        sockperf-dev@googlegroups.com, Eliezer Tamir <eliezer@tamir.org.il>
Date: Thu, 13 Jun 2013 20:12:49 -0700
In-Reply-To: <20130614015659.3500.48625.stgit@ladj378.jer.intel.com>
References: <20130614015638.3500.61523.stgit@ladj378.jer.intel.com>
	 <20130614015659.3500.48625.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-14 at 04:57 +0300, Eliezer Tamir wrote:
> Use sched_clock() instead of get_cycles().
> We can use sched_clock() because we don't care much about accuracy.
> Remove the dependency on X86_TSC
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---

>  
> -static inline bool can_poll_ll(cycles_t end_time)
> +static inline bool can_poll_ll(u64 end_time)
>  {
> -	return !time_after((unsigned long)get_cycles(),
> +	return !time_after((unsigned long)sched_clock(),
>  			    (unsigned long)end_time);
>  }

I do not really understand why you bother to have 64bit wide values,
and then use these "unsigned long" casts here.

On 32bit arches, this will really limit to 2^31 ns range.

You should instead either :
- use time_after_64() or 
- explicitly limit sysctl_net_ll_poll range


