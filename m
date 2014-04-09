Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933372AbaDIP3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:29:53 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:42469 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932908AbaDIP3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:29:52 -0400
Date: Wed, 9 Apr 2014 11:29:50 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Matthew Whitehead <tedheadster@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        mwhitehe@redhat.com
Subject: Re: nohz problem with idle time on old hardware
Message-ID: <20140409112950.7be9f8ac@gandalf.local.home>
In-Reply-To: <CAKohponY+4y8G875wy4GsO1hTqERc7-hYKY6uQvLn28+32VxVQ@mail.gmail.com>
References: <20131113113927.GA13875@mwhitehe.csb>
	<alpine.DEB.2.02.1311131453500.30673@ionos.tec.linutronix.de>
	<20131113102153.5f10e6b5@gandalf.local.home>
	<20131113103134.5b8cf02f@gandalf.local.home>
	<20131113105737.3f7a0b1b@gandalf.local.home>
	<alpine.DEB.2.02.1311131706260.30673@ionos.tec.linutronix.de>
	<20131113111257.482c2955@gandalf.local.home>
	<20131113161829.GE4138@linux.vnet.ibm.com>
	<20131113112338.7d303c0f@gandalf.local.home>
	<20131113163552.GF4138@linux.vnet.ibm.com>
	<alpine.DEB.2.02.1311132052240.30673@ionos.tec.linutronix.de>
	<CAOh2x=koQ4tXdq5_Bi4Vbo_k1a=zosFA3e4zRJGjzysYmC-PEA@mail.gmail.com>
	<20140409103138.29be16b9@gandalf.local.home>
	<CAKohponY+4y8G875wy4GsO1hTqERc7-hYKY6uQvLn28+32VxVQ@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2014 20:50:59 +0530
Viresh Kumar <viresh.kumar@linaro.org> wrote:

> On 9 April 2014 20:01, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Ouch! You are correct, this part of the patch makes no sense. That's
> > what I get for reviewing a patch and not looking at all the code around
> > the changes. (another kernel developer hangs head in shame :-( )
> >
> > I think that if statement should be nuked.
> 
> Hmm, my opinion differs here :)
> 
> If we completely remove this statement, we will run
> tick_nohz_switch_to_nohz() even if nohz is not enabled. And check for
> enabled must stay.

Do we? This is only called by tick_check_oneshot_change() which has the
following:

int tick_check_oneshot_change(int allow_nohz)
{
	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);

	if (!test_and_clear_bit(0, &ts->check_clocks))
		return 0;

	if (ts->nohz_mode != NOHZ_MODE_INACTIVE)
		return 0;

	if (!timekeeping_valid_for_hres() || !tick_is_oneshot_available())
		return 0;

	if (!allow_nohz)
		return 1;

	tick_nohz_switch_to_nohz();
	return 0;
}

How often does it make it to that last check?

-- Steve
