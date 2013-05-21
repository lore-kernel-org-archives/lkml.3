Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab3EUMH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:07:58 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:42487 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753226Ab3EUMH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:07:56 -0400
Message-ID: <519B632F.7040202@mellanox.com>
Date: Tue, 21 May 2013 15:06:07 +0300
From: Alex Rosenbaum <alexr@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Dave Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v3 net-next 0/4] net: low latency Ethernet device polling
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
In-Reply-To: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.222.66.109]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2013 1:15 PM, Eliezer Tamir wrote:
> updated with the comments I got so far.
>
> Thanks,
> Eliezer
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hello Eliezer,

I am working in Mellanox on a low latency user space offload technology 
and there are some similarities between the user space and your kernel 
implementation.

We have experience in similar ‘infinite polling’ issues in respect to 
the real applications.

I am coming in a little late here but wanted to check that:

1. It seem this patch does not cover epoll/select and such IO muxing APIs?

Most real application will be based on epoll or select, not like netperf 
which is a simple send/recv per thread based network test. If you take 
memcached application you have epoll per thread with few sockets in each 
running on each core.

In the IO mux cases you need to poll multiple driver rings while also 
polling other non-network fd’s (files, pipes,..) and not to hurt their 
latency response.

2. How is the logic aware of RSS and RFS?

With TCP sockets, the driver knows the specific ring it need to poll so 
this should be mapped and provide the best latency.

For UDP (unicast and multicast) you can have all rings delivering 
packets to a single receive socket, is ndo_ll_poll expected to scan 
driver rings?

3. I could not find any reference to multi-thread on single core logic. 
This can causes the opposite effect and create contentions and higher 
latency’s.

Maybe you should ref_count the number of threads per core going into 
ndo_ll_poll. If the second+ threads want to go down to ndo_ll_poll you 
should block (sleep) them instead of creating contention.

In this mode at least the first thread will get very good latency and 
the others will not get hurt.

Or if they move to a different core they should go down to the driver 
for polling the ring.

Thanks,

Alex Rosenbaum

Director R&D Application Acceleration

Mellanox Technologies

