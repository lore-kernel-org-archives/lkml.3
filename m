Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3C2QqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:46:05 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:58629 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3C2QqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:46:03 -0400
Message-ID: <1364575560.5113.45.camel@edumazet-glaptop>
Subject: Re: [PATCH] net: add a synchronize_net() in
 netdev_rx_handler_unregister()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Ivan Vecera <ivecera@redhat.com>, Jiri Pirko <jpirko@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Nicolas de =?ISO-8859-1?Q?Peslo=FCan?= 
	<nicolas.2p.debian@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Guy Streeter <streeter@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>, stephen@networkplumber.org
Date: Fri, 29 Mar 2013 09:46:00 -0700
In-Reply-To: <20130329161219.GA1668@minipsycho.orion>
References: <1364490997.6345.237.camel@gandalf.local.home>
	 <1364491792.15753.47.camel@edumazet-glaptop>
	 <20130329094856.GB1677@minipsycho.orion>
	 <1364562082.5113.16.camel@edumazet-glaptop> <5155AF24.3090305@redhat.com>
	 <1364571495.5113.23.camel@edumazet-glaptop>
	 <20130329161219.GA1668@minipsycho.orion>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-03-29 at 17:12 +0100, Jiri Pirko wrote:
> Fri, Mar 29, 2013 at 04:38:15PM CET, eric.dumazet@gmail.com wrote:
> >On Fri, 2013-03-29 at 16:11 +0100, Ivan Vecera wrote:
> >
> >> Erik, why doesn't help the write barrier between the assignments. It 
> >> should guarantee their orders... or not?
> >> 
> >
> >Its not enough, I wont explain here why as RCU is quite well documented
> >in Documentation/RCU
> 
> Can you point me exact paragraph? I'm unable to find that :(
> 

You need a bit of RCU history to understand the issue

rcu_assign_pointer(dev->rx_handler, NULL) is certainly not needing a
barrier _before_ setting rx_handler to NULL.

Old kernels had this rcu_assign_pointer() implementation since
commit d99c4f6b13b3149bc83703ab1493beaeaaaf8a2d 
(Remove rcu_assign_pointer() penalty for NULL pointers)

#define rcu_assign_pointer(p, v) \
	({ \
		if (!__builtin_constant_p(v) || \
		    ((v) != NULL)) \
			smp_wmb(); \
		(p) = (v); \
	})

Note that wmb() was _not_ done if v was NULL


Because of various sparse issues, commit
d322f45ceed525daa9401154590bbae3222cfefb
(rcu: Make rcu_assign_pointer() unconditionally insert a memory barrier)
removed the conditional, because RCU_INIT_POINTER() was available.

In the rx_handler/rx_handler_data, we use two pointers protected by RCU,
but we want to only test rx_hander being NULL, and avoid testing
rx_handler_data.

Nothing in RCU guarantees that two different pointers have any order.

Here is what could happen

CPU0                                      CPU1

handler = rcu_dereference(dev->rx_handler)
if (handler) {
   handler(dev, ...);

                                          dev->rx_handler = NULL;
                                          smp_wmb(); // OR NOT
                                          dev->rx_handler_data = NULL;
                                          smp_wmb(); // OR NOT
 handler(dev)
   priv_data = rcu_dereference(dev->rx_handler_data);
   x = priv_data->some_field;   // CRASH because priv_data is NULL



