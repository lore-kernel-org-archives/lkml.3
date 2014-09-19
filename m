Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955AbaISEcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 00:32:13 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41539 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaISEcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 00:32:11 -0400
Date: Thu, 18 Sep 2014 21:32:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "open list:READ-COPY UPDATE..." <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] rcu: Add early boot self tests
Message-ID: <20140919043206.GW4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1411010509-31927-1-git-send-email-bobby.prani@gmail.com>
 <1411010509-31927-3-git-send-email-bobby.prani@gmail.com>
 <20140918212955.GA6941@linux.vnet.ibm.com>
 <CAJhHMCCe43QYjGo8gA-GHhj-DMbGbNcUajCwWVDx-woLpqixhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJhHMCCe43QYjGo8gA-GHhj-DMbGbNcUajCwWVDx-woLpqixhA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091904-1344-0000-0000-00000451A8BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 09:03:43PM -0400, Pranith Kumar wrote:
> On Thu, Sep 18, 2014 at 5:29 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> 
> >> +static int rcu_self_test_counter;
> >> +static struct rcu_head head;
> >
> > This needs to be within the individual functions, because otherwise the
> > lists get messed up when you to multiple tests during the same boot...
> 
> Hmm, I thought this was OK since we are not using this head anywhere.
> What lists are getting messed up?

The problem is that the current code enqueues the same structure onto
up to four different lists, and we don't have a quantum computer, so
head.next can't point to four different places.  ;-)

Making head be static in all four functions allows four different
head.next pointer to point to the four different places, as required.

> In any case, I will update this as you suggested.

Very good!

> >> +DEFINE_STATIC_SRCU(srcu_struct);
> >> +
> >> +static void test_callback(struct rcu_head *r)
> >> +{
> >> +     rcu_self_test_counter++;
> >> +     pr_info("RCU test callback executed %d\n", rcu_self_test_counter);
> >> +}
> >> +
> >> +static void early_boot_test_call_rcu(void)
> >> +{
> >
> > ... as in:
> >
> >         static struct rcu_head head;
> >
> >> +     call_rcu(&head, test_callback);
> >> +}
> >> +
> >> +static void early_boot_test_call_rcu_bh(void)
> >> +{
> >> +     call_rcu_bh(&head, test_callback);
> >> +}
> >> +
> >> +static void early_boot_test_call_rcu_sched(void)
> >> +{
> >> +     call_rcu_sched(&head, test_callback);
> >> +}
> >> +
> >> +static void early_boot_test_call_srcu(void)
> >> +{
> >> +     call_srcu(&srcu_struct, &head, test_callback);
> >
> > This looked like a great idea at first, but unfortunately call_srcu()
> > invokes queue_delayed_work(), which breaks horribly this early in boot.
> > Either this test has to be removed, or call_srcu() has to be updated
> > to handle early-boot invocation.  Given that no one is using call_srcu()
> > during early boot, it is probably best to just drop the test.
> >
> > (In case you were wondering, TEST06 dies during boot.)
> >
> > Could you please send an updated patch?
> 
> 
> Yup, will do. Please see one question below:
> 
> <...>
> >> +static int rcu_verify_early_boot_tests(void)
> >> +{
> >> +     int ret = 0;
> >> +     int early_boot_test_counter = 0;
> >> +
> >> +     if (rcu_self_test) {
> >> +             early_boot_test_counter++;
> >> +             rcu_barrier();
> >> +     }
> >> +     if (rcu_self_test_bh) {
> >> +             early_boot_test_counter++;
> >> +             rcu_barrier_bh();
> >> +     }
> >> +     if (rcu_self_test_sched) {
> >> +             early_boot_test_counter++;
> >> +             rcu_barrier_sched();
> >> +     }
> >> +     if (rcu_self_test_srcu) {
> >> +             early_boot_test_counter++;
> >> +             srcu_barrier(&srcu_struct);
> >> +     }
> >> +
> >> +     if (rcu_self_test_counter != early_boot_test_counter)
> >> +             ret = -1;
> 
> 
> So this basically does nothing when it does not match. All we see is
> the return value when we pass initcall_debug. Should I add a WARN_ON()
> or some such so that it is more explicit?

Please do!

								Thanx, Paul

> >> +
> >> +     return ret;
> >> +}
> >> +late_initcall(rcu_verify_early_boot_tests);
> >> +#else
> >> +void rcu_early_boot_tests(void) {}
> >> +#endif /* CONFIG_PROVE_RCU */
> >> --
> >> 2.1.0
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> 
> 
> -- 
> Pranith
> 

