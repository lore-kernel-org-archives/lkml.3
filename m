Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbaLEFBH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 00:01:07 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16987 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaLEFBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 00:01:06 -0500
Message-ID: <54813C03.8040009@oracle.com>
Date: Fri, 05 Dec 2014 00:00:51 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?windows-1252?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141127225637.GA24019@redhat.com> <m5dart$co$1@ger.gmane.org> <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com> <547b8a45.6e608c0a.20f9.1002@mx.google.com> <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com> <547bbe36.48548c0a.105c.779c@mx.google.com> <20141201191431.GA17385@linux.vnet.ibm.com> <547ccf74.a5198c0a.25de.26d9@mx.google.com> <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com> <20141201230339.GA20487@ret.masoncoding.com> <20141202193252.GB17595@redhat.com> <547E4C14.6040509@oracle.com>
In-Reply-To: <547E4C14.6040509@oracle.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 06:32 PM, Sasha Levin wrote:
> On 12/02/2014 02:32 PM, Dave Jones wrote:
>> > On Mon, Dec 01, 2014 at 06:08:38PM -0500, Chris Mason wrote:
>> >  > I'm not sure if this is related, but running trinity here, I noticed it
>> >  > was stuck at 100% system time on every CPU.  perf report tells me we are
>> >  > spending all of our time in spin_lock under the sync system call.
>> >  > 
>> >  > I think it's coming from contention in the bdi_queue_work() call from
>> >  > inside sync_inodes_sb, which is spin_lock_bh(). 
>> >  > 
>> >  > I wonder if we're just spinning so hard on this one bh lock that we're
>> >  > starving the watchdog?
>> >  > 
>> >  > Dave, do you have spinlock debugging on?  
>> > 
>> > That has been a constant, yes. I can try with that disabled some time.
> Here's my side of the story: I was observing RCU lockups which went away when
> I disabled verbose printing for fault injections. It seems that printing one
> line ~10 times a second can cause that...

Just to add to this: I've enabled the simplest level of verbosity in the fault
injection options, and RCU stalls are again easy to trigger:

[ 3926.110026] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 3926.110026] INFO: rcu_sched detected stalls on CPUs/tasks:
[ 3926.110026]  0: (62 ticks this GP) idle=b63/140000000000002/0 softirq=20384/20384 last_accelerate: f772/8874, nonlazy_posted: 619783, ..
[ 3926.110026]  (detected by 2, t=30002 jiffies, g=-222, c=-223, q=0)
[ 3926.110026] Task dump for CPU 0:
[ 3926.110026] kworker/dying   R  running task    13464     7      2 0x00080008
[ 3926.110026]  ffffffff814db441 ffff88006aa3bd68 ffffffff814db441 ffffe8fff3c6c9d4
[ 3926.110026]  00000000ffffffff ffff88006aa3bd88 ffffffff814db76b ffffffff93a27440
[ 3926.110026]  dfffe90000000000 ffff88006aa26890 ffff88006aa26000 ffff88006aa3b5d8
[ 3926.110026] Call Trace:
[ 3926.110026]  [<ffffffff814db441>] ? get_parent_ip+0x11/0x50
[ 3926.110026]  [<ffffffff814db441>] ? get_parent_ip+0x11/0x50
[ 3926.110026]  [<ffffffff814db76b>] ? preempt_count_sub+0x11b/0x1d0
[ 3926.110026]  [<ffffffff81429c57>] ? do_exit+0x1687/0x3f20
[ 3926.110026]  [<ffffffff81485578>] ? worker_thread+0xa28/0x1760
[ 3926.110026]  [<ffffffff81484b50>] ? process_one_work+0x17a0/0x17a0
[ 3926.110026]  [<ffffffff8149d719>] ? kthread+0x229/0x320
[ 3926.110026]  [<ffffffff8149d4f0>] ? kthread_worker_fn+0x7d0/0x7d0
[ 3926.110026]  [<ffffffff91ffc0fc>] ? ret_from_fork+0x7c/0xb0
[ 3926.110026]  [<ffffffff8149d4f0>] ? kthread_worker_fn+0x7d0/0x7d0
[ 3926.110033]
[ 3926.110033]  0: (62 ticks this GP) idle=b63/140000000000002/0 softirq=20384/20384 last_accelerate: f772/8876, nonlazy_posted: 619783, ..
[ 3926.110033]  (detected by 10, t=30004 jiffies, g=15638, c=15637, q=63609)
[ 3926.110033] Task dump for CPU 0:
[ 3926.110033] kworker/dying   R  running task    13464     7      2 0x00080008
[ 3926.110033]  ffffffff814db441 ffff88006aa3bd68 ffffffff814db441 ffffe8fff3c6c9d4
[ 3926.110033]  00000000ffffffff ffff88006aa3bd88 ffffffff814db76b ffffffff93a27440
[ 3926.110033]  dfffe90000000000 ffff88006aa26890 ffff88006aa26000 ffff88006aa3b5d8
[ 3926.110033] Call Trace:
[ 3926.110033]  [<ffffffff814db441>] ? get_parent_ip+0x11/0x50
[ 3926.110033]  [<ffffffff814db441>] ? get_parent_ip+0x11/0x50
[ 3926.110033]  [<ffffffff814db76b>] ? preempt_count_sub+0x11b/0x1d0
[ 3926.110033]  [<ffffffff81429c57>] ? do_exit+0x1687/0x3f20
[ 3926.110033]  [<ffffffff81485578>] ? worker_thread+0xa28/0x1760
[ 3926.110033]  [<ffffffff81484b50>] ? process_one_work+0x17a0/0x17a0
[ 3926.110033]  [<ffffffff8149d719>] ? kthread+0x229/0x320
[ 3926.110033]  [<ffffffff8149d4f0>] ? kthread_worker_fn+0x7d0/0x7d0
[ 3926.110033]  [<ffffffff91ffc0fc>] ? ret_from_fork+0x7c/0xb0
[ 3926.110033]  [<ffffffff8149d4f0>] ? kthread_worker_fn+0x7d0/0x7d0


Thanks,
Sasha
