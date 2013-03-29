Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3C2Pqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 11:46:47 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:50044 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187Ab3C2Pqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 11:46:46 -0400
Date: Fri, 29 Mar 2013 08:46:32 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jiri Pirko <jpirko@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?B?UGVzbG/8YW4=?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [BUG] Crash with NULL pointer dereference in bond_handle_frame
 in -rt (possibly mainline)
Message-ID: <20130329084632.469ec44d@nehalam.linuxnetplumber.net>
In-Reply-To: <20130329094856.GB1677@minipsycho.orion>
References: <1364490997.6345.237.camel@gandalf.local.home>
	<1364491792.15753.47.camel@edumazet-glaptop>
	<20130329094856.GB1677@minipsycho.orion>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Mar 2013 10:48:56 +0100
Jiri Pirko <jpirko@redhat.com> wrote:

> index 0caa38e..c16b829 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3332,8 +3332,8 @@ void netdev_rx_handler_unregister(struct net_device *dev)
>  {
>  
>  	ASSERT_RTNL();
> -	RCU_INIT_POINTER(dev->rx_handler, NULL);
> -	RCU_INIT_POINTER(dev->rx_handler_data, NULL);
> +	rcu_assign_pointer(dev->rx_handler, NULL);
> +	rcu_assign_pointer(dev->rx_handler_data, NULL);
>  }
>  EXPORT_SYMBOL_GPL(netdev_rx_handler_unregister);
It is worth noting that at the time rcu_assign_pointer() had a special
case tat if the value was NULL it would compile into RCU_INIT_POINTER without
the barrier.
