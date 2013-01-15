Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab3AOCrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 21:47:08 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37413 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673Ab3AOCrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 21:47:06 -0500
Message-ID: <50F4C31F.9030503@linux.vnet.ibm.com>
Date: Tue, 15 Jan 2013 10:46:55 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net>
In-Reply-To: <1357977704.6796.47.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011502-9264-0000-0000-000002FF8E56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2013 04:01 PM, Mike Galbraith wrote:
> On Wed, 2013-01-09 at 17:28 +0800, Michael Wang wrote: 
>> On 12/27/2012 02:08 PM, Michael Wang wrote:
>>> This patch set is trying to simplify the select_task_rq_fair() with
>>> schedule balance map.
>>>
>>> After get rid of the complex code and reorganize the logical, pgbench show
>>> the improvement.
>>>
>>> 	Prev:
>>> 		| db_size | clients |  tps  |
>>> 		+---------+---------+-------+
>>> 		| 22 MB   |       1 |  4437 |
>>> 		| 22 MB   |      16 | 51351 |
>>> 		| 22 MB   |      32 | 49959 |
>>> 		| 7484 MB |       1 |  4078 |
>>> 		| 7484 MB |      16 | 44681 |
>>> 		| 7484 MB |      32 | 42463 |
>>> 		| 15 GB   |       1 |  3992 |
>>> 		| 15 GB   |      16 | 44107 |
>>> 		| 15 GB   |      32 | 41797 |
>>>
>>> 	Post:
>>> 		| db_size | clients |  tps  |
>>> 		+---------+---------+-------+
>>> 		| 22 MB   |       1 | 11053 |		+149.11%
>>> 		| 22 MB   |      16 | 55671 |		+8.41%
>>> 		| 22 MB   |      32 | 52596 |		+5.28%
>>> 		| 7483 MB |       1 |  8180 |		+100.59%
>>> 		| 7483 MB |      16 | 48392 |		+8.31%
>>> 		| 7483 MB |      32 | 44185 |		+0.18%
>>> 		| 15 GB   |       1 |  8127 |		+103.58%
>>> 		| 15 GB   |      16 | 48156 |		+9.18%
>>> 		| 15 GB   |      32 | 43387 |		+3.8%
>>>
>>> Please check the patch for more details about schedule balance map, they
>>> currently based on linux-next 3.7.0-rc6, will rebase them to tip tree in
>>> follow version.
>>>
>>> Comments are very welcomed.
>>
>> Could I get some comments for this patch set?
> 
> I kinda like it.  It doesn't bounce buddies all over a large package at
> low load, doesn't have a tbench dip at clients=cores with HT enabled
> that my idle buddy patch does, and your pgbench numbers look very nice.
> It's not as good at ramp as idle buddies, but is an improvement over
> mainline for both tbench and pgbench.  Cool.
> 
> It'll schedule client/server cross node sometimes with you preferring to
> leave wakee near prev_cpu, but that's one of those things that can bite
> whichever choice you make.  It kills the bounce problem, can't hurt
> little boxen, and may help big boxen more often than it hurts, who
> knows.
> 
> Some tbench numbers:
> 
> I had to plug it into 3.0 to play with it, the 3.6-stable kernel I had
> been using on 4x10 core box is misbehaving.

Hi, Mike

Thanks for your reply and test results.

> 
> mainline = upstream select_idle_sibling()
> idle_buddy = upstream select_idle_sibling() with 37407ea7 reverted
> 
> clients                    1          5         10        20         40         80        160
> 3.0.57-mainline        30.76     146.29    1569.48   4396.10    7851.87   14065.90   14128.40
> 3.0.57-idle_buddy     291.69    1448.13    2874.62   5329.49    7311.44   13582.20   13927.50
> 3.0.57-mainline+wang  292.41    1085.70    2048.62   4342.16    8280.17   13494.60   13435.50
> 
> It'd be nice to see more numbers, likely there will be plus/minus all
> the map, but from my quick test drive, generic behavior looks healthier.

It's good to know that you like the idea, I will re-base the code on
latest tip tree and do more test on it.

Regards,
Michael Wang

> 
> -Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

