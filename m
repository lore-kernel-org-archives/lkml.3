Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaDNRtK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:49:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56649 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbaDNRtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:49:03 -0400
Date: Mon, 14 Apr 2014 13:49:01 -0400 (EDT)
Message-Id: <20140414.134901.2191404761213317963.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397497204.4222.28.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1397495549.4222.26.camel@edumazet-glaptop2.roam.corp.google.com>
	<20140414.133417.308357592624654107.davem@davemloft.net>
	<1397497204.4222.28.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 14 Apr 2014 10:49:03 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 14 Apr 2014 10:40:04 -0700

> On Mon, 2014-04-14 at 13:34 -0400, David Miller wrote:
>> From: Eric Dumazet <eric.dumazet@gmail.com>
>> Date: Mon, 14 Apr 2014 10:12:29 -0700
>> 
>> > Hmm, it seems commit 31c70d5956fc l2tp: keep original skb ownership
>> > is the problem.
>> > 
>> > ip_queue_xmit() assumes the socket attached to skb is an inet socket.
>> 
>> This is similar to the "send over AF_PACKET" issue we were discussing
>> the other week.
>> 
>> It seems we need a real resolution to this issue.
>> 
>> To recap:
>> 
>> 1) We want to charge memory to the top-level socket.
>> 
>> 2) However during encapsulations etc. we can end up in IP stack
>>    which expects only IP sockets to be attached to skb->sk
>> 
>> I suspect that in the short term we may have to bit the bullet and
>> compromise #2, and do flow control via the tunnel's socket.
> 
> Or add a sk parameter to ip_queue_xmit(), to break the assumption "sk =
> skb->sk", which happened to be generally true, but is ambiguous for IP
> tunnels.

Yep that would handle the l2tp cases, but vxlan needs something different
since it goes through iptunnel_xmit().

So perhaps as a quick fix we can add an 'sk' arg to both
ip_queue_xmit() and ip_local_out().
