Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab3ALICF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 03:02:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:57657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab3ALICD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 03:02:03 -0500
Message-ID: <1357977704.6796.47.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Sat, 12 Jan 2013 09:01:44 +0100
In-Reply-To: <50ED384C.1030301@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:rrqlcLcPIdlilrr5Jxo2NZFdih1FQnKviHZzBSpZc8U
 rk0yY2Z/8tX0ux8Bqjq6y9tAo2v2nSWaXjtpZdNhMSYmqvUJm2
 YBlCD9ZDbTrck1CFm0lDamnj+INfuWPdcXjnQxRquSkjzFX8lt
 XeFX1cSg6/voP3Y+VVUcldexV1FTK4ty24EBTY4w+F5bforu+u
 sNEwdL4WWZut2WNYSfLmo32h41SC0Bibx/RqJYFYvnB+LkZe3w
 XzlqTOUR/LKHtFfkdau1CyuV6+DQJ4DmSPoiLISU6VtTjHNst+
 KUtc4SdUiKY4hVp5SD5BGH9CVQLV4bQUq6K2vdILuIf0bfoDPk
 i6LzWzAUSnTK+6XTCTYeetFwJTVm02BYWzC7qNupgJSDxQ88rB
 7IzyAtOUi6SHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 17:28 +0800, Michael Wang wrote: 
> On 12/27/2012 02:08 PM, Michael Wang wrote:
> > This patch set is trying to simplify the select_task_rq_fair() with
> > schedule balance map.
> > 
> > After get rid of the complex code and reorganize the logical, pgbench show
> > the improvement.
> > 
> > 	Prev:
> > 		| db_size | clients |  tps  |
> > 		+---------+---------+-------+
> > 		| 22 MB   |       1 |  4437 |
> > 		| 22 MB   |      16 | 51351 |
> > 		| 22 MB   |      32 | 49959 |
> > 		| 7484 MB |       1 |  4078 |
> > 		| 7484 MB |      16 | 44681 |
> > 		| 7484 MB |      32 | 42463 |
> > 		| 15 GB   |       1 |  3992 |
> > 		| 15 GB   |      16 | 44107 |
> > 		| 15 GB   |      32 | 41797 |
> > 
> > 	Post:
> > 		| db_size | clients |  tps  |
> > 		+---------+---------+-------+
> > 		| 22 MB   |       1 | 11053 |		+149.11%
> > 		| 22 MB   |      16 | 55671 |		+8.41%
> > 		| 22 MB   |      32 | 52596 |		+5.28%
> > 		| 7483 MB |       1 |  8180 |		+100.59%
> > 		| 7483 MB |      16 | 48392 |		+8.31%
> > 		| 7483 MB |      32 | 44185 |		+0.18%
> > 		| 15 GB   |       1 |  8127 |		+103.58%
> > 		| 15 GB   |      16 | 48156 |		+9.18%
> > 		| 15 GB   |      32 | 43387 |		+3.8%
> > 
> > Please check the patch for more details about schedule balance map, they
> > currently based on linux-next 3.7.0-rc6, will rebase them to tip tree in
> > follow version.
> > 
> > Comments are very welcomed.
> 
> Could I get some comments for this patch set?

I kinda like it.  It doesn't bounce buddies all over a large package at
low load, doesn't have a tbench dip at clients=cores with HT enabled
that my idle buddy patch does, and your pgbench numbers look very nice.
It's not as good at ramp as idle buddies, but is an improvement over
mainline for both tbench and pgbench.  Cool.

It'll schedule client/server cross node sometimes with you preferring to
leave wakee near prev_cpu, but that's one of those things that can bite
whichever choice you make.  It kills the bounce problem, can't hurt
little boxen, and may help big boxen more often than it hurts, who
knows.

Some tbench numbers:

I had to plug it into 3.0 to play with it, the 3.6-stable kernel I had
been using on 4x10 core box is misbehaving.

mainline = upstream select_idle_sibling()
idle_buddy = upstream select_idle_sibling() with 37407ea7 reverted

clients                    1          5         10        20         40         80        160
3.0.57-mainline        30.76     146.29    1569.48   4396.10    7851.87   14065.90   14128.40
3.0.57-idle_buddy     291.69    1448.13    2874.62   5329.49    7311.44   13582.20   13927.50
3.0.57-mainline+wang  292.41    1085.70    2048.62   4342.16    8280.17   13494.60   13435.50

It'd be nice to see more numbers, likely there will be plus/minus all
the map, but from my quick test drive, generic behavior looks healthier.

-Mike

