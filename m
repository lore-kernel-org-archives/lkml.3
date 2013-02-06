Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab3BFQ6w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:58:52 -0500
Received: from mail.candelatech.com ([208.74.158.172]:59215 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716Ab3BFQ6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:58:50 -0500
Message-ID: <51128BC3.40304@candelatech.com>
Date: Wed, 06 Feb 2013 08:58:43 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: Question on lockdep and MAX_LOCK_DEPTH
References: <5111AD8D.1080005@candelatech.com>     <20130206015430.GA9161@home.goodmis.org>    <5111BF51.5010607@candelatech.com>    <1360119124.2621.37.camel@gandalf.local.home>    <5111CE60.4080403@candelatech.com>   <1360125419.2621.39.camel@gandalf.local.home>   <5111F6F6.7010402@candelatech.com>  <1360156888.2621.42.camel@gandalf.local.home>  <51127D15.7080503@candelatech.com> <1360166840.2621.45.camel@gandalf.local.home>
In-Reply-To: <1360166840.2621.45.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2013 08:07 AM, Steven Rostedt wrote:
> On Wed, 2013-02-06 at 07:56 -0800, Ben Greear wrote:
>
>>> I'm 99% sure that the bug is in your modifications.
>>
>> I'm sorry, I tried to make that clear.
>
> You said it was an out of tree module, I didn't realize it had changes
> to the core Linux as well.
>
>
>> My tree is here, minus a few debugging patches related to this bug:
>>
>> http://dmz2.candelatech.com/git/gitweb.cgi?p=linux-3.7.dev.y/.git;a=summary
>
> Here's your bug:
>
> 3319         list_for_each_entry_rcu(ptype, &ptype_all, list) {
> 3320                 if (!ptype->dev || ptype->dev == skb->dev) {
> 3321                         if (pt_prev) {
> 3322                                 ret = deliver_skb(skb, pt_prev, orig_dev);
> 3323                                 if (ret == NET_RX_CONSUMED) {
> 3324                                         kfree_skb(skb); /* we made a copy in deliver_skb */
> 3325                                         goto out;
> 3326                                 }
> 3327                         }
>
> One of many. All those "goto out;"s skip the rcu_read_unlock().

Thank you so much!

I'll fix this and continue testing...

I can also post a patch to print the held locks when
the max-lock-depth overflows unless someone else prefers
to...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

