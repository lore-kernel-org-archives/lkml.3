Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab3C2Sg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 14:36:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24356 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756522Ab3C2Sg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 14:36:27 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=W6PAbytqgoIA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=bpkUmt_rH-IA:10 a=YXbaqjE6zUTl0Ot_U0oA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1364582184.10629.34.camel@gandalf.local.home>
Subject: Re: [BUG] Crash with NULL pointer dereference in bond_handle_frame
 in -rt (possibly mainline)
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Pirko <jpirko@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, stephen@networkplumber.org
Date: Fri, 29 Mar 2013 14:36:24 -0400
In-Reply-To: <20130329094856.GB1677@minipsycho.orion>
References: <1364490997.6345.237.camel@gandalf.local.home>
	 <1364491792.15753.47.camel@edumazet-glaptop>
	 <20130329094856.GB1677@minipsycho.orion>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 10:48 +0100, Jiri Pirko wrote:

> Because, if rcu_dereference(dev->rx_handler) is null,
> rcu_dereference(dev->rx_handler_data) is never done. Therefore I believe
> we are hitting following scenario:
> 
> 
>    CPU0				CPU1
>    ----				----
>   			    dev->rx_handler_data = NULL
>  rcu_read_lock()
>  			    dev->rx_handler = NULL
> 
> 

That is not what is happening and that is not how RCU works. That is,
rcu_read_lock() does not block nor does it really do much with ordering
at all.

The problem is totally contained within the rcu_read_lock() as well:


If you have:

	rcu_read_lock();
	rx_handler = dev->rx_handler;
	rx_handler();
	rcu_read_unlock();

where rx_handler references rx->rx_handler_data you need much more than
making sure that rx->handler is set to null before rx_handler_data.

The way RCU works is it lets things exist in a "dual state". Kind of
like a Schödinger's cat. The solution Eric posted is a classic RCU
example of how this works.

When you set dev->rx_handler to NULL, there's two states that currently
exist in the system. Those that still see dev->rx_handler set to
something and those that see it set to NULL. You could put in memory
barriers to your hearts content, but you will still have a system that
sees things in a dual state. If you set dev->rx_handler_data to NULL,
you risk those that see rx_handler as a function can still reference the
rx_handler_data when it is NULL.

Think of it this way:

	dev->rx_handler() {

Once the function has been called, even if you set rx_handler() to NULL
at this point, it makes no difference, even with memory barriers. This
CPU is about to execute the previous value of rx_handler and there's
nothing you can do to stop it. Setting rx_handler_data to NULL now can
cause that CPU to reference the NULL pointer. There isn't a ordering
problem where rx_handler_data got set to NULL first.

But the beauty about RCU is the synchronize_*() functions, because that
puts the system back into a single state. After the synchronization is
complete, the entire system sees rx_handler() as NULL. There is no worry
about setting rx_handler_data to NULL now because nothing will be
referencing the previous value of rx_handler because that value no
longer exists in the system.

That means Eric's solution fits perfectly well here.

	< system in single state : everyone sees rx_handler = function() >

	rx_handler = NULL;

	< system in dual state : new calls see rx_handler = NULL, but
	  current calls see rx_handler = function >

	synchronize_net();

	< system is back to single state: everyone sees rx_handler = NULL >

	rx_handler_data = NULL;

no problem ;-)

-- Steve




