Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933666Ab3E1IuP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:50:15 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:62101 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623Ab3E1IuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:50:13 -0400
Message-ID: <1369730970.5857.132.camel@marge.simpson.net>
Subject: Re: [PATCH v2] sched: wake-affine throttle
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 28 May 2013 10:49:30 +0200
In-Reply-To: <51A45B23.4050403@linux.vnet.ibm.com>
References: <5164DCE7.8080906@linux.vnet.ibm.com>
	 <519AE7F2.706@linux.vnet.ibm.com>
	 <20130522084947.GQ26912@twins.programming.kicks-ass.net>
	 <519C8F24.5060207@linux.vnet.ibm.com>
	 <1369234551.5916.40.camel@marge.simpson.net>
	 <51A43A63.4090703@linux.vnet.ibm.com>
	 <1369722552.5857.72.camel@marge.simpson.net>
	 <51A45B23.4050403@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:/Oye76xcYKHSZgbYSC6/jxoig412+T+7p1Y20EEOD6b
 c/38riB/27jXsmsc1YKEJL6Pr5OBYlw97Hpha+qL689QXw3lKS
 VFSHAiy1fHAheYMqNKseMpx7GsnA9YdQBoOoZLuZ8GKQov+Wm2
 Wj9xR3Ic9gOIlMQ1/nOTLqchKcSii2mIMuxIsGZ0S6KwdOy9Mt
 aFhoSPcHm7n03X5P81UKftLG9dDmZXWPbo/7r35N5Pb/chHsVt
 tLoHi0k9qiapb9RYNKoGNNfsYZyMXO1/g9HZ2vlCatgCTGay9O
 OgMU9pWjj97swCEaeIJVX7i2H34KDWi/tzJx7+jZBIpJLI80Cl
 Et4x4gjj5rQY7LfMpXkLsyxNRVqJI1GSUp4xu4xHGkotraMATC
 jfYFscdclMxBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-28 at 15:22 +0800, Michael Wang wrote: 
> On 05/28/2013 02:29 PM, Mike Galbraith wrote:
> > On Tue, 2013-05-28 at 13:02 +0800, Michael Wang wrote: 
> >> On 05/22/2013 10:55 PM, Mike Galbraith wrote:
> >>> On Wed, 2013-05-22 at 17:25 +0800, Michael Wang wrote:
> >>>
> >>>> I've not test the hackbench with wakeup-buddy before, will do it this
> >>>> time, I suppose the 15% illegal income will suffered, anyway, it's
> >>>> illegal :)
> >>>
> >>> On a 4 socket 40 core (+SMT) box, hackbench wasn't too happy.
> >>
> >> I've done more test and now I got the reason of regression...
> >>
> >> The writer and reader in hackbench is N:N, prev writer will write all
> >> the fd then switch to next writer and repeat the same work, so it's
> >> impossible to setup the buddy relationship by just record the last one,
> >> and we have to record all the waker/wakee in history, but that means
> >> unacceptable memory overhead...
> > 
> > Yeah, that's why I was thinking we'd need a dinky/fast as hell FIFO of
> > tokens or such to bind waker/wakee more or less reliably.  Making such a
> > scheme cheap enough could be hard.
> > 
> >> So this buddy idea seems to be bad...
> >>
> >> I think a better way may should be allowing pull in most time, but
> >> filter the very bad cases carefully.
> > 
> > Any way that is cheap, and fairly accurately recognizes when we're being
> > stupid will help.  First and foremost, it has to be dirt cheap :)
> > 
> >> For workload like pgbench, we actually just need to avoid pull if that
> >> will damage the 'mother' thread, which is busy and be relied by many
> >> 'child'.
> > 
> > Yeah, 'mom' is the key player.  If we can cheaply recognize mom, that
> > should get us a generic improvement.  Not as good as being able to
> > recognize the size of her+brood as size changes, but better anyway.
> 
> That's right, I'm trying to rely on the frequency of a task switching
> it's wakee in the new idea, it's really cheap and somewhat reliable, I
> appreciate if you could pay an eye on the new patch and let me know you
> opinion :)

I'll feed it to my 40 core box, hopefully soon.

-Mike

