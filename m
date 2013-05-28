Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933120Ab3E1G3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 02:29:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933008Ab3E1G3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 02:29:46 -0400
Message-ID: <1369722552.5857.72.camel@marge.simpson.net>
Subject: Re: [PATCH v2] sched: wake-affine throttle
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 28 May 2013 08:29:12 +0200
In-Reply-To: <51A43A63.4090703@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
	 <519AE7F2.706@linux.vnet.ibm.com>
	 <20130522084947.GQ26912@twins.programming.kicks-ass.net>
	 <519C8F24.5060207@linux.vnet.ibm.com>
	 <1369234551.5916.40.camel@marge.simpson.net>
	 <51A43A63.4090703@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:NwYwyT89GujaDq7iNmjpDNvfjbNB35fuOyJTTnWfPve
 NOgPk+WFsulW2eK6Q/w2tCT3K4LklwzG6o3ojGsdxESHNxlKWP
 DzVaYboZW0NAvUxdCim0Bv7BBw6TCjJh0YpzP/7iOHt3ZJzCk9
 dqM2MpYgLPxHFAvsyq34ds0qD4fAaRahm0t915WW5FtdR5RL0+
 b8ibNW/2GYgKUOZorCDYxG2p/3kJ5aiuO9/9PCVjd91Nitk9Zs
 bTm7Stzhqpa4NGHCGfllL5lCxhSnCh0RH76JjeSuhWsffRpUGl
 YrdXIFXg2J6qyq+J+lMIOAVZV5uaE2++FXwMRi+eRhV20S6Dun
 D2Z6U0XkNtMEWb8GpR1oVmlEmDbgyinkglaxsWh+d0kETY+GKv
 Z9gqkd+jFG/aw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 13:02 +0800, Michael Wang wrote: 
> On 05/22/2013 10:55 PM, Mike Galbraith wrote:
> > On Wed, 2013-05-22 at 17:25 +0800, Michael Wang wrote:
> > 
> >> I've not test the hackbench with wakeup-buddy before, will do it this
> >> time, I suppose the 15% illegal income will suffered, anyway, it's
> >> illegal :)
> > 
> > On a 4 socket 40 core (+SMT) box, hackbench wasn't too happy.
> 
> I've done more test and now I got the reason of regression...
> 
> The writer and reader in hackbench is N:N, prev writer will write all
> the fd then switch to next writer and repeat the same work, so it's
> impossible to setup the buddy relationship by just record the last one,
> and we have to record all the waker/wakee in history, but that means
> unacceptable memory overhead...

Yeah, that's why I was thinking we'd need a dinky/fast as hell FIFO of
tokens or such to bind waker/wakee more or less reliably.  Making such a
scheme cheap enough could be hard.

> So this buddy idea seems to be bad...
> 
> I think a better way may should be allowing pull in most time, but
> filter the very bad cases carefully.

Any way that is cheap, and fairly accurately recognizes when we're being
stupid will help.  First and foremost, it has to be dirt cheap :)

> For workload like pgbench, we actually just need to avoid pull if that
> will damage the 'mother' thread, which is busy and be relied by many
> 'child'.

Yeah, 'mom' is the key player.  If we can cheaply recognize mom, that
should get us a generic improvement.  Not as good as being able to
recognize the size of her+brood as size changes, but better anyway.

-Mike

