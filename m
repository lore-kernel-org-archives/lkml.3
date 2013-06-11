Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3FKHcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:32:52 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:44699 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab3FKHcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:32:50 -0400
Message-ID: <1370935964.3252.24.camel@edumazet-glaptop>
Subject: Re: [PATCH v10 net-next 0/6] net: low latency Ethernet device
 polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, jesse.brandeburg@intel.com,
        donald.c.skidmore@intel.com, e1000-devel@lists.sourceforge.net,
        willemb@google.com, bhutchings@solarflare.com, andi@firstfloor.org,
        hpa@zytor.com, eilong@broadcom.com, or.gerlitz@gmail.com,
        amirv@mellanox.com, eliezer@tamir.org.il
Date: Tue, 11 Jun 2013 00:32:44 -0700
In-Reply-To: <51B6C87B.70101@linux.intel.com>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
	 <20130610.134116.1913599114372510768.davem@davemloft.net>
	 <51B68AA6.1050105@linux.intel.com>
	 <20130610.212443.1096102996038709384.davem@davemloft.net>
	 <51B6C87B.70101@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 09:49 +0300, Eliezer Tamir wrote:

> I would like to hear opinions on what needs to be added to make this
> feature complete.
> 
> The list I have so far is:
> 1. add a socket option

Yes, please. I do not believe all sockets on the machine are candidate
for low latency. In fact very few of them should be, depending on the
number of cpu and/or RX queues.

> 2. support for poll/select

As long as the cost of llpoll is bounded per poll()/select() call it
will be ok.

> 3. support for epoll

For this one, I honestly do not know how to proceed.

epoll Edge Trigger model is driven by the wakeups events.

The wakeups come from frames being delivered by the NIC (for UDP/TCP
sockets)

If epoll_wait() has to scan the list of epitem to be able to perform the
llpoll callback, it will be too slow : We come back to poll() model,
with O(N) execution time.

Ideally we would have to callback llpoll not from the tcp_poll(), but
right before putting current thread in wait mode.

> 
> Also, would you accept a trailing whitespace cleanup patch for
> fs/select.c?

This has to be submitted to lkml



