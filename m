Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3C1RoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:44:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:27534 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab3C1RoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:44:08 -0400
X-Authority-Analysis: v=2.0 cv=UN5f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=W6PAbytqgoIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bpkUmt_rH-IA:10 a=26UNjcSdM5vJxEUXTMQA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364492646.10629.1.camel@gandalf.local.home>
Subject: Re: [BUG] Crash with NULL pointer dereference in bond_handle_frame
 in -rt (possibly mainline)
From: Steven Rostedt <rostedt@goodmis.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Jiri Pirko <jpirko@redhat.com>, Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Thu, 28 Mar 2013 13:44:06 -0400
In-Reply-To: <1364491792.15753.47.camel@edumazet-glaptop>
References: <1364490997.6345.237.camel@gandalf.local.home>
	 <1364491792.15753.47.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-03-28 at 10:29 -0700, Eric Dumazet wrote:

> Nothing :(
> 
> bug introduced in commit 35d48903e9781975e823b359ee85c257c9ff5c1c
> (bonding: fix rx_handler locking)
> 
> CC Jiri
> 
> Fix seems simple :
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 6bbd90e..7956ca5 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -1457,6 +1457,8 @@ static rx_handler_result_t bond_handle_frame(struct sk_buff **pskb)
>  	*pskb = skb;
>  
>  	slave = bond_slave_get_rcu(skb->dev);
> +	if (!slave)
> +		return ret;

Thanks! That's basically what I thought, but wanted to make sure there's
wasn't some other synchronization that I may have been missing.

-- Steve

>  	bond = slave->bond;
>  
>  	if (bond->params.arp_interval)
> 
> 


