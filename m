Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaIBGEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:04:41 -0400
Received: from mga14.intel.com ([192.55.52.115]:50099 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbaIBGEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:04:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,447,1406617200"; 
   d="scan'208";a="474552897"
Message-ID: <54055D9F.7000108@linux.intel.com>
Date: Tue, 02 Sep 2014 09:03:11 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>,
        "Ingo Molnar jacob.e.keller@intel.com" <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com>	 <1408608310-13579-2-git-send-email-jasowang@redhat.com>	 <1408683665.5648.69.camel@marge.simpson.net>	 <20140822073653.GA7372@gmail.com> <53F70887.8030602@redhat.com> <1408716976.5604.18.camel@edumazet-glaptop2.roam.corp.google.com> <53FB3715.7070009@linux.intel.com> <53FC3466.8000304@redhat.com> <5404186E.4090409@linux.intel.com> <54053AF8.6070907@redhat.com>
In-Reply-To: <54053AF8.6070907@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 06:35, Jason Wang wrote:
> On 09/01/2014 02:55 PM, Eliezer Tamir wrote:
>> On 26/08/2014 10:16, Jason Wang wrote:
>>> On 08/25/2014 09:16 PM, Eliezer Tamir wrote:

>> Think about the case where two processes are busy polling on the
>> same CPU and the same device queue. Since busy polling processes
>> incoming packets on the queue from any process, this scenario works
>> well currently,
> 
> I see, but looks like we can simply do this by exiting the busy loop
> when ndo_busy_poll() finds something but not for current socket?

I don't think there is a need for that.

When ndo_busy_poll() finds something it feeds it to the stack, which
will process the packet, just as if it came from NAPI polling.
So, if this is data that someone is blocked waiting on, the stack will
wake them up, and then you presumably can decide which app should get
the cpu.

Note, that there is no easy way to know, when looking at the
incoming traffic, whether it is important, or even if you are seeing
a full message. (Maybe you only have 9 packets out of 10?)
The only place this knowledge might exist is in the layers of the
stack closer to the user.

>>  and will not work at all when polling yields to other
>> processes that are of the same priority that are running on the same
>> CPU.
> 
>>
>> Maybe the networking subsystem should maintain a list of device
>> queues that need busypolling and have a thread that would poll
>> all of them when there's nothing better to do.
> 
> Not sure whether this method will scale considering thousands of sockets
> and processes.

There may be millions of sockets, but in most cases only a handful of
device queues per CPU to busy poll on. I have tested the epoll rfc
code with hundreds of thousands of sockets and one or two device
queues and is scales pretty well.

The part I don't like in that code is the cumbersome mechanism I used
to track the socket -> queue relationship. I think that if I had more
time to work on it, I would instead look into extending the epoll
interface so that libevent can tell the kernel what it wants, instead
of having the busypoll code try and learn it.

Cheers,
Eliezer
