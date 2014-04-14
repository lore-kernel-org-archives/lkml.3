Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaDNTW3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:22:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57764 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaDNTW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:22:27 -0400
Date: Mon, 14 Apr 2014 15:22:25 -0400 (EDT)
Message-Id: <20140414.152225.1983723140136958968.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397502396.4222.45.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1397499566.4222.36.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140414.144843.488522666550066271.davem@davemloft.net>
	<1397502396.4222.45.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 12:22:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Apr 2014 12:06:36 -0700

> On Mon, 2014-04-14 at 14:48 -0400, David Miller wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Mon, 14 Apr 2014 11:19:26 -0700
>> 
>> > ip_local_out() doesn't use skb->sk
>> 
>> It does Eric.
>> 
> 
> Hmmm, right...
> 
>> We had just such a report with this in the backtrace, when AF_PACKET
>> sends over vxlan devices.
>> 
>> The problem is ip_mc_output().
> 
> So this means that : User socket wanted sk_mc_loop(sk), but because
> vxlan changed skb->sk to internal socket, we were doing something else
> anyway.

Actually the exact opposite is happening.  vxlan does not override skb->sk,
and leaves it as AF_PACKET's socket.  Then we crash in ip_mc_output() because
it only expects IP sockets, not AF_PACKET ones, attached to skb->sk.

> There are a lot of undocumented features here... like
> 
>  	skb->priority = sk->sk_priority;
>  	skb->mark = sk->sk_mark;
> 
> which socket do we want here (in ip_queue_xmit()) ?

Probably that of tunnel.

> Its interesting to see ip6_xmit() already has a 'struct sock *sk'
> parameter...
> 
> This was the preliminary patch I tested :

You still need to make similar transformation to ip_local_out() as mentioned
above.
