Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaLSUcQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 15:32:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1069 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751488AbaLSUcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 15:32:15 -0500
Date: Fri, 19 Dec 2014 15:31:36 -0500
From: Chris Mason <clm@fb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Dave Jones <davej@redhat.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141219203135.GA1200@ret.masoncoding.com>
Mail-Followup-To: Chris Mason <clm@fb.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dave Jones <davej@redhat.com>,
	Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
	Peter Anvin <hpa@linux.intel.com>
References: <20141218051327.GA31988@redhat.com>
 <1418918059.17358.6@mail.thefacebook.com>
 <20141218161230.GA6042@redhat.com>
 <20141219024549.GB1671@redhat.com>
 <CA+55aFw7R+P+2xgXwUqG5uxNs=dLD59fL+6uHuhWHFtsAb1nSg@mail.gmail.com>
 <20141219035859.GA20022@redhat.com>
 <20141219040308.GB20022@redhat.com>
 <CA+55aFzg0WN1_SzRagwwEDGUkKou4t+-gBNMUd-W3KM7tC+-AA@mail.gmail.com>
 <20141219145528.GC13404@redhat.com>
 <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-19_05:2014-12-19,2014-12-19,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=172.485279719936
 compositescore=0.12498974524102 urlsuspect_oldscore=0.12498974524102
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=2524143
 rbsscore=0.12498974524102 spamscore=0
 recipient_to_sender_domain_totalscore=8 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412190200
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 11:15:21AM -0800, Linus Torvalds wrote:
> Here's another pattern. In your latest thing, every single time that
> CPU1 is waiting for some other CPU to pick up the IPI, we have CPU0
> doing this:
> 
> [24998.060963] NMI backtrace for cpu 0
> [24998.061989] CPU: 0 PID: 2940 Comm: trinity-c150 Not tainted 3.18.0+ #108
> [24998.064073] task: ffff8801bf3536b0 ti: ffff880197e0c000 task.ti:
> ffff880197e0c000
> [24998.065137] RIP: 0010:[<ffffffff8103e006>]  [<ffffffff8103e006>]
> read_hpet+0x16/0x20
> [24998.083577]  [<ffffffff810e0d3e>] ktime_get+0x3e/0xa0
> [24998.084450]  [<ffffffff810e9cd3>] tick_sched_timer+0x23/0x160
> [24998.085315]  [<ffffffff810daf96>] __run_hrtimer+0x76/0x1f0
> [24998.086173]  [<ffffffff810e9cb0>] ? tick_init_highres+0x20/0x20
> [24998.087025]  [<ffffffff810db2e7>] hrtimer_interrupt+0x107/0x260
> [24998.087877]  [<ffffffff81031a4b>] local_apic_timer_interrupt+0x3b/0x70
> [24998.088732]  [<ffffffff8179bca5>] smp_apic_timer_interrupt+0x45/0x60
> [24998.089583]  [<ffffffff8179a0df>] apic_timer_interrupt+0x6f/0x80
> [24998.090435]  <EOI>
> [24998.091279]  [<ffffffff810da66e>] ? __remove_hrtimer+0x4e/0xa0
> [24998.092118]  [<ffffffff812c7c7a>] ? ipcget+0x8a/0x1e0
> [24998.092951]  [<ffffffff812c7c6c>] ? ipcget+0x7c/0x1e0
> [24998.093779]  [<ffffffff812c8d6d>] SyS_msgget+0x4d/0x70
> 
> and I think that's the smoking gun. The reason CPU0 isn't picking up
> any IPI's is because it is in some endless loop around read_hpet().
> 
> There is even time information in the register dump:
> 
>  RAX: 0000000061fece8a RBX: 0000000000510792 RCX: 0000000000000000
>  RAX: 0000000079e588fc RBX: 0000000000511d6e RCX: 0000000000000000
>  RAX: 0000000091ca7f65 RBX: 0000000000513346 RCX: 0000000000000000
>  RAX: 00000000a9afbd0d RBX: 000000000051491e RCX: 0000000000000000
>  RAX: 00000000cbd1340c RBX: 000000000051684a RCX: 0000000000000000
>  RAX: 00000000fb9d303f RBX: 00000000005193fc RCX: 0000000000000000
>  RAX: 000000002b67efe4 RBX: 000000000051c224 RCX: 0000000000000004
> 
> That RAX value is the value we just read from the HPET, and RBX seems
> to be monotonically increasing too, so it's likely the sequence
> counter in ktime_get().
> 
> So it's not stuck *inside* read_hpet(), and it's almost certainly not
> the loop over the sequence counter in ktime_get() either (it's not
> increasing *that* quickly). But some basically infinite __run_hrtimer
> thing or something?

Really interesting.

So, we're calling __run_hrtimer in a loop:

                while ((node = timerqueue_getnext(&base->active))) {
				...
				__run_hrtimer(timer, &basenow);
				...
		}

The easy question is how often does trinity call nanosleep?

Looking at __run_hrtimer(), it drops the lock and runs the function and then
takes the lock again, maybe enqueueing us again right away.

timer->state is supposed to protect us from other CPUs jumping in and doing
something else with the timer, but it feels racey wrt remove_hrtimer().
Something like this, but I'm not sure how often __hrtimer_start_range_ns gets
called

CPU 0						CPU 1
__run_hrtimer()
    timer->state = HRTIMER_STATE_CALLBACK
    removed from list
    unlock cpu_base->lock
    restrt = fn(timer)
    						__hrtimer_start_range_ns()
						base = lock_hrtimer_base()
						ret = remove_hrtimer()
						    finds timer->state = HRTIMER_STATE_CALLBACK
						    does nothing
						new_base = switch_hrtimer_base()
						    now we're on a different base, different lock
    lock(cpu_base->lock)
    enqueue the timer
    						enqueue the timer
