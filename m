Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab3EMOvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:51:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21428 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3EMOvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:51:54 -0400
Message-ID: <5190FE00.6010508@redhat.com>
Date: Mon, 13 May 2013 10:51:44 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        bitbucket@online.de, tglx@linutronix.de, prarit@redhat.com
CC: tip-bot for Thomas Gleixner <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/urgent] tick: Cleanup NOHZ per cpu data on cpu down
References: <alpine.LFD.2.02.1305031451561.2886@ionos> <tip-4b0c0f294f60abcdd20994a8341a95c8ac5eeb96@git.kernel.org>
In-Reply-To: <tip-4b0c0f294f60abcdd20994a8341a95c8ac5eeb96@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/12/2013 06:27 AM, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  4b0c0f294f60abcdd20994a8341a95c8ac5eeb96
> Gitweb:     http://git.kernel.org/tip/4b0c0f294f60abcdd20994a8341a95c8ac5eeb96
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Fri, 3 May 2013 15:02:50 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Sun, 12 May 2013 12:20:09 +0200
> 
> tick: Cleanup NOHZ per cpu data on cpu down
> 
> Prarit reported a crash on CPU offline/online. The reason is that on
> CPU down the NOHZ related per cpu data of the dead cpu is not cleaned
> up. If at cpu online an interrupt happens before the per cpu tick
> device is registered the irq_enter() check potentially sees stale data
> and dereferences a NULL pointer.
> 
> Cleanup the data after the cpu is dead.

Thomas, while this does fix up the NULL pointer issue, I think you've introduced
a new bug in the schedule timer code.

While doing up and downs on the same CPU, I now occasionally see long delays in
the up and down...

[   65.150073] smpboot: Booting Node 1 Processor 19 APIC 0x28
[   66.715339] smpboot: CPU 19 is now offline
[   67.752751] smpboot: Booting Node 1 Processor 19 APIC 0x28
[   68.758711] smpboot: CPU 19 is now offline

Everything is normal ...

[   69.711612] smpboot: Booting Node 1 Processor 19 APIC 0x28
[   70.731521] smpboot: CPU 19 is now offline

Long delay in bringing CPU "down"

[   81.744565] smpboot: Booting Node 1 Processor 19 APIC 0x28
[   82.848591] smpboot: CPU 19 is now offline

Long delay in bringing CPU "up"

[   89.826533] smpboot: Booting Node 1 Processor 19 APIC 0x28
[   84.905358] smpboot: CPU 19 is now offline
[   87.565274] smpboot: Booting Node 1 Processor 19 APIC 0x28

Also, if the system is in this state I cannot reboot -- the system appears to
hang while bringing down CPUs...

Oddly, if I do

+       memset(ts, 0, sizeof(*ts));
+       ts->tick_stopped = 1;

instead of your memset, everything works.  I'm looking at the tick-sched.c code
to see why setting tick_stopped = 1 seems to fix the problem.

P.
