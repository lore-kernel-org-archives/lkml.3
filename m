Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab3KALjt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 07:39:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15507 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755894Ab3KALjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 07:39:47 -0400
Message-ID: <527392E9.6080005@redhat.com>
Date: Fri, 01 Nov 2013 07:39:21 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Rik van Riel <riel@redhat.com>, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] fix race between stop_two_cpus and stop_cpus
References: <20131031163144.0fd27457@annuminas.surriel.com> <20131101110825.GX2400@suse.de>
In-Reply-To: <20131101110825.GX2400@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 11/01/2013 07:08 AM, Mel Gorman wrote:
> On Thu, Oct 31, 2013 at 04:31:44PM -0400, Rik van Riel wrote:
>> There is a race between stop_two_cpus, and the global stop_cpus.
>>
> 
> What was the trigger for this? I want to see what was missing from my own
> testing. I'm going to go out on a limb and guess that CPU hotplug was also
> running in the background to specifically stress this sort of rare condition.
> Something like running a standard test with the monitors/watch-cpuoffline.sh
> from mmtests running in parallel.
> 

I have a test that loads and unloads each module in /lib/modules/3.*/...

Each run typically takes a few minutes.  After running 4-5 times, the system
issues a soft lockup warning with a CPU in multi_cpu_stop().  Unfortunately,
kdump isn't working on this particular system (due to another bug) so I modified
the code with (sorry for the cut-and-paste):

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 05039e3..4a8c9f9 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -323,8 +323,10 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtime
                else
                        dump_stack();

-               if (softlockup_panic)
+               if (softlockup_panic) {
+                       show_state();
                        panic("softlockup: hung tasks");
+               }
                __this_cpu_write(soft_watchdog_warn, true);
        } else
                __this_cpu_write(soft_watchdog_warn, false);

and then 'echo 1 > /proc/sys/kernel/softlockup_panic' to get a full trace of all
tasks.

When I did this and ran the kernel module load unload test ...

[prarit@prarit tmp]$ cat /tmp/intel.log | grep RIP
[  678.081168] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.156180] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.230190] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.244186] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.259194] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.274192] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.288195] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.303197] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.318200] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.333203] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.349206] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.364208] RIP: 0010:[<ffffffff810d328b>]  [<ffffffff810d328b>]
multi_cpu_stop+0x7b/0xf0
[  678.379211] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.394212] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.409215] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.424217] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.438219] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.452221] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.466228] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.481228] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.496230] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.511234] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.526236] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.541238] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.556244] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.571243] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.586247] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0
[  678.601248] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.616251] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  678.632254] RIP: 0010:[<ffffffff810d328b>]  [<ffffffff810d328b>]
multi_cpu_stop+0x7b/0xf0
[  678.647257] RIP: 0010:[<ffffffff810d3292>]  [<ffffffff810d3292>]
multi_cpu_stop+0x82/0xf0
[  687.570464] RIP: 0010:[<ffffffff810d3296>]  [<ffffffff810d3296>]
multi_cpu_stop+0x86/0xf0

and,

[prarit@prarit tmp]$ cat /tmp/intel.log | grep RIP | wc -l
32

which shows all 32 cpus are "correctly" in the cpu stop threads.  After some
investigation, Rik came up with his patch.

Hope this explains things,

P.
