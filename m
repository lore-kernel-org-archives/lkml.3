Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932072AbaLDKvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:51:00 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:44591 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509AbaLDKu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:50:58 -0500
Date: Thu, 4 Dec 2014 10:51:03 +0000
From: Will Deacon <will.deacon@arm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Tejun Heo <tj@kernel.org>,
        Dave Jones <davej@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Don Zickus <dzickus@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141204105103.GD14519@arm.com>
References: <20141119145902.GA13387@redhat.com>
 <546D0530.8040800@mit.edu>
 <20141120152509.GA5412@redhat.com>
 <20141125122217.GA15280@arm.com>
 <20141201114854.GB18466@arm.com>
 <CA+55aFyhB5LBVadA5TfuX8+TrZZWTHwT-2NCYRLat8Fp6eBjgw@mail.gmail.com>
 <20141201171036.GH18466@arm.com>
 <CA+55aFwooh31=GMVUoriev+t92=roye_ck+czqr48M1sQ3UOMg@mail.gmail.com>
 <20141201182519.GA16749@node.dhcp.inet.fi>
 <CA+55aFz+ODi34J2n0kzXm+v++B7KW1e9NSFU=f-jgonPA1bNxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz+ODi34J2n0kzXm+v++B7KW1e9NSFU=f-jgonPA1bNxg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 01, 2014 at 06:36:04PM +0000, Linus Torvalds wrote:
> On Mon, Dec 1, 2014 at 10:25 AM, Kirill A. Shutemov
> <kirill@shutemov.name> wrote:
> >
> > No idea about oom_score, but kernel happily accepts chmod on any file
> > under /proc/PID/net/.
> 
> /proc used to accept that fairly widely, but no, we tightened things
> down, and core /proc files end up not accepting chmod. See
> 'proc_setattr()':
> 
>         if (attr->ia_valid & ATTR_MODE)
>                 return -EPERM;
> 
> although particular /proc files could choose to not use 'proc_setattr'
> if they want to.
> 
> The '/proc/pid/net' subtree is obviously not doing that. No idea why,
> and probably for no good reason.

I just hit another one of these, but it's slightly different this time:

  [child1:811] [2219] execve(name="/proc/610/attr/keycreate", argv=0x3a044bf0, envp=0x3a04c810)

this guy disappears off into the execve and never returns. A little later,
another guy gets stuck on a completion after a sync:

  [child0:856] [155] sync()

trinity-c0      D ffffffc000087570     0   856    612 0x00000000
Call trace:
[<ffffffc000087570>] __switch_to+0x74/0x8c
[<ffffffc0005350b4>] __schedule+0x204/0x670
[<ffffffc000535544>] schedule+0x24/0x74
[<ffffffc0005380a4>] schedule_timeout+0x134/0x18c
[<ffffffc000536204>] wait_for_common+0x9c/0x144
[<ffffffc0005362bc>] wait_for_completion+0x10/0x1c
[<ffffffc0001bbc14>] sync_inodes_sb+0x98/0x194
[<ffffffc0001c0244>] sync_inodes_one_sb+0x10/0x1c
[<ffffffc0001984c8>] iterate_supers+0x10c/0x114
[<ffffffc0001c04c0>] sys_sync+0x38/0xa4

The backtrace for 811 looks bogus to me (or we're missing some entries):

trinity-c1      R  running task        0   811    612 0x00000000
Call trace:
[<ffffffc000087570>] __switch_to+0x74/0x8c
[<ffffffc0000ecb48>] __handle_domain_irq+0x9c/0xf4
[<ffffffc000301da4>] __this_cpu_preempt_check+0x14/0x20
[<ffffffc000538a2c>] _raw_spin_lock_irq+0x18/0x58
[<ffffffc000538cb4>] _raw_spin_unlock_irq+0x1c/0x48
[<ffffffc0000fa6bc>] run_timer_softirq+0x68/0x240
[<ffffffc0000b5b2c>] __do_softirq+0x110/0x244
[<ffffffc000301d84>] debug_smp_processor_id+0x18/0x24

and, as before, it has a weird child process that I can't backtrace:

trinity-c1      R  running task        0   861    811 0x00000000
Call trace:

The RCU stall detector gets cross too, but the stall ends before it has
a chance to dump anything.

Will
