Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab3F0BH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:07:29 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58791 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3F0BHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:07:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
References: <20130622013731.GA22918@redhat.com>
	<20130622173129.GA29375@redhat.com>
	<20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com>
	<20130623150603.GA32313@redhat.com>
	<20130623160452.GA11740@redhat.com> <20130624155758.GA5993@redhat.com>
	<20130624173510.GA1321@redhat.com> <20130625153520.GA7784@redhat.com>
	<20130626191853.GA29049@redhat.com>
	<20130627002255.GA16553@redhat.com>
Date: Wed, 26 Jun 2013 18:06:45 -0700
In-Reply-To: <20130627002255.GA16553@redhat.com> (Dave Jones's message of
	"Wed, 26 Jun 2013 20:22:55 -0400")
Message-ID: <87ppv82wgq.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/VdPVzIE8/0mRRqwWovS2dSaCgHENCayo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3199]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Dave Jones <davej@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: frequent softlockups with 3.10rc6.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> On Wed, Jun 26, 2013 at 09:18:53PM +0200, Oleg Nesterov wrote:
>  > On 06/25, Dave Jones wrote:
>  > >
>  > > Took a lot longer to trigger this time. (13 hours of runtime).
>  > 
>  > And _perhaps_ this means that 3.10-rc7 without 8aac6270 needs more
>  > time to hit the same bug ;)
>
> Ok, that didn't take long. 4 hours in, and I hit it on rc7 with 8aac6270 reverted.
> So that's the 2nd commit I've mistakenly blamed for this bug.
>
> Crap. I'm going to have to redo the bisecting, and give it a whole day
> at each step to be sure. That's going to take a while.
>
> Anyone got any ideas better than a week of non-stop bisecting ?

Just based on the last trace and your observation that it seems to be
vfs/block layer related I am going to mildly suggest that Jens and Tejun
might have a clue.  Tejun made a transformation of the threads used for
writeback from a custom thread pool to the generic mechanism.  So it
seems worth asking the question could it have been in Jens block merge
of 4de13d7aa8f4d02f4dc99d4609575659f92b3c5a.

Eric

> What I've gathered so far:
>
> - Only affects two machines I have (both Intel Quad core Haswell, one with SSD, one with hybrid SSD)
> - One machine is XFS, the other EXT4.
> - When the lockup occurs, it happens on all cores.
> - It's nearly always a sync() call that triggers it looking like this..
>
>   irq event stamp: 8465043
>   hardirqs last  enabled at (8465042): [<ffffffff816ebc60>] restore_args+0x0/0x30
>   hardirqs last disabled at (8465043): [<ffffffff816f476a>] apic_timer_interrupt+0x6a/0x80
>   softirqs last  enabled at (8464292): [<ffffffff81054204>] __do_softirq+0x194/0x440
>   softirqs last disabled at (8464295): [<ffffffff8105466d>] irq_exit+0xcd/0xe0
>   RIP: 0010:[<ffffffff81054121>]  [<ffffffff81054121>] __do_softirq+0xb1/0x440
>
>   Call Trace:
>    <IRQ> 
>    [<ffffffff8105466d>] irq_exit+0xcd/0xe0
>    [<ffffffff816f560b>] smp_apic_timer_interrupt+0x6b/0x9b
>    [<ffffffff816f476f>] apic_timer_interrupt+0x6f/0x80
>    <EOI> 
>    [<ffffffff816ebc60>] ? retint_restore_args+0xe/0xe
>    [<ffffffff810b9c56>] ? lock_acquire+0xa6/0x1f0
>    [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
>    [<ffffffff816eaba0>] _raw_spin_lock+0x40/0x80
>    [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
>    [<ffffffff811da892>] sync_inodes_sb+0x1c2/0x2a0
>    [<ffffffff816e8206>] ? wait_for_completion+0x36/0x110
>    [<ffffffff811e04f0>] ? generic_write_sync+0x70/0x70
>    [<ffffffff811e0509>] sync_inodes_one_sb+0x19/0x20
>    [<ffffffff811b0e62>] iterate_supers+0xb2/0x110
>    [<ffffffff811e0775>] sys_sync+0x35/0x90
>    [<ffffffff816f3d14>] tracesys+0xdd/0xe2
>
>
> I'll work on trying to narrow down what trinity is doing. That might at least
> make it easier to reproduce it in a shorter timeframe.


