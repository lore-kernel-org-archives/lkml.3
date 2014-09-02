Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaIBGPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 02:15:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:51589 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaIBGPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 02:15:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,447,1406617200"; 
   d="scan'208";a="584904029"
Message-ID: <54056076.2030603@linux.intel.com>
Date: Tue, 02 Sep 2014 09:15:18 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, Ingo Molnar <mingo@kernel.org>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mst@redhat.com,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH net-next 2/2] net: exit busy loop when another process
 is runnable
References: <1408608310-13579-1-git-send-email-jasowang@redhat.com> <1408608310-13579-2-git-send-email-jasowang@redhat.com> <1408683665.5648.69.camel@marge.simpson.net> <53F6F14B.1030609@redhat.com> <20140822074224.GB7372@gmail.com> <53FFEEC0.4000304@redhat.com> <540414AB.9000004@linux.intel.com> <54053998.4040604@redhat.com>
In-Reply-To: <54053998.4040604@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 06:29, Jason Wang wrote:
> On 09/01/2014 02:39 PM, Eliezer Tamir wrote:
>> On 29/08/2014 06:08, Jason Wang wrote:
>>>> Yes, but rx busy polling only works in process context and does not
>>>> disable bh, so it may be not an issue.
>> sk_busy_loop() uses rcu_read_lock_bh(), so it does run with bh disabled.
> 
> True, so we need probably also exit the loop when there are pending bhs.

I'm not so sure, in the typical busy poll scenario, the incoming
traffic is the most time-critical thing in the system.
It's so important that you are willing to trade lots of CPU power
for better latency. The user has decided that he wants to dedicate
this CPU mostly for that. This is not something that plays nice with
other apps, but this is what the user wants.

So, you definitely don't want to starve any bh, and you should
regularly re-enable bh's, but you also don't want to stop everything
at any time a bh is scheduled.

You also want network processing on the queues that are busy polled
to come through busy polling and not through NAPI, which is run in bh
context.

-Eliezer
