Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3F0AXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:23:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849Ab3F0AXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:23:12 -0400
Date: Wed, 26 Jun 2013 20:22:55 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130627002255.GA16553@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626191853.GA29049@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:18:53PM +0200, Oleg Nesterov wrote:
 > On 06/25, Dave Jones wrote:
 > >
 > > Took a lot longer to trigger this time. (13 hours of runtime).
 > 
 > And _perhaps_ this means that 3.10-rc7 without 8aac6270 needs more
 > time to hit the same bug ;)

Ok, that didn't take long. 4 hours in, and I hit it on rc7 with 8aac6270 reverted.
So that's the 2nd commit I've mistakenly blamed for this bug.

Crap. I'm going to have to redo the bisecting, and give it a whole day
at each step to be sure. That's going to take a while.

Anyone got any ideas better than a week of non-stop bisecting ?

What I've gathered so far:

- Only affects two machines I have (both Intel Quad core Haswell, one with SSD, one with hybrid SSD)
- One machine is XFS, the other EXT4.
- When the lockup occurs, it happens on all cores.
- It's nearly always a sync() call that triggers it looking like this..

  irq event stamp: 8465043
  hardirqs last  enabled at (8465042): [<ffffffff816ebc60>] restore_args+0x0/0x30
  hardirqs last disabled at (8465043): [<ffffffff816f476a>] apic_timer_interrupt+0x6a/0x80
  softirqs last  enabled at (8464292): [<ffffffff81054204>] __do_softirq+0x194/0x440
  softirqs last disabled at (8464295): [<ffffffff8105466d>] irq_exit+0xcd/0xe0
  RIP: 0010:[<ffffffff81054121>]  [<ffffffff81054121>] __do_softirq+0xb1/0x440

  Call Trace:
   <IRQ> 
   [<ffffffff8105466d>] irq_exit+0xcd/0xe0
   [<ffffffff816f560b>] smp_apic_timer_interrupt+0x6b/0x9b
   [<ffffffff816f476f>] apic_timer_interrupt+0x6f/0x80
   <EOI> 
   [<ffffffff816ebc60>] ? retint_restore_args+0xe/0xe
   [<ffffffff810b9c56>] ? lock_acquire+0xa6/0x1f0
   [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
   [<ffffffff816eaba0>] _raw_spin_lock+0x40/0x80
   [<ffffffff811da892>] ? sync_inodes_sb+0x1c2/0x2a0
   [<ffffffff811da892>] sync_inodes_sb+0x1c2/0x2a0
   [<ffffffff816e8206>] ? wait_for_completion+0x36/0x110
   [<ffffffff811e04f0>] ? generic_write_sync+0x70/0x70
   [<ffffffff811e0509>] sync_inodes_one_sb+0x19/0x20
   [<ffffffff811b0e62>] iterate_supers+0xb2/0x110
   [<ffffffff811e0775>] sys_sync+0x35/0x90
   [<ffffffff816f3d14>] tracesys+0xdd/0xe2


I'll work on trying to narrow down what trinity is doing. That might at least
make it easier to reproduce it in a shorter timeframe.

	Dave

