Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaJ0BIR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:08:17 -0400
Received: from numascale.com ([213.162.240.84]:56369 "EHLO numascale.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbaJ0BIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:08:16 -0400
Message-ID: <544D9AF7.2080206@numascale.com>
Date: Mon, 27 Oct 2014 09:08:07 +0800
From: Daniel J Blueman <daniel@numascale.com>
Organization: Numascale AS
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Steffen Persvold <sp@numascale.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: RCU fanout leaf balancing
References: <544B4A4C.5070807@numascale.com> <20141025134835.GD28247@linux.vnet.ibm.com>
In-Reply-To: <20141025134835.GD28247@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cpanel21.proisp.no
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - numascale.com
X-Get-Message-Sender-Via: cpanel21.proisp.no: authenticated_id: daniel@numascale.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/10/2014 21:48, Paul E. McKenney wrote:
> On Sat, Oct 25, 2014 at 02:59:24PM +0800, Daniel J Blueman wrote:
>> Hi Paul,
>>
>> Finding earlier reference to increasing RCU fanout leaf for the
>> purpose of "decrease[ing] cache-miss overhead for large systems",
>> would your suggestion be to increase the value to the next hierarchy
>> core-count above 16?
>>
>> If we have say 32 interconnected 48-core servers; 3 sockets of
>> dual-node 8-core Opteron 6300s, so 1536 cores in all. Latency across
>> the coherent interconnect is O(100x) higher than the internal
>> Hypertransport interconnect, so if we set RCU_FANOUT_LEAF to 48 to
>> keep leaf-checking local to one Hypertransport fabric, what wisdom
>> would one use for RCU_FANOUT? 4x leaf?
>>
>> Or, would it be more cache-friendly to set RCU_FANOUT_LEAF to 8 and
>> RCU_FANOUT to 48?
>
> The easiest approach would be to use the default of 16.  Assuming
> consecutive CPU numbering within each 48-core server, this would mean that
> you would have three rcu_node structures per 48-core server.  The next
> level up would of course span servers, but that level is accessed much
> less frequently than is the root level, so this should still work.
>
> If you also have hyperthreading, so that there are 96 hardware threads
> per server, and if you are using the same "interesting" numbering scheme
> that Intel uses, then this still works.  You have three leaf rcu_node
> structure for the first set of hardware threads and another set of three
> for the second set of hardware threads.
>
> Or are you seeing some problem with the default?  If so, please tell me
> what that problem is.
>
> You can of course increase RCU_FANOUT to 24 or 48 (this latter assuming
> a 64-bit kernel), at least if you are using a recent kernel.  However,
> the penalty for too large a value for RCU_FANOUT is lock contention at
> scheduling-clock-interrupt time.  So if you are setting RCU_FANOUT to 48,
> you probably also want to boot with skew_tick set.
>
> But the best approach is to try it.  I bet that the default will work
> just fine for you.  ;-)

Good info. I'll stick with the defaults of 16/64, will schedule some 
tuning later, and let you know if I find anything significant.

Thanks Paul!

Daniel
-- 
Daniel J Blueman
Principal Software Engineer, Numascale
