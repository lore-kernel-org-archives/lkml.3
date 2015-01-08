Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971AbbAHEeQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 23:34:16 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57688 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839AbbAHEeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 23:34:14 -0500
Date: Wed, 7 Jan 2015 20:33:29 -0800
From: Calvin Owens <calvinowens@fb.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Peter Zijlstra <peterz@infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        <calvinowens@fb.com>
Subject: Re: [PATCH v2] ksoftirqd: Enable IRQs and call cond_resched() before
 poking RCU
Message-ID: <20150108043329.GB27996@mail.thefacebook.com>
References: <1420594659-16996-1-git-send-email-calvinowens@fb.com>
 <20150107014906.GA27996@mail.thefacebook.com>
 <20150107021926.GT5280@linux.vnet.ibm.com>
 <20150107165223.GA21555@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20150107165223.GA21555@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-08_02:2015-01-07,2015-01-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=3.45033029023803
 compositescore=0.928708196901072 urlsuspect_oldscore=0.928708196901072
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.928708196901072 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501080043
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01/07 at 08:52 -0800, Paul E. McKenney wrote:
> On Tue, Jan 06, 2015 at 06:19:26PM -0800, Paul E. McKenney wrote:
> > On Tue, Jan 06, 2015 at 05:49:06PM -0800, Calvin Owens wrote:
> > > While debugging an issue with excessive softirq usage, I encountered the
> > > following note in commit 3e339b5dae24a706 ("softirq: Use hotplug thread
> > > infrastructure"):
> > > 
> > >     [ paulmck: Call rcu_note_context_switch() with interrupts enabled. ]
> > > 
> > > ...but despite this note, the patch still calls RCU with IRQs disabled.
> > > 
> > > This seemingly innocuous change caused a significant regression in softirq
> > > CPU usage on the sending side of a large TCP transfer (~1 GB/s): when
> > > introducing 0.01% packet loss, the softirq usage would jump to around 25%,
> > > spiking as high as 50%. Before the change, the usage would never exceed 5%.
> > > 
> > > Moving the call to rcu_note_context_switch() after the cond_sched() call,
> > > as it was originally before the hotplug patch, completely eliminated this
> > > problem.
> > > 
> > > Signed-off-by: Calvin Owens <calvinowens@fb.com>
> > > ---
> > > Changes since v1:
> > > 	I mixed up the kernel versions I was patching against, sorry!
> > > 
> > >  kernel/softirq.c | 6 +++++-
> > >  1 file changed, 5 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/softirq.c b/kernel/softirq.c
> > > index 501baa9..9e787d8 100644
> > > --- a/kernel/softirq.c
> > > +++ b/kernel/softirq.c
> > > @@ -656,9 +656,13 @@ static void run_ksoftirqd(unsigned int cpu)
> > >  		 * in the task stack here.
> > >  		 */
> > >  		__do_softirq();
> > > -		rcu_note_context_switch();
> > >  		local_irq_enable();
> > >  		cond_resched();
> > 
> > If this is for 3.20, we can just replace cond_resched() with
> > cond_resched_rcu_qs(), and get rid of the direct call to
> > rcu_note_context_switch().  This has the benefit of avoiding
> > needless rcu_note_context_switch() overhead if cond_resched()
> > actually did a reschedule.
> > 
> > But don't try it in 3.19 or earlier.  ;-)
> 
> As in the following for 3.20.  Does this version work for you?

That's great, thanks :)

Should this go to stable as well? It is technically a regression, albeit
a rather long-standing one.

My original scenario was a bit contrived, but I tested this on some real
loads and it makes a difference: on a heavily loaded Proxygen server,
the aggregate softirq CPU usage decreases by roughly 10% (relative)
given the same amount of traffic with the patch. It also produces
statistically significant performance wins at higher loads on
webservers: about a 1% reduction in overall CPU utilization and improved
latency metrics.

Thanks,
Calvin
 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
> ksoftirqd: Enable IRQs and call cond_resched() before poking RCU
> 
> While debugging an issue with excessive softirq usage, I encountered the
> following note in commit 3e339b5dae24a706 ("softirq: Use hotplug thread
> infrastructure"):
>     
>         [ paulmck: Call rcu_note_context_switch() with interrupts enabled. ]
>     
> ...but despite this note, the patch still calls RCU with IRQs disabled.
> 
> This seemingly innocuous change caused a significant regression in softirq
> CPU usage on the sending side of a large TCP transfer (~1 GB/s): when
> introducing 0.01% packet loss, the softirq usage would jump to around 25%,
> spiking as high as 50%. Before the change, the usage would never exceed 5%.
> 
> Moving the call to rcu_note_context_switch() after the cond_sched() call,
> as it was originally before the hotplug patch, completely eliminated this
> problem, but the new cond_resched_rcu_qs() provides shorter code and
> avoids double RCU notification in the case where cond_resched() really
> did a context switch.
> 
> Signed-off-by: Calvin Owens <calvinowens@fb.com>
> [ paulmck: Substituted shiny new cond_resched_rcu_qs() primitive. ]
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 501baa9ac1be..8cdb98847c7b 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -656,9 +656,8 @@ static void run_ksoftirqd(unsigned int cpu)
>  		 * in the task stack here.
>  		 */
>  		__do_softirq();
> -		rcu_note_context_switch();
>  		local_irq_enable();
> -		cond_resched();
> +		cond_resched_rcu_qs();
>  		return;
>  	}
>  	local_irq_enable();
> 
