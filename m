Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597AbaICGtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 02:49:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:8546 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaICGtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 02:49:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,455,1406617200"; 
   d="scan'208";a="585481693"
Message-ID: <5406B9E6.6050103@linux.intel.com>
Date: Wed, 03 Sep 2014 09:49:10 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Jason Wang <jasowang@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <53F6F14B.1030609@redhat.com> <20140822074224.GB7372@gmail.com> <53FFEEC0.4000304@redhat.com> <540414AB.9000004@linux.intel.com> <54053998.4040604@redhat.com> <54056076.2030603@linux.intel.com> <20140902083124.GB10356@redhat.com>
In-Reply-To: <20140902083124.GB10356@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 11:31, Michael S. Tsirkin wrote:
> On Tue, Sep 02, 2014 at 09:15:18AM +0300, Eliezer Tamir wrote:
>> On 02/09/2014 06:29, Jason Wang wrote:
>>> On 09/01/2014 02:39 PM, Eliezer Tamir wrote:
>>>> On 29/08/2014 06:08, Jason Wang wrote:
>>>>>> Yes, but rx busy polling only works in process context and does not
>>>>>> disable bh, so it may be not an issue.
>>>> sk_busy_loop() uses rcu_read_lock_bh(), so it does run with bh disabled.
>>>
>>> True, so we need probably also exit the loop when there are pending bhs.
>>
>> I'm not so sure, in the typical busy poll scenario, the incoming
>> traffic is the most time-critical thing in the system.
>> It's so important that you are willing to trade lots of CPU power
>> for better latency. The user has decided that he wants to dedicate
>> this CPU mostly for that. This is not something that plays nice with
>> other apps, but this is what the user wants.
> 
> I think most applications wouldn't interpret this flag as "burn up CPU I don't
> care what is the result", what apps want is more of "maximise throughput
> and minimise latency even if throughput/CPU ratio goes down".
> Jason posted benchmarks that show throughput going up because other
> processes get more of a chance to run, so this seems consistent
> with that goal.

Busy polling is not a general purpose feature, it's not something you
can casually turn on and will "just work". Most applications should not
be using busy polling. Currently it is used by multiserver applications
that you spend days tuning to specific platforms.

What the user wants is to lower both avg and maximum latencies, at the
expense of everything else including power efficiency and sometimes
even throughput. The only exception is making the system crash ;)

While letting other things take precedence over busy polling might not
hurt the avg latency much, it will kill your maximum latency.

-Eliezer
