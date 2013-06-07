Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067Ab3FGFmt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:42:49 -0400
Received: from git.silcnet.org ([81.89.56.81]:58506 "EHLO git.silcnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971Ab3FGFmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:42:47 -0400
Date: Fri, 7 Jun 2013 07:23:21 +0200 (CEST)
From: Pekka Riikonen <priikone@iki.fi>
X-X-Sender: priikone@git.silcnet.org
To: Tejun Heo <tj@kernel.org>
cc: greearb@candelatech.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH v3] Fix lockup related to stop_machine being stuck in
 __do_softirq.
In-Reply-To: <20130606214014.GK5045@htj.dyndns.org>
Message-ID: <alpine.GSO.2.00.1306070717400.20297@git.silcnet.org>
References: <1370554189-31432-1-git-send-email-greearb@candelatech.com> <20130606214014.GK5045@htj.dyndns.org>
User-Agent: Alpine 2.00 (GSO 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Jun 2013, Tejun Heo wrote:

> On Thu, Jun 06, 2013 at 02:29:49PM -0700, greearb@candelatech.com wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The stop machine logic can lock up if all but one of
>> the migration threads make it through the disable-irq
>> step and the one remaining thread gets stuck in
>> __do_softirq.  The reason __do_softirq can hang is
>> that it has a bail-out based on jiffies timeout, but
>> in the lockup case, jiffies itself is not incremented.
>>
>> To work around this, re-add the max_restart counter in __do_irq
>> and stop processing irqs after 10 restarts.
>>
>> Thanks to Tejun Heo and Rusty Russell and others for
>> helping me track this down.
>>
>> This was introduced in 3.9 by commit:  c10d73671ad30f5469
>> (softirq:  reduce latencies).
>>
>> It may be worth looking into ath9k to see if it has issues with
>> it's irq handler at a later date.
>>
>> The hang stack traces look something like this:
> ...
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> Linus, while this doesn't fix the root cause of the problem - softirq
> runaway - I still think this is a worthwhile protection to have.  Ben
> is in the process of finding out why the softirq runaway happens in
> the first place.  We probably want to add Cc: stable@vger.kernel.org
> tag.
>
The counter also helps to keep the interrupted task interrupted a shorter 
period of time.  10 iterations may be a lot shorter than the 2 ms, or 10 
ms with HZ=100, so it helps interactivity also.  This is a good change 
to bring back in any case.

 	Pekka
