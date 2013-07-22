Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236Ab3GVP3H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:29:07 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42414 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484Ab3GVP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:29:04 -0400
Message-ID: <51ED4EE6.9050502@linux.vnet.ibm.com>
Date: Mon, 22 Jul 2013 20:55:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Fan Du <fan.du@windriver.com>, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: Re: [BUG] ipv6, rawv6_close(): BUG: unable to handle kernel paging
 request
References: <51EC283D.5010208@linux.vnet.ibm.com> <51ED09A6.1020605@windriver.com> <20130722121911.GB6538@order.stressinduktion.org>
In-Reply-To: <20130722121911.GB6538@order.stressinduktion.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072215-2000-0000-0000-00000CFD2E94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22/2013 05:49 PM, Hannes Frederic Sowa wrote:
> On Mon, Jul 22, 2013 at 06:29:58PM +0800, Fan Du wrote:
>> Hallo Srivatsa
>>
>>
>> On 2013年07月22日 02:28, Srivatsa S. Bhat wrote:
>>> Hi,
>>>
>>> I'm seeing this on every boot.
>>>
>>> Version: Latest mainline (commit ea45ea70b)
>>
>> I tested with this commit using your updated IPv6 config, this incident 
>> didn't show up after several times of reboot.
>> Could you please elaborate your testing details if possible?
>>
>> A wild guess, it dereference mrt->mroute6_sk, indicating mrt is invalid.
> 
> Yes, that seems to be the case.
> 
> Could you test the following patch if you have a bit of time?
> 
> rtnl_lock is for some functions down lower the call stack in ip6mr_free_table.
>

This patch fixed the issue I was facing. Thanks!

Tested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
> index 583e8d4..03986d3 100644
> --- a/net/ipv6/ip6mr.c
> +++ b/net/ipv6/ip6mr.c
> @@ -259,10 +259,12 @@ static void __net_exit ip6mr_rules_exit(struct net *net)
>  {
>  	struct mr6_table *mrt, *next;
> 
> +	rtnl_lock();
>  	list_for_each_entry_safe(mrt, next, &net->ipv6.mr6_tables, list) {
>  		list_del(&mrt->list);
>  		ip6mr_free_table(mrt);
>  	}
> +	rtnl_unlock();
>  	fib_rules_unregister(net->ipv6.mr6_rules_ops);
>  }
>  #else
> @@ -289,7 +291,10 @@ static int __net_init ip6mr_rules_init(struct net *net)
> 
>  static void __net_exit ip6mr_rules_exit(struct net *net)
>  {
> +	rtnl_lock();
>  	ip6mr_free_table(net->ipv6.mrt6);
> +	net->ipv6.mrt6 = NULL;
> +	rtnl_unlock();
>  }
>  #endif
> 
> 

