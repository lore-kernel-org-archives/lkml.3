Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbbAUUhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 15:37:47 -0500
Received: from hygieia.santi-shop.eu ([78.46.175.2]:59469 "EHLO
	hygieia.santi-shop.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbbAUUhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 15:37:41 -0500
Date: Wed, 21 Jan 2015 21:37:33 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.19-rc5
Message-ID: <20150121213733.7522f087@neptune.home>
In-Reply-To: <CA+55aFw7aoShsqS_ro5DASbseXFLQs_sE=dwLp_tTNAvD9Y09w@mail.gmail.com>
References: <CA+55aFxNk9OCXz7nvKXpRBc0Z85NLXPNkRm1yJf4-KAGB4pHRA@mail.gmail.com>
	<20150119190216.7ce58d74@neptune.home>
	<CA+55aFw7aoShsqS_ro5DASbseXFLQs_sE=dwLp_tTNAvD9Y09w@mail.gmail.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 January 2015 Linus Torvalds wrote:
> On Tue, Jan 20, 2015 at 6:02 AM, Bruno Prémont wrote:
> >
> > No idea yet which rc is the offender (nor exact patch), but on my not
> > so recent UP laptop with a pccard slot I have 2 pccardd kernel threads
> > converting my laptop into a heater.
> >
> > lspci for affected nodes:
> > 02:06.0 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
> > 02:06.1 CardBus bridge [0607]: O2 Micro, Inc. OZ711EC1 SmartCardBus Controller [1217:7113] (rev 20)
> >
> > Very basics I have, before I attempt any bisection:
> 
> Hmm. I'm not seeing anything recent changing anything in this area, so
> I suspect that unless somebody else steps up and says "Ahh, that
> sounds like xyz", your bisection is the best option.

I've done most of the bisection and ended up in the scheduler changes.
CCing Peter.

A few iterations from the end kernel is warning about (might?)sleeping during
locking or so (scrolling too fast to read end making access to console
hard).

My current bisection log is:
git bisect start
# bad: [117af36e3bceb4fceb1c63489d6f3d94ed259a4c] Apple-GMUX: inhibit VGA arbitration changes
git bisect bad 117af36e3bceb4fceb1c63489d6f3d94ed259a4c
# good: [b2776bf7149bddd1f4161f14f79520f17fc1d71d] Linux 3.18
git bisect good b2776bf7149bddd1f4161f14f79520f17fc1d71d
# bad: [c0222ac086669a631814bbf857f8c8023452a4d7] Merge branch 'upstream' of git://git.linux-mips.org/pub/scm/ralf/upstream-linus
git bisect bad c0222ac086669a631814bbf857f8c8023452a4d7
# bad: [2183a58803c2bbd87c2d0057eed6779ec4718d4d] Merge tag 'media/v3.19-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-media
git bisect bad 2183a58803c2bbd87c2d0057eed6779ec4718d4d
# good: [6da314122ddc11936c6f054753bbb956a499d020] Merge tag 'dt-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
git bisect good 6da314122ddc11936c6f054753bbb956a499d020
# bad: [cbfe0de303a55ed96d8831c2d5f56f8131cd6612] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad cbfe0de303a55ed96d8831c2d5f56f8131cd6612
# bad: [9e66645d72d3c395da92b0f8855c787f4b5f0e89] Merge branch 'irq-irqdomain-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad 9e66645d72d3c395da92b0f8855c787f4b5f0e89
# good: [5706ffd045c3810912c4982357d7daa721af3464] Merge branch 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 5706ffd045c3810912c4982357d7daa721af3464
# bad: [a157508c9790ccd1c8b5c6a828d6ba85bbe95aaa] Merge branch 'timers-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect bad a157508c9790ccd1c8b5c6a828d6ba85bbe95aaa
# bad: [acb32132ec0433c03bed750f3e9508dc29db0328] sched/deadline: Add deadline rq status print
git bisect bad acb32132ec0433c03bed750f3e9508dc29db0328
# good: [1029a2b52c09e479fd7b07275812ad97868c0fb0] sched, exit: Deal with nested sleeps
git bisect good 1029a2b52c09e479fd7b07275812ad97868c0fb0


That means, the remaining commits would be:
 commit acb32132ec0433c03bed750f3e9508dc29db0328
 Author: Wanpeng Li <wanpeng.li@linux.intel.com>
 Date:   Fri Oct 31 06:39:33 2014 +0800

     sched/deadline: Add deadline rq status print

 ...

 commit e23738a7300a7591a57a22f47b813fd1b53ec404
 Author: Peter Zijlstra <peterz@infradead.org>
 Date:   Wed Sep 24 10:18:50 2014 +0200

     sched, inotify: Deal with nested sleeps


It looks like pccardd might be doing the wrong thing for
locking/sleeping/waiting.


Trying to complete bisection.

Bruno
