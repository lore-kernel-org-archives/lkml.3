Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3HWHZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 03:25:52 -0400
Received: from mga03.intel.com ([143.182.124.21]:33162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab3HWHZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 03:25:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,939,1367996400"; 
   d="scan'208";a="285730493"
Message-ID: <52170E78.1010704@linux.intel.com>
Date: Fri, 23 Aug 2013 10:25:44 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Eric Wong <normalperson@yhbt.net>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, e1000-devel@lists.sourceforge.net,
        Eilon Greenstein <eilong@broadcom.com>,
        Amir Vadai <amirv@mellanox.com>, Eric Dumazet <erdnetdev@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH RFC net-next] net: epoll support for busy poll
References: <20130821103954.30607.6819.stgit@ladj378.jer.intel.com> <20130822201135.GA4088@dcvr.yhbt.net>
In-Reply-To: <20130822201135.GA4088@dcvr.yhbt.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/2013 23:11, Eric Wong wrote:
> Eliezer Tamir <eliezer.tamir@linux.intel.com> wrote:
>> Performance:
>> using sockperf, Intel X520 NICs,
>> Supermicro 6026TT-BTF systems with E5-2690 Xeon CPUs
>> 100 UDP sockets avg. latency 5.756 (std-dev 0.510)
>> 1k  UDP sockets avg. latency 5.780 (std-dev 0.536)
>> 10k UDP sockets avg. latency 6.269 (std-dev 0.611)
> 
> How does this compare to with normal poll on this system?
> 
> In other words, what advantage is there to using epoll instead of poll
> when busy looping?
> 
> epoll and busy_poll seem to be opposites.  epoll inherently has higher
> latency than normal poll, but provides stable performance with many more
> FDs.

I'm not sure I understand your claim that epoll has a higher latency
than poll.

Some quick (and very unscientific) testing seem to indicate that
while poll is slightly faster than epoll when polling one socket,
when polling on three sockets epoll is already slightly faster.

(what's the point of using poll if you only need to monitor one
socket?)

With a larger socket set epoll is a clear winner.

Both select and poll on 1k UDP sockets take over 120us on a similar
system.
Poll on 10 sockets takes about 6.8us, on 100 socket about 16.5us.

Note that I'm using a slightly old NIC that has a high HW latency.
For comparison, a busy poll on a socket read (using netperf) is about 5.7us.

I expect Amir is seeing better numbers, but he's not telling. ;)
