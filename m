Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab3FENl4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:41:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:20480 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab3FENly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:41:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,806,1363158000"; 
   d="scan'208";a="250985641"
Message-ID: <51AF401C.2030506@linux.intel.com>
Date: Wed, 05 Jun 2013 16:41:48 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v9 net-next 5/7] net: simple poll/select low latency socket
 poll
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>  <20130605103452.11172.31453.stgit@ladj378.jer.intel.com> <1370439054.24311.248.camel@edumazet-glaptop>
In-Reply-To: <1370439054.24311.248.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 16:30, Eric Dumazet wrote:
> On Wed, 2013-06-05 at 13:34 +0300, Eliezer Tamir wrote:
>> A very naive select/poll busy-poll support.
>> Add busy-polling to sock_poll().
>> When poll/select have nothing to report, call the low-level
>> sock_poll() again until we are out of time or we find something.
>> Right now we poll every socket once, this is suboptimal
>> but improves latency when the number of sockets polled is not large.
>>
>> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
>> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
>> Tested-by: Willem de Bruijn <willemb@google.com>
>> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
>> ---
>
> I am a bit uneasy with this one, because an applicatio polling() on one
> thousand file descriptors using select()/poll(), will call sk_poll_ll()
> one thousand times.

But we call sk_poll_ll() with nonblock set, so it will only test once
for each socket and not loop.

I think this is not as bad as it sounds.
We still honor the time limit on how long to poll.

When we busy-wait on a single socket we call sk_poll_ll() repeatedly
until we timeout or we have something to report.

Here on the other hand, we sk_poll_ll() once for each file, so we loop 
on the files. We moved the loop from inside sk_poll_ll to select/poll.

I also plan on improving this this in the next stage.

The plan is to give control on whether sk_poll_ll is called to
select/poll/epoll, so the caller has even more control.

-Eliezer


